#!/bin/bash
# Pilote le serveur Minecraft. Le serveur tourne dans une session tmux nommee "mc",
# ce qui permet de lui envoyer des commandes A CHAUD, sans jamais le redemarrer.
#
#   ./mc start            arrete Supabase, plafonne la RAM Docker (1 Go), demarre le cerveau IA (session tmux "ia") puis le serveur
#   ./mc stop             arrete proprement (sauvegarde le monde), RAM Docker par defaut ; cerveau IA laisse lance
#   ./mc restart
#   ./mc status           tourne ou pas, joueurs connectes, cerveau IA
#   ./mc console          ouvre la console live (Ctrl+B puis D pour sortir)
#   ./mc log              suit le journal
#   ./mc add <pseudo>     autorise un joueur (immediat, sans redemarrage)
#   ./mc remove <pseudo>  retire un joueur
#   ./mc list             joueurs autorises + joueurs connectes
#   ./mc op <pseudo>      donne les droits admin
#   ./mc cmd "<commande>" envoie n'importe quelle commande Minecraft
#   ./mc restock [pseudo] [metier] reinitialise le stock des villageois (defaut: nistroy9 fisherman, ou "all")
#   ./mc backup           sauvegarde le monde
#   ./mc info             adresse du serveur et etat du tunnel

set -uo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
SRV="$BASE/server"
SESSION="mc"
IA_SESSION="ia"
IA_BRAIN="$HOME/minecraft-ia/brain"
TMUX_BIN="/opt/homebrew/bin/tmux"
[ -x "$TMUX_BIN" ] || TMUX_BIN="$(command -v tmux || true)"

if [ -z "$TMUX_BIN" ]; then
    echo "Erreur : tmux est introuvable. Installe-le avec : brew install tmux"
    exit 1
fi

running() { "$TMUX_BIN" has-session -t "$SESSION" 2>/dev/null; }

require_running() {
    if ! running; then
        echo "Le serveur ne tourne pas. Demarre-le avec : ./mc start"
        exit 1
    fi
}

brain_running() { "$TMUX_BIN" has-session -t "$IA_SESSION" 2>/dev/null; }

# Cerveau de l'assistant IA (depot minecraft-ia). Lance AVANT le serveur : le mod
# lit le jeton du cerveau au demarrage du serveur. Sans cerveau le serveur tourne
# quand meme, seul /ia est indisponible : on previent sans bloquer le demarrage.
start_brain() {
    if brain_running; then
        echo "Cerveau IA : deja lance"
        return
    fi
    if [ ! -x "$IA_BRAIN/.venv/bin/minecraft-ia" ]; then
        echo "Cerveau IA introuvable ($IA_BRAIN) : /ia sera indisponible"
        return
    fi
    "$TMUX_BIN" new-session -d -s "$IA_SESSION" -c "$IA_BRAIN" ".venv/bin/minecraft-ia serve"
    for _ in $(seq 1 15); do
        # Session disparue = le cerveau a quitte (config, port deja pris...).
        if ! brain_running; then
            echo "Cerveau IA : arrete au demarrage, /ia indisponible. Pour voir l'erreur :"
            echo "  cd $IA_BRAIN && .venv/bin/minecraft-ia serve"
            return
        fi
        # "cerveau pr" sans l'accent de "pret" : independant de la locale de grep.
        if "$TMUX_BIN" capture-pane -p -t "$IA_SESSION" 2>/dev/null | grep -q 'cerveau pr'; then
            echo "Cerveau IA : pret"
            return
        fi
        python3 -c "import time; time.sleep(1)" 2>/dev/null
    done
    echo "Cerveau IA : pas pret apres 15 s. Regarde : $TMUX_BIN attach -t $IA_SESSION"
}

# Docker partage les 16 Go du Mac avec le serveur. Une stack Supabase de dev
# (~2,6 Go, 12 conteneurs) a fait swapper le heap Java et tomber le serveur a
# ~10 TPS (2026-09-19). Pendant que le serveur tourne, Docker n'heberge que
# playit (~11 Mo) : on plafonne sa VM, et on rend la valeur par defaut a l'arret.
# La VM ne rend pas au Mac la RAM deja prise : changer le plafond impose de
# redemarrer Docker Desktop (tunnel coupe ~30 s, sans importance a ces moments-la).
DOCKER_SETTINGS="$HOME/Library/Group Containers/group.com.docker/settings-store.json"
DOCKER_MEM_LOW_MIB=1024

docker_up() { docker info >/dev/null 2>&1; }

# Valeur actuelle de MemoryMiB, vide si absente (= defaut Docker, moitie de la RAM).
docker_mem_get() {
    python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("MemoryMiB",""))' "$DOCKER_SETTINGS"
}

# $1 = MiB, ou vide pour retirer la cle. A n'appeler que Docker Desktop arrete :
# il reecrit ce fichier en quittant.
docker_mem_write() {
    python3 - "$DOCKER_SETTINGS" "$1" <<'EOF'
import json, sys
path, mib = sys.argv[1], sys.argv[2]
with open(path) as f:
    settings = json.load(f)
if mib:
    settings["MemoryMiB"] = int(mib)
else:
    settings.pop("MemoryMiB", None)
with open(path, "w") as f:
    json.dump(settings, f, indent=2)
EOF
}

# Applique le plafond $1 (MiB, ou vide = defaut). Demarre Docker si besoin quand
# $2 = "start" ; sinon ne redemarre Docker que s'il tournait deja.
docker_mem_apply() {
    local want="$1" mode="${2:-}"
    [ -f "$DOCKER_SETTINGS" ] || { echo "Reglages Docker introuvables : plafond RAM non applique."; return; }
    if [ "$(docker_mem_get)" = "$want" ]; then
        if [ "$mode" = "start" ] && ! docker_up; then
            echo "Demarrage de Docker Desktop..."
            docker desktop start --timeout 120 >/dev/null || echo "Docker Desktop n'a pas demarre."
        fi
        return
    fi
    if docker_up; then
        echo "Redemarrage de Docker Desktop (RAM : ${want:-defaut} Mo)..."
        docker desktop stop --timeout 120 >/dev/null || { echo "Docker Desktop ne s'arrete pas : plafond RAM inchange."; return; }
    elif [ "$mode" != "start" ]; then
        docker_mem_write "$want"
        return
    else
        echo "Demarrage de Docker Desktop (RAM : $want Mo)..."
    fi
    docker_mem_write "$want"
    docker desktop start --timeout 120 >/dev/null || echo "Docker Desktop n'a pas demarre."
}

# Avant le serveur : Supabase arrete (docker stop tient malgre --restart
# unless-stopped, sinon il repartirait avec Docker), VM plafonnee, tunnel verifie.
prepare_docker() {
    if ! command -v docker >/dev/null; then
        echo "Docker introuvable : tunnel playit ARRETE, les amis ne pourront pas se connecter."
        return
    fi
    if docker_up; then
        local ids
        ids=$(docker ps -q --filter label=com.supabase.cli.project)
        if [ -n "$ids" ]; then
            echo "Arret des conteneurs Supabase pour liberer la RAM..."
            # shellcheck disable=SC2086 # une liste d'IDs, decoupage voulu
            docker stop $ids >/dev/null
        fi
    fi
    docker_mem_apply "$DOCKER_MEM_LOW_MIB" start
    # playit repart seul (--restart unless-stopped) quelques secondes apres Docker.
    for _ in $(seq 1 30); do
        [ -n "$(docker ps -q --filter name=^playit-minecraft$ 2>/dev/null)" ] && { echo "Tunnel playit : OK"; return; }
        python3 -c "import time; time.sleep(1)" 2>/dev/null
    done
    echo "Tunnel playit : ARRETE, les amis ne pourront pas se connecter. Relance : docker start playit-minecraft"
}

# Envoie une commande a la console et affiche UNIQUEMENT ce que le serveur
# repond a cette commande. On compte les lignes de l'historique complet (-S -)
# avant l'envoi, puis on n'affiche que ce qui est apparu apres : sans ca, on
# reafficherait la reponse de la commande precedente.
send() {
    require_running
    local before
    # On ne compte QUE les lignes non vides : capture-pane complete le panneau
    # avec des lignes vides jusqu'a sa hauteur, donc le nombre total de lignes
    # ne bouge pas quand du contenu arrive (il remplace le vide). Le filtrage
    # doit etre identique avant et apres pour que la decoupe soit juste.
    before=$("$TMUX_BIN" capture-pane -p -S - -t "$SESSION" | grep -c '[^[:space:]]')
    "$TMUX_BIN" send-keys -t "$SESSION" -- "$1" Enter
    python3 -c "import time; time.sleep(1.2)" 2>/dev/null
    "$TMUX_BIN" capture-pane -p -S - -t "$SESSION" \
        | grep '[^[:space:]]' \
        | tail -n +$((before + 1)) \
        | (grep -vxF "$1" || true)
}

case "${1:-}" in

start)
    prepare_docker
    start_brain
    if running; then
        echo "Le serveur tourne deja. Console : ./mc console"
        exit 0
    fi
    # -x/-y : un panneau detache fait 80 colonnes par defaut, ce qui coupe les
    # lignes du journal en plein milieu des mots. On le force large.
    "$TMUX_BIN" new-session -d -s "$SESSION" -x 200 -y 50 -c "$SRV" "./start.sh"
    echo -n "Demarrage"
    # On lit le panneau tmux et non logs/latest.log : le panneau ne contient que
    # la sortie de CETTE execution, donc aucun risque de matcher un "Done ("
    # laisse par un demarrage precedent.
    for _ in $(seq 1 120); do
        if ! running; then
            echo
            echo "Le serveur s'est arrete pendant le demarrage. Journal :"
            tail -n 15 "$SRV/logs/latest.log" 2>/dev/null
            exit 1
        fi
        line=$("$TMUX_BIN" capture-pane -p -t "$SESSION" 2>/dev/null | grep 'Done (' | tail -1)
        if [ -n "$line" ]; then
            echo
            echo "$line"
            echo "Console : ./mc console"
            exit 0
        fi
        echo -n "."
        python3 -c "import time; time.sleep(1)" 2>/dev/null
    done
    echo
    echo "Toujours pas pret apres 120 s. Regarde : ./mc log"
    exit 1
    ;;

stop)
    require_running
    echo "Arret en cours (le monde est sauvegarde)..."
    "$TMUX_BIN" send-keys -t "$SESSION" -- "stop" Enter
    for _ in $(seq 1 60); do
        if ! running; then
            echo "Serveur arrete proprement."
            # restart : inutile de redemarrer Docker deux fois.
            [ -n "${MC_KEEP_DOCKER:-}" ] || docker_mem_apply ""
            exit 0
        fi
        python3 -c "import time; time.sleep(1)" 2>/dev/null
    done
    echo "L'arret traine. Session encore active : ./mc console"
    ;;

restart)
    MC_KEEP_DOCKER=1 "$0" stop
    "$0" start
    ;;

status)
    if running; then
        echo "Serveur : EN MARCHE"
        pid=$(pgrep -f 'fabric-server-launch.jar' | head -1)
        if [ -n "$pid" ]; then
            ps -o pid,rss,%cpu,etime -p "$pid" | awk 'NR==2{printf "  PID %s | %.0f Mo RAM | %s%% CPU | actif depuis %s\n",$1,$2/1024,$3,$4}'
        fi
        send "list"
    else
        echo "Serveur : ARRETE"
    fi
    echo -n "Cerveau IA : "
    brain_running && echo "EN MARCHE" || echo "ARRETE"
    ;;

console)
    require_running
    echo "Console live. Pour sortir SANS arreter le serveur : Ctrl+B puis D"
    python3 -c "import time; time.sleep(1.5)" 2>/dev/null
    exec "$TMUX_BIN" attach -t "$SESSION"
    ;;

log)
    tail -f "$SRV/logs/latest.log"
    ;;

add)
    [ -n "${2:-}" ] || { echo "Usage : ./mc add <pseudo>"; exit 1; }
    send "whitelist add $2"
    ;;

remove)
    [ -n "${2:-}" ] || { echo "Usage : ./mc remove <pseudo>"; exit 1; }
    send "whitelist remove $2"
    ;;

list)
    send "whitelist list"
    echo "---"
    send "list"
    ;;

op)
    [ -n "${2:-}" ] || { echo "Usage : ./mc op <pseudo>"; exit 1; }
    send "op $2"
    ;;

cmd)
    [ -n "${2:-}" ] || { echo 'Usage : ./mc cmd "<commande>"'; exit 1; }
    send "$2"
    ;;

restock)
    target="${2:-nistroy9}"
    profession="${3:-fisherman}"
    if [ "$profession" = "fisherman" ]; then
        echo "Reinitialisation des pecheurs proches de $target (rayon: 20m)..."
        send "execute at $target as $target run function restock:fishermen"
    elif [ "$profession" = "all" ]; then
        echo "Reinitialisation de tous les villageois proches de $target (rayon: 20m)..."
        send "execute at $target as $target run function restock:all"
    else
        echo "Reinitialisation des villageois ($profession) proches de $target (rayon: 20m)..."
        send "execute at $target as @e[type=villager,distance=..20,nbt={VillagerData:{profession:\"minecraft:$profession\"}}] run data modify entity @s Offers.Recipes[].uses set value 0"
        send "execute at $target as @e[type=villager,distance=..20,nbt={VillagerData:{profession:\"minecraft:$profession\"}}] run data modify entity @s RestocksToday set value 0"
    fi
    ;;

backup)
    exec "$BASE/backup.sh"
    ;;

info)
    echo "Adresse a donner aux joueurs : schmidt-shut.tun.ply.gg"
    echo "  (port 63508 via DNS SRV ; sinon schmidt-shut.tun.ply.gg:63508)"
    echo
    echo -n "Tunnel playit : "
    docker ps --filter name=playit-minecraft --format '{{.Status}}' 2>/dev/null | grep . || echo "ARRETE"
    echo -n "Serveur       : "
    running && echo "EN MARCHE" || echo "ARRETE"
    ;;

*)
    # Affiche le bloc de commentaires d'en-tete, en s'arretant a la premiere
    # ligne qui n'est pas un commentaire (une plage de lignes figee finirait
    # par deborder sur le code des que le script est modifie).
    awk 'NR==1 {next} /^#/ {sub(/^# ?/, ""); print; next} {exit}' "$0"
    ;;
esac

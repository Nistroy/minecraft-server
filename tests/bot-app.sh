#!/usr/bin/env bash
# Tests de l'app scarpet /bot (server/scripts/bot.sc) sur un serveur Fabric 1.21.1 + Carpet jetable.
# Isolé du serveur réel : dossier temporaire, 127.0.0.1, console par FIFO (pas de tmux : piège du
# préfixe `mc`, cf. TEST-MODS.md). Faux joueurs Alice/Bob pilotés par `execute as`.
#
# Usage : tests/bot-app.sh
#   JAVA=<java 21>            défaut : openjdk@21 Homebrew, sinon `java`
#   BOT_TEST_PORT=<port>      défaut : 25570 (hors tunnel playit)
#   BOT_TEST_KEEP=1           garde le dossier du serveur de test (gardé d'office en cas d'échec)
#   BOT_TEST_APP=<fichier>    app à tester (défaut : server/scripts/bot.sc)
set -euo pipefail
export LC_ALL=C

REPO=$(cd "$(dirname "$0")/.." && pwd)
APP="${BOT_TEST_APP:-$REPO/server/scripts/bot.sc}"
LAUNCHER="$REPO/server/fabric-server-launch.jar"
CARPET_URL='https://cdn.modrinth.com/data/TQTTVgYE/versions/f2mvlGrg/fabric-carpet-1.21-1.4.147%2Bv240613.jar'
CARPET_SHA512='e6f33d13406796a34e7598d997113f25f7bea3e55f9d334b73842adda52b2c5d0a86b7b12ac812d7e758861e3f468bf201c6c710c40162bb79d6818938204151'
CACHE="${BOT_TEST_CACHE:-$HOME/.cache/minecraft-server-tests}"
PORT="${BOT_TEST_PORT:-25570}"
# Délais raccourcis pour les tests (réel : 30 min, vérification toutes les 400 ticks).
OFFLINE_LIMIT_S=8
CHECK_PERIOD_TICKS=40
CHECK_PERIOD_S=2

WORK=""
SERVER_PID=""
MARK=0
PASSED=0

log() { printf '%s\n' "$*"; }

fail() {
    log "ÉCHEC : $*"
    if [ -n "$WORK" ] && [ -f "$WORK/console.log" ]; then
        log "--- 30 dernières lignes de $WORK/console.log ---"
        tail -n 30 "$WORK/console.log"
    fi
    BOT_TEST_KEEP=1
    exit 1
}

ok() {
    PASSED=$((PASSED + 1))
    log "ok - $*"
}

cleanup() {
    if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi
    if [ -n "$WORK" ]; then
        if [ "${BOT_TEST_KEEP:-0}" = 1 ]; then
            log "Dossier de test gardé : $WORK"
        else
            rm -rf "$WORK"
        fi
    fi
}
trap cleanup EXIT

pick_java() {
    if [ -z "${JAVA:-}" ]; then
        if [ -x /opt/homebrew/opt/openjdk@21/bin/java ]; then
            JAVA=/opt/homebrew/opt/openjdk@21/bin/java
        else
            JAVA=$(command -v java || true)
        fi
    fi
    [ -n "$JAVA" ] || fail "Java introuvable (variable JAVA)"
    local version
    version=$("$JAVA" -version 2>&1)
    case "$version" in
        *'"21'*) ;;
        *) fail "Java 21 requis : $JAVA" ;;
    esac
}

sha512_of() {
    if command -v sha512sum >/dev/null; then
        sha512sum "$1" | cut -d ' ' -f 1
    else
        shasum -a 512 "$1" | cut -d ' ' -f 1
    fi
}

fetch_carpet() {
    mkdir -p "$CACHE"
    CARPET_JAR="$CACHE/carpet-1.4.147.jar"
    if [ -f "$CARPET_JAR" ] && [ "$(sha512_of "$CARPET_JAR")" = "$CARPET_SHA512" ]; then
        return
    fi
    curl -fsSL -o "$CARPET_JAR.tmp" "$CARPET_URL" || fail "téléchargement de Carpet"
    [ "$(sha512_of "$CARPET_JAR.tmp")" = "$CARPET_SHA512" ] || fail "sha512 de Carpet incorrect"
    mv "$CARPET_JAR.tmp" "$CARPET_JAR"
}

# Copie de test : commande ouverte à la console (execute as <faux joueur>) et délais courts.
make_test_app() {
    local out=$1 changed
    sed -e "s/'command_permission' -> 'players'/'command_permission' -> 'all'/" \
        -e "s/^global_offline_limit_ms = 30 \* 60 \* 1000;/global_offline_limit_ms = $OFFLINE_LIMIT_S * 1000;/" \
        -e "s/^global_check_period_ticks = 400;/global_check_period_ticks = $CHECK_PERIOD_TICKS;/" \
        "$APP" > "$out"
    changed=$(diff "$APP" "$out" | grep -c '^>' || true)
    [ "$changed" = 3 ] || fail "bot.sc a changé (permission/délais) : adapter make_test_app"
}

setup_server() {
    WORK=$(mktemp -d "${TMPDIR:-/tmp}/bot-app-test.XXXXXX")
    mkdir -p "$WORK/mods" "$WORK/world/scripts" "$WORK/.fabric"
    cp "$LAUNCHER" "$WORK/"
    cp "$CARPET_JAR" "$WORK/mods/carpet.jar"
    # Jar vanilla + bibliothèques : téléchargés par le lanceur Fabric au 1er run, cache ensuite.
    if [ -d "$CACHE/libraries" ]; then cp -R "$CACHE/libraries" "$WORK/"; fi
    if [ -d "$CACHE/fabric-server" ]; then cp -R "$CACHE/fabric-server" "$WORK/.fabric/server"; fi
    echo 'eula=true' > "$WORK/eula.txt"
    cat > "$WORK/server.properties" <<EOF
server-ip=127.0.0.1
server-port=$PORT
online-mode=false
white-list=true
enforce-whitelist=true
level-type=minecraft\:flat
view-distance=3
simulation-distance=3
spawn-protection=0
EOF
    make_test_app "$WORK/world/scripts/bot.sc"
    : > "$WORK/console.log"
}

save_cache() {
    if [ ! -d "$CACHE/libraries" ]; then cp -R "$WORK/libraries" "$CACHE/"; fi
    if [ ! -d "$CACHE/fabric-server" ]; then cp -R "$WORK/.fabric/server" "$CACHE/fabric-server"; fi
}

mark() { MARK=$(wc -l < "$WORK/console.log"); }

since_mark() { tail -n "+$((MARK + 1))" "$WORK/console.log"; }

# Pas de grep -q : il fermerait le tube tôt, et pipefail verrait le SIGPIPE de tail.
seen_since_mark() { since_mark | grep -Ei -- "$1" >/dev/null; }

# Attend une ligne (regex étendue, sans casse) écrite depuis le dernier mark.
wait_log() {
    local pattern=$1 timeout_s=$2 what=$3 waited=0
    until seen_since_mark "$pattern"; do
        kill -0 "$SERVER_PID" 2>/dev/null || fail "$what : serveur arrêté"
        [ "$waited" -lt $((timeout_s * 2)) ] || fail "$what : « $pattern » absent après $timeout_s s"
        sleep 0.5
        waited=$((waited + 1))
    done
}

send() {
    local cmd
    for cmd in "$@"; do printf '%s\n' "$cmd" >&3; done
}

# expect <regex> <description> <commande>... : envoie les commandes, attend la réponse.
expect() {
    local pattern=$1 what=$2
    shift 2
    mark
    send "$@"
    wait_log "$pattern" 15 "$what"
}

refute_since_mark() {
    if seen_since_mark "$1"; then fail "$2 : « $1 » inattendu"; fi
}

start_server() {
    rm -f "$WORK/console.fifo"
    mkfifo "$WORK/console.fifo"
    (cd "$WORK" && exec "$JAVA" -Xms512M -Xmx1536M -jar fabric-server-launch.jar nogui \
        < console.fifo >> console.log 2>&1) &
    SERVER_PID=$!
    exec 3> "$WORK/console.fifo"
    mark
    wait_log 'Done \(' 300 "démarrage du serveur"
}

stop_server() {
    local waited=0
    send stop
    while kill -0 "$SERVER_PID" 2>/dev/null; do
        [ "$waited" -lt 120 ] || fail "arrêt du serveur"
        sleep 0.5
        waited=$((waited + 1))
    done
    wait "$SERVER_PID" 2>/dev/null || true
    SERVER_PID=""
    exec 3>&-
}

spawn_player() { expect "\]: $1 joined the game" "connexion de $1" "player $1 spawn"; }

spawn_bot() { expect "\]: bot_$1 joined the game" "bot de $1" "execute as $1 run bot spawn"; }

test_autoload() {
    seen_since_mark 'bot app loaded' || fail "app non chargée au démarrage"
    ok "app chargée au démarrage"
}

test_console_refused() {
    # Version réelle (permission 'players'), chargée à part puis retirée.
    cp "$APP" "$WORK/world/scripts/botprod.sc"
    expect 'botprod app loaded' "chargement de la version réelle" 'script load botprod'
    expect 'Unknown or incomplete command' "console" 'botprod xp'
    expect 'Removed botprod app' "retrait de la version réelle" 'script unload botprod'
    rm "$WORK/world/scripts/botprod.sc"
    ok "/bot refusée depuis la console"
}

test_spawn_once() {
    spawn_player Alice
    spawn_player Bob
    expect 'Ton bot arrive' "2e spawn immédiat" 'execute as Alice run bot spawn' 'execute as Alice run bot spawn'
    wait_log '\]: bot_alice joined the game' 15 "bot d'Alice"
    refute_since_mark 'duplicate UUID' "doublon de bot"
    ok "1 seul bot par joueur, même en double spawn rapide"
}

test_collect_from_active_bot() {
    expect 'Gave 30 experience levels to bot_alice' "XP au bot" 'xp add bot_Alice 30 levels'
    expect 'Alice a récupéré 1395 points' "transfert" 'execute as Alice run bot xp'
    expect '\]: Alice has 30 experience levels' "niveau d'Alice" 'xp query Alice levels'
    expect '\]: bot_alice has 0 experience levels' "niveau du bot" 'xp query bot_Alice levels'
    expect '= 0 \(' "total d'XP du bot" "script in bot run query(player('bot_Alice'), 'xp')"
    ok "/bot xp : XP exacte transférée, bot remis à 0"
}

test_stop_banks_xp() {
    expect 'bot_alice déconnecté, 160 points' "arrêt du bot" \
        'xp add bot_Alice 10 levels' 'execute as Alice run bot stop'
    expect ': 160[,}]' "réserve" 'script in bot run global_banked_xp'
    spawn_bot Alice
    expect '\]: bot_alice has 0 experience levels' "XP du bot au respawn" 'xp query bot_Alice levels'
    expect 'Alice a récupéré 160 points' "récupération de la réserve" 'execute as Alice run bot xp'
    ok "/bot stop : XP mise de côté, pas de doublon au respawn"
}

test_owner_isolation() {
    expect 'Pas de bot actif' "Bob sans bot" 'execute as Bob run bot stop'
    expect 'bot_alice' "bot d'Alice" 'list'
    ok "un joueur ne touche pas au bot d'un autre"
}

test_owner_timeout() {
    local left elapsed
    spawn_bot Bob
    expect 'Gave 12 experience levels' "XP au bot de Bob" 'xp add bot_Bob 12 levels'
    mark
    left=$(date +%s)
    send 'player Bob kill'
    wait_log 'bot_bob arrêté' $((OFFLINE_LIMIT_S + CHECK_PERIOD_S + 10)) "arrêt auto du bot de Bob"
    elapsed=$(($(date +%s) - left))
    [ "$elapsed" -ge $((OFFLINE_LIMIT_S - 1)) ] || fail "bot de Bob arrêté trop tôt (${elapsed} s)"
    wait_log 'bot_bob déconnecté, 216 points' 5 "XP du bot de Bob"
    ok "bot arrêté après le délai d'absence du propriétaire (${elapsed} s), XP mise de côté"
}

test_owner_return() {
    expect '\]: Alice left the game' "départ d'Alice" 'player Alice kill'
    spawn_player Alice
    sleep $((OFFLINE_LIMIT_S + 2 * CHECK_PERIOD_S + 2))
    refute_since_mark 'bot_alice arrêté' "retour d'Alice"
    expect 'bot_alice' "bot d'Alice" 'list'
    ok "propriétaire revenu avant le délai : bot gardé"
}

test_death_no_dup() {
    expect 'Set bot_alice' "mode survie" 'gamemode survival bot_Alice'
    expect 'Gave 5 experience levels' "XP au bot" 'xp add bot_Alice 5 levels'
    expect '\]: bot_alice left the game' "mort du bot" 'damage bot_Alice 1000'
    seen_since_mark '\]: bot_alice died' || fail "le bot n'est pas mort"
    refute_since_mark 'bot_alice déconnecté' "XP d'un bot mort mise de côté"
    spawn_bot Alice
    expect '\]: bot_alice has 0 experience levels' "XP au respawn" 'xp query bot_Alice levels'
    ok "bot mort : XP ni mise de côté ni retrouvée au respawn"
}

test_restart() {
    expect 'Gave 13 experience levels' "XP au bot" 'xp add bot_Alice 13 levels'
    stop_server
    start_server
    seen_since_mark 'bot app loaded' || fail "app non chargée après redémarrage"
    expect ': 216[,}]' "réserve de Bob" 'script in bot run global_banked_xp'
    expect 'There are 0 of' "bots après redémarrage" 'list'
    spawn_player Alice
    spawn_bot Alice
    expect '\]: bot_alice has 13 experience levels' "XP du bot sauvegardée" 'xp query bot_Alice levels'
    expect 'Alice a récupéré 247 points' "récupération" 'execute as Alice run bot xp'
    spawn_player Bob
    expect 'Bob a récupéré 216 points' "réserve de Bob" 'execute as Bob run bot xp'
    ok "redémarrage : réserve gardée, bots partis, XP du bot retrouvée"
}

test_no_errors() {
    local errors refused
    # Attendus : monde plat sans réglages (« No key layers »), 1 refus console (test_console_refused).
    errors=$(grep -Ei 'exception|error' "$WORK/console.log" \
        | grep -v -e 'No key layers' -e 'Unknown or incomplete command' || true)
    [ -z "$errors" ] || fail "erreurs dans la console : $errors"
    refused=$(grep -c 'Unknown or incomplete command' "$WORK/console.log" || true)
    [ "$refused" = 1 ] || fail "$refused commandes inconnues dans la console (1 attendue)"
    ok "aucune erreur dans la console"
}

main() {
    [ -f "$APP" ] || fail "app introuvable : $APP"
    pick_java
    fetch_carpet
    setup_server
    log "Serveur de test : $WORK (port $PORT)"
    start_server
    save_cache
    test_autoload
    test_console_refused
    test_spawn_once
    test_collect_from_active_bot
    test_stop_banks_xp
    test_owner_isolation
    test_owner_timeout
    test_owner_return
    test_death_no_dup
    test_restart
    stop_server
    test_no_errors
    log "Tous les tests passent ($PASSED)."
}

main "$@"

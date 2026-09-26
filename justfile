# Serveur Minecraft entre amis — raccourcis de commandes.
# Installer une fois : brew install just
# Usage : `just` liste tout ; `just <recette>` en lance une.

set shell := ["bash", "-cu"]

live := env_var('HOME') / "minecraft-server"
worktrees := env_var('HOME') / "minecraft-server-worktrees"
packwiz := env_var('HOME') / "go/bin/packwiz"

# Liste toutes les recettes
default:
    @just --list

# ---------------------------------------------------------------------------
# Serveur (toujours le checkout live, meme lance depuis une worktree : son ./mc
# demarrerait un serveur sans monde ni mods)
# ---------------------------------------------------------------------------

# Demarre le cerveau IA puis le serveur
[group('serveur')]
start:
    "{{live}}/mc" start

# Arrete proprement le serveur (monde sauvegarde)
[group('serveur')]
stop:
    "{{live}}/mc" stop

# Arrete puis redemarre le serveur
[group('serveur')]
restart:
    "{{live}}/mc" restart

# Serveur, joueurs connectes, cerveau IA
[group('serveur')]
status:
    "{{live}}/mc" status

# Console live (Ctrl+B puis D pour sortir sans arreter)
[group('serveur')]
console:
    "{{live}}/mc" console

# Suit le journal du serveur
[group('serveur')]
log:
    "{{live}}/mc" log

# Adresse du serveur et etat du tunnel playit
[group('serveur')]
info:
    "{{live}}/mc" info

# Joueurs autorises + joueurs connectes
[group('serveur')]
players:
    "{{live}}/mc" list

# Envoie une commande a la console (ex. just cmd "time query day")
[group('serveur')]
[positional-arguments]
cmd command:
    "{{live}}/mc" cmd "$1"

# N'importe quelle commande ./mc (ex. just mc add <pseudo>)
[group('serveur')]
[positional-arguments]
mc *args:
    "{{live}}/mc" "$@"

# ---------------------------------------------------------------------------
# Sauvegardes
# ---------------------------------------------------------------------------

# Sauvegarde le monde (rotation : 10 gardees)
[group('sauvegarde')]
backup:
    "{{live}}/mc" backup

# Sauvegarde hors rotation avant un changement de mods/version/worldgen (ex. just backup-pre add-create)
[group('sauvegarde')]
[positional-arguments]
backup-pre change:
    "{{live}}/mc" backup-pre "$1"

# ---------------------------------------------------------------------------
# Pack joueurs (packwiz, MODS.md §6.9)
# ---------------------------------------------------------------------------

# Recalcule l'index du pack apres un ajout/retrait
[group('pack')]
pack-refresh:
    cd pack && {{packwiz}} refresh

# Date du jour comme version du pack, puis recalcule l'index
[group('pack')]
pack-release:
    sed -i '' 's/^version = ".*"$/version = "'"$(date +%Y-%m-%d)"'"/' pack/pack.toml
    cd pack && {{packwiz}} refresh
    @grep '^version' pack/pack.toml

# Sert le pack en local pour le tester avant merge (http://localhost:8080/pack.toml)
[group('pack')]
pack-serve:
    cd pack && {{packwiz}} serve

# ---------------------------------------------------------------------------
# Verifications
# ---------------------------------------------------------------------------

# Syntaxe de tous les scripts shell (+ shellcheck s'il est installe)
[group('verif')]
check:
    #!/usr/bin/env bash
    set -euo pipefail
    scripts=(mc backup.sh discord-mcp.sh server/start.sh)
    for f in "${scripts[@]}"; do bash -n "$f" && echo "ok  $f"; done
    if command -v shellcheck >/dev/null; then
        shellcheck "${scripts[@]}"
    else
        echo "shellcheck absent (brew install shellcheck) : analyse sautee"
    fi

# Preuve d'un demarrage propre : "Done (" dans le journal du dernier demarrage + nombre de lignes ERROR
[group('verif')]
check-start:
    #!/usr/bin/env bash
    set -euo pipefail
    logs="{{live}}/server/logs"
    # latest.log tourne chaque jour : le demarrage peut etre dans un .log.gz plus ancien.
    # Tri par nom (AAAA-MM-JJ-N) : les dates de modification des .gz ne suivent pas cet ordre.
    # Journal lu en entier dans une variable : un grep -q en fin de tube couperait gzip (SIGPIPE + pipefail).
    startup="" text=""
    for f in "$logs/latest.log" $(ls "$logs"/*.log.gz | sort -rV); do
        text=$(gzip -cdf "$f")
        if [[ "$text" == *"Starting minecraft server version"* ]]; then startup="$f"; break; fi
    done
    [ -n "$startup" ] || { echo "Aucun journal de demarrage dans $logs"; exit 1; }
    echo "Journal : $(basename "$startup")"
    done_line=$(grep -m1 'Done (' <<<"$text" || true)
    if [ -z "$done_line" ]; then
        echo "Pas de \"Done (\" : demarrage incomplet ou en echec. Fin du journal :"
        tail -n 20 <<<"$text"
        exit 1
    fi
    echo "$done_line"
    # ~250 erreurs de recettes/advancements de datapacks sont connues et sans effet (2026-09-25) :
    # un chiffre qui grimpe d'un demarrage a l'autre merite un coup d'oeil.
    # grep -c sort en 1 quand il compte 0 ligne.
    echo "Lignes ERROR : $(grep -c '/ERROR\]' <<<"$text" || true)"

# ---------------------------------------------------------------------------
# Git (le checkout live est le dossier du serveur : jamais de changement de branche dedans)
# ---------------------------------------------------------------------------

# Nouvelle branche <type>/<sujet> dans sa worktree, hors du checkout live (ex. just worktree feat add-amecs)
[group('git')]
[positional-arguments]
worktree type topic:
    #!/usr/bin/env bash
    set -euo pipefail
    type="$1" topic="$2"
    [[ "$type" =~ ^(feat|fix|docs|chore|refactor|test|perf)$ ]] || { echo "Type inconnu : $type"; exit 1; }
    [[ "$topic" =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "Sujet en kebab-case attendu : $topic"; exit 1; }
    git -C "{{live}}" fetch -q origin
    git -C "{{live}}" worktree add -b "$type/$topic" "{{worktrees}}/$type-$topic" origin/main
    echo "cd {{worktrees}}/$type-$topic"

# Met le checkout live a jour avec origin/main (avance rapide seulement)
[group('git')]
sync:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{live}}"
    branch=$(git branch --show-current)
    [ "$branch" = main ] || { echo "Checkout live sur $branch au lieu de main : a regler a la main"; exit 1; }
    git fetch -q origin
    changed=$(git diff --name-only HEAD origin/main -- server/)
    [ -z "$changed" ] || printf 'Fichiers du serveur modifies (lus au prochain demarrage) :\n%s\n' "$changed"
    git merge --ff-only origin/main

# Supprime les branches fusionnees dans main (locales + distantes), liste les worktrees a retirer
[group('git')]
clean-branches:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{live}}"
    git fetch -q --prune origin
    open=$(git worktree list --porcelain)
    git branch --merged origin/main --format='%(refname:short)' | while read -r b; do
        [ "$b" = main ] && continue
        # Branche ouverte dans une worktree : git refuse de la supprimer, elle peut contenir du travail non commite.
        if [[ $'\n'"$open"$'\n' == *$'\n'"branch refs/heads/$b"$'\n'* ]]; then
            echo "worktree fusionnee, a retirer si plus utile : $b"
        else
            git branch -d "$b"
        fi
    done
    git branch -r --merged origin/main --format='%(refname:short)' | while read -r b; do
        case "$b" in origin | origin/main | origin/HEAD) continue ;; esac
        git push -q origin --delete "${b#origin/}" && echo "distante supprimee : $b"
    done

#!/bin/bash
# Sauvegarde le monde dans ~/minecraft-server/backups/
# Usage : ./backup.sh    (a lancer serveur arrete, ou apres un /save-all dans la console)

set -euo pipefail

BASE="$HOME/minecraft-server"
WORLD="$BASE/server/world"
DEST="$BASE/backups"
STAMP=$(date +%Y-%m-%d_%Hh%M)

if [ ! -d "$WORLD" ]; then
    echo "Aucun monde a sauvegarder ($WORLD est introuvable)."
    exit 1
fi

mkdir -p "$DEST"
tar -czf "$DEST/world_$STAMP.tar.gz" -C "$BASE/server" world
echo "Sauvegarde : $DEST/world_$STAMP.tar.gz ($(du -h "$DEST/world_$STAMP.tar.gz" | cut -f1))"

# Ne garde que les 10 sauvegardes les plus recentes.
ls -1t "$DEST"/world_*.tar.gz 2>/dev/null | tail -n +11 | while read -r old; do
    echo "Suppression de l'ancienne sauvegarde : $(basename "$old")"
    rm -f "$old"
done

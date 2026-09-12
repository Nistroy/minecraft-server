#!/bin/bash
# Termine la configuration du tunnel playit.gg.
# A lancer APRES avoir valide le lien de rattachement sur playit.gg.
#
# Usage : ./setup-tunnel.sh

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
CODE_FILE="$DIR/claim-code.txt"
SECRET_FILE="$DIR/secret.txt"

if [ ! -f "$CODE_FILE" ]; then
    echo "Erreur : $CODE_FILE introuvable."
    echo "Regenere un code avec :"
    echo "  docker run --rm -v $DIR:/pl --entrypoint /pl/playit-cli alpine claim generate"
    exit 1
fi

CODE=$(tr -d '[:space:]' < "$CODE_FILE")

if [ ! -f "$SECRET_FILE" ]; then
    echo "Recuperation de la cle secrete (code : $CODE)..."
    echo "Si ca bloque, c'est que le lien https://playit.gg/claim/$CODE n'a pas encore ete valide."

    SECRET=$(docker run --rm -v "$DIR:/pl" --entrypoint /pl/playit-cli alpine \
        claim exchange "$CODE" --wait 120 | tr -d '[:space:]')

    if [ -z "$SECRET" ]; then
        echo "Echec : aucune cle recue. Valide d'abord le lien de rattachement."
        exit 1
    fi

    printf '%s' "$SECRET" > "$SECRET_FILE"
    chmod 600 "$SECRET_FILE"
    echo "Cle secrete enregistree dans $SECRET_FILE"
else
    echo "Cle secrete deja presente, reutilisation."
    SECRET=$(tr -d '[:space:]' < "$SECRET_FILE")
fi

# (Re)demarre l'agent. --restart unless-stopped le relance apres un reboot du Mac.
docker rm -f playit-minecraft >/dev/null 2>&1 || true
docker run -d --name playit-minecraft --restart unless-stopped \
    -e SECRET_KEY="$SECRET" \
    ghcr.io/playit-cloud/playit-agent:latest >/dev/null

sleep 3
echo
docker ps --filter name=playit-minecraft --format 'Agent : {{.Status}}'
echo
echo "Derniere etape, sur https://playit.gg :"
echo "  1. Cree un tunnel 'Minecraft Java'"
echo "  2. Adresse locale a renseigner : 192.168.1.198:25565"
echo "  3. Partage a tes amis l'adresse xxxxx.gl.joinmc.link affichee"

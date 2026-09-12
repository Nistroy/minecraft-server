#!/bin/bash
# Lance le serveur Minecraft Fabric 1.21.1
# Usage : ./start.sh

cd "$(dirname "$0")" || exit 1

# Java 21 est requis par Minecraft 1.21.x. On force le chemin Homebrew plutot que
# le `java` du PATH, qui pointe sur Java 25 (non supporte par de nombreux mods).
JAVA="/opt/homebrew/opt/openjdk@21/bin/java"

if [ ! -x "$JAVA" ]; then
    echo "Erreur : Java 21 introuvable a $JAVA"
    echo "Installe-le avec : brew install openjdk@21"
    exit 1
fi

# 4 Go : confortable pour 2-5 joueurs en Fabric legerement moddé.
# Passe a 6G si tu ajoutes un gros modpack. Ne depasse jamais 8G sur cette machine
# (16 Go au total, macOS et le reste ont besoin de respirer).
MEM="4G"

# Flags G1GC d'Aikar : reduisent nettement les micro-freezes lies au garbage collector.
exec "$JAVA" \
    -Xms${MEM} -Xmx${MEM} \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar fabric-server-launch.jar nogui

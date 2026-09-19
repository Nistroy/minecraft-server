# Serveur Minecraft — Mac mini M1

Serveur **Fabric 1.21.1**, Java 21, pour jouer entre amis (2-5 joueurs).

## Adresse à donner à tes amis

```
schmidt-shut.tun.ply.gg
```

Sans port : un enregistrement DNS SRV redirige automatiquement vers le port 63508.
Si un joueur a un client qui ignore les SRV, lui donner `schmidt-shut.tun.ply.gg:63508`.

Testé de bout en bout : ~30 ms de latence vers le tunnel (datacenter européen).

## Arborescence

```
~/minecraft-server/
├── server/              Le serveur et ses données
│   ├── start.sh         ← lance le serveur
│   ├── server.properties
│   ├── mods/            ← déposer les mods ici (serveur ET joueurs doivent avoir les mêmes)
│   ├── world/           Le monde
│   └── whitelist.json   Les joueurs autorisés
├── backups/             Sauvegardes du monde (10 max, rotation auto)
├── backup.sh            ← lance une sauvegarde
└── playit/              Agent du tunnel playit.gg
```

## Tout se pilote avec `./mc`

Le serveur tourne dans une session `tmux`, ce qui permet de lui envoyer des
commandes **à chaud**. Rien de ce qui suit ne nécessite de redémarrage.

```bash
cd ~/minecraft-server

./mc start              # arrête Supabase, RAM Docker plafonnée 1 Go (redémarre Docker si besoin), vérifie playit, démarre cerveau IA (tmux `ia`) puis serveur
./mc stop               # arrête proprement (sauvegarde le monde), RAM Docker remise par défaut (redémarre Docker) ; cerveau IA laissé lancé
./mc restart
./mc status             # en marche ? RAM, CPU, joueurs connectés, cerveau IA
./mc console            # console live — Ctrl+B puis D pour sortir SANS arrêter
./mc log                # suit le journal

./mc add <pseudo>       # autorise un joueur — IMMÉDIAT, sans redémarrage
./mc remove <pseudo>
./mc list               # joueurs autorisés + connectés
./mc op <pseudo>        # droits admin
./mc cmd "<commande>"   # n'importe quelle commande Minecraft
./mc restock [pseudo]   # réinitialise le stock des villageois proches (défaut: nistroy9, 20m, pêcheurs)

./mc backup
./mc info               # adresse du serveur + état du tunnel
```

Le pseudo est le **pseudo Minecraft/Microsoft exact**, pas un surnom.

### Pourquoi garder la whitelist

Une adresse `.ply.gg` n'est pas un secret : ces plages sont scannées en
permanence, et il suffit qu'un ami la recopie quelque part pour qu'elle circule.
Sans whitelist, n'importe qui peut entrer et saccager le monde — et comme le
tunnel masque les IP réelles, tu ne pourrais pas filtrer par adresse.

Ajouter quelqu'un coûte une commande et zéro interruption (`./mc add <pseudo>`),
donc la whitelist ne te fait rien perdre. Si tu veux vraiment ouvrir à tous :
`./mc cmd "whitelist off"`.

## Administration

`nistroy9` est opérateur niveau 4. En jeu, tu peux donc taper directement
`/whitelist add <pseudo>`, `/gamemode creative`, `/time set day`, etc.

Pour bannir : **`/ban <pseudo>`**, jamais `/ban-ip` — tous les joueurs arrivent
par l'IP du tunnel, tu bannirais tout le monde d'un coup, toi compris.

## Ajouter des mods

Modpack installé le 2026-09-12 : liste = `MODS.md` (§2-3), versions = `versions-testees.tsv`.
1. Mod décidé dans `MODS.md`, version **Fabric 1.21.1**, testé d'abord (`TEST-MODS.md`).
2. `./mc stop` + `./backup.sh`, déposer le jar dans `server/mods/`, `./mc start`.
3. Mod joué des deux côtés (S+C) : l'ajouter aussi au pack joueurs `pack/` (`MODS.md` §6.9). Une fois sur `main`,
   les amis le reçoivent tout seuls au lancement suivant (`MODS.md` §7).

RAM : `MEM="6G"` dans `start.sh` (modpack complet), jamais plus de 8G.
`server.properties` (2026-09-13) : `view-distance=16` (demandé par nistroy ; au-delà de la zone pré-générée, 2500 blocs,
génération plus lourde → réduire à 12 si lag à plusieurs), `simulation-distance=8` (coût mobs/redstone inchangé),
`max-tick-time=180000` (filet anti-watchdog, `MODS.md` §5 point 7).

## Sauvegardes

```bash
~/minecraft-server/backup.sh
```

À lancer serveur arrêté, ou après avoir tapé `save-all` dans la console.
En plus, Textile Backup sauvegarde toutes les heures quand des joueurs sont connectés, et à l'arrêt, dans `backups/`
(10 gardées, `server/config/textile_backup.json5`).

## Notes techniques

- **Java 21** est forcé dans `start.sh` (`/opt/homebrew/opt/openjdk@21/bin/java`).
  Le `java` du système est un Java 25, que beaucoup de mods ne supportent pas.
- **Pourquoi 1.21.1 ?** C'est la version « ancre » du moddé actuel : ~31 000 mods
  disponibles, contre ~12 000 pour la dernière version (26.2). Les versions les
  plus récentes sont les moins bien fournies en mods.
- **playit.gg** ne fournit pas de binaire macOS : l'agent tourne dans Docker
  (image `linux/arm64`, native sur M1, pas d'émulation).
- Le tunnel pointe vers `192.168.1.198:25565` (l'IP LAN du Mac). Si cette IP
  change, il faut la mettre à jour dans le tableau de bord playit.gg —
  pense à réserver l'IP dans ta box (bail DHCP statique).

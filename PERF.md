# Lag et crashs serveur : causes connues

Registre de ce qui a fait ou peut faire ramer ou tomber le serveur. Une ligne par cause, avec son statut.
Coûts « à prévoir » des mods (génération, sauvegardes…) : `MODS.md` §5 Consommation.

## Causes

| # | Cause | Impact | Statut |
|---|---|---|---|
| 1 | Enchants Plus : fonction `enchantsplus:tick` | 🔴 ~55 % du tick, qui grimpe avec le nombre de joueurs | Corrigé 2026-09-23 (§Enchants Plus) |
| 2 | RAM du Mac saturée → Java en swap | 🔴 risque de gels de plusieurs secondes | À surveiller (§RAM du Mac) |
| 3 | Génération de chunks neufs hors pré-génération | 🟠 pics en exploration | À surveiller |
| 4 | Entités nombreuses : 145 glares (Friends&Foes), 94 gardiens (ferme), 195 objets au sol | 🟡 glares ~2 % du tick | À surveiller |
| 5 | Enhanced Celestials (prévisions lunaires, à chaque tick) | 🟡 ~2 % du tick | Accepté |
| 6 | `/locate` sur le thread principal → watchdog | Crash 2026-09-13 02:05 | Corrigé 2026-09-13 (`MODS.md` §5 point 7) |
| 7 | `Failed to initialize server` au démarrage | Crash 2026-09-20 05:39 | Cause inconnue (log écrasé). Survenu pendant l'essai de FTB Quests, retiré le jour même |

## Épisode du 2026-09-23 (19:35 → 19:55+)

- Symptôme : `Can't keep up` toutes les ~20 s, jusqu'à 21,7 s de retard. Début 2 min après l'arrivée du 5e joueur
  (6 connectés ensuite). Mêmes pics les 2026-09-20 (341 alertes) et 2026-09-21 (199), à chaque fois avec 5 à 7 joueurs.
- Mesures `spark health` : TPS 13-15, tick médian 60-77 ms (budget 50 ms), 95e centile 112 ms.
  RAM Java 3,4 / 6 Go, CPU du processus Java ~20 %, disque 74 %. 914 entités dans l'Overworld.
- Profil `spark profiler` 30 s sur `Server thread` : <https://spark.lucko.me/HEIoKE3o18>
  - 55 % : fonctions de datapack exécutées à chaque tick (`#minecraft:tick`) → sélecteurs `nbt=`
    → sérialisation NBT complète des entités (Accessories ~19 %, Fabric attachments ~26 %). Seul pack concerné : Enchants Plus.
    BlazeandCave (`blazeandcave:tick_timer`) est léger : ses tests `nbt=` ne tournent qu'une fois par seconde.
  - Le reste : Lithium 2,4 %, glares 2,2 %, Enhanced Celestials 2,1 %, C2ME ~1,5 %. Rien d'autre au-dessus de 1 %.
- Mac mini au même moment : 89 Mo de RAM libre, 7,7 Go compressés, swap 4,1 / 5 Go ; processus Java = 2,9 Go en RAM
  et **4,4 Go en swap** (`vmmap --summary`). RustDesk occupait 4,8 Go, Chrome ~3 Go.
- Écarté : sauvegarde Textile (compression de 21 s à 19:48, mais le lag avait commencé à 19:35), GC (jeunes collectes
  de 42 ms en moyenne, aucune collecte complète), erreurs en boucle (aucune ; les logs ne contiennent que du bruit de démarrage).

## Enchants Plus

`Enchants+ 1.21 - 1.21.1 fabric-forge.jar` (`1.6B`, dernière version Fabric 1.21.1 sur Modrinth, vérifié 2026-09-23).
`data/enchantsplus/function/tick.mcfunction`, exécutée 20 fois par seconde :

- `@e[type=!player,nbt={NoAI:true},tag=ep.entity.frozen]` : le test `nbt` passe avant le test `tag`, donc
  **toutes** les entités non-joueurs sont sérialisées à chaque tick (914 le 2026-09-23).
- 7 × `@a[nbt={SelectedItem:…}]` / `@a[nbt={Inventory:[…Slot:102b]}]` (Gloutonnerie, Luminosité) :
  chaque joueur est sérialisé 7 fois par tick, avec son inventaire, son sac à dos et ses Accessories. Le coût est proportionnel au nombre de joueurs.
- Les autres lignes filtrent d'abord par `type`/`tag` (flèches, marqueurs) : coût faible.

**Correctif 2026-09-23** : datapack `server/world/datapacks/enchantsplus-perf/` (hors dépôt, `pack_format` 48). Il redéfinit
`enchantsplus:tick`, ce qui marche parce que les datapacks du monde se chargent après ceux des mods (`datapack list`).
Copie de l'original avec 8 remplacements :
- 7 × `@a[nbt={SelectedItem…}]` / `@a[nbt={Inventory…Slot:102b}]` → `@a` + `if items entity @s weapon.mainhand` /
  `armor.chest *[minecraft:enchantments~[{enchantments:"enchantsplus:<id>",levels:<n>}]]` ;
- `@e[type=!player,nbt={NoAI:true},tag=ep.entity.frozen]` → `tag` avant `nbt`.

Vérifié : `if items` et l'ancien `nbt=` donnent le même résultat sur nistroy9 (Luminosité III sur le plastron) ; `/reload` sans
nouvelle erreur, 81 packs ; marqueurs `ep.light.mark` présents après correction. Profil avec 6 joueurs
<https://spark.lucko.me/FLcnPhaII5> : fonctions 55 % → 5,5 % du tick, tick médian 43 → 21 ms, TPS 20.
Enchants+ mis à jour → régénérer la surcharge à partir du nouveau `tick.mcfunction`.

Autres options (analyse des jars Modrinth 2026-09-23, builds Fabric 1.21.1) :

| Option | Coût serveur | Côté joueurs | Remarques |
|---|---|---|---|
| More Enchants `moreenchantments` `1.2.1+mod` | nul (21 enchantements en données pures, aucune fonction par tick) | optionnel | Enchantements à attributs (vitesse, force, portée…), moins « vanilla » |
| Enchantments Encore `1.8+mod` | faible : 1 × `@a[nbt={SleepTimer…}]` par tick + tests `nbt` sur les projectiles | optionnel | 153 fichiers d'enchantement. Déjà écarté au vote (un seul pack d'enchantements) |
| Neo Enchant+ `5.14.0` | faible : chaque tick, lit les objets au sol à moins de 10 blocs des joueurs (`if data`) | optionnel | 129 fichiers d'enchantement |
| Enchancement `1.21-r14`, Elemental Enchantments `2.3.0` | nul (code Java) | **mod client obligatoire** | Enchancement refond tout le système d'enchantement vanilla |

Remplacer Enchants Plus (au lieu de le corriger) : ses enchantements disparaissent des objets existants. Le pack de
ressources `enchants-plus-lang` (`MODS.md` §6 étape 9) et le datapack `starlight-bow-enchants` (`MODS.md` §3) en dépendent.

## RAM du Mac

16 Go au total : Java 6 Go de heap (`MEM="6G"`, 7,1 Go en tout) + VM Docker (playit, ~1 Go) + le reste.
Si macOS manque de RAM, il compresse et swappe la mémoire de Java. Le GC doit ensuite relire ces pages
depuis le disque, d'où des gels. RustDesk `1.4.8` (`--server`, service launchd `gui/501/com.carriez.RustDesk_server`)
fuit : 4,7 Go après 10 jours. Il sert à l'accès à distance, donc on ne le ferme pas. macOS ne sait pas plafonner la RAM d'un processus.
Parade : le redémarrer avec `launchctl kickstart -k gui/501/com.carriez.RustDesk_server` (relancé en ~1 s, la session
distante coupe). 2026-09-23 : 4,7 Go → 60 Mo, swap 4,1 → 1,2 Go, mémoire compressée 7,7 → 2,8 Go.
Redémarrage automatique à 6 h (validé par nistroy) : LaunchAgent `~/Library/LaunchAgents/com.nistroy.rustdesk-restart.plist`, à installer.
Leviers : limiter Chrome et l'IDE pendant les sessions de jeu ; ne pas augmenter `MEM` sans RAM libre.
Baisser `MEM` : heap utilisé jusqu'à 4,3 Go le 2026-09-23 (6 joueurs) → 5 Go laisserait peu de marge. `MEM` ne sert
que serveur lancé (Java rend tout à l'arrêt), donc rien à « remettre » après un arrêt.

## Génération hors pré-génération

Pré-génération Overworld : `chunky radius 2500` (carré, `MODS.md` §5). Le village de la bande est vers `x≈2800`,
donc en dehors. Toute exploration plus loin génère des chunks neufs (Terralith, Tectonic, ~20 mods de structures),
avec `view-distance=16`. Parade possible : étendre la pré-génération par Chunky, serveur vide.

## Diagnostiquer

- `./mc cmd "spark tps"` · `./mc cmd "spark health"` : TPS, durée des ticks, CPU, RAM.
- `./mc cmd "spark profiler start --timeout 30 --thread Server thread"` → lien dans `server/logs/latest.log`.
  Données brutes : `https://spark-usercontent.lucko.me/<id>` (protobuf).
- `grep -c "Can't keep up" server/logs/latest.log` · `server/crash-reports/`.
- Mac : `vmmap --summary <pid java> | grep TOTAL` (colonne SWAPPED) · `top -l 1 -o mem` · `sysctl vm.swapusage`.

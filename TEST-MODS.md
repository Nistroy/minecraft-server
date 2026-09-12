# Test des mods — instance jetable

À exécuter dans une conversation dédiée. But : tous les mods candidats tournent ensemble sur un serveur
de test, sans erreur, **avant** la fin du sondage. Liste, côtés, compat : `MODS.md` (relire au moment d'agir).

## Décisions (nistroy, 2026-09-12)
- Instance séparée `test-server/` (gitignoré), monde jetable. `server/` + son monde : ne pas toucher.
- Périmètre : ✅ S + S+C (`MODS.md` §2.1-2.2) + Emotecraft, Do a Barrel Roll (serveur optionnel, §6 étape 9) +
  tous les ⏳ (§3). Jamais les mods C.
- Galosphere / Spelunkery : testés 2026-09-12 (runs A/B), écartés tous les deux (`MODS.md` §4) → 1 seul run désormais.
- Vanilla arrêté pendant le test (validé : 0 joueur, monde recréé ensuite), relancé à la fin.
- Go-ahead téléchargement : `test-server/mods/` seulement. `server/mods/` reste bloqué jusqu'au vote.
- Hors périmètre : test en jeu côté client (demande le `.mrpack`, `MODS.md` §6 étape 9).

## Relevé Modrinth 2026-09-12
- 112 projets résolus : 86 candidats + 26 bibliothèques, tous Fabric 1.21.1. 0 incompatibilité déclarée dans le lot.
- Pas de release, seulement alpha : `c2me-fabric`, `incendium` · beta : `bosses-of-mass-destruction`, `trade-cycling`, `bountiful`.
- `blazeandcaves-advancements-pack` = datapack (loader `datapack`), pas un jar de mod.
- Loader serveur : Fabric `0.19.5` (`install.properties` de `server/fabric-server-launch.jar`).

## Pièges
- **Session tmux `test-mc`, jamais `mc-…`** : `./mc` fait `tmux has-session -t mc`, et tmux accepte un préfixe
  → avec le vanilla arrêté, `./mc start/stop/cmd` viseraient la session de test.
- Tunnel playit → `192.168.1.198:25565` : le test sur 25565 est joignable de l'extérieur → garder
  `white-list=true` + `enforce-whitelist=true` (valeurs actuelles de `server/server.properties`).
- Variante sans arrêter le vanilla : `server-port=25566` (hors tunnel, valeur actuelle de `test-server/server.properties`),
  faite 2026-09-12 pour le lot final (RAM 4 + 6 Go OK). `./mc status` affiche alors PID/RAM du **test** (`pgrep … | head -1`) ;
  son `list` reste celui du vanilla.
- Ne pas supprimer de monde : un `level-name` différent par run.

## Procédure

### 1. Préparer
1. `./mc status` → 0 joueur, sinon attendre. Puis `./mc stop`.
2. `mkdir test-server`. Copier depuis `server/` : `fabric-server-launch.jar`, `eula.txt`, `start.sh`, `server.properties`,
   `whitelist.json`, `ops.json`, + `libraries/`, `versions/`, `.fabric/` (évite un re-téléchargement).
3. `test-server/start.sh` : `MEM="6G"`.

### 2. Mods
1. Résoudre comme `MODS.md` §6 étape 2 : `curl`, dernière `release` (sinon dernière version), fichier `primary`,
   `sha512` vérifié après téléchargement, dépendances `required` récursives, signaler toute `incompatible` dans le lot.
2. Jars → `test-server/mods/`. Pas le datapack (étape 3.3).
3. `test-server/versions-testees.tsv` : `slug  version  fichier  sha512` par jar. L'install après le vote reprendra ces versions.

### 3. Runs
| Run | `level-name` | Mods |
|---|---|---|
| A | `world-A` | tout (sans `galosphere` ni `spelunkery`, écartés) |

- Lancer : `tmux new-session -d -s test-mc -x 200 -y 50 -c ~/minecraft-server/test-server ./start.sh`
- Console : `tmux send-keys -t test-mc -- '<cmd>' Enter` · log : `test-server/logs/latest.log` · arrêt : `stop`.

Par run, dans l'ordre :
1. `Done (` dans le log. Aucun `ERROR`, `Mixin apply failed`, `Incompatible mods found`, dépendance manquante.
   `WARN` : relever et trier (seulement ceux qui touchent un mod du lot).
2. Configs générées : `MODS.md` §5 point 1 (Illusionner de Friends&Foes) → noter le nom exact de l'option, l'appliquer.
3. Datapack : copier dans `test-server/<level-name>/datapacks/`, `reload`, `datapack list` → activé
   (sinon `datapack enable "file/<nom>"`).
4. `locate` : **un à la fois**, attendre la réponse (lot envoyé d'un coup = 1 tick → watchdog, `MODS.md` §5 point 7).
   1 biome Terralith + 1 structure par mod de structure/boss. ID de structure lus dans le jar
   (`unzip -l <jar> | grep worldgen/structure/`), jamais inventés. Nether/End : `execute in minecraft:the_nether run locate …`
   / `execute in minecraft:the_end run locate …`.
5. Génération : `chunky radius 500` + `chunky start`, puis Nether et End en plus petit (`chunky world <dimension>`).
   Noter la durée, `spark tps`, `spark health` (RAM).
6. `stop` propre, rien dans `test-server/crash-reports/`.

Échec → bisection : retirer la moitié des candidats (garder leurs bibliothèques), relancer, recommencer jusqu'au coupable.

### 4. Fin
1. `stop` sur `test-mc`, puis `./mc start`, `./mc status`.
2. Résultats → `MODS.md` §5 (conflits, noms d'options vérifiés, Kambrik). Mod cassé → le signaler à nistroy,
   ne pas le passer en « écarté » sans lui.
3. Garder `test-server/` (les jars testés servent à l'install après le vote) ; ne pas le supprimer sans demander.
4. Compte rendu à nistroy : runs, versions, erreurs, TPS/RAM, durée de génération.

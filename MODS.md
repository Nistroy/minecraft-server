# Modpack du serveur — liste de référence

> **Source de vérité** pour les mods du serveur. Toute installation doit suivre ce fichier.
> Statut : ✅ = validé par nistroy · ⏳ = au vote (§3 ; certains déjà installés) ·
> 🗳️ = nistroy hésite → tranché par le sondage.
> **Validation finale : un sondage entre amis** décidera si chaque mod est accepté ou non sur le serveur.
> Les ✅ sont les choix de nistroy, soumis à ce sondage avant installation.

- **Version** : Minecraft **1.21.1**, loader **Fabric** (Java 21 — voir `README.md`)
- **Esprit** : « vanilla+ » pour 2 à 5 amis — plus de biomes, de structures, quelques boss ;
  rien qui transforme le jeu (pas de Create, pas de tech, pas de magie lourde).
- **Vocal** : sur Discord → pas de mod de voice chat.

Légende « Côté » :
- **S** = serveur seul (les amis n'installent rien)
- **S+C** = serveur **et** joueurs
- **C** = joueurs seulement (ne **jamais** mettre dans `server/mods/`)

---

## 1. Décisions prises

| Question | Décision | Pourquoi |
|---|---|---|
| Fabric ou NeoForge ? | **Fabric** | Seuls Cataclysm/Mowzie's justifiaient NeoForge ; non retenus. L'End est déjà couvert (Nullscape + YUNG's End Island + boss Obsidilith). |
| Monde actuel | **Le recréer** | Les mods de génération n'agissent que sur les nouveaux chunks. Le monde actuel n'a jamais été joué (5 Mo, 0 joueur). |
| Voice chat | Non | Le groupe utilise Discord. |

---

## 2. Mods validés ✅

### 2.1 Serveur seul (S)

**Performance**

| Mod | Slug Modrinth | Ce qu'il apporte |
|---|---|---|
| Lithium | `lithium` | Optimise la logique du jeu (mobs, physique, entonnoirs) sans rien changer au gameplay |
| C2ME | `c2me-fabric` | Génération de chunks multi-cœurs — crucial avec Terralith/Tectonic. Toute la ligne `0.4.0-*` exige Java 25 (module `c2me-opts-natives-math`) → `0.3.0+alpha.0.364+1.21.1` tant que Java 21 (test 2026-09-12) |
| FerriteCore | `ferrite-core` | Moins de RAM |
| ModernFix | `modernfix` | Démarrage plus rapide, moins de RAM |
| Chunky | `chunky` | Pré-génération de la carte |
| spark | `spark` | Profilage si le serveur rame |
| ScalableLux | `scalablelux` | Calcul de la lumière plus rapide (aussi utile côté client) |
| Clumps | `clumps` | Regroupe les orbes d'XP → moins de lag (client optionnel) |
| Async Locator Refined | `async-locator-refined` | `/locate` structure/biome, cartes d'exploration, dauphins hors thread principal → plus de gel (§5 point 7). Ajouté 2026-09-13 hors sondage (perf, serveur seul) |

**Terrain & biomes**

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| Terralith | `terralith` | ~95 biomes Overworld, uniquement en blocs vanilla |
| Tectonic | `tectonic` | Relief spectaculaire (montagnes, vallées, falaises) — compatible Terralith |
| Incendium | `incendium` | Refonte du Nether : biomes, structures, butin unique |
| Nullscape | `nullscape` | Refonte du terrain de l'End (hauteur 384, îles variées). Incompatible avec les *autres* mods de terrain de l'End — aucun dans la liste |

**Structures**

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| YUNG's Better Dungeons | `yungs-better-dungeons` | Donjons refaits |
| YUNG's Better Mineshafts | `yungs-better-mineshafts` | Mines refaites |
| YUNG's Better Strongholds | `yungs-better-strongholds` | Strongholds refaits |
| YUNG's Better Ocean Monuments | `yungs-better-ocean-monuments` | Monuments océaniques refaits |
| YUNG's Better Nether Fortresses | `yungs-better-nether-fortresses` | Forteresses du Nether refaites |
| YUNG's Better Desert Temples | `yungs-better-desert-temples` | Temples du désert refaits |
| YUNG's Better Jungle Temples | `yungs-better-jungle-temples` | Temples de la jungle refaits |
| YUNG's Better Witch Huts | `yungs-better-witch-huts` | Cabanes de sorcière refaites |
| YUNG's Better End Island | `yungs-better-end-island` | Île centrale de l'End + combat du dragon refaits (compatible Nullscape) |
| Towns and Towers | `towns-and-towers` | Villages et avant-postes pillards selon le biome |
| Dungeons and Taverns | `dungeons-and-taverns` | Tavernes, repaires, donjons style vanilla |
| Explorify | `explorify` | Dizaines de petites structures (ruines, campements, cryptes) |
| MVS – Moog's Voyager Structures | `moogs-voyager-structures` | Structures variées partout |
| ChoiceTheorem's Overhauled Village | `ct-overhaul-village` | Un style de village par biome |
| When Dungeons Arise | `when-dungeons-arise` | Rares donjons géants remplis de mobs |
| Sparse Structures | `sparsestructures` | Espace les structures (évite la surcharge avec tous ces mods) |
| Structory | `structory` | Ruines et petites structures style vanilla |
| Structory: Towers | `structory-towers` | Tours style vanilla |
| Tidal Towns | `tidal-towns` | Villages sur l'océan |

**Utilitaires**

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| Universal Graves | `universal-graves` | Tombe qui garde le stuff à la mort |
| RightClickHarvest | `rightclickharvest` | Clic droit = récolter + replanter |
| Leaves Be Gone | `leaves-be-gone` | Les feuilles tombent tout de suite |
| FallingTree | `fallingtree` | Couper la base abat tout l'arbre |
| Grind Enchantments | `grind-enchantments` | La meule transfère les enchantements sur un livre |
| Textile Backup | `textile_backup` | Sauvegardes automatiques **pendant** que le serveur tourne |
| Better Than Mending | `better-than-mending` | Shift + clic droit : répare un objet Mending avec son XP |
| Élytre du slot | release GitHub `Nistroy/minecraft-elytra-slot-enchants` `v0.1.0` (pas Modrinth) | Mod maison : enchantements « torse seul » (Graviole) actifs sur l'élytre du slot Elytra Slot, coupés au retrait. Trinkets passe `inSlot = null` → `trinkets:slots` par datapack = NPE `idForSlot` au vol, d'où le mod. Ajouté 2026-09-27. `v0.2.0` (Recharge d'âme, boost Élytre des âmes) refusée : trop cheatée (nistroy 2026-09-30) → rester en `v0.1.0` |
| Duel | release GitHub `Nistroy/minecraft-duel` `v0.2.1` (pas Modrinth), `side = both` (`pack/mods/duel.pw.toml`) | Mod maison : `/duel <joueur> [arène] [mode]` (Accepter/Refuser/Regarder cliquables) ; client avec le mod → écran `/duel` (têtes, arène + aperçu, équipement ou kit), sans le mod → commandes seules. Kits Chevalier/Archer/Netherite (même kit pour les deux, emplacements Trinkets/Accessories vidés, tout rendu). Dimension vide `duel:arena`, pas de vraie mort, inventaire entier rendu, spectateurs en spectateur. Arène = schéma Kowal_96 « Blackstone Vault — The Molten Core » (Planet Minecraft, non versionné, droits de l'auteur) converti en `server/world/generated/duel/structures/molten_core.nbt` (`tools/litematic_to_structure.py` du dépôt du mod), posé par console `duel admin arene <id>`. Config `server/config/duel.json` (arènes + kits, défauts du jar ; v0.1 à plat supprimée 2026-10-04), aperçus `server/config/duel/previews/<id>.png` (copie `~/minecraft-tools/duel/previews/`). Ajouté 2026-09-30 ; `v0.2.0` serveur + pack 2026-10-04 ; `v0.2.1` (2026-10-04) corrige le crash serveur du 2026-10-04 03:50 (joueur rendu au retour de déconnexion en plein duel → présent dans 2 mondes → NPE `DistanceManager.removePlayer`). Écran non testé en jeu |
| Paliers Trinkets | release GitHub `Nistroy/minecraft-tiered-trinkets` `v0.2.0` (pas Modrinth), `side = both` | Mod maison, serveur + pack (client depuis 2026-09-28 : l'infobulle Trinkets « porté comme… » passe par `TrinketModifiers.get`, donc affiche le palier ; TieredZ seul n'affiche pas les gabarits `BODY`) : palier TieredZ d'un objet porté dans un emplacement Trinkets appliqué (mixin `TrinketModifiers.get*`). 102 paliers : bijoux Jewelry (thème du bijou, moitié des armes ; émeraude = Chance jusqu'à +2), sacs Traveler's Backpack (moitié armure), Élytre des âmes (copie élytre). Clé, carquois, charme, pêche exclus (nistroy 2026-09-28). `v0.2.0` (2026-09-30) : emplacements Accessories d'Aether aussi (`AdjustAttributeModifierCallback`) → Bouclier de répulsion (paliers du sac), Pierre de régénération (thème santé, ×2 = 2 bonus) ; reforge : gemme de zanite. Noms → pack `enchants-plus-lang`. Détails : `CLAUDE.md` du dépôt |
| Emplacements Trinkets figés | release GitHub `Nistroy/minecraft-trinkets-menu-fix` `v0.1.0` (pas Modrinth), serveur seul | Mod maison, corrige pertes/dupes des slots Trinkets (sac, cape, bijoux) depuis 2026-09-27 : écran accessoires d'Aether (`AetherAccessoriesMenu extends InventoryMenu`) → Trinkets recrée les inventaires, `player.inventoryMenu` garde les anciens jusqu'au relog. Rebranche après `update()`. `depends trinkets = 3.10.0` exact. Ajouté 2026-10-01. Détails : `CLAUDE.md` du dépôt, enquête `~/minecraft-tools/back-slot/ENQUETE.md` |
| Effets empilés Porting Lib | release GitHub `Nistroy/minecraft-effect-cures-fix` `v0.1.0` (pas Modrinth), serveur seul | Mod maison, corrige crash Porting Lib `3.1.0-beta.90` embarqué par Twilight Forest `4.8.629` : effet chargé de la sauvegarde + effet caché (Régénération II sur I) qui reprend → `ImmutableSet.clear()` → joueur éjecté « Internal server error » ou serveur arrêté (mob). 2026-10-01 : 2 éjections + 2 crashs serveur (squelette `1776 20 -1457`). Copie du correctif amont Porting-Lib#202, absent de TF `4.8.629`. `depends porting_lib_entity = 3.1.0-beta.90+1.21.1` exact → retirer quand TF embarque #202. Ajouté 2026-10-01. Détails : `CLAUDE.md` du dépôt |
| Boss Aether + Porting Lib | release GitHub `Nistroy/minecraft-aether-boss-fix` `v0.1.0` (pas Modrinth), serveur seul | Mod maison : boss Aether (Slider, Reine Valkyrie, Esprit du Soleil) absents des donjons générés depuis TF `4.8.629` (2026-09-30). Porting Lib `base` `3.1.0-beta.90` passe à `placeEntities` des entités déjà en coordonnées monde, Aether `1.5.11` les retransforme (détecte Porting Lib via `porting_lib_extensions`, absent) → boss hors structure, jamais placé. Correctif : liste brute rendue à Aether si processeur d'entités Aether. Donjons dont la salle a été générée entre 2026-09-30 et l'install (44 : 35 bronze, 7 argent, 2 or ; 614 tronçons) régénérés 2026-10-03 (validé nistroy), sauvegarde `pre-regen-aether-dungeons_2026-10-03_02h23` ; Slider vérifié en place après régénération ; outils `~/minecraft-tools/regen-troncons/`. `depends` exacts `aether 1.5.11` + `porting_lib_base 3.1.0-beta.90+1.21.1`. Ajouté 2026-10-03. Détails : `CLAUDE.md` du dépôt |
| Annihilation Recreated | `annihilation-recreated` | Boss Annihilation de Wynncraft (datapack emballé en mod, client optionnel). `r1.2.5_mc1.21.1+mod`. Ajouté 2026-09-27 (#idées) |

### 2.2 Serveur + joueurs (S+C)

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| Bosses of Mass Destruction | `bosses-of-mass-destruction` | 4 boss : Night Lich (biomes froids), Obsidilith (End), Gauntlet (Nether), Void Blossom (fond du monde) |
| The Aether | `aether` | Dimension céleste, 3 donjons + boss, mobs, équipement. Avec TF : boss absents sans le mod maison « Boss Aether + Porting Lib » |
| Aquamirae | `aquamirae` | Océan glacé, navire fantôme et boss |
| Deeper and Darker | `deeperdarker` | Prolonge les Anciennes Cités, nouvelle dimension derrière leur portail |
| Friends&Foes | `friends-and-foes` | Mobs des votes Mojang (golem de cuivre, crabe, glare, moobloom, rascal, mauler, iceologer, wildfire…) — chaque mob désactivable en config |
| Illager Invasion | `illager-invasion` | ~10 nouveaux illagers, fort, tour, labyrinthe, table d'imprégnation |
| Waystones | `waystones` | Pierres de téléportation |
| Farmer's Delight Refabricated | `farmers-delight-refabricated` | Cuisine, nouvelles cultures, dizaines de plats |
| Supplementaries | `supplementaries` | Blocs déco/pratiques style vanilla. `config/supplementaries-common.json` `plunderer.naval_raid_chance` = `0.0` (défaut `0.75`, 2026-10-01) : raid naval = vague sur l'eau en bateau (`NavalRaidSpawner`) → ferme à raid sur l'océan inutilisable |
| Traveler's Backpack | `travelersbackpack` | Sacs à dos (compat. Universal Graves déclarée) |
| Easy Anvils | `easy-anvils` | Plus de « Trop cher ! » à l'enclume |
| Trade Cycling | `trade-cycling` | Relancer les offres d'un villageois |
| Nature's Compass | `natures-compass` | Boussole qui trouve un biome choisi |
| Explorer's Compass | `explorers-compass` | Boussole qui trouve une structure choisie |
| Lootr | `lootr` | Chaque joueur a **son propre butin** dans les coffres de structures |
| Enhanced Celestials | release GitHub `Nistroy/minecraft-server` `pack-2026-09-21` (base `6.0.2.6-fabric`, patch sans popup annonce EC2) | Événements lunaires : lune de sang (plus de monstres), lune des moissons, lune bleue |
| Tide 2 | `tide` | Refonte de la pêche : poissons par biome, pêche dans la lave, carnet |
| Amendments | `amendments` | Améliorations de blocs vanilla, par l'auteur de Supplementaries |
| Handcrafted | `handcrafted` | Meubles style vanilla |
| Ribbits | `ribbits` | Villages de grenouilles dans les marais |
| Enchants Plus | `enchants-plus` | 18 enchantements + 4 malédictions « comme vanilla ». Serveur suffit : le mod n'a **aucun fichier de langue** (noms en anglais via `fallback`, pas de descriptions) → pack de ressources maison, voir §6 étape 9 |
| Easy Magic | `easy-magic` | La table d'enchantement garde les objets, relance possible. `server/config/easymagic-server.toml` : `enchantment_hint = "ALL"` (tous les enchantements visibles au survol ; défaut `SINGLE`, 2026-09-18) |
| Hardcore Revival | `hardcore-revival` | Au lieu de mourir, KO : les amis ont un temps limité pour te relever |
| Exposure | `exposure` | Appareils photo, pellicules, développement, tirages, albums, cadres |
| Immersive Melodies | `immersive-melodies` | Instruments pour jouer des mélodies, même à plusieurs |
| Immersive Paintings | `immersive-paintings` | Mettre ses propres images en tableaux |
| Macaw's Doors | `macaws-doors` | Dizaines de portes style vanilla |
| Macaw's Windows | `macaws-windows` | Fenêtres, rideaux, vitraux |
| Macaw's Bridges | `macaws-bridges` | Ponts |
| Dramatic Doors | `dramatic-doors` | Portes hautes (3 blocs) |
| Bountiful | `bountiful` | Tableaux de primes dans les villages : missions contre récompenses. Requiert Kambrik (§2.4) |
| Minecraft IA | release GitHub `Nistroy/minecraft-ia` `v0.2.0` (`pack/mods/minecraft-ia.pw.toml`, pas Modrinth) | Assistant IA : touche `I` / `/ia` ; `v0.2.0` = écran refait, icônes d'items, grilles de craft. Serveur : cerveau `~/minecraft-ia` doit tourner (tmux `ia`, lancé par `./mc start`), sinon `/ia` indisponible ; `server/mods/` `v0.2.0` depuis 2026-09-30. Ajouté 2026-09-13 |
| Barque à moteur | release GitHub `Nistroy/minecraft-motorboat` `v0.6.1` (`pack/mods/motorboat.pw.toml`, pas Modrinth) | Mod maison (§8) : bateau vanilla + moteur à combustible de four, soute, grande barque 6 places, 3 moteurs (16/24/32 bloc/s, −15 % sur la grande coque), coque 3D, hors-bord modélisés, houle. Pack + `server/mods/` en `v0.6.1` 2026-09-21 |
| Carte de l'aventurier | release GitHub `Nistroy/minecraft-adventure-map` `v0.2.0` (`pack/mods/adventure-map.pw.toml`, pas Modrinth) | Mod maison : carte au trésor de progression **par joueur** (7 régions dont Forêt du Crépuscule, 169 objectifs, indice par objectif, liste « À faire », sceaux, brouillard, récompenses à réclamer). Carte donnée à la 1re connexion, `/carte` pour la récupérer, aucune touche. Remplace FTB Quests (§4). Réglages sans release : `server/config/adventuremap/map.json` (copie de `default_map.json` du dépôt). Pack + `server/mods/` en `v0.2.0` 2026-09-30 (client et serveur même version : client v0.1 plante sur la condition `crafted`) |
| Comforts | `comforts` | Hamacs (dormir le jour pour passer la journée jusqu'au crépuscule) et sacs de couchage portables sans réinitialiser le point de spawn |
| Storage Drawers | `storagedrawers` | Tiroirs : 1 type d'objet par case, contenu + quantité affichés sur la face, clic pour prendre/déposer sans ouvrir d'interface. Capacités par défaut (lues dans le jar `13.11.4`) : 1×1 = 2048 objets, 1×2 = 1024/case, 2×2 = 512/case. Contrôleur = tri auto (`interactPutItemsIntoInventory` : clic droit → l'inventaire se range), `controllerRange` = 50, réseau découvert en largeur → les tiroirs doivent se toucher en chaîne (bandeaux = rallonge). Contrôleur IO (or) pour entonnoirs. Compare les composants NBT (`isSameItemSameComponents`) → inutile pour l'équipement enchanté. Ajouté 2026-09-22 |
| Elytra Slot | `elytra-slot` | Emplacement Trinkets dédié à l'élytre → plastron + élytre en même temps (torse reste possible). Intégré : Élytre des âmes (boost, Deeper and Darker), Wavey Capes ; tombe Universal Graves (`TrinketsCompat`). `9.0.1+1.21.1` + Trinkets `3.10.0`. Trinkets ≠ Accessories embarqué par Aether (`beta.48`) → 2 systèmes séparés ; couche `accessories-compat-layer` écartée (exige Accessories ≥ `beta.53`). Enchantements dans le slot : Trinkets applique ceux `any`/`armor` (Mending, Solidité, Skyguard) ; Graviole (`chest`) via mod maison Élytre du slot (§2.1). Ajouté 2026-09-27 (demande nemessvr, #idées) |
| Marium's Soulslike Weaponry | `mariums-soulslike-weaponry` | Boss + armes légendaires. Minerais moonstone/verglas et structures (ex. `soulsweapons:cathedral_of_resurrection`, 22,7 km du spawn test) : chunks neufs seulement. Deps AttributeFix (plafonds d'attributs → 1 000 000), GeckoLib `4.9.2` du pack (exige ≥ `4.7.6`). Ajouté 2026-09-27 |
| TieredZ | `tieredz` | Modificateurs aléatoires sur l'équipement (lib LibZ). Ajouté 2026-09-27. `config/tiered.json5` (hors dépôt) : `luckReforgeModifier` 0.02 → `0.05` (2026-09-28, nistroy) : au reforgeage, poids > max/3 (Commun, Peu commun, Rare) × (1 − 0,05 × Chance) ; Chance +7 max réaliste → Unique 1/73 (1/92 à 0.02, 1/107 sans Chance). Poids négatifs dès Chance ≥ 21 (hors d'atteinte). Chargé au démarrage seulement |
| RPG Series : Wizards, Archers, Paladins & Priests, Rogues & Warriors, Jewelry | `wizards`, `archers`, `paladins-and-priests`, `rogues-and-warriors`, `jewelry` | Classes, sorts (Spell Engine), runes, bijoux (slots Trinkets). `3.1.3` (Jewelry `2.5.0`). Filons de gemmes Jewelry : chunks neufs seulement (monde pré-généré r=2500). Ajouté 2026-09-27 |
| Better Combat | `better-combat` | Combat au corps à corps façon Minecraft Dungeons (combos, portée par arme). playerAnimator `2.0.4` remplace le `2.0.1` embarqué par Emotecraft (Fabric garde le plus récent). `server/config/bettercombat/server.json5` (hors dépôt, envoyé aux joueurs à la connexion, redémarrage requis) : `allow_attacking_thru_walls` `false` → `true` (sinon aucun coup à travers une demi-dalle ou un trou → ferme à gardiens intouchable ; issue GitHub BetterCombat #322), nistroy 2026-09-27. Affilage (Sweeping Edge) = seulement via le balayage refait (vanilla coupé, `allow_vanilla_sweeping: false`) : coup sur ≥ 2 cibles → dégâts × (1 − `penalty` × min(4, n−1)/4 + `penalty` × `player.sweeping_damage_ratio`) (`ServerNetwork`, bytecode 2.4.0) ; Affilage III = ratio 0,75 → +37,5 % sur 2 cibles, −12,5 % sur 5+. Garder `reworked_sweeping_maximum_damage_penalty` = `0.5` : à `0` Affilage ne sert plus à rien. Ajouté 2026-09-27 |
| Twilight Forest | CurseForge `227639`, fichier `8848279` (pas Modrinth ; `packwiz curseforge add --addon-id 227639 --file-id 8848279`) | Dimension forêt crépusculaire, boss en progression. Build Fabric officiel **bêta** `4.8.629` (2026-09-10) ; release = NeoForge seul. Embarque ~24 modules `3.1.0-beta.90` + ForgeConfigAPIPort `21.1.6` (= version du pack). Piège packwiz : `curseforge add` a réécrit `fabric-api.pw.toml` en version CurseForge → restauré. Test serveur 2026-09-27 (305 mods) : `Done` OK, `locate twilightforest:lich_tower` OK, chunky r=64 sans erreur ; installeur packwiz local : téléchargement CurseForge OK (sha1 identique). 5 WARN `non-existent data map type` (`transformation_powder`, `crumble_horn`, `ore_map_color`, `magic_map_color`, `ominous_fire`) → ces fonctions probablement cassées. Demandé nemessvr (#idées), validé nistroy 2026-09-27 |

### 2.3 Joueurs seulement (C)

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| Sodium | `sodium` | Moteur de rendu, gros gain de FPS |
| Iris | `iris` | Charge les shaders |
| Entity Culling | `entityculling` | N'affiche pas ce qui est caché |
| ImmediatelyFast | `immediatelyfast` | Rendu de l'interface/texte accéléré |
| FerriteCore | `ferrite-core` | Moins de RAM |
| ModernFix | `modernfix` | Démarrage plus rapide, moins de RAM |
| Dynamic FPS | `dynamic-fps` | Réduit les FPS quand le jeu est en arrière-plan |
| Zoomify | `zoomify` | Zoom |
| Xaero's Minimap | `xaeros-minimap` | Minimap |
| Xaero's World Map | `xaeros-world-map` | Grande carte |
| AppleSkin | `appleskin` | Saturation de la nourriture |
| Jade | `jade` | Nom du bloc/mob regardé |
| EMI | `emi` | Recettes (utile pour Farmer's Delight) |
| Mod Menu | `modmenu` | Menu « Mods » en jeu pour configurer les mods |
| Traveler's Titles | `travelers-titles` | Affiche le nom du biome/de la dimension en y entrant |
| Sodium Extra | `sodium-extra` | Plus de réglages graphiques pour gagner des FPS |
| Reese's Sodium Options | `reeses-sodium-options` | Menu des options graphiques plus clair |
| Mouse Tweaks | `mouse-tweaks` | Gestion de l'inventaire à la souris |
| Controlling | `controlling` | Recherche dans les touches |
| Amecs | `amecs` | Combinaisons de touches (Shift/Ctrl/Alt + touche) et plusieurs actions sur une même touche (ex. sprint + boost Élytre des âmes). `1.6.3+mc1.21.1` 2026-09-24, dépendances incluses dans le jar ; compatible Controlling (issue GitHub `Siphalor/amecs#119`, 1.21, 2026-06-30) |
| LambDynamicLights | `lambdynamiclights` | Une torche en main éclaire autour de soi |
| Complementary Reimagined | `complementary-reimagined` (**shader**, `pack/shaderpacks/`) | Shader livré avec le pack, **désactivé par défaut** (Iris sans shader actif ne coûte rien) : Options → Vidéo → Shader Packs. Eau réglée en style Unbound d'office (§6.9). `r5.9.3` 2026-09-20 |
| Fresh Animations | `fresh-animations` (**pack de ressources**) + `entitytexturefeatures` + `entity-model-features` | Animations des **mobs vanilla uniquement** (les mobs des autres mods gardent les leurs) |
| AmbientSounds | `ambientsounds` | Sons d'ambiance selon le biome |
| Sound Physics Remastered | `sound-physics-remastered` | Écho dans les grottes, sons étouffés |
| Emotecraft | `emotecraft` | Emotes visibles par les autres (serveur optionnel → l'installer aussi sur le serveur) |
| Do a Barrel Roll | `do-a-barrel-roll` | Élytre pilotée comme un avion (serveur optionnel) |
| Falling Leaves | `fallingleaves` | Feuilles qui tombent des arbres |
| Continuity | `continuity` | Textures connectées (vitres sans bordures) |
| Enchantment Descriptions | `enchantment-descriptions` | Explique chaque enchantement dans l'infobulle (traduit en français) |
| Not Enough Animations | `not-enough-animations` | Animations plus vivantes (manger, lire une carte…) |
| First-person Model | `first-person-model` | Voir son propre corps en vue à la 1re personne |
| Wavey Capes | `wavey-capes` | Capes qui flottent au vent |
| Presence Footsteps | `presence-footsteps` | Bruits de pas selon le bloc |
| Particle Rain | `particle-rain` | Pluie et neige en particules |
| Bobby | `bobby` | Garde les chunks déjà vus → voir plus loin sans charger le serveur |
| More Culling | `moreculling` | FPS en plus (feuillages, blocs cachés) |
| Better Advancements | `better-advancements` | Écran des progrès plus lisible |
| Advancement Plaques | `advancement-plaques` | Notifications de progrès plus jolies |
| Pick Up Notifier | `pick-up-notifier` | Affiche les objets ramassés (serveur optionnel) |
| Status Effect Bars | `status-effect-bars` | Durée des effets en barre |
| BetterF3 | `betterf3` | Écran F3 lisible |
| Chat Heads | `chat-heads` | Tête du joueur à côté de son message dans le chat |
| Subtle Effects | `subtle-effects` | Petits détails en particules (éclaboussures, étincelles…). `1.14.3` : crash éclaboussure de lave → pack `bahbeuh-fixes` (§6.9) |

### 2.4 Bibliothèques

À résoudre automatiquement (dépendances `required` de la version Fabric 1.21.1 de chaque mod, récursivement).
Relevé du 2026-09-12 (API Modrinth, dernière release) : fabric-api, fabric-language-kotlin, yungs-api, cloth-config,
geckolib, cardinal-components-api, puzzles-lib, forge-config-api-port, owo-lib, balm, moonlight, lithostitched,
cristel-lib, moogs-structure-lib, polymer, architectury-api, jamlib, resourceful-lib, fragmentum, corgilib,
data-anchor, resourceful-config, fzzy-config, cicada, trinkets ; 2026-09-27 : attributefix, bookshelf-lib, prickle, ranged-weapon-api, libz, runes, bundle-api (absent de la résolution packwiz, ajouté à la main), armor-model-api, structure-pool-api (serveur seul sur Modrinth mais requis par les `fabric.mod.json` RPG → `both`), spell-engine, spell-power, playeranimator ; pour les ⏳ seulement : yacl, kiwi.
Hors résolution auto : `kambrik` ≥ `8.0.0-beta.2`, requis par Bountiful (`fabric.mod.json`) mais absent de ses
dépendances Modrinth → à ajouter à la main (échec de démarrage sans, test 2026-09-12).

---

## 3. Suggestions au vote ⏳

Toutes vérifiées disponibles en Fabric 1.21.1, **aucune incompatibilité déclarée** avec la liste (vérifié le 2026-09-11).
**Installé** = sur le serveur depuis le 2026-09-12, avant la fin du vote (décision nistroy) ; rejet au vote → retirer +
régénérer le monde (§6). Sinon : ne pas installer.

| Mod | Slug | Côté | Ce qu'il apporte | Statut |
|---|---|---|---|---|
| Naturalist | `naturalist` | S+C | Animaux style vanilla (cerfs, ours, serpents, papillons, oiseaux…) | Installé |
| Crafting Tweaks | `crafting-tweaks` | S+C (optionnels) | Répartir/vider/tourner la grille de craft en un clic | Installé |
| Visual Workbench | `visual-workbench` | S+C | Objets visibles sur l'établi, qui les garde | Installé |
| Critters and Companions | `critters-and-companions` | S+C | Petits animaux (loutres, pandas roux, koïs, libellules…) | Installé |
| BlazeandCave's Advancements | `blazeandcaves-advancements-pack` | S (**datapack** → `world/datapacks/`) | +1 000 progrès, 16 onglets | Installé (`BlazeandCave's Advancements Pack 1.17.2.zip`) |
| Better Archeology | `better-archeology` | S+C | Plus d'archéologie (structures, blocs suspects, 3 enchantements) | Retiré du pack de base (test en jeu 2026-09-12) ; peut revenir : objets partout, structures seulement dans les chunks jamais générés |
| Snow! Real Magic! | `snow-real-magic` | S+C | Neige qui s'accumule, recouvre escaliers/dalles/clôtures (lib Kiwi) | Installé |

Rappel enchantements : Dungeons and Taverns (✅) ajoute déjà des enchantements uniques et Illager Invasion (✅)
sa table d'imprégnation. **Un seul pack d'enchantements** (Enchants Plus ✅) : les packs ne gèrent pas les exclusivités entre eux.
Datapack maison `world/datapacks/starlight-bow-enchants/` (hors dépôt, 2026-09-23) — Starlight Bow (Tide) :
- Étoile flèche `tide:star_arrow` : vitesse 2,5 (flèche 3,0) → 5 dégâts au lieu de 6 ; vit 50 ticks ; détruite au 1er contact (pas de perforation) ; mixin Tide `ProjectileWeaponItemMixin` : 60 % → 1 flèche gratuite, saute `ammo_use`/`projectile_count` vanilla (source : bytecode Tide 2.1.1).
- Enchants+ Puissance/Précision/Toxique/Rafale de vent étendus à l'arc (copies de `power.json`, `precision.json`, `toxic.json`, `breeze_burst.json` → resynchroniser si Enchants+ mis à jour). Puissance/Précision/Toxique : `supported_items` = tag `starbow:enchantable/ranged` (`#enchantable/bow` + `#enchantable/crossbow`) depuis 2026-09-30 ; avant, liste arc/arbalète/arc aux étoiles → grands arcs Archers + arcs/arbalètes moddés refusés à l'enclume. Puissance, Frappe (`punch.json` vanilla copié), Toxique : sans effet sur joueur touché par étoile ; Rafale de vent = `hit_block` seulement.
- `starbow:etoile_filante` I-III, recette Tide surchargée → arc crafté niveau I ; I+I / II+II à l'enclume ; incompatible Infinité (déjà applicable via `#enchantable/bow` de Tide). I : +1 base (×2,5), lueur, joueur touché → 1-2 PV (minimum pour déclencher `post_attack`) puis Soin instantané I (III : II) + Résistance au feu 6 s (contre Flamme), particules. II : 80 % munitions, Marque +1 vs cible lumineuse, Absorption 5 s tireur (II : I, III : II ; Régén testée en jeu 2026-09-24 = trop faible), vision nocturne en main (21 s, rafraîchie /200 ticks), téléportation : Shift + Q (stat `minecraft.dropped:tide.starlight_bow` + `starbow:sneaking`) pendant le vol ou ≤ 1,5 s après l'impact (marqueur relié au tireur par `starbow.id` ; étoile à 2,5 blocs/tick → impact trop rapide pour Q avant) → arc remis en main même si refusée, tp à l'impact ; Q seul = lancer normal ; 5 dégâts `minecraft:fall` + ~2 faim, refusée si faim ≤ 6, recharge 15 s ; boucle programmée seulement pendant le vol. III : infini, Chasseur +2 vs `#starbow:celestial`, pluie d'étoiles (tir accroupi, 7 étoiles en 3,5 s, recharge 45 s via `time query gametime`, pas de tick).
- Lore des paliers : recette (lignes = chaînes JSON, sinon recette en erreur) + `starbow:lore` (`item modify entity <joueur> weapon.mainhand starbow:lore`) → garder les deux identiques.
- Piège : tireur d'un projectile = `execute on origin` (`on owner` = animaux apprivoisés/vex/crocs, vide pour une flèche) ; `projectile_spawned` s'exécute dans le constructeur (propriétaire pas encore posé → tireur = `@p[distance=..2]`).
- Paliers = `random_chance` + `enchantment_level` lookup. Enchantements = registre dynamique → **redémarrage requis**, `/reload` ne suffit pas (recette en erreur tant que l'enchantement n'est pas chargé). Validé sur serveur vanilla 1.21.1 jetable (ids Tide remplacés).
Datapack maison `world/datapacks/enchantsplus-perf/` (hors dépôt, 2026-09-23) : surcharge `enchantsplus:tick` (lag, `PERF.md` §Enchants Plus) → à régénérer si Enchants+ mis à jour.
Datapack maison `world/datapacks/soul-elytra-enchants/` (hors dépôt, 2026-09-24) : copies de `graviole.json` + `skyguard.json` (Enchants+) avec `supported_items` = `minecraft:elytra` + `deeperdarker:soul_elytra` (original : élytre vanilla seule → enclume refuse l'Élytre des âmes ; effets indépendants de l'objet). Redémarrage requis ; resynchroniser si Enchants+ mis à jour.
Datapack maison `world/datapacks/spell-imbuing/` (hors dépôt, 2026-09-28, nistroy) : ajoute les 8 enchantements Spell Power (`spell_power`, `haste`, `critical_chance`, `critical_damage`, `sunfire`, `soulfrost`, `energize`, `magic_protection`) au tag `#illagerinvasion:imbuing` (`required: false`) → table d'imprégnation : livre à 1 seul enchantement, au niveau max → max + 1 (`ImbuingMenu`, bytecode Illager Invasion `21.1.6`). Testé `test-server` : pack activé, aucune erreur de tag. Tags → `/reload` suffit (pas un nouvel enchantement).
Datapack maison `world/datapacks/spell-vi-boost/` (hors dépôt, 2026-09-29, nistroy ; source + `generate.py <jar Spell Power>` dans `~/minecraft-tools/staging/spell-vi-boost/`) : surcharge 7 enchantements Spell Power `1.6.0` (`sunfire`, `soulfrost`, `energize`, `spell_power`, `critical_chance`, `critical_damage`, `haste`), montant `minecraft:linear` → `minecraft:lookup` : niveaux I-V inchangés, **VI (imprégnation) = 1,6 × V** (ex. Sunfire +15 % → +24 % au lieu de +18 %), `fallback` = linéaire d'origine. Pourquoi : VI linéaire = +1 % de dégâts par robe, invisible (vérifié en jeu 2026-09-29). `magic_protection` non touché (protection, pas un attribut). Enchantement = registre dynamique → redémarrage requis ; relancer `generate.py` si Spell Power mis à jour. Chargé au redémarrage du 2026-09-30 (démarrage propre, erreurs identiques au précédent) ; valeur en jeu (Sunfire VI = 0,24) à vérifier sur un joueur connecté.
Datapack maison `world/datapacks/mage-looting/` (hors dépôt, 2026-09-28, nistroy ; source `~/minecraft-tools/staging/mage-looting/`) : surcharge `minecraft:looting` (copie vanilla 1.21.1) → `supported_items` = `#magelooting:looting` (`#minecraft:enchantable/sword` + `#wizards:staves` + `#wizards:wands`, `required: false`) → Butin à l'enclume sur bâtons/baguettes Wizards. `primary_items` = `#minecraft:enchantable/sword` (sinon la table le propose sur les bâtons). Butin lu sur la main principale de l'attaquant (`enchanted_count_increase`) → kills par sort comptent. Enchantement = registre dynamique → redémarrage requis ; resynchroniser si MC mis à jour. 2026-09-30 : trouvé dans la liste `Disabled` de `level.dat` (ajouté 2026-09-28 21:16 serveur lancé, jamais chargé ; un pack désactivé ne se réactive pas au démarrage) → `datapack enable "file/mage-looting"` + redémarrage.
Datapack maison `world/datapacks/mage-staff-tiers/` (hors dépôt, 2026-09-28, nistroy ; source + `generate.sh` dans `~/minecraft-tools/staging/mage-staff-tiers/`) : TieredZ `1.3.7` n'a aucun palier pour les bâtons/baguettes Wizards → reforge refusé (`getRandomAttributeIDFor` null). 96 fichiers `item_attributes` générés depuis `melee_weapons/*` du jar (mêmes poids/valeurs) : `generic.attack_damage` → `spell_power:<école>` (feu, arcane, givre ; les 3 pour `staff_wizard` + `aether_wizard_staff`), `tiered:generic.crit_chance` → `spell_power:critical_chance` `ADD_MULTIPLIED_BASE`, portée (unique) → `spell_power:haste` +0,1. Verifiers par `id` (objets absents ignorés). Base de reforge = ingrédient de réparation (`StaffItem extends ToolItem`) : netherite, or (feu/arcane), fer (givre), bâton (novice/sorcier), `aether:ambrosium_shard` (Aether : forcé par `data/tiered/reforge_items/aether_wizard_staff.json`, prioritaire sur l'ingrédient de réparation dans `ReforgeScreenHandler` ; sans lui, lingot de netherite car `WizardWeapons.ingredient()` Wizards `3.1.3` inverse sa condition `isModLoaded("aether")`, constaté en jeu 2026-09-30, activé par `/reload`). Noms `<id>.label` côté client → pack `enchants-plus-lang`. Activé par `/reload` 2026-09-28 (3 joueurs) : `Loaded 240 tiers`, TieredZ renvoie les paliers aux clients (`END_DATA_PACK_RELOAD`). Mettre à jour TieredZ → relancer `generate.sh`.
Datapack maison `world/datapacks/captain-bottles/` (hors dépôt, 2026-10-02, nistroy ; source `~/minecraft-tools/staging/captain-bottles/`) : surcharge `minecraft:entities/pillager` + `vindicator` (copies vanilla 1.21.1) → capitaine = 1 fiole sinistre (amplificateur 0-4 = I-V), **en raid ou non**. Pourquoi : (1) `RaiderPredicate` vanilla : `has_raid` vaut `false` par défaut et doit être égal ; `Raider.hasRaid()` = raid actif à ≤ 96 blocs → capitaines de raid jamais de fiole, seuls ceux de patrouille (bytecode) ; condition remplacée par `any_of` `has_raid` false/true. (2) Capitaine de vague = 1er raider créé dans l'ordre `RaiderType` (vindicateur avant pillard) → vagues 2, 4, 5 toujours vindicateur, 1 et 3 à 50 % (bonus normal `nextInt(2)`) ; vindicateur vanilla sans fiole → pool ajouté. Maraudeur (Illager Invasion) non touché. Aucun mod ne touche ces 2 tables (chemins absents des jars). `/reload` suffit. Resynchroniser si MC mis à jour.
Config `server/config/wizards/equipment_v2.json` (hors dépôt, serveur seul) : robes netherite (arcane, feu, givre) = armure d'origine du jar `1/3/2/1` (7) + `armor_toughness` 1.0 et `knockback_resistance` 0.025 par pièce (jar : 0 et 0). 2026-09-30, nistroy : armure `2/4/3/2` (11) retirée → boost léger façon netherite vanilla (ténacité, pas d'armure). Pourquoi : robes Unique (+16) + sac + élytre dépassaient déjà 20 d'armure efficace. Armure non plafonnée à 30 : AttributeFix (`config/attributefix/minecraft/generic.armor.json`, max 1e6) ; réduction plafonnée à 80 % par le calcul vanilla. Redémarrage requis.

---

## 4. Écartés

Mods proposés et **refusés** — ne pas installer sans nouvelle demande.

| Mod | Raison |
|---|---|
| Artifacts | Rend le jeu trop facile |
| Mutant Monsters | Trop « monstres de film », loin du vanilla |
| Creeper Overhaul | Remplace le creeper vanilla |
| L_Ender's Cataclysm | NeoForge uniquement ; l'End est déjà couvert |
| Mowzie's Mobs | NeoForge uniquement ; pas indispensable |
| Simple Voice Chat | Le groupe utilise Discord |
| Enderscape | Incompatible avec Nullscape (un seul mod de terrain de l'End) |
| Enchantments Encore | Enchants Plus choisi à la place (un seul pack d'enchantements) |
| Serene Seasons | « Peut-être plus tard » — change trop le rythme des cultures pour l'instant |
| Discord MC Chat | Non retenu (pont chat Minecraft ↔ Discord) |
| Ledger | Non retenu (journal anti-grief / rollback) |
| BlueMap | Non retenu (carte 3D web, demanderait un tunnel en plus) |
| Comforts | Non retenu (sacs de couchage, hamacs) |
| Carry On | Non retenu (porter coffres et animaux) |
| Inventory Profiles Next | Non retenu (Mouse Tweaks choisi) |
| Shulker Box Tooltip | Non retenu |
| Distant Horizons | Non retenu (très gourmand) |
| End Remastered | Trop compliqué ; 4 de ses sources d'yeux sont des structures refaites par YUNG's → quête risquée |
| Wilder Wild | Empiète sur Terralith et Friends&Foes (crabes en double) |
| Tough As Nails | Température et soif : change trop le jeu |
| Better Clouds | On utilise des shaders, qui dessinent déjà leurs propres nuages |
| 3D Skin Layers, Every Compat, Diagonal Fences, Diagonal Walls, Rechiseled, [Let's Do] Vinery | Pas envie |
| More Armor Trims, Elytra Trims | Pas envie |
| Shippy Ships | Testé en jeu 2026-09-20 (`1.0.18`, dep IngeniumAPI) : charge propre avec le pack, navires OK. Écarté : vitesse ~1,4-1,6× vanilla seulement, construction en 5 paliers jugée pénible, on reste assis (pas de pont praticable, issue GitHub #2 ouverte). Projet jeune (publié 2026-04-15), source non publique, branche 1.21.1 figée à `1.0.18` |
| Fish 'N' Ships | Testé 2026-09-20 (`1.1.0`) : le grand `ship` n'accepte **qu'un seul passager** (`ShipEntity.canAddPassenger` = `passengers.isEmpty()`), le pont n'est qu'une hitbox `ShipCabinPart` qui ne transporte pas les entités debout → inutile pour voyager en groupe. Licence All Rights Reserved |
| Small Ships | Fabric 1.21.1 seulement en beta `2.0.0-b2.1` (2024-11-26), branche morte depuis. Non testé |
| Sable / Eureka (navires en blocs) | Pas de build 1.21.1 pour Eureka. Sable existe (`1.21.1`) mais aucun assemblage en survie (commande `/sable`) et l'auteur le décrit « incredibly intrusive » |
| Bullets Boats, Faster Boats, Seaworthy Boats | Écartés au profit d'un mod maison (§8) : gros canot ou simple multiplicateur de vitesse, pas des navires |
| Macaw's Lights and Lamps / Trapdoors / Fences and Walls, Beautify, Another Furniture, Cooking for Blockheads | Pas fan des mods de déco supplémentaires |
| Reactive Music | AmbientSounds suffit pour l'ambiance sonore |
| Visuality | Pas fan (et doublon avec Subtle Effects) |
| Reinforced Chests | Coffres vanilla suffisent (test en jeu 2026-09-12) |
| Tom's Simple Storage | Pas réussi à le faire marcher, pas indispensable (test en jeu 2026-09-12) |
| Macaw's Roofs | Pas voulu (nistroy, 2026-09-12) |
| Anti Enderman Grief | Pas voulu (nistroy, 2026-09-12) |
| Galosphere | Avec Terralith, ses 3 biomes souterrains ne génèrent pas (`locate biome` échoue, témoins vanilla OK ; Terralith `dimension/overworld.json` = liste explicite `minecraft`/`terralith`) → ses mobs, blocs et sanctuaire disparaissent, restent ruines + palladium. Sous-sol déjà couvert : Terralith (11 biomes `cave/`) + Tectonic (grottes, rivières souterraines). Test 2026-09-12 |
| Spelunkery | `0.4.4` + Moonlight `3.6.4` : 63 `Failure adding generated resources … NoSuchElementException` (loot + worldgen des minerais), aussi seul → bug du mod. Écrase en plus des loots d'autres mods (Pyrolysis d'Enchants Plus sur 4 minerais deepslate, Wither d'Incendium). Test 2026-09-12 |
| FTB Quests (+ FTB Library, FTB Teams) | Livre de quêtes d'exploration installé 2026-09-20, retiré le jour même sur demande de nistroy. Ne pas réinstaller sans nouvelle demande |
| *(indisponibles en Fabric 1.21.1)* | Blue Skies, Alex's Mobs, Bosses'Rise, RPG Style More Weapons, The Undergarden, EEEAB's Mobs, Betweenlands (Forge/NeoForge seuls, vérifié 2026-09-27), Etched, Sophisticated Backpacks, Moog's End/Nether Structures, Twigs, More Villagers, Croptopia, Iron Chests, Double Shulker Shells |

---

## 5. Compatibilité et consommation

Vérifié sur Modrinth le 2026-09-11 :
- **Aucune incompatibilité déclarée** entre les mods de la liste (✅ et ⏳).
  Seule exception : LambDynamicLights est incompatible avec *d'autres* mods de lumière dynamique — aucun dans la liste.
- Compatibilités déclarées : YUNG's Better End Island ↔ Nullscape (« complètement compatible »),
  Traveler's Backpack ↔ Universal Graves, Farmer's Delight ↔ EMI, Terralith ↔ Tectonic.

Points à régler / tester à l'installation :
1. **Illusionner en double** : Friends&Foes et Illager Invasion le modifient tous les deux.
   → `config/friendsandfoes.json` : `"enableIllusioner": false` (nom vérifié dans le fichier généré, test 2026-09-12).
   Autres clés F&F laissées par défaut : `enableIllusionerSpawn`, `enableIllusionerInRaids`, `replaceVanillaIllusioner`,
   `generateIllusionerShackStructure`, `generateIllusionerTrainingGroundsStructure` (structures F&F `illusioner_shack`,
   `illusioner_training_grounds`, en plus de `illagerinvasion:illusioner_tower`). Effet de `enableIllusioner` sur ces structures : non vérifié.
2. **Villages** CTOV + Towns and Towers : cohabitent, pas de doublon gênant (test en jeu 2026-09-12).
3. **Densité** : Sparse Structures espace assez (test en jeu 2026-09-12, survol du spawn).
4. **End** : île YUNG's + Obsidilith OK avec Nullscape (test en jeu 2026-09-12). Progrès « The End... Again? » obtenu au
   1er dragon : cause probable = YUNG's fait apparaître le dragon par sa propre séquence de respawn (`DragonRespawnStage`,
   `EndDragonFightMixin` dans le jar) ; aucun ticket GitHub. Sans gravité.
5. **Fresh Animations × Illusionner** (Illager Invasion le redessine) : OK (test en jeu 2026-09-12).
6. Tests 2026-09-12 :
   - Serveur (`TEST-MODS.md`, runs A/B) : démarrage OK après Kambrik + C2ME Java 21, aucun `Mixin apply failed`.
     → points 1, 7-8, Galosphere/Spelunkery (§4), mesures (Consommation). Lot final (110 jars) : 258 mods, 19 `locate` OK
     (5 dimensions), pré-gén sans nouvelle erreur.
   - Client (`bahbeuh-test-2026-09-12.mrpack`, Windows, RTX 4060 portable) : 256 mods, ~150 FPS sans shaders, ~100
     Complementary Reimagined, ~80 avec mobs ; 1 crash Subtle Effects → `bahbeuh-fixes` (§6.9).
   - En jeu (`12b`, `test-server/` `world-C`, checklist 52 points : biomes, 5 dimensions, structures de chaque mod, boss,
     raid, mobs, pêche Tide, rangement, emotes, lunes, explosions) : 47 OK, 0 crash client/serveur, TPS ~20 ;
     `Can't keep up` seulement en tp vers des chunks neufs. Points ouverts : point 9.
   - Installation `server/` 2026-09-12 : 103 jars du lot testé (sha512 = `versions-testees.tsv`), sans Reinforced Chests,
     Tom's Storage, Macaw's Roofs, Anti Enderman Grief (§4), Better Archeology, Storage Drawers (ajouté depuis, §2.2) ; Subtle Effects (C) retiré.
     Démarrage OK (249 mods), aucune ERROR nouvelle vs test, datapack BlazeandCave's chargé, configs §6 étape 6 faites.
     Pack joueurs `client-pack/bahbeuh-2026-09-12.mrpack` = `12d` moins ces mods (110 fichiers).
7. **`/locate`** : vanilla = thread principal, jusqu'à ~25 s pour une structure rare → plusieurs à la suite = watchdog
   60 s → crash (test en jeu 2026-09-12, crash réel 2026-09-13 02:05).
   → Corrigé 2026-09-13 : Async Locator Refined `1.21.1-1.6.0` (`config/asynclocator.properties` par défaut, 2 recherches
   simultanées) + `max-tick-time=180000`. Vérifié : `engineer_tower` 41,8 km = 17,9 s sur `asynclocator-1`, `list` répond
   pendant, aucun `Can't keep up`. Non couvert : recherches lancées par d'autres mods (page Modrinth : vanilla seulement), ex. Explorer's/Nature's Compass.
   YUNG's remplace la mine vanilla : `locate structure #bettermineshafts:better_mineshafts`.
8. **Bountiful** : pools de compat Farmer's Delight / Supplementaries (`chef_*`, `carpenter_*`) rattachés à aucun décret
   → ces primes n'apparaissent pas (`config/bountiful/errors.log`). Sans gravité.
9. **Test en jeu 2026-09-12, points ouverts** :
   - Continuity : verre non connecté → pack intégré désactivé par défaut ; OK une fois activé à la main → activé dans le
     `.mrpack` dès `12d` (§6.9).
   - Touche `B` par défaut pour 4 actions (relevé des jars) : roue Emotecraft, nouveau waypoint Xaero (a pris le dessus),
     inventaire Traveler's Backpack, terminal Tom's Storage (écarté) → `.mrpack` dès `12d` : waypoint `N`, sac `H` (§6.9).
     Autres touches partagées, non signalées en jeu, laissées telles quelles : `C` Zoomify + Trade Cycling (écran villageois)
     + barre d'outils vanilla ; `Z` carte Xaero + outil du sac ; `O` Iris + emote debug ; `I` accessoires Aether + Do a Barrel
     Roll ; `F6` First-person Model + Zoomify.
   - Subtle Effects : TNT dans la lave = particules vanilla seules. Normal : `ExplosionMixin` lit `splash_type`, retiré de
     la lave par `bahbeuh-fixes` ; revient avec le retrait du pack.
   - Traveler's Backpack : « à voir » (nistroy) → sondage.
   - Non testés : brossage Better Archeology (camp d'archéologue sans bloc suspect ; il y en a dans `underwater_*`, `mott`,
     `desert_obelisk`), Lootr (butin par joueur, il faut 2 joueurs).
   - Sans gravité : navire pirate Aquamirae pris dans la glace ; légère baisse de FPS au Mechanical Nest (When Dungeons Arise).
   - Log serveur sans effet visible : 24 `Couldn't find template pool reference: dungeons_arise:mechanical_nest/mechanical_nest_decoration` ;
     CTOV `kaisyn:village/beach_lighthouse/villager_lighthouse_master` (phare de plage) et `Empty or non-existent pool: minecraft:`
     (grand village de plaine) ; ERROR `Block-attached entity at invalid position` et `Failed to parse vibration listener for
     Sculk Sensor` en génération, source non identifiée.
   - AmbientSounds = mod, pas pack de ressources : visible dans Mod Menu, pas dans Packs.
10. **Lot 2026-09-27** (Elytra Slot, Soulslike, Annihilation, TieredZ, RPG Series, Better Combat + 13 libs) : `test-server/`
    run léger (`world-farm`, `MEM="3G"`, nice) = mods du live + 23 jars. 280 mods, `Done (6.856s)`, aucune ERROR/WARN venant
    des nouveaux mods (ERROR = bruit connu : Dungeons Arise, Dramatic Doors, Supplementaries), `locate structure
    soulsweapons:cathedral_of_resurrection` OK (async 4,5 s), TPS 20, arrêt propre. Live : 1 `Can't keep up` 2 s au démarrage du test.
    Non testé : en jeu (client, touches, combat), aucun `incompatible` déclaré sur Modrinth.

---

### Compatibilité des mods graphiques / sonores (côté joueurs)
- Sodium, Iris, Sodium Extra, Reese's Sodium Options, Continuity, LambDynamicLights, EMF/ETF : tous prévus pour
  Sodium ; Sodium Extra et Reese's déclarent l'intégration Iris. **Contrainte : Iris exige une version précise de Sodium.**
  Paire vérifiée 2026-09-12 (`fabric.mod.json`) : Iris `1.8.14-beta.1+mc1.21.1` (dépend `sodium 0.8.x`) + Sodium `0.8.13`
  (casse Iris `<1.8.13`). Iris release `1.8.8` veut Sodium `0.6.x` → exclu : Sodium Extra, Reese's (dépendent Sodium ≥ `0.8.12`),
  More Culling (casse ≤ `0.6.13`), Supplementaries (casse < `0.8.12-beta.1`).
- LambDynamicLights n'est incompatible qu'avec d'autres mods de lumière dynamique (Sodium Dynamic Lights, RyoamicLights) — aucun ici.
- Shaders + LambDynamicLights : Complementary a sa propre lumière en main → effet en double, en désactiver un des deux.
- Sound Physics Remastered + AmbientSounds : compatibles (SPR traite aussi les sons d'ambiance).
- Not Enough Animations + First-person Model : même auteur, prévus pour aller ensemble.
  À tester avec Emotecraft (emotes vues à la 1re personne).- Enchants Plus + enchantements de Dungeons and Taverns : cohabitent, sans exclusivités entre eux (ceux de DnT sont rares).
- **Enchantment Descriptions × enchantements des mods** (jars inspectés le 2026-09-11) : si une description manque,
  le mod n'affiche **rien** (pas de bug, pas de clé brute). Couverture :
  Dungeons and Taverns 13/13 (les 3 autres sont internes aux boss), Deeper and Darker 2/2, Better Archeology 3/3,
  Supplementaries 1/1 — **Enchants Plus 0/22** et Farmer's Delight « Backstabbing » 0/1 → à combler par le pack maison.

### Consommation

**Côté joueurs (FPS)**, du plus gourmand au plus léger :

| Mod | Impact | Si ça rame |
|---|---|---|
| Shaders (via Iris) | 🔴 très fort (carte graphique) | Désactiver ou preset bas. Iris sans shader actif ne coûte rien |
| Fresh Animations (EMF/ETF) | 🟠 moyen (processeur), surtout près des villages et fermes à mobs | Retirer le pack de ressources |
| Sound Physics Remastered | 🟠 moyen (processeur) : calcule la propagation de chaque son | Baisser la qualité dans sa config |
| LambDynamicLights | 🟠 moyen, avec beaucoup de sources de lumière qui bougent | Mode « Fast », ou désactiver pour les entités |
| Falling Leaves | 🟡 léger à moyen dans les forêts denses | Réduire le taux de feuilles |
| Relief Terralith/Tectonic | 🟡 plus de géométrie à afficher | Baisser la distance de rendu |
| Xaero's World Map | 🟡 léger (processeur/RAM en exploration) | — |
| Mobs animés des mods, blocs animés (Supplementaries, Amendments, Handcrafted) | 🟢 léger | — |
| Particle Rain | 🟡 léger, plus lourd pendant les orages | Réduire la densité |
| Bobby | 🟡 un peu plus de RAM et de disque | Limiter la taille du cache |
| Continuity, AmbientSounds, Emotecraft, Do a Barrel Roll, Zoomify, Jade, AppleSkin, EMI, Traveler's Titles, Not Enough Animations, First-person Model, Wavey Capes, Presence Footsteps, Better Advancements, Advancement Plaques, Pick Up Notifier, Status Effect Bars, BetterF3 | 🟢 négligeable | — |

Gains : Sodium, Entity Culling, More Culling, ImmediatelyFast, Sodium Extra (couper particules/animations), Dynamic FPS,
ScalableLux, FerriteCore/ModernFix (RAM). RAM à allouer aux joueurs : **6 Go** (4 Go minimum sans shaders).

**Côté serveur (Mac mini M1)** : causes de lag et de crash observées en jeu → `PERF.md`.

| Mod | Impact | Parade |
|---|---|---|
| Génération (Terralith, Tectonic, ~20 mods de structures) | 🔴 fort, **uniquement** en générant de nouveaux chunks | C2ME + pré-génération Chunky |
| Textile Backup | 🟠 pic processeur pendant la compression | 1×/2 h, seulement si des joueurs sont connectés |
| FallingTree | 🟡 petit pic en abattant un arbre géant | Limite de taille dans sa config |
| Enhanced Celestials | 🟡 lune de sang = plus de mobs pendant une nuit | — |
| Mobs des mods (Friends&Foes, Illager Invasion, boss) | 🟡 un peu plus d'entités | Lithium |
| Lootr | 🟢 négligeable (une copie de coffre par joueur, un peu de disque) | — |
| Exposure, Immersive Paintings | 🟢 processeur négligeable ; photos et images stockées dans le monde (disque) | Surveiller la taille du monde |
| Structory, Tidal Towns | inclus dans le coût de génération ci-dessus | Pré-génération |

Mesuré 2026-09-12 (`test-server/`, `MEM="6G"`, 0 joueur, lot complet, C2ME `0.3.0+alpha.0.364`) :

| | Run A (Galosphere) | Run B (Spelunkery) | Lot final (vanilla en marche) |
|---|---|---|---|
| Chunky Overworld r=500 (4225 chunks) | 1 min 24 (~50 chunks/s) | 1 min 46 | 1 min 19 |
| Nether / End r=250 (1089 chunks chacun) | 29 s / 20 s | 21 s / 19 s | 28 s / 21 s |
| Pendant génération : TPS, tick méd./95 %/max | 20 · 1,4 / 6 / 182 ms | 20 · 1,2 / 4,8 / 35 ms | 20 · 1,6 / 6,2 / 19 ms |
| RAM pendant / après | 4,1 / 3,1 Go sur 6 | 3,8 / 3,5 Go sur 6 | 4,2 / 3,4 Go sur 6 |
| Monde après pré-gén | 115 Mo | 90 Mo | 103 Mo |

→ Install réelle 2026-09-12 : `chunky radius 2500` Overworld = 99 225 chunks en 29 min 23 (~56 chunks/s) ; après :
TPS 20, tick méd./95 %/max 0,7 / 3,4 / 379 ms (1 min), RAM 3,9 / 6 Go, monde 1,5 Go.

---

## 6. Procédure d'installation (pour l'agent)

Test préalable sur instance jetable : `TEST-MODS.md`. Ses versions testées (`versions-testees.tsv`, racine) priment sur l'étape 2. Procédure faite le 2026-09-12 (§5 point 6).
Contexte technique : voir `README.md` (tout se pilote avec `./mc`, Java 21 forcé dans `start.sh`).
Sur ce Mac, **Python `urllib` échoue en SSL** → utiliser `curl` pour l'API Modrinth.

1. `./mc stop` puis `./backup.sh`.
2. Télécharger **uniquement les ✅ de côté S et S+C** + leurs bibliothèques dans `server/mods/` :
   - API : `https://api.modrinth.com/v2/project/<slug>/version?loaders=["fabric"]&game_versions=["1.21.1"]`
     → prendre la version la plus récente, fichier `primary`, vérifier le `sha512`.
   - Résoudre récursivement les dépendances `required`.
   - **Ne jamais** mettre les mods C (Sodium, Iris…) sur le serveur.
3. `start.sh` : `MEM="4G"` → `MEM="6G"`.
4. Nouveau monde : renommer `server/world` en `server/world-vanilla-old` (ne pas supprimer).
5. `./mc start`, suivre `./mc log` : aucune erreur de chargement, aucun conflit de mixin. Corriger avant d'aller plus loin.
6. Configs : point 1 de la section 5 (Illusionner) ; Textile Backup → sauvegarde auto toutes les heures
   quand des joueurs sont connectés, rotation limitée (ex. 10), dossier `~/minecraft-server/backups/` ; puis redémarrer.
   Règle de jeu validée : `./mc cmd "gamerule playersSleepingPercentage 1"` (un seul joueur qui dort suffit).
   Scoreboards validés (2026-09-12), stockés dans le monde → à faire après sa recréation, pas avant :
   `./mc cmd 'scoreboard objectives add morts deathCount "Morts"'` + `./mc cmd "scoreboard objectives setdisplay list morts"` (morts dans Tab) ;
   `./mc cmd 'scoreboard objectives add vie health "PV"'` + `./mc cmd "scoreboard objectives setdisplay below_name vie"` (PV sous le pseudo).
7. Tests console : `/locate biome` (Terralith), `/locate structure` (YUNG's, CTOV, Towns and Towers, BoMD) ;
   pour l'End : `execute in minecraft:the_end run locate structure …`.
8. Pré-génération en arrière-plan : `chunky radius 2500` puis `chunky start` (peut prendre plusieurs heures).
9. Pack joueurs = packwiz dans `pack/` (source de vérité, S+C + C + leurs bibliothèques ; mods S hors pack).
   Amis mis à jour à chaque lancement (§7) depuis `https://raw.githubusercontent.com/Nistroy/minecraft-server/main/pack/pack.toml`
   → changement visible des amis seulement après merge sur `main` (dépôt public, requis pour ce lien).
   - Outil : `~/go/bin/packwiz` (`go install github.com/packwiz/packwiz@latest`, pas de formule brew). Commandes depuis `pack/`.
   - Ajouter : `packwiz modrinth add <slug>` ; version testée imposée : `--project-id <id> --version-id <id>`.
     Retirer : `packwiz remove <slug>`. `side` dans `mods/<slug>.pw.toml` : `client` (C) ou `both` (S+C).
   - Shaders : `packwiz modrinth add <slug>` les range seul dans `shaderpacks/`, mais Modrinth les déclare `env: unknown`
     → packwiz écrit `side = "both"`, à corriger en `client` à la main (vérifié 2026-09-20).
     Complementary : licence propre (Complementary License Agreement 1.7 §1.2) — inclusion autorisée via Modrinth
     (URL + hash, ce que fait packwiz), interdit de réuploader le zip ou de modifier son contenu ;
     crédit obligatoire dans la description du pack seulement si activé par défaut → on le laisse désactivé.
   - Réglages d'un shader : Iris lit `shaderpacks/<nom exact du zip>.txt`, un fichier `Properties` de ses seules valeurs
     modifiées (`Iris.java` `loadExternalShaderpack`, branche 1.21.1, vérifié 2026-09-20) — hors du zip, donc pas une
     modification du shader au sens de la licence. Livré : `ComplementaryReimagined_r5.9.3.zip.txt` = `WATER_STYLE_DEFINE=3`
     (eau style Unbound ; `lib/common.glsl` : `-1` = suit le style du pack, `1` Reimagined, `2` + vagues, `3` Unbound ;
     les caustiques suivent l'eau car `WATER_CAUSTIC_STYLE_DEFINE` reste à `-1`). `preserve = true` dans `index.toml`
     → écrit au 1er install seulement, les réglages des amis ne sont jamais écrasés.
     **Piège : le nom du fichier contient la version du shader** → à renommer à chaque mise à jour de Complementary,
     sinon Iris repart des valeurs par défaut.
   - Après toute modif : `packwiz refresh` + monter `version` dans `pack.toml`.
   - `options.txt` : `preserve = true` dans `index.toml` → écrit au 1er install seulement, réglages des amis gardés ;
     nouvelles touches jamais poussées → les définir dans le mod. `refresh` garde `preserve` (vérifié 2026-09-12).
   - Test avant merge : `packwiz serve` + dans un dossier vide `java -jar packwiz-installer-bootstrap.jar -g
     http://localhost:8080/pack.toml` (jar = release GitHub `packwiz-installer-bootstrap` `v0.0.3`) → comparer les `sha512`,
     `check_deps.py` sur `mods/`. Fait 2026-09-12 : 110/110 fichiers Modrinth, 7/7 packs maison, `options.txt` ; maj test :
     mod retiré supprimé, 0 retéléchargement, `options.txt` modifié gardé ; pack injoignable → exit 1 en `-g`
     (fenêtre normale : bouton « Continue without updating », `GUIHandler.kt`).
   - Import unique des amis : `bahbeuh-auto.mrpack` (`~/minecraft-tools/client-pack/build_bootstrap_mrpack.py`). À refaire si
     version MC/Fabric change : packwiz-installer ne met à jour le loader que des instances MultiMC (option `--multimc-folder`).
   - Migration 2026-09-12 depuis `bahbeuh-2026-09-12.mrpack` : mêmes 110 fichiers, mêmes versions.
   Fresh Animations va dans `resourcepacks/` et doit être activé par défaut (`options.txt`, `resourcePacks`).
   **Iris et Sodium : prendre des versions compatibles entre elles** (respecter la version de Sodium exigée par Iris).
   Emotecraft et Do a Barrel Roll : les mettre aussi sur le serveur (optionnel côté serveur mais meilleure synchro).
   Packs maison = dossiers `pack/resourcepacks/<nom>/` (ID `file/<nom>` dans `options.txt`, sans `.zip`).
   **Pack de ressources maison « enchants-plus-lang »** (activé par défaut) : `assets/enchantsplus/lang/`
   `en_us.json` + `fr_fr.json` avec, pour les 22 enchantements, le nom (`enchantment.enchantsplus.<id>`) et la description
   (`enchantment.enchantsplus.<id>.desc`), rédigés d'après la page Modrinth d'Enchants Plus ; + `assets/farmersdelight/lang/`
   avec `enchantment.farmersdelight.backstabbing.desc`. + `assets/tiered/lang/en_us.json` : noms de palier `<id>.label` (sinon clé brute dans le nom de l'objet ; `en_us` seul comme le jar) : 96 `tiered:<palier>_staff_<école>_<n>` (datapack `mage-staff-tiers`) + 102 du mod `minecraft-tiered-trinkets` (`lang/en_us.json` du dépôt, fusion). + `assets/starbow/lang/` : `enchantment.starbow.etoile_filante.desc` (datapack Étoile filante ;
   clé EnchDesc = `enchantment.<ns>.<id>.desc` même si le nom de l'enchantement est un texte littéral, vérifié dans `enchdesc-fabric-1.21.1-21.1.11.jar`). IDs : breaking_curse, breeze_burst, clumsiness_curse, crabs_touch,
   displacement_curse, double_edge_curse, gluttony, graviole, ice_aspect, kinetic_protection, luminosity, outreach,
   precision, pyrolysis, retrieval, scorch_walker, skyguard, stride, swift_strike, toxic, vitality, websnare.
   **Pack maison « bahbeuh-fixes »** (activé par défaut, priorité la plus haute) : `assets/minecraft/subtle_effects/fluid_definitions/lava.json`
   = celui du jar Subtle Effects `1.14.3` sans `splash_type` (champ optionnel) → plus d'éclaboussure de lave, eau intacte.
   Cause : crash client `No sprite set is set for sprite set holder 'subtle_effects:lava_splash'` = course au chargement des
   ressources (`SplashTypeReloadListener.prepare` crée la texture dynamique en parallèle de `DynamicSpriteSetsManager.reload`
   appelé par `FabricParticleEngineMixin`) → aléatoire selon le lancement, F3+T ne garantit rien. Tickets GitHub #242/#237
   ouverts, `1.14.3` = dernière version 1.21.1 (vérifié 2026-09-12). Retirer le pack quand une version corrige.
   **Pack intégré Continuity `continuity:default`** (« Default Connected Textures » : verre, grès, bibliothèques) : aussi dans
   `resourcePacks` de `options.txt`, sinon verre non connecté. Continuity l'enregistre en `ResourcePackActivationType.NORMAL`
   (désactivé par défaut) ; ID = `Identifier.toString()` (`ModNioResourcePack.create` de Fabric API, vérifié 2026-09-12). Dès `12d`.
   **Touches** (`options.txt`, dès `12d`) : `key_gui.xaero_new_waypoint:key.keyboard.n`, `key_key.travelersbackpack.inventory:key.keyboard.h`
   → `B` reste à la roue Emotecraft. `G`, `H`, `J`, `N` : aucune touche par défaut dans les jars du pack (relevé 2026-09-12).
10. Mettre à jour la section « Ajouter des mods » du `README.md`.
11. Rendre compte : ce qui est installé, les versions, les problèmes rencontrés.

## 7. Pour les amis

Une seule fois (libellés : capture de l'app par nistroy 2026-09-12 + `settings-modal/index.vue` ; chemin Windows avec
espaces non testé). Hook impossible à pré-remplir via `.mrpack` (format : fichiers + versions seulement). Piège :
« Launch hooks » = réglage global de l'app (Default instance options), pas celui de l'instance.
1. Installer l'**app Modrinth** (modrinth.com/app).
2. « + » → **Importer** → `bahbeuh-auto.mrpack` fourni (Minecraft + Fabric + outil de mise à jour, pas de mods).
3. Instance → ⚙ (à côté de Play) → onglet **Sync overrides** (RAM et hook au même endroit, vu par nistroy 2026-09-12) :
   - **Custom memory allocation** → 6 Go (4 Go minimum sans shaders). RAM client jamais mesurée : relever `Mem` (F3)
     en jeu avant de changer ;
   - **Custom game launch hooks** → **Pre-launch**, coller (variables fournies par l'app, `hooks.rs`) :
   `"$INST_JAVA" -jar "$INST_DIR/packwiz-installer-bootstrap.jar" https://raw.githubusercontent.com/Nistroy/minecraft-server/main/pack/pack.toml`

Chaque lancement : fenêtre packwiz télécharge seulement ce qui a changé, puis le jeu démarre. Pack injoignable →
« Continue without updating » (sinon l'app annule le lancement : hook en échec).
4. Lancer, se connecter à `schmidt-shut.tun.ply.gg`.
5. Au 1er lancement : Options → Packs de ressources → actifs, de haut en bas : bahbeuh-fixes, enchants-plus-lang,
   Fresh Animations, Default Connected Textures. Normalement déjà réglé par le pack ; sinon les activer dans cet ordre.
6. Shaders (optionnel, gros coût GPU) : Options → Vidéo → Shader Packs → Complementary Reimagined (déjà livré, rien à télécharger).
7. FPS trop bas ? Dans l'ordre : couper les shaders → retirer Fresh Animations → baisser Sound Physics → baisser la distance de rendu.
8. Touches : roue des emotes **B**, nouveau waypoint **N**, ouvrir le sac à dos **H**.

---

## 8. Mod maison — barque à moteur

Dépôt séparé `Nistroy/minecraft-motorboat` (local `~/minecraft-motorboat`, instructions dans son `CLAUDE.md`).
Décidé 2026-09-20 après test en jeu de Shippy Ships et Fish 'N' Ships (§4) : aucun mod 1.21.1 existant ne répond.

### v0.6.0 déployée 2026-09-20 — pack **et** `server/mods/` (saut depuis `v0.3.1`)
Trois versions d'un coup, une seule mise à jour pour les joueurs (choix nistroy) :
- `v0.4.0` coque 3D de la grande barque (maquette Blockbench de nistroy) + sprites d'items faits main.
- `v0.5.0` hors-bord accrochés au tableau arrière sur les deux coques, gros moteur avec son propre
  modèle, grande coque allongée à 48 px (hitbox toujours 2,25).
- `v0.6.0` houle : tangage, roulis et étrave qui se lève en vitesse. **Purement visuel** — rien côté
  entité, hitbox et pilotage inchangés, rien de plus à synchroniser. La phase vient de l'heure du
  monde et de la position, donc deux barques voisines prennent la même vague.
- `v0.6.1` (2026-09-21) la houle vient **par séries** : eau plate ~72 % du temps puis une série de
  5-10 s. La 0.6.0 oscillait en continu — « ça ne fait que trembler » (nistroy, essai en jeu).

### Contenu depuis v0.3.1
- 2 coques : barque 2 places (coque vanilla) et grande barque 6 places (coque maison, 2,25 blocs → passe mal
  sous les ponts bas). Soute : accroupi + clic droit main vide (réservoir + slot moteur + coffre 27).
- 3 moteurs, slot moteur de la soute : `motor` 16, `big_motor` 24, `double_motor` 32 bloc/s ; grande coque
  ×0,85 (13,6 / 20,4 / 27,2). Petite coque = moteur de base seulement. Slot vide = bateau à rames.
- Combustible de four, réservoir 12 000 ticks (10 min, 7,5 charbons) ; plein à la main (accroupi + clic droit
  avec combustible) ou auto depuis le slot réservoir. Ne consomme que moteur posé **et** en marche.
- Crafts, tous à forme fixe : moteur (4 fer + 2 cuivre + 1 four) · gros moteur (moteur + 4 fer + bloc de cuivre)
  · double moteur (2 gros moteurs + bloc de fer) · coque (`fer bateau fer`, **sans** moteur, v0.3.1) · grande
  coque (coque + 7 planches).
- Config `config/motorboat.json` : 4 clés, **aucun plafond** de vitesse ; ancienne clé `topSpeedBlocksPerSecond`
  relue comme vitesse du moteur de base. Même fichier client et serveur.
- Client et serveur doivent avoir la **même version** : sinon remap de registre → items d'autres mods au pick,
  crafts et menus muets (constaté 2026-09-20 avec client 0.3.0 sur serveur 0.1.1).
- Vérifié 2026-09-20 : build + tests verts, `runServer` propre, RCON (items, slot moteur 28, conso auto),
  serveur live redémarré en 0.3.0 (`Done (`, `- motorboat 0.3.0`).
- Seuil `Vehicle moved too quickly` : refus si distance² − vitesse² > 100 par paquet
  (`ServerGamePacketListenerImpl.handleMoveVehicle`, javap 1.21.1) ; 32 bloc/s = 1,6 bloc/tick → large marge.

### Reste à faire
- Regarder la houle en jeu et régler les amplitudes au goût (constantes de `Wave`, dépôt du mod).
- Vote Discord pas fait (mod maison ajouté au pack sur décision de nistroy 2026-09-20). Prévenir les copains
  du changement de craft de la coque (le moteur ne fait plus partie de la recette) **et de la mise à jour
  `0.6.0`** : relancer le launcher, client et serveur doivent avoir la même version.
- Garder le bois du bateau utilisé au craft (aujourd'hui : coque chêne quel que soit le bateau).
- **Hors périmètre, explicitement** : pont praticable en mouvement (demanderait mixins client + physique).


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

### 2.2 Serveur + joueurs (S+C)

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| Bosses of Mass Destruction | `bosses-of-mass-destruction` | 4 boss : Night Lich (biomes froids), Obsidilith (End), Gauntlet (Nether), Void Blossom (fond du monde) |
| The Aether | `aether` | Dimension céleste, 3 donjons + boss, mobs, équipement |
| Aquamirae | `aquamirae` | Océan glacé, navire fantôme et boss |
| Deeper and Darker | `deeperdarker` | Prolonge les Anciennes Cités, nouvelle dimension derrière leur portail |
| Friends&Foes | `friends-and-foes` | Mobs des votes Mojang (golem de cuivre, crabe, glare, moobloom, rascal, mauler, iceologer, wildfire…) — chaque mob désactivable en config |
| Illager Invasion | `illager-invasion` | ~10 nouveaux illagers, fort, tour, labyrinthe, table d'imprégnation |
| Waystones | `waystones` | Pierres de téléportation |
| Farmer's Delight Refabricated | `farmers-delight-refabricated` | Cuisine, nouvelles cultures, dizaines de plats |
| Supplementaries | `supplementaries` | Blocs déco/pratiques style vanilla |
| Traveler's Backpack | `travelersbackpack` | Sacs à dos (compat. Universal Graves déclarée) |
| Easy Anvils | `easy-anvils` | Plus de « Trop cher ! » à l'enclume |
| Trade Cycling | `trade-cycling` | Relancer les offres d'un villageois |
| Nature's Compass | `natures-compass` | Boussole qui trouve un biome choisi |
| Explorer's Compass | `explorers-compass` | Boussole qui trouve une structure choisie |
| Lootr | `lootr` | Chaque joueur a **son propre butin** dans les coffres de structures |
| Enhanced Celestials | `enhanced-celestials` | Événements lunaires : lune de sang (plus de monstres), lune des moissons, lune bleue |
| Tide 2 | `tide` | Refonte de la pêche : poissons par biome, pêche dans la lave, carnet |
| Amendments | `amendments` | Améliorations de blocs vanilla, par l'auteur de Supplementaries |
| Handcrafted | `handcrafted` | Meubles style vanilla |
| Ribbits | `ribbits` | Villages de grenouilles dans les marais |
| Enchants Plus | `enchants-plus` | 18 enchantements + 4 malédictions « comme vanilla ». Serveur suffit : le mod n'a **aucun fichier de langue** (noms en anglais via `fallback`, pas de descriptions) → pack de ressources maison, voir §6 étape 9 |
| Easy Magic | `easy-magic` | La table d'enchantement garde les objets, relance possible |
| Hardcore Revival | `hardcore-revival` | Au lieu de mourir, KO : les amis ont un temps limité pour te relever |
| Exposure | `exposure` | Appareils photo, pellicules, développement, tirages, albums, cadres |
| Immersive Melodies | `immersive-melodies` | Instruments pour jouer des mélodies, même à plusieurs |
| Immersive Paintings | `immersive-paintings` | Mettre ses propres images en tableaux |
| Macaw's Doors | `macaws-doors` | Dizaines de portes style vanilla |
| Macaw's Windows | `macaws-windows` | Fenêtres, rideaux, vitraux |
| Macaw's Bridges | `macaws-bridges` | Ponts |
| Dramatic Doors | `dramatic-doors` | Portes hautes (3 blocs) |
| Bountiful | `bountiful` | Tableaux de primes dans les villages : missions contre récompenses. Requiert Kambrik (§2.4) |

### 2.3 Joueurs seulement (C)

| Mod | Slug | Ce qu'il apporte |
|---|---|---|
| Sodium | `sodium` | Moteur de rendu, gros gain de FPS |
| Iris | `iris` | Shaders (pack conseillé : Complementary Reimagined) |
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
| LambDynamicLights | `lambdynamiclights` | Une torche en main éclaire autour de soi |
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
data-anchor, resourceful-config, fzzy-config, cicada ; pour les ⏳ seulement : yacl, kiwi.
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
| Storage Drawers | `storagedrawers` | S+C | Tiroirs grand volume ; contrôleur = tri automatique ; entonnoirs OK (API de transfert Fabric vérifiée dans le jar) | Pas installé : « plus tard, a l'air bien » (nistroy 2026-09-12) ; pas de génération de monde → ajout possible à tout moment |
| Better Archeology | `better-archeology` | S+C | Plus d'archéologie (structures, blocs suspects, 3 enchantements) | Retiré du pack de base (test en jeu 2026-09-12) ; peut revenir : objets partout, structures seulement dans les chunks jamais générés |
| Snow! Real Magic! | `snow-real-magic` | S+C | Neige qui s'accumule, recouvre escaliers/dalles/clôtures (lib Kiwi) | Installé |

Rappel enchantements : Dungeons and Taverns (✅) ajoute déjà des enchantements uniques et Illager Invasion (✅)
sa table d'imprégnation. **Un seul pack d'enchantements** (Enchants Plus ✅) : les packs ne gèrent pas les exclusivités entre eux.

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
| Macaw's Lights and Lamps / Trapdoors / Fences and Walls, Beautify, Another Furniture, Cooking for Blockheads | Pas fan des mods de déco supplémentaires |
| Reactive Music | AmbientSounds suffit pour l'ambiance sonore |
| Visuality | Pas fan (et doublon avec Subtle Effects) |
| Reinforced Chests | Coffres vanilla suffisent (test en jeu 2026-09-12) |
| Tom's Simple Storage | Pas réussi à le faire marcher, pas indispensable (test en jeu 2026-09-12) |
| Macaw's Roofs | Pas voulu (nistroy, 2026-09-12) |
| Anti Enderman Grief | Pas voulu (nistroy, 2026-09-12) |
| Galosphere | Avec Terralith, ses 3 biomes souterrains ne génèrent pas (`locate biome` échoue, témoins vanilla OK ; Terralith `dimension/overworld.json` = liste explicite `minecraft`/`terralith`) → ses mobs, blocs et sanctuaire disparaissent, restent ruines + palladium. Sous-sol déjà couvert : Terralith (11 biomes `cave/`) + Tectonic (grottes, rivières souterraines). Test 2026-09-12 |
| Spelunkery | `0.4.4` + Moonlight `3.6.4` : 63 `Failure adding generated resources … NoSuchElementException` (loot + worldgen des minerais), aussi seul → bug du mod. Écrase en plus des loots d'autres mods (Pyrolysis d'Enchants Plus sur 4 minerais deepslate, Wither d'Incendium). Test 2026-09-12 |
| *(indisponibles en Fabric 1.21.1)* | Twilight Forest, Blue Skies, Etched, Sophisticated Backpacks, Moog's End/Nether Structures, Twigs, More Villagers, Croptopia, Iron Chests, Double Shulker Shells |

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
     Tom's Storage, Macaw's Roofs, Anti Enderman Grief (§4), Better Archeology, Storage Drawers (§3) ; Subtle Effects (C) retiré.
     Démarrage OK (249 mods), aucune ERROR nouvelle vs test, datapack BlazeandCave's chargé, configs §6 étape 6 faites.
     Pack joueurs `client-pack/bahbeuh-2026-09-12.mrpack` = `12d` moins ces mods (110 fichiers).
7. **`/locate` gèle le serveur** (thread principal) : jusqu'à ~25 s pour une structure rare (`structory_towers:engineer_tower`, 36 km).
   Plusieurs envoyés d'un coup = même tick → watchdog 60 s → crash. Le retard s'additionne aussi entre `locate` lents
   envoyés un par un (23 s + 17 s + 24 s… → crash, test en jeu 2026-09-12).
   → Un seul à la fois, ~20 s de pause après un `locate` lent, pas pendant que des amis jouent.
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

**Côté serveur (Mac mini M1)** :

| Mod | Impact | Parade |
|---|---|---|
| Génération (Terralith, Tectonic, ~20 mods de structures) | 🔴 fort, **uniquement** en générant de nouveaux chunks | C2ME + pré-génération Chunky |
| Textile Backup | 🟠 pic processeur pendant la compression | 1×/heure, seulement si des joueurs sont connectés |
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
   avec `enchantment.farmersdelight.backstabbing.desc`. IDs : breaking_curse, breeze_burst, clumsiness_curse, crabs_touch,
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
3. Instance → ⚙ (à côté de Play) → onglet **Sync overrides** → activer **Custom game launch hooks** → **Pre-launch**,
   coller (variables fournies par l'app, `hooks.rs`) :
   `"$INST_JAVA" -jar "$INST_DIR/packwiz-installer-bootstrap.jar" https://raw.githubusercontent.com/Nistroy/minecraft-server/main/pack/pack.toml`
4. Paramètres de l'instance → **allouer 6 Go de RAM** (4 Go minimum sans shaders).

Chaque lancement : fenêtre packwiz télécharge seulement ce qui a changé, puis le jeu démarre. Pack injoignable →
« Continue without updating » (sinon l'app annule le lancement : hook en échec).
5. Lancer, se connecter à `schmidt-shut.tun.ply.gg`.
6. Au 1er lancement : Options → Packs de ressources → actifs, de haut en bas : bahbeuh-fixes, enchants-plus-lang,
   Fresh Animations, Default Connected Textures. Normalement déjà réglé par le pack ; sinon les activer dans cet ordre.
6. Shaders (optionnel) : Options → Vidéo → Shader Packs → Complementary Reimagined.
7. FPS trop bas ? Dans l'ordre : couper les shaders → retirer Fresh Animations → baisser Sound Physics → baisser la distance de rendu.
8. Touches : roue des emotes **B**, nouveau waypoint **N**, ouvrir le sac à dos **H**.

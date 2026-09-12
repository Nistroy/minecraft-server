# Serveur Discord « BahBeuh » — état actuel

> **Copie locale du 2026-09-12**, faite pour éviter d'appeler le MCP juste pour retrouver un ID ou un texte.
> Elle peut devenir fausse si nistroy modifie le Discord à la main :
> - lire / écrire / modifier un message ou un post → utiliser directement les ID ci-dessous ;
> - **avant de changer la structure** (salons, rôles, droits) → un `list_channels` / `list_roles` pour vérifier ;
> - **votes** → toujours relus en direct (`get_poll_results`), jamais depuis ces fichiers.
> **Mettre ce fichier à jour après chaque changement fait sur Discord.**
> Contenu des posts du forum + ID des sondages : `discord/posts.json`. Plan et pièges : `DISCORD.md`.

## Serveur
- ID `1548102098133061735` · propriétaire nistroy (`496343592739012638`) · 2 membres au 2026-09-12 (nistroy + bot)
- Bot : « BahBeuh » (`1548107020190748782`), invité avec Administrateur (droits à réduire plus tard, voir `DISCORD.md` §1)

## Rôles
| Rôle | ID | Couleur | Affiché à part | Droits |
|---|---|---|---|---|
| BahBeuh (rôle du bot, géré par Discord) | `1548111162518933606` | — | non | Administrateur |
| Admin | `1548115813851074781` | rouge `#e74c3c` | oui | **aucun pour l'instant** — nistroy doit cocher Administrateur et se l'attribuer (refusé au MCP par le mode auto) |
| Joueur | `1548116497304518716` | vert `#2ecc71` | oui | aucun (décoratif), à donner en masse avec `bulk_assign_role` sur demande |
| @everyone | `1548102098133061735` | — | — | défaut Discord |

Ordre : BahBeuh > Admin > Joueur > @everyone. **Accès ouvert** : aucun rôle requis pour voir/écrire.

## Catégories et salons
Droits : « lecture seule » = @everyone refusé SendMessages, SendMessagesInThreads, CreatePublicThreads, CreatePrivateThreads.

| Catégorie (ID) | Salon | ID | Type | Droits | Sujet |
|---|---|---|---|---|---|
| 📢 INFOS `1548115822080163910` (lecture seule sur la catégorie) | #annonces | `1548117930343137300` | texte | hérité | Ouverture du serveur, mises à jour, maintenances |
| | #rejoindre | `1548118056734163066` | texte | hérité | Adresse du serveur Minecraft et installation du modpack |
| 💬 COMMUNAUTÉ `1548115949641531475` | #général | `1548102098648825878` | texte | ouvert | Discussion libre |
| | #screenshots | `1548116788297076748` | texte | ouvert | Captures d'écran et photos (mod Exposure) |
| | #idées | `1548116811688444005` | texte | ouvert | Propositions de mods, de projets de construction, d'événements |
| 🗳️ SONDAGE MODS `1548116077626793984` | #comment-voter | `1548116923894603867` | texte | lecture seule | Comment marche le sondage des mods… |
| | mods | `1548117074763587684` | **forum** | @everyone : refusé SendMessages (= créer un post), autorisé SendMessagesInThreads (répondre/voter) | Un post par mod… Pour proposer un autre mod : #idées |
| | #résultats | `1548117199280017478` | texte | lecture seule | Récapitulatif final des votes |
| 🛠️ SERVEUR MINECRAFT `1548116202906452008` | #modpack | `1548117318599442574` | texte | lecture seule | Fichier .mrpack du modpack et notes de mise à jour |
| | #bugs-et-crashs | `1548117428674756689` | texte | ouvert | Signalements : décrire le problème et joindre le log/crash |
| 🔊 VOCAL `1548116328534122597` | Général | `1548102098648825879` | vocal | ouvert | — |
| | Minecraft 1 | `1548117559184990228` | vocal | ouvert | — |
| | Minecraft 2 | `1548117695998861353` | vocal | ouvert | — |

Supprimés : #bienvenue (inutile entre amis), catégories par défaut « Salons textuels » / « Salons vocaux ».

## Étiquettes du forum `mods`
🌍 Monde · 🏰 Structures · ⚔️ Boss & aventure · 🐾 Mobs · 🎮 Gameplay · 🎨 Fun & déco · 🤔 Hésitations · ℹ️ Info
(noms sans emoji à passer dans `create_forum_post` → `tags`, ex. `["Fun & déco"]`)

## Messages publiés (hors forum)
**#rejoindre** — message `1548120922957807696` :
```
**Adresse** : `schmidt-shut.tun.ply.gg`
Envoie-moi ton pseudo Minecraft exact que je t'ajoute à la whitelist.

**Modpack** (dans <#1548117318599442574> après le vote) :
1. Installe l'app Modrinth : <https://modrinth.com/app>
2. « + » → Importer → le fichier `.mrpack`
3. Mets 6 Go de RAM dans les paramètres de l'instance
```

**#comment-voter** — message `1548120931640279131` :
```
Un post par mod dans <#1548117074763587684>, avec un sondage ✅ / ❌ / 🤷.
Plus de ✅ que de ❌ = on le garde. Égalité → je tranche. Je ferme le vote quand le serveur est prêt.

Pas au vote : les mods de perf, les bibliothèques, et les mods côté joueur (Sodium, shaders, minimap…) que chacun active ou non chez lui.
Un mod en plus ? → <#1548116811688444005>
```

**#rejoindre** `1548120922957807696` : son étape 2 (import `.mrpack`) est obsolète depuis le pack packwiz (2026-09-12)
→ à remplacer par un renvoi vers #modpack (sur demande de nistroy).

**#modpack** — message `1548420154990534769` (2026-09-12), pièce jointe `bahbeuh-auto.mrpack` (590 o) : import unique,
mods via hook packwiz (`MODS.md` §7). Libellés de l'app relevés dans ses locales `en-US` / `fr-FR` (dépôt `modrinth/code`,
2026-09-12) ; onglet hooks = interrupteur « Custom game launch hooks » (`hooks-settings.vue`). Chemin Windows avec espaces non testé.
Obsolètes, à supprimer à la main (suppression refusée au mode auto, §5 `DISCORD.md`) : v1 `1548326166581092444` et
v2 `1548340069570715728` (anciens `.mrpack` de test à importer à la main).
```
**Modpack BahBeuh** : il se met à jour tout seul maintenant, plus besoin de réimporter à chaque changement.
Minecraft 1.21.1 Fabric · les mods du serveur + ceux côté joueur (Sodium, Iris, minimap…)

**Une seule fois :**
1. Installe l'app Modrinth : <https://modrinth.com/app>
2. « + » → Importer → le fichier `bahbeuh-auto.mrpack` ci-dessous (pas de mods dedans, c'est normal : ils arrivent au lancement)
3. Paramètres de l'instance → onglet Launch hooks (« Lancer le crochet » en français) → active « Custom game launch hooks » → dans Pre-launch / Pré-lancement, colle :
(bloc de code) "$INST_JAVA" -jar "$INST_DIR/packwiz-installer-bootstrap.jar" https://raw.githubusercontent.com/Nistroy/minecraft-server/main/pack/pack.toml
4. Paramètres de l'instance → 6 Go de RAM (4 Go sans shaders)
5. Lance : une fenêtre télécharge les mods (un peu long la 1re fois), puis le jeu démarre
6. Multijoueur → Ajouter un serveur → `schmidt-shut.tun.ply.gg`

Après, à chaque lancement il récupère juste ce qui a changé. Si la fenêtre affiche une erreur → « Continue without updating » et tu joues quand même.
Pas encore dans la whitelist ? Envoie-moi ton pseudo Minecraft exact.
Shaders (optionnel) : onglet Shaders de l'app → Complementary Reimagined
Un souci → <#1548117428674756689> avec le fichier `logs/latest.log` de l'instance
```

#annonces, #résultats, #screenshots, #idées, #bugs-et-crashs : vides.

## Forum `mods`
51 posts de vote + 1 post ℹ️ « Mods côté joueurs (pas de vote) » (`1548124750650417264`).
Chaque post de vote a un sondage « On le garde ? » (✅ Oui · ❌ Non · 🤷 Sans avis). Tous créés le 2026-09-12, 768 h → fin auto ~2026-10-14.
Post « Sous-sol : Galosphere ou Spelunkery ? » supprimé par nistroy le 2026-09-12 (les 2 écartés, `MODS.md` §4).
Détail (titre, étiquettes, slugs, ID du fil et du sondage, vidéo vérifiée, texte exact) : `discord/posts.json`.

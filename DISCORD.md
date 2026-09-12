# Serveur Discord — plan de création et sondage des mods

> **À exécuter dans une conversation Claude Code dédiée, avec un MCP Discord connecté.**
> Objectif : créer de A à Z le serveur Discord du groupe, puis y organiser le **sondage des mods**
> (chaque mod accepté ou refusé par les amis).
> Sources : `MODS.md` (liste des mods, **toujours la relire au moment d'agir**) et `README.md` (serveur Minecraft).

---

## 0. Règles pour la conversation qui exécute ce plan

1. **Commencer par vérifier le MCP `discord`** (outils `mcp__discord__*`, voir section 1) : `get_bot_info` et
   `get_guild_info` pour confirmer l'accès au serveur. Si une action n'est pas possible via le MCP, le dire
   et proposer une alternative (ex. nistroy le fait à la main).
2. **Tout ce qui est publié sur Discord est visible par les amis** : montrer à nistroy la structure prévue
   et un exemple de post **avant** de tout créer ou poster. Une validation par étape, pas pour chaque message.
3. **Ne rien installer sur le serveur Minecraft.** Ce plan ne concerne que Discord et `MODS.md`.
4. **Relire `MODS.md` avant de le modifier** : d'autres conversations l'éditent aussi.
5. API Modrinth : utiliser `curl` (Python `urllib` échoue en SSL sur ce Mac).
6. Répondre en français.

## 1. Prérequis et MCP Discord

**État au 2026-09-12** : serveur Discord créé (vide), ID `1548102098133061735`. MCP installé et déclaré
dans Claude Code. **Bot prêt** : application « BahBeuh » (ID `1548107020190748782`), token valide, intents
Server Members + Message Content activés, invité avec Administrateur ; `discord-mcp check` → 24/24 permissions.
Les étapes ci-dessous ne sont à refaire qu'en cas de nouveau token.

**Serveur construit le 2026-09-12** (étapes 1 à 3 faites, étape 4 validée) :
- Rôles : Admin `1548115813851074781` (droit Administrateur et attribution à nistroy **refusés par le mode auto**
  → à faire à la main), Joueur `1548116497304518716`, rôle du bot « BahBeuh » `1548111162518933606`
  (géré par Discord, tient lieu de rôle Bot).
- Accès **ouvert** : aucun rôle requis (pas d'attribution automatique possible avec ce MCP ; Joueur est décoratif,
  à donner en masse avec `bulk_assign_role` sur demande). @everyone ne peut pas écrire dans 📢 INFOS,
  #comment-voter, #résultats, #modpack ; dans le forum `mods`, ne crée pas de post mais peut y répondre et voter.
- Salons : #annonces `1548117930343137300`, #rejoindre `1548118056734163066`, #général `1548102098648825878`,
  #screenshots `1548116788297076748`, #idées `1548116811688444005`, #comment-voter `1548116923894603867`,
  forum `mods` `1548117074763587684`, #résultats `1548117199280017478`, #modpack `1548117318599442574`,
  #bugs-et-crashs `1548117428674756689` ; vocaux Général, Minecraft 1, Minecraft 2. **#bienvenue supprimé**.
- Étiquettes du forum : Monde, Structures, Boss & aventure, Mobs, Gameplay, Fun & déco, Hésitations, Info.
- **Ton** (demande de nistroy) : textes courts, familiers, à la 1re personne — pas de règles ni de blabla « communauté ».
- **Vote** : sondage Discord de 768 h (le maximum) dans chaque post, clos par nistroy quand le serveur est prêt
  (`end_poll`) — remplace « 1 semaine ». Une **vidéo YouTube** dans chaque post quand il y en a une.
- **Étape 5 faite le 2026-09-12** : 52 posts de vote + post ℹ️ « Mods côté joueurs » publiés dans `mods`, chacun
  avec son sondage 768 h (fin automatique vers le 2026-10-14). **ID des fils et des sondages + texte exact de chaque post :
  `discord/posts.json`** — c'est la source pour l'étape 6. **Inventaire du serveur (rôles, salons, droits, ID) :
  `discord/ETAT.md`** — à lire avant d'appeler le MCP.
- Format des posts (validé par nistroy) : 2-3 lignes, `<lien Modrinth>` (chevrons = pas d'aperçu),
  `▶️ [Vidéo](https://youtu.be/…)` et `🖼️ [1](url) · [2](url)` — **l'emoji hors des crochets** (dedans, Discord
  n'affiche pas le lien masqué) et jamais de texte vide `[​](url)` (Discord ignore alors l'aperçu).
- **Vérifier chaque vidéo** avant de la poster : `curl "https://www.youtube.com/oembed?url=https://youtu.be/<id>&format=json"`
  donne le titre. Une vidéo prise sur une page Modrinth pointait vers une vidéo sans rapport (Towns and Towers, corrigé).

### MCP choisi : `@quadslab.io/discord-mcp` v2.1.1 (Node)
C'est le seul des MCP comparés qui couvre tout le plan : rôles, catégories, salons texte et vocaux,
forum + étiquettes (`create_forum_channel`, `create_forum_tag`, `create_forum_post`),
**sondages** (`send_poll`, `get_poll_results`, `end_poll`), réactions, permissions de salon
(`set_channel_permissions`), fichier joint par URL (`send_message_with_file`).
Écartés : `SaseQ/discord-mcp` (pas de sondages), `barryyip0625/mcp-discord` (ni sondages ni fichiers).

- Lancement : `discord-mcp.sh` (dans ce dossier). Il lit le token dans `~/.config/discord-mcp/token`
  (hors du projet), fixe `DISCORD_GUILD_ID` et lance `npx -y @quadslab.io/discord-mcp@2.1.1`.
- Déclaration (portée locale à ce dossier, déjà faite) :
  `claude mcp add discord --scope local -- /Users/nistroy/minecraft-server/discord-mcp.sh`
- Fonctionne dans **l'extension VS Code comme dans le CLI** (même configuration). Un MCP ajouté n'est chargé
  que dans les **nouvelles conversations** : vérifier avec `/mcp` que `discord` est **Connected**.
- Dépannage : `DISCORD_TOKEN=… DISCORD_GUILD_ID=1548102098133061735 npx @quadslab.io/discord-mcp check`.

### À faire par nistroy (une seule fois)
1. https://discord.com/developers/applications → **New Application** (ex. « Minecraft Bot ») → onglet **Bot** :
   - activer **Server Members Intent** et **Message Content Intent** (sinon le bot ne se connecte pas :
     le MCP demande ces deux intents) ;
   - dans un terminal (zsh), lancer d'abord cette commande ; elle attend le token en saisie masquée :
     `read -rs "T?Token du bot : " && printf '%s' "$T" | tr -d '[:space:]' > ~/.config/discord-mcp/token && chmod 600 ~/.config/discord-mcp/token && unset T && curl -s -o /dev/null -w 'HTTP %{http_code}\n' -H "Authorization: Bot $(cat ~/.config/discord-mcp/token)" https://discord.com/api/v10/users/@me`
   - **ensuite** : **Reset Token** → **Copy** → coller dans le terminal → Entrée. `HTTP 200` = token valide.
     (Ne pas utiliser `pbpaste` : si la commande a été copiée, le presse-papier contient la commande et plus le token.
     Ne jamais coller le token dans une conversation ni dans ce dossier.)
2. Onglet **OAuth2 → URL Generator** : scopes `bot` + `applications.commands`, permission **Administrator**
   → ouvrir l'URL générée et inviter le bot sur le serveur.
   - Pourquoi Administrateur pendant la création : un bot ne peut pas créer un rôle avec des droits qu'il
     n'a pas lui-même (le rôle Admin), ni régler les permissions de tous les salons.
   - Une fois le serveur construit, réduire ses droits à : Gérer les salons, Gérer les rôles,
     Gérer les messages, Gérer les fils, Envoyer des messages (et dans les fils), Créer des sondages,
     Intégrer des liens, Joindre des fichiers, Ajouter des réactions, Lire l'historique des messages.
3. Ouvrir une **nouvelle conversation** Claude Code dans ce dossier → `/mcp` → `discord` doit être **Connected**.

---

## 2. Structure du serveur (à valider avec nistroy avant création)

### Rôles
| Rôle | Pour qui | Droits |
|---|---|---|
| **Admin** | nistroy | Tout |
| **Joueur** | Les amis whitelistés sur le serveur Minecraft | Voter, écrire partout sauf 📢 |
| **Bot** | Le bot du MCP | Ce dont il a besoin |

### Catégories et salons

**📢 INFOS** (écriture réservée à Admin)
- `#bienvenue` — présentation du serveur, règles de base (respect, pas de grief, `/ban` = décision Admin)
- `#annonces` — ouverture du serveur, mises à jour, maintenances
- `#rejoindre` — adresse `schmidt-shut.tun.ply.gg`, étapes d'installation du modpack (section 7 de `MODS.md`),
  RAM à allouer (6 Go), à compléter quand le `.mrpack` existe

**💬 COMMUNAUTÉ**
- `#général`
- `#screenshots` — captures et photos (mod Exposure)
- `#idées` — propositions de mods, de projets de construction, d'événements

**🗳️ SONDAGE MODS**
- `#comment-voter` — explication du sondage (section 3), liste des mods **sans vote** et pourquoi
- `mods` — **salon forum** : **un post par mod ou groupe de mods** (= son propre mini-salon avec images,
  vidéos, vote et discussion), avec **étiquettes par thème** (Monde, Structures, Boss & aventure, Mobs,
  Gameplay, Fun & déco, Hésitations)
  - *Alternative si nistroy la préfère* : une catégorie Discord par thème et **un salon texte par mod**
    (limite Discord : 50 salons par catégorie)
- `#résultats` — récapitulatif final des votes

**🛠️ SERVEUR MINECRAFT**
- `#modpack` — fichier `.mrpack` + notes de mise à jour
- `#bugs-et-crashs` — signalements (joindre le fichier de log/crash)

**🔊 VOCAL**
- `Général` · `Minecraft 1` · `Minecraft 2`

---

## 3. Principe du sondage

### Ce qui est soumis au vote
Les mods **visibles en jeu** de `MODS.md` : ✅ (choix de nistroy) et 🗳️ (hésitations).
Les mods ❌ (section 4 « Écartés ») ne sont **pas** soumis au vote.

### Ce qui n'est pas soumis au vote (expliqué dans `#comment-voter`)
- **Performance** (Lithium, C2ME, FerriteCore, ModernFix, ScalableLux, Clumps, Chunky, spark) : invisibles en jeu.
- **Bibliothèques** : nécessaires au fonctionnement des autres mods.
- **Infrastructure** : Textile Backup, Sparse Structures, Leaves Be Gone.
- **Mods côté joueurs** (Sodium, Iris, Xaero's, Jade, Sound Physics, Fresh Animations, Subtle Effects, Do a Barrel Roll…) :
  inclus dans le modpack, **chacun les active ou désactive chez lui**. Un post d'information unique les liste.

### Proposition de posts de vote (état de `MODS.md` au 2026-09-12 — à recalculer depuis `MODS.md` au moment d'agir)

| Thème | Posts (un post = un vote) |
|---|---|
| 🌍 Monde | Terralith + Tectonic · Incendium (Nether) · Nullscape (End) |
| 🏰 Structures | Les 9 YUNG's (un seul vote) · Towns and Towers · Dungeons and Taverns · Explorify · MVS · Overhauled Village · When Dungeons Arise · Structory + Structory: Towers · Tidal Towns |
| ⚔️ Boss & aventure | Bosses of Mass Destruction · The Aether · Aquamirae · Deeper and Darker |
| 🐾 Mobs | Friends&Foes · Illager Invasion · Naturalist 🗳️ · Critters and Companions 🗳️ |
| 🎮 Gameplay | Lootr · Hardcore Revival · Bountiful · Enhanced Celestials · Tide 2 · Waystones · Nature's + Explorer's Compass · Universal Graves · FallingTree · Enchants Plus · Farmer's Delight · Traveler's Backpack · « Petits conforts » (Easy Anvils, Easy Magic, Grind Enchantments, Trade Cycling, Better Than Mending, RightClickHarvest) |
| 🎨 Fun & déco | Exposure · Immersive Melodies · Immersive Paintings · Emotecraft · Supplementaries + Amendments · Handcrafted · Macaw's Doors/Windows/Bridges + Dramatic Doors · Ribbits · Better Archeology |
| 🤔 Hésitations | Macaw's Roofs · Crafting Tweaks · Visual Workbench · BlazeandCave's Advancements · Storage Drawers · Reinforced Chests · Tom's Simple Storage · Snow! Real Magic! · Anti Enderman Grief · « Sous-sol » (Galosphere / Spelunkery / aucun — un seul choix) |

### Contenu de chaque post
Construit à partir de `MODS.md` et de l'API Modrinth (`curl https://api.modrinth.com/v2/project/<slug>`) :
- **Titre** : nom du mod (ou du groupe)
- **2-3 phrases en français** : ce qu'il ajoute concrètement, sans jargon
- **Côté** : serveur seul (rien à installer) ou serveur + joueurs
- **Impact** : FPS / serveur, repris de la section 5 de `MODS.md`
- **Lien Modrinth** (Discord affiche automatiquement un aperçu)
- **Images** : 2-4 images de la galerie Modrinth (champ `gallery` de l'API). `create_forum_post` n'accepte
  que du texte (+ étiquettes) : mettre les URL d'images dans le texte (Discord les affiche en aperçu), ou les
  joindre ensuite dans le fil avec `send_message_with_file` (fichier par URL)
- **Vidéo** : lien YouTube s'il y en a un sur la page du mod (champ `body`) ou une vidéo de présentation connue
- **Étiquette** du thème
- **Vote** : sondage Discord « On le garde ? » → ✅ Oui · ❌ Non · 🤷 Sans avis, posté dans le fil du post
  avec `send_poll` (`channel` = ID du fil renvoyé par `create_forum_post`, `duration` = 168 h pour 1 semaine ;
  max 10 réponses, 768 h). À défaut : réactions ✅ / ❌ / 🤷 sur le premier message (`add_reaction`)
- Pour « Sous-sol » : sondage à choix unique Galosphere / Spelunkery / Aucun

### Limites du MCP (vérifiées dans son code v2.1.1 et testées le 2026-09-12)
- `send_poll`, `get_poll_results` et `end_poll` cherchent le salon **uniquement dans le cache** du MCP
  (`smartFindChannel`). Ce cache n'est reconstruit qu'au démarrage et après **création ou suppression** d'un
  salon, d'une catégorie ou d'un rôle — pas après `modify_channel` ni `create_forum_post`. Un post de forum
  tout juste créé est donc introuvable (`Channel "…" not found`).
  **Contournement validé** : créer tous les posts, puis `create_category` « tmp-cache » (reconstruit le cache,
  fils compris), envoyer les sondages, puis `delete_channel` de cette catégorie. (Autre option : `/mcp` → Reconnect.)
- Les outils de messages (`send_message`, `add_reaction`, `send_message_with_file`, `get_thread_messages`…)
  passent par `smartFindTextChannel`, qui trouve les fils actifs : pas de problème pour eux.
- `create_forum_tag` : une étiquette à la fois (l'outil relit puis réécrit la liste, en parallèle elles risquent de s'écraser).
- La recherche de salon est **approximative** (nom similaire à 70 %) : toujours passer des **ID**, et vérifier
  `channelName` dans la réponse pour ne pas poster dans le mauvais salon.
- Le mode auto de Claude Code a refusé `modify_role_permissions` (Administrateur sur le rôle Admin) et
  `assign_role` (Admin → nistroy) : à faire à la main par nistroy.

### Règles du vote (à afficher dans `#comment-voter`)
- Durée : **1 semaine** (à confirmer avec nistroy).
- Un mod est **gardé** s'il a plus de ✅ que de ❌ ; « Sans avis » ne compte pas.
- **Égalité** → nistroy tranche.
- On peut discuter dans chaque post avant de voter.

### Après le vote
1. Relever les résultats de chaque post via le MCP.
2. Relire `MODS.md`, puis :
   - gardé → reste ✅ (les 🗳️ gardés passent en ✅ dans la bonne section) ;
   - refusé → section 4 « Écartés », raison : « Refusé au sondage (✅ x / ❌ y) ».
3. Poster le récapitulatif dans `#résultats` (gardés / refusés, par thème).
4. Signaler à nistroy que `MODS.md` est prêt pour l'installation (section 6).

---

## 4. Ordre d'exécution

1. Lister les outils du MCP Discord, vérifier l'accès au serveur.
2. Proposer la structure (section 2) → **validation nistroy** → créer rôles, catégories, salons, forum et étiquettes.
3. Remplir `#bienvenue`, `#rejoindre`, `#comment-voter`.
4. Générer le contenu des posts depuis `MODS.md` + Modrinth ; montrer **1 ou 2 posts d'exemple** → **validation**.
5. Publier tous les posts de vote + le post d'information « mods côté joueurs ».
6. À la fin du vote : résultats → `MODS.md` → `#résultats`.

---

## 5. Pièges et leçons (session du 2026-09-12)

**Avant d'appeler le MCP** : lire `discord/ETAT.md` (ID de tout) et `discord/posts.json` (texte exact des posts).
Mettre ces deux fichiers à jour après chaque changement sur Discord. Les fichiers générés dans le dossier
temporaire (scratchpad) d'une conversation sont **perdus** ensuite → toujours enregistrer le résultat dans `discord/`.

### MCP Discord
- **Sondage dans un post tout juste créé** → `Channel not found` (cache). Contournement : `create_category`
  « tmp-cache » → `send_poll` → `delete_channel` de la catégorie. `modify_channel` ne rafraîchit **pas** le cache.
- **ID d'un post de forum = ID de son premier message** → `edit_message(channel=<fil>, messageId=<fil>)`.
- `create_forum_tag` : **une à la fois** (la liste est relue puis réécrite).
- Toujours passer des **ID**, jamais des noms (recherche approximative à 70 %) ; vérifier `channelName` dans la réponse.
- Un salon créé dans une catégorie **hérite de ses droits** à la création (vérifié). Dans un forum,
  « créer un post » = `SendMessages`, « répondre dans un post » = `SendMessagesInThreads`.
- Créations en parallèle : l'ordre a été respecté (ID croissants), mais vérifier avec `list_channels` ;
  le forum s'est placé en tête de sa catégorie → `reorder_channels`.
- **Mode auto de Claude Code** : refuse de donner des droits (`modify_role_permissions` Administrateur,
  `assign_role`). Ne pas contourner : demander à nistroy de le faire à la main.
- Pas d'attribution automatique de rôle à l'arrivée (le bot ne réagit pas aux événements) ; l'Onboarding Discord
  exigerait un serveur « Communauté ».

### Mise en forme Discord
- Lien sans aperçu : `<https://…>` ou `[texte](<https://…>)`.
- **Emoji hors des crochets** : `▶️ [Vidéo](url)` fonctionne, `[▶️ Vidéo](url)` s'affiche en texte brut.
- Lien masqué à texte vide `[​](url)` : Discord **n'affiche plus l'aperçu** → utiliser des libellés courts `🖼️ [1](url) · [2](url)`.
- Message ≤ 2 000 caractères (les posts font au plus ~1 200).

### Contenu des posts (Modrinth / YouTube)
- API Modrinth en masse : `curl -sG https://api.modrinth.com/v2/projects --data-urlencode 'ids=["slug1",…]'`.
- Images : champ `gallery[].raw_url` (pleine taille), pas `url` (vignette 350 px). 15 mods sans galerie → images
  tirées du champ `body` ; écarter les bannières (Stardust Labs partage 2 bannières sur Incendium/Nullscape,
  `announcement.png` d'Enhanced Celestials).
- **Vidéos : toujours vérifier le titre** via oEmbed (`curl "https://www.youtube.com/oembed?url=https://youtu.be/<id>&format=json"`).
  Une vidéo trouvée dans la page Modrinth de Towns and Towers était une vidéo **injurieuse sans rapport** (publiée,
  signalée par nistroy, corrigée) ; 2 autres étaient supprimées. Recherche de remplacement : WebSearch limité à `youtube.com`.

### Façon de travailler avec nistroy
- Textes **courts, familiers, à la 1re personne** (voir mémoire `discord-tone-friends`).
- nistroy regarde le rendu sur son téléphone : **après tout changement de format, faire vérifier 1 post avant
  de publier en masse**. (Le format du lien vidéo a changé après la validation → 50 posts à corriger à la main.)
- Donner un point d'étape court pendant les longues séries d'appels.
- Tant que seuls nistroy et le bot sont sur le serveur, les tests sont invisibles pour les amis — ce ne sera plus
  vrai une fois qu'ils l'auront rejoint : tester alors dans un salon privé ou supprimer aussitôt.

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

**#modpack** — message `1548340069570715728` (2026-09-12), pièce jointe `bahbeuh-test-2026-09-12b.mrpack`
(= `client-pack/`, 22 902 o, + pack `bahbeuh-fixes`). **Pack de test avant la fin du vote** (serveur de test en LAN) →
à supprimer et remplacer par le pack final après le vote.
Ancien message v1 `1548326166581092444` (`bahbeuh-test-2026-09-12.mrpack`) encore présent : suppression refusée par le
mode auto (§5 `DISCORD.md`) → à supprimer à la main.
```
**Pack de test** (v2 : corrige un crash quand un truc tombe dans la lave) : je vérifie que tout marche en jeu avant la fin du vote.
Minecraft 1.21.1 Fabric · tous les mods du vote + ceux côté joueur (Sodium, Iris, minimap…)

1. Installe l'app Modrinth : <https://modrinth.com/app>
2. « + » → Importer → le fichier `.mrpack` ci-dessous
   L'app prévient que 2 fichiers ne sont pas sur Modrinth (`enchants-plus-lang.zip`, `bahbeuh-fixes.zip`) : c'est mes packs maison (traduction des enchantements, correctif du crash) → « Install anyways »
3. Paramètres de l'instance → 6 Go de RAM (4 Go sans shaders)
4. Lance le jeu, puis Multijoueur → Ajouter un serveur

Serveur de test : `192.168.1.198:25566` (réseau local seulement, ce n'est pas l'adresse du vrai serveur)
Shaders (optionnel) : onglet Shaders de l'app → Complementary Reimagined
Un souci → <#1548117428674756689> avec le fichier `logs/latest.log` de l'instance
```

#annonces, #résultats, #screenshots, #idées, #bugs-et-crashs : vides.

## Forum `mods`
51 posts de vote + 1 post ℹ️ « Mods côté joueurs (pas de vote) » (`1548124750650417264`).
Chaque post de vote a un sondage « On le garde ? » (✅ Oui · ❌ Non · 🤷 Sans avis). Tous créés le 2026-09-12, 768 h → fin auto ~2026-10-14.
Post « Sous-sol : Galosphere ou Spelunkery ? » supprimé par nistroy le 2026-09-12 (les 2 écartés, `MODS.md` §4).
Détail (titre, étiquettes, slugs, ID du fil et du sondage, vidéo vérifiée, texte exact) : `discord/posts.json`.

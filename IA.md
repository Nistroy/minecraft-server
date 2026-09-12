# IA.md — assistant IA en jeu (plan, pas commencé)

Design validé par nistroy 2026-09-12. Pas commencé. Démarrer seulement quand :
- pack auto-maj packwiz en place (il livre le mod client) ;
- liste mods finale (vote en cours, `MODS.md`) — fiches dépendent de la liste.

## But
- Joueur pose question sur mods en jeu → réponse rapide, sourcée, sinon "je sais pas". Jamais inventer.
- IA note ce qu'elle trouve / corrige (caveman) → répond plus vite ensuite.
- EMI (recettes/usages) + Jade (bloc visé) déjà dans pack → IA vise mécaniques, "où trouver", compat entre mods.

## Décisions
| Sujet | Choix | Pourquoi |
|---|---|---|
| Interface | mod client Fabric : écran (champ question, historique perso, votes ✔/✘), touche d'ouverture | privé + historique. 1.21.1 : serveur ne peut pas ouvrir d'écran sans mod client (dialogs = 1.21.6+, minecraft.wiki `Dialog`) |
| Secours | `/ia <question>` (mod serveur), réponse privée, boutons chat cliquables ✔/✘, `/ia historique` | joueur sans mod, console |
| Transport | paquets Fabric `CustomPacketPayload` + `PayloadTypeRegistry` + `ServerPlayNetworking`/`ClientPlayNetworking` (docs.fabricmc.net, 1.21.1, vérifié 2026-09-12) | joueur déjà authentifié par le serveur ; rien exposé sur internet/tunnel |
| Cerveau | service Python séparé, Mac mini, `127.0.0.1` ; mod serveur = passerelle mince | corriger/relancer sans redémarrer MC ; testable sans MC |
| LLM | `gemini-3.8-flash`, thinking `high` (niveaux `low`/`medium`/`high`, défaut `medium`), SDK `google-genai`, tier gratuit | gratuit. nistroy accepte : tier gratuit → Google utilise les questions (page pricing, 2026-09-12) |
| LLM isolé | 1 module d'accès LLM | conditions tier gratuit peuvent changer → changer fournisseur = 1 module |
| Internet | tier gratuit = pas de Google Search grounding → outils maison : API Modrinth (description, `wiki_url`, `source_url`, `issues_url`), README/wiki/issues GitHub | ciblé sur nos versions ; wikis génériques = souvent autre version MC |
| Connaissances | md dans dépôt git dédié ; IA commit, nistroy édite/revert | lisible, modifiable, historique, annulation |
| Stockage | SQLite tables `STRICT`, migrations numérotées dès le début, 1 seul module d'accès DB, recherche FTS5 | 1 écrivain, 2-5 joueurs. Postgres = serveur + RAM prise au MC pour rien ; bascule possible via module unique |
| Pas de base vectorielle | index 1 ligne/mod + lecture des fiches par outil | exactitude noms/ID, debug facile, petit corpus. Revoir seulement si wikis entiers aspirés |
| Distribution mod client | pack packwiz auto-maj | aucune action des potes |
| Langages | cerveau Python, mods Java | validé nistroy |
| Mod IA autonome | mods IA (client + serveur) : aucun contenu ni dépendance d'autres mods (Fabric API seule). Connaissances hors du mod, sur le Mac mini, servies par le cerveau | modpack change → seules les données du cerveau changent, mod intact ; rien des autres mods redistribué |

## Architecture
touche → écran client → payload → mod serveur (async, jamais bloquer le tick) → HTTP `127.0.0.1` → cerveau → outils + LLM → réponse → payload → écran.

## Données
| Couche | Contenu | Écrit par | Format |
|---|---|---|---|
| Exactes | items, recettes (`data/*/recipe/*.json`), noms FR/EN (`assets/*/lang/*.json`) extraits des jars | script, jamais l'IA ; relancé à chaque maj mod | SQLite local, regénérable, **jamais commité** ni dans un mod (contenu des mods, souvent All Rights Reserved ; dépôts publics) |
| Fiches mods | 1 fiche caveman/mod (ajouts, mécaniques, pièges, version, sources) + `index.md` 1 ligne/mod ; résumés rédigés, pas de copie de texte des pages/wikis | pré-base (agents + vérif), puis IA / nistroy | md git |
| Notes apprises | fait + source + version mod + date + statut `non-vérifié` / `confirmé-joueur` / `validé-nistroy` / `contesté` | IA, votes, nistroy | md git, statut en frontmatter |
| Index recherche | FTS sur fiches + notes | reconstruit | SQLite, jetable |
| Historique + votes | par joueur (UUID) | service | SQLite, sauvegardé, **jamais commité** (questions privées) |

## Règles de réponse
- Source obligatoire (mod + lien ou fichier). Pas de source → "je sais pas".
- Priorité sources : données exactes > notes `validé-nistroy` > fiches > Modrinth/GitHub.
- Vérifier version mod / MC de toute source web.
- Note `non-vérifié` jamais présentée comme sûre.
- Vote ✘ → note `contesté` + nouvelle recherche. Rien supprimé automatiquement.
- Réorganisation des connaissances par l'IA OK, toujours en commit (diff visible, revert).
- Quota questions/joueur/jour (limites tier gratuit visibles seulement dans AI Studio).
- Message "je cherche…" immédiat (recherche = plusieurs secondes).
- Trop strict → "je sais pas" partout → personne l'utilise : calibrer via jeu de questions test.

## Étapes (ordre ; chacune utile seule)
1. **Fiches mods + extraction jars.** Sources : API Modrinth (`curl`), contenu des jars, wiki du mod. Agents parallèles OK
   (CLAUDE.md §Subagents), sorties vérifiées. Fini = 1 fiche/mod sourcée + `index.md` + DB items/recettes.
2. **Cerveau + jeu de questions test** (vraies questions des potes + pièges attendant "je sais pas"). Mesure : % justes,
   % "je sais pas", 0 invention. Utilisable en CLI sans MC.
3. **Mod serveur** : `/ia`, passerelle HTTP async, réponses privées, boutons ✔/✘ cliquables. Installation = garde-fous
   CLAUDE.md (backup, redémarrage demandé).
4. **Mod client** : écran + historique + votes. Touche par défaut définie dans le mod (pack : `options.txt` en
   `preserve` → nouvelles touches jamais poussées aux potes).
- Nouveau programme → TDD + CI s'activent : proposer diff CLAUDE.md au démarrage (§Evolution).

## À revérifier au démarrage (peut avoir changé)
- Modèles, tier gratuit, thinking Gemini : `ai.google.dev/gemini-api/docs/models`, `/pricing`, `/thinking`.
- Python `urllib` SSL cassé sur ce Mac → vérifier que `google-genai` fonctionne (sinon `certifi`).
- Fabric networking + écrans : `docs.fabricmc.net`, version 1.21.1.
- Liste mods finale : `MODS.md`.

## Sécurité
- Clé Gemini hors dépôt (`~/.config/…`), jamais lue ni affichée (`test -s` seulement).
- Cerveau écoute `127.0.0.1` seulement, jamais via tunnel playit.
- Payloads validés côté serveur (taille max, joueur connecté). Texte joueur jamais passé au shell ni à la console.
- IA : aucun accès console / commandes MC.
- Dépôts publics OK (validé nistroy) si clé + conversations hors dépôt.

## Ouvert
- Dépôts : proposition `minecraft-ia` (code, flux PR) + `minecraft-ia-kb` (connaissances, IA commit direct). À confirmer.
- Touche d'ouverture de l'écran.
- Quota par joueur.

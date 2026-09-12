---
name: explain-commit
description: >-
  Explique en détail et presque ligne par ligne les modifications apportées par un ou plusieurs commits Git.
  À utiliser lorsque l'utilisateur demande d'expliquer, analyser ou décortiquer un commit (ex: 'explique le commit abc123',
  'analyse les 3 derniers commits ligne par ligne', 'revue du diff').
---

# Workflow d'Explication de Commits (Ligne par Ligne)

Ce skill guide l'analyse approfondie et pédagogique de commits Git (un seul commit par défaut, ou une plage/série de commits).

---

## ⚡ Principes Directeurs

1. **🚫 Analyse Statique Pure (Pas d'Exécution)** : Ne JAMAIS lancer de tests, ni les scripts du projet (`./mc`, `backup.sh`, `server/start.sh`), ni démarrer le serveur. L'analyse est purement statique et documentaire.
2. **Pédagogie & Précision** : Expliquer les intentions, le code ligne par ligne et les impacts sans supputations.
3. **Restitution Sélective par Artifact** :
   - **Commits substantiels / techniques (`feat`, `fix`, `refactor`, `perf`, changements de scripts ou de config serveur)** : Rédiger l'explication sous la forme d'un artifact Markdown dédié nommé d'après le message du commit (ex: `commit_explanation_<slug_du_message>.md`).
   - **Commits mineurs ou d'accompagnement (`docs`, `chore`, `style`, retouches mineures)** : **NE PAS créer d'artifact**. Expliquer ou synthétiser ces commits directement dans le message de réponse pour ne pas encombrer les artifacts.

---

## Étape 1 : Extraction du Contexte Git

1. **Identification de la cible :**
   - Si un hash de commit est fourni : `rtk git show <hash>`
   - Si une plage est fournie (ex: `HEAD~3..HEAD` ou `branchA..branchB`) : `rtk git log --oneline <plage>` puis `rtk git log -p <plage>`
   - Si aucun hash n'est spécifié : vérifier le dernier commit avec `rtk git show HEAD` ou demander confirmation.
   - Si le diff paraît volumineux : inspecter d'abord la liste des fichiers modifiés avec `rtk git show --stat <hash>`.

2. **Inspection du contexte :**
   - Si une ligne modifiée dépend d'une fonction, variable ou option distante (fonction `send()` de `mc`, clé de `server.properties`, variable de `start.sh`), utiliser `view_file` ou `grep_search` pour examiner le code environnant afin d'offrir une explication exacte et sans supputations.
   - Pour une option Minecraft/Fabric ou un mod, ne pas deviner son effet : se référer à la doc officielle ou à `MODS.md`.
   - **Rappel Strict** : Ne lancer aucune commande d'exécution en arrière-plan.

---

## Étape 2 : Filtrage & Création des Artifacts d'Analyse

Pour chaque commit analysé :

1. **Évaluer l'utilité d'un Artifact** :
   - **Commits de Documentation / Trivial (`docs:`, `chore:`, typos, formatting)** : Expliquer brièvement dans le corps de la réponse textuelle (ex: *"Commit `351f03b` (`refactor`) : Regroupement des fichiers Discord dans `discord/`."*). **Aucun artifact n'est généré pour ce type de commit.**
   - **Commits de Code / Feature / Fix / Refactor (`feat:`, `fix:`, `refactor:`, `perf:`)** : Créer un **Artifact Markdown dédié** au format `commit_explanation_<slug_du_message>.md`.

2. **Format de l'Artifact (uniquement pour les commits substantiels)** :
   - Nommage : `commit_explanation_<slug_du_message>.md` (kebab-case/slug du message sans caractères spéciaux).

### Structure du Document Artifact :

# 📖 Analyse Détaillée du Commit `<hash>`

## 1. 📌 Résumé Global
- **Objectif du/des commit(s)** : Pourquoi ce changement a-t-il été effectué ? (Bug fix, refactoring, nouvelle fonctionnalité, optimisation).
- **Périmètre & Fichiers touchés** : Liste concise des scripts, fichiers de config et docs impactés.

---

## 2. 🔍 Analyse Détaillée des Fonctions & Fichiers (Ligne par Ligne)

Pour chaque fichier modifié :

### 📄 `chemin/vers/fichier.ext`

Pour chaque fonction ou bloc de modifications (hunk) :

```diff
- code supprimé ou modifié
+ nouveau code ajouté
```

- **Explication ligne par ligne / bloc par bloc :**
  - **Ligne `X` à `Y` (`+` / `-`)** : Explication précise de la syntaxe et de l'instruction (options bash, pipes, `set -euo pipefail`, quoting…).
  - **Rôle de la fonction / ligne** : Ce que fait la fonction et pourquoi elle est nécessaire.
  - **Raison du changement** : Pourquoi cette ligne a été modifiée/ajoutée plutôt que l'ancienne.
  - **Subtilités techniques** : Cas limites (serveur arrêté, session tmux absente, fichier manquant), effets de bord, dépendances impactées.

---

## 3. 🧪 Analyse des Fichiers de Tests Modifiés (si applicable)

*(Ne s'applique que si le commit inclut des fichiers de test. Ne JAMAIS lancer les tests.)*
Pour chaque fichier de test ajouté ou modifié :

- **Quoi (Périmètre couvert)** : Quels scripts ou fonctions sont testés ?
- **Comment (Méthodologie & Scénarios)** :
  - Quelles données ou faux outils (*fixtures*, faux `tmux`, dossier temporaire) sont mis en place ?
  - Quelles assertions sont écrites dans le code ?
  - Quels cas limites ou scénarios d'erreur sont simulés ?
- **Pourquoi (Raison d'être des tests)** :
  - Quel risque ou régression ce test empêche-t-il ?
  - Pourquoi ces cas spécifiques ont-ils été retenus plutôt que d'autres ?

---

## 4. 🛡️ Impact, Risques & Recommandations
- **Monde & Données** : Le changement peut-il affecter le monde, les sauvegardes ou nécessiter un redémarrage ?
- **Joueurs** : Impact visible pour les amis (mods côté client à installer, coupure, adresse, whitelist) ?
- **Sécurité** : Secrets exposés, entrées non échappées envoyées à la console, permissions.

---

## Conseils de Rédaction

- **Artifact Obligatoire** (commits substantiels) : Générer le document via les outils de création d'artifact pour préserver la richesse des explications.
- **Précision absolue** : Ne devine jamais la raison d'un paramètre ou d'une option ; vérifie dans le code source ou la doc si nécessaire.
- **Lisibilité** : Utilise des blocs de code diff colorés et des listes à puces claires.
- **Pédagogie** : Explique non seulement *ce que fait* la ligne, mais *pourquoi* elle a été écrite ainsi.
- **🚫 Pas d'exécution** : Ne lancer aucun script, test ou serveur en arrière-plan.

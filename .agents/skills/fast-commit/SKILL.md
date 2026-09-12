---
name: fast-commit
description: >-
  Effectue rapidement un ou plusieurs commits Git sur les modifications en cours.
  Découpe intelligemment les changements en commits atomiques et clairs sans faire de session à rallonge.
  À utiliser lorsque l'utilisateur demande de 'commiter', 'commit les fichiers', 'sauvegarder les changements' ou 'découper les commits'.
---

# Workflow de Commit Rapide (Fast Commit)

Ce skill permet d'analyser, découper et créer un ou plusieurs commits de manière rapide, efficace et directe.

---

## ⚡ Principes Directeurs

1. **Vitesse & Autonomie** : Minimiser les échanges conversationnels. Ne poser de questions qu'en cas d'ambiguïté réelle.
2. **🚫 Pas d'Exécution** : Ne JAMAIS lancer de tests, de linter, ni les scripts du projet (`./mc`, `backup.sh`, `server/start.sh`) avant/après le commit. Suivre les consignes et commiter, sans phase de validation.
3. **🚫 Interdiction Absolue de Modifier les Fichiers** : Ne JAMAIS modifier, corriger, formater ou toucher aux fichiers du projet. Si un hook pre-commit ou une commande git échoue, **s'arrêter immédiatement**, ne rien modifier et remonter l'erreur brute à l'utilisateur.
4. **Commits Atomiques** : Si des fichiers concernent des sujets différents (ex: script `mc` + config serveur + docs), découper en plusieurs commits distincts.
5. **Norme Conventional Commits** : Messages en anglais, clairs et normés (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `style:`, `test:`, `perf:`).
6. **🚫 Pas de Push** : Ne jamais pousser la branche ni ouvrir de PR sans demande explicite.

---

## 🌿 Étape 1 : Vérification de la Branche & Isolation (Branching)

1. Obtenir le nom de la branche courante :
   ```bash
   rtk git branch --show-current
   ```
2. **Si la branche courante est `main`** :
   - Déduire automatiquement le type de changement principal (`feat`, `fix`, `docs`, `refactor`, `chore`).
   - Nommer et créer une branche dédiée au format `<type>/<sujet-court-kebab-case>` (ex: `fix/backup-rotation`, `feat/mc-restore-command`, `docs/mods-results`).
   - Exécuter immédiatement :
     ```bash
     rtk git checkout -b <type>/<sujet-court-kebab-case>
     ```
   - *Remarque* : Ne jamais commiter directement sur `main`.
3. **Si on est déjà sur une branche de travail** : rester dessus.

---

## 🔍 Étape 2 : Inspection des Modifications

Exécuter rapidement :
```bash
rtk git status --short
rtk git diff --stat
```

- Vérifier s'il y a des fichiers non suivis (*untracked*) ou des modifications indexées (*staged*) / non indexées (*unstaged*).
- **Garde-fou Sécurité / Ambiguïté** : Si des fichiers sensibles (`playit/secret.txt`, `playit/claim-code.txt`, tokens, `.env*`, archives `*.tar.gz`, fichiers de `server/world/`) ou ambigus apparaissent, demander confirmation à l'utilisateur avant de les inclure.
- **Rappel Strict** : Ne lancer AUCUNE commande de test ni aucun script.

---

## 📦 Étape 3 : Groupement Intelligent des Changements

Organiser les fichiers en groupes logiques et cohérents. Exemples :
- **Groupe 1 (Scripts)** : `mc`, `backup.sh`, `discord-mcp.sh`, `server/start.sh`.
- **Groupe 2 (Config serveur)** : `server/server.properties`, `.gitignore`, config des mods.
- **Groupe 3 (Docs / Discord / Agents)** : `README.md`, `MODS.md`, `DISCORD.md`, `discord/`, `CLAUDE.md`, `.agents/`.

*Remarque : Si tous les changements concernent une seule et même tâche, effectuer 1 seul commit.*

---

## 🚀 Étape 4 : Exécution des Commits

Pour chaque groupe logique :

1. Indexer uniquement les fichiers du groupe :
   ```bash
   rtk git add <fichier1> <fichier2> ...
   ```
2. Créer le commit avec un message concis au format Conventional Commit :
   ```bash
   rtk git commit -m "<type>(<scope>): <description courte>"
   ```

⚠️ **En cas d'échec du commit (hooks pre-commit, etc.)** :
- Ne **JAMAIS** tenter de corriger soi-même.
- Ne modifier aucun fichier.
- Afficher l'erreur retournée et s'arrêter immédiatement pour laisser l'utilisateur gérer la situation.

---

## 📊 Étape 5 : Synthèse Rapide

Une fois les commits créés, afficher un récapitulatif synthétique :
- Nom de la branche (créée ou existante).
- Liste des commits créés (hash court + message).
- État final (`git status --short`).

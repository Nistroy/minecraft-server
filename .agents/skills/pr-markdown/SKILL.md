---
name: pr-markdown
description: >-
  Génère une description de Pull Request (PR) en Markdown clair, synthétique et sobre.
  Analyse automatiquement la branche Git par rapport à main
  et produit un résumé à haut niveau structuré (Contexte & Problème, Résumé des changements, Comment tester).
  À utiliser lorsque l'utilisateur demande '/pr', '/pr-markdown', une 'description de PR', de 'générer la PR', le 'markdown de PR' ou un 'summary PR'.
---

# Skill PR Markdown (Générateur de PR Sobres & Synthétiques)

Ce skill analyse les modifications apportées sur la branche Git courante par rapport à `main` et génère une description de Pull Request claire, professionnelle et synthétique.

---

## ⚡ Principes Directeurs

1. **Concision & Direct au but** : Aller immédiatement à l'essentiel. Éviter les phrases à rallonge, le blabla explicatif et le jargon superflu. Utiliser un style télégraphique et dynamique.
2. **Hauteur de vue & Synthèse** : Donner la vue d'ensemble des évolutions par domaine. Ne JAMAIS lister les détails micro-techniques ou ligne par ligne.
3. **Diagrammes Mermaid (quand pertinent)** : Intégrer un schéma `mermaid` (flowchart, sequenceDiagram, etc.) lorsque la PR implique un flux (joueur → tunnel playit → serveur, script `mc` → tmux → console, vote Discord → `MODS.md` → installation), un changement d'architecture ou une séquence d'interactions.
4. **Emojis avec parcimonie** : Quelques emojis ciblés sont autorisés pour améliorer la lisibilité, sans surcharger la mise en page.
5. **Structure Universelle en 3 axes** :
   - **Contexte & Problème** (Besoin ou problème en 1-2 phrases courtes max)
   - **Résumé des changements** (Graphes Mermaid si pertinent + puces ultra-concises par domaine)
   - **Comment tester** (Étapes simples et concrètes)
6. **Impact joueurs visible** : Si la PR impose quelque chose aux amis (nouveaux mods côté client, redémarrage, nouveau monde, changement d'adresse), le signaler explicitement dans le résumé.

---

## 🔍 Étape 1 : Inspection de la Branche Git

1. **Branche de référence** : `main`.

2. **Récupérer la liste des commits de la branche** :
   ```bash
   rtk git log main..HEAD --oneline
   ```

3. **Obtenir la liste des fichiers modifiés et les statistiques** :
   ```bash
   rtk git diff --stat main...HEAD
   ```

---

## 📝 Étape 2 : Analyse et Synthèse à Haut Niveau

- Regrouper les modifications par grands domaines du projet :
  - **scripts** (`mc`, `backup.sh`, `discord-mcp.sh`)
  - **serveur** (`server/start.sh`, `server/server.properties`, mods)
  - **tunnel** (`playit/`)
  - **discord** (`discord/`, `DISCORD.md`)
  - **docs** (`README.md`, `MODS.md`, `docs/`)
  - **agents** (`CLAUDE.md`, `.agents/`)
- Évaluer si un diagramme `mermaid` apporte une réelle clarté visuelle.
- Rédiger des puces très courtes et percutantes (ex: `- **scripts** : \`./mc status\` affiche aussi la RAM du serveur.`).

---

## 📄 Étape 3 : Structure du Markdown à Générer

Présenter le résultat final dans ce format exact :

```markdown
# [Titre explicite et concis de la PR]

## Contexte & Problème
[Résumé direct du besoin en 1 à 2 phrases max.]

## Résumé des changements

```mermaid
[Graphique Mermaid optionnel si pertinent (ex: flowchart ou sequenceDiagram)]
```

- **[Domaine 1]** : Évolution synthétique (puces courtes)
- **[Domaine 2]** : Évolution synthétique (puces courtes)

## Comment tester
1. [Étape concrète 1, ex: `./mc start` puis vérifier `Done (` dans `./mc log`]
2. [Étape concrète 2]
```

---

## 🚀 Étape 4 : Sortie

Afficher le bloc Markdown prêt à copier-coller dans GitHub. Pour ouvrir la PR : pousser la branche puis `gh pr create --title "<titre>" --body-file <fichier>` ; push + PR + merge du travail vérifié sans validation (`CLAUDE.md` §Git).

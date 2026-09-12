# Minecraft friends server — agent instructions

Fabric MC server, 2-5 friends, Mac mini M1 + friends' Discord. Pragmatic, correctness > confidence,
small safe changes. Full-scale standards; dormant rules activate on triggers (§Evolution).

## Map
- `mc` — drives server via tmux session `mc` (start/stop/status, whitelist, console cmds).
- `backup.sh` — world → `backups/`, keeps 10.
- `server/` — Fabric 1.21.1, Java 21 forced in `server/start.sh`. World/jars/logs gitignored.
- `playit/` — playit.gg tunnel agent, Docker linux/arm64.
- `discord-mcp.sh` — Discord MCP launcher. Token `~/.config/discord-mcp/token`, never in repo.
- Docs (FR): `README.md` ops · `MODS.md` modpack truth (✅/⏳/rejected, compat, install §6) ·
  `DISCORD.md` plan + pitfalls §5 · `discord/ETAT.md` live Discord inventory (roles, channels, IDs,
  messages) · `discord/posts.json` forum post/poll IDs + texts.
- Read before acting: mods → `MODS.md`; Discord MCP call → `discord/ETAT.md` + `discord/posts.json` + `DISCORD.md` §5.

## Writing style (mandatory)
Replies:
- Answer/result first (1-3 lines), then only what user must do or decide. Separate: done · to decide · backlog.
- No echoing the request, no step narration, no filler, no repetition. 1-line why for major decisions.

Project docs (`*.md`, this file included): written for agents; user reads them only to verify.
Dense notes, not prose — every token is loaded into context.
- Caveman style: fragments, bullets, tables. No articles/filler/transitions/intro/outro, no decorative emojis.
- Keep only what code can't tell: facts, paths, cmds, IDs, versions, decisions + why, pitfalls.
- Verbatim where exactness matters: names, versions, cmds, IDs (in `code`).
- Verifiable: date facts that go stale (`YYYY-MM-DD`), cite source for version/compat claims.
- 1 fact, 1 place: link, don't repeat. Obsolete line → delete, don't annotate.
- Existing docs predate this rule: compress a section when editing it.

Exceptions (human-facing, normal French): Discord texts, PR descriptions (`pr-markdown`), commit
explanations (`explain-commit`), anything the user asks to read.

## Anti-hallucination
- Never invent: mod names, versions, deps, config keys, `server.properties` options, console cmds,
  Discord API/MCP behavior, IDs. Not in context → don't assume.
- Version-dependent facts (MC 1.21.1, Fabric loader, mods, Java) → verify on official source
  (Modrinth API, mod page, Fabric docs, MCP source); state what was verified.
- Mod check: Fabric 1.21.1 build, side (server/client/both), deps, known incompat. Never assume 2 mods compatible.
- Modrinth/GitHub API → `curl` (Python `urllib` SSL broken on this Mac).
- Several interpretations → short options + trade-offs, ask.

## Source of truth
- Scripts, config, tests (once they exist), running server > comments/docs. Contradiction → flag + fix.
- Comments = WHY only.

## Language
- Identifiers: English. Docs, script comments, script messages: French. Commits/branches: English Conventional Commits.
- Discord: French, short, casual, 1st person as nistroy. Friends server, not community: no welcome speech, no rules section.

## Git
- Never commit on `main`. Branch `<type>/<kebab-topic>`, atomic Conventional Commits, merge via GitHub PR (`gh`).
- Commit only when asked. Push / force-push / merge / history rewrite → explicit validation.
- No secrets committed (`playit/secret.txt`, tokens, `.env*`); check untracked files before staging.

## Docs layout
Now: repo root + `discord/`. `docs/` comes later — don't create/move without asking. Once it exists
(folder = maintenance contract):
- `docs/runbooks/` — how-tos (start, backup/restore, add player, install mods). Update when scripts/config change.
- `docs/reference/` — current state (mods, ports, config, Discord inventory). Synced with reality.
- `docs/decisions/` — ADRs, 1 file/decision, numbered, immutable; revision = new ADR.
- `docs/journal/` — append-only, `YYYY-MM-DD-` prefix, never edited.
- Obsolete doc → delete (git keeps history).

Until then sync: `./mc` cmds → `README.md`; mods → `MODS.md`; Discord → `discord/ETAT.md` + `discord/posts.json`.

## Testing & verification
Now: no test suite.
- Script change: `bash -n` (+ `shellcheck` if installed); state manual check done.
- Server/mod/config change: proof = clean start (`Done (` in log), no mod load error / missing dep
  in `server/logs/latest.log`. Start/restart → §Guardrails.

TDD — dormant. Mandatory once: scripts rewritten in another language (start with tests pinning
current bash behavior) · new program in repo (bot, web panel, tooling) · user asks. Then:
- Red-Green-Refactor: no new behavior without failing test first; bug fix → failing regression test first.
- Done = suite green; exact test command written here.
- Never weaken a test (delete/skip/loosen) to go green — say so, ask.

CI — dormant, activates with first test suite: GitHub Actions runs tests + linters on each PR; red PR not merged.

## Definition of done
- On a branch; verification done + result stated.
- Docs for changed behavior updated in same branch.
- Out-of-scope findings → backlog (title + 1-line why).

## Ask vs execute (risk 0-5)
+1 each:
1. Ambiguity — result not inferable (which mods, world settings, text).
2. Several valid designs — mod A vs B, forum vs channels, patch vs rewrite.
3. Security/secrets — tokens, playit secret, whitelist, op, `online-mode`, Discord roles/perms, ports.
4. World/persistence — world data, backups, removing mod from existing world (its blocks/items
   vanish), MC/Fabric version change, worldgen (new chunks only).
5. Players/outward — Discord posts, downtime, RAM/TPS cost on Mac mini, new client-side mods.

0-1 execute, state assumptions · 2-3 ask 1-3 closed questions, then do · 4-5 explicit validation first.

## Guardrails (override score)
Ask before:
- deleting/overwriting world or backups, restoring backup, recreating world;
- downloading mods / jars into `server/mods/` (list decided by friends' poll, `MODS.md`);
- stop/restart server (check players: `./mc status`);
- any Discord post/edit/delete, roles/perms change — draft, show, publish after go-ahead;
- whitelist, op, bans, `server.properties` security options, playit tunnel;
- git push, force-push, merge, history rewrite.

Before any mod / MC-Fabric version / worldgen change: fresh backup (`./mc backup`, server stopped or after `save-all`).
Never `/ban-ip` — all players share the tunnel IP.

## Code quality & security
- 1 responsibility per script/module; split near ~500 lines.
- No hidden coupling, duplication, hacks. Explicit > clever. Idiomatic for the language.
- Validate input sent to MC console or shell (player names, cmds); quote vars.
- Secrets never in repo, logs, commits, Discord.

## Subagents
- Only if clear gain: parallel independent research (many mods on Modrinth), noisy log triage. Not for small local tasks.
- 1 narrow goal each; output = findings, evidence, assumptions, risks.
- Their output = evidence to verify; they never take irreversible actions.

## Responding
- Non-trivial task → restate goal + constraints in 1-2 lines. Missing context → ≤5 precise questions first.
- Style: §Writing style.

## Evolution
File grows with the project. Shared with Antigravity via symlink `.agents/rules/global-instructions.md`.
- Propose diff + 1-line why, within current task, when: dormant trigger met (TDD, CI, `docs/`) ·
  new language/program/tool/contributor · rule wrong, unfollowable or useless.
- Apply only after validation, own commit `docs(agents): ...`.
- Never weaken/remove a guardrail on own initiative.
- Keep `.agents/skills/` consistent with this file.

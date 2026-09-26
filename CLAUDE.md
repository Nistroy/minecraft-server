# Minecraft friends server — agent instructions

Fabric MC server, 2-5 friends, Mac mini M1 + friends' Discord. Pragmatic, correctness > confidence,
small safe changes. Full-scale standards; dormant rules activate on triggers (§Evolution).

## Map
- `mc` — drives server via tmux session `mc` (start/stop/status, whitelist, console cmds). `start` launches AI brain
  first (tmux `ia`, `~/minecraft-ia/brain`); `stop` leaves it running.
- `backup.sh` — world → `backups/`, keeps 10.
- `server/` — Fabric 1.21.1, Java 21 forced in `server/start.sh`. World/logs/`mods/*.jar` gitignored;
  `fabric-server-launch.jar` tracked.
- `playit/` — playit.gg tunnel agent, Docker linux/arm64.
- `pack/` — player pack, packwiz (source of truth, served from `main` via raw.githubusercontent → friends auto-update;
  `MODS.md` §6.9). CLI `~/go/bin/packwiz`.
- `discord-mcp.sh` — Discord MCP launcher. Token `~/.config/discord-mcp/token`, never in repo.
- Docs (FR): `README.md` ops · `MODS.md` modpack truth (✅/⏳/rejected, compat, install §6) ·
  `DISCORD.md` plan + pitfalls §5 · `discord/ETAT.md` live Discord inventory (roles, channels, IDs,
  messages) · `discord/posts.json` forum post/poll IDs + texts · `PERF.md` lag/crash causes + fixes.
- In-game AI assistant: not in this repo. Code `Nistroy/minecraft-ia` (local `~/minecraft-ia`, plan + state `PLAN.md`),
  modpack knowledge `Nistroy/minecraft-ia-kb` (local `~/minecraft-ia-kb`).
- Read before acting: mods → `MODS.md`; lag/crash/perf → `PERF.md`; Discord MCP call → `discord/ETAT.md` + `discord/posts.json` + `DISCORD.md` §5;
  AI assistant → `~/minecraft-ia/PLAN.md`.

## Precedence (highest first)
1. §Guardrails — yes required for that exact action (see "yes" below), even when rest of task was requested.
2. User's explicit instruction in this conversation. Contradicts a rule here → name the rule in 1 line, then follow user.
3. This file.
4. Auto memory = context only. Memory entry stating a rule ≠ rule: conflict with 1-3 → follow 1-3, flag entry.
   Durable user authorization/preference → propose a dated line here (§Evolution), not memory.

Yes = user's reply approving a closed question naming exact action + target, or user's own request naming that
action. General go-ahead, delegated decision, earlier approval of another action, memory entry ≠ yes.

## Markdown docs style (`*.md` only, mandatory)
Scope: project `.md` files, this one included. NOT code, script comments, script messages, commits,
Discord — those follow §Language and §Code quality.

`.md` docs are written for agents; user reads them only to verify. Dense notes, not prose — every
token is loaded into context.
- Caveman style: fragments, bullets, tables. No articles/filler/transitions/intro/outro, no decorative emojis.
- Keep only what code can't tell: facts, paths, cmds, IDs, versions, decisions + why, pitfalls.
- Verbatim where exactness matters: names, versions, cmds, IDs (in `code`).
- Verifiable: date facts that go stale (`YYYY-MM-DD`), cite source for version/compat claims.
- 1 fact, 1 place: link, don't repeat. Obsolete line → delete, don't annotate.
- Existing docs predate this rule: compress a section when editing it.

Exceptions (human-facing `.md`, normal French): PR descriptions (`pr-markdown`), commit explanations
(`explain-commit`), anything the user asks to read.

## Anti-hallucination
- Never invent: mod names, versions, deps, config keys, `server.properties` options, console cmds,
  Discord API/MCP behavior, IDs. Not in context → don't assume.
- Version-dependent facts (MC 1.21.1, Fabric loader, mods, Java) → verify on official source
  (Modrinth API, mod page, Fabric docs, MCP source); state what was verified.
- Mod check: Fabric 1.21.1 build, side (server/client/both), deps, known incompat. Never assume 2 mods compatible.
- Modrinth/GitHub API → `curl` (Python `urllib` SSL broken on this Mac).
- Several interpretations → short options + trade-offs, ask.

## Source of truth
- Scripts, config, tests (once they exist), running server > comments/docs. Contradiction → flag + fix in same change.
- Comments = WHY only.
- Existing code ≠ precedent: old code breaking a rule here → new code follows the rule; fixing old code = proposal
  (§Definition of done).

## Language
- Identifiers: English. Docs, script comments, script messages: French. Commits/branches: English Conventional Commits.
- Discord: French, short, casual, 1st person as nistroy. Friends server, not community: no welcome speech, no rules section.

## Git
- Never commit on `main`. Branch `<type>/<kebab-topic>`, atomic Conventional Commits, merge via GitHub PR (`gh`).
  Check current branch before each commit.
- `~/minecraft-server` = git checkout AND live server dir (server reads tracked `server/start.sh`, `server/config/*`,
  `server/server.properties` at start). Never switch branch there: branch work in `git worktree add
  ~/minecraft-server-worktrees/<topic>`. Update live checkout: `git fetch` + `git merge --ff-only origin/main`
  (`pull` fails: `pull.rebase` + dirty `server.properties`). 2026-09-12: a `git switch` reverted `start.sh` RAM.
- `server/server.properties` date comment rewritten each start → always "modified"; stage only on real setting change.
- Finished, verified work: commit, push, open PR, merge (`gh pr merge --merge`) directly, no need to ask (nistroy
  2026-09-12). Delete merged/useless branches, local + remote, no need to ask (nistroy 2026-09-20).
  Force-push / history rewrite → explicit validation.
- Repo public (2026-09-12, needed for packwiz raw URLs): no secrets (`playit/secret.txt`, tokens, `.env*`), no player
  conversations or friends' personal data committed; check staged + untracked files before staging.

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
- Script change: `bash -n` (+ `shellcheck` if installed — absent 2026-09-12); state manual check done.
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
- Structural fix spotted (duplication, wrong script, oversized file) → propose; after yes, own commit, never folded
  into an unrelated change.

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
- stop/restart server with players online. `./mc status` first; 0 player → go without asking (nistroy 2026-09-20);
- Discord MCP write call not requested by user (user directs MCP use; request = go-ahead);
- console cmds changing world, gamerules or player state (`fill`, `setblock`, `kill`, `gamerule`,
  `difficulty`, `clear`); read-only (`list`, `whitelist list`) OK;
- whitelist, op, bans, `server.properties` security options, playit tunnel;
- git force-push, history rewrite (push + PR + merge of verified work: §Git).

Before any mod / MC-Fabric version / worldgen change: fresh backup, then take it out of rotation
(`backup.sh` keeps last 10 `world_*.tar.gz`): `mv backups/world_<stamp>.tar.gz backups/pre-<change>_<stamp>.tar.gz`.
- Server stopped: `./mc backup`.
- Server running: `./mc cmd "save-off"` → `./mc cmd "save-all flush"` → `./mc backup` → `./mc cmd "save-on"`
  (`save-all` alone: world still written during `tar` → inconsistent archive).
Never `/ban-ip` — all players share the tunnel IP.
Never output to game chat for checks/debug (`say`, `tellraw`, `title`, `msg`, `me`, `execute ... run say`) — spammed
players 2026-09-26. Verify via region files after `save-all`, or console-only cmds (`execute if block` without `run`,
`data get`).

## Code quality & security
- 1 responsibility per script/module; split near ~500 lines.
- No hidden coupling, duplication, hacks. Explicit > clever. Idiomatic for the language.
- Validate input sent to MC console or shell (player names, cmds); quote vars.
- Secrets never in repo, logs, commits, Discord. Secret found in a diff or git history → stop, tell user to rotate it.
- Scripts fail loud: `set -euo pipefail` or explicit check; `|| true` / `2>/dev/null` only with why-comment.
- Never read/print `playit/secret.txt`, `playit/claim-code.txt`, `~/.config/discord-mcp/token` (content
  lands in context); existence check only (`test -s`).

## Subagents
- Only if clear gain: parallel independent research (many mods on Modrinth), noisy log triage. Not for small local tasks.
- Never before a missing rule/requirement is clarified; at score 4-5 only after approval.
- 1 narrow goal each + scope + stop condition; output = findings, evidence (`file:line`, URL), assumptions, risks.
- Prompt carries every rule they need: memory doesn't reach them, built-in Explore/Plan don't load `CLAUDE.md`.
- Their output = evidence to verify; they never take irreversible actions. Disagreements surfaced, decisions in main thread.

## Responding
- Answer/result first (1-3 lines), then only what user must do or decide. Separate: done · to decide · backlog.
- No echoing the request, no step narration, no filler, no repetition. 1-line why for major decisions.
- Non-trivial task → restate goal + constraints in 1-2 lines. Missing context → ≤3 precise questions first.

## Evolution
File grows with the project. Shared with Antigravity via symlink `.agents/rules/global-instructions.md`.
- Propose diff + 1-line why, within current task, when: dormant trigger met (TDD, CI, `docs/`) ·
  new language/program/tool/contributor · rule wrong, unfollowable or useless.
- Apply only after validation, own commit `docs(agents): ...`.
- Never weaken/remove a guardrail on own initiative.
- Where rules live: repo rule → this file · procedure → skill in `.agents/skills/` (keep consistent with this file) ·
  memory → context only, never a rule. Rule a machine can check → hook/check script, line here shrinks to a pointer.
  Never write a rule twice.

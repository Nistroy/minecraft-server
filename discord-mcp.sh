#!/bin/bash
# Lance le MCP Discord (@quadslab.io/discord-mcp) pour Claude Code.
# Le token du bot est lu dans ~/.config/discord-mcp/token (jamais dans ce dossier).
TOKEN_FILE="$HOME/.config/discord-mcp/token"
NODE_BIN="$HOME/.nvm/versions/node/v24.12.0/bin"

if [ ! -s "$TOKEN_FILE" ]; then
  echo "Token Discord absent : mets le token du bot dans $TOKEN_FILE" >&2
  exit 1
fi

export PATH="$NODE_BIN:$PATH"
export DISCORD_TOKEN="$(tr -d '[:space:]' < "$TOKEN_FILE")"
export DISCORD_GUILD_ID="1548102098133061735"
exec npx -y @quadslab.io/discord-mcp@2.1.1

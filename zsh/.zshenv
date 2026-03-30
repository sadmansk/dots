# Sourced by all zsh instances (login, non-login, interactive, non-interactive).
# Keep this minimal - only environment variables that must always be available.

# Load secrets (API keys, tokens, etc.)
[[ -f ~/.secrets/env ]] && source ~/.secrets/env

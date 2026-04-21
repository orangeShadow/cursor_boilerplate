#!/usr/bin/env bash
set -euo pipefail

# Generic Confluence fetcher using local env and curl.
# Usage:
#   bash .cursor/skills/confluence-curl/scripts/fetch.sh "<PAGE_ID_OR_URL_OR_PATH>"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
ENV_FILE="${ROOT_DIR}/.cursor/.env"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE" 2>/dev/null || true
  set +a
fi

BASE_URL="${CONFLUENCE_BASE_URL:-}"
API_KEY="${CONFLUENCE_API_KEY:-${CONFLUENCE_TOKEN:-}}"
BASIC_AUTH="${CONFLUENCE_BASIC_AUTH:-}"
EMAIL="${CONFLUENCE_EMAIL:-}"
API_TOKEN="${CONFLUENCE_API_TOKEN:-}"
COOKIES="${CONFLUENCE_COOKIE:-${CONFLUENCE_COOKIES:-}}"
ARG="${1:-}"

if [[ -z "$BASE_URL" ]]; then
  echo "Missing CONFLUENCE_BASE_URL in .cursor/.env" >&2
  exit 1
fi

BASE_URL="${BASE_URL%/}"
HEADERS=(-H "Accept: application/json" -H "User-Agent: confluence-curl-skill")
AUTH_ARGS=()

if [[ -n "$API_KEY" ]]; then
  AUTH_ARGS+=(-H "Authorization: Bearer $API_KEY")
elif [[ -n "$BASIC_AUTH" ]]; then
  AUTH_ARGS+=(-H "Authorization: Basic $BASIC_AUTH")
elif [[ -n "$EMAIL" && -n "$API_TOKEN" ]]; then
  ENCODED="$(printf "%s" "${EMAIL}:${API_TOKEN}" | base64 | tr -d '\n')"
  AUTH_ARGS+=(-H "Authorization: Basic $ENCODED")
elif [[ -n "$COOKIES" ]]; then
  AUTH_ARGS+=(-b "$COOKIES")
fi

if [[ "$ARG" =~ ^[0-9]+$ ]]; then
  URL="${BASE_URL}/rest/api/content/${ARG}?expand=body.storage,version"
elif [[ "$ARG" =~ ^https?:// ]]; then
  URL="$ARG"
elif [[ -n "$ARG" ]]; then
  ARG="${ARG#/}"
  URL="${BASE_URL}/${ARG}"
else
  echo "Provide PAGE_ID, full URL, or relative path." >&2
  exit 1
fi

curl -sS -L "$URL" "${HEADERS[@]}" "${AUTH_ARGS[@]}"

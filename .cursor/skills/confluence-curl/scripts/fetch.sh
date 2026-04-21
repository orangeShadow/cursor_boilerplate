#!/usr/bin/env bash
set -euo pipefail

# Generic Confluence/Jira fetcher using local env and curl.
# Usage:
#   bash .cursor/skills/confluence-curl/scripts/fetch.sh confluence "<PAGE_ID_OR_URL_OR_PATH>"
#   bash .cursor/skills/confluence-curl/scripts/fetch.sh jira "/rest/api/2/myself"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
ENV_FILE="${ROOT_DIR}/.cursor/.env"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE" 2>/dev/null || true
  set +a
fi

TARGET="${1:-}"
ARG="${2:-}"

if [[ -z "$TARGET" || -z "$ARG" ]]; then
  echo "Usage: fetch.sh <confluence|jira> <page_id_or_url_or_path>" >&2
  exit 1
fi

HEADERS=(-H "Accept: application/json" -H "User-Agent: confluence-jira-curl-skill")

if [[ "$TARGET" == "confluence" ]]; then
  BASE_URL="${CONFLUENCE_BASE_URL:-}"
  API_KEY="${CONFLUENCE_API_KEY:-}"
  if [[ -z "$BASE_URL" || -z "$API_KEY" ]]; then
    echo "Missing CONFLUENCE_BASE_URL or CONFLUENCE_API_KEY in .cursor/.env" >&2
    exit 1
  fi
  BASE_URL="${BASE_URL%/}"

  if [[ "$ARG" =~ ^[0-9]+$ ]]; then
    URL="${BASE_URL}/rest/api/content/${ARG}?expand=body.storage,version"
  elif [[ "$ARG" =~ ^https?:// ]]; then
    URL="$ARG"
  else
    ARG="${ARG#/}"
    URL="${BASE_URL}/${ARG}"
  fi
  curl -sS -L "$URL" "${HEADERS[@]}" -H "Authorization: Bearer $API_KEY"
  exit 0
fi

if [[ "$TARGET" == "jira" ]]; then
  BASE_URL="${JIRA_BASE_URL:-}"
  API_KEY="${JIRA_API_KEY:-}"
  if [[ -z "$BASE_URL" || -z "$API_KEY" ]]; then
    echo "Missing JIRA_BASE_URL or JIRA_API_KEY in .cursor/.env" >&2
    exit 1
  fi
  BASE_URL="${BASE_URL%/}"
  ARG="${ARG#/}"
  URL="${BASE_URL}/${ARG}"
  curl -sS -L "$URL" "${HEADERS[@]}" -H "Authorization: Bearer $API_KEY"
  exit 0
fi

echo "Unknown target: ${TARGET}. Use 'confluence' or 'jira'." >&2
exit 1

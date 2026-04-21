---
name: confluence-curl
description: Generic Confluence reader via curl from the user's machine. Use when user asks to read Confluence/wiki/spec pages by URL or page id.
---

# Confluence via curl (generic)

## When to use

- User asks to read Confluence/wiki pages.
- Task includes Confluence links or page IDs.
- Need quick fetch of page content for analysis.

## Config (`.cursor/.env`)

Use project-local secrets only. Do not commit real credentials.

- `CONFLUENCE_BASE_URL` - Base URL without trailing slash.
  - Cloud example: `https://example.atlassian.net/wiki`
  - Server/DC example: `https://wiki.example.com`
- `CONFLUENCE_API_KEY` - Bearer token (preferred generic auth).
- `CONFLUENCE_TOKEN` - Alias for bearer token (optional compatibility).
- `CONFLUENCE_BASIC_AUTH` - Base64(email:api_token), optional.
- `CONFLUENCE_EMAIL` + `CONFLUENCE_API_TOKEN` - optional Basic auth source.
- `CONFLUENCE_COOKIE` or `CONFLUENCE_COOKIES` - session cookie fallback.

## Rules

1. Always execute requests with `curl` from the user's machine.
2. Prefer REST API by numeric page id:
   - `GET /rest/api/content/<PAGE_ID>?expand=body.storage,version`
3. Never print full secrets/cookies in chat output.
4. If `401/403`, ask user to refresh token/cookie in `.cursor/.env`.

## Quick commands

Health check:

```bash
curl -sS -L "${CONFLUENCE_BASE_URL%/}/rest/api/user/current" \
  -H "Authorization: Bearer ${CONFLUENCE_API_KEY:-$CONFLUENCE_TOKEN}" \
  -H "Accept: application/json"
```

Fetch page by id:

```bash
curl -sS -L "${CONFLUENCE_BASE_URL%/}/rest/api/content/<PAGE_ID>?expand=body.storage,version" \
  -H "Authorization: Bearer ${CONFLUENCE_API_KEY:-$CONFLUENCE_TOKEN}" \
  -H "Accept: application/json"
```

Cookie fallback:

```bash
curl -sS -L "${CONFLUENCE_BASE_URL%/}/rest/api/content/<PAGE_ID>?expand=body.storage,version" \
  -b "${CONFLUENCE_COOKIE:-$CONFLUENCE_COOKIES}" \
  -H "Accept: application/json"
```

## Script helper

Use:

```bash
bash .cursor/skills/confluence-curl/scripts/fetch.sh "<PAGE_ID_OR_URL_OR_PATH>"
```

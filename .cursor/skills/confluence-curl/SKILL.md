---
name: confluence-curl
description: Generic Confluence and Jira reader via curl from the user's machine using API keys only.
---

# Confluence + Jira via curl (API key only)

## When to use

- User asks to read Confluence/wiki pages.
- Task includes Confluence links or page IDs.
- User asks to check/read Jira issue data or Jira API endpoints.
- Need quick fetch of page content for analysis.

## Config (`.cursor/.env`)

Use project-local secrets only. Do not commit real credentials.

- `CONFLUENCE_BASE_URL` - Base URL without trailing slash.
  - Cloud example: `https://example.atlassian.net/wiki`
  - Server/DC example: `https://wiki.example.com`
- `CONFLUENCE_API_KEY` - Bearer token for Confluence.
- `JIRA_BASE_URL` - Jira base URL without trailing slash.
- `JIRA_API_KEY` - Bearer token for Jira.

## Rules

1. Always execute requests with `curl` from the user's machine.
2. Prefer REST API by numeric page id:
   - `GET /rest/api/content/<PAGE_ID>?expand=body.storage,version`
3. For Jira, use REST endpoints such as:
   - `GET /rest/api/2/myself`
   - `GET /rest/api/2/issue/<ISSUE_KEY>`
4. Never print full secrets in chat output.
5. If `401/403`, ask user to refresh API keys in `.cursor/.env`.

## Quick commands

Health check:

```bash
curl -sS -L "${CONFLUENCE_BASE_URL%/}/rest/api/user/current" \
  -H "Authorization: Bearer ${CONFLUENCE_API_KEY}" \
  -H "Accept: application/json"
```

Fetch page by id:

```bash
curl -sS -L "${CONFLUENCE_BASE_URL%/}/rest/api/content/<PAGE_ID>?expand=body.storage,version" \
  -H "Authorization: Bearer ${CONFLUENCE_API_KEY}" \
  -H "Accept: application/json"
```

Jira health check:

```bash
curl -sS -L "${JIRA_BASE_URL%/}/rest/api/2/myself" \
  -H "Authorization: Bearer ${JIRA_API_KEY}" \
  -H "Accept: application/json"
```

## Script helper

Use:

```bash
bash .cursor/skills/confluence-curl/scripts/fetch.sh confluence "<PAGE_ID_OR_URL_OR_PATH>"
bash .cursor/skills/confluence-curl/scripts/fetch.sh jira "/rest/api/2/issue/PROJ-123"
```

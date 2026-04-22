#!/bin/bash
# Hook: afterFileEdit
# After any file edit, check if docs might need updating.

input=$(cat)
file_path=$(echo "$input" | jq -r '.file_path // .path // empty' 2>/dev/null)

if [ -z "$file_path" ]; then
  exit 0
fi

# Only prompt for docs updates on architecture/workflow/config changes
if echo "$file_path" | grep -qi "rules/\|commands/\|skills/\|agents/\|README\|docs/"; then
  echo '{ "additional_context": "A workflow, architecture, or configuration file was edited. Consider using the docs-writer subagent to update related documentation." }'
  exit 0
fi

exit 0

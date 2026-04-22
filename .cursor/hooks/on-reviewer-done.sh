#!/bin/bash
# Hook: subagentStop (reviewer)
# After reviewer subagent completes, suggest next action based on review outcome.

input=$(cat)
result=$(echo "$input" | jq -r '.result // empty' 2>/dev/null)

if [ -z "$result" ]; then
  echo '{ "followup_message": "Reviewer subagent finished but returned no result. Check the subagent output manually." }'
  exit 0
fi

# Check if reviewer approved
if echo "$result" | grep -qi "Approve"; then
  echo '{ "followup_message": "Code review approved. Use the finishing-a-development-branch skill to finalize merge/PR." }'
  exit 0
fi

# Review requested changes
if echo "$result" | grep -qi "Request changes\|Needs discussion\|Critical\|High"; then
  echo '{ "followup_message": "Reviewer requested changes. Use the implementer subagent to address feedback, then re-run verification." }'
  exit 0
fi

# Default
echo '{ "followup_message": "Review complete. Check the reviewer output for details and decide next steps." }'
exit 0

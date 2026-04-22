#!/bin/bash
# Hook: subagentStop (verifier)
# After verifier subagent completes, suggest next action based on results.

input=$(cat)
result=$(echo "$input" | jq -r '.result // empty' 2>/dev/null)

if [ -z "$result" ]; then
  echo '{ "followup_message": "Verifier subagent finished but returned no result. Check the subagent output manually." }'
  exit 0
fi

# Check if verifier found issues
if echo "$result" | grep -qi "INCOMPLETE\|ISSUE\|broken\|failed\|error"; then
  echo '{ "followup_message": "Verifier found issues. Use the implementer subagent to address: " + result }'
  exit 0
fi

# All verified
echo '{ "followup_message": "Verifier confirmed all checks passed. Proceed to code review with the reviewer subagent." }'
exit 0

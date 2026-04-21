---
description: Review staged changes for risk, regressions, and missing checks
---

Review only staged changes.

Before commit:
- Run `/update-docs` to sync docs with current staged changes.

Prioritize:
- Functional regressions
- Missing tests or verification
- Risky edge cases
- Security and data-handling concerns
- Readability and maintainability risks

Output:
- Findings by severity
- Open questions/assumptions
- Suggested next checks before commit

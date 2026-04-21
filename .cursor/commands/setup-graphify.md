---
description: Install and configure graphify for Cursor in this project
---

Set up graphify in this project with a safe, repeatable flow.

Execution sequence:
1. Pre-checks:
   - Verify Python 3.10+ is available.
   - Prefer isolated install (`pipx`) when available; otherwise use project venv.
2. Install CLI:
   - `pip install graphifyy` (official package name is `graphifyy`).
   - Alternative: `pipx install graphifyy`.
3. Install Cursor integration:
   - Run `graphify cursor install`.
   - Verify `.cursor/rules/graphify.mdc` was created.
4. Optional repository hygiene:
   - Create/update `.graphifyignore` with heavy/generated paths (`node_modules`, `dist`, `vendor`).
   - Add `graphify-out/cache/` to `.gitignore`.
5. First graph build:
   - Run `/graphify .` (or `graphify .` if slash command is unavailable in current client).
6. Verification:
   - Confirm `graphify-out/GRAPH_REPORT.md` and `graphify-out/graph.json` exist.
   - Confirm graphify rule is active in Cursor.
7. Documentation sync:
   - Run `/update-docs` and add short usage notes to project docs.

Output format:
- `Install Status`
- `Integration Status`
- `Generated Artifacts`
- `Suggested Next Queries`

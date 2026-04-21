---
description: Bootstrap project context, detect stack, and propose iterative improvements
---

Run a project bootstrap interview and produce an actionable setup roadmap.

Execution sequence:
1. Ask the user:
   - What is the current project stack?
   - What is the delivery preference (speed vs reliability)?
   - Are there constraints (legacy code, deadlines, CI limits)?
2. If the user does not know the stack, run automatic repository analysis:
   - Detect stack markers: `package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, `Gemfile`, `Dockerfile`, compose files.
   - Detect quality tooling: tests, lint, format, typecheck, CI, docs, rules.
3. Detect stack-aware glob profile (`DetectStackGlobs`):
   - TypeScript/React profile:
     - `**/*.{ts,tsx,js,jsx}`
     - `**/*.{test,spec}.{ts,tsx,js,jsx}`
     - `**/*.{md,mdx}`
   - Python profile:
     - `**/*.py`
     - `**/tests/**/*.py`
     - `**/*.{md,rst}`
   - Docs profile:
     - `**/*.{md,mdx,rst,txt}`
   - Fallback mixed/unknown profile:
     - `**/*.{ts,tsx,js,jsx,py,md,mdx,rst}`
   - If confidence is low, show two close profile options and ask user to choose one.
4. Build a maturity snapshot:
   - What exists now
   - What is missing
   - Top technical risks
5. Propose 3-5 improvement tracks with smallest useful next step for each:
   - Code quality
   - Developer experience
   - CI/CD
   - Security baseline
   - Observability
6. Ask user to choose priority track(s).
7. Generate iterative bootstrap plan:
   - Step-by-step actions
   - Expected outcome per step
   - Verification for each step
8. Recommend next commands and skills to continue execution.

Output format:
- `Project Snapshot`
- `Detected/Selected Stack`
- `Recommended Rule Globs`
  - `.cursor/rules/10-bugfix-flow.mdc`
  - `.cursor/rules/20-verification-gates.mdc`
  - `.cursor/rules/40-docs-sync.mdc`
  - Notes for mixed/unknown fallback and confidence level
- `Improvement Tracks`
- `Recommended Iteration #1`
- `Next Commands`
- `Suggested Skills`

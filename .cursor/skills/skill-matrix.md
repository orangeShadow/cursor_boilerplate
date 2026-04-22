# Skill Matrix for Balanced Workflow

This matrix defines when to invoke each skill and subagent in everyday delivery.

## Subagent Routing Map

| Subagent | Model | Access | Paired Skill | Paired Rule | When to use |
|---|---|---|---|---|---|
| `planner` | inherit | readonly | `writing-plans` | `00-core-workflow` | Multi-step tasks, feature design |
| `implementer` | inherit | full | `test-driven-development` | `20-verification-gates`, `30-git-safety` | Executing approved plans |
| `verifier` | fast | readonly | `verification-before-completion` | `20-verification-gates` | After implementation, before commit |
| `reviewer` | inherit | readonly | `requesting-code-review`, `receiving-code-review` | — | Before PR, after implementation |
| `debugger` | inherit | full | `systematic-debugging` | `10-bugfix-flow` | Bugs, test failures, errors |
| `explorer` | fast | readonly | — | — | Unfamiliar code, dependency mapping |
| `refactorer` | inherit | full | `test-driven-development` | `20-verification-gates`, `30-git-safety` | Code restructuring, tech debt |
| `docs-writer` | fast | full | — | `40-docs-sync` | Doc updates after changes |

### When to use subagent vs skill directly

- **Subagent** — task needs context isolation, takes 3+ steps, or benefits from parallel execution
- **Skill** — single-purpose, repeatable action that completes in one shot

### Parallel execution scenarios

- `verifier` + `reviewer` — run simultaneously after implementation for speed
- `explorer` + `docs-writer` — explore code and update docs in parallel
- `planner` can launch `explorer` as a child to gather context

## Mandatory Order for Feature Work
1. `brainstorming` skill - clarify requirements and design options.
2. `planner` subagent (or `writing-plans` skill for simpler tasks) - convert approved design into executable steps.
3. `implementer` subagent (or `test-driven-development` skill for simpler tasks) - define and drive tests, then implement.
4. `verifier` subagent - independently validate before declaring done.
5. `reviewer` subagent (or `requesting-code-review` skill) - review code changes.
6. `receiving-code-review` skill - process review feedback rigorously.
7. `finishing-a-development-branch` skill - finalize merge/PR path.

## Bugfix Flow
1. `debugger` subagent (or `systematic-debugging` skill) - root-cause analysis.
2. `test-driven-development` skill - regression protection.
3. Implementation.
4. `verifier` subagent - confirm fix works.
5. `reviewer` subagent - review the fix.

## Refactoring Flow
1. `explorer` subagent - map dependencies and understand scope.
2. `refactorer` subagent - execute safe refactoring with test coverage.
3. `verifier` subagent - confirm behavior preserved.
4. `docs-writer` subagent - update documentation if needed.

## Decision Triggers
- Unclear requirement or behavior change: use `brainstorming` skill.
- Multi-step implementation (3+ steps): use `planner` subagent.
- Simple single-step plan: use `writing-plans` skill directly.
- Unfamiliar codebase area: use `explorer` subagent first.
- Any bug or flaky behavior: use `debugger` subagent or `systematic-debugging` skill.
- Before claiming success: always use `verifier` subagent.
- Explicit refactor request: use `refactorer` subagent.
- After `/start-project`, if user wants containerization: use `devops-docker-bootstrap` to build image.

## DevOps / Docker (Optional Track)
- `devops-docker-bootstrap` - prepares Dockerfile/build context, validates image build, and documents run commands.
- Trigger: user explicitly asks to containerize after bootstrap.
- Outcome: repeatable `docker build`/`docker run` path and updated docs.

## Knowledge Base / Confluence + Jira (Optional Track)
- `confluence-curl` - reads Confluence and Jira data via `curl` from the user's machine using API keys from `.cursor/.env`.
- Trigger: user asks to open wiki/spec pages in Confluence or check Jira entities via API.
- Outcome: fetched Confluence/Jira content for analysis without hardcoded org-specific settings.

## Practical Notes
- Keep solutions incremental; avoid broad rewrites unless requested.
- Prefer one logical goal per iteration.
- If uncertainty remains, pause and ask one focused question.
- Start with 2-3 focused subagents. Add more only when you have clear, distinct use cases.

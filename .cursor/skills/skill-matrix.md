# Skill Matrix for Balanced Workflow

This matrix defines when to invoke each skill in everyday delivery.

## Mandatory Order for Feature Work
1. `brainstorming` - clarify requirements and design options.
2. `writing-plans` - convert approved design into executable steps.
3. `test-driven-development` - define and drive tests for behavior changes.
4. Implementation execution.
5. `verification-before-completion` - validate before declaring done.
6. `requesting-code-review` - prep and request review.
7. `receiving-code-review` - process review feedback rigorously.
8. `finishing-a-development-branch` - finalize merge/PR path.

## Bugfix Flow
1. `systematic-debugging`
2. `test-driven-development` (for regression protection)
3. Implementation
4. `verification-before-completion`
5. `requesting-code-review`

## Decision Triggers
- Unclear requirement or behavior change: use `brainstorming`.
- Multi-step implementation: use `writing-plans`.
- Any bug or flaky behavior: use `systematic-debugging` first.
- Before claiming success: always run `verification-before-completion`.
- After `/start-project`, if user wants containerization: use `devops-docker-bootstrap` to build image.

## DevOps / Docker (Optional Track)
- `devops-docker-bootstrap` - prepares Dockerfile/build context, validates image build, and documents run commands.
- Trigger: user explicitly asks to containerize after bootstrap.
- Outcome: repeatable `docker build`/`docker run` path and updated docs.

## Knowledge Base / Confluence (Optional Track)
- `confluence-curl` - reads Confluence pages via `curl` from the user's machine using `.cursor/.env`.
- Trigger: user asks to open wiki/spec pages in Confluence.
- Outcome: fetched page content for analysis without hardcoded org-specific settings.

## Practical Notes
- Keep solutions incremental; avoid broad rewrites unless requested.
- Prefer one logical goal per iteration.
- If uncertainty remains, pause and ask one focused question.

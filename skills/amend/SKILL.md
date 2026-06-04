---
name: amend
description: Amend the latest git commit with local repository changes and push the amended branch. Use when the user asks to amend, fold changes into the previous commit, update the last commit, or amend and push. Inspects and stages intended local changes, runs focused tests, preserves or updates the structured commit message with TLDR, WHAT CHANGED, and TEST PLAN sections, syncs with main before pushing when appropriate, resolves safe sync conflicts, and pushes rewritten upstream history with force-with-lease.
---

# Amend

Fold current local changes into the latest commit.

## Workflow

1. Inspect:
   - `git status --short --branch`
   - `git diff --stat`
   - `git diff`
   - `git diff --cached`
   - `git log -1 --format=fuller`
   - Current branch and upstream state
2. Decide staging:
   - Stage intended local repo changes by default with `git add <paths>`.
   - Ask before staging files that appear unrelated, generated, secret-like, destructive, or ambiguous.
3. Verify:
   - Run focused relevant tests/checks for changed code.
   - If repo instructions require a full suite before amend, run it.
   - Record exact commands and PASS/FAIL/BLOCKED results.
4. Amend:
   - Use `git commit --amend`.
   - Preserve the subject unless the user asks for a new one.
   - Ensure the body uses the required message format and updates `WHAT CHANGED` and `TEST PLAN`.
5. Push:
   - `git fetch origin main`
   - Sync with main using the safest appropriate rebase/merge path when the
     repo workflow requires it and it can be done safely. This sync happens
     before every push.
   - Resolve conflicts using Conflict Handling when safe.
   - If the branch is `main`, `master`, or another protected base branch, do
     not push unless the user explicitly asked to rewrite that base branch.
   - If the branch had an upstream before the amend, push rewritten history
     with `git push --force-with-lease`.
   - If the branch has no upstream and has an `origin` remote, push with
     `git push -u origin <branch>`.
   - Pause on lease failures, auth failures, missing remotes,
     protected-branch risk, or unsafe rewrite risk.

## Conflict Handling

When sync reports conflicts:

- Run `git status --short` and inspect each unmerged file and conflict hunk.
- Resolve conflicts when the fix is clear, scoped to the current branch/main
  integration, and preserves both sides' intended behavior.
- Edit only conflicted files unless a minimal adjacent change is required to
  make the resolution build or test.
- Stage resolved files, then continue with `git rebase --continue` or
  `git merge --continue`.
- Rerun affected verification after resolving conflicts and update `TEST PLAN`.
- Pause and ask if the conflict touches unrelated, user-owned, generated, or
  secret-like files, requires product/design judgment, would discard work, or
  is not confidently resolvable.

## Message Format

Use a concise subject line, then this exact body structure:

```text
TLDR

<1-3 sentence summary>

WHAT CHANGED

- <bullet>
- <bullet>

TEST PLAN

- PASS: `<command>` — <short result>
- FAIL: `<command>` — <short reason>
- BLOCKED: `<command>` — <short reason>
```

Rules:
- Use uppercase headers exactly: `TLDR`, `WHAT CHANGED`, `TEST PLAN`.
- Include test commands and results in `TEST PLAN`.
- Prefer repo-relative paths.
- Trim long external paths with an ellipsis while preserving useful tail context.
- Do not paste long command logs.

## Command Scope

Use only the minimal needed commands:
- Inspect: `git status`, `git diff`, `git log`, `git branch`
- Stage: `git add`
- Amend: `git commit --amend`
- Sync/push: `git fetch`, `git rebase` or `git merge`, `git rebase --continue`, `git merge --continue`, `git push`, `git push --force-with-lease`
- Verify: repo-specific test/build commands required by the change

Do not create PRs from this skill.

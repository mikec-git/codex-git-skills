---
name: commit
description: Create and push a scoped git commit from local repository changes. Use when the user asks to commit, make a commit, save changes in git, or create a checkpoint commit. Inspects changes first, stages intended local repo files, runs focused tests, writes a structured commit message with TLDR, WHAT CHANGED, and TEST PLAN sections, syncs with main, resolves safe sync conflicts, then pushes the current task branch.
---

# Commit

Create one focused commit from the current repository state and push the
current task branch.

## Workflow

1. Inspect:
   - `git status --short --branch`
   - `git diff --stat`
   - `git diff`
   - `git diff --cached`
   - For untracked files, inspect names and contents enough to classify them.
2. Decide staging:
   - Stage intended local repo changes by default with `git add <paths>`.
   - Ask before staging files that appear unrelated, generated, secret-like, destructive, or ambiguous.
   - Do not stage files outside the repo.
3. Verify:
   - Run focused relevant tests/checks for changed code.
   - If repo instructions require a full suite before commits, run it.
   - Record exact commands and PASS/FAIL/BLOCKED results.
4. Commit:
   - Use `git commit` only after staging and verification.
5. Sync before pushing:
   - `git fetch origin main` when an `origin` remote exists.
   - Choose the safest appropriate strategy:
     - Rebase for simple or unpublished task branches.
     - Merge `origin/main` for already-pushed/shared branches when safer.
   - Resolve conflicts using Conflict Handling when safe.
   - Pause on non-fast-forward surprises, unsafe rewrite risk, or uncertainty
     about whether the branch should be rebased or merged.
6. Push:
   - Identify the current branch and upstream.
   - If the branch is `main`, `master`, or another protected base branch, do
     not push unless the user explicitly asked to push that base branch.
   - If the branch has an upstream, push with `git push`.
   - If the branch has no upstream and has an `origin` remote, push with
     `git push -u origin <branch>`.
   - Pause on missing remotes, auth failures, non-fast-forward rejection,
     protected-branch risk, or any uncertainty about where the branch should
     be pushed.
7. Report:
   - Commit hash, pushed branch/upstream, staged files summary, and test
     results.

## Conflict Handling

When sync reports conflicts:

- Run `git status --short` and inspect each unmerged file and conflict hunk.
- Resolve conflicts when the fix is clear, scoped to the current branch/main
  integration, and preserves both sides' intended behavior.
- Edit only conflicted files unless a minimal adjacent change is required to
  make the resolution build or test.
- Stage resolved files, then continue with `git rebase --continue` or
  `git merge --continue`.
- Rerun affected verification after resolving conflicts and update the report.
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
- Trim long external paths with an ellipsis while preserving useful tail context, for example `…/Resources/Codex/skills/commit/SKILL.md`.
- Do not paste long command logs.

## Command Scope

Use only the minimal needed commands:

- Inspect: `git status`, `git diff`, `git log`, `git branch`, `git remote`, `git rev-parse`
- Stage: `git add`
- Commit: `git commit`
- Amend (when needed): `git commit --amend` — only to refine the latest commit that has NOT been pushed yet (fold in a small fix, or correct the message/format). Never amend a commit already on the remote; never force-push.
- Sync/push: `git fetch`, `git rebase` or `git merge`, `git rebase --continue`, `git merge --continue`, `git push`
- Verify: repo-specific test/build commands required by the change

Do not force-push or create PRs from this skill. Use rebase/merge only to sync
the current branch with `main` before pushing. Amending is allowed only for the
latest unpushed commit (see Command Scope); never amend a commit that already
exists on the remote.

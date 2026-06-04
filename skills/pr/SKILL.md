---
name: pr
description: Create or update a GitHub pull request for the current git branch. Use when the user asks to open, create, submit, update, or push a PR. Requires committed changes on a non-main branch, syncs with main before pushing, resolves safe sync conflicts, pushes the current branch, and creates or updates a GitHub PR with TLDR, WHAT CHANGED, and TEST PLAN sections.
---

# PR

Create or update a GitHub pull request for the current branch.

## Workflow

1. Inspect:
   - `git status --short --branch`
   - `git branch --show-current`
   - `git remote -v`
   - `git log --oneline --decorate -5`
2. Require:
   - Current branch is not `main` or the repo's default branch.
   - Worktree is clean and all intended changes are committed.
   - `gh` is installed and authenticated.
3. Sync before pushing:
   - `git fetch origin main`
   - Choose the safest appropriate strategy:
     - Rebase for simple or unpublished branches.
     - Merge `origin/main` for already-pushed/shared branches when safer.
   - This sync is required before every push.
   - Resolve conflicts using Conflict Handling when safe.
   - Pause on unsafe rewrite risk or uncertain sync strategy.
4. Push:
   - Push current branch to origin before creating or updating the PR.
   - If the branch has no upstream, set it with `git push -u origin <branch>`.
   - If history was rewritten by an explicit prior amend/metadata step, use `git push --force-with-lease`; otherwise use normal `git push`.
   - Pause on missing remotes, auth failures, non-fast-forward rejection,
     lease failures, or protected-branch risk.
5. Create or update the PR:
   - Use `gh pr view --json number,url,title,body,headRefName,baseRefName`.
   - If a PR exists, update it with `gh pr edit`.
   - If no PR exists, create one with `gh pr create --base main --head <branch>`.
   - Report the PR URL.

## Conflict Handling

When sync reports conflicts:

- Run `git status --short` and inspect each unmerged file and conflict hunk.
- Resolve conflicts when the fix is clear, scoped to the current branch/main
  integration, and preserves both sides' intended behavior.
- Edit only files Git reports as conflicted unless a minimal adjacent change is
  required to make the resolution build or test.
- Stage resolved files, then continue with `git rebase --continue` or
  `git merge --continue`.
- Rerun or confirm the affected verification commands before pushing.
- Pause and ask if the conflict touches unrelated, user-owned, generated, or
  secret-like files, requires product/design judgment, would discard work, or
  is not confidently resolvable.

## PR Body Format

Use this exact structure:

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
- Inspect: `git status`, `git branch`, `git remote`, `git log`
- Sync/push: `git fetch`, `git rebase` or `git merge`, `git rebase --continue`, `git merge --continue`, `git push`
- GitHub: `gh auth status`, `gh pr view`, `gh pr create`, `gh pr edit`

Do not commit or amend normal repo changes, or merge PRs from this skill. Edit
files only when Git reports them as conflicted during the required main sync.

# Codex Git Skills

Global Codex skills for focused Git and GitHub workflows.

## Skills

- `$commit` — inspect local changes, stage intended files, run focused tests, and create a structured git commit.
- `$update-commit-metadata` — update the latest commit message metadata without changing files.
- `$amend` — amend the latest commit with local changes and push rewritten history safely when needed.
- `$pr` — sync with main, push the current branch, and create or update a GitHub pull request.

Each skill uses structured message bodies with `TLDR`, `WHAT CHANGED`, and `TEST PLAN` sections.

## Local install

Symlink each skill folder into `~/.codex/skills`:

```sh
for skill in commit update-commit-metadata amend pr; do
  ln -s "$PWD/skills/$skill" "$HOME/.codex/skills/$skill"
done
```

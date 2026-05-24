# Codex Git Skills

[![Skills](https://img.shields.io/badge/Codex-skills-111827)](https://github.com/mikec-git/codex-git-skills)
[![GitHub](https://img.shields.io/badge/GitHub-workflows-24292f?logo=github)](https://github.com/mikec-git/codex-git-skills)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

Focused Git and GitHub workflow skills for Codex.

These skills keep repository automation explicit and small: inspect changes, run relevant checks, write structured messages, sync with `main` before publishing, and avoid broad hidden behavior.

## Skills

| Skill | Purpose |
| --- | --- |
| `$commit` | Inspect local changes, stage intended files, run focused tests, and create a structured git commit. |
| `$update-commit-metadata` | Update the latest commit message metadata without changing files. |
| `$amend` | Amend the latest commit with local changes and push rewritten history safely when needed. |
| `$pr` | Sync with `main`, push the current branch, and create or update a GitHub pull request. |

Each skill uses structured message bodies with `TLDR`, `WHAT CHANGED`, and `TEST PLAN` sections.

## Install

Clone this repo and run the installer:

```sh
git clone https://github.com/mikec-git/codex-git-skills.git
cd codex-git-skills
./install.sh
```

The installer symlinks each skill folder into `~/.codex/skills`.

## Update

Pull the latest repo changes and repair symlinks:

```sh
cd codex-git-skills
./update.sh
```

Because the runtime skills are symlinks into this repo, updates are available as soon as `git pull` completes.

## Message Format

The commit and PR workflows use this body structure:

```text
TLDR

<1-3 sentence summary>

WHAT CHANGED

- <bullet>
- <bullet>

TEST PLAN

- PASS: `<command>` - <short result>
- FAIL: `<command>` - <short reason>
- BLOCKED: `<command>` - <short reason>
```

## Safety Model

- `$commit` never pushes.
- `$update-commit-metadata` changes commit metadata only.
- `$amend` uses `--force-with-lease` when rewritten history must be pushed.
- `$pr` requires committed changes on a non-main branch.
- Publishing workflows fetch and sync with `main` before pushing.

## Requirements

- Codex with local skills support.
- `git`.
- GitHub CLI `gh` for `$pr`.

## License

MIT

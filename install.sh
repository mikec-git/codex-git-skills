#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_dir="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
skills=(commit update-commit-metadata amend pr)

mkdir -p "$skills_dir"

for skill in "${skills[@]}"; do
  source_path="$repo_dir/skills/$skill"
  target_path="$skills_dir/$skill"

  if [[ ! -d "$source_path" ]]; then
    echo "Missing skill source: $source_path" >&2
    exit 1
  fi

  if [[ -e "$target_path" && ! -L "$target_path" ]]; then
    echo "Refusing to replace non-symlink path: $target_path" >&2
    echo "Move it aside, then rerun ./install.sh." >&2
    exit 1
  fi

  ln -sfn "$source_path" "$target_path"
  echo "Linked $target_path -> $source_path"
done

echo "Installed Codex git skills."

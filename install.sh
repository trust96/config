#!/usr/bin/env bash
set -xeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_ROOT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
  --work-root)
    WORK_ROOT="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

# Mapping: repo_file -> target_path
declare -A FILE_MAP=(
  ["bashrc"]="$HOME/.bashrc"
  ["bashrc_profile"]="$HOME/.bash_profile"
  ["gitconfig.work"]="$HOME/.gitconfig.work"
  ["wezterm.lua"]="$HOME/.wezterm.lua"
  ["nvim"]="$HOME/.config/nvim"
)

link_file() {
  local src="$1"
  local dest="$2"

  # Skip if symlink already points to the correct target
  if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
    echo "skip: $dest → already linked"
    return
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dest")"

  # If backup files/directory already exist, remove them before creating new backup
  if [ -e "${dest}.bak" ] || [ -L "${dest}.bak" ]; then
    echo "remove existing backup: ${dest}.bak"
    rm -rf "${dest}.bak"
  fi

  # Back up existing file/directory
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "backup: $dest → ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -s "$src" "$dest"
  echo "link: $dest → $src"
}

install_gitconfig() {
  local src="$SCRIPT_DIR/gitconfig.template"
  local dest="$HOME/.gitconfig"

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dest")"

  # Backup existing gitconfig
  if [ -e "${dest}.bak" ] || [ -L "${dest}.bak" ]; then
    echo "remove existing backup: ${dest}.bak"
    rm -rf "${dest}.bak"
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "backup: $dest → ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  if [ -n "$WORK_ROOT" ]; then
    # Substitute the work root path into the template
    sed "s|__WORK_ROOT__|$WORK_ROOT|g" "$src" >"$dest"
    echo "generate: $dest (work-root: $WORK_ROOT)"
  else
    # Strip the includeIf block when no work root is provided
    sed '/\[includeIf "gitdir:__WORK_ROOT__\/"\]/,/^\[/{ /^\[includeIf/d; /path = /d; }' "$src" >"$dest"
    echo "generate: $dest (personal only)"
  fi
}

echo "Installing dotfiles from $SCRIPT_DIR"
echo "---"

install_gitconfig

for file in "${!FILE_MAP[@]}"; do
  link_file "$SCRIPT_DIR/$file" "${FILE_MAP[$file]}"
done

echo "---"
echo "Done!"

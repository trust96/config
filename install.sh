#!/usr/bin/env bash
set -xeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Mapping: repo_file -> target_path
declare -A FILE_MAP=(
  ["bashrc"]="$HOME/.bashrc"
  ["bashrc_profile"]="$HOME/.bash_profile"
  ["gitconfig"]="$HOME/.gitconfig"
  ["wezterm.lua"]="$HOME/.config/wezterm/wezterm.lua"
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

echo "Installing dotfiles from $SCRIPT_DIR"
echo "---"

for file in "${!FILE_MAP[@]}"; do
  link_file "$SCRIPT_DIR/$file" "${FILE_MAP[$file]}"
done

echo "---"
echo "Done!"

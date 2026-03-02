# Copilot Instructions

## Repository Overview

This is a **dotfiles repository** containing personal development environment configuration. Files here are symlinked or copied to their target locations (e.g., `bashrc` → `~/.bashrc`, `nvim/` → `~/.config/nvim/`).

## Structure

- **Root-level files** (`bashrc`, `bashrc_profile`, `gitconfig`, `wezterm.lua`) are standalone config files meant for `$HOME`.
- **`nvim/`** is a full [LazyVim](https://www.lazyvim.org/) configuration directory meant for `~/.config/nvim/`.

## Key Conventions

- **Neovim config uses LazyVim**: The `nvim/` directory follows LazyVim's file structure. Custom plugins go in `nvim/lua/plugins/`, custom keymaps in `nvim/lua/config/keymaps.lua`, and options in `nvim/lua/config/options.lua`.
- **Lua formatting**: Lua files use [StyLua](https://github.com/JohnnyMorganz/StyLua) with 2-space indentation and 120-column width (see `nvim/stylua.toml`).
- **Git editor is nvim**: The gitconfig sets `core.editor = nvim`.
- **Terminal is WezTerm**: `wezterm.lua` configures the WezTerm terminal with the "AdventureTime" color scheme and ALT-based tab navigation keybindings.

## When Editing

- Config files have no build/test/lint pipeline — validate syntax mentally or by loading the config in its target application.
- When adding Neovim plugins, follow the LazyVim plugin spec pattern used in `nvim/lua/plugins/example.lua`.
- Lua files should be formatted with StyLua (`stylua <file>`) using the settings in `nvim/stylua.toml`.

## Git Workflow

- When making changes for a PR, create a **git worktree** for the branch (e.g., `git worktree add ../config-<branch-name> -b <branch-name>`).
- Once the PR is merged or work is complete, **delete the worktree** (`git worktree remove ../config-<branch-name>`).

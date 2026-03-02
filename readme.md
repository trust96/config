# This is the start of the config files

- [ ] git
  - [ ] prettier git log
  - [ ] merge strategy
- [ ] neovim / lazyvim

## Linux and Windows config plan

- [ ] Split shared config from OS-specific overrides (shared git and nvim settings, shell/terminal per OS)
- [ ] Add a `windows/` directory for PowerShell profile and Windows-specific setup notes
- [ ] Keep Linux shell config in existing `bashrc` and `bashrc_profile` with Linux-only paths guarded behind OS checks
- [ ] Document installation steps for both platforms (symlink/copy targets for Linux and Windows)
- [ ] Validate manually on both platforms by loading shell, git, nvim, and terminal configs

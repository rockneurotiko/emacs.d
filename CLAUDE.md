# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Emacs configuration repository designed to be modular, self-contained, and easily cloneable. The configuration uses Elpaca as the package manager and is structured to auto-install dependencies.

## Architecture

### Core Files
- `init.el` - Main configuration entry point that:
  - Sets up Elpaca package manager with bootstrap code
  - Configures use-package with custom `:setopt` keyword
  - Loads modular settings from `settings/` directory
  - Sets up fonts, themes, and core Emacs behavior

- `early-init.el` - Early initialization optimizations for startup performance, native compilation, and UI tweaks

### Modular Settings Structure
The configuration is organized in the main `init.el` file, but if the config is long it goes into modular files in the `settings/` directory:
- `settings/meow-settings.el` - Modal editing configuration (Dvorak layout)
- `settings/eglot-settings.el` - LSP configuration with Elixir support
- `settings/org-settings.el` - Org-mode configuration
- `settings/treesit-settings.el` - Tree-sitter configuration

### Key Features
- **Package Manager**: Elpaca (modern alternative to package.el)
- **Modal Editing**: Meow with Dvorak layout and custom keybindings
- **Completion**: Corfu + Cape + Vertico + Marginalia + Consult stack
- **LSP**: Eglot with eglot-booster for performance
- **AI Integration**: GitHub Copilot and Claude Code IDE support
- **Version Control**: Magit with git-link and git-auto-commit-mode
- **Terminal**: Vterm with Fish shell
- **Language Support**: Primarily Elixir with ExUnit testing support

## Common Development Workflows

### Emacs Package Development
Since this is an Emacs configuration:
- Test changes by restarting Emacs or evaluating elisp expressions, the agent can't restart.
- Package dependencies are handled automatically by Elpaca
- Configuration changes require Emacs restart to take full effect, the agent can't restart.

### Managing Dependencies
- Elixir LSP server path: `/home/rock/.emacs.d/.cache/elixir-ls/language_server.sh`
- Font dependencies: "Sarasa Mono J Nerd Font" and "Sarasa UI J Nerd Font"

### Authentication
- Uses auth-source for secure credential storage
- Anthropic API credentials stored in authinfo for Claude Code IDE
- Supports encrypted .authinfo.gpg files

## Key Configuration Patterns

### Use-Package Extensions
- Custom `:setopt` keyword for setting options
- Extensive use of `:ensure t` for automatic package installation
- Hook-based configuration for mode-specific setups

### Modal Editing (Meow)
- Dvorak-optimized key layout
- Custom functions for duplication and commenting
- Leader key mappings for common Emacs commands

### LSP Integration
- Eglot configured for Elixir development
- Automatic formatting on save for Elixir/Heex files
- Jump-to-definition integration with xref marker ring

## Environment Setup

The configuration expects:
- Modern Emacs (28+) with native compilation support
- Git for package management
- Fish shell for terminal integration
- Nerd Font icons for UI elements
- Optional: Language-specific tools (elixir-ls, etc.)

## Notes for Development

- Configuration uses lexical binding throughout
- Heavy use of advice functions for enhancing built-in commands
- Custom functions prefixed with `rock/` namespace
- Extensive keybinding customization, especially for modal editing

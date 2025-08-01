# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive, modular Emacs configuration repository (`rockneurotiko/emacs.d`) that provides a full-featured development environment. The configuration is designed to be self-contained and automatically install all required packages on first run.

## Architecture

### Entry Points
- `early-init.el` - Early initialization, sets up native compilation, LSP plists, and package system
- `init.el` - Main configuration orchestrator that loads all modules in specific order

### Modular Organization
The configuration uses a modular approach with all feature-specific configurations in the `settings/` directory:

**Core System:**
- `package-settings.el` - Package management (straight.el + use-package)
- `general-settings.el` - Global Emacs behavior and keybindings
- `custom-functions.el` - Platform detection and utility functions
- `rock-defuns.el` - Custom interactive commands and macros

**Development Tools:**
- `programming-settings.el` - Language configurations orchestrator
- `eglot-settings.el` - LSP client configuration (built-in Eglot)
- `copilot-settings.el` - GitHub Copilot AI code completion
- `magit-settings.el` - Git integration
- `projectile-settings.el` - Project management

**AI Integration:**
- `llm-settings.el` - LLM integrations (ChatGPT Shell, Claude Code, Claude Code IDE)
- `mcp-settings.el` - MCP (Model Context Protocol) and GPTel configuration
- `aider-settings.el` - Aidermacs integration for AI-assisted coding

**UI/UX Enhancements:**
- `theme-settings.el` - Theme management (EF themes, Nord, etc.)
- `font-settings.el` - Font configuration
- `dashboard-settings.el` - Dashboard configuration
- `meow-settings.el` - Modal editing with Meow
- `vertico-settings.el` - Modern completion framework

**Language Support:**
Individual `*-settings.el` files for each language: `elixir-settings.el`, `go-settings.el`, `js-settings.el`, `python-settings.el`, `rust-settings.el`, etc.

**New/Custom Features:**
- `universal-launcher.el` - Universal application launcher with calculator, emoji support
- `buffer-faces.el` - Buffer face analysis utility
- `other-meow.el` - Alternative Meow configuration (nyaatouch modal editing)

### Package Management Strategy
Uses a multi-layered approach:
1. **Primary**: `straight.el` for reproducible package management
2. **Configuration**: `use-package` for declarative package setup
3. **Fallback**: Built-in `package.el` with MELPA

## Installation and Setup

### Initial Setup
```bash
# Direct installation
git clone --recursive https://github.com/rockneurotiko/emacs.d.git ~/.emacs.d

# Alternative with symlink
git clone --recursive https://github.com/rockneurotiko/emacs.d.git ~/path/to/emacs.d
ln -s ~/path/to/emacs.d ~/.emacs.d
```

### Optional Dependencies
The configuration will work without these, but some features require:

**Development Tools:**
- PlantUML: Download jar to `/opt/plantuml/plantuml.jar` (or update path in `settings/random-requires.el`)
- Node.js tools: `sudo npm install -g tern`
- Python tools: `sudo pip install jedi flake8 importmagic autopep8 yapf`
- Rust: `cargo install racer`
- System utilities for universal launcher: `wmctrl`, `flatpak`, `wl-copy`/`xclip`

**Google Calendar Integration:**
- Set up org-gcal following: https://github.com/myuhe/org-gcal.el

### AI Tools Setup
- **Anthropic API Key**: Store in `~/.authinfo` with host "aider.chat" and user "anthropic"
- **MCP Server**: Configured for Tidewave at `http://localhost:4000/tidewave/mcp?include_fs_tools=true`

### Secret Management
- Secrets and oauth tokens are loaded from `~/.authinfo`
- Use `(efs/lookup-password)` to get secrets from `~/.authinfo`

## Development Practices

### Code Organization
- Each settings file provides its module name: `(provide 'module-name)`
- Custom functions prefixed with `rock--` namespace
- Platform-specific code uses `system-is-mac` and `system-is-linux` helpers

### Adding New Features
1. Create new `*-settings.el` file in `settings/` directory
2. Add `(require 'your-settings)` to `init.el` in appropriate section
3. Use `use-package` for package configuration
4. Add custom functions to `rock-defuns.el` if needed

### Language Support
- Language-specific settings go in individual files (e.g., `elixir-settings.el`)
- LSP configuration centralized in `eglot-settings.el`
- Tree-sitter parsers in `tree-sitter/` directory
- Snippets organized in `snippets/` directory

### Utility Functions and Macros
- `->` threading macro for functional composition (in `rock-defuns.el`)
- Text manipulation: `move-text-up`, `move-text-down`
- Platform detection: `system-is-mac`, `system-is-linux`
- File utilities: `file-if-exists`, `sudo-edit`

## Key Features

### Modern Emacs Technologies
- Native compilation enabled for performance
- Tree-sitter for enhanced syntax highlighting
- LSP via Eglot (built-in client) with plist optimization
- Vertico/Consult completion framework

### Development Environment
- GitHub Copilot integration
- Multi-language LSP support
- Git integration via Magit
- Project management via Projectile
- Snippet support via YASnippet

### AI Integration
- **Copilot**: GitHub Copilot for code completion
- **ChatGPT Shell**: Claude 3.5 Sonnet integration
- **Claude Code**: Official Claude Code extension with keybinding `C-c I`
- **Claude Code IDE**: Enhanced IDE integration with `C-c C-'` keybinding and MCP tools
- **Aidermacs**: AI-assisted coding with Sonnet model
- **GPTel**: Multi-provider LLM client with MCP support
- **MCP Hub**: Model Context Protocol server integration

### UI/UX Features
- **Universal Launcher**: Comprehensive launcher with:
  - Application launching (desktop files, Flatpak)
  - Buffer/file switching
  - Web bookmarks and search
  - Calculator with instant results
  - Emoji picker
  - System command execution
- **Modal Editing**: Meow modal editing with custom configurations
- **Theme Management**: Multiple theme options (EF, Nord, Catppuccin)
- **Dashboard**: Custom startup dashboard

## File Structure Notes

### Generated/Runtime Files
- `eln-cache/` - Native compiled Elisp files
- `straight/` - Package manager cache
- `persist/` - Persistent data storage
- `transient/` - Transient command history
- `forge-database.sqlite` - Git forge data
- `org-roam.db` - Org-roam knowledge base
- `oauth2-auto.plist` - OAuth2 authentication data
- `eca/` - ECA tool directory

### Configuration State
- `bookmarks` - Emacs bookmarks
- `projects.eld` - Projectile project cache
- `.org-*-locations` - Org-mode ID location caches
- Modified files in git status are normal for active development

### Key Bindings
- `C-c I` - Claude Code command map
- `C-c C-'` - Claude Code IDE menu
- `C-c i` - Aidermacs transient menu
- `C-c e` - Text processing function

## Troubleshooting

### First Run
- Package installation is automatic but may take several minutes
- Some language servers need manual installation (see optional dependencies)
- Native compilation warnings during first run are normal

### Performance
- Native compilation improves startup time after initial compilation
- LSP uses plists for better performance (`LSP_USE_PLISTS=true`)
- Use `M-x profiler-start` and `M-x profiler-report` for performance debugging
- Large projects may need `projectile-enable-caching`

### AI Tools
- Ensure `ANTHROPIC_API_KEY` is properly configured in `~/.authinfo`
- MCP server must be running for MCP tools to work
- Universal launcher requires system utilities for full functionality

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
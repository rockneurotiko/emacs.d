# Modern Emacs Configuration

A modern, modular Emacs configuration focused on performance, developer experience, and Elixir development.

## Features

- 🚀 **Fast startup** with optimized `early-init.el`
- 📦 **Elpaca package manager** - Modern alternative to package.el
- ⌨️  **Meow modal editing** with Dvorak layout optimization
- 🧠 **AI-powered development** with GitHub Copilot and Claude Code IDE
- 🔍 **Modern completion** with Corfu + Cape + Vertico + Marginalia
- 🛠️ **LSP support** via Eglot with performance boosters
- 💎 **Elixir-focused** with ExUnit testing integration
- 🎨 **Beautiful themes** with Doom themes and Nerd icons
- 📱 **Integrated terminal** with Vterm and Fish shell

## Quick Start

### Prerequisites

- **Emacs 28+** with native compilation support
- **Git** for package management
- **Nerd Font** - Specifically "Sarasa Mono J Nerd Font" and "Sarasa UI J Nerd Font"
- **Fish shell** (optional, for terminal integration)

### Installation

Clone directly to your `.emacs.d` directory:

```bash
# Backup existing config if you have one
mv ~/.emacs.d ~/.emacs.d.backup

# Clone this configuration
git clone --recursive https://github.com/rockneurotiko/emacs.d.git ~/.emacs.d
```

Or clone to a different location and symlink:

```bash
git clone --recursive https://github.com/rockneurotiko/emacs.d.git ~/path/to/emacs.d
ln -s ~/path/to/emacs.d ~/.emacs.d
```

### First Launch

On first launch, Emacs will:
1. Bootstrap the Elpaca package manager
2. Install all required packages automatically
3. Set up fonts and themes

This process may take a few minutes on the first run.

## Configuration Structure

- `init.el` - Main configuration entry point
- `early-init.el` - Performance optimizations and early setup
- `settings/` - Modular configuration files:
  - `meow-settings.el` - Modal editing setup
  - `eglot-settings.el` - LSP configuration
  - `org-settings.el` - Org-mode setup
  - `treesit-settings.el` - Tree-sitter configuration

## Key Bindings

This configuration uses **Meow** modal editing with a Dvorak-optimized layout. Key highlights:

### Leader Key Commands (SPC)
- `SPC f` - Find file
- `SPC b` - Switch buffer
- `SPC g` - Magit status
- `SPC p` - Project commands

### Search & Navigation
- `C-c r p` - Ripgrep search in project
- `C-c r f` - Search current file
- `C-c SPC` - Avy jump to character
- `M-s M-l` - Consult line search

### Development
- `C-c C-'` - Claude Code IDE menu
- `Tab` - Copilot accept completion
- `C-.` - Embark actions
- `C-c g` - Magit status

## Language Support

### Elixir Development
- **LSP**: Automatic setup with ElixirLS
- **Testing**: ExUnit integration for running tests
- **Formatting**: Automatic formatting on save
- **Project detection**: Automatic detection of Mix projects

### Additional Languages
- Tree-sitter support for modern syntax highlighting
- Eglot LSP integration for multiple languages
- GraphQL mode support

## Optional Dependencies

For enhanced functionality, install these optional tools:

### Development Tools
```bash
# Elixir (if doing Elixir development)
# Install via your system package manager

# Ripgrep for fast searching
sudo pacman -S ripgrep  # Arch Linux
brew install ripgrep    # macOS
```

## Customization

### Authentication
For Claude Code IDE and other services, configure authentication in `~/.authinfo` or `~/.authinfo.gpg`:

```
machine aider.chat login anthropic password your-api-key
machine aider.chat login anthropic-url password your-base-url
```

### Fonts
The configuration expects specific fonts. If you prefer different fonts, modify these variables in `init.el`:

```elisp
(defvar rock/fontname "Your-Font-Name")
(defvar rock/fontname-variable "Your-Variable-Font-Name")
```

## Troubleshooting

### Common Issues

**Slow startup**: First launch installs packages and may be slow. Subsequent launches should be fast.

**Missing fonts**: Install the required Nerd Fonts or modify font settings in `init.el`.

**LSP not working**: Ensure language servers are installed (e.g., ElixirLS for Elixir).

### Performance

This configuration is optimized for performance with:
- Deferred package loading
- Native compilation
- Garbage collection tuning
- Early initialization optimizations

## Contributing

This is a personal configuration, but suggestions and improvements are welcome via issues or pull requests.

## License

BeerWare

# Agent Emacs

Minimal, fast Emacs configuration for editing alongside Claude Code.

## Launch

```bash
emacs --init-directory ~/.agent.emacs.d
```

Or add to your shell config:

```bash
alias agent-emacs='emacs --init-directory ~/.agent.emacs.d'
alias ae='emacs --init-directory ~/.agent.emacs.d'
```

## Using Claude Code

**Launch Claude Code from Emacs:**

- `C-c a` - Claude Code transient menu (shows all commands)
- `C-c c` - Quick launch Claude Code
- `C-c t` - Quick vterm (if you need bash)

**Available via `C-c a` menu:**
- Launch Claude Code
- Send region to Claude
- Send buffer to Claude
- Other claude-code.el features

**Workflow:**
1. Launch Agent Emacs: `ae` (or your alias)
2. Press `C-c c` or `C-c a` to start Claude Code
3. Interact with Claude in vterm
4. Open files Claude mentions: `C-x C-f`
5. Split windows to see code + Claude: `C-x 3` (vertical) or `C-x 2` (horizontal)
6. Switch between windows: `M-o`

## What's Included

**Minimal packages** - only vterm + claude-code.el for best Claude Code experience.

### Core Features
- **vterm** - Fast, full-featured terminal emulator (better than ansi-term)
- **claude-code.el** - Emacs integration for Claude Code with transient menu
- Clean UI (no menu/tool/scroll bars)
- Line numbers in code
- Auto-revert files changed by Claude
- Recent files list
- Save cursor position between sessions
- Auto-pairing brackets/quotes
- Smart buffer naming for duplicates

### Navigation
- `C-x C-r` - Recent files
- `C-x p f` - Find file in project
- `C-x p p` - Switch project
- `M-o` - Switch window
- `C-x 3` - Split window vertically
- `C-x 2` - Split window horizontally
- `C-x 1` - Close other windows

### Completion
- Uses `fido-vertical-mode` (built-in, lightweight)
- Flex matching for fuzzy finding
- Tab completes inline

### Syntax
- Built-in syntax highlighting
- Tree-sitter support (if available)
- Basic flymake error checking
- Xref code navigation (uses ripgrep if available)

## Customization

Edit `~/.agent.emacs.d/init.el` directly. Everything is commented and organized by section.

### Quick Tweaks

**Light theme:**
```elisp
(load-theme 'modus-operandi t)
```

**Larger font:**
```elisp
(set-face-attribute 'default nil :height 140)
```

**Different completion style:**
```elisp
;; Replace fido-vertical-mode with:
(ido-mode 1)  ; or just remove it for basic completion
```

## VTerm Usage

When Claude Code is running in vterm:

**Copy/paste:**
- `C-c C-t` - Toggle between vterm mode and normal Emacs mode
- In Emacs mode: use normal `C-SPC`, `M-w`, `C-y` for mark/copy/paste
- In vterm mode: keys go directly to Claude Code
- Mouse selection works in both modes

**Navigation:**
- Scroll with mouse wheel or `Shift-PgUp`/`Shift-PgDn`
- Search: `C-c C-r` (reverse search in vterm)

**Vterm is much faster and handles ANSI codes better than ansi-term!**

## Philosophy

- **Fast**: <1s startup (includes vterm compilation check)
- **Focused**: Only what you need for Claude Code + file editing
- **Stable**: Just 2 packages (vterm + claude-code.el), everything else built-in
- **Maintainable**: ~200 lines, all commented

This is NOT your main Emacs. This is your dedicated Claude Code interface with editing superpowers.

## First Launch

On first launch, Emacs will:
1. Install vterm (requires cmake + libtool if not present)
2. Install claude-code.el from GitHub
3. Compile vterm's native module

This takes ~30 seconds once. After that, startup is instant.

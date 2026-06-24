# Agent Emacs

Minimal, fast Emacs configuration for use as an interface to Claude Code.

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

**Copy from Claude → system clipboard:**
- `C-c C-t` - Enter copy mode
- `C-SPC` to set mark, navigate to end of selection
- `M-w` - Copy to system clipboard (other apps can now paste it)
- Copy mode exits automatically

**Paste from system clipboard → Claude:**
- `C-c C-y` or `C-S-v` - Paste system clipboard into vterm
  (use this for text copied from browser, another terminal, etc.)

**Shift+drag (GUI only):** Hold Shift and mouse-drag to select text directly via
X11 — bypasses vterm entirely, goes straight to PRIMARY selection.

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

;;; init.el --- Minimal config for Claude Code sessions -*- lexical-binding: t; -*-
;;
;; Fast, focused Emacs for quick editing alongside Claude Code
;; Launch with: emacs --init-directory ~/.agent.emacs.d

;;; Performance
;; Reset GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;;; UI Cleanup
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)

;; Better frame title
(setq frame-title-format '("Agent Emacs - %b"))

;; Command to change window title (for xmonad)
(defun set-window-title (title)
  "Set the Emacs frame title to TITLE.
This changes what appears in your window manager (xmonad).
Use 'reset-window-title' to restore the default format."
  (interactive "sWindow title: ")
  (setq frame-title-format title)
  (force-mode-line-update t)
  (message "Window title set to: %s" title))

(defun reset-window-title ()
  "Reset frame title to default format showing buffer name."
  (interactive)
  (setq frame-title-format '("Agent Emacs - %b"))
  (force-mode-line-update t)
  (message "Window title reset to default"))

;; Clean modeline
(column-number-mode 1)
(size-indication-mode 1)

;;; Better Defaults
(setq-default
 ;; Editing
 indent-tabs-mode nil
 tab-width 2
 fill-column 80

 ;; No backup clutter
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil

 ;; Better scrolling
 scroll-margin 3
 scroll-conservatively 101
 scroll-preserve-screen-position t

 ;; Cursor
 cursor-in-non-selected-windows nil
 blink-cursor-mode nil)

;; Always follow symlinks
(setq vc-follow-symlinks t)

;; UTF-8 everywhere
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; Start from ~/claude directory
(setq default-directory (expand-file-name "~/claude/"))

;; Shorter yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Show matching parens instantly
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Highlight current line (but not in terminals)
(global-hl-line-mode 1)

;; Line numbers for code (but not in terminals)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Auto-revert files changed on disk
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)

;; Better buffer names for duplicates
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;; Navigation & Editing Enhancements
;; Recent files
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; Save place in files
(save-place-mode 1)

;; Better search
(setq-default
 case-fold-search t
 isearch-lazy-count t)

;; Electric pairs
(electric-pair-mode 1)

;; Delete selection on type
(delete-selection-mode 1)

;; Smooth scrolling
(pixel-scroll-precision-mode 1)

;;; Built-in IDE Features
;; Project.el for project management
(require 'project)
(setq project-switch-commands
      '((project-find-file "Find file")
        (project-find-regexp "Find regexp")
        (project-dired "Dired")))

;; Xref for code navigation
(setq xref-search-program 'ripgrep)

;; Flymake for syntax checking (very lightweight)
(add-hook 'prog-mode-hook 'flymake-mode)

;;; Language Support (built-in, fast)
;; Treesit for better syntax highlighting (if available)
(when (and (fboundp 'treesit-available-p)
           (treesit-available-p))
  ;; Auto-use treesit modes when available
  (setq treesit-font-lock-level 3))

;;; Keybindings
;; Better window switching
(global-set-key (kbd "M-o") 'other-window)

;; Quick file finding
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; Project switching
(global-set-key (kbd "C-x p p") 'project-switch-project)
(global-set-key (kbd "C-x p f") 'project-find-file)

;; Buffer switching with completion
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Quick kill buffer
(global-set-key (kbd "C-x k") 'kill-current-buffer)

;; Comment/uncomment
(global-set-key (kbd "M-;") 'comment-line)

;; Avy - quick navigation
(global-set-key (kbd "C-'") 'avy-goto-char-2)      ;; Jump to any 2 chars
(global-set-key (kbd "C-c j") 'avy-goto-char-timer) ;; Jump with timer
(global-set-key (kbd "M-g l") 'avy-goto-line)      ;; Jump to line
(global-set-key (kbd "M-g w") 'avy-goto-word-1)    ;; Jump to word

;; Window title management
(global-set-key (kbd "C-c w") 'set-window-title)
(global-set-key (kbd "C-c W") 'reset-window-title)  ;; Capital W for reset

;;; Completion (built-in, fast)
;; Use fido-mode for lightweight completion (better than ido, lighter than ivy/helm)
(fido-vertical-mode 1)
(setq completion-styles '(flex basic partial-completion))

;; Better completion at point
(setq tab-always-indent 'complete)
(setq completion-cycle-threshold 3)

;;; Package Management (minimal, just for vterm + claude-code)
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))

;; Initialize packages and update load-path
(package-initialize)

;; Refresh if needed and install packages
(unless package-archive-contents
  (package-refresh-contents))

;; Install vterm if needed
(unless (package-installed-p 'vterm)
  (package-install 'vterm))

;; Install avy for quick navigation
(unless (package-installed-p 'avy)
  (package-install 'avy))

;; Install claude-code.el from git if needed
(unless (package-installed-p 'claude-code)
  (package-vc-install "https://github.com/stevemolitor/claude-code.el" nil nil 'claude-code))

;; Ensure packages are activated (this updates load-path)
(package-activate 'vterm)
(package-activate 'avy)
(package-activate 'claude-code)

;;; Avy Configuration - Quick jump navigation
;; Must be after package activation
(require 'avy)
(setq avy-timeout-seconds 0.3)  ; How long to wait before auto-selecting
(setq avy-style 'at-full)       ; Show keys at target location
(setq avy-all-windows nil)      ; Only jump within current window
(setq avy-background t)         ; Dim background while selecting

;;; Claude Code Configuration
;; Load packages with error handling
(condition-case err
    (progn
      (require 'vterm)
      (message "vterm loaded successfully"))
  (error (message "Failed to load vterm: %s" err)))

(condition-case err
    (progn
      (require 'claude-code)
      (message "claude-code loaded successfully"))
  (error (message "Failed to load claude-code: %s" err)))

;; Force proper environment from login shell
(require 'inheritenv)

;; Get environment from login shell and update Emacs
(defun setup-shell-environment ()
  "Load PATH and environment from login shell."
  (let* ((shell (or (getenv "SHELL") "/bin/bash"))
         (command (format "%s -l -c 'printf \"%%s\" \"$PATH\"'" shell))
         (path-from-shell (string-trim (shell-command-to-string command))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))
    (message "Loaded PATH from shell: %s" (car (split-string path-from-shell ":")))))

;; Set up environment
(setup-shell-environment)

;; Make sure vterm inherits this environment
(inheritenv-add-advice 'vterm)

;; Optimize vterm performance - disable everything that could slow it down
(add-hook 'vterm-mode-hook
          (lambda ()
            ;; Disable visual features
            (setq-local global-hl-line-mode nil)
            (setq-local line-spacing 0)
            (when (fboundp 'display-line-numbers-mode)
              (display-line-numbers-mode -1))
            (when (fboundp 'hl-line-mode)
              (hl-line-mode -1))
            ;; Disable file watching and tracking
            (when (fboundp 'auto-revert-mode)
              (auto-revert-mode -1))
            ;; Don't track vterm buffers in recentf
            (setq-local recentf-exclude (list (buffer-file-name)))
            ;; No flymake in terminals
            (when (fboundp 'flymake-mode)
              (flymake-mode -1))
            ;; Fast scrolling
            (setq-local scroll-margin 0)
            (setq-local scroll-conservatively 101)))

;; Use vterm as terminal backend (much better than ansi-term)
(setq claude-code-terminal-backend 'vterm)

;; Make vterm display faster
(setq vterm-timer-delay nil)  ; Process immediately, no buffering
(setq claude-code-vterm-buffer-multiline-output nil)  ; Disable multiline buffering

;; Vterm Copy Mode - for scrolling and searching the terminal
;; Enter copy mode with C-c C-t, then use normal Emacs navigation
(defun vterm-copy-mode-enter-with-message ()
  "Enter vterm copy mode with helpful message."
  (interactive)
  (when (eq major-mode 'vterm-mode)
    (vterm-copy-mode 1)
    (message "Copy mode ON - Navigate with C-n/C-p/C-s, press RET to copy region, C-c C-t to exit")))

;; Make copy mode more discoverable
(with-eval-after-load 'vterm
  ;; Enable scrollback
  (setq vterm-max-scrollback 10000)

  ;; Better copy mode keybindings
  (define-key vterm-mode-map (kbd "C-c C-t") 'vterm-copy-mode-enter-with-message)
  (define-key vterm-mode-map (kbd "C-c C-y") 'vterm-copy-mode-enter-with-message)

  ;; In copy mode, add helpful bindings
  (define-key vterm-copy-mode-map (kbd "C-c C-t") 'vterm-copy-mode)
  (define-key vterm-copy-mode-map (kbd "q") 'vterm-copy-mode)

  ;; Make search work better in copy mode
  (define-key vterm-copy-mode-map (kbd "C-s") 'isearch-forward)
  (define-key vterm-copy-mode-map (kbd "C-r") 'isearch-backward)

  ;; Vim-style navigation in copy mode (optional)
  (define-key vterm-copy-mode-map (kbd "j") 'next-line)
  (define-key vterm-copy-mode-map (kbd "k") 'previous-line)
  (define-key vterm-copy-mode-map (kbd "h") 'backward-char)
  (define-key vterm-copy-mode-map (kbd "l") 'forward-char)
  (define-key vterm-copy-mode-map (kbd "g g") 'beginning-of-buffer)
  (define-key vterm-copy-mode-map (kbd "G") 'end-of-buffer))

;; FIX: Make cursor visible and highlighting work in vterm copy mode
(add-hook 'vterm-copy-mode-hook
          (lambda ()
            (if vterm-copy-mode
                ;; Entering copy mode - make cursor visible
                (progn
                  (setq-local cursor-type 'box)
                  (hl-line-mode 1)
                  (setq-local cursor-in-non-selected-windows t))
              ;; Exiting copy mode - restore terminal settings
              (progn
                (hl-line-mode -1)
                (setq-local cursor-type nil)))))

(message "Terminal backend set to: %s" claude-code-terminal-backend)

;; Configuration for Claude Code flags
(defvar claude-code-skip-permissions t
  "Whether to launch Claude with --dangerously-skip-permissions flag.")

;; Function to choose between Claude commands
(defun claude-code-select-command ()
  "Select which Claude command to use: anthropic or synthetic.new."
  (interactive)
  (let ((choice (completing-read "Select Claude command: "
                                  '("claude (Anthropic)"
                                    "synclaude.sh (Synthetic.new)")
                                  nil t)))
    (cond
     ((string-match "Anthropic" choice)
      (setq claude-code-program "claude")
      (setq claude-code-program-switches (if claude-code-skip-permissions
                                              '("--dangerously-skip-permissions")
                                            nil))
      (message "Using claude (Anthropic credentials)%s"
               (if claude-code-skip-permissions " with --dangerously-skip-permissions" "")))
     ((string-match "Synthetic" choice)
      (setq claude-code-program (expand-file-name "~/claude/synclaude.sh"))
      (setq claude-code-program-switches (if claude-code-skip-permissions
                                              '("--dangerously-skip-permissions")
                                            nil))
      (message "Using ~/claude/synclaude.sh (Synthetic.new credentials)%s"
               (if claude-code-skip-permissions " with --dangerously-skip-permissions" ""))))
    claude-code-program))

;; Function to toggle skip permissions flag
(defun claude-code-toggle-skip-permissions ()
  "Toggle --dangerously-skip-permissions flag for Claude."
  (interactive)
  (setq claude-code-skip-permissions (not claude-code-skip-permissions))
  (message "--dangerously-skip-permissions: %s"
           (if claude-code-skip-permissions "enabled" "disabled")))

;; Custom display function to maximize Claude buffer
(defun claude-code-display-buffer-fullscreen (buffer)
  "Display Claude Code BUFFER in fullscreen, deleting other windows."
  (delete-other-windows)
  (let ((window (display-buffer buffer '((display-buffer-same-window)))))
    (select-window window)
    window))

;; Set custom display function
(setq claude-code-display-window-fn #'claude-code-display-buffer-fullscreen)

;; Enhanced claude-code launcher with command selection
(defun claude-code-launch ()
  "Launch Claude Code with command selection and auto-focus."
  (interactive)
  (claude-code-select-command)
  ;; Pass prefix arg (4) to switch to buffer after creating
  (claude-code '(4)))

;; Verify claude command is available
(message "claude command found at: %s" (executable-find "claude"))

;; Keybindings - use same as main Emacs config
(global-set-key (kbd "C-c a") 'claude-code-transient)  ;; Main transient menu
(global-set-key (kbd "C-c c") 'claude-code-launch)     ;; Quick launch with command selection

;; Alternative: launch with last-used command (no prompt)
(global-set-key (kbd "C-c C-c") 'claude-code)

;; Quick vterm if needed
(global-set-key (kbd "C-c t") 'vterm)

;; Toggle skip-permissions flag
(global-set-key (kbd "C-c p") 'claude-code-toggle-skip-permissions)

;; Verify keybindings were set
(message "C-c c bound to: %s" (key-binding (kbd "C-c c")))
(message "C-c C-c bound to: %s" (key-binding (kbd "C-c C-c")))
(message "C-c a bound to: %s" (key-binding (kbd "C-c a")))
(message "claude-code-launch function exists: %s" (fboundp 'claude-code-launch))
(message "claude-code function exists: %s" (fboundp 'claude-code))

;; Debug wrapper for claude-code
(defun debug-claude-code (&optional arg)
  "Debug wrapper for claude-code."
  (interactive "P")
  (message "=== DEBUG: Starting claude-code with arg: %s" arg)
  (message "=== DEBUG: Current buffer: %s" (current-buffer))
  (message "=== DEBUG: Terminal backend: %s" claude-code-terminal-backend)
  (condition-case err
      (progn
        (claude-code arg)
        (message "=== DEBUG: claude-code returned, current buffer: %s" (current-buffer)))
    (error (message "=== DEBUG ERROR: %s" err))))

;; Override keybinding for debugging
(global-set-key (kbd "C-c C-d") 'debug-claude-code)

;;; Theme - Use Billy's custom theme
;; Load custom theme from main emacs config
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d"))
(load-theme 'Billy-Theme t)

;;; Final Message
(message "Agent Emacs ready (%.2fs) - Press C-c c to launch Claude Code | Working directory: %s"
         (float-time (time-subtract (current-time) before-init-time))
         default-directory)

;; Auto-launch Claude Code on startup after a brief delay to let everything settle
(defun agent-emacs-auto-launch-claude ()
  "Auto-launch Claude Code with command selection."
  (run-with-timer 0.5 nil
                  (lambda ()
                    (message "Auto-launching Claude Code...")
                    (claude-code-launch))))

;; Enable auto-launch (remove this line if you want to disable it)
(add-hook 'emacs-startup-hook #'agent-emacs-auto-launch-claude)

;;; Debug helper
(load-file (concat user-emacs-directory "debug-env.el"))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((claude-code :vc-backend Git :url
                  "https://github.com/stevemolitor/claude-code.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

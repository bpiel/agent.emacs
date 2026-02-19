;;; early-init.el --- Fast startup configuration -*- lexical-binding: t; -*-
;;
;; Optimizations for instant startup

;; Defer garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Keep package.el enabled (needed for vterm + claude-code)
;; But defer initialization to init.el for better control
(setq package-enable-at-startup nil)

;; Don't load default library
(setq inhibit-default-init t)

;; Disable unnecessary UI elements before they load
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Faster to disable these here
(setq frame-inhibit-implied-resize t)

;; Don't ping things at startup
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name)

;;; early-init.el ends here

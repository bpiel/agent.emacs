;;; Quick environment debugger
(defun debug-env ()
  "Show environment info."
  (interactive)
  (with-current-buffer (get-buffer-create "*debug-env*")
    (erase-buffer)
    (insert "=== ENVIRONMENT DEBUG ===\n\n")
    (insert (format "exec-path:\n%s\n\n" (mapconcat 'identity exec-path "\n")))
    (insert (format "PATH env:\n%s\n\n" (getenv "PATH")))
    (insert (format "claude found at: %s\n" (executable-find "claude")))
    (insert (format "shell: %s\n" (getenv "SHELL")))
    (insert (format "invoked from: %s\n" (if (display-graphic-p) "GUI" "terminal")))
    (pop-to-buffer (current-buffer))))

(global-set-key (kbd "C-c d") 'debug-env)
(message "Debug: Press C-c d to see environment info")

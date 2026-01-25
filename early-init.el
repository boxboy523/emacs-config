(setq user-emacs-directory (expand-file-name "~/.local/share/emacs/"))
(setq package-enable-at-startup nil)
(setq create-lockfiles nil)
:
(setq backup-directory-alist
       `((".*" . ,(concat user-emacs-directory "backups"))))

(setq auto-save-file-name-transforms
       `((".*" ,(concat user-emacs-directory "backups") t)))

(setq undo-tree-history-directory-alist
      `((".*" ,(concat user-emacs-directory "undo"))))

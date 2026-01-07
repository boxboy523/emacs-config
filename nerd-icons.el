
(use-package nerd-icons
  :straight t
  :demand t)

(use-package nerd-icons-completion
  :straight t
  :after (nerd-icons vertico)
  :config
  (nerd-icons-completion-mode))

;;(use-package nerd-icons-dired
;;  :straight t
;;  :hook
;;  (dired-mode . nerd-icons-dired-mode))

;; Treemacs에서 Nerd Icons를 사용하도록 설정
(use-package treemacs-nerd-icons
  :straight t
  :after (treemacs nerd-icons)
  :config
  (treemacs-nerd-icons-config))

(use-package nerd-icons-mode-line
  :straight (:host github :repo "grolongo/nerd-icons-mode-line")
  :custom
  (nerd-icons-mode-line-v-adjust 0.1) ; default value
  (nerd-icons-mode-line-size 1.0) ; default value
  :config (nerd-icons-mode-line-global-mode t))

(use-package nerd-icons-ibuffer
  :straight t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-corfu
  :straight t
  :after (corfu nerd-icons)
  :init
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
  :config
  (setq nerd-icons-corfu-mapping
        '(;; :style "cod" 대신 :set "cod" 또는 아예 생략하고 
          ;; nerd-icons가 제공하는 표준 아이콘 이름을 사용합니다.
          (array :icon "symbol_array" :set "cod" :face font-lock-type-face)
          (boolean :icon "symbol_boolean" :set "cod" :face font-lock-builtin-face)
          (file :fn nerd-icons-icon-for-file :face font-lock-string-face)
          (t :icon "code" :set "cod" :face font-lock-warning-face))))

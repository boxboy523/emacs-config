(use-package corfu
  :straight t
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :bind
  ;; ("M-TAB" . corfu-complete) ; M-TAB 주석 처리
  ("M-/" . corfu-complete)     ; M-/ (Alt + /) 사용
)

(use-package kind-icon
  :straight t
  :after corfu
  ;:custom
  ; (kind-icon-blend-background t)
  ; (kind-icon-default-face 'corfu-default) ; only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(straight-use-package
 '(corfu-terminal
   :type git
   :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))

(unless (display-graphic-p)
  (corfu-terminal-mode +1))

(electric-pair-mode 1)

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package flycheck
  :straight t)

(use-package lsp-haskell
  :straight t)

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred lsp-enable-log)
  :init
  (setq lsp-completion-provider :capf)
  (setq lsp-keymap-prefix "C-c l")
  (setq read-process-output-max (* 1024 1024))
  (setq gc-cons-threshold (* 20 1024 1024))
  :custom
  ;; completion backend로 completion-at-point을 사용하도록 설정 (corfu/cape 사용 가능)
  (lsp-idle-delay 0.500)
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-snippet t)
  :config
  ;; 자동으로 프로젝트 루트 기반에서 LSP 시작
  (setq lsp-auto-guess-root t)
  (lsp-enable-which-key-integration t)
  (setq lsp-rust-analyzer-server-command '("rust-analyzer"))
  (define-key lsp-mode-map (kbd "C-c l r") #'lsp-rename)
  (define-key lsp-mode-map (kbd "C-c l a") #'lsp-execute-code-action)
  (define-key lsp-mode-map (kbd "C-c l d") #'lsp-find-definition)
  (define-key lsp-mode-map (kbd "C-c l f") #'lsp-format-buffer)
  :hook
  (haskell-mode . lsp-deferred)
  (haskell-literate-mode . lsp-deferred))

(use-package lsp-ui
  :straight t
  :after lsp-mode
  :custom
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-show-hover t)
  :custom-face
  (lsp-ui-sideline-global ((t (:background "gray10" :slant italic))))
   :commands lsp-ui-mode)

;; optional: lsp-treemacs (symbols / errors view)
(use-package lsp-treemacs
  :straight t
  :after (lsp-mode treemacs)
  :bind
  ("C-c l e" . lsp-treemacs-errors-list)
  :commands lsp-treemacs-errors-list)

(use-package cape
  :straight t
  :after corfu
  :config
  ;; 많이 쓰는 cape 소스 등록(필요에 따라 순서 조정)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))
;; 스니펫
(use-package yasnippet
  :straight t
  :config
  (yas-global-mode 1))

;; (선택) lsp-ivy / consult-lsp: 심볼/레퍼런스 빠른 탐색
(use-package consult-lsp
  :straight t
  :after (consult lsp-mode)
  :commands (consult-lsp-symbols))

(use-package haskell-mode
  :straight t)

(use-package rust-mode
  :straight t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(setq rust-format-on-save t)
(add-hook 'rust-mode-hook
          (lambda () (prettify-symbols-mode)))
;; (add-hook 'rust-mode-hook #'lsp)
(use-package cargo
  :straight t
  :hook (rust-mode . cargo-minor-mode))
;; 1. 중요: 타입 정보와 에러 메시지를 모두 다 보여주도록 설정
(setq lsp-eldoc-render-all t)
(setq lsp-eldoc-enable-hover nil)

(use-package nix-mode
  :straight t
  :mode "\\.nix\\'")

;; 2. 미니버퍼가 내용이 길면 자동으로 늘어나게 설정 (한 줄만 보이면 잘림)
(setq eldoc-echo-area-use-multiline-p t)
(use-package geiser
  :straight t
  :hook (scheme-mode . geiser-mode))

(use-package geiser-chez
  :straight t)
(provide 'lsp-and-highlight)

;; 자동완성

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

(use-package cape
  :straight t
  :after corfu
  :config
  ;; 많이 쓰는 cape 소스 등록(필요에 따라 순서 조정)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; 2. 문법 검사 및 하이라이팅

(electric-pair-mode 1)

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package flycheck
  :straight t)

;; 3. LSP 공통 설정

(use-package eglot
  :straight t
  :hook ((rust-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         (gdscript-mode . eglot-ensure)
         (typescript-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l d" . xref-find-definitions)
              ("C-c l f" . eglot-format))
  :config
  ;; [중요] Godot 4 연결 설정: 실행하지 말고 localhost:6005로 접속만 해라
  (add-to-list 'eglot-server-programs
               '((gdscript-mode) . ("localhost" 6005)))

  ;; 성능 최적화: 이벤트 버퍼링
  (fset #'jsonrpc--log-event #'ignore)
  (setq eglot-events-buffer-size 0)
  (setq eglot-sync-connect 0))

;; Consult와 Eglot 연동 (심볼 검색 등)
(use-package consult-eglot
  :straight t
  :after (consult eglot))

(use-package yasnippet
  :straight t
  :config (yas-global-mode 1))

;; 4. 언어별 설정

(use-package haskell-mode
  :straight t
  :mode "\\.hs\\'"
  :hook (haskell-mode . (lambda ()
                          (setq indent-tabs-mode nil)
                          (setq tab-width 2)
                          (haskell-indentation-mode t)))
  :bind (:map haskell-mode-map
              ("C-c C-c" . haskell-compile)
              ("C-c C-l" . haskell-process-load-file)
              ("C-c C-z" . haskell-interactive-switch)))

(use-package rust-mode
  :straight t
  :mode "\\.rs\\'"
  :init
  (setq indent-tabs-mode nil)
  :config
  (setq rust-format-on-save t)
  (prettify-symbols-mode 1))

(use-package cargo
  :straight t
  :hook (rust-mode . cargo-minor-mode))

(use-package nix-mode
  :straight t
  :mode "\\.nix\\'")

(use-package typescript-mode
  :straight t
  :mode "\\.ts\\'")

(use-package gdscript-mode
    :straight (gdscript-mode
               :type git
               :host github
               :repo "godotengine/emacs-gdscript-mode")
    :hook (gdscript-mode . eglot-ensure)
    :mode "\\.gd\\'"
    :custom
    (gdscript-godot-executable "godot4"))

(use-package geiser
  :straight t
  :hook (scheme-mode . geiser-mode))

(use-package geiser-chez
  :straight t)

(setq eldoc-echo-area-use-multiline-p t)

(provide 'lsp-and-highlight)

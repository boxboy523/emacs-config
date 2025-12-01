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

(use-package lsp-haskell
  :straight t)

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred lsp-enable-log)
  :init
  ;; lsp 단축키 프리픽스 (원하면 변경)
  (setq lsp-keymap-prefix "C-c l")
  ;; 성능 개선: LSP가 더 큰 응답을 읽을 수 있게 함
  (setq read-process-output-max (* 1024 1024)) ; 1MB
  (setq gc-cons-threshold (* 20 1024 1024))    ; 메모리 가비지 컬렉션 임계값(선택)
  :custom
  ;; completion backend로 completion-at-point을 사용하도록 설정 (corfu/cape 사용 가능)
  (lsp-completion-provider :capf)
  ;; 기타 lsp 설정
  (lsp-idle-delay 0.500)         ; 변경 감지 후 여유 시간
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-snippet t)
  :config
  ;; 자동으로 프로젝트 루트 기반에서 LSP 시작
  (setq lsp-auto-guess-root t)
  (lsp-enable-which-key-integration t)
  ;; 편한 명령들 바인딩
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
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-delay 0.2)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-code-actions t)
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
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))
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

(use-package geiser
  :straight t
  :hook (scheme-mode . geiser-mode))

(use-package geiser-chez
  :straight t)

(provide 'lsp-and-highlight)

;; Straight.el 부트스트랩 코드
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq backup-directory-alist
      ;; 모든 백업 파일을 ~/.emacs.d/backups/ 디렉토리로 이동시킵니다.
      `((".*" . ,(concat user-emacs-directory "backups"))))

(setq auto-save-file-name-transforms
      ;; 자동 저장 파일도 동일 디렉토리로 이동시킵니다.
      `((".*" ,(concat user-emacs-directory "backups") t)))

(setq undo-tree-history-directory-alist
      `((".*" ,(concat user-emacs-directory "undo"))))
;; use-package 로드
(straight-use-package 'use-package)

(use-package el-patch
  :straight t)

;; Enable Vertico.
(use-package vertico
  :straight t
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :straight t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;;(use-package persp-mode
;;  :straight t
;;  :init
;;  (persp-mode 1)
;;  :config
;;  (setq	persp-auto-save-buffer nil
;;	persp-save-state-on-exit nil)
;;  :bind
;;  (:map global-map
;;        ("C-x p c" . persp-set-name)      ; 현재 관점 이름 설정/변경
;;        ("C-x p s" . persp-switch-by-name) ; 이름으로 관점 전환 (Vertico 인터페이스 사용)
;;        ("C-x p n" . persp-next)          ; 다음 관점으로 전환
;;        ("C-x p p" . persp-prev)          ; 이전 관점으로 전환
;;        ("C-x p k" . persp-kill)          ; 현재 관점 제거
;;        ))

(use-package winum
  :straight t
  :config
  (winum-mode))

(use-package which-key
  :straight t
  :config
  (which-key-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :straight t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package ir-black-theme
  :straight t
  :config
  (load-theme 'ir-black t))

(use-package nerd-icons
  :straight t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq x-select-enable-primary t)  ; X 윈도우의 'PRIMARY' 클립보드와 연동
(setq x-select-enable-clipboard t) ; X 윈도우의 'CLIPBOARD'와 연동

(use-package magit
  :straight t
  :bind (("C-x g" . magit-status)))

(use-package vterm
  :straight t)

(load (expand-file-name "consult-config.el" (file-name-directory load-file-name)))
(load (expand-file-name "treemacs-config.el" (file-name-directory load-file-name)))
(load (expand-file-name "my-keys.el" (file-name-directory load-file-name)))

(use-package projectile
  :straight t
  :init
  (projectile-mode +1))

;; 1. Straight.el에게 Copilot을 설치/업데이트하도록 명령합니다.
(straight-use-package 
 '(copilot :type git :host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist")))

;; 2. Copilot이 성공적으로 설치된 후에만 로드하고 설정합니다.
(eval-after-load 'copilot
  '(progn
     (add-hook 'prog-mode-hook 'copilot-mode)
     (define-key copilot-mode-map (kbd "<tab>") #'copilot-accept-completion)
     (message "Copilot loaded successfully (Manual Load).")))

;; Copilot-chat도 동일하게 처리합니다.
(straight-use-package 
 '(copilot-chat :type git :host github :repo "chep/copilot-chat.el" :files ("*.el")))

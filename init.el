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

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4)

;; -----------------------------------------------------------
;; UI 요소 제거 (터미널 공간 확보)
;; -----------------------------------------------------------

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))   ; 상단 아이콘 툴바 제거
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))   ; 상단 텍스트 메뉴바 제거
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ; 우측 스크롤바 제거

;; 시작 화면(스타트업 메시지) 끄기
(setq inhibit-startup-screen t)

(setq-default truncate-lines t)

;; 화면을 한 줄씩 정직하게 스크롤하게 함
(setq scroll-margin 0)
(setq scroll-conservatively 10000)t
(setq scroll-preserve-screen-position t)

;; 마우스 스크롤 시에도 렌더링 부하 감소
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

;; use-package 로드
(straight-use-package 'use-package)

(straight-use-package 'org)

(use-package exec-path-from-shell
  :straight t
  :init
  (exec-path-from-shell-initialize)
)

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

(use-package dirvish
  :straight t
  :demand t
  :init
  (dirvish-override-dired-mode)
  :bind
  (("C-x d" . dirvish)
   :map dirvish-mode-map
   ("M-p" . dirvish-peek-mode))
  :after nerd-icons  
  :config
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-default-layout '(preview))
  (setq dirvish-mode-line-height 10)
  (setq dirvish-attributes
        '(nerd-icons file-time file-size collapse subtree-state vc-state git-msg))
  (setq dirvish-subtree-state-style 'nerd)
  (setq delete-by-moving-to-trash t)
  (setq dirvish-path-separators (list
                                 (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                 (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                 (format " %s " (nerd-icons-faicon "nf-fa-angle_right"))))
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  (dirvish-peek-mode) ; Preview files in minibuffer
  (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  )
(tab-bar-mode 1)

(use-package clipetty
  :straight t
  :hook (after-init . global-clipetty-mode))

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

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

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
         ("M-a" . marginalia-cycle))

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

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package magit
  :straight t
  :bind (("C-x g" . magit-status)))

(use-package vterm
  :straight t
  :config
  (setq vterm-max-scrollback 10000))

(use-package vterm-toggle
  :straight t
  :init
  (require 'project)
  :bind (("C-z" . vterm-toggle)
         :map vterm-mode-map
         ("C-z" . vterm-toggle)))

(load (expand-file-name "consult-config.el" (file-name-directory load-file-name)))
(load (expand-file-name "treemacs-config.el" (file-name-directory load-file-name)))
(load (expand-file-name "my-keys.el" (file-name-directory load-file-name)))
(load (expand-file-name "lsp-and-highlight.el" (file-name-directory load-file-name)))
(load (expand-file-name "nerd-icons.el" (file-name-directory load-file-name)))

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-vc-selected-packages
   '((nerd-icons-mode-line :url
                           "https://github.com/grolongo/nerd-icons-mode-line"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

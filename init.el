(when (boundp 'native-comp-eln-load-path)
  (setq native-comp-eln-load-path
        (list (expand-file-name "eln-cache/" user-emacs-directory))))

;; [디버깅] TRAMP 상세 로그 비활성화 (정상화)
(setq tramp-verbose 3)

(setq lsp-completion-provider :capf)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

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

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; -----------------------------------------------------------
;; UI 요소 제거 (터미널 공간 확보)
;; -----------------------------------------------------------

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))   ; 상단 아이콘 툴바 제거
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))   ; 상단 텍스트 메뉴바 제거
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ; 우측 스크롤바 제거

;; 시작 화면(스타트업 메시지) 끄기
(setq inhibit-startup-screen t)

(setq-default truncate-lines t)

(use-package ir-black-theme
  :straight t
  :config
  (load-theme 'ir-black t))

;; 화면을 한 줄씩 정직하게 스크롤하게 함
;;(setq scroll-margin 0)
;;(setq scroll-conservatively 10000)t
;;(setq scroll-preserve-screen-position t)

;; 마우스 스크롤 시에도 렌더링 부하 감소
;;(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;;(setq mouse-wheel-progressive-speed nil)

;; Korean
(setq default-input-method "korean-hangul")

;; -----------------------------------------------------------
;; 성능 튜닝: 가비지 컬렉션(GC) 빈도 줄이기
;; -----------------------------------------------------------

;; 1. GC 임계값을 100MB로 대폭 상향 (기본값: 800KB)
;;    -> 평소에는 메모리를 넉넉하게 쓰다가, 100MB 찰 때만 청소함.
(setq gc-cons-threshold (* 200 1024 1024))

;; 2. 프로세스 통신(LSP 등)에서 읽어오는 데이터 양 늘리기
(setq read-process-output-max (* 1024 1024)) ;; 1MB

;; use-package 로드
(straight-use-package 'use-package)

(use-package transient
  :straight t)

(straight-use-package 'org)

(use-package exec-path-from-shell
  :straight t
  :init
  (exec-path-from-shell-initialize))

;; -----------------------------------------------------------
;; 폰트 설정
;; -----------------------------------------------------------
(defun my-font-setup ()
  ;; 1. 영문 폰트 설정 (기본 폰트)
  ;; :height 120 은 12pt 크기를 의미합니다. (10배수)
  (set-face-attribute 'default nil
                      :font (font-spec :family "Terminess Nerd Font Mono"
                                       :size 14.0
                                       :weight 'medium
                                       :antialias t))

  ;; 2. 한글 폰트 설정 (따로 지정해야 안 깨짐)
  ;; 'hangul 스크립트에 대해서만 둥근모 Neo를 씁니다.
  (set-fontset-font t 'hangul (font-spec :name "Monoplex KR"
                                     	 :antialias t))

  ;; 3. 특수문자/이모지 설정 (선택사항)
  ;; 폰트가 없어서 네모(□)로 나오는 문자를 잡아줍니다.
  (set-fontset-font t 'symbol (font-spec :family "og-dcm-emoji") nil 'prepend)
  (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend))

(add-hook 'server-after-make-frame-hook
          (lambda () (my-font-setup)))

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
  (dirvish-side-follow-mode))
;;(tab-bar-mode 1)
;; -----------------------------------------------------------
;; 버퍼 탭 설정 (Tab Line)
;; -----------------------------------------------------------
(use-package tab-line
  :straight t
  :hook (after-init . global-tab-line-mode) ;; 시작하자마자 켜기
  :config
  ;; 1. 불필요한 버튼 숨기기
  (setq tab-line-new-button-show nil)      ;; '새 탭' (+) 버튼 숨김
  (setq tab-line-close-tab-function 'kill-buffer) ;; 닫기 버튼 누르면 버퍼 kill
  (setq tab-line-separator " "))            ;; 탭 사이 간격

(use-package tab-line-nerd-icons
  :straight t)

(defun my-tab-line-setup ()
  (interactive)
  (unless global-tab-line-mode
    (global-tab-line-mode 1)
    (tab-line-nerd-icons-global-mode)))

(add-hook 'server-after-make-frame-hook 'my-tab-line-setup)

;; tab-line 색상 커스텀 (ir-black 테마와 어울리게)
(custom-set-faces
 '(tab-line ((t (:background "#151515" :height 0.95))))           ;; 탭 바 전체 배경 (아주 어두운 회색)
 '(tab-line-tab ((t (:background "#353535" :foreground "#888888" :box nil)))) ;; 비활성 탭 (회색 배경, 회색 글씨)
 '(tab-line-tab-current ((t (:background "#000000" :foreground "#ffffff" :weight bold :box nil)))) ;; 활성 탭 (검은 배경, 흰 글씨)
 '(tab-line-tab-inactive ((t (:inherit tab-line-tab)))))          ;; (혹시 몰라 안전장치)

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

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package magit
  :straight t
  :bind (("C-x g" . magit-status)))

(use-package vterm
  :straight t
  :config
  (setq vterm-max-scrollback 10000))

(use-package project
  :straight t
  :demand t)

(use-package vterm-toggle
  :straight t
  :init
  :bind (("C-z" . vterm-toggle)
         :map vterm-mode-map
         ("C-z" . vterm-toggle)))

;; 공백 시각화
(use-package whitespace
  :straight t
  :hook ((prog-mode . whitespace-mode)
         (text-mode . whitespace-mode))
  :config
  ;; 표시 스타일
  (setq whitespace-style '(face
                           tabs
                           tab-mark
                           spaces
                           space-mark
                           trailing))
  (setq whitespace-line-column nil)
  ;; 공백 문자 표시 방식
  (setq whitespace-display-mappings
        '((space-mark 32 [?•] [?.])        ;; 공백 → 점 (·)
          (newline-mark 10 [?↵ 10])           ;; 줄바꿈 → ↵
          (tab-mark 9 [?→ 9] [?^ 9])))       ;; 탭 → →

  ;; 색상: ir-black 테마에 맞춘 어두운 회색
  (set-face-attribute 'whitespace-space nil
                      :background "inherit"
                      :foreground "#222222"  ;; 어두운 회색
                      :weight 'light)
  (set-face-attribute 'whitespace-tab nil
                      :background "inherit"
                      :foreground "#222222"
                      :weight 'light)
  (set-face-attribute 'whitespace-trailing nil
                      :background "#3a3a3a"  ;; 배경 강조
                      :foreground "#888888"
                      :weight 'bold)
  (set-face-attribute 'whitespace-newline nil
                      :foreground "#454545"
                      :weight 'light))

(load (expand-file-name "lsp-and-highlight.el" (file-name-directory load-file-name)))
(load (expand-file-name "consult-config.el" (file-name-directory load-file-name)))
(load (expand-file-name "treemacs-config.el" (file-name-directory load-file-name)))
(load (expand-file-name "my-keys.el" (file-name-directory load-file-name)))
(load (expand-file-name "nerd-icons.el" (file-name-directory load-file-name)))

;; -----------------------------------------------------------
;; AI 코딩 보조 (Copilot) - use-package로 통일
;; -----------------------------------------------------------
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist"))
  :hook (prog-mode . copilot-mode)
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))

  (let ((server-file (expand-file-name "copilot/dist/agent.js" user-emacs-directory)))
    (unless (file-exists-p server-file)
      (message "Copilot server not found. Installing...")
      (copilot-install-server)))
  (message "Copilot loaded."))

;; (use-package copilot-chat
;;  :straight (:host github :repo "chep/copilot-chat.el" :files ("*.el"))
;;  :after copilot
;;  :bind (("C-c c" . copilot-chat-transient)  ;; 메인: Transient 메뉴
;;         ("C-c C-o c" . copilot-chat-display)  ;; 빠른 열기
;;         ("C-c C-o a" . copilot-chat-custom-mini-buffer))  ;; 빠른 질문 (("C-c c c" . copilot-chat)
;;  :config
;;  (setq copilot-chat-mode-hook
;;        '(display-line-numbers-mode
;;          (lambda () (setq-local truncate-lines t)))))

(use-package eat
  :straight (:type git
                   :host codeberg
                   :repo "akib/emacs-eat"
                   :files ("*.el" ("term" "term/*.el") "*.texi"
                           "*.ti" ("terminfo/e" "terminfo/e/*")
                           ("terminfo/65" "terminfo/65/*")
                           ("integration" "integration/*")
                           (:exclude ".dir-locals.el" "*-tests.el"))))

(use-package popup :straight t)
(use-package gemini-cli
  :straight (:type git :host github :repo "linchen2chris/gemini-cli.el" :branch "main"
                   :files ("*.el" (:exclude "demo.gif")))
  :bind-keymap
  ("C-c c" . gemini-cli-command-map)
  :config
  (gemini-cli-mode))

(with-eval-after-load 'copilot
  (define-key copilot-mode-map (kbd "<tab>") nil)
  (define-key copilot-mode-map (kbd "TAB") nil)
  (define-key copilot-mode-map (kbd "C-<tab>") 'copilot-accept-completion)
  (define-key copilot-mode-map (kbd "C-TAB") 'copilot-accept-completion)
  (define-key copilot-mode-map (kbd "s-n") 'copilot-next-completion)
  (define-key copilot-mode-map (kbd "s-p") 'copilot-previous-completion)
  (define-key copilot-mode-map (kbd "s-<right>") 'copilot-accept-completion-by-word)
  (define-key copilot-mode-map (kbd "s-<down>") 'copilot-accept-completion-by-line))

;; -----------------------------------------------------------
;; 환경 변수 및 LSP 실행 트리거 (가장 중요)
;; -----------------------------------------------------------
(use-package envrc
  :straight t
  :demand t
  :config
  (envrc-global-mode)
  (add-hook 'envrc-mode-hook
          (lambda ()
            ;; Rust, Haskell, Nix 등 direnv 환경이 로드된 후 Eglot 시작
            (when (or (derived-mode-p 'rust-mode)
                      (derived-mode-p 'haskell-mode)
                      (derived-mode-p 'nix-mode)
                      (derived-mode-p 'gdscript-mode)
                      (derived-mode-p 'typescript-mode))
              (eglot-ensure)))))

;; Custom 파일 변수들 (자동 생성됨)
(custom-set-variables
 '(package-vc-selected-packages
   '((nerd-icons-mode-line :url "https://github.com/grolongo/nerd-icons-mode-line"))))
(custom-set-faces)

(setq org-image-actual-width nil)
;; ----------------------------------------------------------------------
;; 1. Org Modern (디자인 개선)
;; ----------------------------------------------------------------------
(use-package org-modern
  :straight t
  :hook
  ((org-mode . org-modern-mode)
   (org-agenda-finalize . org-modern-agenda)) ; 아젠다에도 적용
  :custom
  (org-modern-star '("◉" "○" "◈" "◇" "★" "◆" "■" "□" "▲" "△")) ; 제목 아이콘 커스텀
  (org-modern-hide-stars nil) ; 별(제목 표시) 숨김 여부
  (org-modern-table-vertical 1) ; 표 세로선 표시
  (org-modern-table-horizontal 0.2) ; 표 가로선 두께
  :config
  (global-org-modern-mode))

;; ----------------------------------------------------------------------
;; 2. Org Roam (제텔카스텐/지식 관리)
;; ----------------------------------------------------------------------
(use-package org-roam
  :straight t
  :custom
  (org-roam-directory (file-truename "~/documents/org")) ; ★ 노트 저장 경로 (미리 폴더 생성 필요)
  (org-roam-completion-everywhere t) ; 어디서든 링크 완성 기능 사용
  :bind (("C-c n l" . org-roam-buffer-toggle) ; 백링크 버퍼 켜기/끄기
         ("C-c n f" . org-roam-node-find)     ; 노트 찾기/생성
         ("C-c n g" . org-roam-graph)         ; 그래프 보기
         ("C-c n i" . org-roam-node-insert)   ; 현재 위치에 링크 삽입
         ("C-c n c" . org-roam-capture)       ; 캡처(새 노트 작성)
         ;; Dailies (일기/데일리 노트)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates
        '(("d" "default" plain
           "%?"
           :if-new (file+head "${slug}.org"  ; 원래 있던 %<%Y%m%d%H%M%S>- 부분을 지웠습니다.
                              "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t))))

;; ----------------------------------------------------------------------
;; 3. Org Super Agenda (아젠다 그룹화)
;; ----------------------------------------------------------------------
(use-package org-super-agenda
  :straight t
  :after org-agenda
  :config
  (org-super-agenda-mode 1)

  ;; 예시: 기본 아젠다 뷰 설정 (사용자 취향에 맞춰 수정 가능)
  (setq org-agenda-custom-commands
        '(("z" "Super View"
           ((agenda "" ((org-agenda-span 'day)
                        (org-super-agenda-groups
                         '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :todo "TODAY"
                                  :scheduled today
                                  :order 1)
                           (:name "High Priority"
                                  :priority "A"
                                  :order 2)
                           (:name "Due Soon"
                                  :deadline future
                                  :order 3)
                           (:name "Waiting"
                                  :todo "WAITING"
                                  :order 9)
                           (:discard (:anything t))))))))))) ; 나머지는 숨김 (테스트용)

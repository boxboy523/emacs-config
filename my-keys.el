;; 복사 붙여넣기 잘라내기 커스텀
(global-set-key (kbd "C-x x") 'kill-region)
(global-set-key (kbd "C-x c") 'copy-region-as-kill)
(global-set-key (kbd "C-x v") 'yank)

(global-set-key (kbd "C-S-x") 'kill-region)
(global-set-key (kbd "C-S-c") 'copy-region-as-kill)
(global-set-key (kbd "C-S-v") 'yank)

(global-set-key (kbd "C-x C-z") 'delete-frame)

;;windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; 기존 C-x 4 설정이 있다면 제거합니다.
(global-unset-key (kbd "C-x 4"))

(define-prefix-command 'my-window-control-map)
(global-set-key (kbd "C-w") 'my-window-control-map)
;; 창 분할
(global-set-key (kbd "C-w v") 'split-window-right) ; C-x w v: 세로 분할 (V for Vertical)
(global-set-key (kbd "C-w h") 'split-window-below)  ; C-x w h: 가로 분할 (H for Horizontal)

;; 창 정리/삭제
(global-set-key (kbd "C-w d") 'delete-window)      ; C-x w d: 현재 창 닫기 (D for Delete)
(global-set-key (kbd "C-w f") 'delete-other-windows) ; C-x w f: 현재 창 최대화 (F for Full/Focus)

(global-set-key (kbd "M-<up>") 'scroll-down-command)
(global-set-key (kbd "M-<down>") 'scroll-up-command)

(global-set-key (kbd "M-<left>") 'move-beginning-of-line)
(global-set-key (kbd "M-<right>") 'move-end-of-line)

;; --- Eldoc 문서 토글 함수 추가 ---
(defun my-eldoc-doc-toggle ()
  "Eldoc 문서 버퍼가 있으면 닫고, 없으면 엽니다."
  (interactive)
  (let ((win (get-buffer-window "*eldoc*")))
    (if win
        (delete-window win)
      (eldoc-doc-buffer))))

;; --- 전역 폰트 크기 조절 함수 추가 ---
(defun my-global-text-scale-increase ()
  "전역 폰트 크기를 키웁니다."
  (interactive)
  (let ((old-face-attribute (face-attribute 'default :height)))
    (set-face-attribute 'default nil :height (+ old-face-attribute 10))))

(defun my-global-text-scale-decrease ()
  "전역 폰트 크기를 줄입니다."
  (interactive)
  (let ((old-face-attribute (face-attribute 'default :height)))
    (set-face-attribute 'default nil :height (- old-face-attribute 10))))

;; --- 단축키 바인딩 변경 및 추가 ---
;; 기존 C-= / C-- 는 버퍼 로컬 조절로 두고,
;; C-M-= / C-M-- 를 전역 조절로 할당하거나 취향에 맞게 교체하세요.
(global-set-key (kbd "C-+") 'my-global-text-scale-increase)
(global-unset-key (kbd "C-_")) ; 기존 C-_ 단축키 제거
(global-set-key (kbd "C-_") 'my-global-text-scale-decrease)

;; Eldoc 토글 단축키 (LSP 프리픽스 C-c l 에 맞춤)
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l h") #'my-eldoc-doc-toggle))

;; -----------------------------------------------------------
;; C-x + 숫자 : Tab Line 탭 전환 (기존 창 관리 키 덮어씀)
;; -----------------------------------------------------------

;; 1. N번째 탭으로 이동하는 함수 (이전과 동일)
(defun my-tab-line-switch-to-tab (n)
  "Tab Line에 보이는 목록 중 n번째 탭으로 이동합니다."
  (interactive "p")
  (let ((tabs (funcall tab-line-tabs-function)))
    (if (and tabs (< (1- n) (length tabs)))
        (switch-to-buffer (nth (1- n) tabs))
      (message "탭 %d번은 없습니다." n))))

;; 2. C-x 1 ~ C-x 9 키 바인딩 설정
(mapc (lambda (n)
        (global-set-key (kbd (format "C-x %d" n))
                        ;; 람다로 숫자 n을 고정(capture)해서 바인딩
                        `(lambda () (interactive) (my-tab-line-switch-to-tab ,n))))
      (number-sequence 1 9))

;; 3. (선택) C-x 0 : 현재 탭(버퍼) 닫기
;; 원래 C-x 0 (delete-window) 자리에 '현재 버퍼 닫기'를 넣으면 직관적입니다.
(global-set-key (kbd "C-x 0") 'kill-current-buffer)

;; -----------------------------------------------------------
;; 저장 없이 삭제하기 (Blackhole Delete)
;; -----------------------------------------------------------

(defun my-delete-line-or-region ()
  "선택 영역이 있으면 영역 삭제, 없으면 현재 줄 전체 삭제 (Kill Ring 저장 X)"
  (interactive)
  (if (use-region-p)
      ;; 1. 선택 영역이 있으면 -> 영역만 'Delete'
      (delete-region (region-beginning) (region-end))
    ;; 2. 선택 영역이 없으면 -> 현재 줄 전체 'Delete'
    (delete-region (line-beginning-position) (line-beginning-position 2))))

;; 단축키 설정 (원하는 키로 바꾸셔도 됩니다)
(global-set-key (kbd "M-d") 'my-delete-line-or-region)

(global-set-key (kbd "<backspace>") 'backward-delete-char-untabify)

(global-set-key (kbd "C-=") 'text-scale-increase)

(global-set-key (kbd "C--") 'text-scale-decrease)

(provide 'my-keys)

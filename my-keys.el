;; 복사 붙여넣기 잘라내기 커스텀
(global-set-key (kbd "C-x x") 'kill-region)
(global-set-key (kbd "C-x c") 'copy-region-as-kill)
(global-set-key (kbd "C-x v") 'yank)

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

(define-prefix-command 'my-tab-control-map)

(global-set-key (kbd "C-t") 'my-tab-control-map)

(define-key my-tab-control-map (kbd "t") #'tab-bar-new-tab)
;; 탭 닫기
(define-key my-tab-control-map (kbd "d") #'tab-bar-close-tab)
;; 탭 이름 변경
(define-key my-tab-control-map (kbd "r") #'tab-bar-rename-tab)
;; 다음 / 이전 탭
(define-key my-tab-control-map (kbd "<right>") #'tab-bar-switch-to-next-tab)
(define-key my-tab-control-map (kbd "<left>")  #'tab-bar-switch-to-prev-tab)

;; 번호(1-9)로 바로 이동: C-t 1 ... C-t 9
;; tab-bar-select-tab은 1-based 인덱스를 사용. 클로저로 각각 바인딩.
(dotimes (i 9)
  (let ((n (1+ i)))
    (define-key my-tab-control-map (kbd (number-to-string n))
      `(lambda ()
         (interactive)
         (tab-bar-select-tab ,n)))))

;; (선택) which-key가 있으면 프리픽스 도움을 보기 쉽게 함
(when (featurep 'which-key)
  (which-key-add-key-based-replacements
    "C-t" "tabs"
    "C-t t" "new tab"
    "C-t d" "close tab"
    "C-t r" "rename tab"))

(provide 'my-keys)

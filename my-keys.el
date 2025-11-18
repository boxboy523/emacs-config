;; 복사 붙여넣기 잘라내기 커스텀
(global-set-key (kbd "C-x x") 'kill-region)
(global-set-key (kbd "C-x c") 'copy-region-as-kill)
(global-set-key (kbd "C-x v") 'yank)

;;windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; 기존 C-x 4 설정이 있다면 제거합니다.
(global-unset-key (kbd "C-x 4"))

;; 창 분할
(global-set-key (kbd "C-x w v") 'split-window-right) ; C-x w v: 세로 분할 (V for Vertical)
(global-set-key (kbd "C-x w h") 'split-window-below)  ; C-x w h: 가로 분할 (H for Horizontal)

;; 창 정리/삭제
(global-set-key (kbd "C-x w d") 'delete-window)      ; C-x w d: 현재 창 닫기 (D for Delete)
(global-set-key (kbd "C-x w f") 'delete-other-windows) ; C-x w f: 현재 창 최대화 (F for Full/Focus)

(provide 'my-keys)

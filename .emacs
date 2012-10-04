; Don't show startup message
(setq inhibit-startup-message t)

(setq load-path (cons "~/.emacs.d/elisp" load-path))

; 見栄えとかそういうもの
(auto-fill-mode)
(global-font-lock-mode t)
(set-face-background 'region "darkgreen")
(setq visible-bell t)
(show-paren-mode)
(transient-mark-mode t)
(setq indent-tabs-mode nil)    ; インデントにスペースを使う
(add-to-list 'default-frame-alist '(cursor-type . (bar . 2)))
(tool-bar-mode 0)
(column-number-mode t)
(line-number-mode t)
(set-scroll-bar-mode 'right)
; backup
(setq backup-inhibit t)
(setq delete-auto-save-files t)

; anthy
; (load-library "anthy") 
(set-language-environment "Japanese")
(setq default-input-method "japanese-anthy")


;;; キーバインド
(global-set-key "\C-z" 'undo)
(global-set-key [kp-delete] 'delete-char)
(global-set-key [delete] 'delete-char)



;;; プラグイン

; install-elisp.el
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

; anything.el
(require 'anything-config)
(define-key global-map (kbd "C-;") 'anything)
; (add-to-list ')

; auto-complete.el
(require 'auto-complete)
(global-auto-complete-mode t)

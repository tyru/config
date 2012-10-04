; Don't show startup message
(setq inhibit-startup-message t)

; add ~/.emacs.d/lisp to load-path (for ddskk)
;
; (setq load-path (cons "~/.emacs.d/elisp" load-path))
;
; (let ((default-directory (expand-file-name "~/.emacs.d/lisp")))
;    (add-to-list 'load-path default-directory)
;     (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
;            (normal-top-level-add-subdirs-to-load-path)))

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
; (set-language-environment "Japanese")
; (setq default-input-method "japanese-anthy")


;;; キーバインド
(global-set-key "\C-z" 'undo)
(global-set-key [kp-delete] 'delete-char)
(global-set-key [delete] 'delete-char)



;;; プラグイン

; auto-install.el
; (add-to-list 'load-path auto-install-directory)
(add-to-list 'load-path "~/.emacs.d/auto-install")
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

; ; install-elisp.el
; (require 'install-elisp)
; (setq install-elisp-repository-directory "~/.emacs.d/elisp/")
; 
; ; anything.el
; (require 'anything-config)
; (define-key global-map (kbd "C-;") 'anything)
; ; (add-to-list ')
; 
; ; auto-complete.el
; (require 'auto-complete)
; (global-auto-complete-mode t)
;
; ddskk
; ;; C-j の機能を別のキーに割り当て
; (global-set-key (kbd "C-m") 'newline-and-indent)
; ;; C-x C-j で skk モードを起動
; (global-set-key (kbd "C-x C-j") 'skk-mode)
; ;; C-\ でも SKK に切り替えられるように設定
; ; (setq default-input-method "japanese-skk")
; ;; 送り仮名が厳密に正しい候補を優先して表示
; (setq skk-henkan-strict-okuri-precedence t)
; ;;漢字登録時、送り仮名が厳密に正しいかをチェック
; (setq skk-check-okurigana-on-touroku t)
; ;; 有効化
; (skk-mode)

(require 'skk-autoloads)
(global-set-key (kbd "C-x C-j") 'skk-mode) ; C-x C-j で skk モードを起動
(setq skk-byte-compile-init-file t) ; .skk を自動的にバイトコンパイル

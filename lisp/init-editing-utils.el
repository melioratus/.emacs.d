;;----------------------------------------------------------------------------
;;  Some basic preferences
;;----------------------------------------------------------------------------
(setq-default
 blink-cursor-interval 0.4
 bookmark-default-file (expand-file-name ".bookmarks.el" user-emacs-directory)
 buffers-menu-max-size 30
 case-fold-search t
 default-tab-width 4
 delete-selection-mode t
 ediff-split-window-function 'split-window-horizontally
 ediff-window-setup-function 'ediff-setup-windows-plain
 fill-column 130
 ;; enable visual line mode
 ;;when you are on the last line of the buffer, C-n will act like <return>
 next-line-add-newlines t
 indent-tabs-mode nil
 make-backup-files nil
 ;; only auto-save when the buffer has been idle for 1 hour.  This has no purpose other than to stop auto-saves
 ;; the next two lines are dumb hacks to try to stop auto-saving
 ;;auto-save-timeout 3600
 ;;auto-save-interval 2000
 ;; this should turn off auto-saving the proper way.
 auto-save-default nil
 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
 scroll-preserve-screen-position 'always
 set-mark-command-repeat-pop t
 show-trailing-whitespace t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil
 ;;visible-bell t
 )

(global-visual-line-mode 1)
(global-linum-mode 1)
;; this highlights search and replace as you type
(require 'anzu)
(global-anzu-mode +1)

(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)


;;; Whitespace

(defun sanityinc/no-trailing-whitespace ()
  "Turn off display of trailing whitespace in this buffer."
  (setq show-trailing-whitespace nil))

;; But don't show trailing whitespace in SQLi, inf-ruby etc.
(dolist (hook '(special-mode-hook
                eww-mode-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook
                twittering-mode-hook
                minibuffer-setup-hook))
  (add-hook hook #'sanityinc/no-trailing-whitespace))


;;; Newline behaviour
(global-set-key (kbd "RET") 'newline-and-indent)



(when (fboundp 'global-prettify-symbols-mode)
  (global-prettify-symbols-mode))


;; When you define a macro, you can type C-x Q to prompt the user for input.
;; Very helpful and cool!
(defun my-macro-query (arg)
  "Prompt for input using minibuffer during kbd macro execution.
    With prefix argument, allows you to select what prompt string to use.
    If the input is non-empty, it is inserted at point."
  (interactive "P")
  (let* ((query (lambda () (kbd-macro-query t)))
         (prompt (if arg (read-from-minibuffer "PROMPT: ") "Input: "))
         (input (unwind-protect
                    (progn
                      (add-hook 'minibuffer-setup-hook query)
                      (read-from-minibuffer prompt))
                  (remove-hook 'minibuffer-setup-hook query))))
    (unless (string= "" input) (insert input))))

(global-set-key "\C-xQ" 'my-macro-query)

;; put semantic is supposed to have that feature too.
;;This mode highlights the current word under point! very cool!
;; (require-package 'highlight-symbol)
;; (dolist (hook '(prog-mode-hook html-mode-hook css-mode-hook))
;;   (add-hook hook 'highlight-symbol-mode)
;;   (add-hook hook 'highlight-symbol-nav-mode))
;; (eval-after-load 'highlight-symbol
;;   '(diminish 'highlight-symbol-mode))



;; save all buffers after saving the current buffer.
(add-hook 'after-save-hook #'(lambda ()
                               (interactive)
                               (save-some-buffers 1)))

;;----------------------------------------------------------------------------
;; Don't disable narrowing commands
;;----------------------------------------------------------------------------
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;;----------------------------------------------------------------------------
;; Show matching parens
;;----------------------------------------------------------------------------
(show-paren-mode 1)

;;----------------------------------------------------------------------------
;; Expand region
;;----------------------------------------------------------------------------
;; The binding for this is listed below
(require-package 'expand-region)

;;----------------------------------------------------------------------------
;; Don't disable case-change functions
;;----------------------------------------------------------------------------
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;----------------------------------------------------------------------------
;; Handy key bindings
;;----------------------------------------------------------------------------

;; This is just not working...
(defun toggle-refill-mode ()
  "This will toggle refill mode"
  (interactive)
  (set-fill-column 134)
  (if (= refill-mode-state 0)
      '(lambda ()
         (set-fill-column 134)
         ;;since refill-mode state is off, then turn on refill-mode
         (refill-mode 1)
         (setq refill-mode-state 1))
    '(lambda ()
       (refill-mode 0)
       (set-fill-column 134)
       (setq refill-mode-state 0))))

(global-set-key (kbd "C-c C-x r") #'toggle-refill-mode)

(defun my/uppercase-word ()
  "capitalize the current word."
  (interactive)
  (forward-word)
  (backward-word)
  (capitalize-word 1))

(defun my/downcase-word ()
  "downcase the current word."
  (interactive)
  (forward-word)
  (backward-word)
  (downcase-word 1))


(defun indent-whole-buffer ()
  "This indents the whole buffer"
  (interactive)
  (indent-region (point-min) (point-max)))

;;all of my "C-c [letter]" commands
;; most of these commands are also in init-evil.el
;; It's probably not a good idea to have duplicate code, but
;;this is not working.
;;(define-key yas-minor-mode-map (kbd "C-c s") 'yas-expand)
(global-set-key "\t" #'indent-for-tab-command)
(global-set-key (kbd "s-s") #'save-buffer)
(global-set-key (kbd "s-g") #'magit-status)
(global-set-key (kbd "C-c g") #'magit-status)
(global-set-key (kbd "C-c P") #'pwd)
(global-set-key (kbd "C-c f") #'isearch-forward)
(global-set-key (kbd "C-c F") #'isearch-forward-regexp)
(global-set-key (kbd "C-c t") #'transpose-chars)
(global-set-key (kbd "C-c h") #'helm-command-prefix)
(global-set-key (kbd "s-u") #'my/uppercase-word)
;; this conflicts with my command for dired.
(global-set-key (kbd "s-d") #'my/downcase-word)
(global-set-key (kbd "s-a") #'mark-whole-buffer)
(global-unset-key (kbd "C-a"))
(local-unset-key (kbd "C-a"))
(global-set-key (kbd "C-c ;") #'comment-dwim)
(global-set-key (kbd "C-c d") #'dired-jump)
(global-set-key (kbd "C-c b") #'eval-buffer)
(global-set-key (kbd "C-c l") #'eval-last-sexp)
(global-set-key (kbd "C-c m") #'helm-mini)
(global-set-key (kbd "C-c q") #'fill-paragraph)
(global-set-key (kbd "C-c e") #'helm-M-x)
(global-set-key (kbd "C-c m") #'helm-mini)
;; this is not working for some reason.
(global-set-key (kbd "C-c x") #'er/expand-region)
(global-set-key (kbd "C-c i") #'info-display-manual)

(global-set-key (kbd "C-x C-.") #'pop-global-mark)
;; web-mode has a command C-c C-h that overrides this.
;; I've modified the web-mode-hook to account for this.
(global-set-key (kbd "C-c C-h") #'help)
(global-set-key (kbd "C-c h k") #'helm-show-kill-ring)
(global-set-key (kbd "C-x f") #'helm-find-files)
(global-set-key (kbd "C-c h o") #'helm-occur)
(global-set-key (kbd "C-c h c") #'helm-calcul-expression)

(require-package 'multiple-cursors)
;; multiple-cursors
(global-set-key (kbd "C-c <") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c >") #'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-<") #'mc/mark-all-like-this)
;; From active region to multiple cursors:
(global-set-key (kbd "C-c c r") #'set-rectangular-region-anchor)
(global-set-key (kbd "C-c c c") #'mc/edit-lines)
(global-set-key (kbd "C-c c e") #'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c c a") #'mc/edit-beginnings-of-lines)

;; To make myself use C-w h/t/n/s
(global-set-key (kbd "C-x o") 'other-window)
;; make myself use "s-s"
(global-unset-key (kbd "C-x C-s"))

;;----------------------------------------------------------------------------
;; Page break lines
;;----------------------------------------------------------------------------
;; this turn ^L into nice long lines.
(require-package 'page-break-lines)
(global-page-break-lines-mode)
;; (diminish 'page-break-lines-mode)

;;----------------------------------------------------------------------------
;; Shift lines up and down with M-up and M-down. When paredit is enabled,
;; it will use those keybindings. For this reason, you might prefer to
;; use M-S-up and M-S-down, which will work even in lisp modes.
;;----------------------------------------------------------------------------
(require-package 'move-dup)
(global-set-key [M-up] 'md/move-lines-up)
(global-set-key [M-down] 'md/move-lines-down)
(global-set-key [M-S-up] 'md/move-lines-up)
(global-set-key [M-S-down] 'md/move-lines-down)

(global-set-key (kbd "s-p") 'md/duplicate-down)
(global-set-key (kbd "s-P") 'md/duplicate-up)

;;----------------------------------------------------------------------------
;; Fix backward-up-list to understand quotes, see http://bit.ly/h7mdIL
;;----------------------------------------------------------------------------
(defun backward-up-sexp (arg)
  "Jump up to the start of the ARG'th enclosing sexp."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(global-set-key [remap backward-up-list] 'backward-up-sexp) ; C-M-u, C-M-up



;; This package pops up a buffer, when a key prefix is hit, that shows what keys the user can now hit to use a command.
(require-package 'guide-key)
(setq guide-key/guide-key-sequence '("C-c ," "C-c ."  "C-x" "C-c" "C-c c" "C-x 4" "C-x 5" "C-c ;" "C-c ; f" "C-c ' f" "C-x n" "C-c p" "C-c h"))
(guide-key-mode 1)
(diminish 'guide-key-mode)


(add-hook 'before-save-hook
          '(lambda ()
             (delete-trailing-whitespace)))

(provide 'init-editing-utils)

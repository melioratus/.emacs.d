;; ----------------------------------------------------------------------------
;; Automatic byte compilation
;; ----------------------------------------------------------------------------
(use-package auto-compile
  :ensure t)
(auto-compile-on-save-mode 1)
(auto-compile-on-load-mode 1)

;; ----------------------------------------------------------------------------
;; Load .el if newer than corresponding .elc
;; ----------------------------------------------------------------------------
(setq load-prefer-newer t)

;; ----------------------------------------------------------------------------
;; Enable desired features for all lisp modes
;; ----------------------------------------------------------------------------
;; show different parenthesis in different colors.  For example, the lambda's parenthesis, within a function will have a
;; color than the function's parenthesis.
(use-package rainbow-delimiters
  :ensure t)
(add-hook 'emacs-lisp-mode-hook '(lambda ()
                                   (rainbow-delimiters-mode 1)
                                   (flycheck-mode 1)
                                   ))

;; automatically indent the text after certain commands are pressed!
(when (fboundp 'aggressive-indent-mode)
  (aggressive-indent-mode))

;; show documentation of the current elisp function in the minibuffer as you write it.
;; whoever made this mode is amazing!

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(use-package paredit
  :ensure t)

(defun turn-on-paredit ()
  (paredit-mode +1))
(add-hook 'emacs-lisp-mode-hook 'turn-on-paredit)

(provide 'init-lisp)

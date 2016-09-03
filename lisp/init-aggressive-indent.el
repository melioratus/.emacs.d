(use-package aggressive-indent :ensure t :defer t)
;; it's probably a good idea NOT to enable aggressive indent mode globally.  web-mode has a hard time
;; indenting everything when the file gets big
(dolist (hook '(js2-mode-hook cc-mode css-mode emacs-lisp-mode-hook css-mode))
  (add-hook hook #'aggressive-indent-mode))

(provide 'init-aggressive-indent)

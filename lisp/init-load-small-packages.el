(dolist (hook '(org-mode-hook
                prog-mode-hook
                text-mode-hook))
  (add-hook hook (lambda ()
                   (abbrev-mode 1)
                   (diminish 'abbrev-mode))))

(use-package avy
  :ensure t
  :defer t
  :config
  (setq avybackground t
   avy-highlight-first t)
  ;; https://github.com/abo-abo/avy
  (setq  avy-keys (number-sequence ?e ?t )))

(when (file-exists-p "/home/joshua/programming/emacs/autocorrect/autocorrect.org")
(org-babel-load-file "/home/joshua/programming/emacs/autocorrect/autocorrect.org"))

(use-package which-key :ensure t
  :config (which-key-mode))

(use-package bug-hunter :ensure t :defer t)

(when (not (string-equal system-type "darwin"))
  (require 'ispell)

  (add-hook 'prog-mode-hook (lambda ()
                              (flyspell-prog-mode)
                              (unbind-key (kbd "C-c $") flyspell-mode-map)
                              (global-set-key (kbd "C-c $") #'endless/ispell-word-then-abbrev)))

  ;; enable flyspell mode for all of my text modes.  This will enable flyspell to underline misspelled words.
  (add-hook 'text-mode-hook (lambda ()
                              (flyspell-mode)
                              (unbind-key (kbd "C-c $") flyspell-mode-map)
                              (global-set-key (kbd "C-c $") #'endless/ispell-word-then-abbrev))))

(cond ((string-equal system-type "darwin")
       (setq flyspell-program "hunspell")))

(require 'ispell)

(use-package aggressive-indent :ensure t :defer t)
;; it's probably a good idea NOT to enable aggressive indent mode globally.  web-mode has a hard time
;; indenting everything when the file gets big
(dolist (hook '(js2-mode-hook cc-mode css-mode emacs-lisp-mode-hook css-mode))
  (add-hook hook #'aggressive-indent-mode))

(use-package async
  :ensure t
  :defer t
  :config
  ;; enable async dired commands
  (autoload 'dired-async-mode "dired-async.el" nil t)
  (dired-async-mode 1)
  ;; enable async compilation of melpa packages
  (async-bytecomp-package-mode 1))

(dolist (hook '(
                js2-mode-hook
                css-mode-hook
                php-mode-hook
                web-mode-hook
                emacs-lisp-mode-hook
                ))
              (add-hook hook 'linum-mode))

(dolist (hook '(
                js2-mode-hook
                css-mode-hook
                php-mode-hook
                web-mode-hook
                emacs-lisp-mode-hook
                ))
              (remove-hook hook 'linum-mode))

;; (use-package nlinum :ensure t)

;; let's check for poor writing style
(require 'init-writegood)

(require 'bookmark)
(defhydra hydra-bookmark (:color pink :hint nil)
  "
^Edit^                   ^Jump^                    ^Set^
^^^^^^------------------------------------------------------
_e_: edit bookmarks     _j_ump to bookmark         _s_: set bookmark
_r_: rename             _J_ump to gnus bookmark    _S_: set a gnus bookmark
"
  ;; Edit
  ("e" edit-bookmarks :exit t)                ; Up
  ("r" helm-bookmark-rename :exit t)                ; Up

  ;; Jump
  ("j" bookmark-jump :exit t)          ; Show (expand) everything
  ("J" gnus-bookmark-jump :exit t)          ; Show (expand) everything

  ;; Set
  ("s" bookmark-set :exit t)    ; Hide everything but the top-level headings
  ("S" gnus-bookmark-set :exit t)    ; Hide everything but the top-level headings

  ("z" nil "leave"))

;; I want to set this hydra to a keybinding.  So I don't have to remember all of the keybindings
(global-set-key (kbd "C-c C-b") 'hydra-bookmark/body)
;; a ton of other modes try to set C-c C-b to a keybinding.  I am overriding them.
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-b") 'hydra-bookmark/body))
(with-eval-after-load 'web-mode
  (define-key web-mode-map (kbd "C-c C-b") 'hydra-bookmark/body))
(with-eval-after-load 'php-mode
  (define-key php-mode-map (kbd "C-c C-b") 'hydra-bookmark/body))

(use-package diff-hl
  :defer t
  :ensure t)
(add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)

(use-package f :ensure t)

(cond
 ((string-equal system-name "antelope")
  (setq epg-gpg-program "gpg"))
 ((string-equal system-name "parabola")
  (setq epg-gpg-program "gpg2"))
 ((string-equal system-name "GuixSD")
  (setq epg-gpg-program "gpg")))

(setq epg-gpg-program "gpg")

(when (f-file? "~/.authinfo.gpg")
  ;; only use the encrypted file.
  (setq auth-sources '("~/.authinfo.gpg"))
  ;;(require 'auth-source)
  )

(use-package golden-ratio
  :defer t
  :ensure t
  :config (setq golden-ratio-exclude-modes
                '( "sr-mode" "ediff-mode" "ediff-meta-mode" "ediff-set-merge-mode" "gnus-summary-mode" ))
  :diminish golden-ratio-mode)
(add-hook 'after-init-hook 'golden-ratio-mode)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
   (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(defun my-recentf-startup ()
"My configuration for recentf."
(recentf-mode 1)

(setq recentf-max-saved-items 1000
      recentf-exclude '("/tmp/"
            "^.*autoloads.*$"
            "^.*TAGS.*$"
            "^.*COMMIT.*$"
            "^.*pacnew.*$"
                        ;; in case I ever want to exclude shh files, I can add this next line.
                        ;;  "/ssh:"
            ))

(add-to-list 'recentf-keep "^.*php$//")
(recentf-auto-cleanup))

(add-hook 'after-init-hook 'my-recentf-startup)

(setq-default grep-highlight-matches t
              grep-scroll-output t)

;; ag is the silver searcher.  It lets you search for stuff crazy fast
(when (executable-find "ag")
  (use-package ag
    :defer t
    :ensure t)
  (use-package wgrep-ag
    :defer t
    :ensure t)
  (setq-default ag-highlight-search t))

(setenv "PAGER" "cat")

(add-hook 'eshell-mode-hook (lambda ()
                              (setq
                               shell-aliases-file "~/.emacs.d/alias"
                               )))

(define-key Info-mode-map (kbd "C-w h") 'windmove-down)
(define-key Info-mode-map (kbd "C-w t") 'windmove-up)
(define-key Info-mode-map (kbd "C-w n") 'windmove-left)
(define-key Info-mode-map (kbd "C-w s") 'windmove-right)

;; if major mode is web-mode then use web-mode's comment.
(defun my/smart-comment ()
  "A little wrapper around smart comment.
If (= major-mode 'web-mode) then use web-mode's built in
smart comment."
  (interactive)
  (if (string= major-mode "web-mode")
      (web-mode-comment-or-uncomment)
    (smart-comment t)))

(use-package smart-comment
  :ensure t
  :bind ("C-c ;" . my/smart-comment)
  :config
  (with-eval-after-load 'org
    (local-unset-key "C-c ;")))

(use-package wttrin
  :ensure t
  :commands (wttrin)
  :init
  (setq wttrin-default-cities
  '("West Lafayette")))

(defun weather ()
  "Show the local weather via wttrin"
  (interactive)
  (wttrin))

(add-hook 'after-init-hook 'global-prettify-symbols-mode)

(use-package suggest :ensure t)

(require 'uniquify)

(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator " • ")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

(use-package dired+ :ensure t)

(use-package dired-sort :ensure t)

(use-package dired-details :ensure t
  :config
  (setq-default dired-details-hidden-string "--- "))

(use-package dired
  ;; before loading dired, set these variables
  :init (setq-default diredp-hide-details-initially-flag nil
                      dired-dwim-target t
                      ;;omit boring auto save files in dired views
                      dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$")
  :config ;; after loading dired, do this stuff
  (load "dired-x")
  :bind
  (:map dired-mode-map
        ("/" . helm-swoop)
        ([mouse2] . dired-find-file)))

(with-eval-after-load 'dired
  (add-hook 'dired-mode-hook 'dired-omit-mode))

(use-package yasnippet
  :defer t
  :ensure t)

  (add-to-list 'load-path "~/.emacs.d/snippets")
  (require 'yasnippet)
  (yas-global-mode 1)

(with-eval-after-load 'warnings
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change)))

(use-package company :ensure t
  :config
  (setq company-idle-delay .2)
  (define-key company-active-map "\C-n" #'company-select-next)
  (define-key company-active-map "\C-p" #'company-select-previous))

(add-hook 'after-init-hook 'global-company-mode)

(dolist (hook '(prog-mode-hook
                text-mode-hook
                org-mode-hook))
  (add-hook hook
            (lambda ()
              (set (make-local-variable 'company-backends)
                   '((company-dabbrev-code company-yasnippet))))))

(use-package flycheck-pos-tip :ensure t :defer t)

(use-package flycheck-status-emoji :ensure t)

(use-package flycheck-color-mode-line :ensure t)

(use-package flycheck
  :defer t
  :ensure t
  :config
  (flycheck-color-mode-line-mode)
  (flycheck-pos-tip-mode)
  (flycheck-status-emoji-mode))

(add-hook 'after-init-hook 'global-flycheck-mode)

(use-package lua-mode :ensure t)

(use-package magit :defer t :ensure t)
(require-package 'git-blame)

(after-load 'magit
  (define-key magit-status-mode-map (kbd "C-M-<up>") 'magit-goto-parent-section))

(require-package 'fullframe)
(after-load 'magit (fullframe magit-status magit-mode-quit-window))

(after-load 'magit (diminish 'magit-auto-revert-mode))

(use-package gitignore-mode  :defer t :ensure t)
(use-package gitconfig-mode  :defer t :ensure t)

(use-package git-timemachine :ensure t :defer t)

(setq-default
 magit-save-some-buffers nil
 ;; if a command takes longer than 5 seconds, pop up the process buffer.
 magit-process-popup-time 5
 magit-diff-refine-hunk t)

(use-package rainbow-mode :ensure t)
(dolist (hook '(css-mode-hook html-mode-hook sass-mode-hook))
  (add-hook hook 'rainbow-mode))

(use-package sass-mode :ensure t)
(use-package scss-mode :ensure t)
(setq-default scss-compile-at-save nil)

(use-package less-css-mode :ensure t)
;; I don't think I've ever used skewer-mode.
;; (when (featurep 'js2-mode)
;;   (use-package skewer-less))

(require-package 'css-eldoc)
(autoload 'turn-on-css-eldoc "css-eldoc")
(add-hook 'css-mode-hook 'turn-on-css-eldoc)

(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

(setq password-cache-expiry nil)

(use-package all-the-icons :load-path "~/.emacs.d/lisp/all-the-icons.el/")

(use-package projectile :ensure t)
(use-package helm-projectile :ensure t)

(provide 'init-load-small-packages)
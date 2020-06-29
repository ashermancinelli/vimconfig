;; Package config
(require 'package)
(add-to-list
	'package-archives
	'("melpa" . "http://melpa.org/packages/")
	t)
(package-initialize)

(setq tags-table-list
      '("~/.emacs.d/tags"))

;; Requirements
(require 'use-package)

;; (use-package helm-mode :bind ("C-x C-f" . 'helm-find-files))
(use-package neotree :bind ("C-x T" . 'neotree))
(use-package multiple-cursors
  :bind ("C-c n" . mc/mark-next-like-this)
        ("C-c p" . mc/mark-previous-like-this)
        ("C-c a" . mc/mark-all-like-this))
  
(electric-pair-mode 1)
(rainbow-delimiters-mode 1)

;; Hooks
(with-eval-after-load 'company
  (company-ctags-auto-setup))

(setq company-ctags-extra-tags-files '("$HOME/.emacs.d/tags"))

;; Indentation config
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

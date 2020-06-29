;; Package config
(require 'package)
(add-to-list
	'package-archives
	'("melpa" . "http://melpa.org/packages/")
	t)
(package-initialize)

(setq tags-table-list
  '("~/.emacs.d/tags"))

;; Plugins
(electric-pair-mode 1)

;; Hooks
(with-eval-after-load 'company
  (company-ctags-auto-setup))

(setq company-ctags-extra-tags-files '("$HOME/.vim/tags"))

;; Indentation config
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

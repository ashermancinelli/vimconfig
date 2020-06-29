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
(use-package indent-guide
  :init (indent-guide-global-mode)
  :ensure t)

(use-package highlight-parentheses
  :init
  (highlight-parentheses-mode 1))

(use-package spartparens
  :ensure t)

(use-package smart-tab
  :ensure t
  :init
  (smart-tab-mode 1))

(use-package multiple-cursors
  :bind ("C-c n" . mc/mark-next-like-this)
        ("C-c p" . mc/mark-previous-like-this)
        ("C-c a" . mc/mark-all-like-this)
  :init
  (multiple-cursors-mode 1)
  :ensure t)
  
(electric-pair-mode 1)

(use-package rainbow-delimiters
  :ensure t
  :init
  (rainbow-delimiters-mode 1))

;; Hooks
(with-eval-after-load 'company
  (company-ctags-auto-setup))

(setq company-ctags-extra-tags-files '("$HOME/.emacs.d/tags"))

;; Indentation config
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
    (quote
     (ivy-posframe highlight-parentheses smart-tab smartparens indent-guide use-package rainbow-delimiters multiple-cursors helm-mode-manager))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

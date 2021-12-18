;;general
(setq inhibit-startup-message t)                ;disable default welcome message
(setq make-backup-files nil)                    ;disable backup files
(menu-bar-mode -1)                              ;disable menubar
(global-hl-line-mode)                           ;highlight current line
(electric-pair-mode)                            ;smarter delimeters.
(delete-selection-mode 1)                       ;replace hilighted text when pastings
(defvar explicit-shell-file-name "/bin/bash")   ;ensure emacs uses bash shell
(put 'dired-find-alternate-file 'disabled nil)  ;Has something to do w a hotkey in dired.
(setq-default indent-tabs-mode nil)             ;tabs are spaces
(global-auto-revert-mode t)                     ;automatically refresh files changed on disk
(setq-default tab-width 2)                      ;tab width
(setq-default flycheck-disabled-checkers        ;don't treat this file like an elisp package file
  '(emacs-lisp-checkdoc))
(setq browse-url-browser-function               ;default browser qutebrowser
      'browse-url-generic browse-url-generic-program "qutebrowser")

;;PACKAGE MANAGER
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
;;USE-PACKAGE
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(defvar use-package-always-ensure t)

;;EVIL
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-width 2)
  (evil-mode))

;;EVIL-COLLECTION
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(magit vterm dired ibuffer mu4e))
  (evil-collection-init))

;;EVIL-SURROUND
(use-package evil-surround
  :config (global-evil-surround-mode 1))

;;DOOM-MODELINE:
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;;DOCKER-TRAMP
(use-package docker-tramp)

;;COMPANY: syntax completion
(use-package company
  :init (global-company-mode t))

;;COUNSEL: better nav
(use-package counsel
  :init (counsel-mode t))

;;SMEX: enables M-X history
(use-package smex)

;;SWIPER: better searching
(use-package swiper)

;;FLYCHECK: syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

;;ORG
(use-package org
  :init
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "/home/marc/Dropbox/org"
    org-agenda-files '("/home/marc/Dropbox/org")
    org-log-done 'time
    org-hide-emphasis-markers t
    org-src-tab-acts-natively t
    org-todo-keywords '((sequence "TODO(t)" "MEET(m)" "|" "DONE(d)" "CANCELLED(c)"))))

;;ORG-BULLETS
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;;EVIL-ORG
(use-package evil-org
  :commands evil-org-mode
  :after org
  :init
  (add-hook 'org-mode-hook 'evil-org-mode))
(use-package org-tempo)

;;SYNTAX HIGHLIGHTING
(use-package haskell-mode)
(use-package yaml-mode)
(use-package go-mode)
(use-package rust-mode)
(use-package handlebars-mode
  :init (add-to-list 'auto-mode-alist '("\\.hb?\\'" . handlebars-mode)))
(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-auto-closing t))

;;SPELLCHECK
(use-package flyspell
  :config
  (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist)
  (setq ispell-dictionary "english")
  (setq ispell-local-dictionary-alist
    '(("english" "[[:alpha:]]" "[^[:alpha:]]" "[']" t ("-d" "en_US") nil utf-8))))

;;MAGIT
(use-package magit)

;;XClIP: copy to clipboard
(use-package xclip
  :config (xclip-mode))

;;IBUFFER setup
(defvar ibuffer-expert t)                                 ;;don't ask for confirmation when deleting buffers
(use-package ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "*Messages*") ;;hide *Messages* buffer from vterm
(add-to-list 'ibuffer-never-show-predicates "*Scratch*")  ;;hide *Scratch* buffer from vterm
(add-to-list 'ibuffer-never-show-predicates "\\magit")    ;;hide hide magit buffers

;;VTERM
(use-package vterm
    :init
    (setq shell-file-name "/bin/bash"))
;;MULTI-VTERM: allows for multiple vterm instances.
(use-package multi-vterm)

;;WHITESPACE: remove whitespace on save
(require 'whitespace)
(setq-default show-trailing-whitespace t)
(set-face-attribute 'trailing-whitespace nil :underline t :background "black")
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;RELATIVE LINE NUMBERS
(setq-default display-line-numbers-type 'visual
              display-line-numbers-current-absolute t)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;SMOOTH SCROLLING
(setq scroll-margin 15
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;ALACRITTY FIXES
(add-to-list 'term-file-aliases '("alacritty" . "xterm")) ;;make emacs-nox fully featured in alacritty
(setq xterm-extra-capabilities nil)                       ;;fixes slow startup from above command

;; ;;WICH-KEY
(use-package which-key
  :config (which-key-mode))

(load-file (expand-file-name "mu4e.el" user-emacs-directory))
(load-file (expand-file-name "keybindings.el" user-emacs-directory))
(load-file (expand-file-name "theme.el" user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(htmlize org-bullets smex swiper-helm yaml-mode xclip which-key web-mode use-package rust-mode org multi-vterm magit haskell-mode handlebars-mode go-mode general flycheck evil-surround evil-org evil-collection doom-modeline docker-tramp counsel company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;general
(setq inhibit-startup-message t)                ;disable default welcome message
(setq make-backup-files nil)                    ;disable backup files
(menu-bar-mode -1)                              ;disable menubar
(tool-bar-mode -1)                              ;disable tool bar
(setq default-frame-alist '((background-color . "#121212")))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(global-hl-line-mode)                           ;highlight current line
(electric-pair-mode)                            ;smarter delimeters.
(delete-selection-mode 1)                       ;replace hilighted text when pastings
(setq explicit-shell-file-name "/bin/bash")   ;ensure emacs uses bash shell
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
(setq use-package-always-ensure t)

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

;;DOOM-THEME
(use-package doom-themes
  :config
  (load-theme 'doom-acario-dark t)
  (set-face-attribute 'default nil :height 195 :weight 'bold)
  (set-face-attribute 'hl-line nil :background "#3e4446"))

;;DOOM-MODELINE:
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config (set-face-attribute 'mode-line nil :height 160))

;;COMPANY: syntax completion
(use-package company
  :init (global-company-mode t))
;;FLYCHECK: syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

;;end

;;DOCKER-TRAMP
(use-package docker-tramp)

;;COUNSEL: better nav
(use-package counsel
  :init (counsel-mode t))

;;SMEX: enables M-X history
(use-package smex)

;;SWIPER: better searching
(use-package swiper)

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
  :init (add-hook 'org-mode-hook 'evil-org-mode))
(use-package org-tempo)

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
(setq ibuffer-expert t)                                 ;;don't ask for confirmation when deleting buffers
(setq ibuffer-saved-filter-groups
          (quote (("main"
                   ("other" (or
                             (name . "^\\*scratch\\*$")
                             (name . "^\\*Messages\\*$")
                             (mode . dired-mode)
                             (name . "^\\magit")
                             (name . "^\\*Compile")
                             (name . "^\\*Flycheck")
                             (name . "^\\*lsp")
                             (name . "^\\*pyright")
                             (name . "^\\*rust")
                             (name . "^\\*run")
                             (name . "^\\*Completions")
                             (name . "^\\*Backtrace")
                             (name . "^\\*Python")
                             (name . "^\\*Shell")))))))
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "main")))

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

;;SMOOTH SCROLLING
(setq scroll-margin 5
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;ALACRITTY FIXES
(add-to-list 'term-file-aliases '("alacritty" . "xterm")) ;;make emacs-nox fully featured in alacritty
(setq xterm-extra-capabilities nil)                       ;;fixes slow startup from above command

;; ;;WICH-KEY
(use-package which-key
  :config (which-key-mode))

;;LOAD FILES
(load-file (expand-file-name "mu4e.el" user-emacs-directory))
(load-file (expand-file-name "keybindings.el" user-emacs-directory))
(load-file (expand-file-name "lsp.el" user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ibuf-ext rustic mu4e-alert lsp-pyright python-mode dap-mode lsp-ivy lsp-ui lsp-mode htmlize org-bullets smex swiper-helm yaml-mode xclip which-key web-mode use-package rust-mode org multi-vterm magit haskell-mode handlebars-mode go-mode general flycheck evil-surround evil-org evil-collection doom-modeline docker-tramp counsel company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

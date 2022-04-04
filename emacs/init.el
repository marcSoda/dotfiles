;;general
(setq inhibit-startup-message t)                ;disable default welcome message
(menu-bar-mode -1)                              ;disable menubar
(tool-bar-mode -1)                              ;disable tool bar
(scroll-bar-mode -1)                            ;disable scroll bar
(global-hl-line-mode)                           ;highlight current line
(setq make-backup-files nil)                    ;disable backup files
(electric-pair-mode)                            ;smarter delimeters.
(delete-selection-mode 1)                       ;replace hilighted text when pasting
(setq explicit-shell-file-name "/bin/fish")     ;ensure emacs uses fish shell
(setq vterm-shell "/bin/fish")                  ;ensure vterm uses fish shell
(setq make-backup-files nil)                    ;disable backup files
(put 'dired-find-alternate-file 'disabled nil)  ;has something to do w a hotkey in dired.
(setq-default indent-tabs-mode nil)             ;tabs are spaces
(setq dired-listing-switches "-aBhl  --group-directories-first") ;dired group directories
(global-auto-revert-mode t)                     ;automatically refresh files changed on disk
(setq-default tab-width 4)                      ;tab width
(setq auto-save-default nil)                    ;disable autosave
(setq vc-follow-symlinks t)                     ;open file where symlink points
(setq bookmark-save-flag 1)                     ;bookmarks save automatically
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
  (evil-mode))

;;EVIL-COLLECTION
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(magit dashboard vterm dired ibuffer mu4e))
  (evil-collection-init))

;;EVIL-SURROUND
(use-package evil-surround
  :config (global-evil-surround-mode 1))

;;dashboard
(use-package dashboard
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-startup-banner 2)
  (setq dashboard-center-content t)
  (setq dashboard-footer-messages nil)
  (setq dashboard-set-init-info nil)
  (setq dashboard-items '((projects  . 5)
			              (bookmarks . 5)
                          (recents   . 5)))
  (setq initial-buffer-choice (lambda () ;refresh and display dashboard buffer on emacsclient open
      (ignore-errors (org-agenda-exit))  ;close auto-opened org-agenda buffers
      (get-buffer "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

;;THEME
(use-package humanoid-themes
  :init (load-theme 'humanoid-dark t)
  :config (set-face-attribute 'default nil :height 175 :weight 'bold))

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

;;DOCKER-TRAMP
(use-package docker-tramp)

;;COUNSEL: better nav
(use-package counsel
  :init (counsel-mode t))

;;ivy
(use-package ivy
  :init (ivy-mode t))

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
    org-capture-bookmark nil
    org-todo-keywords '((sequence "TODO(t)" "MEET(m)" "|" "DONE(d)" "CANCELLED(c)"))))

;;ORG-BULLETS
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;;ORG-ROAM
(use-package org-roam
    :custom
    (org-roam-directory "~/working/org/roam")
    (org-roam-completion-everywhere t)
    :config
    (org-roam-setup)
    (setq epa-file-encrypt-to '("m@soda.fm"))                    ;;use the gpg key for m@soda.fm by default
    (setq epa-file-select-keys 1)                                ;;don't prompt which key to use
    (setq org-roam-capture-templates '(("d" "default" plain "%?" ;;encrypt all org roam files
        :target (file+head "${slug}.org.gpg"
                            "#+title: ${title}\n")
        :unnarrowed t)))

    (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
            "* %?"
            :target (file+head "%<%Y-%m-%d>.org.gpg"
                                "#+title: %<%Y-%m-%d>\n"))))


    )


;;EVIL-ORG
(use-package evil-org
  :commands evil-org-mode
  :after org
  :init (add-hook 'org-mode-hook 'evil-org-mode))
(use-package org-tempo)

;;SPELLCHECK NOTE: to install the dictionary: pacman -S hunspell-en_us
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
(use-package ibuffer)
(use-package ibuf-ext)
(setq ibuffer-expert t)    ;;don't ask for confirmation when deleting buffers
(setq ibuffer-saved-filter-groups
          (quote (("main"
                   ("other" (or
                             (name . "^\\*scratch\\*$")
                             (name . "^\\*Messages\\*$")
                             (name . "^\\*dashboard\\*$")
                             (mode . dired-mode)
                             (name . "^\\*Help*")
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
                             (name . "^\\*clang")
                             (name . "^\\*tramp")
                             (name . "^\\*Shell")))))))
(add-hook 'ibuffer-mode-hook
    '(lambda () (ibuffer-switch-to-saved-filter-groups "main")))

;;RAINBOW-DELIMITERS
(use-package rainbow-delimiters
    :init (progn (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

;;PROJECTILE
(use-package projectile
    :diminish projectile-mode
    :config
    (projectile-mode)
    (setq projectile-track-known-projects-automatically nil)
    :custom ((projectile-completion-system 'ivy))
    :init
    (when (file-directory-p "~/working/dev")
      (setq projectile-project-search-path '("~/working/dev")))
    (setq projectile-switch-project-action #'projectile-dired))
(use-package counsel-projectile
  :config (counsel-projectile-mode))

;;VTERM
(use-package vterm
    :init
    (setq shell-file-name "/bin/bash"))
;;MULTI-VTERM: allows for multiple vterm instances. unused as of 3/1/22
;; (use-package multi-vterm)

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

;;WICH-KEY
(use-package which-key :config (which-key-mode))

;;yasnippet ;;MAYBE REMOVE
(use-package yasnippet)

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
   '(org-roam counsel-projectile dashboard rainbow-delimiters humanoid-themes org-latex-impatient org-evil ccls yasnippet ibuf-ext rustic mu4e-alert lsp-pyright python-mode dap-mode lsp-ivy lsp-ui lsp-mode htmlize org-bullets smex swiper-helm yaml-mode xclip which-key web-mode use-package rust-mode org multi-vterm magit haskell-mode handlebars-mode go-mode general flycheck evil-surround evil-org evil-collection doom-modeline docker-tramp counsel company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;general

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq inhibit-startup-message t)                ;disable default welcome message
(menu-bar-mode -1)                              ;disable menubar
(tool-bar-mode -1)                              ;disable tool bar
(scroll-bar-mode -1)                            ;disable scroll bar
(global-hl-line-mode)                           ;highlight current line
;; (set-face-background hl-line-face "grey" )
(setq make-backup-files nil)                    ;disable backup files
(electric-pair-mode)                            ;smarter delimeters.
(delete-selection-mode 1)                       ;replace hilighted text when pasting
(setq make-backup-files nil)                    ;disable backup files
(put 'dired-find-alternate-file 'disabled nil)  ;has something to do w a hotkey in dired.
(setq-default indent-tabs-mode nil)             ;tabs are spaces
(setq dired-listing-switches "-aBhl  --group-directories-first") ;dired group directories
(global-auto-revert-mode t)                     ;automatically refresh files changed on disk
(setq-default tab-width 4)                      ;tab width
(setq auto-save-default nil)                    ;disable autosave
(setq vc-follow-symlinks t)                     ;open file where symlink points
(setq bookmark-save-flag 1)                     ;bookmarks save automatically

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
  (setq evil-collection-mode-list '(magit vterm dired ibuffer mu4e))
  (evil-collection-init))

;;EVIL-SURROUND
(use-package evil-surround
  :config (global-evil-surround-mode 1))

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

;;SYNTAX
(use-package rustic)
(use-package python-mode)
(use-package go-mode)
(use-package haskell-mode)
(use-package yaml-mode)
(use-package handlebars-mode
	       :init (add-to-list 'auto-mode-alist '("\\.hb?\\'" . handlebars-mode)))
(use-package web-mode
	       :init
	         (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
		   (setq web-mode-enable-auto-closing t))


;;MAGIT
(use-package magit)

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
(load-file (expand-file-name "keybindings.el" user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yasnippet yaml-mode xclip which-key web-mode use-package smex rustic rainbow-delimiters python-mode magit humanoid-themes haskell-mode handlebars-mode go-mode general flycheck evil-surround evil-collection doom-modeline dashboard counsel company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

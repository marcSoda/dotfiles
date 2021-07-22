;;general
(setq inhibit-startup-message t)                ;disable default welcome message
(setq make-backup-files nil)                    ;disable backup files
(menu-bar-mode -1)                              ;disable menubar
(global-hl-line-mode)                           ;highlight current line
(electric-pair-mode)                            ;smarter delimeters.
(delete-selection-mode 1)                       ;replace hilighted text when pastings
(setq explicit-shell-file-name "/bin/bash")     ;ensure emacs uses bash shell
(put 'dired-find-alternate-file 'disabled nil)  ;Has something to do w a hotkey in dired.
(setq-default indent-tabs-mode nil)             ;tabs are spaces
(global-auto-revert-mode t)                     ;automatically refresh files changed on disk

;;package: setup package manager
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
;;setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;;evil
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode))
;;evil-collection
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(magit vterm dashboard dired ibuffer))
  (evil-collection-init))
;;evil surround mode
(use-package evil-surround
  :config (global-evil-surround-mode 1))

;;dashboard
(use-package dashboard
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-items '((agenda . 20 )))
  (setq initial-buffer-choice (lambda () ;refresh and display dashboard buffer on emacsclient open
      (dashboard-refresh-buffer)
      (ignore-errors (org-agenda-exit))  ;close auto-opened org-agenda buffers
      (get-buffer "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

;;general: for keybindings
(use-package general
  :after evil
  :config
  (general-evil-setup t))

;;org
(use-package org
  :init
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "~/working/sync/org"
      org-agenda-files '("~/working/sync/org")
      org-log-done 'time
      org-hide-emphasis-markers t)
  (setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)
  (setq org-todo-keywords '((sequence "TODO(t)" "MEET(m)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-blank-before-new-entry (quote ((heading . nil)))))

;;org-bullets
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))
;;evil-org
(use-package evil-org
  :commands evil-org-mode
  :after org
  :init
  (add-hook 'org-mode-hook 'evil-org-mode)
  :config
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading)))

;;syntax-highlighting
(use-package haskell-mode)
(use-package yaml-mode)
(use-package go-mode)
(use-package handlebars-mode
  :init (add-to-list 'auto-mode-alist '("\\.hb?\\'" . handlebars-mode)))
(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-auto-closing t))

;;magit
(use-package magit)

;;xclip: copy to clipboard
(use-package xclip
  :config (xclip-mode))

;;ibuffer setup
(setq ibuffer-expert t)                                  ;;don't ask for confirmation when deleting buffers
(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")      ;;hide buffers with asterisks (emacs buffers)
(add-to-list 'ibuffer-never-show-predicates "\\magit")   ;;hide hide magit buffers
;; ;; (setq ibuffer-saved-filter-groups                                         ;;define a filter group
;;       '(("default"                                                        ;;default is the name of the filter group
;;          ("Org" (or (mode . org-mode) (filename . "OrgMode"))))))
;; (add-hook 'ibuffer-mode-hook
;;     (lambda ()
;;         (ibuffer-auto-mode 1)
;;         (ibuffer-switch-to-saved-filter-groups "default")))

;;keybindings
(general-define-key
    :states 'normal
    :keymaps 'override
    :prefix "SPC"
    "" nil
    "SPC"   '(execute-extended-command :which-key "M-x")
    "t t"   '(toggle-truncate-lines    :which-key "Toggle truncate lines")
    "v v"   '(vterm                    :which-key "vterm")
    "w w"   '(save-buffer              :which-key "Save buffer")
    "z"     '(suspend-frame            :which-key "Suspend frame")
    ;;org
    "o *"   '(org-ctrl-c-star          :which-key "Org-ctrl-c-star")
    "o +"   '(org-ctrl-c-minus         :which-key "Org-ctrl-c-minus")
    "o ."   '(counsel-org-goto         :which-key "Counsel org goto")
    "o e"   '(org-html-export-to-html  :which-key "Org export to html")
    "o h"   '(org-toggle-heading       :which-key "Org toggle heading")
    "o i"   '(org-toggle-item          :which-key "Org toggle item")
    "o n"   '(org-store-link           :which-key "Org store link")
    "o o"   '(org-set-property         :which-key "Org set property")
    "o x"   '(org-toggle-checkbox      :which-key "Org toggle checkbox")
    "o B"   '(org-babel-tangle         :which-key "Org babel tangle")
    "o T"   '(org-todo                 :which-key "Org todo")
    "o t"   '(org-todo-list            :which-key "Org todo list")
    "o a"   '(org-agenda               :which-key "Org agenda")
    "o d"   '(org-deadline             :which-key "Org deadline")
    "o o"   '(org-agenda-exit          :which-key "org-agenda-exit")
    ;;Ibuffer-related
    "b b"   '(ibuffer                  :which-key "Ibuffer")
    "b k"   '(kill-current-buffer      :which-key "Kill current buffer")
    ;;Magit-related
    "m g"   '(magit-status             :which-key "magit")
    "m c"   '(with-editor-finish       :which-key "with-editor-finish")
    "m k"   '(with-editor-cancel       :which-key "with-editor-cancel")
    ;;Window-related
    "w c"   '(evil-window-delete       :which-key "Close window")
    "w o"   '(delete-other-windows     :which-key "Make window fill frame")
    "w s"   '(evil-window-split        :which-key "Horizontal split window")
    "w v"   '(evil-window-vsplit       :which-key "Vertical split window")
    "w h"   '(evil-window-left         :which-key "Window left")
    "w j"   '(evil-window-down         :which-key "Window down")
    "w k"   '(evil-window-up           :which-key "Window up")
    "w l"   '(evil-window-right        :which-key "Window right")
    ;;describe
    "d k"   '(describe-key             :which-key "Describe Key")
    "d f"   '(where-is                 :which-key "Describe Function")
    ;;file-related
    "f f"   '(find-file                :which-key "Find file")
    "f r"   '(counsel-recentf          :which-key "Recent files"))
(define-key evil-normal-state-map (kbd "M-;") 'comment-line)  ;; M-; in normal mode to comment a line

;;theme
(defvar my-white    "#ffffff")
(defvar my-black    "#000000")
(defvar my-red      "#ff0000")
(defvar my-cyan     "#0087d7")
(defvar my-green    "#03fc94")
(defvar my-purple   "#cd75ff")
(defvar my-orange   "#ffa500")
(defvar my-pink     "#ff7efd")
(defvar my-yellow   "#f4ff5c")
(defvar my-brown    "#af5f00")
(defvar my-grey     "#8f8c8c")
(defvar my-darkgrey "#3e4446")
;general
(set-face-attribute 'default nil                      :foreground my-white)
(set-face-attribute 'font-lock-comment-face nil       :foreground my-grey)
(set-face-attribute 'font-lock-string-face nil        :foreground my-red)
(set-face-attribute 'font-lock-constant-face nil      :foreground my-yellow)
(set-face-attribute 'font-lock-keyword-face nil       :foreground my-green)
(set-face-attribute 'font-lock-builtin-face nil       :foreground my-purple)
(set-face-attribute 'font-lock-type-face nil          :foreground my-orange)
(set-face-attribute 'line-number nil                  :foreground my-white)
(set-face-attribute 'font-lock-function-name-face nil :foreground my-pink  :weight 'bold)
(set-face-attribute 'font-lock-variable-name-face nil :foreground my-cyan  :weight 'bold)
(set-face-attribute 'mode-line nil                    :foreground my-white :background my-darkgrey)
(set-face-attribute 'mode-line-inactive nil                                :background my-grey)
(set-face-attribute 'hl-line nil                                           :background my-darkgrey)
;magit
(set-face-attribute 'magit-section-heading nil    :foreground my-cyan)
(set-face-attribute 'magit-branch-remote nil      :foreground my-green)
(set-face-attribute 'magit-branch-remote-head nil :foreground my-green)
(set-face-attribute 'magit-branch-current nil     :foreground my-red)
(set-face-attribute 'magit-branch-local nil       :foreground my-red)
;org
(set-face-attribute 'org-level-1 nil         :foreground my-purple)
(set-face-attribute 'org-level-2 nil         :foreground my-cyan)
(set-face-attribute 'org-level-3 nil         :foreground my-green)
(set-face-attribute 'org-level-4 nil         :foreground my-red)
(set-face-attribute 'org-level-5 nil         :foreground my-pink)
(set-face-attribute 'org-level-6 nil         :foreground my-grey)
(set-face-attribute 'org-level-7 nil         :foreground my-yellow)
(set-face-attribute 'org-level-8 nil         :foreground my-brown)
(set-face-attribute 'org-done nil            :foreground my-green)
(set-face-attribute 'org-todo nil            :foreground my-red)
(set-face-attribute 'org-priority nil        :foreground my-cyan)
(set-face-attribute 'org-special-keyword nil :foreground my-grey)
(set-face-attribute 'org-headline-done nil   :foreground my-green)

;;relative line numbers
(setq-default display-line-numbers-type 'visual
              display-line-numbers-current-absolute t)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;vterm
(use-package vterm
    :init
    (setq shell-file-name "/bin/bash"))

;; whitespace: remove whitespace on save
(require 'whitespace)
(setq-default show-trailing-whitespace t)
(set-face-attribute 'trailing-whitespace nil :underline t :background "black")
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;smooth scrolling
(setq redisplay-dont-pause t
  scroll-margin 15
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;alacritty fixes
(add-to-list 'term-file-aliases '("alacritty" . "xterm")) ;;make emacs-nox fully featured in alacritty
(setq xterm-extra-capabilities nil)                       ;;fixes slow startup from above command

(use-package which-key
  :config
  (which-key-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rainbow-mode vterm which-key xclip magit web-mode handlebars-mode go-mode yaml-mode haskell-mode evil-org org-bullets org general dashboard evil-surround evil-collection evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

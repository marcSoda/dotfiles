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
(setq browse-url-browser-function 'browse-url-generic ;default browser
      browse-url-generic-program "qutebrowser")

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
  (setq evil-collection-mode-list '(magit vterm dashboard dired ibuffer mu4e))
  (evil-collection-init))
;;EVIL-SURROUND
(use-package evil-surround
  :config (global-evil-surround-mode 1))

;;DASHBOARD
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

;;GENERAL: for keybindings
(use-package general
  :after evil
  :config
  (general-evil-setup t))

;;ORG
(use-package org
  :init
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "~/working/sync/org"
    org-agenda-files '("~/working/sync/org")
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
  (add-hook 'org-mode-hook 'evil-org-mode)
  :config
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading)))
(use-package org-tempo)

;;SYNTAX HIGHLIGHTING
(use-package haskell-mode)
(use-package yaml-mode)
(use-package go-mode)
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
(setq ibuffer-expert t)                                  ;;don't ask for confirmation when deleting buffers
(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")      ;;hide buffers with asterisks (emacs buffers)
(add-to-list 'ibuffer-never-show-predicates "\\magit")   ;;hide hide magit buffers

;;MU4e
(use-package mu4e
  :ensure nil
  :config
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-get-mail-command "mbsync -c ~/.config/mu4e/mbsyncrc -a")
  (setq mu4e-maildir "~/.mail")
  (setq mu4e-compose-complete-only-personal nil)
  (setq mu4e-attachment-dir "~/working/downloads")
  (setq mu4e-headers-skip-duplicates t)
  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy 'always-ask)
  (add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)
  (setq message-send-mail-function 'smtpmail-send-it
	smtpmail-auth-credentials "~/.authinfo.gpg"
	smtpmail-smtp-server "127.0.0.1"
        smtpmail-stream-type 'starttls
	smtpmail-smtp-service 1025)

  (setq mu4e-contexts
        (list
         ;; gmail account
            (make-mu4e-context
                :name "gmail"
                :match-func
                    (lambda (msg)
                    (when msg
                        (string-prefix-p "/msoda412-gmail" (mu4e-message-field msg :maildir))))
                :vars '((user-mail-address . "m.soda412@gmail.com")
                        (user-full-name    . "Marc Soda Jr.")
                        (mu4e-drafts-folder  . "/msoda412-gmail/drafts")
                        (mu4e-sent-folder  . "/msoda412-gmail/sent")
                        (mu4e-refile-folder  . "/msoda412-gmail/all")
                        (mu4e-trash-folder  . "/msoda412-gmail/trash")

                        (message-send-mail-function . smtpmail-send-it)
                        (starttls-use-gnutls . t)
                        (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                        (smtpmail-auth-credentials . "~/.authinfo.gpg")
                        (smtpmail-default-smtp-server . "smtp.gmail.com")
                        (smtpmail-smtp-server ."smtp.gmail.com")
                        (smtpmail-smtp-service . 587)))
         ;; lehigh account
            (make-mu4e-context
                :name "lehigh"
                :match-func
                    (lambda (msg)
                    (when msg
                        (string-prefix-p "/masa20-lehigh" (mu4e-message-field msg :maildir))))
                :vars '((user-mail-address . "masa20@lehigh.edu")
                        (user-full-name    . "Marc Soda Jr.")
                        (mu4e-drafts-folder  . "/masa20-lehigh/drafts")
                        (mu4e-sent-folder  . "/masa20-lehigh/sent")
                        (mu4e-refile-folder  . "/masa20-lehigh/all")
                        (mu4e-trash-folder  . "/masa20-lehigh/trash")

                        (message-send-mail-function . smtpmail-send-it)
                        (starttls-use-gnutls . t)
                        (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                        (smtpmail-auth-credentials . "~/.authinfo.gpg")
                        (smtpmail-default-smtp-server . "smtp.gmail.com")
                        (smtpmail-smtp-server ."smtp.gmail.com")
                        (smtpmail-smtp-service . 587)))
            ;protonmail
            (make-mu4e-context
                :name "protonmail"
                :match-func
                    (lambda (msg)
                    (when msg
                        (string-prefix-p "/m-soda-protonmail" (mu4e-message-field msg :maildir))))
                :vars '((user-mail-address . "m@soda.fm")
                        (user-full-name    . "Marc Soda Jr.")
                        (mu4e-drafts-folder  . "/m-soda-protonmail/drafts")
                        (mu4e-sent-folder  . "/m-soda-protonmail/sent")
                        (mu4e-refile-folder  . "/m-soda-protonmail/all")
                        (mu4e-trash-folder  . "/m-soda-protonmail/trash")

                        (message-send-mail-function . smtpmail-send-it)
                        (smtpmail-auth-credentials . "~/.authinfo.gpg")
                        (smtpmail-smtp-server . "127.0.0.1")
                        (smtpmail-stream-type . starttls)
                        (smtpmail-smtp-service . 1025))))))

;;VTERM
(use-package vterm
    :init
    (setq shell-file-name "/bin/bash"))

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
(setq redisplay-dont-pause t
  scroll-margin 15
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;ALACRITTY FIXES
(add-to-list 'term-file-aliases '("alacritty" . "xterm")) ;;make emacs-nox fully featured in alacritty
(setq xterm-extra-capabilities nil)                       ;;fixes slow startup from above command

;; ;;WICH-KEY
;; (use-package which-key
;;   :config
;;   (which-key-mode))

;;KEYBINDINGS
(general-define-key
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC"
    "" nil
    "SPC"   '(execute-extended-command   :which-key "M-x")
    "t t"   '(toggle-truncate-lines      :which-key "Toggle truncate lines")
    "v v"   '(vterm                      :which-key "vterm")
    "w w"   '(save-buffer                :which-key "Save buffer")
    "c l"   '(comment-line               :which-key "Comment-line")
    "i s"   '(ispell                     :which-key "ispell")
    "f f"   '(find-file                  :which-key "Find file")
    "e e"   '(eval-last-sexp             :which-key "Eval lisp")
    "z"     '(suspend-frame              :which-key "Suspend frame")
    "q"     '(save-buffers-kill-terminal :which-key "Quit")
    ;;org
    "o *"   '(org-ctrl-c-star                      :which-key "Org-ctrl-c-star")
    "o +"   '(org-ctrl-c-minus                     :which-key "Org-ctrl-c-minus")
    "o ."   '(counsel-org-goto                     :which-key "Counsel org goto")
    "o e"   '(org-html-export-to-html              :which-key "Org export to html")
    "o h"   '(org-toggle-heading                   :which-key "Org toggle heading")
    "o i"   '(org-toggle-item                      :which-key "Org toggle item")
    "o n"   '(org-store-link                       :which-key "Org store link")
    "o o"   '(org-set-property                     :which-key "Org set property")
    "o x"   '(org-toggle-checkbox                  :which-key "Org toggle checkbox")
    "o B"   '(org-babel-tangle                     :which-key "Org babel tangle")
    "o t t" '(org-set-tags-command                 :which-key "Org set tags")
    "o t c" '(org-table-toggle-coordinate-overlays :which-key "Org Table toggle coordinates")
    "o t a" '(org-table-align                      :which-key "Org table align")
    "o t s" '(org-time-stamp                       :which-key "Org time stamp")
    "o a"   '(org-agenda                           :which-key "Org agenda")
    "o d"   '(org-deadline                         :which-key "Org deadline")
    "o c"   '(org-ctrl-c-ctrl-c                    :which-key "Org ctrl-c-ctrl-c")
    ;;Ibuffer-related
    "b b"   '(ibuffer                  :which-key "Ibuffer")
    "b k"   '(kill-current-buffer      :which-key "Kill current buffer")
    ;;Magit-related
    "m g"   '(magit-status             :which-key "magit")
    "m c"   '(with-editor-finish       :which-key "with-editor-finish")
    "m k"   '(with-editor-cancel       :which-key "with-editor-cancel")
    ;;mu4e
    "m u"   '(mu4e                     :which-key "mu4e")
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
    "d v"   '(describe-variable        :which-key "Describe Variable"))

;MU4E KEYBINDINGS
(general-define-key
    :states 'normal
    :keymaps '(mu4e-main-mode-map mu4e-headers-mode-map mu4e-view-mode-map mu4e-compose-mode-map)
    :prefix "SPC"
    "" nil
    "p i" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/m-soda-protonmail/inbox"))   :which-key "Protonmail Inbox")
    "p a" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/m-soda-protonmail/all"))     :which-key "Protonmail All Mail")
    "p s" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/m-soda-protonmail/sent"))    :which-key "Protonmail Sent")
    "p d" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/m-soda-protonmail/drafts"))  :which-key "Protonmail Drafts")
    "p f" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/m-soda-protonmail/starred")) :which-key "Protonmail Starred")
    "p t" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/m-soda-protonmail/trash"))   :which-key "Protonmail Trash")
    "l i" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/masa20-lehigh/inbox"))   :which-key "Lehigh Inbox")
    "l a" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/masa20-lehigh/all"))     :which-key "Lehigh All")
    "l s" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/masa20-lehigh/sent"))    :which-key "Lehigh Sent")
    "l d" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/masa20-lehigh/drafts"))  :which-key "Lehigh Drafts")
    "l f" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/masa20-lehigh/starred")) :which-key "Lehigh Starred")
    "l t" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/masa20-lehigh/trash"))   :which-key "Lehigh Trash")
    "g i" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/msoda412-gmail/inbox"))   :which-key "Gmail Inbox")
    "g a" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/msoda412-gmail/all"))     :which-key "Gmail All Mail")
    "g s" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/msoda412-gmail/sent"))    :which-key "Gmail Sent")
    "g d" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/msoda412-gmail/drafts"))  :which-key "Gmail Drafts")
    "g f" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/msoda412-gmail/starred")) :which-key "Gmail Starred")
    "g t" '((lambda() (interactive) (mu4e~headers-jump-to-maildir "/msoda412-gmail/trash"))   :which-key "Gmail Trash"))
(define-key mu4e-view-mode-map (kbd "M-j") 'mu4e-view-headers-next)
(define-key mu4e-view-mode-map (kbd "M-k") 'mu4e-view-headers-prev)

;;THEME
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
(set-face-attribute 'line-number nil                  :foreground my-cyan  :weight 'bold)
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
;mu4e
(set-face-attribute 'mu4e-title-face nil   :foreground my-cyan :weight 'bold)
(set-face-attribute 'mu4e-header-title-face nil   :foreground my-red)
(set-face-attribute 'mu4e-header-value-face nil   :foreground my-red)
(set-face-attribute 'mu4e-header-key-face nil   :foreground my-green)
(set-face-attribute 'mu4e-replied-face nil   :foreground my-purple)
(set-face-attribute 'mu4e-flagged-face nil   :foreground my-cyan)

;; NAME
(setq user-full-name "Marc Soda"
      user-mail-address "m@soda.fm")

;; MISC
(advice-remove 'evil-open-below #'+evil--insert-newline-below-and-respect-comments-a)
(advice-remove 'evil-open-above #'+evil--insert-newline-above-and-respect-comments-a)

;; FONT
(setq doom-font (font-spec :family "Iosevka" :size 25)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 25)
      doom-big-font (font-spec :family "Iosevka" :size 30))

;;IBUFFER
(after! ibuffer
    (setq ibuffer-expert t))    ;;don't ask for confirmation when deleting buffers
    (setq ibuffer-saved-filter-groups
            (quote (("Default"
                    ("other" (or
                                (name . "^\\*doom\\*$")
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
                                (name . "^\\*gopls")
                                (name . "^\\*httpd*")
                                (name . "^\\*jdtls*")
                                (name . "^\\*Shell")))))))
    (add-hook 'ibuffer-mode-hook
        #'(lambda ()
            (ibuffer-switch-to-saved-filter-groups "Default")
            (setq ibuffer-hidden-filter-groups (list "other"))))

;;LINE NUMBERS
(setq display-line-numbers-type 'nil)

;;RAND-THEME
(after! rand-theme
    (setq rand-theme-wanted '(doom-henna doom-xcode doom-monokai-classic doom-1337)))
    (rand-theme) ;;for some reason, this does not work when I put it in the block

;;ORG
(after! org
  :init
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "/home/marc/Dropbox/org"
    org-agenda-files '("/home/marc/Dropbox/org")
    org-agenda-window-setup 'only-window
    org-hide-emphasis-markers t
    org-src-tab-acts-natively t
    org-capture-bookmark nil
    org-todo-keywords '((sequence "URG(u)" "PROG(p)" "TODO(t)" "MEET(m)" "NEXT(n)" "DATE(D)" "|" "DONE(d)"))))

;;ORG-ROAM
(setq org-roam-directory "~/working/org/roam")
(setq org-roam-completion-everywhere t)
(org-roam-db-autosync-enable)
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

;; ORG-ROAM-UI
(after! org-roam-ui
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow nil
          org-roam-ui-update-on-save t))

;;TREEMACS
(after! treemacs
    (setq treemacs-width 25)
    (setq treemacs-find-workspace-method 'find-for-file-or-manually-select)
    (setq treemacs-is-never-other-window t))

;;SMOOTH SCROLLING
(setq scroll-margin 10
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;WHITESPACE: show whitespace and remove it on save
(after! whitespace
    (setq-default show-trailing-whitespace t)
    (set-face-attribute 'trailing-whitespace nil :underline t :background "black")
    (add-hook 'before-save-hook 'delete-trailing-whitespace))

;;LSP
(add-hook 'c++-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'lsp-deferred)

;;KEYBINDINGS
(define-key evil-normal-state-map (kbd "/") 'swiper)
(define-key evil-normal-state-map (kbd "J") 'evil-forward-paragraph)
(define-key evil-normal-state-map (kbd "K") 'evil-backward-paragraph)
(define-key minibuffer-mode-map   (kbd "M-j") 'next-line)
(define-key minibuffer-mode-map   (kbd "M-k") 'previous-line)
(after! org-agenda
    (define-key org-agenda-mode-map   (kbd "q") 'org-agenda-exit))
(after! ibuffer
    (define-key ibuffer-mode-map (kbd "<tab>") 'ibuffer-toggle-filter-group))
(after! ivy
    (define-key ivy-minibuffer-map (kbd "<escape>") 'keyboard-escape-quit)
    (define-key ivy-minibuffer-map (kbd "M-j") 'ivy-next-line)
    (define-key ivy-minibuffer-map (kbd "M-k") 'ivy-previous-line))
(after! company
    (define-key company-active-map (kbd "M-j") #'company-select-next)
    (define-key company-active-map (kbd "M-k") #'company-select-previous)
    (define-key company-active-map (kbd "<tab>") #'company-complete-selection))
(after! yasnippet
    (define-key evil-insert-state-map (kbd "<tab>") nil)
    (define-key evil-insert-state-map (kbd "TAB") nil)
    (define-key evil-insert-state-map (kbd "<M-tab>") 'yas-expand))

(map! :leader
    :desc "cmd"     "SPC" #'execute-extended-command
    :desc "comment" "/"   #'comment-line
    (:prefix ("b". "buffer")
        :desc "ibuffer" "b" #'ibuffer)
    (:prefix ("c". "code")
        :desc "flycheck-next-error" "n" #'flycheck-next-error
        :desc "flycheck-prev-error" "p" #'flycheck-previous-error)
    (:prefix ("f". "file")
        :desc "find file as sudo"      "s" #'doom/sudo-find-file
        :desc "open this file as sudo" "S" #'doom/sudo-this-file)
    (:prefix ("r". "roam")
        :desc "find node"                 "f" #'org-roam-node-find
        :desc "insert link to node"       "i" #'org-roam-node-insert
        :desc "view all links for a node" "v" #'org-roam-buffer-display-dedicated)
    (:prefix ("p". "project")
        :desc "search project" "/" #'+default/search-project)
    (:prefix ("t". "toggle/treemacs")
        :desc "treemacs"                    "t" #'treemacs-select-window
        :desc "treemacs error list"         "e" #'lsp-treemacs-errors-list
        :desc "treemacs edit workspaces"    "E" #'treemacs-edit-workspaces
        :desc "treemacs switch workspace"   "S" #'treemacs-switch-workspace)
    (:prefix ("w". "window")
        :desc "window-only" "o" #'delete-other-windows
        :desc "save"        "w" #'save-buffer))

(load-file "~/working/dev/rust/lightc/misc/light-mode.el")

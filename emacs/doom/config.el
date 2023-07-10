;; NAME
(setq user-full-name "Marc Soda"
      user-mail-address "m@soda.fm")

;; MISC
(advice-remove 'evil-open-below #'+evil--insert-newline-below-and-respect-comments-a)
(advice-remove 'evil-open-above #'+evil--insert-newline-above-and-respect-comments-a)
(setq tab-width 4)
(setq evil-shift-width 4)

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

;;LSP
(after! lsp-mode
    (after! lsp-pyright
        (setq lsp-pyright-venv-path "/home/marc/working/dev/lehigh/431/kmm/venv"))
    ;; tramp remote stuff
    (if (boundp 'tramp-remote-path)
        (progn
            (add-to-list 'tramp-remote-path "~/go/bin")
            (add-to-list 'tramp-remote-path "/usr/bin/clangd")
            (add-to-list 'tramp-remote-path 'tramp-own-remote-path)))
    (lsp-register-client
        (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                :major-modes '(c++-mode)
                :remote? t
                :server-id 'cpp-server))
    (lsp-register-client
        (make-lsp-client :new-connection (lsp-tramp-connection "gopls")
                :major-modes '(go-mode)
                :remote? t
                :server-id 'go-server))
    (lsp-register-client
        (make-lsp-client :new-connection (lsp-tramp-connection "rust-analyzer")
                :major-modes '(rust-mode rustic-mode)
                :remote? t
                :server-id 'rust-server)))
(after! lsp-ui
    (setq lsp-ui-doc-enable t)
    (setq lsp-headerline-breadcrumb-enable t)
    (setq lsp-ui-doc-show-with-mouse t))

;;RAND-THEME
(after! rand-theme
    (setq rand-theme-wanted '(doom-henna doom-xcode doom-1337)))
(rand-theme) ;;for some reason, this does not work when I put it in the block

;;ORG
(after! org
  :init
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "/home/marc/Dropbox/org"
    org-agenda-files '("/home/marc/Dropbox/org")
    org-agenda-window-setup 'only-window
    org-hide-emphasis-markers t
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
    (defun treemacs-ignore-filter (name path)
        (string-match-p ".*\\.pyc$" name)
        (string-match-p ".*\\.class$" name))
    (setq treemacs-width 25)
    (setq treemacs-width-is-locked nil)
    (setq treemacs-width-is-initially-locked nil)
    (setq treemacs-find-workspace-method 'find-for-file-or-manually-select)
    (setq treemacs-is-never-other-window t)
    (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-filter))


;;SMOOTH SCROLLING
(setq scroll-margin 10
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;whitespace: show whitespace and remove it on save
(after! whitespace
    (setq-default show-trailing-whitespace t)
    (set-face-attribute 'trailing-whitespace nil :underline t :background "black")
    (add-hook 'before-save-hook 'delete-trailing-whitespace))

(fset 'mac-treemacs-up
   (kmacro-lambda-form [?  ?t ?t ?k ?  ?t ?t] 0 "%d"))
(fset 'mac-treemacs-down
   (kmacro-lambda-form [?  ?t ?t ?j ?  ?t ?t] 0 "%d"))
(fset 'mac-treemacs-ret
   (kmacro-lambda-form [?  ?t ?t return ?  ?w ?l] 0 "%d"))
(fset 'mac-treemacs-resize-left
   (kmacro-lambda-form [?  ?t ?t ?\C-x ?\{ ?  ?t ?t] 0 "%d"))
(fset 'mac-treemacs-resize-right
   (kmacro-lambda-form [?  ?t ?t ?\C-x ?\} ?  ?t ?t] 0 "%d"))

;;keybindings
(define-key evil-normal-state-map (kbd "M-j") 'mac-treemacs-down)
(define-key evil-normal-state-map (kbd "M-k") 'mac-treemacs-up)
(define-key evil-normal-state-map (kbd "M-RET") 'mac-treemacs-ret)
(define-key evil-normal-state-map (kbd "M-h") 'mac-treemacs-resize-left)
(define-key evil-normal-state-map (kbd "M-l") 'mac-treemacs-resize-right)
(define-key evil-normal-state-map (kbd "/") 'swiper)
(define-key evil-normal-state-map (kbd "J") 'evil-forward-paragraph)
(define-key evil-normal-state-map (kbd "K") 'evil-backward-paragraph)
(define-key evil-visual-state-map (kbd "J") 'evil-forward-paragraph)
(define-key evil-visual-state-map (kbd "K") 'evil-backward-paragraph)
(define-key minibuffer-mode-map   (kbd "M-j") 'next-line)
(define-key minibuffer-mode-map   (kbd "M-k") 'previous-line)
(after! evil-org
    (evil-define-key 'normal evil-org-mode-map
        (kbd "M-o") '+org/insert-item-below
        (kbd "M-O") '+org/insert-item-above))
(after! org-agenda
    (define-key org-agenda-mode-map (kbd "q") 'org-agenda-exit)
    (setq org-agenda-custom-commands
        '(("b" "Better agenda view"
            ((agenda "")
            ;;List all agenda items without timestamps
            (alltodo ""
                ((org-agenda-todo-ignore-with-date t))))))))
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
        :desc "open this file as sudo" "S" #'doom/sudo-this-file
        :desc "find in dotfiles" "d" (lambda () (interactive)(doom-project-browse "~/working/dotfiles/"))
        :desc "find in org" "o" (lambda () (interactive)(doom-project-browse "~/working/org/")))
    (:prefix ("n". "notes")
        (:prefix ("r". "roam")
        :desc "list all links for a node" "l" #'org-roam-buffer-display-dedicated
        :desc "open roam UI" "u" #'org-roam-ui-open))
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

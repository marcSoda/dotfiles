;; NAME
(setq user-full-name "Marc Soda"
      user-mail-address "m@soda.fm")

;; MISC
(advice-remove 'evil-open-below #'+evil--insert-newline-below-and-respect-comments-a)
(advice-remove 'evil-open-above #'+evil--insert-newline-above-and-respect-comments-a)
(setq tab-width 4)
(setq native-comp-jit-compilation nil) ;; don't defer compilation for new packages
;; treesitter
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)


;; FONT
(setq doom-font (font-spec :family "Iosevka" :size 25))
(setq doom-variable-pitch-font (font-spec :family "Ubuntu" :size 25))
(setq doom-big-font (font-spec :family "Iosevka" :size 30))

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

;; javascript indentation
(defun setup-jsx-indentation ()
  (setq tab-width 4)
  (setq js-indent-level 4)
  (setq typescript-indent-level 4)
  (setq js2-basic-offset 4)
  (setq js-jsx-indent-level 4))
(add-hook 'rjsx-mode-hook 'setup-jsx-indentation)
(add-hook 'typescript-mode-hook 'setup-jsx-indentation)
(add-hook 'js-mode-hook 'setup-jsx-indentation)
(add-hook 'js2-jsx-mode-hook 'setup-jsx-indentation)
(add-hook 'js-jsx-mode-hook 'setup-jsx-indentation)

(setq js-indent-level 4)
(setq typescript-indent-level 4)
(setq tab-width 4)
(setq js-jsx-indent-level 4)
(setq js2-basic-offset 4)

;;LINE NUMBERS
(setq display-line-numbers-type 'nil)

;;LSP
(after! lsp-mode
    ;; lsp stuff
    (setq lsp-idle-delay 0.5
          lsp-signature-render-documentation nil
          lsp-lens-enable nil
          lsp-eldoc-render-all nil
          gc-cons-threshold (* 100 1024 1024)
          read-process-output-max (* 3 1024 1024)
          undo-limit (* 2 1024 1024)
          undo-strong-limit (* 2 1024 1024)
          undo-outer-limit (* 24 1024 1024)
          compilation-scroll-output t)
    ;; tramp remote stuff
    (if (boundp 'tramp-remote-path)
        (progn
            (add-to-list 'tramp-remote-path "~/go/bin")
            (add-to-list 'tramp-remote-path "/usr/bin")
            (setq enable-remote-dir-locals t)
            (add-to-list 'tramp-remote-path 'tramp-own-remote-path))))

(after! lsp-ui
    ;; lsp bar at the top of frame
    (setq lsp-headerline-breadcrumb-enable t)
    ;; peek
    (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
    (setq lsp-ui-peek-peek-height 12)
    (setq lsp-ui-peek-enable t)
    ;; sideline
    (setq lsp-ui-sideline-show-hover t)
    (setq lsp-ui-sideline-show-code-actions t)
    ;; doc
    (setq lsp-ui-doc-enable t)
    (setq lsp-ui-doc-show-with-cursor t)
    (setq lsp-ui-doc-position 'top)
    (setq lsp-ui-doc-side 'right))

;; direnv. for now, this mode just allows pyright to use python venvs. Check instructions for more details
(after! direnv
  (direnv-mode))

;; theme
(setq rand-theme-wanted '(misterioso humanoid-dark))
(rand-theme)

;;ORG
(after! org
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-directory "/home/marc/Nextcloud/org"
        org-agenda-files '("/home/marc/Nextcloud/org")
        org-agenda-window-setup 'only-window
        org-hide-emphasis-markers t
        org-todo-keywords '((sequence "TODO(t)" "MEET(m)" "|" "DONE(d)"))))

;;ORG-ROAM
(setq org-roam-directory "~/working/nextcloud/org/roam"
      org-roam-completion-everywhere t
      org-roam-db-autosync-mode t)

;; CAPTURE TEMPLATES
(setq org-roam-capture-templates '(("d" "default" plain "%?"
    :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
    :unnarrowed t)))

;; DAILIES CAPTURE TEMPLATE
(setq org-roam-dailies-capture-templates
    '(("d" "default" entry "* %?"
    :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

;;ORG-ROAM-UI
(after! org-roam-ui
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow nil
          org-roam-ui-update-on-save t))

;;TRANSPARENCY
(add-to-list 'default-frame-alist '(alpha-background . 100))

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
    ;; (add-hook 'treemacs-mode-hook (lambda () (text-scale-decrease 1.5)))
    (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-filter))

;;SMOOTH SCROLLING
(setq scroll-margin 10
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;; ;;whitespace: show whitespace and remove it on save
;; (after! whitespace
;;     (setq-default show-trailing-whitespace t)
;;     (set-face-attribute 'trailing-whitespace nil :underline t :background "black")
;;     (add-hook 'before-save-hook 'delete-trailing-whitespace))

;; treemacs macros: interact with treemacs without focusing on treemacs buffer
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
  (setq org-agenda-auto-save t)
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?D)
  (setq org-default-priority ?D)
  (setq org-agenda-custom-commands
        '(("a" "Better agenda view"
            ((agenda "")
            (tags-todo "solar")
            (tags-todo "-solar" ((org-agenda-todo-ignore-with-date t))))))))

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
        :desc "flycheck-prev-error" "p" #'flycheck-previous-error
        :desc "find definitions" "d" #'xref-find-definitions
        :desc "find references" "D" #'xref-find-references
        :desc "open imenu" "I" #'lsp-ui-imenu
        :desc "switch between header and source (clangd)" "s" #'lsp-clangd-find-other-file
        :desc "grep" "g" #'rgrep)
    (:prefix ("d". "dired")
        :desc "dired" "d" #'dired
        :desc "dired jump to current" "j" #'dired-jump
        :desc "peep-dired" "p" #'peep-dired)
    (:prefix ("f". "file")
        :desc "find file as sudo"      "s" #'doom/sudo-find-file
        :desc "open this file as sudo" "S" #'doom/sudo-this-file
        :desc "find in dotfiles" "d" (lambda () (interactive)(doom-project-browse "~/working/dotfiles/"))
        :desc "find in instructions" "i" (lambda () (interactive)(doom-project-browse "~/working/dotfiles/instructions/"))
        :desc "find in org" "o" (lambda () (interactive)(doom-project-browse "~/Nextcloud/org/")))
    (:prefix ("n". "notes")
        (:prefix ("r". "roam")
        :desc "list all links for a node" "l" #'org-roam-buffer-display-dedicated
        :desc "open roam UI" "u" #'org-roam-ui-open))
    (:prefix ("o". "open")
        :desc "org agenda" "a" #'org-agenda)
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

;;GENERAL: for keybindings
(use-package general
  :after evil
  :config
  (general-evil-setup t))

;;remap '/' to use swiper
(define-key evil-normal-state-map (kbd "/") 'swiper)
;;remap tab to act as enter for company
(define-key company-active-map (kbd "<tab>") #'company-complete-selection)
;;remap company up/down to M-k/j
(define-key company-active-map (kbd "M-j") #'company-select-next)
(define-key company-active-map (kbd "M-k") #'company-select-previous)
;;remap C-n and C-p to M-j and M-k in ivy buffers
(define-key ivy-minibuffer-map (kbd "M-j") 'ivy-next-line)
(define-key ivy-minibuffer-map (kbd "M-k") 'ivy-previous-line)
;;S-j/k to navigate faster
(define-key evil-normal-state-map (kbd "J") 'evil-forward-paragraph)
(define-key evil-normal-state-map (kbd "K") 'evil-backward-paragraph)
;;M-j/k move up and down in mu4e-view-mode-map
(define-key mu4e-view-mode-map (kbd "M-j") 'mu4e-view-headers-next)
(define-key mu4e-view-mode-map (kbd "M-k") 'mu4e-view-headers-prev)
;;ibuffer
;; (require 'ibuffer) ;ensure ibuffer is loaded
(define-key ibuffer-mode-map (kbd "<tab>") 'ibuffer-toggle-filter-group)

;;j/k in org-agenda mode are down/up. overrides org-agenda-goto-date and org-agenda-capture
(add-hook 'org-agenda-mode-hook (lambda ()
  (define-key org-agenda-mode-map "j" 'evil-next-line)
  (define-key org-agenda-mode-map "k" 'evil-previous-line)
  (define-key org-agenda-mode-map "s" 'org-agenda-todo)
  (define-key org-agenda-mode-map "p" 'org-agenda-priority)
  (define-key org-agenda-mode-map "q" 'org-agenda-exit))) ;;close org files when press 'q'

(general-define-key
    :states '(normal visual emacs motion)
    :keymaps 'override
    :prefix "SPC"
    "" nil
    "SPC"   '(execute-extended-command       :which-key "M-x")
    "v v"   '(vterm                          :which-key "vterm")
    "c c"   '(comment-line                   :which-key "Comment-line")
    "c p"   '(c++-mode                       :which-key "c++-mode")
    "i s"   '(ispell                         :which-key "ispell")
    "e e"   '(eval-last-sexp                 :which-key "Eval lisp")
    "n n"   '(linum-mode                     :which-key "Show line numbers")
    "p"     '(:keymap projectile-command-map :which-key "Projectile prefix")
    "z"     '(suspend-frame                  :which-key "Suspend frame")
    "q"     '(save-buffers-kill-terminal     :which-key "Quit")
    ;;d
    "d d"   '(dashboard-refresh-buffer       :which-key "Refresh and show dashboard")
    "d c d" '(dired-create-directory         :which-key "Dired create directory")
    "d c f" '(dired-create-empty-file        :which-key "Direc create file")
    "d k"   '(describe-key                   :which-key "Describe Key")
    "d f"   '(describe-function              :which-key "Describe Function")
    "d v"   '(describe-variable              :which-key "Describe Variable")
    ;;f
    "f l"   '(flycheck-list-errors    :which-key "flycheck-list-errors")
    "f n"   '(flycheck-next-error     :which-key "flycheck-next-error")
    "f p"   '(flycheck-previous-error :which-key "flycheck-previous-error")
    "f f"   '(find-file               :which-key "Find file")
    ;;o
    "o e"     '(org-html-export-to-html              :which-key "Org export to html")
    "o h"     '(org-toggle-heading                   :which-key "Org toggle heading")
    "o i"     '(org-toggle-item                      :which-key "Org toggle item")
    "o n"     '(org-store-link                       :which-key "Org store link")
    "o x"     '(org-toggle-checkbox                  :which-key "Org toggle checkbox")
    "o c"     '(org-ctrl-c-ctrl-c                    :which-key "Org ctrl-c-ctrl-c")
    "o t t"   '(org-set-tags-command                 :which-key "Org set tags")
    "o t c"   '(org-table-toggle-coordinate-overlays :which-key "Org Table toggle coordinates")
    "o t a"   '(org-table-align                      :which-key "Org table align")
    "o r t"   '(org-roam-buffer-toggle               :which-key "Roam toggle buffer")
    "o r f"   '(org-roam-node-find                   :which-key "Roam find node")
    "o r i"   '(org-roam-node-insert                 :which-key "Roam insert node")
    "o r c"   '(completion-at-point                  :which-key "Roam autocomplete node link")
    "o r d C" '(org-roam-dailies-goto-today          :which-key "Roam Dailies Goto Today")
    "o r d c" '(org-roam-dailies-capture-today       :which-key "Roam Dailies Capture Today")
    "o r d Y" '(org-roam-dailies-goto-yesterday      :which-key "Roam Dailies Goto  Yesterday")
    "o r d y" '(org-roam-dailies-capture-yesterday   :which-key "Roam Dailies Capture Yesterday")
    "o r d T" '(org-roam-dailies-goto-tomorrow       :which-key "Roam Dailies Goto Tomorrow")
    "o r d t" '(org-roam-dailies-capture-tomorrow    :which-key "Roam Dailies Capture Tomorrow")
    "o r d d" '(org-roam-dailies-goto-date           :which-key "Roam Dailies Goto Date")
    "o A"     '(org-agenda                           :which-key "Org agenda")
    "o a s"   '(org-todo                             :which-key "Org change state")
    "o a d s" '(org-schedule                         :which-key "Org schedule")
    "o a d d" '(org-deadline                         :which-key "Org deadline")
    "o a d t" '(org-time-stamp                       :which-key "Org timestamp")
    ;;b
    "b b"   '(ibuffer                  :which-key "Ibuffer")
    "b k"   '(kill-current-buffer      :which-key "Kill current buffer")
    "b r"   '(revert-buffer            :which-key "revert-buffer")
    ;;m
    "m g"   '(magit-status             :which-key "magit")
    "m c"   '(with-editor-finish       :which-key "with-editor-finish")
    "m k"   '(with-editor-cancel       :which-key "with-editor-cancel")
    "m u"   '(mu4e                     :which-key "mu4e")
    ;; t
    "t t"   '(treemacs-select-window    :which-key "treemacs-select-window")
    "t e"   '(treemacs-edit-workspaces  :which-key "treemacs-edit-workspaces")
    "t s"   '(treemacs-switch-workspace :which-key "treemacs-switch-workspace")
    ;; l
    "l s"   '(lsp-treemacs-symbols     :which-key "lsp-treemacs-symbols")
    "l e"   '(lsp-treemacs-errors-list :which-key "lsp-treemacs-errors-list")
    "l l"   '(toggle-truncate-lines    :which-key "Toggle truncate lines")
    ;;Window-related
    "w c"   '(evil-window-delete       :which-key "Close window")
    "w o"   '(delete-other-windows     :which-key "Make window fill frame")
    "w s"   '(evil-window-split        :which-key "Horizontal split window")
    "w v"   '(evil-window-vsplit       :which-key "Vertical split window")
    "w h"   '(evil-window-left         :which-key "Window left")
    "w j"   '(evil-window-down         :which-key "Window down")
    "w k"   '(evil-window-up           :which-key "Window up")
    "w l"   '(evil-window-right        :which-key "Window right")
    "w w"   '(save-buffer              :which-key "Save buffer"))

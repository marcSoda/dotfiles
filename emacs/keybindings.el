;;GENERAL: for keybindings
(use-package general
  :after evil
  :config
  (general-evil-setup t))

;;remap '/' to use swiper
(define-key evil-normal-state-map (kbd "/") 'swiper)
;;remap C-n and C-p to M-j and M-k in ivy buffers
(define-key ivy-minibuffer-map (kbd "M-j") 'ivy-next-line)
(define-key ivy-minibuffer-map (kbd "M-k") 'ivy-previous-line)
;;S-j/k to navigate faster
(define-key evil-normal-state-map (kbd "J") 'evil-forward-paragraph)
(define-key evil-normal-state-map (kbd "K") 'evil-backward-paragraph)
;;M-j/k move up and down in mu4e-view-mode-map
(define-key mu4e-view-mode-map (kbd "M-j") 'mu4e-view-headers-next)
(define-key mu4e-view-mode-map (kbd "M-k") 'mu4e-view-headers-prev)

;;j/k in org-agenda mode are down/up. overrides org-agenda-goto-date and org-agenda-capture
(add-hook 'org-agenda-mode-hook (lambda ()
  (define-key org-agenda-mode-map "j" 'evil-next-line)
  (define-key org-agenda-mode-map "k" 'evil-previous-line)
  (define-key org-agenda-mode-map "q" 'org-agenda-exit))) ;;close org files when press 'q'

(general-define-key
    :states '(normal visual emacs motion)
    :keymaps 'override
    :prefix "SPC"
    "" nil
    "SPC"   '(execute-extended-command   :which-key "M-x")
    "t t"   '(toggle-truncate-lines      :which-key "Toggle truncate lines")
    "v v"   '(vterm                      :which-key "vterm")
    "w w"   '(save-buffer                :which-key "Save buffer")
    "c c"   '(comment-line               :which-key "Comment-line")
    "c p"   '(c++-mode                   :which-key "c++-mode")
    "i s"   '(ispell                     :which-key "ispell")
    "f f"   '(find-file                  :which-key "Find file")
    "e e"   '(eval-last-sexp             :which-key "Eval lisp")
    "z"     '(suspend-frame              :which-key "Suspend frame")
    "q"     '(save-buffers-kill-terminal :which-key "Quit")
    ;;flycheck
    "f l"   '(flycheck-list-errors    :which-key "flycheck-list-errors")
    "f n"   '(flycheck-next-error     :which-key "flycheck-next-error")
    "f p"   '(flycheck-previous-error :which-key "flycheck-previous-error")
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
    "o s"   '(org-todo                             :which-key "Org change state")
    ;;buffer-related
    "b b"   '(ibuffer                  :which-key "Ibuffer")
    "b k"   '(kill-current-buffer      :which-key "Kill current buffer")
    "b r"   '(revert-buffer            :which-key "revert-buffer")
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

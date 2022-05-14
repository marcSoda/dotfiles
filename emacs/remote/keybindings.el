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
;;ibuffer
(define-key ibuffer-mode-map (kbd "<tab>") 'ibuffer-toggle-filter-group)

(general-define-key
    :states '(normal visual emacs motion)
    :keymaps 'override
    :prefix "SPC"
    "" nil
    "SPC"   '(execute-extended-command       :which-key "M-x")
    "t t"   '(toggle-truncate-lines          :which-key "Toggle truncate lines")
    "w w"   '(save-buffer                    :which-key "Save buffer")
    "c c"   '(comment-line                   :which-key "Comment-line")
    "c p"   '(c++-mode                       :which-key "c++-mode")
    "f f"   '(find-file                      :which-key "Find file")
    "e e"   '(eval-last-sexp                 :which-key "Eval lisp")
    "n n"   '(linum-mode                     :which-key "Show line numbers")
    "z"     '(suspend-frame                  :which-key "Suspend frame")
    "q"     '(save-buffers-kill-terminal     :which-key "Quit")
    ;;flycheck
    "f l"   '(flycheck-list-errors    :which-key "flycheck-list-errors")
    "f n"   '(flycheck-next-error     :which-key "flycheck-next-error")
    "f p"   '(flycheck-previous-error :which-key "flycheck-previous-error")
    ;;buffer-related
    "b b"   '(ibuffer                  :which-key "Ibuffer")
    "b k"   '(kill-current-buffer      :which-key "Kill current buffer")
    "b r"   '(revert-buffer            :which-key "revert-buffer")
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
    "d f"   '(describe-function        :which-key "Describe Function")
    "d v"   '(describe-variable        :which-key "Describe Variable"))

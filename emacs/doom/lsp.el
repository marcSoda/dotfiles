(after! lsp-mode
    (gc-cons-threshold (* 100 1024 1024))
    (read-process-output-max (* 3 1024 1024))
    (lsp-eldoc-render-all nil)
    (lsp-idle-delay 0.7)
    (lsp-signature-render-documentation nil)
    (lsp-lens-enable nil)
    (if (boundp 'tramp-remote-path)
        (progn
            (add-to-list 'tramp-remote-path "/home/marc/go/bin")
            (add-to-list 'tramp-remote-path 'tramp-own-remote-path)))
    (lsp-register-client
        (make-lsp-client :new-connection (lsp-tramp-connection "gopls")
                         :major-modes '(go-mode)
                         :remote? t
                         :server-id 'electron.soda.fm))
    (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(after! lsp-ui
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-show-hover t))

(use-package! lsp-ivy
  :defer t
  :commands lsp-ivy-workspace-symbol
  :after (lsp-mode ivy))

;;RUST
(after! rustic
  (setq lsp-rust-analyzer-server-command '("/sbin/rust-analyzer"))
  (setq lsp-rust-analyzer-cargo-watch-command "clippy")
  (setq lsp-rust-analyzer-proc-macro-enable t)
  (setq lsp-eldoc-render-all nil)
  (setq-default lsp-rust-analyzer-proc-macro-enable nil)
  (setq compilation-scroll-output t))

;;C++
(after! ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

;; Company mode
(after! company
    (setq company-idle-delay 0)
    (setq company-minimum-prefix-length 1))

;; Go Mode
(after! go-mode
  (add-hook 'go-mode-hook #'lsp-deferred)
  (gofmt-command "goimports"))

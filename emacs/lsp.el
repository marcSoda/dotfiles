(use-package lsp-mode
  :commands lsp
  :custom
  (gc-cons-threshold (* 100 1024 1024))
  (read-process-output-max (* 3 1024 1024))
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay 0.7)
  (lsp-signature-render-documentation nil)
  (lsp-lens-enable nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-show-hover t))

(use-package lsp-ivy
  :defer t
  :commands lsp-ivy-workspace-symbol
  :after (lsp-mode ivy))

(use-package dap-mode)

;; code snippets
(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (yas-minor-mode))


;; PYTHON
(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

(use-package python-mode
  :mode "//.py//'"
  :hook (python-mode . lsp-deferred))

;;RUST
(use-package rustic
  :config
  (setq lsp-rust-analyzer-server-command '("/sbin/rust-analyzer"))
  (setq lsp-rust-analyzer-cargo-watch-command "clippy")
  (setq lsp-rust-analyzer-proc-macro-enable t)
  (setq lsp-eldoc-render-all nil)
  (setq compilation-scroll-output t))

;;C++
(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

;;C#
(use-package csharp-mode
  :ensure t
  :init
  (setenv "FrameworkPathOverride" "/lib/mono/4.5")
  (defun my/csharp-mode-hook ()
    (setq-local lsp-auto-guess-root t)
    (lsp))
  (add-hook 'csharp-mode-hook #'my/csharp-mode-hook))

;; following may not be setup yet for lsp:
(use-package go-mode)
(use-package haskell-mode)
(use-package yaml-mode)
(use-package handlebars-mode
  :init (add-to-list 'auto-mode-alist '("\\.hb?\\'" . handlebars-mode)))
(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-auto-closing t))

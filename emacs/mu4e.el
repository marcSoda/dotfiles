;;MU4E
(use-package mu4e
  :ensure nil
  :config
  (setq mu4e-get-mail-command "mbsync -c ~/.config/mu4e/mbsyncrc -a")
  (setq mu4e-main-view-hide-addresses t)
  (setq mu4e-compose-complete-only-personal nil)
  (setq mu4e-attachment-dir "~/working/downloads")
  (setq mu4e-headers-skip-duplicates t)
  (setq mu4e-headers-include-related nil)
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy 'always-ask)
  (setq user-mail-address "masa20@lehigh.edu")
  (add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)
  (setq message-send-mail-function 'smtpmail-send-it
	smtpmail-auth-credentials "~/.authinfo.gpg"
	smtpmail-smtp-server "127.0.0.1"
  smtpmail-stream-type 'starttls
	smtpmail-smtp-service 1025)
  (require 'mu4e-context)

  (setq mu4e-contexts
    (list
      ;; gmail account
      (make-mu4e-context
        :name "gmail"
        :match-func
        (lambda (msg)
          (when msg
            (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address . "m.soda412@gmail.com")
                (user-full-name    . "Marc Soda Jr.")
                (mu4e-drafts-folder  . "/gmail/[Gmail]/Drafts")
                (mu4e-sent-folder  . "/gmail/[Gmail]/Sent Mail")
                (mu4e-refile-folder  . "/gmail/[Gmail]/All Mail")
                (mu4e-trash-folder  . "/gmail/[Gmail]/Trash")
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
            (string-prefix-p "/lehigh" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address . "masa20@lehigh.edu")
                (user-full-name    . "Marc Soda Jr.")
                (mu4e-drafts-folder  . "/lehigh/[Gmail]/Drafts")
                (mu4e-sent-folder  . "/lehigh/[Gmail]/Sent Mail")
                (mu4e-refile-folder  . "/lehigh/[Gmail]/All Mail")
                (mu4e-trash-folder  . "/lehigh/[Gmail]/Trash")

                (message-send-mail-function . smtpmail-send-it)
                (starttls-use-gnutls . t)
                (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                (smtpmail-auth-credentials . "~/.authinfo.gpg")
                (smtpmail-default-smtp-server . "smtp.gmail.com")
                (smtpmail-smtp-server ."smtp.gmail.com")
                (smtpmail-smtp-service . 587)))
        ;;protonmail
        (make-mu4e-context
          :name "protonmail"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/proton" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "m@soda.fm")
            (user-full-name    . "Marc Soda Jr.")
            (mu4e-drafts-folder  . "/proton/Drafts")
            (mu4e-sent-folder  . "/proton/Sent")
            (mu4e-refile-folder  . "/proton/All Mail")
            (mu4e-trash-folder  . "/proton/Trash")

            (message-send-mail-function . smtpmail-send-it)
            (smtpmail-auth-credentials . "~/.authinfo.gpg")
            (smtpmail-smtp-server . "127.0.0.1")
            (smtpmail-stream-type . starttls)
            (smtpmail-smtp-service . 1025))))))

;; keybindings defined in keybindings.el

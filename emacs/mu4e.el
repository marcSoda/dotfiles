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
        ;;protonmail
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

;; keybindings defined in keybindings.el

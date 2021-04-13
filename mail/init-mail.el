;;; mu4e account setup
(setq mu4e-account-alist
      '(("MailService"
          ;; Under each account, set the account-specific variables you want.
          ;;(mu4e-sent-messages-behavior delete)
          (mu4e-sent-folder "/Sent")
          (mu4e-drafts-folder "/Drafts")
          (user-mail-address "name@domain.com")
          (smtpmail-smtp-user "username")
          (user-full-name "Full Name"))))
(mu4e/mail-account-reset)

;; Don't save message to Sent Messages, GMail/IMAP will take care of this
(setq mu4e-sent-messages-behavior 'delete)

;; Allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "mbsync -a")

;;; Set up some common mu4e variables
(setq mu4e-maildir "~/.email/MailService/"
      mu4e-trash-folder "/Trash"
      mu4e-refile-folder "/Archive"
      mu4e-update-interval 300
      message-kill-buffer-on-exit t
      mu4e-context-policy 'pick-first
      mu4e-confirm-quit nil
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-change-filenames-when-moving t
      mu4e-view-show-addresses t)

;; SMTP Configuration
(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
      ;; starttls-use-gnutls t
      user-mail-address "name@domain.com"
      smtpmail-smtp-user "username"
      ;;smtpmail-starttls-credentials
      ;;'(("domain.com" 587 nil nil))
      smtpmail-auth-credentials
      '(("domain.com" 465 "username" nil))
      smtpmail-default-smtp-server "domain.com"
      smtpmail-smtp-server "domain.com"
      smtpmail-smtp-service 465
      smtpmail-stream-type 'ssl
      smtpmail-debug-info t)

;; Set this to nil so signature is not included by default
;; you can include in message with C-c C-w
(setq mu4e-compose-signature-auto-include 't)
(setq mu4e-compose-signature (with-temp-buffer
                               (insert-file-contents "~/.email/signature.personal")
                               (buffer-string)))
;;; Mail directory shortcuts
(setq mu4e-maildir-shortcuts
      '(("/Inbox" . ?i)
        ("/Drafts" . ?d)
        ("/Sent" . ?s)
        ("/Axess" . ?a)
        ("/Axtract" . ?x)
        ("/Axact" . ?c)))

;;; Bookmarks
(setq mu4e-bookmarks
      `(("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
        ("date:today..now" "Today's messages" ?t)
          ("date:7d..now" "Last 7 days" ?w)
          ("mime:image/*" "Messages with images" ?p)
          (,(mapconcat 'identity
                      (mapcar
                        (lambda (maildir)
                          (concat "maildir:" (car maildir)))
                        mu4e-maildir-shortcuts) " OR ")
          "All inboxes" ?i)))

;; Mail notifications
(setq mu4e-enable-notifications t)
(setq mu4e-enable-mode-line t)
(with-eval-after-load 'mu4e-alert
  ;; Enable Desktop notifications
  ;; (mu4e-alert-set-default-style 'notifications)) ; For linux
  ;; (mu4e-alert-set-default-style 'libnotify))  ; Alternative for linux
  (mu4e-alert-set-default-style 'notifier)  ; For Mac OSX (through the terminal notifier app)
  ;; (mu4e-alert-set-default-style 'growl)   ; Alternative for Mac OSX
  )

(provide 'init-mail)

;; relay.el -- relayed network connection hack

;; Copyright (c) 2001 Shun-ichi Goto.

;; Author: Shun-ichi GOTO <gotoh@taiyo.co.jp>
;; Created: Tue May 15 01:25:22 2001
;; Version: 1.11
;; Keywords: network, socks

;;; Commentary:

;; This packege contains alternative function of open-network-stream
;; to make relayed network connection using external command like ssh
;; and connect(*) command.
;;
;; (*) connect command can be get from
;;     http://www.imasy.or.jp/~gotoh/ssh/connect.c
;;     It can be compiled UNIXes and Win32 environments. 

;;; Resstriction

;; * Interactive authentication is not supported.  For example,
;;   password or passphrase prompt of ssh with tty is not handled.  So
;;   you should prepare other method to authentication like ssh-agent
;;   or ssh-ask-pass.


;;; Instalation:

;; Put this package into load-path'ed directory.

;;; Usage:

;; Define relay-command-alist for your environment.
;; Then use relay-open-network-stream instead of open-network-stream.
;; Or, advice open-network-stream like this:
;;
;; (defadvice open-network-stream (around relay (name buffer host service)
;;                                        activate)
;;   "Open network stream with relaying."
;;   (require 'relay)
;;   (defvar relay-internal-using-p nil)
;;   (if relay-internal-using-p
;;       ad-do-it			; not relayed, use standard way.
;;     (let ((relay-internal-using-p t))
;;       ;; make connction using specified command
;;       (setq ad-return-value
;; 	    (relay-open-network-stream name buffer host service)))))
;;
;; If you use this with Wanderlust,
;; (setq elmo-network-stream-type-alist
;;       (cons '("!relay" relay relay relay-open-network-stream)
;; 	    elmo-network-stream-type-alist))
;;
;; If you send mail through the SMTP server inside of your organization
;; from outside, you can relay to the SMTP server like this:
;;
;; (setq relay-command-alist
;;       (cons '(("^smtp\\.your\\.domain\\.org$" . (25 "smtp"))
;;             "ssh" "somehost.your.domain.org" "connect" host port)
;;       smtp-open-connection-function #'relay-open-network-stream)
;;
;; In expression above, this entry is used only when making smtp
;; service to smtp.your.domain.org, and not used for another service
;; (like POP).  To send message with smtp.el, you should also set
;; `smtp-open-connection-function' as `relay-open-network-stream', 
;; or advice `open-network-stream' function.

;;; Code:

(defvar relay-command-alist nil
  "*Alist of destination and relay command to connect there.  For each
element, car is destination host regex for target hostname, or cons of
regex and list of services.  And cdr is list for relay command
execution. If regexp (and also service) is matches with HOST (and
SERVICE) of `relay-open-network-stream', invoke command specified in
its cdr.  You can use two special symbol 'host and 'service as target
hostname and service given as argument of `relay-open-network-stream'.

For example:
 (setq relay-command-alist
       '((\"^news\\\\.imasy\\\\.or\\\\.jp$\"
          \"ssh\" \"-C\" \"-1\" \"tasogare.imasy.or.jp\" \"connect\"
           host service)
         (\"^news\\\\.biglobe\\\\.ne\\\\.jp$\"
          \"ssh\" \"-C\" \"gotoh.cjb.net\" \"connect\" host service)
         ((\"^smtp\\\\.my-company\\\\.co\\\\.jp$\" . (25 \"smtp\"))
          \"ssh\" \"firewall.my-company.co.jp\" \"connect\" host service))

NOTE: Authentication are not considered.  We assume making
      connection does not use tty for authentication. We hope to 
      use ssh-agent or ssh-askpass for SSH, and host authentication
      for SOCKS.
")


(defun relay-prepare-command (host service)
  "Determine relaly command from `relay-command-alist' and prepare to call.
Result is list of string for calling with `start-process'."
  (let ((alist relay-command-alist)
	dest regexp services cmdl )
    (while alist
      (setq dest (caar alist)
	    cmdl (cdar alist))
      (cond
       ((consp dest)
	(setq regexp (car dest)
	      services (cdr dest)))
       ((stringp dest)
	(setq regexp dest
	      services nil))
       (t (error "Invalid entry in relay-command-alist %s" (car alist))))
      (if (and (or (null services)
		     (member service services))
		 (or (eq regexp t)		; default
		     (and regexp (string-match regexp host))))
	    ;; found!
	  (setq alist nil)
	;; or more loop
	(setq cmdl nil
	      alist (cdr alist))))
    ;; make result list
    (and cmdl
	 (mapcar (lambda (arg) (format "%s" (eval arg))) cmdl))))


(defun relay-open-network-stream (name buffer host service)
  "Alternative function of `open-network-stream'.
If route is not found in `relay-command-alist', make direct 
connection without relaying."
  (let ((cmdl (relay-prepare-command host service)))
    (if (null cmdl)
	(open-network-stream name buffer host service) ; usual way
      (apply (function start-process) name buffer cmdl))))

;;;
(provide 'relay)

;; relay.el ends here

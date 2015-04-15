;;; rudel-loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "infinote/rudel-infinote" "infinote/rudel-infinote.el"
;;;;;;  (21360 21635 0 0))
;;; Generated autoloads from infinote/rudel-infinote.el

(eieio-defclass-autoload 'rudel-infinote-backend '(rudel-protocol-backend) "infinote/rudel-infinote" "")

(rudel-add-backend (rudel-backend-get-factory 'protocol) 'infinote 'rudel-infinote-backend)

(eval-after-load 'rudel-zeroconf '(rudel-zeroconf-register-service "_infinote._tcp" 'xmpp 'infinote))

;;;***

;;;### (autoloads nil "obby/rudel-obby" "obby/rudel-obby.el" (21360
;;;;;;  21618 0 0))
;;; Generated autoloads from obby/rudel-obby.el

(eieio-defclass-autoload 'rudel-obby-backend '(rudel-protocol-backend) "obby/rudel-obby" "Main class of the Rudel obby backend. Creates obby client\nconnections and creates obby servers.")

(rudel-add-backend (rudel-backend-get-factory 'protocol) 'obby 'rudel-obby-backend)

(eval-after-load 'rudel-zeroconf '(rudel-zeroconf-register-service "_lobby._tcp" 'start-tls 'obby))

;;;***

;;;### (autoloads nil "rudel-backend" "rudel-backend.el" (21360 21376
;;;;;;  0 0))
;;; Generated autoloads from rudel-backend.el

(eieio-defclass-autoload 'rudel-backend-factory 'nil "rudel-backend" "Factory class that holds an object for each known backend\ncategory. Objects manage backend implementation for one backend\ncategory each.")

(defmethod rudel-get-factory :static ((this rudel-backend-factory) category) "Return the factory responsible for CATEGORY.\nIf there is no responsible factory, create one and return it." (with-slots (factories) this (or (gethash category factories) (puthash category (rudel-backend-factory category) factories))))

(defmethod rudel-add-backend ((this rudel-backend-factory) name class &optional replace) "\
Add factory class CLASS with name NAME to THIS.
if REPLACE is non-nil, replace a registered implementation of the
same name." (with-slots (backends) this (when (or (not (gethash name backends)) replace) (puthash name class backends))))

(autoload 'rudel-backend-get "rudel-backend" "\
A shortcut for getting backend NAME of category CATEGORY.
The returned backend is of the form (NAME . OBJECT).

\(fn CATEGORY NAME)" nil nil)

(autoload 'rudel-backend-get-factory "rudel-backend" "\
A shortcut for getting the factory object for CATEGORY.

\(fn CATEGORY)" nil nil)

;;;***

;;;### (autoloads nil "rudel-session-initiation" "rudel-session-initiation.el"
;;;;;;  (21360 22136 0 0))
;;; Generated autoloads from rudel-session-initiation.el

(eieio-defclass-autoload 'rudel-ask-protocol-backend '(rudel-session-initiation-backend) "rudel-session-initiation" "This fallback backend can \"discover\" sessions by letting the\nuser select a suitable backend and asking for connect information\nrequired by the chosen backend.")

(rudel-add-backend (rudel-backend-get-factory 'session-initiation) 'ask-protocol 'rudel-ask-protocol-backend)

(eieio-defclass-autoload 'rudel-configured-sessions-backend '(rudel-session-initiation-backend) "rudel-session-initiation" "This fallback backend can \"discover\" sessions the user has\nconfigured using customization.")

(rudel-add-backend (rudel-backend-get-factory 'session-initiation) 'configured-sessions 'rudel-configured-sessions-backend)

;;;***

;;;### (autoloads nil "socket/rudel-socket" "socket/rudel-socket.el"
;;;;;;  (21360 21601 0 0))
;;; Generated autoloads from socket/rudel-socket.el

(eieio-defclass-autoload 'rudel-tcp-backend '(rudel-transport-backend) "socket/rudel-socket" "TCP transport backend.\nThe transport backend is a factory for TCP transport objects.")

(rudel-add-backend (rudel-backend-get-factory 'transport) 'tcp 'rudel-tcp-backend)

;;;***

;;;### (autoloads nil "telepathy/rudel-telepathy" "telepathy/rudel-telepathy.el"
;;;;;;  (21360 21587 0 0))
;;; Generated autoloads from telepathy/rudel-telepathy.el

(eieio-defclass-autoload 'rudel-telepathy-backend '(rudel-transport-backend) "telepathy/rudel-telepathy" "Class rudel-telepathy-backend ")

(rudel-add-backend (rudel-backend-get-factory 'transport) 'telepathy 'rudel-telepathy-backend)

;;;***

;;;### (autoloads nil "tls/rudel-tls" "tls/rudel-tls.el" (21360 21567
;;;;;;  0 0))
;;; Generated autoloads from tls/rudel-tls.el

(eieio-defclass-autoload 'rudel-start-tls-backend '(rudel-transport-backend) "tls/rudel-tls" "STARTTLS transport backend.\nThe transport backend is a factory for transport objects that\nsupport STARTTLS behavior.")

(rudel-add-backend (rudel-backend-get-factory 'transport) 'start-tls 'rudel-start-tls-backend)

;;;***

;;;### (autoloads nil "wave/rudel-wave" "wave/rudel-wave.el" (21360
;;;;;;  21542 0 0))
;;; Generated autoloads from wave/rudel-wave.el

(eieio-defclass-autoload 'rudel-wave-backend '(rudel-protocol-backend) "wave/rudel-wave" "Main class of the Rudel Wave backend. Creates wave client\nconnections.")

(rudel-add-backend (rudel-backend-get-factory 'protocol) 'wave 'rudel-wave-backend)

;;;***

;;;### (autoloads nil "xmpp/rudel-xmpp" "xmpp/rudel-xmpp.el" (21360
;;;;;;  21513 0 0))
;;; Generated autoloads from xmpp/rudel-xmpp.el

(eieio-defclass-autoload 'rudel-xmpp-backend '(rudel-transport-backend) "xmpp/rudel-xmpp" "Transport backend works by transporting XMPP messages through\nXMPP connections.")

(rudel-add-backend (rudel-backend-get-factory 'transport) 'xmpp 'rudel-xmpp-backend)

;;;***

;;;### (autoloads nil "xmpp/rudel-xmpp-tunnel" "xmpp/rudel-xmpp-tunnel.el"
;;;;;;  (21360 21525 0 0))
;;; Generated autoloads from xmpp/rudel-xmpp-tunnel.el

(rudel-add-backend (rudel-backend-get-factory 'transport) 'xmpp 'rudel-xmpp-tunnel-backend)

;;;***

;;;### (autoloads nil "zeroconf/rudel-zeroconf" "zeroconf/rudel-zeroconf.el"
;;;;;;  (21360 21487 0 0))
;;; Generated autoloads from zeroconf/rudel-zeroconf.el

(autoload 'rudel-zeroconf-register-service "zeroconf/rudel-zeroconf" "\
Add an entry for TYPE with TRANSPORT-BACKEND and PROTOCOL-BACKEND to the list of service types.
TRANSPORT-BACKEND is the name of the transport backend handling
the service type TYPE.
PROTOCOL-BACKEND is the name of the protocol backend handling the
service type TYPE.

\(fn TYPE TRANSPORT-BACKEND PROTOCOL-BACKEND)" nil nil)

(eieio-defclass-autoload 'rudel-zeroconf-backend '(rudel-session-initiation-backend) "zeroconf/rudel-zeroconf" "")

(rudel-add-backend (rudel-backend-get-factory 'session-initiation) 'zeroconf 'rudel-zeroconf-backend)

;;;***

;;;### (autoloads nil nil ("adopted/adopted-compound.el" "adopted/adopted-delete.el"
;;;;;;  "adopted/adopted-insert.el" "adopted/adopted-nop.el" "adopted/adopted-operation.el"
;;;;;;  "adopted/adopted.el" "infinote/rudel-infinote-client.el"
;;;;;;  "infinote/rudel-infinote-display.el" "infinote/rudel-infinote-document.el"
;;;;;;  "infinote/rudel-infinote-errors.el" "infinote/rudel-infinote-group-directory.el"
;;;;;;  "infinote/rudel-infinote-group-document.el" "infinote/rudel-infinote-group-text-document.el"
;;;;;;  "infinote/rudel-infinote-group.el" "infinote/rudel-infinote-node-directory.el"
;;;;;;  "infinote/rudel-infinote-node.el" "infinote/rudel-infinote-state.el"
;;;;;;  "infinote/rudel-infinote-text-document.el" "infinote/rudel-infinote-user.el"
;;;;;;  "infinote/rudel-infinote-util.el" "jupiter/jupiter-compound.el"
;;;;;;  "jupiter/jupiter-delete.el" "jupiter/jupiter-insert.el" "jupiter/jupiter-nop.el"
;;;;;;  "jupiter/jupiter-operation.el" "jupiter/jupiter.el" "obby/rudel-obby-client.el"
;;;;;;  "obby/rudel-obby-debug.el" "obby/rudel-obby-display.el" "obby/rudel-obby-errors.el"
;;;;;;  "obby/rudel-obby-server.el" "obby/rudel-obby-state.el" "obby/rudel-obby-util.el"
;;;;;;  "rudel-autoloads.el" "rudel-chat.el" "rudel-color.el" "rudel-compat.el"
;;;;;;  "rudel-debug.el" "rudel-display.el" "rudel-errors.el" "rudel-hooks.el"
;;;;;;  "rudel-icons.el" "rudel-interactive.el" "rudel-mode.el" "rudel-operations.el"
;;;;;;  "rudel-operators.el" "rudel-overlay.el" "rudel-pkg.el" "rudel-protocol.el"
;;;;;;  "rudel-speedbar.el" "rudel-state-machine.el" "rudel-transport-util.el"
;;;;;;  "rudel-transport.el" "rudel-util.el" "rudel-xml.el" "rudel.el"
;;;;;;  "xmpp/rudel-xmpp-debug.el" "xmpp/rudel-xmpp-sasl.el" "xmpp/rudel-xmpp-state.el"
;;;;;;  "xmpp/rudel-xmpp-tls.el" "xmpp/rudel-xmpp-util.el") (21360
;;;;;;  22138 746854 586000))

;;;***

(provide 'rudel-loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; rudel-loaddefs.el ends here

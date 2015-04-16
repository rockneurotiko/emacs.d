;;; rudel-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "rudel" "rudel.el" (21777 64968 6327 889000))
;;; Generated autoloads from rudel.el

(autoload 'rudel-join-session "rudel" "\
Join the collaborative editing session described by INFO.
INFO is a property list that describes the collaborative editing
session in terms of properties like :host, :port
and :encryption. The particular properties and their respective
meanings depend on the used backend.

When called interactively, all data required to join a session
will be prompted for.

\(fn INFO)" t nil)

(autoload 'rudel-host-session "rudel" "\
Host a collaborative editing session described by INFO.
INFO is a property list that describes the collaborative editing
session to be created in terms of properties like :address, :port
and :encryption. The particular properties and their respective
meanings depend on the used backend.

When called interactively, all data required to host a session
will be prompted for.

\(fn INFO)" t nil)

(autoload 'rudel-leave-session "rudel" "\
Leave the current collaborative editing session.

\(fn)" t nil)

(autoload 'rudel-change-color "rudel" "\
Change the color associated with the local user.
Not all backends support this operation.

\(fn)" t nil)

(autoload 'rudel-subscribe "rudel" "\
Subscribe to DOCUMENT offered by a peer in a collaborative editing session.
When called interactively, DOCUMENT is prompted for interactively.

\(fn DOCUMENT)" t nil)

(autoload 'rudel-publish-buffer "rudel" "\
Make the BUFFER available for subscription to peers in a collaborative editing session.
If BUFFER is nil, the current buffer is used.

\(fn &optional BUFFER)" t nil)

(autoload 'rudel-unsubscribe "rudel" "\
Detaches BUFFER from the collaborative editing session.
The most recent version of the content will remain in the
buffer but not be affected by future changes from other
peers. If BUFFER is nil, the current is used.

\(fn &optional BUFFER)" t nil)

;;;***

;;;### (autoloads nil "rudel-mode" "rudel-mode.el" (21777 64968 796331
;;;;;;  909000))
;;; Generated autoloads from rudel-mode.el

(autoload 'rudel-header-subscriptions-minor-mode "rudel-mode" "\
Toggle Rudel header subscriptions minor mode.

This mode displays users subscribed to the document associated
with the buffer in the header-line. Depending on the kind of
session, additional information like connection status,
encryption or activity indication may be displayed with each
user.

If ARG is null, toggle Rudel header subscriptions mode.
If ARG is a number greater than zero, turn on Rudel header
subscriptions mode; otherwise, turn it off.

\(fn &optional ARG)" t nil)

(defvar global-rudel-header-subscriptions-mode nil "\
Non-nil if Global-Rudel-Header-Subscriptions mode is enabled.
See the command `global-rudel-header-subscriptions-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-rudel-header-subscriptions-mode'.")

(custom-autoload 'global-rudel-header-subscriptions-mode "rudel-mode" nil)

(autoload 'global-rudel-header-subscriptions-mode "rudel-mode" "\
Toggle Rudel-Header-Subscriptions minor mode in all buffers.
With prefix ARG, enable Global-Rudel-Header-Subscriptions mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Rudel-Header-Subscriptions minor mode is enabled in all buffers where
`rudel-header-subscriptions-minor-mode' would do it.
See `rudel-header-subscriptions-minor-mode' for more information on Rudel-Header-Subscriptions minor mode.

\(fn &optional ARG)" t nil)

(autoload 'rudel-mode-line-publish-state-minor-mode "rudel-mode" "\
Toggle Rudel mode line publish state minor mode.

This mode displays an indicator of the buffer's state with
respect to an associated Rudel document in the mode line. If the
buffer has an attached document, the string \"P\" is displayed
after the remote file indicator. Otherwise, the string \"-\" is
displayed.

If ARG is null, toggle Rudel mode line publish state minor mode.
If ARG is a number greater than zero, turn on Rudel minor mode
line publish state mode; otherwise, turn it off.

\(fn &optional ARG)" t nil)

(defvar global-rudel-mode-line-publish-state-mode nil "\
Non-nil if Global-Rudel-Mode-Line-Publish-State mode is enabled.
See the command `global-rudel-mode-line-publish-state-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-rudel-mode-line-publish-state-mode'.")

(custom-autoload 'global-rudel-mode-line-publish-state-mode "rudel-mode" nil)

(autoload 'global-rudel-mode-line-publish-state-mode "rudel-mode" "\
Toggle Rudel-Mode-Line-Publish-State minor mode in all buffers.
With prefix ARG, enable Global-Rudel-Mode-Line-Publish-State mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Rudel-Mode-Line-Publish-State minor mode is enabled in all buffers where
`rudel-mode-line-publish-state-minor-mode' would do it.
See `rudel-mode-line-publish-state-minor-mode' for more information on Rudel-Mode-Line-Publish-State minor mode.

\(fn &optional ARG)" t nil)

(defvar global-rudel-minor-mode nil "\
Non-nil if Global-Rudel minor mode is enabled.
See the command `global-rudel-minor-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-rudel-minor-mode'.")

(custom-autoload 'global-rudel-minor-mode "rudel-mode" nil)

(autoload 'global-rudel-minor-mode "rudel-mode" "\
Toggle global Rudel minor mode (No modeline indicator).

If ARG is null, toggle global Rudel mode.
If ARG is a number greater than zero, turn on global Rudel mode;
otherwise, turn it off.

\\{rudel-minor-keymap}

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "rudel-speedbar" "rudel-speedbar.el" (21777
;;;;;;  64970 309672 938000))
;;; Generated autoloads from rudel-speedbar.el

(autoload 'rudel-speedbar "rudel-speedbar" "\
Show connected users and available documents of Rudel session in speedbar.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("rudel-backend.el" "rudel-chat.el" "rudel-color.el"
;;;;;;  "rudel-compat.el" "rudel-debug.el" "rudel-display.el" "rudel-errors.el"
;;;;;;  "rudel-hooks.el" "rudel-icons.el" "rudel-interactive.el"
;;;;;;  "rudel-loaddefs.el" "rudel-operations.el" "rudel-operators.el"
;;;;;;  "rudel-overlay.el" "rudel-pkg.el" "rudel-protocol.el" "rudel-session-initiation.el"
;;;;;;  "rudel-state-machine.el" "rudel-transport-util.el" "rudel-transport.el"
;;;;;;  "rudel-util.el" "rudel-xml.el") (21777 64974 152345 903000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; rudel-autoloads.el ends here

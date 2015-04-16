;;; ensime.el --- ENhanced Scala Interaction Mode for Emacs
;;
;;;; License
;;
;;     Copyright (C) 2010 Aemon Cannon
;;
;;     This file includes code from slime.el of the SLIME project
;;     (also licensend under the GNU General Public License.) The
;;     following copyrights therefore apply:
;;
;;     Copyright (C) 2003  Eric Marsden, Luke Gorrie, Helmut Eller
;;     Copyright (C) 2004,2005,2006  Luke Gorrie, Helmut Eller
;;     Copyright (C) 2007,2008,2009  Helmut Eller, Tobias C. Rittweiler
;;
;;
;;     This program is free software; you can redistribute it and/or
;;     modify it under the terms of the GNU General Public License as
;;     published by the Free Software Foundation; either version 2 of
;;     the License, or (at your option) any later version.
;;
;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;     GNU General Public License for more details.
;;
;;     You should have received a copy of the GNU General Public
;;     License along with this program; if not, write to the Free
;;     Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
;;     MA 02111-1307, USA.


(eval-and-compile
  (when (<= emacs-major-version 21)
    (error "Ensime requires Emacs 22 or higher")))

(eval-when-compile
  (require 'cl)
  (require 'ensime-macros)
  (require 'ensime-client))

(require 'url-gw)
(require 'dash)
(require 'arc-mode)
(require 'thingatpt)
(require 'comint)
(require 'timer)
(require 'tooltip)
(require 'pp)
(require 'hideshow)
(require 'flymake)
(require 'font-lock)
(require 'auto-complete)
(require 'easymenu)
(require 'ensime-util)
(require 'ensime-vars)
(require 'ensime-config)
(require 'ensime-completion-util)
(require 'ensime-auto-complete)
(require 'ensime-company)
(require 'ensime-sbt)
(require 'ensime-inf)
(require 'ensime-stacktrace)
(require 'ensime-debug)
(require 'ensime-editor)
(require 'ensime-goto-testfile)
(require 'ensime-inspector)
(require 'ensime-mode)
(require 'ensime-model)
(require 'ensime-notes)
(require 'ensime-popup)
(require 'ensime-refactor)
(require 'ensime-startup)
(require 'ensime-undo)
(require 'ensime-search)
(require 'ensime-scalex)
(require 'ensime-doc)
(require 'ensime-semantic-highlight)
(require 'ensime-ui)
(require 'timer)
(eval-when (compile)
  (require 'apropos)
  (require 'compile))

(defvar ensime-protocol-version "0.7")

(defvar ensime-prefer-noninteractive nil
  "State variable used for regression testing.")

(defvar ensime-popup-in-other-frame nil)


;;;###autoload
(defun ensime ()
  "Read config file for settings. Then start an inferior
   ENSIME server and connect to its Swank server."
  (interactive)
  (condition-case ex
      (if ensime-auto-generate-config
          (ensime--maybe-refresh-config
           nil
           'ensime--maybe-update-and-start
           '(lambda (reason) (ensime--maybe-update-and-start)))
        (ensime--maybe-update-and-start))
    ('error (error (format
                    "check that sbt is on your PATH and that your config is compatible with %s [%s]"
                    "http://github.com/ensime/ensime-server/wiki/Example-Configuration-File" ex)))))

;;;###autoload
(defun ensime-remote (host port)
  "Read config file for settings. Then connect to an existing ENSIME server."
  (interactive "shost: \nnport: ")

  (if ensime-auto-generate-config
      (ensime--maybe-refresh-config
       nil
       `(lambda () (ensime--maybe-update-and-start (url-gateway-nslookup-host ,host) ,port))
       `(lambda (reason) (ensime--maybe-update-and-start (url-gateway-nslookup-host ,host) ,port)))))

(provide 'ensime)

;; Local Variables:
;; no-byte-compile: t
;; End:


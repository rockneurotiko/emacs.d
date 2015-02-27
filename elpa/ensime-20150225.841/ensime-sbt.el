;;; ensime-sbt.el --- SBT support for ENSIME
;;
;;;; License
;;
;;     Copyright (C) 2008 Raymond Paul Racine
;;     Portions Copyright (C) Free Software Foundation
;;     Portions Copyright (C) 2010 Aemon Cannon
;;
;;     Authors: Luke Amdor, Raymond Racine, Aemon Cannon
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


;; Support for running sbt in inferior mode.
;; 20090918 Suggestions from Florian Hars
;; - Removed global manipulations.
;; - Removed colorization attempts to use base sbt anis colorization.

(eval-when-compile (require 'cl))
(require 'sbt-mode)

(defgroup ensime-sbt nil
  "Support for sbt build REPL."
  :group 'ensime
  :prefix "ensime-sbt-")

(defcustom ensime-sbt-perform-on-save nil
  "Which (if any) sbt action to perform when a file is saved."
  :type '(choice (const nil) string)
  :group 'ensime-sbt)

(defun ensime-sbt ()
  "Switch to the sbt shell (create if necessary) if or if already there, back.
   If already there but the process is dead, restart the process. "
  (interactive)
  (ensime-with-conn-interactive
   conn
   (with-current-buffer (sbt-start)
     (setq ensime-buffer-connection conn)
     (add-hook 'ensime-source-buffer-saved-hook 'ensime-sbt-maybe-auto-compile)
     (add-hook 'comint-output-filter-functions 'ensime-inf-postoutput-filter))))

(defun ensime-sbt-maybe-auto-compile ()
  (when (and
         (ensime-connected-p)
         ensime-sbt-perform-on-save
         (get-buffer (sbt:buffer-name)))
    (sbt-command ensime-sbt-perform-on-save)))

(defun ensime-sbt-switch ()
  (interactive)
  (ensime-sbt))

(defun ensime-sbt-do-compile ()
  (interactive)
  (sbt-command "compile"))

(defun ensime-sbt-do-run ()
  (interactive)
  (sbt-command "run"))

(defun ensime-sbt-do-clean ()
  (interactive)
  (sbt-command "clean"))

(defun ensime-sbt-do-package ()
  (interactive)
  (sbt-command "package"))

(defun ensime-sbt-do-test ()
  (interactive)
  (sbt-command "test"))

(defun ensime-sbt-do-test-quick ()
  (interactive)
  (sbt-command "testQuick"))

(defun ensime-sbt-do-test-only ()
  (interactive)
  (let* ((impl-class
            (or (ensime-top-level-class-closest-to-point)
                (return (message "Could not find top-level class"))))
	 (cleaned-class (replace-regexp-in-string "<empty>\\." "" impl-class))
	 (command (concat "test-only" " " cleaned-class)))
    (sbt-command command)))

(provide 'ensime-sbt)

;; Local Variables:
;; no-byte-compile: t
;; End:


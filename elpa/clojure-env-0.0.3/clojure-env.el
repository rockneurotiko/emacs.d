;;; clojure-env.el --- manage clojure environments with Emacs  -*- lexical-binding: t -*-

;; Copyright (C) 2014  Nic Ferrier

;; Author: Nic Ferrier <nferrier@ferrier.me.uk>
;; Keywords: languages
;; Package-depends: ((cider "0.6.0")(clojurescript-mode "0.5")(web "0.4.2")(noflet "0.0.8"))
;; Version: 0.0.3

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Clojure has complex external dependencies, not least Clojure
;; itself. For those of us who only use Clojure through Emacs it would
;; be nice to just use Emacs to get Clojure. This package allows that.


;;; Code:

(require 'web)
(require 'noflet)

(defconst clojure-env/lein-url "https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
  "Where to find the Leiningen script.")

(defgroup clojure-env nil
  "Manage a clojure environment."
  :group 'languages)

(defcustom clojure-env-clojurescript-template "mies"
  "What template should be used for ClojureScript projects."
  :group 'clojure-env
  :type 'string)

(defcustom clojure-env-om-template "mies-om"
  "What template should be used for Om projects."
  :group 'clojure-env
  :type 'string)

(defcustom clojure-env-bin-dir "~/.clojure-env/bin"
  "Where binaries we need should be installed."
  :group 'clojure-env
  :type 'directory)

(defun clojure-env/lein-get (&optional next)
  "Get the lein script from github.

Call NEXT when we've got it."
  (web-http-get
   (lambda (con header data)
     (with-current-buffer (get-buffer-create "*clojure-env/lein*")
       (erase-buffer)
       (when data
         (insert data)
         (let ((dir (expand-file-name clojure-env-bin-dir)))
           (make-directory dir t)
           (write-file (expand-file-name "lein" dir))))
       (when (functionp next)
         (funcall next))))
   :url clojure-env/lein-url))

(defun clojure-env/lein-call (args &optional next)
  "Call \"lein\" with ARGS.

If \"lein\" does not exist in `clojure-env-bin-dir' then we get
it.

Once we're done call NEXT if we have it."
  (let ((lein-bin (expand-file-name "lein" clojure-env-bin-dir)))
    (noflet ((action ()
               (set-process-sentinel
                (start-process-shell-command
                 "*clojure-env-lein*" "*clojure-env-lein*"
                 (format "bash %s %s" lein-bin args))
                (lambda (proc evt)
                  (cond
                    ((equal evt "finished\n")
                     (when (functionp next)
                       (funcall next))))))
               (pop-to-buffer (get-buffer "*clojure-env-lein*"))))
      (if (file-exists-p lein-bin)
          (action)
          (clojure-env/lein-get 'action)))))

(defun clojure-env/clojurescript-compile ()
  "Set the `compile-command' for clojurescript."
  (make-variable-buffer-local 'compile-command)
  (setq compile-command 
        (format "bash %s cljsbuild once"
                (expand-file-name "lein" clojure-env-bin-dir))))

;;;###autoload
(defun clojure-env-new-clojurescript (project-name)
  "Make a new ClojureScript project.

Uses `clojure-env-clojurescript-template' as the name of the
leiningen template to use."
  (interactive
   (list
    (read-from-minibuffer "New project name: ")))
  (let ((dir (expand-file-name project-name default-directory)))
    (clojure-env/lein-call
     (format "new %s %s"
             clojure-env-clojurescript-template
             project-name)
     (lambda ()
       (find-file dir)
       ;; How can we call this in a hook with a locate-dominating-file
       ;; check?
       (clojure-env/clojurescript-compile)))))

;;;###autoload
(defun clojure-env-new-om (project-name)
  "Make a new ClojureScript/OM project.

Uses `clojure-env-om-template' as the name of the leiningen
template to use."
  (interactive
   (list
    (read-from-minibuffer "New project name: ")))
  (let ((dir (expand-file-name project-name default-directory)))
    (clojure-env/lein-call
     (format "new %s %s"
             clojure-env-om-template
             project-name)
     (lambda ()
       (find-file dir)
       ;; How can we call this in a hook with a locate-dominating-file
       ;; check?
       (clojure-env/clojurescript-compile)))))

(provide 'clojure-env)

;;; clojure-env.el ends here

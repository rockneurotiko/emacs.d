;;; ensime-config.el
;;
;;;; License
;;
;;     Copyright (C) 2010 Aemon Cannon
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


(eval-and-compile (require 'ensime-macros))

(defvar ensime-config-file-name ".ensime"
  "The default file name for ensime project configurations.")

(add-to-list 'auto-mode-alist '("\\.ensime$" . emacs-lisp-mode))

(defun ensime-config-source-roots (conf)
  "Returns a list of all directories mentioned in :source-roots directives."
  (let ((subs (plist-get conf :subprojects)))
    (-mapcat (lambda (sub) (plist-get sub :source-roots)) subs)))

(defun ensime-config-includes-source-file
    (conf file &optional no-ref-sources)
  "Returns t if the given file is contained in the :source-roots or (if "
  "no-ref-sources is nil) :source-jars-dir of the given project."
  (when file
    (let ((source-roots
	   (-filter
	    'file-directory-p
	    (append (ensime-config-source-roots conf)
		    (unless no-ref-sources
		      (when-let (dir (plist-get conf :source-jars-dir))
				(list dir)))))))
      (-first (lambda (dir) (ensime-path-includes-dir-p file dir))
	      source-roots))))

(defmacro ensime-set-key (conf key val)
  `(setq ,conf (plist-put ,conf ,key ,val)))

(defun ensime-config-find-file (file-name)
  "Search up the directory tree starting at file-name
   for a suitable config file to load, return it's path. Return nil if
   no such file found."
  ;;(ensime-config-find-file "~/projects/ensime/")
  ;;(ensime-config-find-file "~/projects/ensime/src/main")
  ;;(ensime-config-find-file "~/projects/ensime/src/main/scala")
  ;;(ensime-config-find-file "~/projects/ensime/src/main/scala/")
  ;;(ensime-config-find-file "~/projects/ensime/.ensime")
  (let* ((dir (file-name-directory file-name))
	 (possible-path (concat dir ensime-config-file-name)))
    (when (and dir (file-directory-p dir))
      (if (file-exists-p possible-path)
	  possible-path
	(if (not (equal dir (directory-file-name dir)))
	    (ensime-config-find-file (directory-file-name dir)))))))

(defun ensime-config-find (&optional force-dir)
  "Query the user for the path to a config file, then load it."
  (let* ((hint (or force-dir buffer-file-name default-directory))
	 (guess (when hint (ensime-config-find-file hint)))
	 (file (if ensime-prefer-noninteractive
                   guess
		 (read-file-name
		  "ENSIME Project file: "
		  (if guess (file-name-directory guess))
		  guess
		  nil
		  (if guess (file-name-nondirectory guess) "")))))

    (if (and (file-exists-p file)
             (not (file-directory-p file)))
        file
      (warn (concat
              "Could not find an ENSIME project file. "
              "Please see the ENSIME guide: "
              "https://github.com/ensime/ensime-server/wiki/Quick-Start-Guide "
              "for instructions on how to write or "
              "generate a config file."))
      nil)))

(defun ensime-config-load (file-name &optional force-dir)
  "Load and parse a project config file. Return the resulting plist."
  (let ((dir (expand-file-name (file-name-directory file-name)))
	(source-path (or force-dir buffer-file-name default-directory)))
    (save-excursion
      (let ((config
	     (let ((buf (find-file-read-only file-name ensime-config-file-name))
		   (src (buffer-substring-no-properties
			 (point-min) (point-max))))
	       (kill-buffer buf)
	       (condition-case error
		   (read src)
		 (error
		  (error "Error reading configuration file, %s: %s" src error)
		  )))))
        (ensime-set-key config
                        ;; bit of a hack: for extracted sources from jars
                        :source-jars-dir
                        (file-name-as-directory
                         (concat dir
                                 (file-name-as-directory ".ensime_cache/dep-src")
                                 (file-name-as-directory "source-jars"))))
        config))))


(defun ensime-source-roots-from-config ()
  "Return all source directories from all subprojects"
  (-flatten
   (mapcar
    (lambda (m) (plist-get m :source-roots))
    (plist-get (ensime-config (ensime-connection)) :subprojects))))

(provide 'ensime-config)

;; Local Variables:
;; no-byte-compile: t
;; End:


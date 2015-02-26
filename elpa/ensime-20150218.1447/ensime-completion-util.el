;;; ensime-completion-util.el
;;
;;;; License
;;
;;     Copyright (C) 2015 Aemon Cannon
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

(defun ensime--annotate-completions (completions)
  "Maps plist structures to propertized strings that will survive
 being passed through the innards of auto-complete or company."
  (mapcar
   (lambda (m)
     (let* ((type-sig (plist-get m :type-sig))
	    (type-id (plist-get m :type-id))
	    (is-callable (plist-get m :is-callable))
	    (to-insert (plist-get m :to-insert))
	    (name (plist-get m :name))
	    (candidate name))
       (propertize candidate
		   'symbol-name name
		   'type-sig type-sig
		   'type-id type-id
		   'is-callable is-callable
		   'to-insert to-insert
		   ))) completions))

(defconst ensime--prefix-char-class "[a-zA-Z\\$0-9_#:<=>@!%&*+/?\\\\^|~-]")
(defun ensime-completion-prefix-at-point ()
  "Returns the prefix to complete."
  ;; A bit of a hack: Piggyback on font-lock's tokenization to
  ;; avoid requesting completions when inside comments.
  (when (not (ensime-in-comment-p (point)))
    ;; As an optimization, first get an upper bound on the length of prefix using
    ;; ensime--prefix-char-class. Emacs's looking-back function is sloooooww.
    (let ((i (point)))
      (while (and (> i 1) (string-match ensime--prefix-char-class (char-to-string (char-before i))))
	(decf i))
      (let ((s (buffer-substring-no-properties i (point))))
	;; Then use a proper scala identifier regex to verify.
	(if (string-match (concat scala-syntax:plainid-re "\\'") s)
	    (match-string 1 s) "")))))

(defun ensime-get-completions-async
    (max-results case-sense callback)
  (ensime-rpc-async-completions-at-point max-results case-sense
   (lexical-let ((continuation callback))
     (lambda (info)
       (let* ((candidates (ensime--annotate-completions
			   (plist-get info :completions))))
	 (funcall continuation candidates))))))

(defun ensime-get-completions (max-results case-sense)
  (let* ((info
	  (ensime-rpc-completions-at-point
	   max-results case-sense))
	 (result (list :prefix (plist-get info :prefix)
		       :candidates (ensime--annotate-completions
				    (plist-get info :completions)))))
    result))

(defun ensime-unique-candidate-at-point ()
  "If the identifier preceding point is already complete, returns it as a fully
 annotated candidate. Otherwise returns nil."
  (let ((prefix (ensime-completion-prefix-at-point)))
    (when (> (length prefix) 0)
      (let* ((info (ensime-rpc-completions-at-point
		    2 ensime-company-case-sensitive))
	     (candidates (ensime--annotate-completions (plist-get info :completions))))
	(when (and (= (length candidates) 1)
		   (string= prefix (car candidates)))
	  (car candidates))))))

(defun ensime-completion-at-point-function ()
  "Standard Emacs 24+ completion function, handles completion-at-point requests.
 See: https://www.gnu.org/software/emacs/manual/html_node/elisp/Completion-in-Buffers.html"
  (when (ensime-connected-p)
    (let* ((prefix (ensime-completion-prefix-at-point))
	   (start (- (point) (length prefix)))
	   (end (point))
	   (props '(:annotation-function
		    (lambda (m)
		      (when (get-text-property 0 'is-callable m)
			(ensime-brief-type-sig
			 (get-text-property 0 'type-sig m))))
		    :exit-function
		    (lambda (m status)
		      (when (eq status 'finished)
			(ensime-ac-complete-action m)))))
	   (completion-func
	    (lambda (prefix pred action)
	      (cond
	       ((eq action 'metadata)
		'(metadata . ((display-sort-function . identity))))
	       (t
		(complete-with-action
		 action (plist-get (ensime-get-completions 1000000 nil)
				   :candidates) prefix pred))))))
      `(,start ,end ,completion-func . ,props))))

(provide 'ensime-completion-util)

;; Local Variables:
;; no-byte-compile: t
;; End:

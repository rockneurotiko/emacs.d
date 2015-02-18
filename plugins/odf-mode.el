;;;; odf-mode.el -- Support for Open Document Format files
;;; Time-stamp: <2006-05-26 19:43:04 john>

;;  This program is free software; you can redistribute it and/or modify it
;;  under the terms of the GNU General Public License as published by the
;;  Free Software Foundation; either version 2 of the License, or (at your
;;  option) any later version.

;;  This program is distributed in the hope that it will be useful, but
;;  WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  General Public License for more details.

;;  You should have received a copy of the GNU General Public License along
;;  with this program; if not, write to the Free Software Foundation, Inc.,
;;  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

(provide 'odf-mode)
(require 'xml)

(defun odf-unzipped-directory (file)
  "Return the filename for unzipping FILE into."
  (concat file "_internals"))

(defun odf-unzip (file)
  "Unzip FILE and return the directory it went into."
  (let ((dir (odf-unzipped-directory file)))
    (shell-command (format "unzip -d %s %s" dir file))
    dir))

(defun odf-rezip (file)
  "Rezip FILE from its directory form."
  (let ((dir (odf-unzipped-directory file)))
    (message "rezipping from directory %s to file %s" dir file)
    (shell-command (format "zip -r %s %s" file dir))
    dir))

(mapcar 'make-variable-buffer-local '(odf-master-file
                                      odf-content-overlays))

(defun odf-mode ()
  "Major mode for reading Open Document Format files."
  (interactive)
  (kill-all-local-variables)
  (let* ((dir (odf-unzip buffer-file-name))
         (content-file (expand-file-name "content.xml" dir))
         (styles-file (expand-file-name "styles.xml" dir))
         ;; (raw-styles (xml-parse-file styles-file))
         (meta-file (expand-file-name "meta.xml" dir))
         (settings-file (expand-file-name "settings.xml" dir))
         (internals (directory-files dir t))
         (master-file buffer-file-name)
         (master-file-directory (file-name-directory master-file)))
    ;; (message "That contains %S" internals)
    (setq major-mode 'odf-mode
          mode-name "Odf"
          content-buffer (find-file-noselect content-file)
          styles-buffer (find-file-noselect styles-file)
          settings-buffer (find-file-noselect settings-file)
          meta-buffer (find-file-noselect meta-file))
    (mapcar (lambda (buffer)
              (set-buffer buffer)
              (setq odf-master-file master-file)
              (cd master-file-directory))
            (list content-buffer styles-buffer settings-buffer meta-buffer))
    (switch-to-buffer content-buffer)))

(add-to-list 'auto-mode-alist (cons "\\.sxw$" 'odf-mode))
(add-to-list 'auto-mode-alist (cons "content.xml" 'odf-content-mode))
(add-to-list 'auto-mode-alist (cons "styles.xml" 'odf-styles-mode))
(add-to-list 'auto-mode-alist (cons "meta.xml" 'odf-meta-mode))
(add-to-list 'auto-mode-alist (cons "settings.xml" 'odf-settings-mode))

(define-derived-mode odf-styles-mode
  sgml-mode
  "OpenDocumentStyles"
  "Major mode for the styles part of an OpenDocumentFormat file."
  (add-hook 'after-save-hook 'odf-write-file-function t t))

(define-derived-mode odf-meta-mode
  sgml-mode
  "OpenDocumentMeta"
  "Major mode for the meta part of an OpenDocumentFormat file."
  (add-hook 'after-save-hook 'odf-write-file-function t t))

(define-derived-mode odf-settings-mode
  sgml-mode
  "OpenDocumentSettings"
  "Major mode for the settings part of an OpenDocumentFormat file."
  (add-hook 'after-save-hook 'odf-write-file-function t t))

(defvar odf-mode-tags-invisible nil
  "Whether tags are invisible")

(make-variable-buffer-local 'odf-mode-tags-invisible)

(defun odf-mode-toggle-tag-visibility (&optional arg)
  "Set whether tags are visible."
  (interactive "P")
  (setq odf-mode-tags-invisible 
        (if (null arg)
            (not odf-mode-tags-invisible)
          (> (prefix-numeric-value arg) 0)))
  (if odf-mode-tags-invisible
      (add-to-invisibility-spec 'odf-mode-tags-invisible)
    (remove-from-invisibility-spec 'odf-mode-tags-invisible)))

(defun odf-mode-open-paragraph (type options tag-start tag-end)
  "Open a paragraph."
  (let* ((overlay (make-overlay tag-start tag-end)))
    (overlay-put overlay 'after-string "\n\n")
    (overlay-put overlay 'invisible 'odf-mode-tags-invisible)
    overlay))

(defun odf-mode-close-paragraph (end-start end-end type options start-start start-end)
  "Close a paragraph."
  (let* ((raw-xml (save-excursion
                    (goto-char start-start)
                    (if (search-forward " " start-end t)
                        (xml-parse-attlist start-end)
                      nil)))
         (style-name (cdr (assoc 'text:style-name raw-xml)))
         (style (cdr (assoc style-name odf-mode-styles)))
         (is-bold (cdr (assoc 'bold (cddr style))))
         (is-italic (cdr (assoc 'italic (cddr style))))
         (overlay (make-overlay tag-start tag-end)))
    (message "paragraph: bold=%S italic=%S" is-bold is-italic)
    (overlay-put overlay 'after-string "\n\n")
    (overlay-put overlay 'invisible 'odf-mode-tags-invisible)
    overlay))

(defun odf-mode-close-span (end-start end-end type options start-start start-end)
  "Close a span."
  (let* ((raw-xml (save-excursion
                    (goto-char start-start)
                    (if (search-forward " " start-end t)
                        (xml-parse-attlist start-end)
                      nil)))
         (style-name (cdr (assoc 'text:style-name raw-xml)))
         (style (cdr (assoc style-name odf-mode-styles)))
         (style-properties (cadr style))
         (is-bold (cdr (assoc 'bold style-properties)))
         (is-italic (cdr (assoc 'italic style-properties))))
    (if is-italic
        (if is-bold
            (put-text-property start-end end-start 'face (cons 'bold-italic t))
          (put-text-property start-end end-start 'face (cons 'italic t)))
      (if is-bold
          (put-text-property start-end end-start 'face (cons 'bold t))
        (put-text-property start-end end-start 'face (cons 'normal t))))

    (message "span: raw=%S style-name=%S style=%S style-properties=%S bold=%S italic=%S" raw-xml style-name style style-properties is-bold is-italic)
    nil))

(defun odf-mode-open-ordered-list (type options start end)
  "Process the start of an ordered list."
  (setq odf-mode-open-lists (cons 0 odf-mode-open-lists))
  nil)

(defun odf-mode-open-unordered-list (type options start end)
  "Process the start of an ordered list."
  (setq odf-mode-open-lists (cons t odf-mode-open-lists))
  nil)

(defun odf-mode-close-ordered-list (end-start end-end type options start-start start-end)
  "Process the end of an ordered list."
  (setq odf-mode-open-lists (cdr odf-mode-open-lists))
  nil)

(defun odf-mode-close-unordered-list (end-start end-end type options start-start start-end)
  "Process the end of an unordered list."
  (setq odf-mode-open-lists (cdr odf-mode-open-lists))
  nil)

(defun odf-mode-open-list-item (type options start end)
  "Process the start of a list item."
  (let ((overlay (make-overlay start end))
        (item-count (car odf-mode-open-lists)))
    ;; (message "Marking list item at %d..%d" start end)
    (if (integerp item-count)
        (progn
          (setq item-count (1+ item-count))
          (rplaca odf-mode-open-lists item-count)
          (overlay-put overlay 'after-string (format "\n %d " item-count)))
      (overlay-put overlay 'after-string "\n * "))
    (overlay-put overlay 'invisible 'odf-mode-tags-invisible)
    overlay))

(defvar odf-mode-styles nil
  "Styles found in this document.")

(defvar odf-mode-list-styles nil
  "List styles found in this document.")

(mapcar 'make-variable-buffer-local '(odf-mode-styles odf-mode-list-styles))

(defun odf-mode-close-automatic-styles (end-start end-end
                                                  type
                                                  options
                                                  start-start start-end)
  "On finding the close of an automatic-styles tag, read the styles from that tagged text."
  ;; (message "About to parse %d..%d" start-start end-end)
  (let* ((auto-styles (save-excursion (goto-char start-start)
                                      (xml-parse-tag end-end))))
    ;; (message "Auto-styles are %S" auto-styles)
    (setq auto-styles (cddr auto-styles))
    (while auto-styles
      (let* ((style (car auto-styles))
             (style-type (car style))
             (style-name (cdr (assoc 'style:name
                                     (cadr style)))))
        (cond
         ((eq style-type 'style:style)
          (let* ((style-properties (cadr (assoc 'style:properties
                                                (cddr style))))
                 (is-bold (string= (cdr (assoc 'fo:font-weight style-properties))
                                   "bold"))
                 (is-italic (string= (cdr (assoc 'fo:font-style style-properties))
                                     "italic")))
            (message "style %S with properties %S %s %s"
                     style-name style-properties
                     (if is-bold "bold" "normal")
                     (if is-italic "italic" "upright"))
            (setq odf-mode-styles
                  (cons (list style-name style
                              (list (cons 'bold is-bold)
                                    (cons 'italic is-italic)))
                        odf-mode-styles))))
         ((eq style-type 'text:list-style)
          (let* ((marker (caar (cddr style)))
                 (is-numeric (eq marker 'text:list-level-style-number)))
            (message "list style %S with marker %S" style-name marker)
            (setq odf-mode-list-styles
                  (cons (list style-name style (list (cons 'numeric is-numeric)))
                        odf-mode-list-styles))
            ))))
      (setq auto-styles (cdr auto-styles)))

    )
  nil)

(defvar odf-mode-unitary-tags
  '()
  "Alist of handlers for unitary tags.
The cars should be tag names as strings, and the cdrs should be
functions taking the tag type, options, and the start and end positions.
The functions should return an overlay if they have created one, and
otherwise return nil.")

(defvar odf-mode-open-tags
  '(("text:p" . odf-mode-open-paragraph)
    ("text:list-item" . odf-mode-open-list-item)
    ("text:ordered-list" . odf-mode-open-ordered-list)
    ("text:unordered-list" . odf-mode-open-unordered-list))
  "Alist of handlers for open tags.
The cars should be tag names as strings, and the cdrs should be
functions taking the tag type, options, and the start and end positions.
The functions should return an overlay if they have created one, and
otherwise return nil.")

(defvar odf-mode-close-tags
  '(("text:p" . odf-mode-close-paragraph)
    ("text:span" . odf-mode-close-span)
    ("office:automatic-styles" . odf-mode-close-automatic-styles))
  "Alist of handlers for close tags.
The cars should be tag names as strings, and the cdrs should be
functions taking the start and end positions of the tag, and the tag
type, options, and start and end positions for the corresponding open
tag.
The functions should return an overlay if they have created one, and
otherwise return nil.")

(defun odf-write-file-function ()
  "After saving part of an ODF document, recreate the ODF file."
  (message "Repacking ODF zip file %S" odf-master-file)
  (odf-rezip odf-master-file))

(defvar odf-mode-open-lists nil
  "A list of any lists (ordered or unordered) that are open in this buffer.
Beginning an unordered list pushes t onto this list;
beginning an ordered list pushes 0 onto it;
a list item increments the head of the list if it is a number;
ending a list pops an item from this list.")

(make-variable-buffer-local 'odf-mode-open-lists)

(defcustom odf-mode-colour-tags t
  "Whether to colour in the XML tags.
Will not normally matter, as you mostly keep them hidden.
However, it reveals the structure nicely, for debugging.")

(defun odf-content-cancel-overlays ()
  "Cancel the overlays in the current buffer."
  (mapcar 'delete-overlay odf-content-overlays)
  (setq odf-content-overlays nil))

(defcustom odf-tag-peep 0
  "How much of each tag to show at each end.")

(defvar odf-content-mode-map (make-sparse-keymap "Open Document Format content")
  "Keymap for odf-content-mode")

(define-key odf-content-mode-map "\C-ct" 'odf-mode-toggle-tag-visibility)

(define-derived-mode odf-content-mode
  ;; sgml-mode
  fundamental-mode
  ;; (use-local-map odf-content-mode-map)
  "OpenDocumentContents"
  "Major mode for the contents part of an OpenDocumentFormat file."
  (font-lock-mode -1)
  (add-hook 'change-major-mode-hook 'odf-content-cancel-overlays nil t)
  (let* ((open-tags nil)
         (all-odf-tags nil)
         (modified (buffer-modified-p)))
    (when odf-master-file
      (rename-buffer (format "%s-Content"
                             (file-name-nondirectory odf-master-file))))
    (odf-content-cancel-overlays)
    (odf-mode-toggle-tag-visibility 1)
    (setq require-final-newline nil
          odf-mode-open-lists nil
          odf-mode-styles nil
          odf-mode-list-styles nil)
    (add-hook 'after-save-hook 'odf-write-file-function t t)
    (goto-char (point-min))
    (while (re-search-forward "<\\([!/]?\\)\\([-!/:A-Za-z0-9]+\\)\\([^>]*\\)>" (point-max) t)
      (let* ((tag-start (match-beginning 0))
             (tag-end (match-end 0))
             (is-ender-string (match-string-no-properties 1))
             (tag-type (match-string-no-properties 2))
             (tag-options (match-string-no-properties 3))
             (is-unitary (or (string-match "/$" tag-options)
                             (string-match "/$" tag-type)
                             (string-match "[!?]" is-ender-string)))
             (is-ender (and (not is-unitary)
                            (string= is-ender-string "/"))))
        ;; (message "tag-type=%S tag-options=%S is-ender-string=%S is-unitary=%S" tag-type tag-options is-ender-string is-unitary)
        (when odf-mode-colour-tags
          (put-text-property tag-start tag-end
                             'face (cons 'background-color
                                         (if is-unitary
                                             "cyan"
                                           (if is-ender
                                               "pink"
                                             "pale green")))))
        (setq all-odf-tags
              ;; Give the tag-handlers a chance to return something to
              ;; put on the list; otherwise, we will record a cons of
              ;; the start and end of the tag, that later gets used to
              ;; put "invisible" and "intangible" text properties on
              ;; the tag in the buffer.

              ;; I'm now not sure about the following:

              ;; This is because, inconsistently, GNUemacs will
              ;; display the before and after strings of an overlay if
              ;; the text under the overlay is made invisible by the
              ;; overlay, but not if the text is made invisible by a
              ;; text property in the buffer. Therefore, any tags that
              ;; we want to display specially by hiding them and
              ;; setting an after string, must be made invisible by a
              ;; property of the overlay we use to hold the after
              ;; string. I presume that using overlays for properties
              ;; has more overhead than putting the properties
              ;; straight in the buffer, so I use text properties
              ;; wherever I don't have to use an overlay.

              ;; In fact, I think it's to do with having lots of
              ;; invisible bits all butting up against each other.
              ;; More thought needed. I might have to make the space
              ;; between the tag name and the tag options visible, and
              ;; use that as visible text to put the overlay on to get
              ;; its before and strings shown!
              (cons
               (or
                (if is-unitary
                    (let ((handler (cdr (assoc tag-type odf-mode-unitary-tags))))
                      (message "Unitary tag %S at %d (%d)" tag-type tag-start (length open-tags))
                      (if handler
                          (funcall handler tag-type tag-options tag-start tag-end)
                        nil))
                  (if is-ender
                      (let ((handler (cdr (assoc tag-type odf-mode-close-tags)))
                            (latest-tag (car open-tags)))
                        (message "Closing %S at %d (%d)" tag-type tag-end (length open-tags))
                        (unless (string= (car latest-tag)
                                         tag-type)
                          (message "Closing %S at %S but open was %S at %S"
                                   tag-type tag-end (car latest-tag) (nth 2 latest-tag)))
                        (setq open-tags (cdr open-tags))
                        (if handler
                            (apply handler tag-start tag-end latest-tag)
                          nil))
                    (let ((handler (cdr (assoc tag-type odf-mode-open-tags))))
                      (message "Opening %S with %S at %d (%d)" tag-type tag-options tag-start (length open-tags))
                      (setq open-tags
                            (cons (list tag-type tag-options tag-start tag-end)
                                  open-tags))
                      (if handler
                          (funcall handler tag-type tag-options tag-start tag-end)
                        nil))))
                (cons tag-start tag-end))
               all-odf-tags))
        (cond
         ((string= tag-type "text:p")
          )
         ((string= tag-type "text:line")
          (setq overlay (make-overlay tag-start tag-end))
          (overlay-put overlay 'after-string "\n")))))
    (message "Marking tags %S" all-odf-tags)
    (while all-odf-tags
      (let ((tag (car all-odf-tags)))
        (message "Marking tag %S" tag)
        (cond
         ((consp tag)
          (put-text-property (+ (car tag) odf-tag-peep) (- (cdr tag) odf-tag-peep) 'invisible 'odf-mode-tags-invisible)
          (put-text-property (+ (car tag) odf-tag-peep) (- (cdr tag) odf-tag-peep) 'intangible t))
         ((overlayp tag)
          (setq odf-content-overlays (cons tag odf-content-overlays)))))
      (setq all-odf-tags (cdr all-odf-tags)))
    (set-buffer-modified-p modified)))

;;; end of odf-mode.el

(use-package mcp-hub
  :ensure t
  :straight (mcp-hub :host github :repo "lizqwerscott/mcp.el" :files ("*.el"))
  :custom
n  (mcp-hub-servers '(("tidewave" . (:url "http://localhost:4000/tidewave/mcp?include_fs_tools=true")))))

(defun gptel-mcp-register-tool ()
  (interactive)
  (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
    (mapcar #'(lambda (tool)
                (apply #'gptel-make-tool
                       tool))
            tools)))

(defun gptel-mcp-use-tool ()
  (interactive)
  (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
    (mapcar #'(lambda (tool)
                (let ((path (list (plist-get tool :category)
                                  (plist-get tool :name))))
                  (push (gptel-get-tool path)
                        gptel-tools)))
            tools)))

(defun gptel-mcp-close-use-tool ()
  (interactive)
  (let ((tools (mcp-hub-get-all-tool :asyncp t :categoryp t)))
    (mapcar #'(lambda (tool)
                (let ((path (list (plist-get tool :category)
                                  (plist-get tool :name))))
                  (setq gptel-tools
                        (cl-remove-if #'(lambda (tool)
                                          (equal path
                                                 (list (gptel-tool-category tool)
                                                       (gptel-tool-name tool))))
                                      gptel-tools))))
            tools)))


(use-package gptel
  :ensure t
  :config
  (setq
   gptel-model 'claude-3-sonnet-20240229 ;  "claude-3-opus-20240229" also available
   gptel-backend (gptel-make-anthropic "Claude" :stream t :key (efs/lookup-password :host "aider.chat" :user "anthropic"))    )
  ;; gptel-directives
  (add-to-list 'gptel-directives '(itinerarycore . "This is a Phoenix application, which uses Bootstrap and AlpineJS. Prefer using LiveView instead of regular Controllers. Once you are done with changes, run `mix compile` and fix any issues. Write tests for your changes and run `mix test` afterwards. Do not commit your changes to git."))
  )

(provide 'mcp-settings)

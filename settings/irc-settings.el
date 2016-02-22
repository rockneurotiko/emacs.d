;; circe

;; (eval-after-load "erc"
;;     '(progn
;;          (setq erc-nick "rockneurotiko")
;;          (setq erc-user-full-name "Rock Neurotiko")
;;          (setq erc-autojoin-channels-alist
;;                '(("freenode.net" "##plig" ))))) ;; "#python" "#haskell" "##typetheory" "#scala" "#julia" )))))

(defun my-erc ()
    "Connect IRC with SSL"
    ;; (interactive)
    ;; (erc-tls :server "irc.freenode.net" :port 7000)
    )

(provide 'irc-settings)

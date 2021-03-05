;; (use-package spotify
;;   :ensure t
;;   :config
;;   ;; (spotify-enable-song-notifications)
;;   :bind (("C-c s n" . spotify-next)
;;          ("C-c s p" . spotify-previous)
;;          ("C-c s t" . spotify-play)
;;          ;; ("C-c s c" . spotify-current)
;;          ;; ("C-c s v" . spotify-enable-song-notifications)
;;          ;; ("C-c s m" . spotify-disable-song-notifications)
;;          )
;;   )

(add-to-list 'load-path "~/Git/spotify.el")
(require 'spotify)

;; Settings
(setq spotify-oauth2-client-id "91703f58ceb94f6b9ec6ec39bc81d6ce")
(setq spotify-oauth2-client-secret "130de46c64c44e0c99f82578a4bd9f7d")
(setq spotify-transport 'apple)

(global-set-key (kbd "C-c s n") 'spotify-next-track)
(global-set-key (kbd "C-c s p") 'spotify-previous-track)
(global-set-key (kbd "C-c s t") 'spotify-toggle-C)
;; ("play-c s c" . spotify-current)

;; (define-key spotify-mode-map (kbd "C-c s") 'spotify-command-map)

;; (use-package multi
;;   :ensure t)

;; (use-package helm-spotify
;;   :ensure t
;;   :bind (("C-c s h" . helm-spotify)))

(provide 'spotify-settings)

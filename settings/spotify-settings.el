(use-package spotify
  :ensure t
  :config (spotify-enable-song-notifications)
  :bind (("C-c s n" . spotify-next)
         ("C-c s p" . spotify-previous)
         ("C-c s p" . spotify-playpause)
         ("C-c s c" . spotify-current)
         ("C-c s n" . spotify-enable-song-notifications)
         ("C-c s m" . spotify-disable-song-notifications)))


(provide 'spotify-settings)

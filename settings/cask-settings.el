;; -*- lexical-binding: t; -*-
(when (file-readable-p "~/.cask/cask.el")
  (require 'cask "~/.cask/cask.el")
  (cask-initialize))

(provide cask-settings)

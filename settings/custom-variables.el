(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#eaeaea" "#d54e53" "#b9ca4a" "#e7c547" "#7aa6da" "#c397d8" "#70c0b1" "#000000"))
 '(auto-indent-assign-indent-level 2)
 '(auto-indent-disabled-indent-functions (quote (indent-relative indent-relative-maybe)))
 '(auto-indent-disabled-modes-list
   (quote
    (compilation-mode conf-windows-mode diff-mode inferior-ess-mode dired-mode eshell-mode markdown-mode fundamental-mode log-edit-mode makefile-gmake-mode org-mode snippet-mode texinfo-mode text-mode wl-summary-mode elm-mode)))
 '(auto-indent-on-visit-file t)
 '(company-backends
   (quote
    (company-elm company-ghc merlin-company-backend company-bbdb company-nxml company-css company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
                 (company-dabbrev-code company-gtags company-keywords)
                 company-oddmuse company-dabbrev)))
 '(company-ghc-show-info t)
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12" default)))
 '(elfeed-feeds
   (quote
    ("http://prog21.dadgum.com/atom.xml" "http://syntaxexclamation.wordpress.com/feed/" "http://blog.emillon.org/rss.xml" "http://why-lambda.blogspot.com/feeds/posts/default" "http://sigfpe.blogspot.com/feeds/posts/default" "http://psnively.github.com/atom.xml" "http://edwinb.wordpress.com/feed/" "http://existentialtype.wordpress.com/feed/" "http://brianmckenna.org/blog/feed" "http://queuea9.wordpress.com/feed/" "http://zenzike.com/rss.xml" "http://lambda.jstolarek.com/feed/" "http://monoidal.blogspot.com/feeds/posts/default" "http://spire-lang.org/atom.xml" "http://typesandkinds.wordpress.com/feed/" "http://homotopytypetheory.org/feed/" "http://arcanesentiment.blogspot.com/feeds/posts/default" "http://paolocapriotti.com/atom.xml" "http://semantic-domain.blogspot.com/feeds/posts/default" "http://comonad.com/reader/feed/" "http://jozefg.bitbucket.org/rss.xml" "http://math.andrej.com/feed/" "http://www.lpw25.net/rss.xml" "http://ocaml.janestreet.com/?q=rss.xml" "http://jeremykun.wordpress.com/feed/" "http://twanvl.nl/feed" "http://bartoszmilewski.wordpress.com/feed/" "http://kwangyulseo.com/feed/" "http://www.haskellforall.com/feeds/posts/default" "http://conal.net/blog/feed/" "https://golem.ph.utexas.edu/category/atom10.xml" "http://requestforlogic.blogspot.com/feeds/posts/default" "http://chromaticleaves.com/rss.xml" "http://feeds.feedburner.com/ezyang" "http://raichoo.github.io/feed.rss" "http://bentnib.org/posts.rss.xml" "http://www.simonjf.com/wordpress/?feed=rss2" "http://gallium.inria.fr/~scherer/gagallium/index.rss" "http://anil.recoil.org/feeds/atom.xml" "http://blog.higher-order.com/atom.xml" "http://bitemyapp.com/rss.xml" "http://mazzo.li/rss.xml" "http://infinitecardinals.wordpress.com/feed/" "http://www.stephanboyer.com/feeds/posts/default")))
 '(fci-rule-color "#424242")
 '(haskell-mode-hook (quote (turn-on-haskell-doc)))
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote stack-ghci))
 '(ido-everywhere t)
 '(js2-include-jslint-globals t)
 '(lisp-body-indent 2)
 '(multi-term-buffer-name "term" t)
 '(multi-term-program "/bin/zsh" t)
 '(org-emphasis-alist
   (quote
    (("*" bold)
     ("/" italic)
     ("_" underline)
     ("=" org-verbatim verbatim)
     ("~" org-code verbatim)
     ("+"
      (:strike-through t)))))
 '(org-taskjuggler-default-global-properties
   "shift s40 \"Part time shift\" {
  workinghours wed, thu, fri off
}

vacation \"Semana Santa\" 2016-03-21 - 2016-03-29
vacation \"Actividades complementarias\" 2016-03-14 - 2016-03-19
vacation \"Independencia madrid\" 2016-05-01 - 2016-05-03
vacation \"Fiesta\" 2016-05-15 - 2016-05-17
vacation \"fiesta 1\" 2016-03-07

")
 '(package-selected-packages
   (quote
    (alchemist emojify lua-mode cider clojure-mode-extra-font-locking paredit clojure-mode flycheck-elm elm-mode racer rust-mode flycheck-haskell shm hindent hi2 ghc haskell-mode virtualenvwrapper pydoc-info ein elpy rainbow-delimiters emacs-eclim ensime scala-mode scala-mode2 go-autocomplete go-snippets go-projectile go-mode tern jasminejs-mode json-mode php-mode js2-refactor js2-mode web-mode nodejs-repl emmet-mode flycheck company helm-spotify multi spotify magit-gh-pulls magit cheatsheet yasnippet helm-projectile projectile smartparens sx ranger switch-window helm-systemd discover-my-major which-key multiple-cursors auto-complete smooth-scrolling puml-mode plantuml-mode git-gutter-fringe+ auto-indent-mode undo-tree miniedit decide calfw org-tree-slide helm-flyspell ox-reveal htmlize org-ref helm-bibtex org-bullets multi-term color-theme-sanityinc-tomorrow powerline ace-jump-helm-line helm-swoop helm-descbinds helm auto-compile use-package)))
 '(python-indent-guess-indent-offset nil)
 '(python-indent-offset 4)
 '(python-shell-interpreter "ipython")
 '(python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: ")
 '(python-shell-prompt-regexp "In \\[[0-9]+\\]: ")
 '(tegmacs-server-buffer-name "<tegmacs> {host}:{port}")
 '(term-default-bg-color nil)
 '(term-default-fg-color "#00FF05")
 '(tss-project nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#d54e53")
     (40 . "#e78c45")
     (60 . "#e7c547")
     (80 . "#b9ca4a")
     (100 . "#70c0b1")
     (120 . "#7aa6da")
     (140 . "#c397d8")
     (160 . "#d54e53")
     (180 . "#e78c45")
     (200 . "#e7c547")
     (220 . "#b9ca4a")
     (240 . "#70c0b1")
     (260 . "#7aa6da")
     (280 . "#c397d8")
     (300 . "#d54e53")
     (320 . "#e78c45")
     (340 . "#e7c547")
     (360 . "#b9ca4a"))))
 '(vc-annotate-very-old-color nil)
 '(web-mode-css-indent-offset 2)
 '(web-mode-enable-auto-expanding t)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(web-mode-comment-face ((t (:foreground "#6c6c6c")))))

;; (provide 'custom-variables)

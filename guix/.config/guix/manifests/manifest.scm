(specifications->manifest (list "git"
                                "git-lfs"
                                "openssh"

                                "gnupg"

                                "flatpak"

                                "glibc-locales" ; Important, otherwise
                                                ; $LANG and $LC_* does
                                                ; not work in Guix.
                                                ; https://guix.gnu.org/manual/devel/en/html_node/Application-Setup.html#Locales-1

                                "icecat"
                                "ungoogled-chromium"

                                "keepassxc"

                                "stow"

                                "vim"
                                "unzip"
                                "sqlite"

				"the-silver-searcher"

                                "emacs"
                                "emacs-pdf-tools"
                                "emacs-org-auto-tangle"
                                "mu"
                                "font-fira-code"
                                "emacs-spacemacs-theme"
                                "emacs-hl-todo"
                                "emacs-spaceline"

                                "hunspell"
                                "hunspell-dict-de"
                                "hunspell-dict-en-us"
                                "hunspell-dict-en-gb"

                                "autojump"

                                ))

(specifications->manifest (list "git"
                                "git-lfs"
                                "openssh"

                                "gnupg"
                                "pinentry"

                                "glibc-locales" ; Important, otherwise
                                                ; $LANG and $LC_* does
                                                ; not work in Guix.
                                                ; https://guix.gnu.org/manual/devel/en/html_node/Application-Setup.html#Locales-1

                                "icecat"

                                "keepassxc"

                                "stow"

                                "vim"
                                "unzip"

                                "emacs"
                                "emacs-pdf-tools"
                                "emacs-org-auto-tangle"
                                "mu"
                                "font-fira-code"
                                "emacs-spacemacs-theme"
                                "emacs-hl-todo"
                                "emacs-spaceline"
                                "hunspell" "hunspell-dict-de"

                                ))

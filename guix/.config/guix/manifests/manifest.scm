;; What follows is a "manifest" equivalent to the command line you gave.
;; You can store it in a file that you may then pass to any 'guix' command
;; that accepts a '--manifest' (or '-m') option.

(specifications->manifest (list "git"
                                "openssh"

                                "gnupg"
                                "pinentry"

                                "icecat"
                                "ungoogled-chromium"
                                "pavucontrol"
                                "xbindkeys"
                                "polybar"
                                "turbovnc"
                                "brightnessctl"

                                "keepassxc"

                                "polybar"
                                "kitty"
                                "rofi"

                                "stow"

                                "vim"
                                "unzip"
                                "sqlite"

                                "emacs"
                                "emacs-pdf-tools"
                                "emacs-org-auto-tangle"
                                "mu"
                                "font-fira-code"
                                "emacs-spacemacs-theme"
                                "emacs-hl-todo"
                                "emacs-spaceline"
                                "hunspell" "hunspell-dict-de"

                                "pulseaudio"))

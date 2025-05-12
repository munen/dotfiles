source ~/.profile

# smart-case and use user
alias ag='ag -S --pager=less'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

# History, near infinite
HISTSIZE=1000000000
SAVEHIST=1000000000

# Immediately append to history file:
setopt INC_APPEND_HISTORY

# Record timestamp in history:
setopt EXTENDED_HISTORY

# Expire duplicate entries first when trimming history:
setopt HIST_EXPIRE_DUPS_FIRST

# Dont record an entry that was just recorded again:
setopt HIST_IGNORE_DUPS

# Delete old recorded entry if new entry is a duplicate:
setopt HIST_IGNORE_ALL_DUPS

# Do not display a line previously found:
setopt HIST_FIND_NO_DUPS

# Dont record an entry starting with a space:
setopt HIST_IGNORE_SPACE

# Dont write duplicate entries in the history file:
setopt HIST_SAVE_NO_DUPS

# Share history between all sessions:
setopt SHARE_HISTORY

# Execute commands using history (e.g.: using !$) immediatel:
unsetopt HIST_VERIFY

plugins=(git bundler vi-mode)

case `uname` in
Darwin)
  # Customize to your needs...
  export PATH=/usr/local/bin/firefox:/Applications/MacVim.app/Contents/MacOS:/usr/local/bin:/Developer/usr/bin:opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/mysql/bin:/usr/local/git/bin:/Applications/ImageMagick/bin:/usr/local/sbin:/usr/texbin:/Users/preek/.rvm/bin

  # nvm
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh

  # JAVA
  #export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.7.0u.jdk/Contents/Home
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home
  # Added by the Heroku Toolbelt
  export PATH="/usr/local/heroku/bin:$PATH"

  # NODE
  export NODE_PATH="/usr/local/lib/node"

  # Never use haml with jRuby, because syntax checking will be very slow
  #alias vim='PATH=/Users/preek/.rvm/gems/ruby-1.9.3-p0/bin/:$PATH vim'
  # tmp fix for mavericks. no macvim available atm.
  #alias vim='/usr/bin/vim'

  # Android Setup
  export ANDROID_HOME=${HOME}/Library/Android/sdk
  export PATH=${PATH}:${ANDROID_HOME}/tools
  export PATH=${PATH}:${ANDROID_HOME}/platform-tools

  alias debian_vm_start='VBoxManage startvm "Debian - Rbenv+Rails" --type headless'

  # Debian VM
  debian_vm_login() {
    DEBIAN_IP=$(VBoxManage guestproperty enumerate "Voicerepublic" | grep IP | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])')
    if [[ $DEBIAN_IP != "" ]]
    then
      echo "Found Debian box at: " $DEBIAN_IP
      echo "Connecting to Debian box...\n\n==========================\n\n"

      # hack, because i'm using port forwarding
      ssh -p 2222 munen@127.0.0.1

      #ssh munen@$DEBIAN_IP
    else
      echo "No IP set yet. Sleep 1s and retry."
      sleep 1
      debian_vm_login
    fi
  }
  ;;
Linux)
  alias ls='ls -F --color=auto'

  # Activate NVM

  if [[ -f ~/.nvm/nvm.sh ]]; then
    source ~/.nvm/nvm.sh
  fi

  ;;
esac

export EDITOR='emacsclient -a="" -nw'

alias sqlite3='sqlite3 -line'
alias less='less -R' # Colors in Rails logs
export LESS=-RFX

# git aliases
alias cgs='clear; git status'
alias ga='git add'
alias gp='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gl="git log --pretty=format:'%Cred%h %Cgreen%ad %Cblue%aN %Creset%s' --date=iso --graph --branches"
alias gs='git status'
alias gd='git diff --color'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'

# open files with vim without 'open' command
alias -s tex rb css sass haml js coffee=vim

# SSH Tunnel
alias ips="sudo ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

alias pgdump='pg_dump dental_development > ~/pgdump_`date +%F`.sql && gzip ~/pgdump_`date +%F`.sql && ls -lh pgdump_*'

# Key bindings
bindkey "^p" history-beginning-search-backward
bindkey "^[n" history-beginning-search-forward
bindkey -M viins '^r' history-incremental-pattern-search-backward
bindkey -M vicmd '^r' history-incremental-pattern-search-backward
# I do not really want 'beep' to be bound to M+v, but normally M+v is bound to edit-command-line which is a problem, because I want M+v to be solely used by I3
bindkey -M vicmd v beep

# Edit current command line in emacs
autoload -z edit-command-line
zle -N edit-command-line
# M-v will lauch $EDITOR
bindkey -M vicmd v edit-command-line

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# disable zsh auto correct
unsetopt correct_all

# Recomy
export JS_DRIVER=phantomjs

# function ssh() {
#     dbus-send --session /net/sf/roxterm/Options net.sf.roxterm.Options.SetColourScheme string:$ROXTERM_ID string:Tango
#     /usr/bin/ssh $@
#     dbus-send --session /net/sf/roxterm/Options net.sf.roxterm.Options.SetColourScheme string:$ROXTERM_ID string:solarized-dark
# }

alias serve_directory="ruby -run -e httpd . -p 8080"

# mass rename file extension
# Usage:
#   $ mmv *m4a *m4b
autoload -U zmv
alias mmv='noglob zmv -W'

alias e='emacsclient -a="" -nw $@'
alias ec='emacsclient -c $@'

alias slime='tmux new-session -s default irb'

alias dmenu_run="dmenu_run -fn arial"

export TERM=xterm-256color

# alias curl="proxychains curl"

# Add Phils sourceme hook
# 200ok.ch/contextual-helpers-with-zsh-hooks/index.html
autoload -U add-zsh-hook

# source .sourceme files
load-local-conf() {
  # check file exists, is regular file and is readable:
  if [[ -f .sourceme && -r .sourceme ]]; then
  	source .sourceme
  fi
}
add-zsh-hook chpwd load-local-conf
load-local-conf

# The SOURCEME_REPO is the path where your clone of the sourceme repo
# lives.
export SOURCEME_REPO=~/src/200ok/sourceme

# The SOURCEME_PREFIX is used as a namespace. It will be used to name
# the symlink from you project's root directory to the corresponding
# directory in the shared sourceme repo. the prefix should be added to
# your user's global gitignore
export SOURCEME_PREFIX=.ok

# load config from .zshrc.d
# For example that used for shared project sourceme and doc files
for zshfile in ~/.zshrc.d/*[^~]; do
  source ${zshfile}
done

# automatically load `.nvmrc` files
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

if (( $+commands[nvm] )); then
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# Manually sync the client to a swiss NTP server and inform how far
# off the clock is
function ntp() {
  sudo service ntp stop
  sudo ntpdate ch.pool.ntp.org
  sudo service ntp start
}

# Circumvent:
#  gpg: signing failed: Inappropriate ioctl for device
export GPG_TTY=$(tty)

# Shortcuts for external screens
SCREEN1=DP-2
SCREEN2=HDMI-0
PRIMARY_RESOLUTION=3840x2160
XRANDR="xrandr --output $SCREEN1 --panning $PRIMARY_RESOLUTION --primary --auto --output $SCREEN2"
alias xr0="$XRANDR --off"
alias xr1="$XRANDR --auto" # mirror
alias xr2="$XRANDR --auto --right-of $SCREEN1 --scale-from $PRIMARY_RESOLUTION"

# Autojump
. ~/.guix-profile/share/autojump/autojump.zsh

#Zoxide
eval "$(zoxide init zsh)"

# Pip binaries
export PATH="/home/munen/.local/bin/:$PATH"

export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

export XDG_DATA_DIRS=/usr/share/gnome:/usr/local/share/:/usr/share/:/usr/share/glib-2.0/schemas:/var/lib/flatpak/exports/share:/home/munen/.local/share/flatpak/exports/share

# Old school without `ssh-with-mfa`
function ssh() {
  kitty @ set-colors foreground=#222
  kitty @ set-colors background=#BA8
  ~/.guix-profile/bin/ssh $@
  kitty @ set-colors --reset
}

# New school with `ssh-with-mfa`, because some people think that SSH
# is only secure with MFA.
function ssh-with-mfa() {
  kitty @ set-colors foreground=#222
  kitty @ set-colors background=#BA8
  ~/bin/ssh-with-mfa $@
  local code=$?
  kitty @ set-colors --reset
  return $code
}


__set-window-title() {
  # limit this to terminals, not consoles
  [[ $(tty) =~ ^/dev/pts ]] && \
    kitty @ set-window-title $(basename $PWD)
}
add-zsh-hook chpwd __set-window-title

# export DICTPATH=/usr/share/hunspell/

# Planck via src/200ok/planck
alias planck='docker run -v `pwd`:/workdir --rm -ti twohundredok/planck'

# Bug fix for Guix in Debian

# Guix sets this env variable. However, when using Debian binaries
# like `gsettings`, this will lead to an interesting situation where a
# Guix glibc is used. However, the versions don't match and yields a
# 'symbol lookup error'.
unset GIO_EXTRA_MODULES
# export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules:/home/munen/.guix-profile/lib/gio/modules:/home/munen/.guix-profile/lib/gio/modules

# vi mode
set -o vi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Enable fzf keybindings
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# This was needed for ansible-galaxy to find the installed cert.
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

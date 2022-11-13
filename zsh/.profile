# rbenv
if (( $+commands[rbenv] )); then
   export PATH="$HOME/.rbenv/bin:$PATH"
   eval "$(rbenv init -)"
fi

# rails
export PATH=./bin:$PATH

export PATH=$HOME/bin:$PATH

# GUIX
export PATH="/home/munen/.config/guix/current/bin/:$PATH"
export GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

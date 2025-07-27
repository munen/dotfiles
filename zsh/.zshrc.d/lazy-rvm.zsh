# Lazy load RVM - only initialize when needed

# Add RVM to PATH for scripting (lightweight)
export PATH="$PATH:$HOME/.rvm/bin"

# Add current Ruby to PATH if RVM is installed and has a default
if [[ -d "$HOME/.rvm" ]]; then
    # Check for default Ruby version
    if [[ -f "$HOME/.rvm/alias/default" ]]; then
        DEFAULT_RUBY=$(cat "$HOME/.rvm/alias/default")
        if [[ -d "$HOME/.rvm/rubies/$DEFAULT_RUBY" ]]; then
            export PATH="$HOME/.rvm/rubies/$DEFAULT_RUBY/bin:$PATH"
            export GEM_HOME="$HOME/.rvm/gems/$DEFAULT_RUBY"
            export GEM_PATH="$HOME/.rvm/gems/$DEFAULT_RUBY:$HOME/.rvm/gems/$DEFAULT_RUBY@global"
        fi
    fi
fi

# Function to load RVM when first needed
_load_rvm() {
    unset -f rvm ruby gem bundle rails rake irb
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
}

# Create placeholder functions that will load RVM on first use
rvm() {
    _load_rvm
    rvm "$@"
}

ruby() {
    _load_rvm
    ruby "$@"
}

gem() {
    _load_rvm
    gem "$@"
}

bundle() {
    _load_rvm
    bundle "$@"
}

rails() {
    _load_rvm
    rails "$@"
}

rake() {
    _load_rvm
    rake "$@"
}

irb() {
    _load_rvm
    irb "$@"
}

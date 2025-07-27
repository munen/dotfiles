# Lazy load NVM - only initialize when needed
export NVM_DIR="$HOME/.nvm"

# Add node binaries to path if they exist (for already installed versions)
if [[ -d "$NVM_DIR/versions/node" ]]; then
    # Find the default or latest node version
    if [[ -L "$NVM_DIR/alias/default" ]]; then
        DEFAULT_NODE_VERSION=$(readlink "$NVM_DIR/alias/default")
    else
        DEFAULT_NODE_VERSION=$(ls "$NVM_DIR/versions/node" | sort -V | tail -n1)
    fi
    
    if [[ -n "$DEFAULT_NODE_VERSION" && -d "$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION" ]]; then
        export PATH="$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/bin:$PATH"
    fi
fi

# Function to load NVM when first needed
_load_nvm() {
    unset -f nvm node npm npx yarn
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create placeholder functions that will load NVM on first use
nvm() {
    _load_nvm
    nvm "$@"
}

node() {
    _load_nvm
    node "$@"
}

npm() {
    _load_nvm
    npm "$@"
}

npx() {
    _load_nvm
    npx "$@"
}

yarn() {
    _load_nvm
    yarn "$@"
}

# Function to find .nvmrc and auto-switch (optimized)
nvm_find_nvmrc() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.nvmrc" ]]; then
            echo "$dir/.nvmrc"
            return
        fi
        dir=$(dirname "$dir")
    done
}

# Optimized auto-switch function
load-nvmrc() {
    local nvmrc_path="$(nvm_find_nvmrc)"
    
    if [[ -n "$nvmrc_path" ]]; then
        # Only load NVM if we actually need to switch versions
        local nvmrc_version="$(cat "$nvmrc_path")"
        local current_version="$(node --version 2>/dev/null | sed 's/^v//')"
        
        if [[ "$nvmrc_version" != "$current_version" ]]; then
            _load_nvm
            nvm use
        fi
    fi
}

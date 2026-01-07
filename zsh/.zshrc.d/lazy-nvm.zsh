# Lazy load NVM - only initialize when needed
# Fixed to work with Claude Code shell snapshots

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
# Define it as a simple inline function to ensure it's captured in snapshots
_load_nvm() {
    unset -f nvm node npm npx yarn
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Export the function so it's available in child shells and snapshots
export -f _load_nvm 2>/dev/null || true

# Create placeholder functions that will load NVM on first use
# These are self-contained to work even if _load_nvm is missing from snapshot
nvm() {
    if typeset -f _load_nvm >/dev/null 2>&1; then
        _load_nvm
        nvm "$@"
    else
        # Fallback: load nvm directly if _load_nvm is not available
        unset -f nvm node npm npx yarn
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    fi
}

node() {
    if typeset -f _load_nvm >/dev/null 2>&1; then
        _load_nvm
        node "$@"
    else
        # Fallback: load nvm directly if _load_nvm is not available
        unset -f nvm node npm npx yarn
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        node "$@"
    fi
}

npm() {
    if typeset -f _load_nvm >/dev/null 2>&1; then
        _load_nvm
        npm "$@"
    else
        # Fallback: load nvm directly if _load_nvm is not available
        unset -f nvm node npm npx yarn
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        npm "$@"
    fi
}

npx() {
    if typeset -f _load_nvm >/dev/null 2>&1; then
        _load_nvm
        npx "$@"
    else
        # Fallback: load nvm directly if _load_nvm is not available
        unset -f nvm node npm npx yarn
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        npx "$@"
    fi
}

yarn() {
    if typeset -f _load_nvm >/dev/null 2>&1; then
        _load_nvm
        yarn "$@"
    else
        # Fallback: load nvm directly if _load_nvm is not available
        unset -f nvm node npm npx yarn
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        yarn "$@"
    fi
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
        local current_version="$(command node --version 2>/dev/null | sed 's/^v//')"

        if [[ "$nvmrc_version" != "$current_version" ]]; then
            if typeset -f _load_nvm >/dev/null 2>&1; then
                _load_nvm
            else
                unset -f nvm node npm npx yarn
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
            fi
            nvm use
        fi
    fi
}

# ~/.zshrc: executed by zsh for interactive shells.
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not already present
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit $ZINIT_HOME
fi

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# oh-my-posh: cache the init script, regenerate only when config changes
_omp_cache="$HOME/.cache/oh-my-posh/init.zsh"
_omp_config="$HOME/.config/posh/posh.toml"
if [[ ! -f "$_omp_cache" || "$_omp_config" -nt "$_omp_cache" ]]; then
    oh-my-posh init zsh --config "$_omp_config" > "$_omp_cache" 2>/dev/null
fi
source "$_omp_cache"

# Add in plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git

# Load completions (rebuild cache only once per day)
autoload -U compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

bindkey '^ ' complete-word

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
export EDITOR=nvim

bindkey '^u' undo

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'
alias r='rm -rf'
alias n='nvim'
#alias t='tmux'
alias cc='claude --dangerously-skip-permissions'
alias ccr='claude --dangerously-skip-permissions --resume'


# Lazy-load nvm: defers 530ms+ startup cost until first use
export NVM_DIR="$HOME/dotfiles/.config/nvm"
nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}
node() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}
npx() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npx "$@"
}

# bun
BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH


export ANDROID_HOME=$HOME/android_sdk
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/android_sdk/cmdline-tools/bin

# mac only
if [[ "$(uname)" == "Darwin" ]]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

    # Turso
    export PATH="$HOME/.turso:$PATH"

    # Docker CLI completions
    fpath=($HOME/.docker/completions $fpath)
    export DYLD_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_LIBRARY_PATH
    export LIBRARY_PATH=/opt/homebrew/lib:$LIBRARY_PATH
    export PKG_CONFIG_PATH=/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

    # bun completions
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

export PATH="$HOME/.local/bin:$PATH"

# zoxide + fzf: cache init scripts, regenerate when binaries update
_cache_dir="$HOME/.cache/zsh"
[[ -d "$_cache_dir" ]] || mkdir -p "$_cache_dir"

_zoxide_bin="$(whence -p zoxide)"
if [[ ! -f "$_cache_dir/zoxide.zsh" || "$_zoxide_bin" -nt "$_cache_dir/zoxide.zsh" ]]; then
    zoxide init --cmd cd zsh > "$_cache_dir/zoxide.zsh"
fi
source "$_cache_dir/zoxide.zsh"

_fzf_bin="$(whence -p fzf)"
if [[ ! -f "$_cache_dir/fzf.zsh" || "$_fzf_bin" -nt "$_cache_dir/fzf.zsh" ]]; then
    fzf --zsh > "$_cache_dir/fzf.zsh"
fi
source "$_cache_dir/fzf.zsh"

bindkey '^I' autosuggest-accept

export XDG_CONFIG_HOME="$HOME/dotfiles/.config"

# Pyenv — lazy-loaded (no versions currently installed)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
pyenv() {
    unfunction pyenv 2>/dev/null
    eval "$(command pyenv init --path)"
    eval "$(command pyenv init -)"
    pyenv "$@"
}

export OPENCODE_CONFIG_DIR=/Users/andrei.antonescu/.config/opencode/

# Load Angular CLI autocompletion.
#source <(ng completion script)

. "$HOME/.posthog/env"

# Nebius CLI (inlined)
export PATH="$HOME/.nebius/bin:$PATH"

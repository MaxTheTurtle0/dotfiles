# ~/.zshrc: executed by zsh for interactive shells.
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not already present
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit $ZINIT_HOME
fi

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

eval "$(oh-my-posh init zsh --config $HOME/.config/posh/posh.toml)"

# Add in plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git

# Load completions
autoload -U compinit && compinit

bindkey '^ ' complete-word

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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
alias t='tmux'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun
BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH


export ANDROID_HOME=$HOME/android_sdk
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/android_sdk/cmdline-tools/bin

# mac only
if [[ "$(uname)" == "Darwin" ]]; then
    export ANDROID_HOME=~/Library/Android/sdk
    export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

    # Turso
    export PATH="/home/maxtheturtle0/.turso:$PATH"

    # The following lines have been added by Docker Desktop to enable Docker CLI completions.
    fpath=(/Users/maxtheturtle0/.docker/completions $fpath)
    export DYLD_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_LIBRARY_PATH
    export LIBRARY_PATH=/opt/homebrew/lib:$LIBRARY_PATH
    export PKG_CONFIG_PATH=/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

    # bun completions
    [ -s "/Users/maxtheturtle0/.bun/_bun" ] && source "/Users/maxtheturtle0/.bun/_bun"
    export PATH=$PATH:/Users/maxtheturtle0/Downloads/platform-tools
fi

export PATH="/snap/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

eval "$(zoxide init --cmd cd zsh)"

source <(fzf --zsh)

bindkey '^I' autosuggest-accept

export XDG_CONFIG_HOME="$HOME/dotfiles/.config"

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

autoload -Uz compinit
compinit

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

if [[ "$(uname)" != "Darwin" ]]; then
    export ANDROID_HOME=$HOME/android_sdk
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$HOME/android_sdk/cmdline-tools/bin
fi

# Turso
export PATH="/home/maxtheturtle0/.turso:$PATH"

export PATH="/snap/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

eval "$(zoxide init --cmd cd zsh)"

source <(fzf --zsh)

bindkey '^I' autosuggest-accept

# bun completions
[ -s "/Users/maxtheturtle0/.bun/_bun" ] && source "/Users/maxtheturtle0/.bun/_bun"

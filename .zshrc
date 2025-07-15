# curl https://gist.githubusercontent.com/prabirshrestha/279d8b179d9353fe8694/raw/.zshrc -o ~/.zshrc
# Path to your oh-my-zsh installation.

PROMPT='%~ %# '
unsetopt flow_control

# enable vi bindings
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

stty -ixon

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh # This loads NVM
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/Library/Python/3.7/bin:$PATH"
export PATH="$HOME/.config/nvim/plugins/vim-themis/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
#export PATH="/opt/pkg/bin:$PATH"

# alias
alias ls='ls -Gp'
alias vi='vim'

# git alias
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gba='git branch -a'
alias gca='git commit -a'
alias gclean='git clean -xdf'
alias gcm='git checkout master'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gf='git fetch --all'
alias gl='git log --oneline --graph --decorate'
alias gm='git merge'
alias gmt='git mergetool'
alias gp='git push origin HEAD'
alias gs='git status'
alias gup='git fetch --all && git rebase'

gpr() {
    git fetch origin pull/${1}/head:pr${1}
    git checkout pr${1}
}


autoload -U +X bashcompinit && bashcompinit

if hash zoxide 2>/dev/null; then eval "$(zoxide init zsh)"; fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[[ -s ~/.grit/bin/env ]] && . ~/.grit/bin/env

if hash mise 2>/dev/null; then eval "$(mise activate zsh)"; fi

# curl -Lk https://raw.githubusercontent.com/prabirshrestha/dotfiles/master/.bash_profile -o ~/.bash_profile
stty -ixon

export PS1='$(pwd)$ '

export EDITOR="vim"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     platform=linux;;
    Darwin*)    platform=mac;;
    CYGWIN*)    platform=cygwin;;
    MINGW*)     platform=mingw;;
    *)          platform="UNKNOWN:${unameOut}"
esac


if [ "$platform" == "mac" ]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export PATH="/opt/homebrew/anaconda3/bin:$PATH"
  export PATH="$(brew --prefix llvm)/bin:$PATH"
  export PATH="$(brew --prefix python)/libexec/bin:$PATH"
fi

if hash zoxide 2>/dev/null; then eval "$(zoxide init bash)"; fi
#if hash just 2>/dev/null; then source <(just --completions bash); fi
[[ -s ~/.cargo/env ]] && . ~/.cargo/env
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/Library/Python/3.8/bin:$PATH"
export PATH="$HOME/.config/nvim/plugins/vim-themis/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
#export PATH="/opt/pkg/bin:$PATH"

# if hash fnm 2>/dev/null; then eval "$(fnm env --use-on-cd)"; fi
if hash mise 2>/dev/null; then eval "$(mise activate bash)"; fi

if hash nomad 2>/dev/null; then complete -C nomad nomad; fi

# if [ "$platform" == "mac" ]
# then
#   if [ -d "$(echo /usr/local/Cellar/rocksdb/*/lib)" ]
#   then
#     export ROCKSDB_LIB_DIR="$(echo /usr/local/Cellar/rocksdb/*/lib)"
#     export ROCKSDB_STATIC=1
#   fi
# fi
#
#.

if [ "$platform" != "mac" ]
then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    alias open='xdg-open'
    if hash xdotool 2>/dev/null; then export WINDOWID=$(xdotool getwindowfocus); fi
fi

# alias
alias ls='ls -Gp'
alias vi='vim'
alias v='vim'

# git alias
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gba='git branch -a'
alias gca='git commit -a'
alias gclean='git clean -xdf'
alias gcm='git checkout main || git checkout master'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate'
alias gm='git merge'
alias gmt='git mergetool'
alias gp='git push origin HEAD'
alias gs='git status'
alias gup='git fetch && git rebase'

swap-ctrl-caps() {
  if [ "$XDG_SESSION_TYPE" == "x11" ]; then
   if which setxkbmap >/dev/null; then setxkbmap -option "ctrl:swapcaps"; fi
  fi
}

swap-ctrl-caps

gpr() {
    git fetch origin pull/${1}/head:pr${1}
    git checkout pr${1}
}


# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}

fco() {
    git checkout "$(git branch --all | fzf | tr -d ' ')"
}

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

start-openwebui() {
  docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_API_BASE_URL=http://localhost:11434/api --restart always --name open-webui ghcr.io/open-webui/open-webui:main
}

export GRIT_TELEMETRY_DISABLED=true
[[ -s ~/.grit/bin/env ]] && . ~/.grit/bin/env

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/prabirshrestha/.cache/lm-studio/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/prabirshrestha/.lmstudio/bin"
# End of LM Studio CLI section


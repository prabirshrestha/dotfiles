# curl -Lk https://gist.githubusercontent.com/prabirshrestha/279d8b179d9353fe8694/raw/.bash_profile -o ~/.bash_profile
[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh # This loads NVM
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/Library/Python/3.7/bin:$PATH"
export PATH="$HOME/.config/nvim/plugins/vim-themis/bin:$PATH"

stty -ixon

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias open='xdg-open'

# alias
alias ls='ls -Gp'
alias vi='nvim'
alias v='vim'

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
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate'
alias gm='git merge'
alias gmt='git mergetool'
alias gp='git push origin HEAD'
alias gs='git status'
alias gup='git fetch && git rebase'

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

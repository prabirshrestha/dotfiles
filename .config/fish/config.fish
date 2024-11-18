# disable fish greeting
set fish_greeting

set -x EDITOR vim

# https://github.com/sigoden/aichat/issues/769#issuecomment-2259388600
set -x AICHAT_CONFIG_DIR $HOME/.config/aichat

set -x TELEVISION_CONFIG $HOME/.config/television

fish_add_path ~/.dotfiles/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

if type -q brew
  fish_add_path (brew --prefix python)/libexec/bin
  fish_add_path (brew --prefix llvm)/bin
end

fish_add_path ~/.bun/bin
fish_add_path ~/.cargo/bin

type -q zoxide; and zoxide init fish | source
if test -n "$HOME/.config/fish/completions/pnpm.fish"
  source "$HOME/.config/fish/completions/pnpm.fish"
end

alias satyrn "open /Applications/satyrn.app"

alias g "git"
alias gs "git status"
alias gb "git branch"
alias gp "git push"
alias gco "git checkout"
alias gca "git commit -a"
alias gcm "git checkout main || git checkout master"
alias gup "git fetch && git rebase"
alias gca "git commit -a"
alias gco "git checkout"
alias gcp "git cherry-pick"

function gpr
    git fetch origin pull/$argv[1]/head:pr$argv[1]
    git checkout pr$argv[1]
end

fish_add_path ~/.proto/bin/shims
fish_add_path ~/.proto/bin
type -q proto; and proto activate fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/prabirshrestha/.cache/lm-studio/bin

# disable fish greeting
set fish_greeting

set -x EDITOR vim

fish_add_path ~/.dotfiles/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

if type -q brew
  fish_add_path (brew --prefix python)/libexec/bin
end

fish_add_path ~/.bun/bin
fish_add_path ~/.cargo/bin

type -q zoxide; and zoxide init fish | source

alias g "git"
alias gs "git status"
alias gp "git push"
alias gup "git fetch --all && git rebase"
alias gca "git commit -a"
alias satyrn "open /Applications/satyrn.app"

fish_add_path ~/.proto/bin/shims
fish_add_path ~/.proto/bin
type -q proto; and proto activate fish | source

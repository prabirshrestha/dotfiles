# disable fish greeting
set fish_greeting

fish_add_path ~/.dotfiles/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

fish_add_path ~/.bun/bin
fish_add_path ~/.cargo/bin

type -q zoxide; and zoxide init fish | source

alias g "git"
alias gs "git status"
alias gup "git fetch --all && git rebase"

fish_add_path ~/.proto/bin/shims
fish_add_path ~/.proto/bin
type -q proto; and proto activate fish | source

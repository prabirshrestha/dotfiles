# disable fish greeting
set fish_greeting

set -x EDITOR vim

# https://github.com/sigoden/aichat/issues/769#issuecomment-2259388600
set -x AICHAT_CONFIG_DIR $HOME/.config/aichat

set -x TELEVISION_CONFIG $HOME/.config/television

fish_add_path ~/.dotfiles/bin
fish_add_path ~/.local/bin

if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

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

type -q uv; and uv generate-shell-completion fish | source

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

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/prabirshrestha/.cache/lm-studio/bin

# Ensure tv is installed and configured
if command -q tv
    # Ctrl+Alt+f to select and paste file path
    bind \e\cf 'set -l selected_file (tv)
    if test -n "$selected_file"
        commandline -i "$selected_file"
    end
    commandline -f repaint'

    # Ctrl+Alt+d to select and paste directory path
    bind \e\cd 'set -l selected_dir (find . -type d | tv)
    if test -n "$selected_dir"
        commandline -i "$selected_dir"
    end
    commandline -f repaint'
end

if test -f ~/.config/fish/local.config.fish
    source ~/.config/fish/local.config.fish
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/prabirshrestha/.lmstudio/bin
# End of LM Studio CLI section


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/prabirshrestha/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

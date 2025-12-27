# disable fish greeting
set fish_greeting

set -gx EDITOR vim

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

set -gx SOPS_AGE_KEY_FILE ~/.config/sops/age/keys.txt

alias tailscale "/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias satyrn "open /Applications/satyrn.app"

alias k "kubectl"

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

alias claude-yolo "claude --dangerously-skip-permissions"

# Git Worktree
alias gw "git worktree"
alias gwl "git worktree list"
# gwr: git worktree remove (interactive if no args)
function gwr
    if test (count $argv) -eq 0
        set -l worktree (git worktree list | tv | awk '{print $1}')
        if test -n "$worktree"
            git worktree remove $worktree
        end
    else
        git worktree remove $argv[1]
    end
end

# gws: git worktree switch (interactive)
function gws
    set -l worktree (git worktree list | tv | awk '{print $1}')
    if test -n "$worktree"
        cd $worktree
    end
end

# gcow: git checkout worktree (-b for new branch)
function gcow
    set -l create_branch 0
    set -l args

    for arg in $argv
        if test "$arg" = "-b"
            set create_branch 1
        else
            set -a args $arg
        end
    end

    if test (count $args) -eq 0
        echo "Usage: gcow [-b] <branch> [path]"
        return 1
    end

    set -l branch $args[1]
    set -l path $args[2]
    if test -z "$path"
        set path "../"(basename (git rev-parse --show-toplevel))"-$branch"
    end

    if test $create_branch -eq 1
        git worktree add $path -b $branch
    else
        git worktree add $path $branch
    end
    and cd $path
end

# gpr: git pr switch (interactive with -w for worktree)
function gpr
    set -l use_worktree 0
    set -l args

    for arg in $argv
        if test "$arg" = "-w"
            set use_worktree 1
        else
            set -a args $arg
        end
    end

    set -l pr
    if test (count $args) -eq 0
        # Interactive: select PR with tv
        set pr (gh pr list | tv | awk '{print $1}')
        if test -z "$pr"
            return 1
        end
    else
        set pr $args[1]
    end

    if test $use_worktree -eq 1
        set -l base_dir (dirname (git rev-parse --show-toplevel))
        set -l repo_name (basename (git rev-parse --show-toplevel))
        set -l path "$base_dir/$repo_name-pr$pr"
        git worktree add $path -b pr$pr
        and cd $path
        and gh pr checkout $pr
    else
        gh pr checkout $pr
    end
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

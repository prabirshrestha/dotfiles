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

alias k "kubectl"

alias g "git"
alias gs "git status"
alias gb "git branch"
# gbs: git branch switch (interactive, includes remote branches)
function gbs
    set -l branch (git branch -a --format='%(refname:short)' | tv)
    if test -n "$branch"
        # Strip 'origin/' prefix for remote branches
        set branch (string replace -r '^origin/' '' $branch)
        git checkout $branch
    end
end
# gbr: git branch remove (interactive multiselect)
function gbr
    set -l branches (git branch --format='%(refname:short)' | tv)
    for branch in $branches
        if test -n "$branch"
            if not git branch -d $branch 2>/dev/null
                read -l -P "Force delete $branch? [y/N] " confirm
                if test "$confirm" = y -o "$confirm" = Y
                    git branch -D $branch
                end
            end
        end
    end
end
alias gp "git push"
alias gco "git checkout"
alias gca "git commit -a"
alias gcm "git checkout main || git checkout master"
alias gup "git fetch && git rebase"
alias gca "git commit -a"
alias gco "git checkout"
alias gcp "git cherry-pick"

alias claude-yolo "claude --dangerously-skip-permissions"
alias claudey "claude --dangerously-skip-permissions"

# Git Worktree (using worktrunk)
alias gw "wt"
alias gwl "wt list"
# gws: git worktree switch (interactive, includes main)
alias gws "wt select --branches"
# gwm: git worktree main (switch to main worktree)
alias gwm "wt switch main"
# gwr: git worktree remove (interactive)
function gwr
    set -l branch (wt list --format json 2>/dev/null | jq -r '.[].branch' | grep -v '^\[0m$' | tv)
    if test -n "$branch"
        wt remove $branch
    end
end
# gcow: git checkout worktree (-b for new branch)
function gcow
    if test (count $argv) -eq 0
        echo "Usage: gcow [-b] <branch>"
        return 1
    end

    if test "$argv[1]" = "-b"
        wt switch $argv[2..-1] --create
    else
        wt switch $argv
    end
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
        if test -d $path
            cd $path
        else
            git worktree add $path -b pr$pr
            and cd $path
            and gh pr checkout $pr
        end
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

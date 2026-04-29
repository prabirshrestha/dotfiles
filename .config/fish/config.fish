# disable fish greeting
set fish_greeting

set -gx EDITOR vim
set -gx DO_NOT_TRACK 1

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

if type -q sccache
    set -gx RUSTC_WRAPPER sccache
    set -gx SCCACHE_DIR $HOME/.cache/sccache
end

if type -q brew; and brew --prefix dotnet &>/dev/null
    set -gx DOTNET_ROOT (brew --prefix dotnet)/libexec
end

if test -d ~/.dotnet/tools
    fish_add_path ~/.dotnet/tools
end

type -q zoxide; and zoxide init fish | source
if test -n "$HOME/.config/fish/completions/pnpm.fish"
  source "$HOME/.config/fish/completions/pnpm.fish"
end

type -q uv; and uv generate-shell-completion fish | source

set -gx SOPS_AGE_KEY_FILE ~/.config/sops/age/keys.txt

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

# agent-safehouse: sandbox agents with deny-first access model
# use `command <agent>` to bypass the sandbox
if command -q safehouse
    function safe
        set -l extra_args
        set -l cleanshot_dir "$HOME/Library/Application Support/CleanShot"
        if test -e "$cleanshot_dir"
            set -a extra_args --add-dirs-ro="$cleanshot_dir"
        end
        set -l edge_devtools "$HOME/Library/Application Support/Microsoft Edge/DevToolsActivePort"
        if test -e "$edge_devtools"
            set -a extra_args --add-dirs="$edge_devtools"
        end
        set -l agents_dir "$HOME/.agents"
        if test -d "$agents_dir"
            set -a extra_args --add-dirs-ro="$agents_dir"
        end
        set -l fish_config "$HOME/.config/fish"
        if test -d "$fish_config"
            set -a extra_args --add-dirs="$fish_config"
        end
        safehouse --enable=browser-native-messaging --enable=agent-browser --enable=clipboard --enable=ssh --enable=all-agents $extra_args $argv
    end
    function claude
        safe claude --dangerously-skip-permissions $argv
    end
    alias claude-yolo claude
    alias claudey claude
    function copilot
        safe copilot $argv
    end
    function opencode
        safe opencode $argv
    end
else
    alias claude-yolo "claude --dangerously-skip-permissions"
    alias claudey "claude --dangerously-skip-permissions"
end

# nono: OS-level command sandbox (functions end in "n" to mark nono-wrapped)
# use `command <agent>` to bypass the sandbox
if command -q nono
    function clauden
        nono run --silent --profile claude-code --allow-cwd -- claude --dangerously-skip-permissions $argv
    end
    function opencoden
        nono run --silent --profile opencode --allow-cwd -- opencode $argv
    end
    # copilot has no built-in profile yet — track: https://github.com/always-further/nono/issues/623
    # piggyback on claude-code profile: it already bundles node_runtime, system_read_macos,
    # homebrew_macos, git_config, user_caches_macos, and the claude_code_macos group
    # (which grants the *.keychain-db file overrides copilot auth needs).
    function copilotn
        set -l extra_args
        set -l gh_config "$HOME/.config/gh"
        if test -d "$gh_config"
            set -a extra_args --allow "$gh_config"
        end
        set -l copilot_config "$HOME/.copilot"
        if test -d "$copilot_config"
            set -a extra_args --allow "$copilot_config"
        end
        set -l copilot_cache "$HOME/Library/Caches/copilot"
        if test -d "$copilot_cache"
            set -a extra_args --allow "$copilot_cache"
        end
        set -l agents_dir "$HOME/.agents"
        if test -d "$agents_dir"
            set -a extra_args --read "$agents_dir"
        end
        set -l mise_dir "$HOME/.local/share/mise"
        if test -d "$mise_dir"
            set -a extra_args --read "$mise_dir"
        end
        nono run --silent --profile claude-code --allow-cwd $extra_args -- copilot $argv
    end
end

# Git Worktree (using worktrunk)
alias gw "wt"
alias gwl "wt list"
# gws: git worktree switch (interactive, includes main)
alias gws "wt switch --branches"
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


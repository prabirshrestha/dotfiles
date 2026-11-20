# prabir does dotfiles

## dotfiles

Your dotfiles are how you personalize your system. These are mine. The very
prejudiced mix: OS X, Linux, Windows, zsh, Bash, git, homebrew, vim. 
If you match up along most of those lines, you may dig my dotfiles.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read Zach Holman's post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## installation

### ArchLinux

```bash
paru -Sy --noconfirm git
```

### Ubuntu/Debian and Mac

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/prabirshrestha/dotfiles/main/install)
```

or 

```bash
./install
```

### Windows

From an existing checkout, run the Windows wrapper from PowerShell or Command
Prompt:

```powershell
.\install.cmd
```

`install.cmd` installs portable BusyBox through WinGet for the current user,
without admin permissions, then runs the shared installer with `busybox sh`.
WinGet adds the `busybox` command. Its utilities, such as `ls` and `grep`, are
available inside that shell or as `busybox ls` and `busybox grep`.

Windows setup also installs uutils coreutils through WinGet for the current
user, providing native commands such as `ls.exe`, `cp.exe`, and `cat.exe`.
Use the `.exe` suffix in PowerShell to avoid its built-in aliases. Mise
installs ripgrep, available as `rg`, on Windows.

`configure.cmd` and the Worktrunk wrapper use Git for Windows' bundled shell.
Install Git to clone the repository and use those wrappers:

```powershell
winget install --id Git.Git --exact --source winget
```

Open a new terminal after installing Git. From a fresh machine, clone this
repository and run the installer:

```powershell
git clone --recurse-submodules https://github.com/prabirshrestha/dotfiles.git "$env:USERPROFILE\.dotfiles"
& "$env:USERPROFILE\.dotfiles\install.cmd"
```

Windows setup uses WinGet to bootstrap Mise. It does not install the former
Windows package bundle. Install any additional Windows applications separately.
Mise installs portable 7-Zip command-line tools on Windows without admin
permissions. Use `7za` to create and extract archives. This package does not
include the File Manager or Explorer context menu.

Mise also installs portable Clink from its official GitHub releases without
admin permissions. The Windows bootstrap enables it for the current user's
Command Prompt sessions.
Clink's install hook refreshes that registration when Mise upgrades it.

Windows setup installs the huacnlee Cargo fork in
`~/.local/share/cargo-fork/bin` and puts it first in your user PATH. The
existing rustup and msrustup proxies remain in their original directories.
The upstream Windows release currently supports x64 only.

#### Ghostty

[GhosttyWin32](https://github.com/i999rri/GhosttyWin32) is not installed by
the bootstrap because its self-signed MSIX currently supports only manual
installation. Download the `.msix` and `Ghostty.cer` from its
[releases](https://github.com/i999rri/GhosttyWin32/releases), trust the
certificate as described in its installation guide, then install the MSIX.
The bootstrap will deploy this repository's Ghostty configuration to
`%LOCALAPPDATA%\ghostty\config`.

## Apply dotfiles

```bash
./install
```

This will clone `~/.dotfiles` if missing and symlink the appropriate files to your
home directory.

### Git configuration

Mise renders portable defaults to `~/.config/git/shared.gitconfig`. The local
`~/.gitconfig` includes that file first and stays a regular, untracked file.
Machine-specific identity overrides, optional pagers, work settings and credential
helpers stay local. Tools such as `gh auth setup-git` and `git config --global`
continue writing to `~/.gitconfig`.

Private configs can sit alongside the shared one, for example
`~/.config/git/work.gitconfig`. Add an include for that file in `~/.gitconfig`
when you need it. Only `shared.gitconfig` is managed by this repository; do not
symlink the entire `~/.config/git` directory into the checkout. Credential helpers
can combine across files, and an empty `helper` resets the earlier list.
The shared file deliberately sets no credential helpers.

`./configure` preserves the old local config in
`~/.config/git/config.before-shared` on the first migration. It removes only
defaults that match the shared file, keeps other local values, and releases
Dotter's old ownership of `~/.gitconfig`. Later applies update the shared defaults
without overwriting local tool settings. The backup may contain private settings;
keep it outside this repository.

To apply only this Git setup, without installing other tools:

```sh
mise dotfiles apply --yes ~/.config/git/shared.gitconfig
sh scripts/configure-git
```

Git reads includes without a terminal or GUI, so the layout works in headless
sessions too. It does not change external credential overrides supplied through
`GIT_CONFIG_*` environment variables.

On Windows, `configure.cmd` runs the same setup through Git for Windows' shell.
`USERPROFILE` supplies the home directory when `HOME` is unset. Mise renders the
Windows defaults, while Windows credential helpers and other local settings stay
in `%USERPROFILE%\.gitconfig`. No Bash, Zsh, or Fish startup edits are required.

## Thanks

Fork of [Holman's dotfiles](https://github.com/holman/dotfiles) which has been supported to work
on all 3 major OS - Mac OSX, Linux and Windows and of coure my own customizations.

[Dotter](https://github.com/SuperCuber/dotter) tool to help with dotfiles automation.

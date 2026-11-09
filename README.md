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

## Thanks

Fork of [Holman's dotfiles](https://github.com/holman/dotfiles) which has been supported to work
on all 3 major OS - Mac OSX, Linux and Windows and of coure my own customizations.

[Dotter](https://github.com/SuperCuber/dotter) tool to help with dotfiles automation.

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
paru -Sy --noconfirm dotter-rs-bin git
```

### Mac

```bash
bash <(curl -s https://raw.githubusercontent.com/prabirshrestha/dotfiles/main/install)
```

or 

```bash
./install
```

### Windows

From PowerShell:

```powershell
curl.exe -fL -o "$env:TEMP\busybox-${env:PROCESSOR_ARCHITECTURE}.exe" "https://github.com/prabirshrestha/dotfiles/releases/download/busybox/busybox-${env:PROCESSOR_ARCHITECTURE}.exe"; if ($LASTEXITCODE -eq 0) { curl.exe -fL -o "$env:TEMP\dotfiles-install" "https://raw.githubusercontent.com/prabirshrestha/dotfiles/main/install" }; if ($LASTEXITCODE -eq 0) { & "$env:TEMP\busybox-${env:PROCESSOR_ARCHITECTURE}.exe" sh "$env:TEMP\dotfiles-install" }
```

From Command Prompt:

```cmd
curl.exe -fL -o "%TEMP%\busybox-%PROCESSOR_ARCHITECTURE%.exe" "https://github.com/prabirshrestha/dotfiles/releases/download/busybox/busybox-%PROCESSOR_ARCHITECTURE%.exe" && curl.exe -fL -o "%TEMP%\dotfiles-install" "https://raw.githubusercontent.com/prabirshrestha/dotfiles/main/install" && "%TEMP%\busybox-%PROCESSOR_ARCHITECTURE%.exe" sh "%TEMP%\dotfiles-install"
```

## Apply dotfiles

```bash
git clone --recurse-submodules https://github.com/prabirshrestha/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./configure
```

This will clone the repo and symlink the appropriate files in `.dotfiles` to your
home directory. Everything is configured and tweaked within `~/.dotfiles`,
though.

## Thanks

Fork of [Holman's dotfiles](https://github.com/holman/dotfiles) which has been supported to work
on all 3 major OS - Mac OSX, Linux and Windows and of coure my own customizations.

[Dotter](https://github.com/SuperCuber/dotter) tool to help with dotfiles automation.

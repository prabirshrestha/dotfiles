# prabir does dotfiles

## dotfiles

Your dotfiles are how you personalize your system. These are mine. The very
prejudiced mix: OS X, Linux, Windows, zsh, Bash, git, homebrew, vim. 
If you match up along most of those lines, you may dig my dotfiles.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read Zach Holman's post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## install

```bash
paru -Sy --noconfirm dotter-rs-bin git
cd ~/
git clone https://github.com/prabirshrestha/dotfiles.git .dotfiles
cd .dotfiles
dotter -v
```

This will clone the repo and symlink the appropriate files in `.dotfiles` to your
home directory. Everything is configured and tweaked within `~/.dotter`,
though.

## thanks

Fork of [Holman's dotfiles](https://github.com/holman/dotfiles) which has been supported to work
on all 3 major OS - Mac OSX, Linux and Windows and of coure my own customizations.

[Dotter](https://github.com/SuperCuber/dotter) tool to help with dotfiles automation.

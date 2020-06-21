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
pacman -Syu --noconfirm --needed git
yay -Sy nerd-fonts-fira-code
cd ~/
curl -Lk https://github.com/ubnt-intrepid/dot/releases/download/v0.1.4/dot-v0.1.4-x86_64-unknown-linux-musl.tar.gz -o dot.tar.gz
tar -xvf ./dot.tar.gz
rm ./dot.tar.gz
sudo mv ./dot /bin/
dot init prabirshrestha/dotfiles
```

This will clone the repo and symlink the appropriate files in `.dotfiles` to your
home directory. Everything is configured and tweaked within `~/.mappings`,
though.

## thanks

Fork of [Holman's dotfiles](https://github.com/holman/dotfiles) which has been supported to work
on all 3 major OS - Mac OSX, Linux and Windows and of coure my own customizations.

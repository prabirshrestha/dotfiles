#!/bin/bash
# curl https://raw.github.com/prabirshrestha/dotfiles/master/install.sh | bash

set -e

if [ -d ~/.dotfiles ]
then
  echo "You already have .dotfiles installed. You'll need to remove ~/.dotfiles if you want to install"
  exit 1
fi

echo "Cloning .dotfiles"
hash git >/dev/null && /usr/bin/env git clone --recursive https://github.com/prabirshrestha/dotfiles.git ~/.dotfiles || {
  echo "git not installed"
  exit 2
}

UNAME=$(uname)
OS=
if [[ "$UNAME" == 'Linux' ]]; then
	OS="linux"
elif [[ "$UNAME" == 'Darwin' ]]; then
	OS="mac"
elif [[ "$UNAME" == CYGWIN* || "$UNAME" == MINGW* ]]; then
	OS="windows"
fi

skip_all=false
overwrite_all=false
backup_all=false

if [[ "$OS" == 'windows' ]]; then
	CMDHOMEDIR=`cmd //c "echo %USERPROFILE%"`
fi

for src_path in ~/.dotfiles/*/*.symlink; do
	overwrite=false
	backup=false
	skip=false
	src_basename=`basename "$src_path"`
	dest_path=`echo "$HOME/.$src_basename" | sed "s/\.symlink$//"`

	if [ "$OS" == "windows" ]; then
		src_path_normalized=`echo ${src_path/$HOME/$CMDHOMEDIR}`
		dest_path_normalized=`echo "$CMDHOMEDIR\.$src_basename" | sed "s/\.symlink$//"`
	else
		src_path_normalized="$dest_path"
		dest_path_normalized="$src_path"
	fi

	if [[ "$OS" == 'windows' ]]; then
		if test -d "$src_path";	then
			is_dir="/d"
		else
			is_dir=
		fi
	fi

	if [ -e "$dest_path" ]; then
		if [[ $skip_all = true || $overwrite_all = true || $backup_all = true  ]]; then
			loop=false
		else
			loop=true
		fi

		while [[ $loop = true ]]; do
			read -p "File already exists: $dest_path_normalized, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite All, [b]ackup, [B]backup all " answer
			case $answer in
				o ) overwrite=true; break;;
				b ) backup=true; break;;
				O ) overwrite_all=true; break;;
				B ) backup_all=true; break;;
				S ) skip_all=true; break;;
				s ) skip=true; break;;
			esac
		done

		if [ $skip_all = false ]; then
			if [ $skip = false ]; then
				if [[ $backup_all = true || $backup = true ]]; then
					if [ -e "$dest_path" ]; then
						echo "mv $dest_path $dest_path.backup"
						mv $dest_path "$dest_path.backup"
					fi
				elif [[ $overwrite_all = true || $overwrite = true ]]; then
					if [ -e "$dest_path" ]; then
						echo "rm -rf $dest_path"
						rm -rf $dest_path
					fi
				fi

				if [ "$OS" == "windows" ]; then
					cmd.exe /c "mklink $is_dir \"$dest_path_normalized\" \"$src_path_normalized\""
				else
					echo "ln -s $src_path $dest_path"
					ln -s $src_path $dest_path
				fi
			fi
		fi
	else
		if [ "$OS" == "windows" ]; then
			cmd.exe /c "mklink $is_dir \"$dest_path_normalized\" \"$src_path_normalized\""
		else
			echo "ln -s $src_path $dest_path"
			ln -s $src_path $dest_path 
		fi
	fi
	
done

# Node/nvm
if [ -f "$HOME/.nvm/nvm.sh" ]; then
	source "$HOME/.nvm/nvm.sh"
	nvm use default > /dev/null
fi

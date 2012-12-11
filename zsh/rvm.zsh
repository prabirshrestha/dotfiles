# rvm
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
	source "$HOME/.rvm/scripts/rvm"
	rvm use default > /dev/null
fi
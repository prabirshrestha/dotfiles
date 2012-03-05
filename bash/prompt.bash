if [ -z "$MSYSTEM" ]; then
  MSYSTEM=MINGW32
fi

if [ $MSYSTEM == MINGW32 ]; then
  export PS1='\[\033]0;$MSYSTEM:\w\007
\033[32m\]\u@\h \[\033[33m\w$(__git_ps1)\033[0m\]
$ '
else
  export PS1="\n\[\033[38m\]\u@\h\[\033[01;34m\] \w \[\033[31m\]\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`\[\033[37m\]\n$\[\033[00m\] "
fi
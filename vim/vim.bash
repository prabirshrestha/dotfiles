UNAME=`uname`
#if [ "$UNAME" == "Linux" ]; then
#fi
  
if [ "$UNAME" == "Darwin" ]; then
   export TERM=xterm-color
   alias vim="mvim"
   alias vi="mvim"
fi

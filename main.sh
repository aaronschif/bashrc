case $- in
    *i*) ;;
      *) return;;
esac

. ./git.sh
. ./colors.sh
. ./alias.sh
. ./complete.sh
. ./history.sh
. ./misc.sh

export PROMPT_DIRTRIM=2
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
color_prompt=yes
else
color_prompt=
fi
export PS1="\`__git_ps1 '[\[${Green}\]%s\[${Reset}\]] '\`\u@\h\n\w \[${Yellow}\]\$\[${Reset}\] "

case "$TERM" in
xterm*|rxvt*) # Can set title
    ;;
*)
    ;;
esac

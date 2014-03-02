case $- in
    *i*) ;;
      *) return;;
esac

. ./work/main.sh

. ./git.sh
. ./colors.sh
. ./prompt_colors.sh
. ./alias.sh
. ./complete.sh
. ./history.sh
. ./misc.sh
. ./environ.sh

export PROMPT_DIRTRIM=2
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
color_prompt=yes
else
color_prompt=
fi

__py_virt_ps1()
{
    if [ -n "$VIRTUAL_ENV" ]
    then 
        if [ -n "$1" ]
        then 
            printf -- "$1" `basename $VIRTUAL_ENV`
        else
            echo -n "[]"
        fi
    fi
}
__py_virt_ps1_restore()
{
    if [ -n "$_OLD_VIRTUAL_PS1" ] 
    then
        PS1=$_OLD_VIRTUAL_PS1
        unset _OLD_VIRTUAL_PS1
    fi
}

__pwd()
{
	i=${PWD//$HOME/'~'}
	printf "${1}"${i//'/'/"${2}/${1}"}"\[${Reset}\]"
}

export PROMPT_COMMAND="$PROMPTCOMMAND __py_virt_ps1_restore;"
#~ export PS1="\
#~ \`__py_virt_ps1 '[\[${Green}\]%s\[${Reset}\]] '; __git_ps1 '[\[${Green}\]%s\[${Reset}\]] '\`\
#~ \u@\h\n\w \[${Yellow}\]\$\[${Reset}\] "
#~ export PS1=`printf \
#~ "${eBlue}[${eGreen}%s${eBlue}]%s${eReset} " \
#~ "\u" \
#~ "\$" 
#~ `

export PS1=`tr --delete '\n' <<EOF
${eBlue}- ${eGreen}\u${eBlue}@${eGreen}\h${Blue}
\\\`__git_ps1 "${eBlue} - ${eGreen}%s${eReset}" \\\`
\\\`__py_virt_ps1 "${eBlue} - ${eGreen}%s${eReset}" \\\`
\n
${eBlue}- ${eGreen}\w${eBlue} \$ 
${eReset}
EOF
`

case "$TERM" in
xterm*|rxvt*) # Can set title
    ;;
*)
    ;;
esac

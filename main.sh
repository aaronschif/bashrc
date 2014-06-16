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

__smart_fab_set()
{
	if [ -f "conf/fabfile.py" ] 
	then
		alias fab="fab -f conf/fabfile.py"
		export FAB_COMPLETION_FABFILE_DIR='conf'
	else
		unalias fab 2> /dev/null
		export FAB_COMPLETION_FABFILE_DIR='.'
	fi
}

__pwd()
{
	i=${PWD//$HOME/'~'}
	printf "${1}"${i//'/'/"${2}/${1}"}"\[${Reset}\]"
}

export PROMPT_COMMAND="$PROMPTCOMMAND __py_virt_ps1_restore; __smart_fab_set;"
#~ export PS1="\
#~ \`__py_virt_ps1 '[\[${Green}\]%s\[${Reset}\]] '; __git_ps1 '[\[${Green}\]%s\[${Reset}\]] '\`\
#~ \u@\h\n\w \[${Yellow}\]\$\[${Reset}\] "
#~ export PS1=`printf \
#~ "${eBlue}[${eGreen}%s${eBlue}]%s${eReset} " \
#~ "\u" \
#~ "\$" 
#~ `

export PS1=`tr -d '\n' <<EOF
\n
${eBlue}- ${eGreen}\u${eBlue}@${eGreen}\h
\\\`__git_ps1 "${eBlue} - ${eGreen}%s" \\\`
\\\`__py_virt_ps1 "${eBlue} - ${eGreen}%s" \\\`
\n
${eBlue}- ${eGreen}\w${eBlue} \$ 
${eReset}
EOF
`

#~ __PS1()
#~ {
	#~ echo "\w"
#~ }
#~ export PS1='`__PS1`'

case "$TERM" in
xterm*|rxvt*) # Can set title
    ;;
*)
    ;;
esac

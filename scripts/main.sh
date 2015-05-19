case $- in
    *i*) ;;
      *) return;;
esac

. ./work/main.sh

# . ./pythonz.sh
. ./git.sh
. ./colors.sh
. ./prompt_colors.sh
. ./complete.sh
. ./alias.sh
. ./history.sh
. ./misc.sh
. ./environ.sh
. ./prompt_commands/ksu_vagrant.sh
. ./util.sh

if which vimpager $> /dev/null; then export PAGER=vimpager; fi

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

__smart_fab_set()
{
	if [ -f "conf/fabfile.py" ]
	then
		alias fab="fab -f conf/fabfile.py"
	else
		unalias fab 2> /dev/null
	fi
}

__color_host()
{
  if [ -n "$SSH_CONNECTION" ]
  then
    local hash=$(md5sum <<< `hostname`)
    local n=$((0x${hash%% *}))

    echo -e '@\[\e[0;3'$(($n%6+1))'m\]'`hostname`
  fi
}

export PROMPT_COMMAND="__smart_fab_set; __ksu_vagrant; $PROMPT_COMMAND"

host=`__color_host`
git="\`__git_ps1 '${eBlue} - ${eGreen}%s '\`"
venv="\`__py_virt_ps1 '${eBlue} - ${eGreen}%s '\`"

export PS1="
${eBlue}- ${eGreen}\u${eBlue}${host}${git}${venv}
${eBlue}- ${eGreen}\w${eBlue} \$${eReset} "

export PYENV_ROOT="$HOME/.pyenv"
! [[ "$PATH" =~ "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"

if command_exists pyenv
then
    # No shims, in favor of virtualenv.
    OLD_PATH="$PATH"
    eval "$(pyenv init -)"
    PATH="$OLD_PATH"
    eval "$(pyenv virtualenv-init -)"
fi

if command_exists gulp
then
    eval "$(gulp --completion=bash)"
fi

. ./title.sh

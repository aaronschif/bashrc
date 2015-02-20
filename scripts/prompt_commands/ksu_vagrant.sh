: <<USAGE
Place this line in your bashrc file and ensure that this file is sourced.

    export PROMPT_COMMAND="$PROMPT_COMMAND __ksu_vagrant;"
USAGE

: ${KSU_VAGRANT_PREFIX:=~/Projects/kstate}
: ${KSU_VAGRANT_SOURCE:=~/Projects/kstate/python-vm}

function __ksu_vagrant()
{
    if [[ `pwd` == $KSU_VAGRANT_PREFIX* ]]
    then
        export VAGRANT_CWD=$(eval echo $KSU_VAGRANT_SOURCE)
    else
        export VAGRANT_CWD=
    fi
}

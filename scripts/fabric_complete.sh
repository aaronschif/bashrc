__fabric_cmd_cache_options=
__fabric_cmd_cache_options_wc=
__fabric_cmd_cache_commands=
__fabric_cache_pwd=

__fabric_complete()
{
    if which fab &> /dev/null; then :; else return 0; fi

    if [ `pwd` != "${__fabric_cache_pwd}" ]
    then
        local fab_help=`fab --help | egrep -o "\-\-[A-Za-z_\-]+\=?" | sort -u`
        __fabric_cmd_cache_options=`echo "$fab_help" | egrep -v "\="`
        __fabric_cmd_cache_options_wc=`echo "$fab_help" | egrep "\="`
        __fabric_cmd_cache_commands=`fab --shortlist`
        __fabric_cache_pwd=`pwd`
    fi

    local word=${COMP_WORDS[COMP_CWORD]}
    local line=${COMP_LINE}

    local commands_with_space
    local commands_no_space

    case "$word" in
    -*)
        commands_with_space="${__fabric_cmd_cache_options} ${__fabric_cmd_cache_commands}"
        commands_no_space="${__fabric_cmd_cache_options_wc}"
        ;;
    *)
        commands_with_space="${__fabric_cmd_cache_commands}"
        commands_no_space=""
        ;;
    esac

    COMPREPLY=(
        $(compgen -o nospace -W "${commands_no_space}" -- "${word}")
        $(compgen -W "${commands_with_space}" -- "${word}")
    )
}

complete -o nospace -F __fabric_complete fab

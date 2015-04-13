case $TERM in
    rxvt|*term)
        if [ -n "$SSH_CONNECTION" ]
        then
            __title_host="`whoami`@`hostname`: %s"
        else
            __title_host="%s"
        fi

        function __title {
            local bc
            if [ -n "${1}" ]
            then
                bc="${1}"
            else
                bc="$PWD"
            fi
            local title="`printf $__title_host $bc`"
            echo -ne "\033]0;${title}\007"
        }

        function __title_precommand {
            case $BASH_COMMAND in
                _*)
                ;;
                *)
                    __title "$BASH_COMMAND"
                ;;
            esac
        }
        function __title_preprompt {
            __title
        }
        PROMPT_COMMAND="__title_preprompt; $PROMPT_COMMAND"
        trap __title_precommand DEBUG
    ;;
esac

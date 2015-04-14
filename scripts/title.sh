case $TERM in
    rxvt|*term)
        if [ -n "$SSH_CONNECTION" ]
        then
            __title_host="`whoami`@`hostname`"
        else
            __title_host=""
        fi

        function __title {
            local bc
            local title=$(basename `echo $PWD | sed "s,^$HOME,~,"`)
            if [ -n "${1}" ]
            then
                title="${title}: ${1}"
            fi
            if [ -n "$__title_host" ]
            then
                title="$__title_host $title"
            fi
            if [ -n "${TITLE}" ]
            then
                title="[$TITLE] ${title}"
            fi
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

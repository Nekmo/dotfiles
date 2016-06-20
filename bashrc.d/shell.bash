#-------------------------------------------------------------
# Modificaciones del terminal:
#-------------------------------------------------------------
registerAssistanceSection "Opciones del terminal"

complete -cf sudo # Habilitar tab tras sudo
complete -cf man # Habilitar tab para man
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config | grep -v '[?*]' | cut -d ' ' -f 2-)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh


# After each command, save and reload history
export PROMPT_COMMAND="history -a ; ${PROMPT_COMMAND:-:}"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Auto cd cuando se pone el path y es un directorio
shopt -s autocd

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=30000
HISTFILESIZE=50000

# parse_branch() {
#     branch=`git branch 2> /dev/null  | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'`
#     if [[ -z "$branch" && `hg root 2> /dev/null` != "$HOME" ]]
#     then
#         branch=`hg branch 2> /dev/null | sed -e 's/\(.*\)/ (\1)/'`
#         echo $branch > /tmp/foo
#     fi
#     echo "$branch";
# }

parse_branch(){
    branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'`
    if [[ "$branch" ]]; then
        echo " $branch";
    fi
}

if [ `whoami` == 'root' ]; then
    hash="${c_white}#"
else
    hash='$'
fi

PS1="\[$c_host\][\u@\h\[$c_path\] \w]"'$(parse_branch)'"$hash\[$c_null\] " # Coloreado PS1


#-------------------------------------------------------------
# Utilidades para terminal:
#-------------------------------------------------------------
registerAssistance "reload" "Recarga la terminal. Equivalente a source ~/.bashrc";
alias reload="source ~/.bashrc"

#-------------------------------------------------------------
# Thirdparty:
#-------------------------------------------------------------
source ~/dotfiles/bashrc.d/thirdparty/dirb.bash

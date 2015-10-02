#-------------------------------------------------------------
# Modificaciones del terminal:
#-------------------------------------------------------------
complete -cf sudo # Habilitar tab tras sudo
complete -cf man # Habilitar tab para man
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# After each command, save and reload history
export PROMPT_COMMAND="history -a ; ${PROMPT_COMMAND:-:}"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

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
    branch=`git branch 2> /dev/null  | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'`
    echo $branch;
}

PS1='\['"$c_host"'\][\u@\h\['"$c_path"'\] \w$(parse_branch)]$\['"$c_null"'\] ' # Coloreado PS1


#-------------------------------------------------------------
# Utilidades para terminal:
#-------------------------------------------------------------
alias reload="source ~/.bashrc"
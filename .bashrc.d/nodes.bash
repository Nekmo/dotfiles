#-------------------------------------------------------------
# Trabajo con archivos y directorios:
#-------------------------------------------------------------
function cmprx() {
    if [ -f "$1" ] ; then
        case "$1" in
           *.tar.bz2)   tar xvjf "$1"     ;;
           *.tar.gz)    tar xvzf "$1"     ;;
           *.bz2)       bunzip2 "$1"      ;;
           *.rar)       unrar x "$1"      ;;
           *.gz)        gunzip "$1"       ;;
           *.tar)       tar xvf "$1"      ;;
           *.tbz2)      tar xvjf "$1"     ;;
           *.tgz)       tar xvzf "$1"     ;;
           *.zip)       unzip "$1"        ;;
           *.Z)         uncompress "$1"   ;;
           *.7z)        7z x "$1"         ;;
           *)           echo "'$1' no se pudo descomprimir." ;;
       esac
   else
       echo "'$1' no es un archivo válido."
   fi
}

function edt(){
    if [ "$DISPLAY" ]
    then
        editor=$VISUAL
    else
        editor=$EDITOR
    fi
    if [ ! -f "$1" ]
    then
        target=`dirname "$1"`;
    else
        target="$1";
    fi
    if [ -w "$target" ]
    then
        $editor "$1" &> /dev/null &
    else
        # Descomentar en sudoers para aplicaciones gráficas:
        # Defaults env_keep += "DISPLAY HOME"
        sudo echo
        sudo $editor "$1" &> /dev/null &
    fi
}

alias viewcode="grep \"^#\" -v $1 | tr -s '\n' | nl | less" # Ver solo el código, sin comentarios, líneas vacías...
alias ls='ls --color=auto'
alias la='ls -AF' # Incluir archivos ocultos
alias ll='ls -lh --color=auto' # Mostrar en lista
alias cr="cp -r" # copiar recursivamente
alias grep='grep --color=auto' 


ls1() {
  if [ -n "$1" ]; then
    ls -1 --color=auto "$1"; ls -1 -A  "$1" | echo -e "${c_dark_gray}# Archivos totales:${c_null} "`wc -l`;
  else
    ls -1 --color=auto $1; ls -1 -A $1 | echo -e "${c_dark_gray}# Archivos totales:${c_null} "`wc -l`;
  fi
}




#-------------------------------------------------------------
# Comprimir y descomprimir:
#-------------------------------------------------------------
alias cmpr-x='cmprx'
alias cmpr-7z="$HOME/.local/scripts/cmpr.py '7z a' 'cmpr7z' '7z'"
alias cmpr-rar="$HOME/.local/scripts/cmpr.py 'rar a' 'cmprrar' 'rar'"
alias cmpr-zip="$HOME/.local/scripts/cmpr.py 'zip' 'cmprzip' 'zip'"
alias cmpr-gz="compress"
alias cmpr-tar="$HOME/.local/scripts/cmpr.py 'tar cvf' 'cmprtar' 'tar'"
alias cmpr-targz="$HOME/.local/scripts/cmpr.py 'tar czfv' 'cmprtargz' 'tar.gz'"
alias cmpr-tarbz2="$HOME/.local/scripts/cmpr.py 'tar jcvf' 'cmprtarbz2' 'tar.bz2'"


complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' compx

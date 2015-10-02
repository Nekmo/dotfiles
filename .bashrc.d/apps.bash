#-------------------------------------------------------------
# Programas:
#-------------------------------------------------------------
export EDITOR=nano
export VISUAL=kate

if [ $is_server = true ]; then
    export VISUAL=$EDITOR; # Forzar el editor de consola en servidor
fi
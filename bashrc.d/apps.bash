#-------------------------------------------------------------
# Programas:
#-------------------------------------------------------------
registerAssistanceSection "Aplicaciones"

export EDITOR=nano
export VISUAL=kate

if [ $is_server = true ]; then
    export VISUAL=$EDITOR; # Forzar el editor de consola en servidor
fi

registerAssistance "about" "Muestra información del sistema. Equivalente a screenfetch";
alias about='screenfetch'
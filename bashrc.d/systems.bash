#-------------------------------------------------------------
# Configuraciones por cada sistema:
#-------------------------------------------------------------
c_path="$c_light_blue"; # Color para el path por defecto
is_server=false

case "$HOSTNAME" in
    "homura")
        c_host="\e[1;1m\e[38;5;141m";; # Morado brillante
    "shiori")
        c_host="\e[1;1m\e[38;5;198m";; # Rosa
    "shinobu")
        c_host="$c_yellow"; # Amarillo puro
        is_server=true;;
    "shizune")
        c_host="$c_light_blue";
        is_server=true;
        c_path="$c_light_cyan";;
    *)
        c_host="$c_white";;
esac
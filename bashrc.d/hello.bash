#-------------------------------------------------------------
# Mensaje de Bienvenida:
#-------------------------------------------------------------
OS=`uname`
IP=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
rusedram=`free -m | awk 'NR==2{printf "%s", $3 }'`
rtotalram="$($_CMD free -mt | grep Mem: | awk '{ print $2 "MB" }')"
uptime_now=`uptime | sed -r 's/,  [0-9]+ users.+//' | sed -r 's/.+ up //' | sed -r 's/  / /'`
echo -e "Bienvenido a ${c_host}${HOSTNAME}${c_null} ${c_dark_gray}(Ver.${c_null} "`uname -r`" ${c_dark_gray}IP.${c_null} $IP${c_dark_gray}).${c_null}"
echo -e "${c_dark_gray}RAM:${c_null} $rusedram/$rtotalram ${c_dark_gray}CPU:${c_null} "`cpupcnt`"% ${c_dark_gray}Uptime:${c_null} $uptime_now. Escriba ${c_dark_gray}Assistance${c_null} para ayuda."
if [ `whoami` == 'root' ]; then
    echo -e "${c_bold}${c_yellow}Atención:${c_null}${c_bold} estás accediendo como super-usuario. ${c_yellow}Tenga precaución, amigo administrador.${c_null}"
fi
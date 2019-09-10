#-------------------------------------------------------------
# Mensaje de Bienvenida:
#-------------------------------------------------------------
OS=`uname`
IP=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}' | grep -v '192.168.' | head -n 1)
rusedram=`free -m | awk 'NR==2{printf "%s", $3 }'`
rtotalram="$($_CMD free -mt | grep Mem: | awk '{ print $2 "MB" }')"
uptime_now=`uptime | sed -r 's/,  [0-9]+ users.+//' | sed -r 's/.+ up //' | sed -r 's/  / /'`
if [[ $release_codename ]]; then
    _codename=" $release_codename"
fi
echo -e "Bienvenido a ${c_host}${HOSTNAME}${c_null} $distribution_name$_codename ${c_details}(Ver.${c_null} "`uname -r`" ${c_details}IP.${c_null} $IP${c_details}).${c_null}"
echo -e "${c_details}RAM:${c_null} $rusedram/$rtotalram ${c_details}CPU:${c_null} "`cpupcnt`"% ${c_details}Uptime:${c_null} $uptime_now. Escriba ${c_details}Assistance${c_null} para ayuda."
if [ `whoami` == 'root' ]; then
    echo -e "${c_bold}${c_yellow}Atención:${c_null}${c_bold} estás accediendo como super-usuario. ${c_yellow}Tenga precaución, amigo administrador.${c_null}"
fi

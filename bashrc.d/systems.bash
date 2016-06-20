#-------------------------------------------------------------
# Configuraciones por cada sistema:
#-------------------------------------------------------------
c_host="$c_white";
c_path="$c_light_blue"; # Color para el path por defecto
c_details="$c_dark_gray";
is_server=false;

_system="$HOME/dotfiles/bashrc.d/systems/${HOSTNAME}.bash"
if [ -a "$_system" ]; then
	source "$_system"
fi

distribution_id=`lsb_release -i -s`
distribution_name=`lsb_release -d | awk '{ $1=""; sub(" ", ""); print }'`
distribution_release=`lsb_release -r -s`
distribution_codename=`lsb_release -c -s`

if [[ $distribution_codename == 'n/a' ]]; then
    distribution_codename=
fi

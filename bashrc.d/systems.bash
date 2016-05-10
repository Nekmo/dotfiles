#-------------------------------------------------------------
# Configuraciones por cada sistema:
#-------------------------------------------------------------
c_host="$c_white";
c_path="$c_light_blue"; # Color para el path por defecto
is_server=false;

_system="$HOME/dotfiles/bashrc.d/systems/${HOSTNAME}.bash"
if [ -a "$_system" ]; then
	source "$_system"
fi

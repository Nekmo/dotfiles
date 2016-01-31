#-------------------------------------------------------------
# Administración del sistema:
#-------------------------------------------------------------
# por SSH, ejecutar una aplicación X y dejarla corriendo cuando se salga de SSH
execremote() { DISPLAY=:0 nohup $* &> /dev/null & }

alias sctl="systemctl"
complete -F _systemctl sctl

_service_start () { sudo systemctl start $1 ; sleep 2 ; sudo systemctl status $1; }
alias service-start="_service_start"
_service_stop () { sudo systemctl stop $1 ; sleep 2 ; sudo systemctl status $1; }
alias service-stop="_service_stop"
_service_restart () { sudo systemctl restart $1 ; sleep 2 ; sudo systemctl status $1; }
alias service-restart="_service_restart"
alias service-status="sudo systemctl status"
_service_enable() { service-start $1 && sudo systemctl enable $1; }
alias service-enable="_service_enable"
_service_disable() { service-stop $1 && sudo systemctl disable $1; }
alias service-disable="_service_disable"
alias service-list="systemctl list-units --all"

alias S-start="service-start"
alias S-stop="service-stop"
alias S-restart="service-restart"
alias S-status="service-status"
alias S-enable="service-enable"
alias S-disable="service-disable"
alias S-list="service-list"

# Es necesario tener instalado bash-completion
source /usr/share/bash-completion/completions/systemctl

# Activamos el autocompletado manualmente para los S-*.
__systemctl_complete(){
     local cur=${COMP_WORDS[COMP_CWORD]};
     compopt -o filenames
     COMPREPLY=( $(compgen -o filenames -W '$comps' -- $cur) )
     return 0
}

__systemctl_start_complete(){
    mode=--system;
    comps=$( __get_startable_units $mode;
                         __get_template_names $mode)
    __systemctl_complete
    return 0
}
complete -F __systemctl_start_complete service-start
complete -F __systemctl_start_complete S-start

__systemctl_stop_complete(){
    mode=--system;
    comps=$( __filter_units_by_property $mode CanStop yes \
                      $( __get_active_units $mode ) )
    __systemctl_complete
    return 0
}
complete -F __systemctl_stop_complete service-stop
complete -F __systemctl_stop_complete S-stop

__systemctl_restart_complete(){
    mode=--system;
    comps=$( __get_restartable_units $mode;
                         __get_template_names $mode)
    __systemctl_complete
    return 0
}
complete -F __systemctl_restart_complete service-restart
complete -F __systemctl_restart_complete S-restart

__systemctl_disable_complete(){
    mode=--system;
    comps=$( __get_enabled_units $mode )
    __systemctl_complete
    return 0
}
complete -F __systemctl_disable_complete service-disable
complete -F __systemctl_disable_complete S-disable

__systemctl_enable_complete(){
    mode=--system;
    comps=$( __get_disabled_units $mode;
                        __get_template_names $mode)
    __systemctl_complete
    return 0
}
complete -F __systemctl_enable_complete service-enable
complete -F __systemctl_enable_complete S-enable

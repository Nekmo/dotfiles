#-------------------------------------------------------------
# Gestor de paquetes:
#-------------------------------------------------------------
function restore_backup() {
    if [[ ! "$1" ]]; then
        echo "Uso: P-restore '<nombre del archivo de respaldo>'";
        return
    fi
    pacman -S $(< "$1");
}

function restore_backup_debian() {
    if [[ ! "$1" ]]; then
        echo "Uso: P-restore '<nombre del archivo de respaldo>'";
        return
    fi
    sudo dpkg --clear-selections;
    sudo dpkg --set-selections < "$1" && sudo apt-get dselect-upgrade
}

localize-debian() {
    if [[ "$1" ]]; then
        dpkg-query -L "$1";
    else
        for package in $(dpkg-query -f '${binary:Package}\n' -W); do
            for file in $(dpkg-query -L "$package"); do
                echo "$package: $file";
            done;
        done
    fi
}

list-packages-debian() {
    if [[ "$1" == '--all' ]]; then
        dpkg-query -l
    elif [[ "$1" == '--version' ]]; then
        dpkg-query -f '${binary:Package} ${Version}\n' -W
    else
        dpkg-query -f '${binary:Package}\n' -W
        >&2 echo "(?) Hit: Utiliza --version o --all"
    fi
}

if [[ $distribution_id == 'Arch' ]]; then
    alias P-update='yaourt -Syu --aur -y --noconfirm' # Sincronizar y actualizar sin preguntar
    alias P-install='yaourt -S' # Instalar el paquete o paquetes
    alias P-find='yaourt' # Buscar el paquete por nombre o regex
    alias P-remove='yaourt -Rd' # Borrar el paquete
    alias P-localize='yaourt -Ql' # Localizar archivos de los paquetes
    alias P-list='yaourt -Q' # Listar paquetes instalados
    alias P-list-explicit='yaourt -Qeq' # Listar paquetes explícitamente instalados
    alias P-list-not-official='yaourt -Qem' # Listar paquetes no oficiales y sin soporte
    alias P-clean='yaourt -Scc' # Limpiar cache
    alias P-about='yaourt -Qi' # Información de un paquete
    alias P-reinstall-all='pacman -Qenq | pacman -S -'
    alias P-backup='yaourt -Qqen' # Backup de paquetes instalados
    alias P-restore=restore_backup # Recuperar backup
elif [[ $distribution_id == 'Debian' ]]; then
    if [[ "$distribution_release" > 7.9 ]]; then
        alias P-update='sudo apt update'
        alias P-install='sudo apt install'
        alias P-remove='sudo apt remove'
    else
        alias P-update='sudo apt-get update'
        alias P-install='sudo apt-get install'
        alias P-remove='sudo apt-get remove'
    fi
    alias P-find='apt-cache search'
    alias P-localize='localize-debian'
    alias P-list='list-packages-debian'
    alias P-list-explicit='sudo apt-get clean'
    alias P-clean='sudo apt-get clean'
    alias P-about='apt-cache show'
    alias P-reinstall-all='sudo aptitude --reinstall install "~i"'
    alias P-backup='dpkg --get-selections > packages_backup.txt&& echo "Created backup in packages_backup.txt"'
    alias P-restore='restore_backup_debian'
fi
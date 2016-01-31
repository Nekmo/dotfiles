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

alias P-update='yaourt -Syu --aur -y --noconfirm' # Sincronizar y actualizar sin preguntar
alias P-install='yaourt -S' # Instalar el paquete o paquetes
alias P-find='yaourt' # Buscar el paquete por nombre o regex
alias P-remove='yaourt -Rd' # Borrar el paquete
alias P-localizate='yaourt -Ql' # Localizar archivos de los paquetes
alias P-list='yaourt -Q' # Listar paquetes instalados
alias P-list-explicit='yaourt -Qeq' # Listar paquetes explícitamente instalados
alias P-list-not-official='yaourt -Qem' # Listar paquetes no oficiales y sin soporte
alias P-clean='yaourt -Scc' # Limpiar cache
alias P-about='yaourt -Qi' # Información de un paquete
alias P-reinstall-all='pacman -Qenq | pacman -S -'
alias P-backup='yaourt -Qqen' # Backup de paquetes instalados
alias P-restore=restore_backup # Recuperar backup

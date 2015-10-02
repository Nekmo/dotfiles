#-------------------------------------------------------------
# Gestor de paquetes:
#-------------------------------------------------------------
alias P-update='yaourt -Syu --aur -y --noconfirm' # Sincronizar y actualizar sin preguntar
alias P-install='yaourt -S' # Instalar el paquete o paquetes
alias P-find='yaourt' # Buscar el paquete por nombre o regex
alias P-remove='yaourt -Rd' # Borrar el paquete
alias P-localizate='yaourt -Ql' # Localizar archivos de los paquetes
alias P-list='yaourt -Q' # Listar paquetes instalados
alias P-clean='yaourt -Scc' # Limpiar cache
alias P-about='yaourt -Qi' # Información de un paquete

#-------------------------------------------------------------
# Utilidades de red:
#-------------------------------------------------------------
# Saber la IP pública
alias publicip='curl -s http://checkip.dyndns.org/ | grep -o "[[:digit:].]\+"'

alias N-ports-listening='netstat -plnt'
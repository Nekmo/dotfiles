#-------------------------------------------------------------
# Estadísticas del sistema:
#-------------------------------------------------------------
alias topcmd="history | awk '{a[\$2]++}END{for(i in a){print a[i] \" \" i}}' | sort -rn | head" # Top de comandos frecuentados.
alias df="df -h"
alias top="htop"

# Porcentaje en uso de la CPU
cpupcnt() {
  PREV_TOTAL=0
  PREV_IDLE=0
  CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
  unset CPU[0]                          # Discard the "cpu" prefix.
  IDLE=${CPU[4]}                        # Get the idle CPU time.
  # Calculate the total CPU time.
  TOTAL=0
  for VALUE in "${CPU[@]}"; do
    let "TOTAL=$TOTAL+$VALUE"
  done
  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
  echo "$DIFF_USAGE"
}
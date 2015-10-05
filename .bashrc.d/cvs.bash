
#-------------------------------------------------------------
# Aliases para Mercurial:
#-------------------------------------------------------------
registerAssistanceSection "*CVS* Mercurial"
registerAssistance "hs" "Mostrar estado del repositorio mercurial";
alias hs='hg status'
registerAssistance "hpu" "Hacer hg pull -u: Traer cambios y aplicar";
alias hpu='hg pull -u'
registerAssistance "hc" "Hacer hg commit -Am: Hacer commit con mensaje y añadiendo archivos.";
alias hc='hg commit -Am'


#-------------------------------------------------------------
# Aliases para Git:
#-------------------------------------------------------------
registerAssistanceSection "*CVS* Git"
registerAssistance "gs" "Git status. Estado de repositorio";
alias gs='git status'
registerAssistance "gs" "Git push origin. Hacer el push al servidor de arriba";
alias gp='git push origin'
registerAssistance "gd" "Comprobar los cambios en local";
alias gd='git diff'
registerAssistance "gs" "Git commit -v. Hacer commit con depuración.";
alias gc='git commit -v'
alias gco='git checkout'
alias gcp='git commit -a -v && git push origin'
alias gb='git branch'
#-------------------------------------------------------------
# Trabajo con proyectos
#-------------------------------------------------------------
alias homework='python2 ~/.local/share/homework/__init__.py' # Crear un proyecto de documentación


function template() {
    if [[ ! "$1" || ! "$2" ]]; then
        echo "Uso: template '<nombre template a usar>' '<nombre nuevo proyecto>'";
        echo "Posibles templates:"
        ls ~/Templates/
        return
    fi
    mkdir "$2";
    cp -R ~/Templates/"$1"/. "$2";
    cd "$2";
    mv .hg .hg2
    hg init
    mv .hg2/* .hg/
    rm -rf .hg2
}
alias template=template

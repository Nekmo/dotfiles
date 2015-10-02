#-------------------------------------------------------------
# Trabajo con proyectos
#-------------------------------------------------------------
alias homework='python2 ~/.local/share/homework/__init__.py' # Crear un proyecto de documentación

function template() {
    mkdir "$2";
    cp -R /home/nekmo/Templates/"$1"/. "$2";
    cd "$2";
    mv .hg .hg2
    hg init
    mv .hg2/. .hg/
    rm -rf .hg2
}
alias template=template
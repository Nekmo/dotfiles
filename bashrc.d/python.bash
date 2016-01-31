#-------------------------------------------------------------
# Entorno Python
#-------------------------------------------------------------
# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Workspace
source /usr/bin/virtualenvwrapper.sh

export PYTHONPATH=$PYTHONPATH::


function pypi(){
    repo=$1;
    if [ ! "$repo" ]; then
        repo="pypi"
    elif [ "$repo" == "test" ]; then
        repo="pypitest"
    fi
    python2 setup.py sdist upload -r "$repo"
}

function pypi-test(){
    repo=$1;
    if [ ! "$repo" ]; then
        repo="pypi"
    elif [ "$repo" == "test" ]; then
        repo="pypitest"
    fi
    python2 setup.py register -r "$repo"
}
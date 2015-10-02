#-------------------------------------------------------------
# Entorno Python
#-------------------------------------------------------------
# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Workspace
source /usr/bin/virtualenvwrapper.sh

export PYTHONPATH=$PYTHONPATH::/home/nekmo/Scripts


alias pypi='ansible-playbook ~/playbooks/workflow/pypi.yml --extra-vars "repository=pypi project_dir=$PWD"'
alias pypi-register='ansible-playbook ~/playbooks/workflow/pypi-register.yml --extra-vars "repository=pypi project_dir=$PWD"'
alias pypi-test='ansible-playbook ~/playbooks/workflow/pypi.yml --extra-vars "repository=pypitest project_dir=$PWD"'
alias pypi-test-register='ansible-playbook ~/playbooks/workflow/pypi-register.yml --extra-vars "repository=pypitest project_dir=$PWD"'

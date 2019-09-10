

.PHONY: help

help:
	@echo "Please use \`make <target>' where <target> is one of"
install:
	mv "${HOME}/.tmux" "${HOME}/.tmux.bak" 2> /dev/null || echo -n
	ln -s "${PWD}/.tmux" "${HOME}/.tmux"
	mv "${HOME}/.tmux.conf" "${HOME}/.tmux.conf.bak" 2> /dev/null || echo -n
	ln -s "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
	mkdir -p "${HOME}/.ipython/"
	mv "${HOME}/.ipython/profile_default" "${HOME}/.ipython/profile_default.bak" 2> /dev/null || echo -n
	ln -s "${PWD}/ipython_profile" "${HOME}/.ipython/profile_default"
	mv "${HOME}/.bashrc" "${HOME}/.bashrc.bak" 2> /dev/null || echo -n
	ln -s "${PWD}/.bashrc" "${HOME}/.bashrc"
	@echo
	@echo "Installed dotfiles in ${HOME}"

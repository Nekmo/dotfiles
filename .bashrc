# Check for an interactive session
[ -z "$PS1" ] && return

if [ -z "${DOTFILES_DIR+1}" ]; then
    DOTFILES_DIR=~/dotfiles
fi

source "$DOTFILES_DIR/bashrc.d/colors.bash"
source "$DOTFILES_DIR/bashrc.d/help.bash"
source "$DOTFILES_DIR/bashrc.d/bash_utils.bash"
source "$DOTFILES_DIR/bashrc.d/systems.bash"
source "$DOTFILES_DIR/bashrc.d/shell.bash"
source "$DOTFILES_DIR/bashrc.d/apps.bash"
source "$DOTFILES_DIR/bashrc.d/apps_mods.bash"
source "$DOTFILES_DIR/bashrc.d/package_manager.bash"
source "$DOTFILES_DIR/bashrc.d/devices.bash"
source "$DOTFILES_DIR/bashrc.d/stats.bash"
source "$DOTFILES_DIR/bashrc.d/sys_tools.bash"
source "$DOTFILES_DIR/bashrc.d/cvs.bash"
source "$DOTFILES_DIR/bashrc.d/netutils.bash"
source "$DOTFILES_DIR/bashrc.d/nodes.bash"
source "$DOTFILES_DIR/bashrc.d/projects.bash"
source "$DOTFILES_DIR/bashrc.d/images.bash"
source "$DOTFILES_DIR/bashrc.d/videos.bash"
source "$DOTFILES_DIR/bashrc.d/python.bash"
source "$DOTFILES_DIR/bashrc.d/custom.bash"
source "$DOTFILES_DIR/bashrc.d/hello.bash"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

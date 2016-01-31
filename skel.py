# -*- coding: utf-8 -*-
from os.path import abspath
from gradale.components.nodes import symlink, cp, mkdir, bak_target_decorator, Node, File, Dir
from gradale.utils.decorators import add_decorator
# Definición de cómo se creará el árbol de directorios y archivos en home
# (enlaces simbólicos, nuevos directorios, archivos copiados, etc.).
symlink, mkdir = add_decorator(symlink, mkdir, decorator=bak_target_decorator)
# Añadiremos a los métodos symlink, cp, mkdir... un decorador que los envuelva que haga el backup
# previamente si el destino existe y es diferente al origen.

# Si ~/.bashrc es un symlink a ~/dotfiles/.bashrc ignorar, de lo contrario renombrar como
# ~/bashrc.bak (hacer método en Gradale que renombre como .bakX)
# symlink('.bashrc', '~/.bashrc')
symlink(abspath('.bashrc'), '~/.bashrc')
mkdir('~/Workspace')
symlink(abspath('Workspace/pull.py'), '~/Workspace/pull.py')
symlink(abspath('Workspace/repositories'), '~/Workspace/repositories')


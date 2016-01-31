#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

from gradale.components.nodes import Node, Dir
from gradale.components.processes import Run


PYTHON_VERSIONS = {'python3', 'python2'}


def get_repositories():
    repositories = Node('repositories')
    cwd = os.getcwd()
    if not repositories.lexists():
        cwd = Node('~/Workspace').path
        repositories = Node('~/Workspace/repositories')
    return cwd, repositories


def get_git_folder(repository):
    if repository.endswith('/'):
        repository = repository[:-1]
    if repository.endswith('.git'):
        repository = repository[:-4]
    return repository.split('/')[-1]


def update_repositories():
    cwd, repositories = get_repositories()
    repositories = repositories.readlines(breaklines=False)
    for repository in repositories:
        folder = Node(os.path.join(cwd, get_git_folder(repository)))
        if folder.lexists():
            print('* Pull: %s' % repository)
            Run(['git', 'pull'], cwd=folder)
        else:
            print('* Clone: %s' % repository)
            Run(['git', 'clone', '--recursive', repository], cwd=cwd)


def update_virtualenvs():
    cwd = get_repositories()[0]
    for python_version in PYTHON_VERSIONS:
        if Run([python_version, '--version']).returncode:
            print('No existe {} en el sistema.'.format(python_version))
            continue
        for folder in Dir(cwd).filter(type='d'):
            if not folder.sub('setup.py').exists():
                continue
            print('* Instalando {}...'.format(folder.name))
            Run([python_version, 'setup.py', 'develop', '--user'], cwd=folder)


def update():
    # update_repositories()
    update_virtualenvs()


if __name__ == '__main__':
    update()

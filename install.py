#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import subprocess
import sys
import tempfile
import zipfile

from shutil import rmtree

if sys.version_info >= (3, 0):
    from urllib.request import urlretrieve
else:
    from urllib import urlretrieve

# VENVS = {'~/.venv': '/usr/bin/python3', '~/.venv2': '/usr/bin/python2'}
GRADALE_URL = 'https://github.com/Nekmo/gradale/archive/master.zip'
DEFAULT_TMP_DIR = '/tmp'
GRADALE_DIR = 'gradale-master'

# def init_virtualenvs():
#     # Crear un virtualenv para instalar los proyectos propios, para luego hacer un enlace simbólico
#     # entre el instalado y el del directorio Workspace
#     for venv, py_path in VENVS.items():
#         if not os.path.exists(os.path.expanduser(venv)):
#             subprocess.call(['virtualenv', '-p', py_path, os.path.expanduser(venv)])


def temp_gradale():
    tmp = tempfile.tempdir or DEFAULT_TMP_DIR
    zip_path = os.path.join(tmp, 'gradale.zip')
    gradale_dir = os.path.join(tmp, GRADALE_DIR)
    urlretrieve(GRADALE_URL, zip_path)
    if os.path.exists(gradale_dir):
        rmtree(gradale_dir)
    zipfile.ZipFile(open(zip_path, 'rb')).extractall(tmp)
    sys.path.append(gradale_dir)


def run_pull():
    sys.path.append(os.path.expanduser('~/Workspace/'))
    from pull import update
    update()

def init():
    init_virtualenvs()
    # temp_gradale()
    import skel
    run_pull()

if __name__ == '__main__':
    init()

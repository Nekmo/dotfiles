#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import subprocess
import sys
import tempfile
import zipfile
from uuid import uuid4

from shutil import rmtree

import shutil

if sys.version_info >= (3, 0):
    from urllib.request import urlretrieve
else:
    from urllib import urlretrieve

uuid = uuid4().hex

# VENVS = {'~/.venv': '/usr/bin/python3', '~/.venv2': '/usr/bin/python2'}
GRADALE_URL = 'https://github.com/Nekmo/gradale/archive/master.zip'
DEFAULT_TMP_DIR = '/tmp'
GRADALE_DIR = 'gradale-master-{}'.format(uuid)


# def init_virtualenvs():
#     # Crear un virtualenv para instalar los proyectos propios, para luego hacer un enlace simbólico
#     # entre el instalado y el del directorio Workspace
#     for venv, py_path in VENVS.items():
#         if not os.path.exists(os.path.expanduser(venv)):
#             subprocess.call(['virtualenv', '-p', py_path, os.path.expanduser(venv)])


def temp_gradale():
    tmp = tempfile.tempdir or DEFAULT_TMP_DIR
    zip_path = os.path.join(tmp, 'gradale-{}.zip'.format(uuid))
    gradale_dir = os.path.join(tmp, GRADALE_DIR)
    urlretrieve(GRADALE_URL, zip_path)
    zipfile.ZipFile(open(zip_path, 'rb')).extractall(tmp)
    sys.path.append(gradale_dir)


def clean():
    try:
        os.remove('/tmp/gradale-{}.zip'.format(uuid))
    except Exception:
        pass
    try:
        shutil.rmtree('/tmp/gradale-master-{}'.format(uuid))
    except Exception:
        pass


def run_pull():
    sys.path.append(os.path.expanduser('~/Workspace/'))
    from pull import update
    update()

def init():
    # init_virtualenvs()
    temp_gradale()
    import skel
    # run_pull()
    clean()

if __name__ == '__main__':
    init()

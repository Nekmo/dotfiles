#!/usr/bin/python
# -*- coding: utf-8 -*-
""" Un sencillo programa para editar archivos en el sistema
    utilizando tu editor favorito. Si no hay permisos de
    escritura, se te pedirán automáticamente. """
import sys, os
SUDO = 'kdesu'
EDITOR = 'kwrite'

def dirname(filename):
    if filename[0] in ['\\', '/']:
        # Ruta completa
        return os.path.dirname(filename)
    # Ruta relativa
    workdir = os.getcwd()
    directory = os.path.dirname(filename)
    return os.path.join(workdir, directory)

def check_write(filename):
    # Se comprueba si el fichero existe
    if os.access(filename, os.F_OK):
        # Se devuelven permisos de escritura
        return os.access(filename, os.W_OK)
    # No existe archivo, comprobar si directorio existe
    filename = dirname(filename)
    if not os.access(filename, os.F_OK):
        raise IOError("El directorio %s no existe." % filename)
    # Existe el directorio, devolver permisos escritura
    return os.access(filename, os.W_OK)


if __name__ == '__main__':
    for filename in sys.argv[1:]:
        try:
            write = check_write(filename)
        except Exception as e:
            print("\033[1;31m%s\033[0m" % e)
            sys.exit(0)
        # Cómo ejecutar el programa según permisos escritura
        if write:
            cmd = EDITOR
        else:
            cmd = '%s %s' % (SUDO, EDITOR)
        # Ejecutar editor
        os.system('%s "%s"' % (cmd, filename))
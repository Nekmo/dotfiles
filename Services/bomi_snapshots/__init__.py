#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

from ftplib import FTP
import os
import sys
import commands
import tempfile
import dbus
import re
import pynotify
import gtk
import urllib
from PIL import Image, ImageFile
import time
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer
from nekutils.tvshow_name import TVShowName
import threading
import uuid
# import subprocess
# ImageFile.LOAD_TRUNCATED_IMAGES = True

SERVER = 'share.nekmo.org'
USER = 'share'
PASSWORD = '*********'
CWD = '/bomi'
URL = 'http://share.nekmo.org/bomi/'
ICON_FILE = '/usr/share/icons/oxygen/32x32/actions/edit-paste.png'
LOCAL_PATH = '/home/nekmo/Images/bomi'


def ns2str(t):
    t = t / 1000000.0
    minutes = int(t / 60)
    seconds = t % 60
    return '%02i-%02i' % (minutes, seconds)

class Bomi:
    def __init__(self):
        self.bus = dbus.SessionBus()

    def get_obj(self):
        return self.bus.get_object("org.mpris.MediaPlayer2.bomi", "/org/mpris/MediaPlayer2")

    def get_properties(self):
        return dbus.Interface(self.get_obj(), "org.freedesktop.DBus.Properties")

    def get_metadata(self):
        return self.get_properties().Get("org.mpris.MediaPlayer2.Player", "Metadata")

    def get_position(self):
        return self.get_properties().Get("org.mpris.MediaPlayer2.Player", "Position")

    def get_filename(self):
        return self.get_metadata()['xesam:url'].split('/')[-1]

def last_file(files):
    if not files:
        return PATTERN2 % 1
    fsns = []
    for file in files:
        if re.match(PATTERN, file):
            fsns.append(int(re.match(PATTERN, file).group(1)))
    return PATTERN2 % (sorted(fsns)[-1] + 1)

def send(filename):
    ftp = FTP(SERVER)
    ftp.login(USER, PASSWORD)
    ftp.cwd(CWD)
    fsn = last_file(ftp.nlst())
    ftp.storbinary("STOR " + fsn, open(filename, "rb"), 1024)
    return URL + fsn

def getpid():
    return commands.getoutput('pidof -s ksnapshot')

def setfile(pid):
    filename = '/tmp/snapshot_%s.png' % pid
    bus = dbus.SessionBus()
    obj = bus.get_object('org.kde.ksnapshot-%s' % pid, '/KSnapshot')
    obj.get_dbus_method('save', dbus_interface='org.kde.ksnapshot')\
                        (filename)
    bus.close()
    im = Image.open(filename)
    new_filename = '/tmp/snapshot_%s.jpg' % pid
    im.save(new_filename, "JPEG", quality=70)
    return new_filename

def setclipboard(url):
    bus = dbus.SessionBus()
    obj = bus.get_object('org.kde.klipper', '/klipper')
    obj.get_dbus_method('setClipboardContents',
                        dbus_interface='org.kde.klipper.klipper')(url)
    bus.close()


def notification(title, text):
    pynotify.init("Bomi Captura")
    msg = pynotify.Notification(title, text)

    pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(ICON_FILE, 32, 32)
    msg.set_icon_from_pixbuf(pixbuf)
    msg.show()


def create_compressed_image(file):
    # compressed = '/tmp./%sjpg' % uuid.uuid1()
    compressed = tempfile.NamedTemporaryFile(suffix='.jpg').name
    for i in range(10):
        try:
            im = Image.open(file)
            im.save(compressed, "JPEG", quality=70)
        except:
            time.sleep(0.1)
    # subprocess.check_output(['convert', '-quality', '70', file, compressed])
    return compressed


class CreatedDaemon(FileSystemEventHandler):

    def on_created(self, event):
        threading.Thread(target=self._on_created, args=(event,)).start()

    def _on_created(self, event):
        print("Detectado nuevo archivo creado: " + event.src_path)
        bomi = Bomi()
        compressed = create_compressed_image(event.src_path)
        file = TVShowName(bomi.get_filename())
        # Crear nueva sesión FTP
        ftp = FTP(SERVER)
        ftp.login(USER, PASSWORD)
        ftp.cwd(CWD)
        # Listar archivos
        if not file.tvshow in ftp.nlst():
            ftp.mkd(os.path.join(CWD, file.tvshow))
        ftp.cwd(file.tvshow)
        t = ns2str(bomi.get_position())
        name = '%s_%s_%s.jpg' % (file.seasson if file.seasson else '1', file.chapter, t)
        url = '%s%s/%s' % (URL, urllib.quote(file.tvshow.encode('utf-8')), name)
        print("Subida imagen en: " + url)
        setclipboard(url)
        notification("Captura transferida",
                     'La url de la captura es: <a href="%(url)s">%(url)s</a>' % {'url': url})
        ftp.storbinary("STOR " + name, open(compressed, "rb"), 1024)
        notification("Transfiriendo captura",
                     'La url será: <a href="%(url)s">%(url)s</a>' % {'url': url})
        return super(CreatedDaemon, self).on_created(event)


if __name__ == "__main__":
    event_handler = CreatedDaemon()
    observer = Observer()
    observer.schedule(event_handler, LOCAL_PATH, recursive=False)
    observer.daemon = True
    observer.start()
    while True: time.sleep(0.2)
    #pid = getpid()
    #filename = setfile(pid)
    #url = send(filename)
    #pynotify.init("Mi aplicacion")
    #msg = pynotify.Notification("Captura transferida",
                                #"La captura se ha transfedo en %s" % url)

    #pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(ICON_FILE, 32, 32)
    #msg.set_icon_from_pixbuf(pixbuf)
    #msg.show()
    #setclipboard(url)
    ## Cerrar la ventana de ksnapshot
    #bus = dbus.SessionBus()
    #obj = bus.get_object('org.kde.ksnapshot-%s' % pid, '/KSnapshot')
    #obj.get_dbus_method('exit', dbus_interface='org.kde.ksnapshot')()
    #bus.close()
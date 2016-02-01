#!/usr/bin/env python3
import re
from libs import mal
import sys
import os
import time
import locale
import dbus
from libs import phpbb
import requests
import json
from PIL import Image, ImageFont, ImageDraw
from ftplib import FTP

locale.setlocale(locale.LC_TIME, "es_ES.utf8")

serie = sys.argv[1]
if serie.endswith('/'): serie = serie[:-1]
serie = serie.split(os.path.sep)[-1]

SERVER = 'nekmo.org'
USER = 'http'
PASSWORD = '*******'
CWD = '/share/tvshow'

def send(from_, tofilename):
    ftp = FTP(SERVER)
    ftp.login(USER, PASSWORD)
    ftp.cwd(CWD)
    ftp.storbinary("STOR " + tofilename, open(from_, 'rb'), 1024)

def clear_video_name(name):
    """
    Renombrar el nombre de archivo de forma
    legible con el nombre del vídeo y capítulo
    """
    # Eliminar extensión
    if '.' in name: name = '.'.join(name.split('.')[:-1])
    # Eliminar todo aquello entre corchetes
    name = re.sub('\[[^\]]+\]', '', name)
    # Eliminar palabras sobre calidad de vídeo
    name = re.sub('hd|dvd|720p|1080p|tv', '', name, flags=re.IGNORECASE)
    # Sustituir puntos y barras bajas por espacios
    name = re.sub('\.|_', ' ', name)
    # Eliminar guiones separadores
    name = re.sub(' - ', ' ', name)
    # Eliminar las almohadillas
    name = re.sub('#', ' ', name)
    # Eliminar espacios múltiples, y sustiuir por 1
    name = re.sub(' +', ' ', name)
    # Eliminar espacio del comienzo del nombre
    if name.startswith(' '): name = name[1:]
    # Eliminar espacio del final del nombre
    if name.endswith(' '): name = name[:-1]
    # Poner como título el nombre
    name = name.title()
    return name

class Gajim(object):
    """
    Obtener y establecer show/status en Gajim
    """
    def __init__(self, account):
        self.account = account
        bus = dbus.SessionBus()
        self.obj = bus.get_object("org.gajim.dbus", "/org/gajim/dbus/RemoteObject")
    def get_accounts(self):
        return self.obj.list_accounts()
    def get_show(self, account=None):
        """
        Obtener el show (online, away, xa, dnd...)
        """
        if not account: account = self.account
        return self.obj.get_status(account,
                                   dbus_interface="org.gajim.dbus.RemoteInterface")
    def get_status(self, account=None):
        """
        Obtener el mensaje de estado
        """
        if not account: account = self.account
        return self.obj.get_status_message(account,
                                           dbus_interface="org.gajim.dbus.RemoteInterface")
    def set_status(self, show, status, account=None):
        """
        Establecer el show y el status
        """
        if not account: account = self.account
        self.obj.change_status(show, status, account,
                               dbus_interface="org.gajim.dbus.RemoteInterface")

    def send_chat_message(self, jid, message, account=None):
        if not account: account = self.account
        self.obj.send_chat_message(jid, message, '', account,
                               dbus_interface="org.gajim.dbus.RemoteInterface")

    def send_groupchat_message(self, jid, message, account=None):
        if not account: account = self.account
        self.obj.send_groupchat_message(jid, message, account,
                               dbus_interface="org.gajim.dbus.RemoteInterface")


forum = phpbb.phpBB('http://www.elotrolado.net/')
forum.login('capitanquartz', '******')
post = forum.lastPost(60, 1348438)
author = post.find('dd', {'class': 'author'}).find('a').text

with open(os.path.join(os.environ['HOME'], '.config', 'tvshow')) as f:
    last_tvshow = clear_video_name(f.read())


with open(os.path.join(os.environ['HOME'], '.local', 'share', 'malscore', last_tvshow + '.json')) as f:
    last_tvshow_data = json.loads(f.read())

m = mal.MAL('nekmo', '*******')
results = m.search(serie)
result = next(results)
result.watch = 'watching'
result.save()

with open('/tmp/last_tvshow.jpg', 'wb') as f:
    f.write(requests.get(last_tvshow_data['image']).content)

with open('/tmp/tvshow.jpg', 'wb') as f:
    f.write(requests.get(result.image).content)

gajim = Gajim('nekmo.org')
gajim.send_chat_message('nekmo@nekmo.org/away', '$tvshow %s' % serie)

message = """
*Terminado:* %s (Puntuación: %i/10).
*Empezando:* %s.""" % (last_tvshow_data['title'], last_tvshow_data['score'], result.title)


for sala in ['eolfansub@salas.nekmo.org', 'offtopic@conf.jabberes.org']:
    try:
        gajim.send_groupchat_message(sala, message)
    except Exception as e:
        print(e)

im = Image.new('RGBA', (600, 500))
background = Image.open(os.path.join(os.path.dirname(__file__), 'watching_background.png'))
im.paste(background, (0,0))

def crop(img):
    if not img.size[0] > 225 and not img.size[1] > 320: return img
    img = img.convert('RGBA')
    overflow_width = 225 - img.size[0]
    overflow_height = 320 - img.size[1]
    img = img.crop((
        int(overflow_width / 2.0), int(overflow_height / 2.0), 225, 320
    ))
    return img

img1 = Image.open('/tmp/last_tvshow.jpg')
orig_size = img1.size
img1 = crop(img1)
im.paste(img1, (7, 80 - (orig_size[1] - 320) // 2))

img2 = Image.open('/tmp/tvshow.jpg')
orig_size = img2.size
img2 = crop(img2)
im.paste(img2, (356, 80 - (orig_size[1] - 320) // 2))

im.save('/tmp/watching.png', "PNG")

to_filename = '%i.png' % time.time()
send('/tmp/watching.png', to_filename)

message = ''
if 'capitanquartz' in author:
    post = int(post['id'][1:])
    message = forum.editPage(60, post).find('textarea', id='message').text
    message += time.strftime("\n\n--- Editado el %x a las %X ---\n\n")
message += '[center][img]http://nekmo.org/share/tvshow/%s[/img][/center]' % to_filename
message += '[center][size=200]Puntuación: [b]%i[/b]/10[/size][/center]' % last_tvshow_data['score']
message += '\n[center]'
message += '[b]Terminada de ver:[/b] [url=http://myanimelist.net/anime.php?id=%i]%s[/url].\n\n' % (last_tvshow_data['id'], last_tvshow_data['title'])
message += '[b]Viendo ahora mismo:[/b] [url=http://myanimelist.net/anime.php?id=%i]%s[/url].' % (result.id, result.title)
message += '[/center]'


if 'capitanquartz' in author:
    forum.postEdit(60, post, message)
else:
    forum.postReply(60, 1348438, message)

with open(os.path.join(os.environ['HOME'], '.config', 'tvshow'), 'w') as f:
    f.write(serie)

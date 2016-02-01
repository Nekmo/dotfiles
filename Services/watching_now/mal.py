#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""Library in Python for MyAnimeList
"""
USERAGENT = 'api-indiv-*********************************************'

import requests
import sys
import lxml.etree
import lxml.html
from datetime import datetime
if sys.version_info < (3,0):
    reload(sys)
    sys.setdefaultencoding('utf8')
    import urlparse
    import urllib
    urllib.parse = urlparse
    for attr in dir(urllib):
        setattr(urllib.parse, attr, getattr(urllib, attr))
from urllib import parse
from requests.auth import HTTPBasicAuth


class MAL(object):
    SEARCH_URL = 'http://myanimelist.net/api/%(type)s/search.xml?q=%(query)s'
    ADD_URL = 'http://myanimelist.net/api/animelist/add/%(id)i.xml'
    UPDATE_URL = 'http://myanimelist.net/api/animelist/update/%(id)i.xml'
    LIST_URL = 'http://myanimelist.net/malappinfo.php?u=%(username)s&status=all&type=%(type)s'

    def __init__(self, username, password):
        self.auth(username, password)
        self.s = requests.Session()
        self.s.headers.update({'User-Agent': USERAGENT})

    def auth(self, username, password):
        self._auth = HTTPBasicAuth(username, password)

    def search(self, query, type_='anime'):
        url = self.SEARCH_URL % {'type': type_, 'query': parse.quote(query)}
        response = self.s.get(url, auth=self._auth)
        root = lxml.html.fromstring(response.content)
        for element in root:
            yield MALResult(element, type_, self)

    def add(self, id, root):
        url = self.ADD_URL % {'id': id}
        response = self.s.post(url, data={'data': lxml.etree.tostring(root)}, auth=self._auth)
        return response.content

    def update(self, id, root):
        url = self.UPDATE_URL % {'id': id}
        response = self.s.post(url, data={'data': lxml.etree.tostring(root)}, auth=self._auth)
        return response.content

    def get_list(self, type, username):
        return MALList(type, username, self)

class MALList(list):
    def __init__(self, list_type, username, main):
        self.list_type, self.username, self.main = list_type, username, main
        url = self.main.LIST_URL % {'username': username, 'type': list_type}
        # body = self.main.s.get(url, auth=self.main._auth)
        with open('/tmp/malappinfo.xml', 'rb') as f:
            body = f.read()
        for element in lxml.html.fromstring(body):
            if element.tag == 'myinfo': continue
            self.append(MALResult(self.result_relationship(element), list_type, main))

    def result_relationship(self, element):
        relations = {
            'series_animedb_id': 'id',
            'my_id': 'my_id',
            'my_status': 'watch',
            'my_watched_episodes': 'episode',
        }
        element.tag = self.list_type
        for child in element:
            if child.tag in relations:
                child.tag = relations[child.tag]
            else:
                child.tag = '_'.join(child.tag.split('_')[1:])
        return element

class MALResult(object):
    result_type = 'anime'
    unsaved_entry = None
    interfaces = {'id@int', 'title', 'english', 'synonyms', 'episodes@int', 'score@float', 'type', 'status',
                  'start_date@date', 'end_date@date', 'synopsys', 'image'}
    anime_fields = {'episode@int', 'score@int', 'downloaded_episodes@int', 'storage_type@int', 'storage_value@float',
                    'times_rewatched@float', 'rewatch_value@int', 'date_start', 'date_finish', 'priority@int',
                    'enable_discussion@bool', 'enable_rewatching@bool', 'comments@str', 'fansub_group@str', 'tags@list',
                    'watch'}

    def __new__(cls, *args):
        def _at_fields(from_):
            to = {}
            for value in from_:
                value = value.split('@')
                type = value[1] if len(value) > 1 else None
                value = value[0]
                to[value] = type
            return to
        cls._interfaces = _at_fields(cls.interfaces)
        cls._anime_fields = _at_fields(cls.anime_fields)
        if sys.version_info < (3,0):
            return super(MALResult, cls).__new__(cls, *args)
        else:
            return super().__new__(cls)

    def __init__(self, element, result_type, main):
        if isinstance(element, int):
            # Es el identificador numérico de MAL, no un elemento lxml
            self.id = element
            element = None
        self.result_type, self.element, self.main = result_type, element, main

    def __getattribute__(self, item):
        internals = ('_interfaces', '_anime_fields', '_manga_fields', 'result_type')
        if item in internals or (not item in self._interfaces and not item in getattr(self, '_%s_fields' % self.result_type)):
            return object.__getattribute__(self, item)
        element = self.element.find(item)
        if element is None: return None
        text = element.text
        if self._interfaces.get(item, False):
            return getattr(self, self._interfaces[item] + '_parser')(text)
        elif getattr(self, '_%s_fields' % self.result_type).get(item, False):
            return getattr(self, getattr(self, '_%s_fields' % self.result_type)[item] + '_parser')(text)
        return text


    def __setattr__(self, item, value):
        fields = getattr(self, '_%s_fields' % self.result_type)
        synonyms = {
            'watch': 'status',
        }
        if not item in fields and not item in synonyms:
            return super(MALResult, self).__setattr__(item, value)
        item = synonyms.get(item, item)
        if self.unsaved_entry is None: self.unsaved_entry = lxml.etree.Element('entry')
        elem = self.unsaved_entry.find(item)
        if elem is None:
            elem = lxml.etree.Element(item)
            self.unsaved_entry.append(elem)
        elem.text = str(value)

    def save(self):
        self.main.add(self.id, self.unsaved_entry)
        resp = self.main.update(self.id, self.unsaved_entry)
        self.unsaved_entry = None
        return resp

    def int_parser(self, value):
        return int(value)

    def float_parser(self, value):
        return float(value)

    def date_parser(self, value):
        return datetime.strptime(value, '%Y-%m-%d')

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('username')
    parser.add_argument('password')
    parser.add_argument('query')
    parser.add_argument('-m', '--manga', action='store_true', help='Search for manga')
    args = parser.parse_args()
    mal = MAL(args.username, args.password)
    print(mal.search(args.query, 'manga' if args.manga else 'anime'))
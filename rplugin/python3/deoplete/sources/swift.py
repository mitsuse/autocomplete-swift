#!/usr/bin/env python
# coding: utf-8

from .base import Base


class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'swift'
        self.mark = '[swift]'
        self.filetypes = ['swift']
        self.min_pattern_length = 4
        self.max_pattern_length = 30
        self.input_pattern = '(?:\.|(?:,|:|->)\s+)\w*'

        self.__completer = Completer(vim)

    def get_complete_position(self, context):
        return self.__completer.decide_completion_position(
            context['input'],
            int(self.vim.eval('col(\'.\')'))
        )

    def gather_candidates(self, context):
        return self.__completer.complete(
            int(self.vim.eval('line(\'.\')')),
            context['complete_position'] + 1
        )


class Completer(object):
    def __init__(self, vim):
        import re

        self.__vim = vim
        self.__completion_pattern = re.compile('\w*$')
        self.__placeholder_pattern = re.compile(
            '<#(?:T##)?(?:[^#]+##)?(?P<desc>[^#]+)#>'
        )

    def complete(self, line, column):
        import os
        from deoplete import util

        text = self.__vim.current.buffer[:]
        path, offset = self.__prepare_completion(text, line, column)

        completer = self.__decide_completer()
        candidates_json = completer.complete(path, offset)
        os.remove(path)

        return [self.__convert_candidates(c) for c in candidates_json]

    def decide_completion_position(self, text, column):
        result = self.__completion_pattern.search(text)

        if result is None:
            return column - 1

        return result.start()

    def __decide_completer(self):
        port = int(self.__vim.call('sourcekitten_daemon#port'))

        if port <= 0:
            return SourceKitten()

        return SourceKittenDaemon(port)

    def __prepare_completion(self, text, line, column):
        import tempfile

        encoding = self.__vim.options['encoding']

        offset = 0
        path = tempfile.mktemp()

        with open(path, mode='w') as f:
            for index, s in enumerate(text):
                l = s + '\n'

                if index < line - 1:
                    offset += len(bytes(l, encoding))

                f.write(l)

            offset += column - 1

        return (path, offset)

    def __filter_newline(self, text):
        return text.replace('\n', '')

    def __convert_candidates(self, json):
        return {
            'word': self.__filter_newline(self.__convert_placeholder(json['sourcetext'])),
            'abbr': json['name']
        }

    def __convert_placeholder(self, text):
        variables = {'index': 0}

        def replacer(match):
            try:
                description = match.group('desc')
                variables['index'] += 1
                return '<`{}:{}`>'.format(variables['index'], description)

            except IndexError:
                return ''

        return self.__placeholder_pattern.sub(replacer, text)


class SourceKitten(object):
    def __init__(self, command='sourcekitten'):
        self.__command = command

    def complete(self, path, offset):
        import subprocess
        import json

        if not self.is_executable:
            return []

        try:
            request = [
                self.__command,
                'complete',
                '--file', path,
                '--offset', str(offset)
            ]
            return json.loads(subprocess.check_output(request).decode())

        except subprocess.CalledProcessError:
            return []

    @property
    def is_executable(self):
        import shutil

        return shutil.which(self.__command) is not None


class SourceKittenDaemon(object):
    def __init__(self, port=8081):
        self.__endpoint = 'http://localhost:{}/complete'.format(port)

    def complete(self, path, offset):
        import json
        from urllib import request

        response = request.urlopen(
            request.Request(
                self.__endpoint,
                method='GET',
                headers={'X-Offset': offset, 'X-Path': path}
            )
        )

        if response.status != 200:
            return []

        return json.loads(response.read().decode())

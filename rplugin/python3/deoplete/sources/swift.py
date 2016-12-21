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
        self.input_pattern = '((?:\.|(?:,|:|->)\s+)\w*|\()'

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
        from deoplete import util

        content, offset = self.__prepare_completion(line, column)

        completer = self.__decide_completer()
        candidates_json = completer.complete(content, offset)

        return [self.__convert_candidates(c) for c in candidates_json]

    def decide_completion_position(self, text, column):
        result = self.__completion_pattern.search(text)

        if result is None:
            return column - 1

        return result.start()

    def __decide_completer(self):
        try:
            toolchain = self.__vim.eval('autocomplete_swift#toolchain')
        except:
            toolchain = None

        try:
            command = self.__vim.eval('autocomplete_swift#sourcekitten_command')
        except:
            command = 'sourcekitten'

        return SourceKitten(command=command, toolchain=toolchain)

    def __prepare_completion(self, row, column):
        text_list = self.__vim.current.buffer[:]
        encoding = self.__vim.options['encoding']

        content = '\n'.join(text_list) 

        offset = 0
        for row_current, text in enumerate(text_list):
            if row_current < row - 1:
                offset += len(bytes(text, encoding)) + 1
        offset += column - 1

        return (content, offset)

    def __filter_newline(self, text):
        return text.replace('\n', '')

    def __convert_candidates(self, json):
        return {
            'word': self.__filter_newline(self.__convert_placeholder(json['sourcetext'])),
            'abbr': json['descriptionKey'],
            'kind': json['kind'].split('.')[-1]
        }

    def __convert_placeholder(self, text):
        variables = {'index': 0}

        neosnippet_func = '*neosnippet#get_snippets_directory'
        used_neosnippet = int(self.__vim.call('exists', neosnippet_func)) == 1

        if not used_neosnippet:
            return text

        def replacer(match):
            try:
                description = match.group('desc')
                variables['index'] += 1
                return '<`{}:{}`>'.format(variables['index'], description)

            except IndexError:
                return ''

        return self.__placeholder_pattern.sub(replacer, text)


class SourceKitten(object):
    def __init__(self, command='sourcekitten', toolchain=None):
        import os

        self.__command = command
        self.__environment = os.environ.copy()

        if toolchain is not None:
            self.__environment['TOOLCHAINS'] = toolchain

    def complete(self, content, offset):
        import subprocess
        import json

        if not self.is_executable:
            return []

        try:
            command = [
                self.__command,
                'complete',
                '--text', content,
                '--offset', str(offset)
            ]

            output, _ = subprocess.Popen(
                command,
                stdout=subprocess.PIPE,
                env=self.__environment
            ).communicate()

            return json.loads(output.decode())

        except subprocess.CalledProcessError:
            return []

    @property
    def is_executable(self):
        import shutil

        return shutil.which(self.__command) is not None

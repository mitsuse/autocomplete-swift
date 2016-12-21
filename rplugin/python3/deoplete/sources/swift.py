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
        path, content, offset = self.__prepare_completion(line, column)

        completer = self.__decide_completer()
        candidates_json = completer.complete(path, content, offset)

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
        path = self.__vim.call('expand', '%:p')
        if len(path) == 0:
            path = None

        content = '\n'.join(text_list)

        offset = 0
        for row_current, text in enumerate(text_list):
            if row_current < row - 1:
                offset += len(bytes(text, encoding)) + 1
        offset += column - 1

        return (path, content, offset)

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

    def complete(self, path, content, offset):
        import os
        import subprocess
        import tempfile
        import json

        if not self.is_executable:
            return []

        temporary_path = tempfile.mktemp()
        try:
            with open(temporary_path, 'w') as f:
                f.write(content)
        except:
            return []

        arguments = SourceKitten.generate_arguments(path, temporary_path)

        try:
            command = [
                self.__command,
                'complete',
                '--file', temporary_path,
                '--offset', str(offset)
            ] + arguments

            output, _ = subprocess.Popen(
                command,
                stdout=subprocess.PIPE,
                env=self.__environment
            ).communicate()

            os.remove(temporary_path)

            return json.loads(output.decode())

        except subprocess.CalledProcessError:
            os.remove(temporary_path)

            return []

    @property
    def is_executable(self):
        import shutil

        return shutil.which(self.__command) is not None

    @staticmethod
    def generate_arguments(path, temporary_path):
        import os

        if path is None:
            return []
        absolute_path = os.path.abspath(path)

        project = Project.find_from_source(absolute_path)
        if project is None:
            return []

        module = project.find_module(absolute_path)
        if module is None:
            return []

        arguments = \
            ['--', temporary_path] + \
            list(filter(lambda x: x != absolute_path, module.sources)) + \
            ['-module-name', module.name] + \
            module.other_arguments + \
            ['-I'] + \
            list(module.imports)

        return arguments


class Project(object):
    def __init__(self, path, modules):
        import os

        self.path = path
        self.modules = modules

    @staticmethod
    def load(path):
        import os

        with open(os.path.join(path, '.build', 'debug.yaml')) as f:
            modules = Module.load(f)

        return Project(path, modules)

    def find_module(self, source_path):
        import os

        absolute_path = os.path.abspath(source_path)

        for module in self.modules:
            if absolute_path in module.sources:
                return module

        return None

    @staticmethod
    def find_from_source(path):
        root = Project.find_root_from_source(path)
        if root is None:
            return None

        try:
            return Project.load(root)
        except:
            return None

    @staticmethod
    def find_root_from_source(path):
        import os

        previous_path = path
        while True:
            current_path = os.path.dirname(os.path.abspath(previous_path))
            if current_path == previous_path:
                break

            description_path = os.path.join(current_path, 'Package.swift')
            if os.path.isfile(description_path):
                return current_path

            previous_path = current_path

        return None


class Module(object):
    def __init__(self, name, sources, imports, other_arguments):
        self.name = name
        self.sources = sources
        self.imports = imports
        self.other_arguments = other_arguments

    @staticmethod
    def load(f):
        import yaml

        obj = yaml.load(f)

        def convert_to_log(obj):
            name = obj.get('module-name')
            if name is None:
                return None

            return Module(
                name,
                set(obj.get('sources', [])),
                set(obj.get('import-paths', [])),
                obj.get('other-args', [])
            )

        generator = filter(
            lambda x: x is not None,
            map(
                lambda x: convert_to_log(x),
                obj.get('commands', {}).values()
            )
        )

        return list(generator)

#!/usr/bin/python
# -*- coding: utf-8 -*-
""" Merges two nextcloud configuration files into one.

License:
    The MIT License (MIT)

    Copyright © 2016 Andre Lehmann

    Permission is hereby granted, free of charge, to any person obtaphpng a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
"""

from os.path import exists, abspath
import argparse
import sys
import StringIO
import string
import ast

import phply.phplex
from phply.phpparse import make_parser
from phply import pythonast

from unparse import Unparser

__author__ = "Andre Lehmann"
__copyright__ = "Copyright 2017, Andre Lehmann"
__license__ = "MIT"
__version__ = "1.0.1"
__maintainer__ = "Andre Lehmann"
__email__ = "aisberg@posteo.de"
__status__ = "Production"


class FileNotFoundError(IOError):
    """ File not found exception

    Args:
        message (str): Message passed with the exception

    """
    def __init__(self, message):
        super(FileNotFoundError, self).__init__(
            "File not found: {0}".format(message))


class PHPSyntaxError(Exception):
    """ PHP syntax error

    Args:
        message (str): Message passed with the exception

    """
    def __init__(self, message):
        super(PHPSyntaxError, self).__init__(
            "PHP syntax error: {0}".format(message))


def _merge_dicts(x, y):
        """ Recursivly merges two dicts

        When keys exist in both the value of 'y' is used.

        Args:
            x (dict): First dict
            y (dict): Second dict

        Returns:
            dict.  Merged dict containing values of x and y

        """
        # when one of the dicts is empty, than just return the other one
        if x is None:
            if y is None:
                return dict()
            else:
                return y
        if y is None:
            if x is None:
                return dict()
            else:
                return x
        if type(y) == list:
            return y

        merged = dict(x, **y)
        xkeys = x.keys()

        # update 'branches' of the individual keys
        for key in xkeys:
            # if this key is a dictionary, recurse
            if type(x[key]) is dict and key in y:
                merged[key] = _merge_dicts(x[key], y[key])
        return merged


def php_to_dict(content_string):
    parser = make_parser()
    body = [pythonast.from_phpast(a)
            for a in parser.parse(content_string, lexer=phply.phplex.lexer)]
    f = StringIO.StringIO()
    Unparser(body, f)
    content = ast.literal_eval(f.getvalue()[10:])
    f.close()
    # reload lexer otherwise parsing a second file will fail
    reload(phply.phplex)
    return content


def dict_to_php(input, f):
    if type(input) == dict:
        f.write("[\n")
        a = sorted(input.items())
        for i in range(len(a)):
            key, val = a[i]
            if key[0] == "\\":
                tmp = string.replace(key, '.', '::')
                f.write(tmp)
            else:
                f.write("'")
                f.write(key)
                f.write("'")
            f.write(" => ")
            dict_to_php(input[key], f)
            if i != len(a) - 1:
                f.write(",\n")
            else:
                f.write("\n")
        f.write("]")

    elif type(input) == list:
        f.write("[\n")
        for i in range(len(input)):
            dict_to_php(input[i], f)
            if i != len(input) - 1:
                f.write(",\n")
            else:
                f.write("\n")
        f.write("]")
    elif type(input) == str or type(input) == unicode:
        f.write("'")
        f.write(input)
        f.write("'")
    else:
        f.write(str(input))


def mergeNextCloudConfigurations(argv):
    """ Merges two php files into one

    Args:
        argv (list): Command line arguments

    """
    parser = argparse.ArgumentParser(
        prog='merge_php_files',
        description='Merges two php files into one.',
        epilog=''
    )
    parser.add_argument('-d', '--dry-run', action='store_true',
                        dest='dry_run', default=False,
                        help='Only prints the resulting merged content')

    parser.add_argument('first_file', help='Path to the first php file')
    parser.add_argument('second_file', help='Path to the second php file')
    parser.add_argument('dest', nargs='?', help='Destination of the resulting file. If not specified the result will be written into the first file.')
    args = parser.parse_args(argv)

    # load files
    first_file = abspath(args.first_file)
    second_file = abspath(args.second_file)
    if not exists(first_file):
        raise FileNotFoundError(first_file)
    if not exists(second_file):
        raise FileNotFoundError(second_file)

    with open(first_file, 'r') as f:
        first_content = f.read().decode('utf-8')

    with open(second_file, 'r') as f:
        second_content = f.read().decode('utf-8')

    # merge content of files
    merged_content = _merge_dicts(php_to_dict(first_content),
                                  php_to_dict(second_content))

    # write new php file
    if not args.dry_run:
        # write merged content
        dest = args.dest
        if dest is None:
            dest = first_file
        with open(dest, 'w') as f:
            f.write("<?php\n$CONFIG = ")
            dict_to_php(merged_content, f)
            f.write(";\n")
    else:
        print(merged_content)


if __name__ == '__main__':
    mergeNextCloudConfigurations(sys.argv[1:])
    # try:
    #     mergeNextCloudConfigurations(sys.argv[1:])
    #     exit(0)
    # except Exception as e:
    #     print(e.message)
    #     exit(1)

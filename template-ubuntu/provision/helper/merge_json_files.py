#!/usr/bin/python
# -*- coding: utf-8 -*-
""" Merges two json files into one.

License:
    The MIT License (MIT)

    Copyright © 2016 Andre Lehmann

    Permission is hereby granted, free of charge, to any person obtaining a copy
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
import json
import sys
import types

__author__ = "Andre Lehmann"
__copyright__ = "Copyright 2016, Andre Lehmann"
__license__ = "MIT"
__version__ = "1.0.0"
__maintainer__ = "Andre Lehmann"
__email__ = "aisberg@posteo.de"
__status__ = "Production"

class FileNotFoundError(IOError):
    """ File not found exception

    Args:
        message (str): Message passed with the exception

    """
    def __init__(self, message):
        super(FileNotFoundError, self).__init__("File not found: {0}".format(message))

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
        if type(x) is types.NoneType:
            if type(y) is types.NoneType:
                return dict()
            else:
                return y
        if type(y) is types.NoneType:
            if type(x) is types.NoneType:
                return dict()
            else:
                return x

        merged = dict(x,**y)
        xkeys = x.keys()

        # update 'branches' of the individual keys
        for key in xkeys:
            # if this key is a dictionary, recurse
            if type(x[key]) is types.DictType and y.has_key(key):
                merged[key] = _merge_dicts(x[key],y[key])
        return merged

def mergeJsonFiles(argv):
    """ Merges two json files into one

    Args:
        argv (list): Command line arguments

    """
    parser = argparse.ArgumentParser(
        prog='merge_json_files',
        description='Merges two json files into one.',
        epilog=''
    )
    parser.add_argument('-d', '--dry-run', action='store_true',
                        dest='dry_run', default=False,
                        help='Only prints the resulting merged content')

    parser.add_argument('first_file', help='Path to the first json file')
    parser.add_argument('second_file', help='Path to the second json file')
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
    merged_content = json.dumps(
                        _merge_dicts(json.loads(first_content), json.loads(second_content)),
                        indent = 4)

    if not args.dry_run:
        # write merged content
        dest = args.dest
        if dest == None:
            dest = first_file
        with open(dest, 'w') as f:
            f.write(merged_content)
    else:
        print(merged_content)

if __name__ == '__main__':
    try:
        mergeJsonFiles(sys.argv[1:])
        exit(0)
    except Exception as e:
        print(e.message)
        exit(1)

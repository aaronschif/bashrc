#!/usr/bin/env python

import argparse
import re
from os import environ
import shutil
import logging
import subprocess
#from yamlformatter import YAMLFormatter

logging.basicConfig(
    level='INFO'
)
log = logging.getLogger(__name__)
logHandler = logging.FileHandler('main.log.yaml')
#logHandler.setFormatter(YAMLFormatter())
log.addHandler(logHandler)

parser = argparse.ArgumentParser(description='Compile a script file.')
parser.add_argument('main', nargs='?', default='main.sh', help='File to compile.')
parser.add_argument('dir', nargs='?', default='scripts', help='Base directory.')
parser.add_argument('out', nargs='?', default='bashrc.out', help='Outfile.')
parser.add_argument('-i', '--install', action='store_true',
    help='Move to ~/.bashrc after compiling')
parser.add_argument('-o', '--optimize', action='store_true',
        help='Remove comments and pre-evaluate statements.')
args = parser.parse_args()

source_statement = re.compile('^(source|[.])\s+(?!/)(?P<file>.+)')
ignore_statement = re.compile('^\s*(#)|($)')
eval_statement = re.compile('^\s*eval "\$\((.*)\)')

def _read_r(main, dir_='.'):
    with open(dir_+'/'+main) as f:
        for line in f:
            source_match = source_statement.match(line)
            eval_match = args.optimize and eval_statement.match(line)
            ignore_match = args.optimize and ignore_statement.match(line)
            if source_match:
                log.info(' reading to output ' + source_match.group('file'))
                yield ''.join(_read_r(source_match.group('file'), dir_))
            elif ignore_match:
                pass
            elif eval_match:
                yield subprocess.check_output(eval_match.group(1), shell=True)
            else:
                yield line

if __name__ == '__main__':
    with open(args.out, 'w') as o:
        for line in _read_r(args.main, args.dir):
            o.write(line)
    log.info(' wrote to '+args.out)
    if args.install:
        log.info(' installing to ~/.bashrc')
        shutil.copy(args.out, environ['HOME'] + '/.bashrc')

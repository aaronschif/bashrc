import argparse
import re
from os import environ
import shutil
import logging
#from yamlformatter import YAMLFormatter

logging.basicConfig(
	level='INFO'
)
log = logging.getLogger(__name__)
logHandler = logging.FileHandler('main.log.yaml')
#logHandler.setFormatter(YAMLFormatter())
log.addHandler(logHandler)

parser = argparse.ArgumentParser(description='Compile a script file.')
parser.add_argument('main', help='File to compile.')
parser.add_argument('out', nargs='?', default='bashrc.out', help='Outfile.')
parser.add_argument('-i', '--install', action='store_true', 
	help='Move to ~/.bashrc after compiling')
args = parser.parse_args()

source_statement = re.compile('^(source|[.])\s+(?!/)(?P<file>.+)')
ignore_statement = re.compile('^\s*(#)|($)')

def _read_r(main):
	with open(main) as f:
		for line in f:
			source_match = source_statement.match(line)
			if source_match:
				log.info(' reading to output ' + source_match.group('file'))
				yield ''.join(_read_r(source_match.group('file')))
			else:# not ignore_statement.match(line):
				yield line
				
with open(args.out, 'w') as o:
	for line in _read_r(args.main):
		o.write(line)
		
if args.install:
	log.info(' installing to ~/.bashrc')
	shutil.move(args.out, environ['HOME'] + '/.bashrc')
					
# TODO --install

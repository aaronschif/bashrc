import argparse
import re
import os

parser = argparse.ArgumentParser(description='Compile a script file.')
parser.add_argument('main', help='File to compile.')
parser.add_argument('out', help='Outfile.')
args = parser.parse_args()

source_statement = re.compile('^(source|[.])\s+(?!/)(?P<file>.+)')
ignore_statement = re.compile('^\s*(#)|($)')

def _read_r(main):
	with open(main) as f:
		for line in f:
			source_match = source_statement.match(line)
			if source_match:
				yield ''.join(_read_r(source_match.group('file')))
			else:# not ignore_statement.match(line):
				yield line
				
with open(args.out, 'w') as o:
	for line in _read_r(args.main):
		o.write(line)
					
# TODO --install

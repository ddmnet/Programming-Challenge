import sys
import os
import shutil
from time import time

st = time() # what time is it? TIME TO GET A WATCH LOL

args = sys.argv

tmp_file = '/tmp/reverse.txt'

try:
	path = args[1]
except:
	print 'You must supply a file, jerkface.'
	
	
# this try layer allows us to catch a KeyboardInterrupt
try:
	# open the supplied file
	try:
		f = open(path, 'r')
		print 'Opening `%s` ...' % (path)
		valid = True
	except IOError as e:
		print 'That file does not exist, bitch.'
		valid = False
	
	# open a tmp write file
	try:
		if valid:
			writer = open(tmp_file, 'w')
			valid = True
	except:
		print 'Unable to create temporary write file. Do you have permissions to open %s ?' % (tmp_file)
		valid = False
		pass

	
	if valid:
		line = f.readline()
		while line != '':
			words = line.split(' ')
			counter = 0
			trimmed = ''
			for word in words:
				if word != '' and word[-1] == '\n':
					word = word[0:-1]
					trimmed = '\n' # if we gutted a newline from the last word, note that.
				words[counter] = word[::-1]
				counter += 1
			writer.write(' '.join(words) + trimmed) # super interesting Python syntax here. you call join on the delimiter and pass in the list
			line = f.readline()	
		
		# we made it! clean up shop, britches
		f.close()
		writer.close()
		os.remove(path)
		shutil.move(tmp_file, path)
		print 'Reversed file in %.2f seconds' % (time() - st)
except (KeyboardInterrupt, SystemExit):
	f.close()
	writer.close()
	os.remove(tmp_file)
	print '\nExecution stopped after %.2f seconds. File unaltered.' % (time() - st)
import sys
import time
start = time.time()

chars_dict = { 'I' : 1, 'V' : 5, 'X' : 10, 'L' : 50, 'C' : 100, 'D' : 500, 'M' : 1000 }
valid_letters = chars_dict.keys()

def process_roman_numerals(line):
	if line == '':
		return False
		
	for letter in line:
		if letter not in valid_letters:
			return False
	
	value = 0
	counter = 0
	length = len(line)
	while counter < length:
		ch = line[counter]
		this_value = chars_dict[line[counter]]
		# is this the last value?
		try:
			# if this succeeds, not the last character
			next_value = chars_dict[line[counter + 1]]
			
			if next_value > this_value:
				# subtact!
				value = value + next_value - this_value
				counter += 1
			else:
				value += this_value
		except:
			# last character
			return value + this_value
		counter += 1
	return value

for line in sys.stdin:
	if line[-1:] == "\n":
		line = line[:-1]
	value = process_roman_numerals(line)
	if isinstance(value, bool):
		print 'INVALID: `' + str(line) + '`'
	else:
		print value # will be x10 value

end = time.time()
runtime = end - start
# print 'Finished in ' + str(runtime) + ' seconds'
# time python jack.py > /dev/null
import string

current_string = ""
for letter in string.lowercase:
	current_string = current_string + letter + current_string

print current_string
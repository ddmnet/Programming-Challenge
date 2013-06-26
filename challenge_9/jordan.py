# python jordan.py "key" "plainText"

import sys

key = sys.argv[1]
text = sys.argv[2]

encrypted = ""
key_index = 0

for i in range(0, len(text)):
	if text[i] == ' ':
		encrypted += ' '
		key_index+=1
		key_index = key_index % len(key)
		continue

	encrypted += chr(((ord(text[i]) + ord(key[key_index]) - 2 * ord('A')) % 26 + ord('A')))
	key_index+=1
	key_index = key_index % len(key)

print encrypted
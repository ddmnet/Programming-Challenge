import os
from subprocess import *
import sys

cmd = "time -p %s > /dev/null" % (sys.argv[1],)
values = [Popen(cmd, stderr=PIPE, shell=True).stderr.read().split("\n")[0].split(" ")[1] for x in range(10)]
values = [float(v) for v in values]
maxvalue = max(values)
removed_max = False
minvalue = min(values)
removed_min = False
print values
print "max", maxvalue
print "min", minvalue

new_values = []
for x in values:
	if x == maxvalue and not removed_max:
		removed_max = True
		continue
	if x == minvalue and not removed_min:
		removed_min = True
		continue

	new_values.append(x)

print new_values
print "avg:", sum(values)/len(values)




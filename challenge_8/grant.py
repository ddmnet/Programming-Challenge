# PC #8
f = open('triangle.txt', 'rt')
q = []
for line in f:
	m = [int(v) for v in line.split(' ')]
	q.append(m)


def from_x(x, l, total):
	lastrow = l[-1]

	if x < 0 or x > len(lastrow)-1:	
		# we went off the triangle yo!
		return 0

	total = total + lastrow[x]

	# make ze sub list
	sublist = l[:-1]
	
	if len(sublist) == 0:
		# done state
		return total
	
	# test left right:
	a = from_x(x,sublist, total)
	b = from_x(x-1,sublist, total)

	# choose maximalist:
	return max(a,b)

print max( [from_x(x,q, 0) for x in range(len(q[-1]))] )

# Port of Jordan's solution to python:
# for y in xrange(len(q)-2, -1, -1):
# 	for x in xrange(0,len(q[y])):
# 		q[y][x] += max( q[y+1][x], q[y+1][x+1] )

# print q[0][0]


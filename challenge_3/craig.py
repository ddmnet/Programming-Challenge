#!/usr/bin/env python
import sys

class ChessBoard(object):
	
	board = []
	game_number = 0
	
	black_king = {}
	white_king = {}
	
	def __init__(self, header, game_number, print_boards):
		self.game_number = game_number
		self.print_boards = print_boards
		self.board = [] # clear this out, it sticks sometimes...
		
	def loadline(self, line, row_index):
		line = list(line) # explode line into list
		if 'k' in line:
			self.black_king['x'] = line.index('k')
			self.black_king['y'] = row_index
		if 'K' in line:
			self.white_king['x'] = line.index('K')
			self.white_king['y'] = row_index
		self.board.append(line)
	
	def process_board(self):
		if self.print_boards:
			self.print_board()
		
		try:
			if self.is_king_in_check(self.white_king, False):
				print 'Game %s: White King is in check.' % self.game_number
			elif self.is_king_in_check(self.black_king, True):
				print 'Game %s: Black King is in check.' % self.game_number
			else:
				print 'Game %s: Both kings are safe.' % self.game_number
		except:
			print str(sys.exc_info())
	
	def is_king_in_check(self, king, enemy_capitalized):
		'''
		king : a dictionary with 'x' and 'y' values
		enemy_capitalized : are enemy pieces capitalized? should be boolean, yo
		'''		
		in_check = False
		
		# check pawns
		pawns = ['p', 'P']
		if enemy_capitalized:
			# enemy is white, that means we're black. that means the attack is coming from below
			in_check = in_check or self.check_direction(king['x'], king['y'], -1, 1, pawns, enemy_capitalized, False)
			in_check = in_check or self.check_direction(king['x'], king['y'], 1, 1, pawns, enemy_capitalized, False)
		else:
			# the inverse of the above comment
			in_check = in_check or self.check_direction(king['x'], king['y'], -1, -1, pawns, enemy_capitalized, False)
			in_check = in_check or self.check_direction(king['x'], king['y'], 1, -1, pawns, enemy_capitalized, False)
			
		# check knights' circle
		knights = ['n', 'N']
		in_check = in_check or self.check_direction(king['x'], king['y'], -2, -1, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], 2, -1, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], -2, 1, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], 2, 1, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], -1, -2, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], 1, -2, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], -1, 2, knights, enemy_capitalized, False)
		in_check = in_check or self.check_direction(king['x'], king['y'], 1, 2, knights, enemy_capitalized, False)
		
		verticals = ['r', 'q', 'R', 'Q']
		# check north
		in_check = in_check or self.check_direction(king['x'], king['y'], 0, 1, verticals, enemy_capitalized)
		# check south
		in_check = in_check or self.check_direction(king['x'], king['y'], 0, -1, verticals, enemy_capitalized)
		# check east
		in_check = in_check or self.check_direction(king['x'], king['y'], 1, 0, verticals, enemy_capitalized)
		# check west
		in_check = in_check or self.check_direction(king['x'], king['y'], -1, 0, verticals, enemy_capitalized)
		
		
		diagonals = ['q', 'Q', 'b', 'B']
		# check NW
		in_check = in_check or self.check_direction(king['x'], king['y'], -1, -1, diagonals, enemy_capitalized)
		# check NE
		in_check = in_check or self.check_direction(king['x'], king['y'], 1, -1, diagonals, enemy_capitalized)
		# check SW
		in_check = in_check or self.check_direction(king['x'], king['y'], -1, 1, diagonals, enemy_capitalized)
		# check SE
		in_check = in_check or self.check_direction(king['x'], king['y'], 1, 1, diagonals, enemy_capitalized)
					
		return in_check
		
	
	def check_direction(self, x, y, deltax, deltay, checkers, enemy_capitalized, loop = True):
		'''
		x, y, deltax, and deltay are ints
		checkers is a list of pieces capable of striking the king with these delta values
		enemy_capitalized : are enemy pieces capitalized? should be boolean, yo
		'''
		current_x = x + deltax
		current_y = y + deltay
		
		all_pieces = ['k','q','r','n','b','p']
		
		while current_x > -1 and current_x < 8 and current_y > -1 and current_y < 8:
			target = self.board[current_y][current_x]
			#print 'looking at %d-%d. found `%s`' % (current_x, current_y, target)
			if target in checkers and target.istitle() == enemy_capitalized:
				#print '%s at %d-%d can strike the king at %d-%d with (%d, %d) delta values!' % (target, current_x, current_y, x, y, deltax, deltay)
				return True
			elif target.lower() in all_pieces:
				# found a non-dangerous piece. thus, this direction is safe
				return False
			else:
				# empty spot. continue on.
				pass

			if not loop:
				# break out of the direction. used for knights and pawns
				break
			
			current_x += deltax
			current_y += deltay
		
		return False
	
	def print_board(self):
		for line in self.board:
			print line
	
valid = False
if len(sys.argv) == 1:
	print "Hook me up with a file, yo."
else:
	path = sys.argv[1]
	try:
		f = open(path, 'r')
		print "Opening %s..." % path
		valid = True
	except:
		print "%s is not a file." % path
		
	try:
		print_boards = sys.argv[2]
		if print_boards == '-pb':
			print_boards == True
		else:
			print_boards == False
	except:
		print_boards = False

if valid:
	row_counter = 0;
	game_counter = 1;
	processed = False
	for line in f.readlines():
		if line[-1] == '\n':
			line = line[0:-1]
		if line[0:4].lower() == 'game':
			cb = ChessBoard(line, game_counter, print_boards)
			processed = False
			game_counter += 1
			row_counter = 0
		elif line != '':
			cb.loadline(line, row_counter)
			row_counter += 1
		else:
			cb.process_board()
			processed = True
	
	try:
		# catch if the last board hasn't been processed yet
		if not processed:
			cb.process_board()
	except:
		pass
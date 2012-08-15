import sys

WHITE = 1
BLACK = 0


class KingInCheck(Exception):
	def __init__(self, col, row, piece_type):
		self.col = col
		self.row = row
		self.piece_type = piece_type
		self.msg = "King In Check: col %d row %d from %s" % (self.col,self.row,self.piece_type)
	def __str__(self):
		return self.msg

class Game:
	def __init__(self, file_obj):
		self.game_name = ""
		self.valid = False
		self.board = []
		self.kings = [ (-1,-1), (-1,-1) ]
		self.readGame(file_obj)
	
	def readGame(self, file_obj):
		self.game_name = file_obj.readline()
		for x in range(8):
			line = file_obj.readline()
			if not line:
				return
			self.board.append( [line[x] for x in range(8)] )
		file_obj.readline()
		self.valid = True

	def findKings(self):
		for col in range(8):
			for row in range(8):
				if self.board[row][col] == 'k':
					self.kings[BLACK] = (col,row)
				if self.board[row][col] == 'K':
					self.kings[WHITE] = (col,row)

	def oppositePiece(self, piece_type, side):
		# returns the opposite piece code from the input "side" value
		return piece_type.upper() if side == BLACK else piece_type.lower()

	def matchPiece(self, col, row, piece_type ):
		# returns True if no piece at col, row
		# returns False if out of range or piece at co, row is other than piece_type
		if col < 0 or col >= 8: return False
		if row < 0 or row >= 8: return False
		try:
			if self.board[row][col] == '.':
				return True
			if self.board[row][col] == piece_type:
				raise KingInCheck(col, row, piece_type)
		except IndexError:
			pass
		return False

	def checkKing(self, side_idx):
		k = self.kings[side_idx]
		oppositeKingPiece = self.oppositePiece('k', side_idx)
		for row in range(-1,2):
			for col in range(-1,2):
				self.matchPiece( k[0]-col, k[1]-row, oppositeKingPiece)
		
	def checkQueen(self, side_idx):
		k = self.kings[side_idx]
		self.checkRook(side_idx, 'q')
		self.checkBishop(side_idx, 'q')
		
	def checkRook(self, side_idx, pcode = 'r'):
		k = self.kings[side_idx]
		op = self.oppositePiece(pcode, side_idx)
		for r in range(1,9):
			if not self.matchPiece( k[0]+r, k[1], op): break
		for r in range(-1,-8, -1):
			if not self.matchPiece( k[0]+r, k[1], op): break
		for r in range(1,9):
			if not self.matchPiece( k[0], k[1]+r, op): break
		for r in range(-1,-8,-1):
			if not self.matchPiece( k[0], k[1]+r, op): break

	def checkBishop(self, side_idx, pcode = 'b'):
		k = self.kings[side_idx]
		op = self.oppositePiece(pcode, side_idx)
		for r in range(1,9):
			if not self.matchPiece( k[0]+r, k[1]+r, op): break
		for r in range(-1,-8, -1):
			if not self.matchPiece( k[0]+r, k[1]+r, op): break
		for r in range(1,9):
			if not self.matchPiece( k[0]+r, k[1]-r, op): break
		for r in range(-1,-8,-1):
			if not self.matchPiece( k[0]+r, k[1]-r, op): break

	def checkKnight(self, side_idx):
		k = self.kings[side_idx]
		op = self.oppositePiece('n', side_idx)
		nightMoves = [
			(-1, -2), (-2, -1),
			(1, -2),  (2, -1),
			(1, 2),   (2, 1),
			(-1, 2),  (-2, 1)
		]

		for m in nightMoves:
			self.matchPiece( k[0]+m[0], k[1]+m[1], op)

	def checkPawn(self, side_idx):
		k = self.kings[side_idx]
		op = self.oppositePiece('p', side_idx)
		
		m = -1 if side_idx == WHITE else 1	# black TOP; white BOTTOM
		pawnMoves = [
			(1,1*m), (-1,1*m)
		]

		for m in pawnMoves:
			self.matchPiece( k[0]+m[0], k[1]+m[1], op)
	def checkAllOnSide(self, side_idx):
		if self.kings[side_idx][0] < 0 or self.kings[side_idx][1] < 0:
			raise Exception("King(s) Missing")
		self.checkKing(side_idx)
		self.checkQueen(side_idx)
		self.checkRook(side_idx)
		self.checkBishop(side_idx)
		self.checkKnight(side_idx)
		self.checkPawn(side_idx)

	def checkAllSides(self):
		self.checkAllOnSide(0)
		self.checkAllOnSide(1)

def main():
	board_file = open(sys.argv[1])
	
	while True:
		g = Game(board_file)
		if not g.valid:
			return
		g.findKings()
		print g.game_name
		#print "kings at:", g.kings
		try:
			g.checkAllSides()
			print "\tNo Check"
		except Exception, e:
			print "\t%s" % (e,)



if __name__ == "__main__":
	main()

IS THE KING IN CHECK?

=====

Sample input:

Game #1:
rnbqk.nr
ppp..ppp
....p...
...p....
.bPP....
.....N..
PP..PPPP
RNBQKB.R

Sample output:

Game #1: The White King is in check.

=====

White is denoted by UPPERCASE letters, black is denoted by lowercase letters. Dots are empty spaces - although any character that is not a newline or a valid "piece" via the key provided below should be treated as an empty space.

You do not need to validate the board configuration itself in any way.

The input will be provided as a file, and there may be multiple board configurations in the file.  Each board configuration will be preceded by the "game title" ("Game #1:" in the above input), and will have a blank line before the next game title and board configuration. (A clearer text file example will be added to the repository later in the day for your testing pleasure.)

Your output must state which king is in check for each board.

No provided board will have both kings in check.  All boards will be 8x8. Black (lowercase) always starts from the top of the board and moves down, white (uppercase) starts at the bottom and works up the board.

Piece Characters:
r/R = Rook.
n/N = Knight.
b/B = Bishop.
q/Q = Queen.
k/K = King.
p/P = Pawn.

(If you're completely unfamiliar with chess, I can also provide reference for the valid moves each piece can perform.)

Questions? I think I've kinda covered everything.

LET THE CHALLENGE BEGIN!
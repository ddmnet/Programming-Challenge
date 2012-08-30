NUMERIC MAZE
=====

by Christer Nilsson

You have a starting point and a target, say 2 and 9. You have a set of three operations:

double
halve    (Odd numbers cannot be halved.)
add_two

Problem: Move from the starting point to the target, minimizing the number of operations.

Examples:

solve(2,9)  # => [2,4,8,16,18,9]

solve(9,2)  # => [9,18,20,10,12,6,8,4,2]

Like the previous challenge, I'm going to impose the language limit. You can't use any language you have used in any previous programming challenge.


##Judging

Similar to challenge #4

1. Correctness
2. Shortest Chain Length
3. Execution Time


source: http://www.rubyquiz.com/quiz60.html

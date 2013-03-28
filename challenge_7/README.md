Challenge #7
============

## Description

The ABACABA sequence is defined as follows: start with the first letter of the alphabet ("a"). This is the first iteration. The second iteration, you take the second letter ("b") and surround it with all of the first iteration (just "a" in this case). Do this for each iteration, i.e. take two copies of the previous iteration and sandwich them around the next letter of the alphabet.

Here are the first 5 items in the sequence:

	a
	aba
	abacaba
	abacabadabacaba
	abacabadabacabaeabacabadabacaba

And it goes on and on like that, until you get to the 26th iteration (i.e. the one that adds the "z"). If you use one byte for each character, the final iteration takes up just under 64 megabytes of space.

Write a computer program that prints the 26th iteration of this sequence to a file.


## Judging

Your program will be judged against the following criteria:

1. Is the solution correct?
2. How long did it take to run?
3. How creative was your solution? (subjective, group vote)

** Timing will be determined by "time [your executable] > /dev/null"

### Rules

You are only allowed to use the same programming lanugage for every third challange.  For instance PHP -> Javascript -> Python -> PHP is OK.  Python -> Ruby -> Python is not.

This is due by 1pm on 4/3.  Please push your submissions into the 'challenge_7' folder in the Programming-Challenge Github repo.
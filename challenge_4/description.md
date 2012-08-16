WORD CHAINS
=====

Write a program that solves word-chain puzzles.

There's a type of puzzle where the challenge is to build a chain of words, starting with one particular word and ending with another. Successive entries in the chain must all be real words, and each can differ from the previous word by just one letter. For example, you can get from "cat" to "dog" using the following chain.

	cat
	cot
	cog
	dog

The objective is to write a program that accepts start and end words and, using words from the dictionary, builds a word chain between them. 

Your program must accept a starting word and ending word as input from the command line. Your program should output one word per line including the first and ending words (e.g. cat and dog in the above example).

The word conversion always happens between words of equal length. The starting word length will always equal the ending word length.

Use the dictionary file provided by OS X: /usr/share/dict/words

Both starting and ending words are guaranteed to be in the above dictionary.

##Allowed Languages Restriction

Your program can be written in any language you have not used in the previous programming challenges.

##Example

	./werd_chainz.py cat dog
	cat
	cot
	cog
	dog


##Judging

1. Correctness
2. Shortest Chain Length
3. Execution Time



source: http://codekata.pragprog.com/2007/01/kata_nineteen_w.html
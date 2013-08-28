Challenge 11
============

## Analyze the Poker hand

You'll be provided a text file. Each line of the file will contain an
example poker hand. Like so:

    2C-5S-TS-JH-AD

This hand would be read as "Two of Clubs, Five of Spades, Ten of Spades,
Jack of Hearts, and Ace of Diamonds".

For each hand in the file, you must determine the best possible rank of
that hand. Poker hand ranking is as follows:

 1. `SF` - Straight Flush
 2. `FK` - Four of a Kind
 3. `FH` - Full House
 4. `FL` - Flush
 5. `ST` - Straight
 6. `TK` - Three of a Kind
 7. `TP` - Two Pair
 8. `PA` - Pair
 9. `HC` - High Card

Your output for each line should read as such:

     [line number]. `hand` - `rank code`.

 So for the above example, assuming it was the first line of the file:

     1. `2C-5S-TS-JH-AD` - `HC`

Note that there is a space in front of the line number.

If you need a little more info on how you determine a flush, straight,
etc., look [no further](http://www.compendia.co.uk/poker_scores.htm).

Entries will be judged on:

 - Correctness
 - Code Clarity (Subjectivity FTW)
 - Speed (time 1000x runs of the program)

You may use any language to complete this task. (Although _Code Clarity_
may be improved by choosing not-bash.)
#!/usr/bin/env node
"use strict";
var numerals = {
		"I": 1,
		"V": 5,
		"X": 10,
		"L": 50,
		"C": 100,
		"D": 500,
		"M": 1000
	},
	validNumeralRegex = /^[IVXLCDM]*$/,
	stdin = process.stdin,
	stdout = process.stdout,
	returncode = 0;

// stdin is paused by default in node.
stdin.resume();
stdin.setEncoding("utf8"); // More like "utf-great".

// let's process some data.
stdin.on('data', function (input) {
	var sign,
		total,
		previousNumeralVal,
		currentNumeralVal,
		characters,
		character,
		lines,
		numeral;

	lines = input.split("\n");

	while (lines.length > 0) {
		sign = 1;
		total = 0;
		previousNumeralVal = 0;
		numeral = lines.shift();
		// all uppercase, and trim unnecessary whitespace.
		numeral = numeral.toUpperCase().replace(/^\s+|\s+$/g, "");

		// OK fine, I'll validate my input. Jerk.
		if (!numeral.match(validNumeralRegex)) {
			stdout.write("Gleep Glorp Roman Numeral Bot Does Not Think \"" + numeral + "\" Is Valid Zleep Zap Carraige Return\n");
			returncode = 1;
		} else if (numeral.length > 0) {
			characters = numeral.split('');

			while (characters.length > 0) {
				character = characters.pop(); // That's right. I'm doing this backwards. It's really the only sane way.
				currentNumeralVal = numerals[character]; // Grab the decimal value of the current character.

				if (currentNumeralVal > previousNumeralVal) { // We'll be adding to the total
					sign = 1;
				} else if (currentNumeralVal < previousNumeralVal) { // We'll be subtracting from the total
					sign = -1;
				}

				// if it's equal, we leave the sign alone - do whatever you did last.
				total += sign * currentNumeralVal;
				previousNumeralVal = currentNumeralVal;
			}

			stdout.write(total + "\n"); // display our result.
		}
	}

});

// Handle closing of stdin stream.
stdin.on('end', function () {
	process.exit(returncode); // exit with no error.
});
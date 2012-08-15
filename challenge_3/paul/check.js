#!/usr/bin/env node
"use strict";

var fs = require('fs'),
	Pieces = require('pieces'),
	Board = require('board'),
	_ = require('underscore'),
	file = (typeof(process.argv[2]) !== 'undefined') ? process.argv[2] : false,
	buffersize = (typeof(process.argv[3]) !== 'undefined') ? process.argv[3] * 1024 : 2048, //2k default buffer
	lastBuffered = '',
	title = false,
	currentBoard = [],
	stream,
	startms,
	endms,
	outputstream;

if (!file) {
	process.stderr.write("No file specified.\n");
	process.exit(1);
}

if (!fs.existsSync(file)) {
	process.stderr.write("No file found at " + file + "\n");
	process.exit(2);
}

stream = fs.createReadStream(file, {encoding: 'utf8', bufferSize: buffersize});

stream.on('data', function(data) {
	var lines = data.split("\n");
	
	lines.forEach(function(line) {
		var kingColor, board, piece, x, y, character, kingColor;
		if (!title) {
			title = line;
		} else if (!_.isNull(line.match(/^\s*$/))) {
			//dispatch new board.
			kingColor = false;
			
			board = new Board();
			board.parse(currentBoard.join("\n"));
			
			for ( x = 0; x < 8; x++ ) {
				for ( y = 0; y < 8; y++ ) {
					character = board.at(x, y);
					if (character !== ' ') {
						piece = new Pieces.dict[character](character, board, {'x': x, 'y': y});
						if (piece.hitKing()) {
							kingColor = (piece.color === 'white') ? 'Black King' : 'White King';
							process.stdout.write(title + ': The ' + kingColor + " is in check.\n\n");
							break;
						}
					}
				}
				if (kingColor !== false) {
					break;
				}
			}
			
			if (kingColor === false) {
				process.stdout.write(title + ": No king is in check.\n\n");
			}
			
			// reset for the next board.
			title = false;
			currentBoard = [];
		} else {
			currentBoard.push(line);
		}
	});
	
});
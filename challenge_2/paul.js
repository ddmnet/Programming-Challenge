#!/usr/bin/env node
"use strict";

var fs = require('fs'),
	file = (typeof(process.argv[2]) !== 'undefined') ? process.argv[2] : false,
	buffersize = (typeof(process.argv[3]) !== 'undefined') ? process.argv[3] * 1024 : 2048, //2k default buffer
	lastword = '',
	newfile = file + '.rev',
	d = new Date(),
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

startms = d.getTime();
stream = fs.createReadStream(file, {encoding: 'utf8', bufferSize: buffersize});
outputstream = fs.createWriteStream(newfile);

stream.on('data', function(data) {
	var output = '',
		words = data.split(/(\s)/),
		appendPrevious = lastword;
	
	words.forEach(function(word) {
		var characters, reversedWord;
		if (word.match(/\s/)) {
			output += lastword;
			output += word;
			lastword = '';
		} else {
			characters = word.split('');
			if (appendPrevious !== '') {
				lastword = '';
			}
			while (characters.length) {
				lastword += characters.pop();
			}
			lastword += appendPrevious;
			appendPrevious = '';
		}
	});
	
	outputstream.write(output);
});

function printCompletionTime() {
	d = new Date();
	endms = d.getTime();
	process.stdout.write('Completion time: ' + (endms - startms) + "ms\n");
}

stream.on('error', function(err) {
	process.stderr.write(err);
	process.exit(3);
});

stream.on('close', function() {
	outputstream.write(lastword);
	fs.renameSync(file, file + '.old');
	fs.renameSync(newfile, file);
	fs.unlink(file + '.old');
	printCompletionTime();
	process.exit(0);
});

process.on('SIGINT', function() {
	process.stdout.write("\nCtrl-C: Backing out.\n");
	printCompletionTime();
	d = new Date();
	startms = d.getTime();
	// delete progress.
	stream.destroy();
	fs.unlink(newfile);
	d = new Date();
	endms = d.getTime();
	process.stdout.write('Reverse completion time: ' + (endms - startms) + "ms\n");
	process.exit(4);
});

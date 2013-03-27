// Prgramming Challenge 6 - synchronous version
// By: Tom Boruta
// REQUIRES NODE.JS
// How to Install Node.js -> http://howtonode.org/how-to-install-nodejs
// Command to run:
// $ node tom-sync.js

var d = Date.now();
var wordCount = 0;
var assocFromText = {};
var assocFromDictionary = {};

var fs = require('fs');
// Text file
var arrayFromText = fs.readFileSync('programming_challenge_6_source.txt', 'utf8').toString().split(/[\s]/);
var arrayFromTextLength = arrayFromText.length;
for(var i=0; i < arrayFromTextLength; i++) {
	if (typeof assocFromText[arrayFromText[i]] != 'undefined'){
		assocFromText[arrayFromText[i]] = assocFromText[arrayFromText[i]]+1;
	}
	else {
		assocFromText[arrayFromText[i]] = 1;
	}
}
// Dictionary file
var arrayFromDictionary = fs.readFileSync('/usr/share/dict/words', 'utf8').toString().split(/[\n]/);
var arrayFromDictionaryLength = arrayFromDictionary.length;
for(var j=0; j < arrayFromDictionaryLength; j++) {
	if (typeof assocFromDictionary[arrayFromDictionary[j]] == 'undefined'){
		assocFromDictionary[arrayFromDictionary[j]] = 1;
	}
}

for(var key in assocFromText){
	console.log(assocFromDictionary[key]);
	if (typeof assocFromDictionary[key] != 'undefined'){
		wordCount=wordCount+assocFromText[key];
	}
}

console.log("Words:");
console.log(wordCount);

console.log("Time:");
console.log((Date.now() - d)/1000);
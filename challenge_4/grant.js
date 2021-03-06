var fs = require('fs');
var dictionaryFile = "/usr/share/dict/words";
var fd = fs.openSync(dictionaryFile, "r");

function word_delta( a, b) {
	var d = 0;
	for( var i = 0; i < a.length; i ++ ) {
		d += ( a[i] - b[i] ) != 0 ? 1 : 0;
	}
	
	return d;
}

function transform( start_word, end_word, source_words, history, history_lut, history_limit ) {
	var candidates = [];
	var candidates_lut = {};

	if( start_word.toString() == end_word) {
		return history;
	}

	if( history.length > history_limit ) {
		return null;
	}

	for( var x = 0; x < source_words.length; x ++ ) {
		var sw = source_words[x];
		var d = word_delta( start_word, sw);
		if( d == 1 ) {
			if(!( candidates_lut[sw.toString()] || history_lut[sw.toString()] )) {
				candidates.push( sw );
				candidates_lut[sw.toString()] = true;
			}
		}
	}

	for( var x = 0; x < candidates.length; x ++ ) {
		var q = history.slice(0);
		q.push( candidates[x].toString() );
		var q_lut = {};
		for( var i = 0; i < q.length; i ++ ) { q_lut[q[i]] = true; }

		var r = transform( candidates[x], end_word, source_words, q, q_lut, history_limit );
		if( r != null ) {
			return r;			
		}
	}
	return null;
}	


fs.readFile(dictionaryFile, function(err, data){
	if (err) throw err;

	var start_word = process.argv[2];
	var end_word = process.argv[3];
	if( start_word.length != end_word.length ) {
		throw new Error("start and end word length must be equal");
	}

	var words = data.toString().split("\n");
	var buffer_words = [];
	for( var i = 0; i < words.length; i ++ ) {
		var lowerCaseWord = words[i].toLowerCase();
		if( lowerCaseWord.length != start_word.length ) {
			continue;
		}
		var bw = new Buffer( lowerCaseWord );
		buffer_words.push( bw );
	}

	// cat dog
	// ruby code
	// lead gold
	// the end	
	// apple mango


	for( hl = 1; hl < 100; hl ++ ) {
		var history_lut = {};
		history_lut[start_word] = true;

		var r = transform(Buffer(start_word), Buffer(end_word), buffer_words, [start_word], history_lut, hl);
		if( r != null ) {
			//console.log("Shortest chain at "+hl+" history length:", r);
			for( var i = 0; i < r.length; i ++ ) {
				console.log(r[i]);
			}
			break;
		} else {
			console.log("max hl "+hl+" contains no results.");
		}
	}

});


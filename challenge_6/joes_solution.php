<?php
ini_set("memory_limit","500M");
$start_time = microtime(true); 

$jacks_text = file_get_contents('programming_challenge_6_source.txt');
$jacks_words = preg_split('/\s+/', $jacks_text);
$jacks_word_count = count($jacks_words);

$dict_text = file_get_contents('/usr/share/dict/words');
$dict_words = explode("\n", $dict_text);
$dict_word_count = count($dict_words);

$jacks_words_associative = array();
for ($i = 0; $i < $jacks_word_count; $i++) {
	if(isset($jacks_words_associative[$jacks_words[$i]]['count'])){
		$jacks_words_associative[$jacks_words[$i]]['count']++;
	}else{
		$jacks_words_associative[$jacks_words[$i]]['count'] = 1;
	}
}

$dict_words_associative = array();
for ($i = 0; $i < $dict_word_count; $i++) {
	$dict_words_associative[$dict_words[$i]] = 1;
}

$total_count = 0;
foreach($jacks_words_associative as $key => $value){
	if(isset($dict_words_associative[$key])){
		$total_count+= $jacks_words_associative[$key]['count'];
	}
}

$end_time = microtime(true);
$total_time = $end_time - $start_time;
echo "Words: $total_count Time: $total_time";
echo "\n";
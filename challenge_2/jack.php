<?php

	// Is the script being called right, and does the file exist?
	if(!check_args($argv)) exit(1);

	// Start timing.
	$start = microtime(true);

	// Opening a file with 'c+' means it won't overwrite
	$fp = fopen($argv[1], 'c+');
	$stats = fstat($fp);
	$filesize = $stats['size'];

	$word_start = 0;
	$current_pos = 0;
	$exit = false;
	$word = array();
	while(!$exit) {
		fseek($fp, $current_pos);
		$char = fgetc($fp);

		if($char != " ") {
			$word[] = $char;
			$current_pos++;
		} else {
			reverse($fp, $word, $word_start);
			$word = array();
			$current_pos++;
			$word_start = $current_pos;
		}
		
		if($current_pos == $filesize) {
			reverse($fp, $word, $word_start);
			$exit = true;
		}
	}

	// Stop timing.
	$end = microtime(true);
	echo ($end - $start) . "\n";

	function check_args($args) {
		$return = false;
		if(count($args) != 2) {
			echo "Usage: php jack.php [path-to-file]\n";
		} else {
			if(file_exists($args[1])) {
				$return = true;
			} else {
				echo "Error: File does not exist.\n";
			}
		}

		return $return;
	}

	function reverse(&$fp, $word, $start_pos) {
		$word_length = count($word);
		$word = array_reverse($word);
		$position = $start_pos;
		for($i = 0; $i < $word_length; $i++) {
			fseek($fp, $position);
			fwrite($fp, $word[$i]);
			$position++;
		}
	}
?>
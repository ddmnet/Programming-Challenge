<?php

	$map = array(
		"I" => 1,
		"V" => 5,
		"X" => 10,
		"L" => 50,
		"C" => 100,
		"D" => 500,
		"M" => 1000
	);

	$stdin = fopen("php://stdin", 'r');
	$stderr = fopen("php://stderr", 'w');
	$stdout = fopen("php://stdout", 'w');

	while(!feof($stdin)) {
		
		$numeral = trim(fgets($stdin));
		if(!is_valid($numeral)) {
			fwrite($stderr, "Invalid romain numeral: $numeral\n");
		} else {
			$numeral_length = strlen($numeral);
			$int_representation = array();
			$current = $total = 0;

			for($i = 0; $i < $numeral_length; $i++) {
				$int_representation[] = $map[$numeral[$i]];
			}

			for($i = 0; $i < count($int_representation); $i++) {
				$current = $int_representation[$i];
				$next = $int_representation[$i+1];
				if($current < $next) {
					$total = $total + ($next - $current);
					$i++;
				} else {
					$total = $total + $current;
				}
			}
			fwrite($stdout, $total."\n");
		}
	}

	fclose($stdin);
	fclose($stderr);
	fclose($stdout);	

	function is_valid($string) {
		$numerals = array("I", "V", "X", "L", "C", "D", "M");
		$len = strlen($string);
		if($len == 0) {
			return false;
		} else {
			for($i = 0; $i < $len; $i++) {
				if(!in_array($string[$i], $numerals)) {
					return false;
				}
			}
			return true;
		}
	}
?>
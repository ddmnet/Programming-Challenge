<?php
	# time php jordan.php > /dev/null
	ini_set('memory_limit', '-1');
	foreach(range('a','z') as $i) $str = $str . $i . $str;
	echo $str;
?>
<?php

$roman_letters = array("M", "CM", "D", "CD", "C", "XC", "L","XL", "X", "IX", "V", "IV", "I");   
$integers = array(1000, 900, 500, 400,  100,   90,  50, 40,   10,    9,   5,   4,    1);

function romanToDecimal($roman){
   $stderr = fopen('php://stderr', 'w');
    $roman = strtoupper($roman);
    echo $roman . " = ";
    $i = 0;
    $total = 0;
    while($i < strlen($roman)){
        try{
        $letter = substr($roman, $i, 1);
        
        $number = letterToNumber($letter);
        
        $i++;
       
        if($i == strlen($roman)){
            $total = $number + $total;
        }else{
            $letter = substr($roman, $i, 1);
            $next_num = letterToNumber($letter);
            if($next_num > $number){
                $total =  $total + ($next_num - $number);
                $i++;
            }else{
                $total = $total + $number;
            }
        }
        }catch(Exception $e){
            fwrite($stderr, "Not a roman numerial\r\n");
            $i = strlen($roman);
            return;
        }
    }
    echo $total . "\r\n";
   
}
function letterToNumber($letter){
    
    switch($letter){
            case 'I':  return 1;
             case 'V':  return 5;
             case 'X':  return 10;
             case 'L':  return 50;
             case 'C':  return 100;
             case 'D':  return 500;
             case 'M':  return 1000;
             default: throw new Exception("Error");
    }
}




function decimalToRoman($num){
    $STDOUT = fopen('php://stdout', 'w');
     
     $string = "";
     for($i = 0; $i < count($roman_letters); $i++){
         
         while($num >= $integers[$i]){
             $num = $num - $integers[$i];
             $string .= $roman_letters[$i];
         }
     }
     
     
     echo $string . "\r\n";
     //fwrite(STDOUT,$string);
     

     
}

$f = fopen('php://stdin', 'r');


while ($roman = fgets($f))
    romanToDecimal(trim($roman));

?>

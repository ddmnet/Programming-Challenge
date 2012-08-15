<?php

/**
 * Chess Main
 * -----------------------------------------------------
 * @author Jonathan Watebrury
 * CHALLENGE 3 OMGZ
 *  
 */




//I'm afraid of life without globals now
global $MOVES;


/*
 *  Set all the Pieces Moves minus pawns
 * 
 *  Wanted to set objects for this but then realized I was wasting 
 *  a lot of my time....quick ugly gross but it works.
 */
$MOVES = array(
    
    array(
        'pieces' => array('q', 'Q', 'b', 'B'),
        'direction' => array
                (array(1, 1), array(-1, 1), array(-1, -1), array(1, -1) 
        ),
        'loop' => 1
    ),
    
    array(
        'pieces' => array('r', 'q', 'R', 'Q'),
        'direction' => array(
            array(0, 1), array(0, -1), array(1, 0), array(-1, 0)
        ),
        'loop' => 1
    ),
    //Knights
    array(
        'pieces' => array('n', 'N'),
        'direction' => array(
            array(-2, -1), array(2, -1), array(-2, 1), array(2, 1),
            array(1, 2), array(-1, 2), array(-1, -2), array(1, -2)
        ),
        'loop' => 0,
    )
);




/**
 *  Chess Games Class 
 * _-------------------------------
 */
class Chess {
    //Better way to do this...
    
    public $board, $BlackKing, $WhiteKing;
    public $winner, $teams, $locX, $locY, $name, $check, $checkMSG;
    private $hasPawns, $hasKnights;
    
    /**
     *
     * @param string $name 
     */
    function __construct($name) {
        $this->name = $name;
        $this->check = 0;
        $this->checkMSG = "No king is in check";
        $this->hasPawns = true; 
        $this->hasKnights  = true;
    }
    
    /**
     *
     * @param type $line
     * @param type $locY 
     */
    function set_board($line, $locY) {
        $this->board[$locY] = str_split(trim($line));
        $pos = strpos($line, 'k');
        if ($pos !== false)
            $this->BlackKing = array($locY, $pos);
        $pos = strpos($line, 'K');

        if ($pos !== false) {
            $this->WhiteKing = array($locY, $pos);
        }
    }
    
    
    /**
     * 
     * @return type 
     */
    function process_board() {
        $mul = -1;
        if ($this->checkKing($this->WhiteKing, $mul, 0, "White")) {
            return;
        } else {
            $mul = 1;
            if ($this->checkKing($this->BlackKing, $mul, 1, "Black"))
                return;
        }
    
        
    }
    
    
    /**
     *
     * @param <boolean> $lowerCase
     * @param <char> $piece
     * @return boolean 
     */
    function isEnemy($lowerCase, $piece) {
        if ($lowerCase && ctype_lower($piece))
            return false;
        else if (!$lowerCase && ctype_upper($piece))
            return false;
        else
            return true;
    }
    
    
    /**
     *
     * @global array $MOVES
     * @param type $start_location
     * @param type $mul
     * @param type $lower_case
     * @param type $color
     * @return boolean 
     */
    private function checkKing($start_location, $mul, $lower_case, $color) {
        global $MOVES;


        // CHECK PAWNS
        //Could check if there are actually pawns...
        if ($this->isCheck($start_location, array($mul * 1, -1), array('p', 'P'), $lower_case, false) ||
                $this->isCheck($start_location, array($mul * 1, 1), array('p', 'P'), $lower_case, false)) {
            $this->checkMSG = $color . " King is in check";
            return true;
        }
        //Check Other Moves
        foreach ($MOVES as $move) {
            $loop = $move['loop'];
            foreach ($move['direction'] as $inc) {
                $result = $this->isCheck($start_location, $inc, $move['pieces'], $lower_case, $loop);
                if ($result) {
                    $this->check = 1;
                    $this->checkMSG = $color . " King is in check";
                    return true;
                }
            }
        }
    
        
    }
    /**
     *
     * @param type $king
     * @param type $increment
     * @param type $pieces
     * @param type $lowerCase
     * @param type $loop
     * @return boolean 
     */
    function isCheck($king, $increment, $pieces, $lowerCase = 0, $loop = true) {
        $row = $king[0];
        $col = $king[1];
        while ($row > -1 && $row < 8 && $col > -1 && $col < 8) {
            $row = $row + $increment[0];
            $col = $col + $increment[1];
            $value = $this->board[$row][$col];
            if ($value != '.') {
                if ($this->isEnemy($lowerCase, $value)) {
                    if (in_array($value, $pieces)) {
                        
                        return true;
                    }
                } else {
                    return false;
                }
            }
            if (!$loop)
                return false;
        }

        return false;
    }
    /**
     *
     * @return <string>
     */
    function __toString() {
        return " $this->name $this->checkMSG";
    }

    function print_board() {
        foreach ($this->board as $row)
            echo implode("", $row) . "<br />";
    }
    

    

}


$Games = array();

$row = 0;

$Chess = new Chess('');
$f = fopen('php://stdin', 'r');
while ($line = fgets($f)) {
    /**
     *  Game is over
     */
    if (trim($line) == "") {
        //$Chess->print_board();
        $Chess->process_board();
        $Games[] = $Chess;
        $row = 0;
    } else if ($row == 0 && strpos($line, ':') !== false) {
        
        $Chess = new Chess($line);
        $row++;
        /** Set the baord * */
    } else if ($row < 9) {
        $Chess->set_board($line, $row - 1);

        $row++;
    } else {
        $row = 0;
    }
}
$Chess->process_board();
$Games[] = $Chess;
foreach ($Games as $Chess) {
    echo $Chess . "\r\n\r\n";
}
?>

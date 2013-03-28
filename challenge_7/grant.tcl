# time tclsh grant.tcl > /dev/null
set runTimes 26
set lastValue a
for {set x 1} {$x < $runTimes} {incr x} {
	set char [format %c [expr {$x + 0x61}]]
	set lastValue "$lastValue$char$lastValue"
	if {$x == [expr {$runTimes - 1}] } {
		puts $lastValue
	}
}
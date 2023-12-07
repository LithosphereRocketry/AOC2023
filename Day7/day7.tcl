set fd [open "input.txt" "r"]
set ftxt [string map {A E T A J B Q C K D} [read $fd]]
set flines [split $ftxt "\n"]
set fixedlines {}
foreach line $flines {
    set hval 0
    set hb [split $line " "]
    set hand [lindex $hb 0]
    set bid [lindex $hb 1]

    set mcount -5
    foreach a [split $hand ""] {
        foreach b [split $hand ""] {
            if {$a == $b} {
                incr mcount
            }
        }
    }
    set type 0
    switch $mcount {
        2 {
            set type 1
        } 
        4 {
            set type 2
        } 
        6 {
            set type 3
        }
        8 {
            set type 4
        }
        12 {
            set type 5
        }
        20 {
            set type 6
        }
    }
    lappend fixedlines [join [list $type $hand $bid] " "]
}
set slines [lsort $fixedlines]
set score 0
set ind 1
foreach game $slines {
    set bid [lindex [split $game " "] 2]
    set score [expr $score + ($bid * $ind)]
    incr ind
}
puts $score
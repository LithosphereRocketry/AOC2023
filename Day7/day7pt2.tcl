set fd [open "input.txt" "r"]
set ftxt [string map {A E T A J 1 Q C K D} [read $fd]]
set flines [split $ftxt "\n"]
set fixedlines {}
foreach line $flines {
    set hval 0
    set hb [split $line " "]
    set hand [lindex $hb 0]
    set bid [lindex $hb 1]

    array unset ccount
    foreach c [split $hand ""] {
        if {$c != 1} {
            if {[info exists ccount($c)]} {
                incr ccount($c)
            } else {
                set ccount($c) 1
            }
        }
    }
    if {[array size ccount] > 0} {
        set cardrank [lsort -stride 2 -index 1 -decreasing [array get ccount]]
        set bestcard [lindex $cardrank 0]
        set wildhand [string map [list 1 $bestcard] $hand]
    } else {
        set wildhand $hand
    }

    set mcount -5
    foreach a [split $wildhand ""] {
        foreach b [split $wildhand ""] {
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
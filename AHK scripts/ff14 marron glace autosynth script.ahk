#SingleInstance force

;ctrl-q synths Marron Glace for thirty minutes
^q::
sleep, 50
send {NumpadEnter} ;hitting ctrl-q steals focus so I have to re-select the category of recipes that Marron Glace lives in
sleep, 500
loop, 29 ;this number is arbitrary but based on experience
{
send {NumpadEnter} ;select the recipe from the list of recipes
sleep, 500
random, delay, 30, 70
sleep, %delay%
send {NumpadEnter} ;hit the "start synth" button, this isn't working for some damn reason
sleep, 100
send {NumpadEnter} ;hit the "start synth" button, attempting the mythical "just double it" strat and it seems to work
sleep, 1250
random, delay, 30, 70
sleep, %delay%
send 1 ;first half of the macro
sleep, 36000 ;approx 34 seconds
random, delay, 30, 70
sleep, %delay%
send 2 ;second half of the macro
sleep, 19000 ;approx 17.5 seconds
random, delay, 30, 70
sleep, %delay%
send {NumpadEnter} ;there's an extra prompt for "do this as a collectible?", which one press clears if I don't have any other actions
sleep, %delay%
send {NumpadEnter} ;sometimes one gets eaten?
sleep, 2750 ;have to wait for synthesis results to go away before I hit enter again, approx 2 seconds
random, delay, 30, 70
sleep, %delay%
}

^!q::Pause

Esc::ExitApp
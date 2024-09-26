#SingleInstance force

;ctrl-q desynths a stack in the fourth row and third column of the first box of my inventory - hardcoded!
^q::
loop, 99
{
random, delay, 50, 60
click right 1480,540
random, delay, 50, 60
sleep, %delay%
click right 1480,540
random, delay, 240, 260
sleep, %delay%
click 1480, 540
random, delay, 50, 60
sleep, delay
click 1480, 540
random, delay, 240, 260
sleep, delay
click 1500, 860
random, delay, 50, 60
sleep, %delay%
click 1500, 860
random, delay, 3000, 3250
sleep, %delay%
}

^!q::Pause

Esc::ExitApp
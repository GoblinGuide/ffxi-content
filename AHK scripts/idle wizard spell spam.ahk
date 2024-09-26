#SingleInstance force

;ctrl-q tells it to unset, then set, then force-cast temper the steel, every... twoish seconds, given loop's delays
^q::
loop, 999999
{
sleep, 1500
Send {x down}
sleep, 100
SendInput 1
sleep, 100
SendInput {x up}
sleep, 100
SendInput {z down}
sleep, 100
SendInput 1
sleep, 100
SendInput {z up}
sleep, 100
SendInput {Shift down}
sleep, 100
SendInput 1 ;can't make "send +1" work sadly
sleep, 100
SendInput {Shift up}
}

Esc::ExitApp
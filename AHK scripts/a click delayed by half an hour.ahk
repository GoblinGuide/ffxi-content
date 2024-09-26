#SingleInstance force

;ctrl-q waits half an hour, then clicks twice wherever I left the mouse
^q::
sleep, 1800000
click
sleep, 5000
click
;the reason for this second click is that I'm genuinely uncertain if the first click ever fired and I would like to wake up the computer with the first one if it did not

Esc::ExitApp
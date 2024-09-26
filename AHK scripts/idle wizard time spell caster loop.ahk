#SingleInstance force

;ctrl-q casts, in order: [wormhole into three compress beam] to net 50 compressed time, three times total to net 150, then time distortion once, then repeat forever
^q::
loop, 999999
{
sleep, 100
sendinput 2
sleep, 100
sendinput 1
sleep, 100
sendinput 1
sleep, 100
sendinput 1
sleep, 100
sendinput 2
sleep, 100
sendinput 1
sleep, 100
sendinput 1
sleep, 100
sendinput 1
sleep, 100
sendinput 2
sleep, 100
sendinput 1
sleep, 100
sendinput 1
sleep, 100
sendinput 1
sleep, 100
sendinput 3
}

Esc::ExitApp
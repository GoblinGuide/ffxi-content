#SingleInstance force

;ctrl-q clicks at current mouse location once every 121 seconds (since duration is 120) for a very long time
;put the click before the sleep so I can tell it's starting by immediately clicking
^q::
loop, 999999
{
click
sleep, 121000
}

Esc::ExitApp
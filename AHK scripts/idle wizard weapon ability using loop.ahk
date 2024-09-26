#SingleInstance force

;ctrl-q sends W, the hotkey to activate weapon ability, once every 115 seconds (since duration is 120) for a very long time
;put the send before the sleep so I can tell it's working by immediately starting
^q::
loop, 999999
{
sendinput W
sleep, 115000
}

Esc::ExitApp
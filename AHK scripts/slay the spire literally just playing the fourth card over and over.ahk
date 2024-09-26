#SingleInstance force

;ctrl-q just makes me play a card every 500 milliseconds, with a double click to make sure I don't drop
^q::
loop, 999999
{
sleep, 250
sendinput 4
sleep, 250
click, 2
}

Esc::ExitApp
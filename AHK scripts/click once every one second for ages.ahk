#SingleInstance force

;ctrl-q clicks once every five seconds for, like, ever man (actually only for five hundred thousand seconds)
^q::
loop, 999999
{
sleep, 950
click
}

Esc::ExitApp
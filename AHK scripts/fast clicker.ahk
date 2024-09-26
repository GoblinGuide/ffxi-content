#SingleInstance force

;this came from some dude on SA
SetTimer Click, 0

^q::Toggle := !Toggle
Click:
    If (!Toggle)
        Return
    Click
return

;manual version - ctrl-1 double clicks 25 times in 25 ms
^1::
Loop, 25
{
click 2
sleep, 1
}
return

Esc::ExitApp
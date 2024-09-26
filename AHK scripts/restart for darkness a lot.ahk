#SingleInstance force

;coordinate mode is absolute screen, because I hardcoded positions on monitor two and it may not be active window...
CoordMode, Mouse, Screen
;can you controlclick on coordmode screen? you cannot, controlclick ignores that option and uses Relative coordinates instead
;leaving this for my own edification, because I removed the hardcoded positions on monitor two, I'm a real scientist

SetTitleMatchMode, 2
;can contain the phrase anywhere in the window title (third parameter of ControlClick) to be a match

;ctrl-q does the clicking
^q::
loop, 999999
{
;sleep, 3000 ;wait for quantum flow
;ControlClick, x1900 y520, Rewritten,,,,Pos ;click on big rip button in the correct window, I think the Pos is optional here actually?
sleep, 4000 ;make sure I actually earn darkness
ControlClick, x1900 y570, Rewritten,,,,Pos ;click on the darkness-making button
}

;windows-q pauses and unpauses this, but I don't think I care anymore! sick upgrade!
#q::Pause

Esc::ExitApp

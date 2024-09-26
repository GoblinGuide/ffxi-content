#SingleInstance force

;this just clicks on the button that says "Delete", I think I can do better...
;w::
;click 1210,280
;return

q::
CoordMode, Mouse, Screen
MouseGetPos, px, py
Mousemove, 1220, 290, 1
click
Mousemove, px, py, 1
return

;esc to exit
Esc::ExitApp
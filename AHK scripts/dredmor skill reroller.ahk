#SingleInstance force
^!n::

loop
{
sleep, 200

pixelgetcolor, psi, 978, 242
pixelgetcolor, burg, 897, 275
pixelgetcolor, ley, 741, 273
pixelgetcolor, prom, 510, 270
pixelgetcolor, law, 928, 423
pixelgetcolor, golem, 690, 197
pixelgetcolor, flesh, 818, 204
pixelgetcolor, arms, 576, 195

if burg != 0xB0C6D4
{
click 960, 542
}

if law != 0x7689A4
{
click 960, 542
}

if psi != 0xBBC9D2
{
click 960, 542
}

if ley != 0xBBC6D0
{
click 960, 542
}

;if golem != 0xBDC8D2
;{
;click 960, 542
;}

;if prom != 0x9FACB3
;{
;click 960, 542
;}

;if flesh != 0x717FD5
;{
;click 960, 542
;}

;if arms != 778087
;{
;click 960, 542
;}

}

;^!c::
;PixelGetColor, color, 690, 197
;MsgBox The color at the current cursor position is %color%.
;this will get the color of the pixel at that coordinates and then pop up a little message box that echoes it

Esc::ExitApp

;this script assumes the window's top corner is (0,0)
;960, 542 is a pixel on the random button
;pixels that will change color are:
;978,242	psionics			0xBBC9D2
;897,275	burglary			0xB0C6D4
;741,273	ley walker			0xBBC6D0
;510,270	promethean magic	0x9FACB3
;928,423	magical law			0x7689A4
;818,204	fleshsmithing		0x717FD5
;576,195	master of arms		0x778087
;690,197	golemancy			0xBDC8D2
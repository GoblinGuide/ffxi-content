#SingleInstance force
#Persistent
#NoEnv

q::
;reassigned hotkey to q and not ctrl-alt-q

loop
{
sleep, 1000

pixelgetcolor, bar, 149, 164

if (bar!=0x1C1C1C)
{
sleep, 2000
sendinput 4
sleep, 50
sendinput 2
sleep, 8000
sendinput 1
;sleep, 100
;send {LControl Down}
;sleep, 100
;click 250, 150
;sleep, 10000
;click 250, 150
;sleep, 100
;send {LControl Up}
;sleep, 25
;click 480, 550
;loop, 10
;{
;sleep, 1000
;click 480, 550
;}
;}

}

else
{
click 480, 550
;this is right on the treasure chest, in case I'm wondering in the future
sleep, 1000
}

}

6:: Pause
;ctrl-alt-6 will pause or unpause the script

c::
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox The color of the pixel at the current cursor position (%MouseX%, %MouseY%) is %color%.
return

Esc::ExitApp
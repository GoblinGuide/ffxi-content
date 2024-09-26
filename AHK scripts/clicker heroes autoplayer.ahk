;archer gave this to me, he's so kind! Then I commented out literally all his code and made my own tiny thing.

#SingleInstance force
#MaxThreadsPerHotkey 2
SetMouseDelay, 8
;Toggle=0
;F12::Reload
;Pause::Pause
;Pause

^!F12::
loop
{
PixelGetColor, color, 1290, 540
if (color=0x295B68)
SendInput a 
sleep 100
SendInput 1
sleep 100
SendInput 2
sleep 100
SendInput 3
sleep 100
SendInput 4
sleep 100
SendInput 5
sleep 100
SendInput 7
sleep 100
SendInput 8
sleep 100
SendInput 6
sleep 100
SendInput 9
sleep 900100
PixelGetColor, color, 1516, 433
if (color=0x295B68)
SendInput a
sleep 100
SendInput 8
sleep 100
SendInput 9
sleep 100
SendInput 1
sleep 100
SendInput 2
sleep 100
SendInput 3
sleep 100
SendInput 4
sleep 100
SendInput 5
sleep 100
SendInput 7
sleep 900100
}

;loop
;{
;Gosub, one
;Gosub, level
;sleep 880000
;Gosub, two
;Gosub, level
;sleep 425000
;Gosub, three
;Gosub, level
;sleep 425000
;}
;return

;four:
;getfocus()
;advance()
;Send 869
;return

;five:
;getfocus()
;advance()
;Send 89
;return

;one:
;getfocus()
;advance()
;Send 123457869
;loop 962 {
;click 1250, 667
;}
;return
 
;two:
;getfocus()
;advance()
;Send 89123457
;loop 962 {
;click 1250, 667
;}
;return
 
;three:
;getfocus()
;Send 1234
;loop 962 {
;click 1250, 667
;}
;return
 
;level:
;loop 20 {
;Click 490, 553
;sleep 100
;Click 490, 660
;sleep 100
;}
;return
 
;getfocus()
;{
;IfWinNotActive, Play Clicker Heroes, a free online game on Kongregate - Mozilla Firefox
;{
;SoundBeep  
;while (A_TimeIdlePhysical<2500)
;sleep 1000
;WinActivate, Play Clicker Heroes, a free online game on Kongregate - Mozilla Firefox
;sleep 1000
;click 921, 839
;sleep 500
;}
;}
 
;advance()
;{
;PixelGetColor, color, 1516, 433
;if (color=0x295B68)
;send a
;}

;F9::Send 123457
;F11:: Toggle := !Toggle

;while Toggle {
;Click
;}
;return

;`::Click

;ctrl-alt-q to exit
^!q::ExitApp
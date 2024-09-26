#SingleInstance force
#MaxThreadsPerHotkey 2

Counter=8440

^!n::
loop, 560
{
SendInput #r
sleep 50
Send C:\Users\User\Desktop\SNES\bcv28\randomizer.py
sleep 50
Send {Enter}
sleep 250
Send C:\Users\User\Desktop\SNES\bcv28\ff3.sfc
sleep 50
Send {Enter}
sleep 50
Send %counter%
Counter += 1
sleep 50
Send {Enter}
sleep 50
Send owzbmciqetfspda
sleep 50
Send {Enter}
sleep 50
Send y
sleep 50
SendInput {Enter}
sleep 8000
}
return

Esc::ExitApp

;windows .bat file suggested from stackexchange to check for differences between files below:
;fc /b file1 file2 > nul
;if errorlevel 1 goto files_differ
;[files are the same, do something here]
;
;:files_differ
;[files are not the same, do something here]
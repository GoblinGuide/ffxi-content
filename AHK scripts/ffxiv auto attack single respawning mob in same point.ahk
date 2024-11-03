#SingleInstance force
;just means you can't have multiple copies running, so no crabwalking

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to

;ctrl-q to start
^q::
loop, 999999
{
ControlSend,, {F12}, XIV ;target enemy, I rebound this just for this. can't send tab for some reason with controlsend, even enclosed in brackets
;my fallback option which I could also not get working was to send /assist <f> and focus target on someone else beforehand, that was just sending shift modifiers not working right, no big deal
sleep, 300
ControlSend,, 1, XIV ;attack
sleep, 400 ;wait to repeat
}

;windows-q pauses and unpauses this script, which will stop/resume loop as desired
#q::Pause

;ctrl-esc quits this script altogether
^Esc::ExitApp

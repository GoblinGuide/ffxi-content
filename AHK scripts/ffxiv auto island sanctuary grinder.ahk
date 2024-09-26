#SingleInstance force
;just means you can't have multiple copies running, so no crabwalking

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to

;ctrl-q to start
^q::
loop, 999999
{
ControlSend,, 1, XIV ;hit the macro, this prevents "FFXIV" in other window titles from working properly because it steals input, so don't shitpost in the thread with this running, too lazy to fix
;ASSUMPTION: YOU HAVE THE MACRO ON THE "1" BUTTON. IF THIS IS NOT TRUE, CHANGE THE PARAMETER AFTER THE PAIR OF COMMAS AND BEFORE THE "XIV" ON THE ABOVE LINE
sleep, 1000 ;wait to move between points
ControlSend,, {Enter}, XIV ;hit the point manually - sometimes, for some reason, it ends up too far for Pandora to hit it but 
sleep, 3000 ;wait for the mining animation to finish before hitting the macro again
}

;windows-q pauses and unpauses this script, which will stop/resume loop as desired
#q::Pause

;ctrl-esc quits this script altogether
^Esc::ExitApp

#SingleInstance force
;just means you can't have multiple copies running, so no crabwalking

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to

;ctrl-q to start
^q::
loop, 999999
{
ControlSend,, {W down}, XIV ;walk forwards
Random randomnumber, 200, 400
sleep, randomnumber ;wait that random amount of milliseconds to stop moving
ControlSend,, {W up}, XIV
Random randomnumber, 2000, 4000
sleep, randomnumber ;wait that random amount of milliseconds (i.e. 2-4 seconds) to move again
ControlSend,, {S down}, XIV ;walk backwards
Random randomnumber, 200, 400
sleep, randomnumber
ControlSend,, {S up}, XIV
Random randomnumber, 2000, 4000
sleep, randomnumber
}

;windows-q pauses and unpauses this script, which will stop/resume loop as desired
#q::Pause

;ctrl-esc quits this script altogether
^Esc::ExitApp

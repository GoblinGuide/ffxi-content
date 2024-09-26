;this script was last used to affiliate as druid and put grand balance on autocast really fast, 1/15/16


#SingleInstance force
#Persistent
#NoEnv

#SingleInstance force
;just means you can't have multiple copies running, so no crabwalking

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to


^q::
sleep, 200
click 660, 500
;that's the abdicate button

sleep, 200
click 700, 780
;that's the "warning: no gems gained" position of the "yes, abdicate" button

sleep, 100
click 700, 370
;clicks to the upgrades tab

sleep, 50
click 950, 620
sleep, 50
click 1110, 380
;10 coin upgrade and one farm

sleep, 100
click 840, 450
sleep, 50
click 620, 450
sleep, 50
click 840, 450
;gems and reincarnations and rubies

sleep, 50
click 840, 450
sleep, 50
click 730, 450
;gem upgrades and neutral declaration

sleep, 50
send {Shift down}
sleep, 50
send {Ctrl down}
sleep, 50
click 1110, 380
sleep, 50
click 1110, 420
sleep, 50
click 1110, 470
sleep, 50
click 1110, 520
sleep, 50
click 1110, 580
sleep, 50
click 1110, 640
sleep, 50
click 1110, 700
sleep, 50
click 1110, 760
sleep, 50
click 1110, 800
sleep, 50
click 1110, 860
sleep, 50
click 1110, 920
sleep, 50
send {Shift up}
sleep, 50
send {Ctrl up}
;lots of buildings

sleep, 50
click 950, 500
sleep, 100
click 850, 666
;demon bloodline, clicking 666 because it's funny

sleep, 50
click 950, 500
sleep, 50
click 950, 500
sleep, 50
click 950, 500
;neutral boost upgrades that move the faction allegiance, just to make sure I don't mess up (last one won't get bought but that's okay)

loop, 3
{
sleep, 50
click 840, 570
}
;the stupid offline upgrade means I can only loop three here

sleep, 50
click 800, 800
sleep, 50
click 840, 570
;click the chest once to get those mouse click upgrades and buy them

loop, 41
{
sleep, 50
click 900, 570
}
;other upgrades

sleep, 50
sendinput 1
sleep, 100
sendinput 1
;two tax collection to be able to buy druids

sleep, 50
click 680, 570
;affiliate druid

sleep, 50
send {Shift down}
sleep, 100
click 510, 540
sleep, 50
send {Shift up}

Esc::ExitApp
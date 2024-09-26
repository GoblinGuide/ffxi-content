;this breaks and I do not know why. it runs two full loops fine so it *shouldn't*. maybe it's dropping an input? increase the waits, don't touch anything.
;also I have YESALREADY configured to skip every possible window so uh, make sure you do too

#SingleInstance force
;just means you can't have multiple copies running, so no interference

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to. the phrase is XIV so don't have like, xivlogs open.

;ctrl-q to start
;start state: Vermilion Cloak (or Kirin's Osode) has 5 materia in it. no other materia in inventory, no other head or body pieces that have open materia slots so that the Cloak/Osode is top of the list
;start state 2: armory chest window is open, in the body section, have just clicked twice on Cloak to pick it up and put it back down so that the game knows where we are
;start state 3: oh god, don't have any materia of higher level than the one you're trying to meld and remeld repeatedly in your inventory, I just thought of this and that'd break it too

^q::
SetNumLockState, On ;set num lock to on, I had no idees this existed!

;before doing ANYTHING else, send enter once so the game knows we're using keyboard, not mouse. this is a result of the above start state definition. sorry self and anyone I share this with.
ControlSend,, {Enter}, XIV ;we're using a keyboard, game.
sleep, 500

;the number of materia melds we need is 10,000, this loop is five melds per, so we can't possibly need more than 2,000 iterations of this loop
loop, 2400
{

;loop 1: take five materia out, one at a time
loop, 5
{
ControlSend,, {Enter}, XIV ;hit enter to pick up cloak
sleep, 500 ;wait to make sure we did
ControlSend,, {Enter}, XIV ;hit enter to put down cloak and select it, opening the "right-click" menu
sleep, 500

;loop 1.5: move down 6 spaces in the menu to Retrieve Materia - you will have to change this if you have changed your submenu configurations!
loop, 6
{
ControlSend,, {Numpad2}, XIV ;move down one space in the menu
sleep, 500 ;wait to make sure we did
} ;end loop 1.5

ControlSend,, {Enter}, XIV ;hit enter to select "Retrieve Materia"
sleep, 4500 ;wait to get materia out. this is real damn long.
} ;end loop 1

;now we have an empty cloak! time to open the Meld submenu.
ControlSend,, {Enter}, XIV ;hit enter to pick up cloak
sleep, 500
ControlSend,, {Enter}, XIV ;hit enter to put down cloak and select it, opening the "right-click" menu
sleep, 500

;loop 2: open "Meld" submenu, which is five spaces down for me.
loop, 5
{
ControlSend,, {Numpad2}, XIV ;move down one space in the menu
sleep, 500 ;wait to make sure we did
}

;the first meld is different from the others because the Cloak is automatically selected
ControlSend,, {Enter}, XIV ;hit enter to select "Meld" (because Cloak is already selected)
sleep, 1000
ControlSend,, {Enter}, XIV ;hit enter to select Quicktongue Materia VI
sleep, 1000
ControlSend,, {Numpad4}, XIV ;move from Return to meld
sleep, 1000
ControlSend,, {Enter}, XIV ;begin meld
sleep, 4500 ;wait for meld

;loop 3: four more Melds
loop, 4
{
ControlSend,, {Enter}, XIV ;hit enter to select Vermilion Cloak
sleep, 1000 ;make sure we did
ControlSend,, {Enter}, XIV ;hit enter to select Quicktongue Materia VI (or whatever materia you're using. this will pick top of list.)
sleep, 1000
ControlSend,, {Numpad4}, XIV ;move from Return to meld
sleep, 1000
ControlSend,, {Enter}, XIV ;begin meld
sleep, 4500 ;wait for meld
}

;we have finished melding. hit escape once to bring us back to the armory chest with Vermilion Cloak highlighted, which, conveniently, is where we began! total time elapsed: about a minute per 5 melds
ControlSend,, {Escape}, XIV ;leave meld menu
sleep, 1000 ;make sure we left meld menu, this has been a breaking point because it was hitting the "enter" way too goddamn fast and breaking

} ;end entire loop

;windows-q pauses and unpauses this script, which will stop/resume loop as desired
#q::Pause

;ctrl-esc quits this script altogether
^Esc::
SetNumLockState, Off ;turn num lock off before we go
sleep, 50 ;do we need a sleep here? I honestly don't think so, but I'll never notice
ExitApp
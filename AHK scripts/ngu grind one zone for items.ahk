#SingleInstance force
;just means you can't have multiple copies running, so no crabwalking

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to

CoordMode, Mouse, Client
CoordMode, Pixel, Client
;both specific pixel and mouse clicking coordinates should be relative to "client", which ignores title bar, so it's a little more futureproof (still entirely dependent on my window size)
;note that pixelgetcolor works on VISIBLE pixels because question marks this limitation has existed, according to google, for at least fifteen years, so make sure the ngu window is visible when running this script
;I thiiiiiink it doesn't need to be active because I'm never sending clicks but I am also not gonna risk it at any point so all the debugging gui statments have NoActivate

CombatDelay := 1000
;delay between attacks, change as needed

;ctrl-q starts
^q::
loop,999999999 ;yeah whatever just loop forever
{
Sleep, 1000 ;gonna be honest, I don't know how to do this BEFORE the loop lmao

;starting from Godmother, guaranteed safe zone with no boss in it. move right one zone to Typo, then wait for a spawn
;NOTE: FIRST FIGHT CURRENTLY DOES NOT USE PARRY AND CHARGE. THIS IS NOT OPTIMAL. USE THEM BEFORE STARTING.
ControlSend,, {Right}, NGU
Sleep, 1700 ;my current enemy respawn time is 1.65 seconds

;check pixel 1100, 425 in client for color, store result in variable named Crown because we're looking for the boss crown
PixelGetColor, Crown, 1100, 425

Gui, Destroy
Gui, Add, Text,, Current Pixel Color is %Crown%.
Gui, Show, x100 y100 NoActivate ;pretty sure I need one of these every time?

;0x29eff7 was the first result which looks like what I WANT...
;F7EF29 is the color reported out by windowspy
If (Crown = 0x29EFF7) ;if the enemy is a boss, kill it
{
Gui, Destroy
Gui, Add, Text,, Pixel hit was on 0x29EFF7.
Gui, Show, x100 y100 NoActivate ;pretty sure I need one of these every time?
ControlSend,, V, NGU ;mega buff
Sleep, CombatDelay
ControlSend,, Y, NGU ;ultimate attack
Sleep, CombatDelay
ControlSend,, R, NGU ;parry
Sleep, CombatDelay
ControlSend,, T, NGU ;piercing attack
Sleep, CombatDelay
ControlSend,, E, NGU ;strong attack and I think this is all it takes at my current stats, modify as needed
Sleep, 250 ;this is not a combat sleep, this is the sleep after attacking before sending Left arrow to leave the zone
Waiting := 1 ;set waiting to "yes, we killed a boss and we're waiting"
}

;and if not a boss, do nothing instead
If (Crown != 0x29EFF7)
{
Gui, Destroy
Gui, Add, Text,, None of the above. Hope that wasn't a boss. Color was %Crown%.
Gui, Show, x100 y100 NoActivate ;pretty sure I need one of these every time?
}

;anyway now go back to the godmother, who is a safe zone since we have her on autokill
ControlSend,, {Left}, NGU
Sleep, 1000 ;not actually urgent, just used so I have time to think when watching this for testing

If Waiting = 1 ;if we have killed something
{
Gui, Destroy
Gui, Add, Text,, Chilling until cooldowns, then back to the grind.
Gui, Show, x100 y100 NoActivate ;pretty sure I need one of these every time?
Sleep, 10000 ;wait on cooldown
ControlSend,, G, NGU ;charge
Sleep, 20000 ;34 second mega buff cooldown minus previous waits, including that ten just above, so this is overkill regardless of combat delay value
Waiting := 0
}

}


;esc quits. not ctrl-esc because I have to have ngu visible anyway for the pixel check
Esc::ExitApp

;below this line, commented out scraps I'm keeping or search purposes
;quick testing, ctrl-e confirms there's a window matching the hardcoded criteria
;^e::
;{
;If WinExist(NGU)
;MsgBox, "yes it does"
;}

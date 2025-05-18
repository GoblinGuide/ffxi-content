;this, and all my other scripts, are AHK 1.0 not AHK 2.0. just be aware, because it keeps coming up for me every time I'm on a fresh computer and accidentally install only 2.0

#SingleInstance force
;just means you can't have multiple copies running

SetTitleMatchMode, 2
;can contain the phrase specified below anywhere in the window title (third parameter of ControlClick) to be a match and send input to

CoordMode, Mouse, Client
CoordMode, Pixel, Client
;both specific pixel and mouse clicking coordinates should be relative to "client", which ignores title bar, so it's a little more futureproof (still entirely dependent on my window size)
;note that pixelgetcolor works on VISIBLE pixels because question marks this limitation has existed, according to google, for at least fifteen years, so make sure the ngu window is visible when running this script
;I thiiiiiink it doesn't need to be active because I'm never sending clicks but I am also not gonna risk it at any point so all the debugging gui statments have NoActivate

CrownPixelXCoordinate := 740
CrownPixelYCoordinate := 280
;coordinates of crown, in pixels, client mode, change accordingly

CombatDelay := 1100
;delay between attacks, change as needed

Waiting := 0
JustStarted := 1
;at the beginning, we are not waiting on cooldowns but we have just started

;ctrl-q starts
^q::
loop,999999999 ;yeah whatever just loop forever
{

If (JustStarted = 1) ;do this only at the beginning
{
ControlSend,, G, NGU ;charge
Sleep, CombatDelay
ControlSend,, R, NGU ;parry
Sleep, 20000 ;sleep until charge cooldown's up
JustStarted := 0 ;and make sure we don't go back into this bit
}

;starting from Godmother, guaranteed safe zone with no boss in it cause we autokill her. move right three zones to JRPG, then wait for a spawn (once Exile's minion is dead but before unlock can use Exile and one left)
ControlSend,, {Right}, NGU
Sleep, 250
ControlSend,, {Right}, NGU
Sleep, 250
ControlSend,, {Right}, NGU
Sleep, 250
Sleep, 1700 ;my current enemy respawn time is 1.65 seconds

;check for the crown, store resulting color in variable named Crown because we're looking for the boss crown
PixelGetColor, Crown, CrownPixelXCoordinate, CrownPixelYCoordinate

;Gui, Destroy
;Gui, Add, Text,, Current Pixel Color is %Crown%.
;Gui, Show, x100 y100 NoActivate ;pretty sure I need one of these every time?

;0x29eff7 was the first result which looks like what I WANT...
;F7EF29 is the color reported out by windowspy
If (Crown = 0x29EFF7) ;if the enemy is a boss, kill it
{
ControlSend,, V, NGU ;mega buff
Sleep, 2000 ;sleep until the enemy hits, to use the charged parry
ControlSend,, G, NGU ;charge, which I have to use BEFORE parry or else the parry can get consumed uncharged. how did I not realize this for several iterations of this script, well, you know, I'm dumb.
Sleep, CombatDelay
ControlSend,, R, NGU ;parry
Sleep, 2000 ;again, sleep until hit
ControlSend,, Y, NGU ;ultimate attack
Sleep, CombatDelay
ControlSend,, T, NGU ;piercing attack
Sleep, CombatDelay
ControlSend,, E, NGU ;strong attack
Sleep, CombatDelay
ControlSend,, W, NGU ;normal attack because everything else is on cooldown lol
Sleep, 500 ;this is not a combat sleep, this is the sleep after attacking before sending Left arrow to leave the zone
Waiting := 1 ;set waiting to "yes, we killed a boss and we're waiting"
}

;and if not a boss, do nothing instead
If (Crown != 0x29EFF7)
{
}

;either way, return to the godmother
ControlSend,, {Left}, NGU
Sleep, 250
ControlSend,, {Left}, NGU
Sleep, 250
ControlSend,, {Left}, NGU
Sleep, 250

If Waiting = 1 ;if we have killed something
{
;Gui, Destroy
;Gui, Add, Text,, Chilling until cooldowns, then back to the grind.
;Gui, Show, x100 y100 NoActivate ;pretty sure I need one of these every time?
Sleep, 5000 ;initial cooldown wait seems to sometimes not hit parry properly and I have no idea why.
ControlSend,, R, NGU ;parry is 10 seconds, we have 6 in hardcoded waits before this, one second overkill
Sleep, 11000
ControlSend,, G, NGU ;charge is 20 seconds, we had 5 before parry + 6 for parry = 11, two second overkill
Sleep, 20000 ;mega buff is 34 seconds, we had 5+6+11 = 22, eight second overkill on Mega Buff but we want to be sure Charge is off cooldown as well when we try to use it as soon as a fight starts!
Waiting := 0
}

}


;esc quits. not ctrl-esc because I have to have ngu visible anyway for the pixel check
Esc::ExitApp

;below this line, commented out scraps I'm keeping for search purposes
;quick testing, ctrl-e confirms there's a window matching the hardcoded criteria
;^e::
;{
;If WinExist(NGU)
;MsgBox, "yes it does"
;}

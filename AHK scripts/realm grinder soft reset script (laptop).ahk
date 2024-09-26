;this script was used to affiliate with the faceless and then abdicate and then repeat to boost the value of old faceless heritage, approx. july 2015

#SingleInstance force
#Persistent
#NoEnv

^!q::
sleep, 200
click 430, 160
sleep, 200

loop, 10000
{
sleep, 200

loop, 11
{
sleep, 50
click 480, 550
}
;11 treasure clicks

sleep, 100
click 520, 250
;gem power

sleep, 100
click 830, 150
;1 farm

sleep, 200
send {Shift down}
sleep, 20
click 830, 150
;100 farms

sleep, 200
click 830, 220
;100 inns

sleep, 200
click 830, 280
sleep, 20
send {Shift up}
;100 blacksmiths

sleep, 100
click 450, 250
;neutral allegiance upgrade

sleep, 100
click 680, 350
;farm assistant

sleep, 100
click 680, 350
;inn assistant

sleep, 100
click 680, 350
;blacksmith assistant

sleep, 200
send {Shift down}
click 820, 310
sleep, 200
click 810, 380
sleep, 200
click 810, 430
sleep, 200
click 810, 470
sleep, 200
click 810, 540
sleep, 200
click 810, 590
sleep, 200
click 810, 640
sleep, 200
click 810, 700
sleep, 200
send {Shift up}
;100 of every building

sleep, 1000
loop, 36
{
sleep, 100
click 510, 350
}
;get over half the upgrades before the treaties arrive to get enough income to make locations consistent later -  extra clicks here end up on greyed out upgrades, so harmless

loop, 50
{
sleep 250
click 480, 550
}
;need one of each faction coin because the treaties move the upgrades out of position, also killing time to guarantee 20 Oc for assistant upgrade

loop, 15
{
sleep, 200
click 510, 350
}
;get the rest of the upgrades, including the stupid mana ones - three or four extra clicks on grayed out autocast here but they're harmless too

loop, 9
{
sleep, 200
click 570, 350
}
;buy assistants

sleep, 1000
click 350, 410
sleep, 1000
click 400, 400
sleep, 1000
click 400, 400
sleep, 1000
click 400, 400
sleep, 1000
click 620, 350
sleep, 1000
click 620, 350
sleep, 1000
click 620, 350
sleep, 1000
click 620, 350
sleep, 1000
click 620, 350
sleep, 1000
click 400, 400
;bonus assistants and faction coin find chance upgrades, in an inelegant and very redundant way, ending with the cursor NOT on excavation just in case something breaks

loop
{
sleep, 1000

pixelgetcolor, faceless, 365, 350

if (faceless!=0xB33F66)
;this means the faceless button is lit up
{
sleep, 200
click 365, 350
sleep, 200
click 590, 150
sleep, 200
click 440, 280
sleep, 200
click 440, 510
;this works if we've gained gems
sleep, 200
click 440, 560
;this works if we haven't gained gems
sleep, 200
click 430, 160
break
}

else
{
click 225, 450
;a dummy click to prevent the computer from going to sleep
sleep, 1000
}

}

}

^!5:: Pause
;ctrl-alt-5 pauses

Esc::ExitApp
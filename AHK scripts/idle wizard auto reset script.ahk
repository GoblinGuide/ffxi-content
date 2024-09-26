#SingleInstance force
#Persistent
#NoEnv

^q::
loop, 225
{
sleep, 200
click 450, 765
;that's the exile button

sleep, 200
click 700, 740
;that's the "yes, exile" button

loop, 15
{
sleep, 100
click 800, 720
}
;click fifteen times on the orb

sleep, 100
click 1100, 380
sleep, 1000
click 1100, 380
;buy one gem, wait one second, buy max gems

}
;then do it again until I hit 250 exiles

Esc::ExitApp
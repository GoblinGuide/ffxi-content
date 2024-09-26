#SingleInstance force

;7.56 sandshrew per second... except sometimes it doubleticks and I don't know why so I actually am overbuying here
^q::
loop 999
{
loop 3
{
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 380
}
loop 1
{
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 100
SendInput {Enter}
sleep 460
}

}

;esc to exit
Esc::ExitApp
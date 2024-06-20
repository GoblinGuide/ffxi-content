--pathing to fishing spots is already solved by someone else's ocean fishing script lmao
--can steal queueing and such too
--https://github.com/plottingCreeper/FFXIV-scripts-and-macros/blob/main/SND/FishingRaid.lua (also saved in the snd folder)

--todo:
--figure out how to define "late in current" (30s, 45s, 1m? let's say 30s for now)
--figure out how to get hi-cordial cooldown
--figure out how the *hell* to time my bites and switching and stuff

--DEPENDENCY: SIMPLETWEAKS "Bait Command" enabled, (creates the command /bait

--eat food (crab cakes but also support other stuff?)
--queue, wait for df pop, accept it
--check zone until we're on the boat, loop sleep until out of cutscene (is there a status for that? don't think so)
--move to the edge of the boat (choose a spot at random)
--pop patience 2 at start of z1 (actually tell autohook to "use patience" so it will use after first cast, but also it'll be P1 if you don't have P2)
--then start fishing
--STATUS ID 48 IS "Well Fed" (242 stack count when it's crab cakes, are they storing information here?)
--STATUS ID 568 is "Fisher's Intuition" (stack count might tell us which fish, possibly? 237 in one place, )
--STATUS ID 763 IS "Chum"
--STATUS ID 2569 IS "Cetaceous Speed" (+10 GP regen per tick)
--CONDITION ID 43 is "Fishing" (a good thing to check for)

--REPLACE THIS WITH YOUR FOOD OF CHOICE
FoodName = "Crab Cakes"

--this is the function to begin fishing, i.e. we have just started zone one
function StartOceanFishing()

--loop until we're not stuck in a cutscene

--once we have freedom of movement, use food
--if not HasStatus(48) then --if we are not "Well Fed"
/yield('/item "' .. FoodName .. '"')
--else end --except we always want to eat GP food on a boat, and waste a few thousand gil max by doing so

--figure out where we are and where we're going to be. route does not change over time and deterministically tells us what zones we'll be in
CurrentRoute = GetCurrentOceanFishingRoute()
--1 = Octopus
--2 = Sothis/Stonescale
--3 = Seadragons/Manta
--4 = Jellyfish
--5 = Sharks/Manta
--6 = Sothis
--7 = Manta
--8 = Crab/Toad
--9 = Hafgufa/Elasmosaurus
--10 = Fugu/Stonescale
--11 = Fugu/Manta
--12 = Hafgufa/Placodus

CurrentTime = GetCurrentOceanFishingTimeOfDay()
--1 = day
--2 = sunset
--3 = night

CurrentZone = 1 --this will always be 1 -> 2 -> 3 so that we have something human-readable that tells us what part of the trip we're on
--the combination of CurrentRoute and CurrentZone gives me the physical location place we are as well, if I need it

Weather = GetCurrentOceanFishingWeatherID()
--1 = clear skies, which is the weather after every spectral current
--8 = showers (relevant for some zones, don't think we care about anything else)
--145 = spectral current

--this is also stored as IDs, sadly
FirstMission = GetCurrentOceanFishingMission1Type()
--7 = "catch sharks"

--second mission is alwaus 5 three-star-or-above fish, aka "trigger a spectral and catch five fish in it", which is free and does not need tracking, because you can't get there without a spectral and you can't not get there with one

ThirdMission = GetCurrentOceanFishingMission3Type()
--10 = 34 !

FirstMissionProgress = 0
ThirdMissionProgress = 0
end

function StartZoneTwo()
CurrentZone = GetCurrentOceanFishingZone()
CurrentTime = GetCurrentOceanFishingTimeOfDay()
end

function StartZoneThree()
CurrentZone = GetCurrentOceanFishingZone()
CurrentTime = GetCurrentOceanFishingTimeOfDay()
end


--cast, evaluate every 0.1 seconds god help me (has to be that precise, or more because cast time = 3 vs 2.9 is different hooking behavior)
	--"do we switch to double hook and if so what bite type"
	--mooch evaluation also goes here
function CastLoop()
--cast is governed by AH though? I don't like that
--anyway that's nbd kind of I guess? we'll figure something out
end

--checks for bait, intuition, weather (and thus spectral), AA stacks, whether we should ICPCTH, and GP level
	--optimal chum use? I think it's something like 100 GP missing or less, regen is 8/tick every 3 seconds(ish)
	--don't forget Cetaceous Speed here, can Chum at a lower threshold
	--STATUS ID 2778 IS "Angler's Art" (you're welcome future self)
--ideally can trigger this every time we hook (misses one tick of gp regen tops)
function StatusCheck()
PlayerGP = GetGp()
PlayerMaxGP = GetMaxGp()

--can get time with GetCurrentOceanFishingTimeLeft()

--use chum if we're near overcapping and it's not a spectral current
if PlayerGP + 100 > PlayerMaxGP and not OceanFishingIsSpectralActive() then
--honestly, I have to figure out how I want to use Chum. do I want to set it in an AutoHook precast or do I just want to manually cast it here?
--I'm thinking I want to manually cast it...
else end


end

--when spectral triggers, move to cancel fishing (also cancels patience 2 if we're early in z1 using it)
function StartSpectral()

end

function PostCatchLoop()
FirstMissionProgress = GetCurrentOceanFishingMission1Progress() --currently have to hardcode references to each route's mission, asking croizat if that can be done more easily
ThirdMissionProgress = GetCurrentOceanFishingMission3Progress() --see above note
end

--for now, ignoring all timers. this means we are going to double hook the wrong shit lmao.
function SetAutoHookPreset(PresetName)
SetAutoHookState(true) --make sure autohook is on
DeleteSelectedAutoHookPreset() --delete the preset you currently have active. be sure that you're not losing anything you don't want to lose.

--figure out the proper way to do this
preset = AHPresetToLoad(PresetName)

UseAutoHookAnonymousPreset()
end

--determine which preset we're switching to
function AHPresetToLoad()

end

--timers
--fishing_start_time = os.time()
--while fishing_start_time + 2400 > os.time() do yield("/wait 1") end --that's actually like a lot of time, it's designed for fish antibot shit, but work with me here


--export autohook presets and put them here:
--time ranges are for the fish, so we will swap them in at the first time and out at the second
--while this took about sixty lines, it's actually only 17 distinct presets

--Default: hook everything, no mooch, yes Hi-Cordial, yes Thaliak's Favor
DefaultPreset = '0'

--Before first cast of z1: Patience 2 (maybe just hit this by hand?)
InitialPatiencePreset = '0'

--"double hook ! at some time, and ICPC on specific catches":
--ICPC on the following fish:
--Nimble Dancer
--Floating Saucer
--Exterminator
--Coral Seadragon
--Casket Oyster?
--Silencer?
DHOnePreset = '0'

--"double hook !! at some time, and ICPC on specific catches":
--Mopbeard
--Pearl Bombfish
--Skaldminni
--Knifejaw?
--Devil's Sting?
DHTwoPreset = '0'

--"double hook !!! at some time, and ICPC on specific catches":
--Cieldales Sunset !!!s: Jetborne Manta DH !!! (2-3)
--Gugrusaurus: DH !!! [all, so we can just leave this here]
--Funnel Shark 1: DH !!!, when you catch Funnel Shark IC PC
--Executioner 1: DH !!!, when you catch Executioner IC PC
--Quartz Hammerhand 1: DH !!!, when you catch Quartz Hammerhand IC PC (7+)
DHThreePreset = '0'

--"triple hook !, whether after ICPC or blind":
--Nimble Dancer 2: TH !
--Floating Saucer 2: TH !
--Sea Nettle: TH ! (6.1+)
--Titanshell Crab: TH ! (2-3)
--Exterminator 2: TH !
--Silencer 2: TH ! (3-4)
THOnePreset = '0'

--"triple hook !!, whether after ICPC or blind":
--Flaming Eel: TH !! (6+)
--Mopbeard 2: TH !! [this can be a reuse of Flaming Eel above]
--Pearl Bombfish 2: use Mopbeard 2
--Merman's Mane: TH !! (2-3)
--Ghost Shark: TH !! (3-4)
--Mythril Sovereign: TH !! (5+)
--Skaldminni 2: TH !!
THTwoPreset = '0'

--"triple hook !!!, whether after ICPC or blind":
--Funnel Shark 2: TH !!!
--Executioner 2: TH !!! [can reuse Funnel Shark]
--Quartz Hammerhand 2: TH !!! [can reuse Funnel Shark]
THThreePreset = '0'

--below this point are the weird ones
--Cieldalaes Sunset/Night !! Mission, stop cast at 12s
CieldalaesTwoTimed = '0'

--Roguesaurus
SouthernMerlthorMoochTHThree = '0'

--Great Grandmarlin
SouthernMerlthorMoochTHTwo = '0'

--Default, but with Mooch on
NothingButMooch = '0'

--Default, but hoard AAs
DefaultButNoAA = '0'

--TH or DH every bite (to burn all GP late final spectral current)
THEverything = '0'
DHEverything = '0'

--Southern Merlthor Night Spectral, Makeshift Bait on, Prize Catch not on, Use Mooch 2 on
SouthernMerlthorMoochDHTwo = '0'

--Rothlyt Sunset Spectral Late: Mooch on, DH Mooch !
RothlytMoochDHOne = '0'

--multihook presets without ICPC
--!
--Rothlyt Day Fugu: DH ! (14-23)
--Rothlyt Day ! 1: DH ! (14-23)
--Rothlyt Day ! 2: DH ! (7-11, 14-23)
--Bloodbrine Day Crabs: DH ! (16-26)
--Southern Merlthor Night/Sunset Jellyfish: La Noscean Jelly DH ! (2-5)
--Cieldales Sunset Fugu/!: Metallic Boxfish DH ! (2-3)

--!!
--Garum Jug
--Beatific Vision
--Ghost Shark

--!!!
--Rhotano Day Sharks: DH !!! (0-19.5)
--Rhotano Day Sharks 2: DH !!! (all, after spectral)

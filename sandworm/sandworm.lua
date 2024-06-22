_addon.name = 'Sandworm'; --not renaming this even though I'm broadening its scope as I type this
_addon.version = '0.6'; --20240621 ACTUALLY made the direct mob status check work. theoretically this is actually 1.0 because there aren't any more functional changes I want to implement.
_addon.author = 'DACK';
_addon.commands = { 'worm', 'sandworm' , 'sand'}; --DEAD I AM THE ONE

res = require('resources') --used to get zone names, to input superwarp commands based on the predefined English names in the results list
packets = require('packets') --"nice ffxi" "thanks! it has packets."
texts = require('texts') --used for the gui
files = require('files') --used to log output to file
require('logger') --used to generate notices in the in-game chat. I prefer this to just using a naked windower.add_to_chat() but you can do that instead if you want. it comes in colors and everything.
require('tables') --I'm gonna be honest with you. I don't know what this damn thing does.

--DEPENDENCIES:
--SCANZONE (see project tako's repo at https://github.com/ProjectTako/ffxi-addons/tree/master/scanzone/windower)
--SUPERWARP (see akaden's repo at https://github.com/AkadenTK/superwarp)
--MYHOME (this is in the default Windower launcher, but if you're curious that means you can find its code at https://github.com/Windower/Lua/tree/dev/addons/MyHome)
--DON'T START THIS IN, OR HAVE YOUR HOME POINT SET TO, ANYWHERE IN TAVNAZIAN SAFEHOLD. I'M VERY LAZY. SORRY, BUT ALSO NOT SORRY.

--set these variables to true for two levels of debug logging in the chat log. major is very spammy, minor is only "mostly" spammy.
DebugVariable = true
VerboseDebugVariable = true

--set this variable to true to also log all output to the file location defined by the second variable here - that's currently "output.txt" in the same folder as this addon (but you can give it an entire path if you want, allegedly)
WriteResultsToFile = true
FileOutputLocation = 'output.txt'

--the loop frequency, in MINUTES. this is not seconds. that means this whole thing will loop every "sixty times this number" seconds (or when the previous loop ends - this is a floor, not a ceiling.)
LoopFrequency = 10

--update the GUI only this many frames. remember that ffxi natively runs at 30 fps, windower can uncap to 60 or uncapped.
HowManyTicksToUpdate = 30
count = 0 --used to track time for the GUI display

--list of targets. order is zone id, target name, method used to teleport there (currently only supports survival guide/home point)
TargetsList = {
			81,'Sandworm','Survival Guide',
			84,'Sandworm','Survival Guide',
			88,'Sandworm','Survival Guide',
			91,'Sandworm','Survival Guide',
			95,'Sandworm','Survival Guide',
			97,'Sandworm','Survival Guide',
			98,'Sandworm','Survival Guide',
			166,'Taisaijin','Survival Guide',
			190,'Vrtra','Survival Guide',
			205,'Ash Dragon','Survival Guide',
			125,'King Vinegarroon','Survival Guide', --this is just to get tod, probably will never find him alive, because he's a weatherlord and I'm gonna have to babysit this... do I want to track weather? naw.
			110,'Simurgh','Survival Guide',
			79,'Khimaira','Home Point', --first of the HPs on the list is in Caedarva Mire, in case that's where this breaks
			61,'Cerberus','Home Point',
			7,'Tiamat','Home Point',
			5,'Jormungand','Home Point',
			--102,'Bloodtear Baldurf','Survival Guide', --killed this
			--51,'Hydra','Survival Guide', --killed this
			--81,'Dark Ixion','Survival Guide', --killed this WHILE TESTING this dang thing, lmao, talk about a proof of concept
			--82,'Dark Ixion','Survival Guide',
			--84,'Dark Ixion','Survival Guide',
			--89,'Dark Ixion','Survival Guide',
			--91,'Dark Ixion','Survival Guide',
			--96,'Dark Ixion','Survival Guide',
			}

NumberOfTargets = 16 --there's no easy way to just "count" a table in lua. manually total up how many mobs you have here. sorry.
PiecesPerTarget = 3 --zone id, mob name, transport method
TargetsListLength = NumberOfTargets * PiecesPerTarget --magic numbers! yay!

--next, an array to store our results. for each mob there are six entries:
--a zone, then a mob in that zone (Ixion and Sandworm are each capable of spawning in Ronfaure/Batallia/Rolanberry so those zones get two lines each)
--then the time of the most recent check, the status from that check, and the coordinates the mob was found at
--then the last time the mob was known to be alive (should this be tod instead?)
ResultsList = {'',''} --to be overwritten, immediately below this. but let's make sure its's an array because sigh, lua
NumberOfResults = NumberOfTargets --there's no reason this HAS to be the same, but also it's illogical for it to ever not be
PiecesPerResult = 7 --zone, mob, last check time, last check status, last check coordinates, most relevant status change time, timestamp on that status change
ResultsListLength = NumberOfResults * PiecesPerResult --length of the results list = (number of mob entries) * (pieces of information per mob)

--create the variables that will hold the results of the search
for LoopCount = 1, NumberOfTargets, 1 do
	AlreadyCompletedElements = (LoopCount-1)*PiecesPerResult --the first X-1 mobs are done, so skip the first (X-1) * (elements per mob) elements [for the first one, this is 0, so we don't run into weird index problems]

	ResultsList[AlreadyCompletedElements+1] = res.zones[TargetsList[(PiecesPerTarget*(LoopCount-1))+1]].english --similarly, skip first X-1 * (elements per mob) elements of target list, then next one's a zone ID
	ResultsList[AlreadyCompletedElements+2] = TargetsList[(PiecesPerTarget*(LoopCount-1))+2] --and the one after that is a mob name
	ResultsList[AlreadyCompletedElements+3] = os.date("%X",os.time()) --current time, in 24h HH:MM:SS format
	ResultsList[AlreadyCompletedElements+4] = 'Unchecked' --because we haven't checked it yet
	ResultsList[AlreadyCompletedElements+5] = '1, 1, 1' --will be overwritten with mob coordinates as of the first check.
	--a mob that hasn't spawned since maintenance will be at 0, 0, 0 so I absolutely do NOT want to use that, since that's a legitimate result. oops. added that functionality and forgot to actually account for it
	ResultsList[AlreadyCompletedElements+6] = os.date("%X",os.time()) --just so we know this is a time, for later
	ResultsList[AlreadyCompletedElements+7] = 'Unchecked' --all we know is that we know nothing

	--intended output format: 'East Ronfaure [S]', 'Sandworm', time, 'Unchecked', '1, 1, 1', time, 'Unchecked'
	--just to know whether they're in the right order. 
	if VerboseDebugVariable then
		notice('Startup array element: ' .. LoopCount .. ': ' .. ResultsList[AlreadyCompletedElements+1] .. ', ' .. ResultsList[AlreadyCompletedElements+2] .. ', ' .. ResultsList[AlreadyCompletedElements+3] .. ', '
		.. ResultsList[AlreadyCompletedElements+4] .. ', ' .. ResultsList[AlreadyCompletedElements+5] .. ', ' .. ResultsList[AlreadyCompletedElements+6] .. ', ' .. ResultsList[AlreadyCompletedElements+7] ..'.')
	end


end

--define the gui info box. since these settings won't change throughout running, but you may want to change them, they go up here at the start of the file.
windowSettings = T{}
windowSettings.pos = {}
windowSettings.pos.x = 50 --not quite at the left edge of the screen
windowSettings.pos.y = 375 --slightly below the windower console on my monitor, your mileage will vary by resolution, but my console has the black background/red text bomco that makes this hard to read while it's open
windowSettings.bg = {}
windowSettings.bg.alpha = 200 --this is opacity ("alpha" as in brightness of the box background) - 255 opaque, 0 completely transparent
windowSettings.bg.red = 150
windowSettings.bg.green = 150
windowSettings.bg.blue = 150
windowSettings.bg.visible = true
windowSettings.flags = {}
windowSettings.flags.bold = true
windowSettings.flags.italic = false
windowSettings.flags.draggable = true --lets you drag the window with the mouse. lol at that.
windowSettings.padding = 10 --controls the margin around the edge of the box. this is good to know about even if you probably shouldn't mess with it.
windowSettings.text = {}
windowSettings.text.size = 12
windowSettings.text.font = 'Courier New' --courier is the calligraphy of my people
windowSettings.text.fonts = {}
--windowSettings.text.alpha = 0 --setting this to any number doesn't seem to do anything. just so people know. suspect it has to be defined in the actual text we're displaying?
--windowSettings.text.stroke.alpha = 255 --same. commenting these out doesn't change anything either, which I proved by testing it.

--DACK note: the function texts dot new creates a text box, unsurprisingly. see roller.lua and omen.lua for what I stole to glean this insight. lmao.
info = texts.new(windowSettings)

--begin with some joke text to show how the UI works so it can be dragged where you want it and whatever and also to show when it gets overwritten shortly afterwards
info_display = ' \\cs(150, 0, 200)' .. 'Notorious Monster Hunter! \\cr \n'
info_display = info_display .. ' \\cs(200, 00, 0)' .. 'Notorious \\cr \n'
info_display = info_display .. ' \\cs(0, 200, 0)' .. 'Monster \\cr \n'
info_display = info_display .. ' \\cs(0, 0, 200)' .. 'Hunter \\cr \n'
info_display = info_display .. ' \\cs(230, 230, 230)' .. '...Notorious Monster Hunter? \\cr \n'
info_display = info_display .. ' \\cs(0, 0, 0)' .. 'Yes, Notorious Monster Hunter. \\cr \n'

--start when we put in "worm start"
windower.register_event('addon command', function (...)
	local cmd  = (...) and (...):lower();

	if (cmd == 'start') then

		if DebugVariable then
			notice('Starting the worm hunter.')
		end

		windower.send_command("lua r scanzone")
		coroutine.sleep(0.2)
        windower.send_command("lua r superwarp") --who plays without superwarp? nonetheless, futureproofing.
		coroutine.sleep(0.2)

        main_function()

    elseif cmd == 'test' then

		notice('Starting the testing function.')

		testing_function()
    
	else
		notice("The only supported command is 'start'. And also 'test' I guess. Use one of those.")
	end

end)
	
--display the GUI
--dack note: this is "postrender", as in we do it immediately after every rendering tick. other relevant options are "load" (on addon load, so only once ever), "status change" which can work on zoning <-> idle, and "zone change".
--frankly, I have no idea if it's correct to put this in here for sixty times per second even if I'm not UPDATING the content sixty times per second
windower.register_event('postrender', function()
	
	--only update as often as we told it to, that's just a modulo function
	if count % HowManyTicksToUpdate == 0 then 
    	info:text(info_display)
    	info:visible(true)
	end

	--then increment the count by 1
	count = count + 1
end)

--scanzone plugin's default relevant messages, verbatim, are:
--[ScanZone]Found entity with name: ENTITY NAME. TargetIndex: 0xHEXADECIMAL
--[ScanZone]Position: (X, Y, Z)
--this function examines all incoming text to check whether it looks like that. if it does, it formats and stores the information accordingly.
--BIG assumption: there is only one relevant entity ID per zone. this is true for everything that I'm currently hunting, thank god. multiple zones for the mob but each zone only has one entity id for the mob.
windower.register_event("incoming text", function(original)
	if original:contains("Found entity") then

		CurrentZone = windower.ffxi.get_info().zone --global variable storing zone ID
		CurrentZoneName = res.zones[windower.ffxi.get_info().zone].english --grabs english name from zone ID
		
		if DebugVariable then
			notice('Debug: Current zone ID: ' .. CurrentZone .. ' (' .. CurrentZoneName .. ')')
		end

		--the format is 'Found entity with name: MOB NAME GOES HERE.' so we go from 'name: ' to '.' (unique period, formatting's weird.)
		--we add two to the second parameter because that tells us not where ": " starts, but two places after that, as in the text after it
		--we subtract one from the third parameter to get "mob name" rather than "mob name.". and the percent sign is an escape cahracter, we're looking for an actual period "." and not a wildcard
		TargetName = string.sub(original,string.find(original,': ')+2,string.find(original,'%.')-1)
		TargetIndex = string.sub(original,string.find(original,'0x'),string.len(original)) --string.find returns start AND end coordinates, but if you call with just one variable you only get the start character.
		notice(TargetName .. ' entity index: ' .. TargetIndex)

	elseif original:contains("Position:") then
		
		CurrentZone = windower.ffxi.get_info().zone --global variable storing zone ID
		CurrentZoneName = res.zones[windower.ffxi.get_info().zone].english --grabs english name from zone ID
		
		if DebugVariable then
			notice('Debug: Current zone ID: ' .. CurrentZone .. ' (' .. CurrentZoneName .. ')')
		end

		TargetPositionString = string.sub(original,string.find(original,'%('),string.find(original,'%)')) --coordinates are between two sets of parentheses
		notice(TargetName .. ' position: ' .. TargetPositionString)

		--also set the time that we got these coordinates here, so it's maximally accurate.
		UpdateTime = os.date("%X",os.time())

	else
		--otherwise the text is not from scanzone so we do not care about it
	end
end)


--every [10 minutes, user defined], go through the target list in order, then wait patiently if it hasn't been [10 minutes] yet, then repeat
function main_function()

	if DebugVariable then
		notice('Debug: Started main function.')
	end

	--start the loop, so get to a known SG location
	startup_function()

	if DebugVariable then
		notice('Debug: Startup function complete. Beginning mob search loop.')
	end

	--loop forever - may want an exit condition someday I guess.
    while 1 do

		--store start time for this loop, so we can wait until the waiting interval is over after it's done
		LoopStartTime = os.clock()

		if DebugVariable then
			notice('Debug: Starting search loop.')
		end
	
		--scan all the zones
		for LoopVariable = 1, NumberOfTargets, 1 do

			if DebugVariable then
				notice('Debug: New value of search loop variable is ' .. LoopVariable)
			end
	
			CurrentTarget = LoopVariable --on loop iteration N, we are hunting the Nth mob
			GetToZone(PiecesPerTarget*(LoopVariable-1)+1) --for target N, skip N-1 targets [variables for a target = pieces per target * that target's number], then look at the first thing in the array after that, which is the zone ID
			CheckZone(PiecesPerTarget*(LoopVariable-1)+1) --now that we're there, check that zone ID for that target

			update_target_information() --save that info to the table
			update_gui() --output that info to the GUI

			if WriteResultsToFile then
				put_results_in_file() --save info to file as well, if configured to do so
			end

		end

		if DebugVariable then
			notice('Debug: Single iteration of the search loop complete at ' .. os.date("%X",os.time()) .. '. Returning to Tavnazian Safehold.')
		end

		startup_function()

		if DebugVariable then
			notice('Waiting another ' .. math.ceiling((60*LoopFrequency) - (os.clock() - LoopStartTime)) .. ' seconds to begin the next loop.') --does this even work? pretty sure it should...
		end

		--now wait until [10 minutes] have elapsed and do it again
		while os.clock() < LoopStartTime + (60*LoopFrequency) do
			coroutine.sleep(1)
		end
	
	end

end


--functions below this comprise the core loop of actual functionality
--navigate to Tavnazian Safehold HP #1. hardcoded because I am a lazy man.
function startup_function()

	if DebugVariable then
		notice('Debug: Started startup function.')
	end

	--check whether we are near a home point
	local nearest_home_point_id = get_nearest_mob_by_prefix('Home Point') --local variables still frighten me

	--if we find a home point within loading distance, it has an ID, so that variable is not nil
	if nearest_home_point_id ~= nil then
	
		--and it's close enough to just interact with it (interact distance is below 7 but above 6, tavnazian safehold HP is ~5.8 yalms from where you arrive when using the Survival Guide to get there
		if get_distance(windower.ffxi.get_mob_by_id(nearest_home_point_id).x, windower.ffxi.get_mob_by_id(nearest_home_point_id).y) < 6 then
	    
			--then we do not have to warp
			if DebugVariable then
				notice('Debug: Started within interact distance of a Home Point. No Warp needed.')
			end

		else 

			if DebugVariable then
				notice("Debug: Started close enough to see a Home Point, but far enough away that we can't interact with it. Warping to be sure we're at a Home Point we CAN interact with.")
			end
		
			windower.send_command('mh')
	    	wait_for_zone_change()
			wait_for_mob_by_prefix('Home Point')
		end

	--also warp if we don't find a home point, obviously
	else

		if DebugVariable then
			notice("Debug: Didn't start near a Home Point. Warping to get to a guaranteed Home Point.")
		end

		windower.send_command('mh')
	    wait_for_zone_change()
		wait_for_mob_by_prefix('Home Point')

	end

    --now we're at a home point, by definition
	windower.send_command('sw hp Tavnazian Safehold 1') --this is more comprehensible than my usual 'sw hp taf sav'. you're welcome :P
	wait_for_zone_change()

	if DebugVariable then
		notice('Debug: Should be loading into Tavnazian Safehold. Waiting to find the Survival Guide.')
	end

	wait_for_mob_by_prefix('Survival Guide') --wait for SG to load so we know we're in Tav Saf

	if DebugVariable then
		notice('Debug: Ended startup function. We should be in Tavnazian Safehold.')
	end

end


--handles movement between zones. currently supports Home Points and Survival Guides.
--possibly relevant future types of teleportation: unity warps (arrive on same submap as khimaira), voidwatch? (can't imagine why), unity? (also can't imagine why)
--variable passed in is a position on the targets list table that holds a zone ID
function GetToZone(TargetsListID)
	
	if DebugVariable then
		notice('Debug: Called Get To Zone function with target list table element ID = ' .. TargetsListID)
		notice('Debug: This means that we are traveling to ' .. res.zones[TargetsList[TargetsListID]].english .. '.')
	end

	--the data stored at that position in the target list is a zone ID, so translate it into a name
	DestinationZoneName = res.zones[TargetsList[TargetsListID]].english 

	WaitingFor = TargetsList[TargetsListID+2] --this item is the entity being used to teleport, which is also present at the destination zone, so we will be "waiting for" the one at our destination to load, thus the name
	
	if TargetsListID > 1 then
		PreviousArrivalPoint = TargetsList[TargetsListID-1] --this tells us what we used last time, so we can leave the way we came
	else
		PreviousArrivalPoint = WaitingFor --if we just started, we are in tav safehold next to a SG and also a HP, so just pretend we came from what we're about to use to save a little time
	end

	--only try to go there if we are not already there
	if DestinationZoneName ~= res.zones[windower.ffxi.get_info().zone].english then

		if WaitingFor == 'Survival Guide' and PreviousArrivalPoint == 'Survival Guide' then
			WarpCommand = 'sw sg ' .. DestinationZoneName --Guide to Guide uses Guide

			if DebugVariable then
				notice('Debug: Sending windower travel command: ' .. WarpCommand)
			end
	
			windower.send_command(WarpCommand)
			wait_for_zone_change()
			wait_for_mob_by_prefix(WaitingFor) --wait for zone to finish loading (using prefix throughout here because there isn't a Survival Guide #2 anywhere YET, but why risk it?)

		elseif WaitingFor == 'Home Point' and PreviousArrivalPoint == 'Home Point' then
			WarpCommand = 'sw hp ' .. DestinationZoneName --Home Point to Home Point uses Home Point

			if DebugVariable then
				notice('Debug: Sending windower travel command: ' .. WarpCommand)
			end
	
			windower.send_command(WarpCommand)
			wait_for_zone_change()
			wait_for_mob_by_prefix(WaitingFor)

		elseif WaitingFor == 'Home Point' and PreviousArrivalPoint == 'Survival Guide' then

			WarpCommand = 'sw sg Tavnazian Safehold' --for SG to HP, sg to Tav and transfer lines

			if DebugVariable then
				notice('Debug: Sending first windower travel command: ' .. WarpCommand)
			end
	
			windower.send_command(WarpCommand)
			wait_for_zone_change()
			wait_for_mob_by_prefix(WaitingFor) --Tav is specifically used because you are in interact range of the one when you arrive from the other

			WarpCommand = 'sw hp ' .. DestinationZoneName --now actually go where we are trying to go

			if DebugVariable then
				notice('Debug: Sending second windower travel command: ' .. WarpCommand)
			end
	
			windower.send_command(WarpCommand)
			wait_for_zone_change()
			wait_for_mob_by_prefix(WaitingFor) --thanks, Tav!

		elseif WaitingFor == 'Survival Guide' and PreviousArrivalPoint == 'Home Point' then --this one is currently unused, but should be functional, since it's just an inversion of the previous logic

			WarpCommand = 'sw hp Tavnazian Safehold 1' --for HP to SG, hp to Tav #1 and transfer lines (make sure it's 1 - 2 and 3 are on other floors altogether)

			if DebugVariable then
				notice('Debug: Sending first windower travel command: ' .. WarpCommand)
			end
	
			windower.send_command(WarpCommand)
			wait_for_zone_change()
			wait_for_mob_by_prefix(WaitingFor) --I don't care about naming characters so Tav was my male monk protagonist in BG3

			WarpCommand = 'sw sg ' .. DestinationZoneName

			if DebugVariable then
				notice('Debug: Sending second windower travel command: ' .. WarpCommand)
			end
	
			windower.send_command(WarpCommand)
			wait_for_zone_change()
			wait_for_mob_by_prefix(WaitingFor) --Tav gonna beat the shit out of these notorious monsters (by proxy)

		else

			print('error: Invalid teleportation type among either ' .. WaitingFor .. ' or ' .. PreviousArrivalPoint .. ' specified. Please fix it to either "Home Point" or "Survival Guide". Unloading.')
			windower.send_command('lua u sandworm')
		
		end
		

	--otherwise, we're already here from the previous mob, so do nothing.
	else
	
		if DebugVariable then
			notice('Debug: Already here from the previous mob. Not moving.')
		end

	end


end

--checks the listed zone for our current target.
--variable passed in is a position on the targets list table that holds a zone ID
function CheckZone(TargetsListID)
	
	--there is a variable above named "target name", but that variable is not updated yet. this is because I am bad at coding and this whole thing is held together with spit and tape.
	CurrentTargetName = TargetsList[TargetsListID+1]

	if DebugVariable then
		notice('Debug: Called CheckZone for ' .. res.zones[TargetsList[TargetsListID]].english .. '.')
		notice('Debug: Sending windower command: scanzone name ' .. CurrentTargetName)
	end

	--scan to find the target name's ID. we could hardcode this because it does not change unless new mobs are added to a zone but this is more versatile if we add to the target list in the
	windower.send_command('scanzone name ' .. CurrentTargetName)
	--ironically, "target name" is populated immediately after this

	--wait for scanzone result to come in so that the chat reading function will update the value of the "target index" variable.
	--if this sleep is too short, it'll break everything via an incomplete capture error (because the second scanzone message will come in and trigger the same event before the first instance of that event has finished)
    coroutine.sleep(5)

	if DebugVariable then
		notice('Debug: Sending windower command: scanzone scan ' .. TargetIndex)
	end

	--now scan the zone for the thing we're looking for
	windower.send_command('scanzone scan ' .. TargetIndex)

	--wait for scanzone result to come in so the chat reading can update the value of the target position variable.
	--if this sleep is too short ... I thiiiink nothing breaks but this single check? but also it might just not update the variables properly and poop all over the results table. so don't risk it, honestly.
	coroutine.sleep(5)

	--this should now be properly set from those scanzone calls above
	NewPositionString = TargetPositionString
	
	if DebugVariable then
		notice('Debug: Current coordinates found were ' .. NewPositionString)
	end

end


--intended functionality: compare the previous position string to the new position string. if they are different, update the info in the array of positions. this should update the gui accordingly. maybe.
function update_target_information()

	if DebugVariable then
		notice('Debug: Started Update Target Information function.')
	end

	--variables we have arrived with:
	--"current target" (which number mob we are looking at)
	--"target name" (the name of the mob that we are looking at)
	--"new position string" (coordinates that mob is currently located at, whether it's dead or alive)
	--"update time" (the time we got those coordinates, which is around a few seconds ago, but we can just pretend it's "right now" since it will be consistently off the same way every time)

	--we know for a fact that scanzone has gotten us the info packet for that mob, so it's loaded into the array of mobs
	--therefore, we can just do this
	TargetStatus = windower.ffxi.get_mob_by_name(TargetName).status
	TargetHPP = windower.ffxi.get_mob_by_name(TargetName).hpp --using this to disambiguate between "alive and not in combat" and "has never spawned since maintenance". this is actually the only brilliant bit in this entire file.

	--the first (pieces per result) * (current target - 1) entries in the results table are the previous mobs we already looked at
	--intended output format: 'East Ronfaure [S]', 'Sandworm', time, 'Unchecked', '1, 1, 1', time, 'Unchecked' - i.e. the Nth mob's entries are name, zone, previous time and status and position, relevant time and status
	--therefore, to find information about this current target, skip the first 7*(N-1) entries which are the first N-1 mobs, then it's the next septuple, so take that and add 1 through 7:
	if DebugVariable then
		notice('Debug: came in with currenttarget = ' .. CurrentTarget)
		notice('Debug: came in with newpositionstring = ' .. NewPositionString)
		notice('Debug: came in with updatetime = ' .. UpdateTime)
		notice('Debug: Zone: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 1])
		notice('Debug: Mob: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 2])
		notice('Debug: Last Time: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 3])
		notice('Debug: Last Status: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 4])
		notice('Debug: Last Coords: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 5])
		notice('Debug: Relevant Time: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 6])
		notice('Debug: Relevant Status: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 7])
	end

	--update the variable "new mob status" - because it already existed from my previous version of this - to be words showing the information that I actually want from the status
	--status 0 is "idle", for sure it's used when the target hasn't spawned since maintenance - this gives coords 0 0 0 too, which is awkward - but also "alive and nobody's killing it"
	--status 1 is engaged but alive, aka "someone else is killing it"
	--status 2 is "dead", no clue what happens when a sandworm despawns but I wonder if that's relevant here. anyway we can 
	--status 3 is "died engaged" - that's when someone killed it and it died while in combat
	if (TargetStatus == 0 and TargetHPP == 0) then
		NewMobStatus = 'Unspawned' --if it's idle but has no HP, it's not what us measly humans would call "alive". in fact, it's never been alive in this zone since the servers came up.
	elseif (TargetStatus == 0 and TargetHPP == 100) then
		NewMobStatus = 'Alive' --specifically, alive and we can go get it right now, since it's at full HP which implies it is not claimed by another human. there's a way to check literally that, but we don't care, this is fine.
	elseif TargetStatus == 1 then
		NewMobStatus = 'Alive' --specifically, alive fighting. which means it will probably be dead REAL soon, because it is claimed by another human. that's ok, we can work with that.
	elseif TargetStatus == 2 then
		NewMobStatus = 'Dead' --specifically, died not engaged, so probably King Vinegaroon/Sandworm actively despawning when their windows closed. maybe some other cases I don't know about.
	elseif TargetStatus == 3 then
		NewMobStatus = 'Dead' --specifically, died engaged, but that's still a death.
	else
		--if it's any status above 3, I have no idea what it is, but I will log it and figure it the hell out. sandworm better not be crafting. king vinegarroon gone fishing. etc.
		NewMobStatus = 'Unknown Status. Number = ' .. TargetStatus
	end

	--just to show this visually, here's what we're updating. I'm going to use pieces * current target and back-count to avoid showing (X*(N-1))+A when I can use (X*N)-B instead, because it's visually cleaner
    --                            1                    2          3      4            5         6      7
	--stored information format: 'East Ronfaure [S]', 'Sandworm', time, 'Unchecked', '1, 1, 1', time, 'Unchecked'
    --                           -6                   -5         -4     -3           -2        -1     -0
								 
	--I'm going to reference this enough below that I wanted to give it a human-readable name
	PreviousMobStatus = ResultsList[(PiecesPerResult*CurrentTarget)]

	--whether or not to update the final two parameters, "relevant mob status and its time" is conditional. we want to keep the best of: death after life = time of death > time of life > time of any check at all > unchecked
	--therefore, compare new status to previous status. if it hasn't changed, do nothing. if it has, start evaluating which is better. many such cases!
	
	--if we already know the ToD, even if it's from a while ago (this is a special status that we only get by manually setting it, so it can take precedence)
	if PreviousMobStatus == 'Approximate Time of Death Known' then
			
		--don't update anything, because there's nothing more important to store there.
		
	--if is dead but was alive, great, we have a time of death!
	elseif NewMobStatus == 'Dead' and PreviousMobStatus == 'Alive' then
		
		--the time at which this happened is actually the previous time, not the current time (because it could have happened one second after we looked and we want to be there when the window opens so we'd rather start early)
		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = 'Approximate Time of Death Known'
		ResultsList[(PiecesPerResult*CurrentTarget) - 6] = ResultsList[(PiecesPerResult*CurrentTarget) - 4]
	
	--if it's dead now and was dead before, put the new info in the last two variables so that we know how recent our info is
	elseif NewMobStatus == 'Dead' and PreviousMobStatus == 'Dead' then
	
		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus
		ResultsList[(PiecesPerResult*CurrentTarget) - 6] = UpdateTime
	
	--if the mob is alive right now, but not at full health, someone else is killing it. pretend that it's already dead as of right now and I'll show up to the next window a minute or two early, it's fine
	elseif NewMobStatus == 'Alive' and TargetHPP < 100 then
	
		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = 'Approximate Time of Death Known'
		ResultsList[(PiecesPerResult*CurrentTarget) - 6] = UpdateTime

	elseif NewMobStatus == 'Alive' and TargetHPP == 100 then

		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = 'CURRENTLY ALIVE!!!!!'
		ResultsList[(PiecesPerResult*CurrentTarget) - 6] = UpdateTime

	elseif NewMobStatus == 'Unspawned' then
	
		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = 'Unspawned'
		ResultsList[(PiecesPerResult*CurrentTarget) - 6] = UpdateTime

	--if we have gotten here, we don't have new mob status as anything we should have set above. which means we have a value for status > 3. which means I have no idea what it is, so document it and move on.
	else

		notice('This should never happen. Something weird went wrong. Please take notes.')

		--still update these two, but don't change the last two pieces of information? will test later
		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus
		ResultsList[(PiecesPerResult*CurrentTarget) - 6] = UpdateTime

	end

	--now we know we have the most relevant ToD info stored, so we don't need the results from the last loop.
	--overwrite the results from the previous loop with the results from this loop
	ResultsList[(PiecesPerResult*CurrentTarget) - 5] = NewPositionString --most recent position = the "new position string"
	ResultsList[(PiecesPerResult*CurrentTarget) - 4] = NewMobStatus --most recent status
	ResultsList[(PiecesPerResult*CurrentTarget) - 3] = UpdateTime --most recent time = the "update time", aka "right now" ish

end


--regenerate the text information in the gui from scratch, because I honestly don't know a better way
function update_gui()

	--create the variable that will hold ALL the info we're displaying
	info_display = ' \\cs(150, 0, 200)' .. 'Notorious Monster Hunter \\cr \n'

	if DebugVariable then
		notice('Debug: Re-creating GUI.')
	end

	--update each line individually and concatenate into the same displayed variable repeatedly. each line ends with a Carriage Return and a Newline to move to the next line
	--the information we're accessing looks like:
	--                            1                    2          3      4            5         6      7
	--stored information format: 'East Ronfaure [S]', 'Sandworm', time, 'Unchecked', '1, 1, 1', time, 'Unchecked'
    --(pieces * target) minus:   -6                   -5         -4     -3           -2        -1     -0
	
	for ResultLoop = 1, NumberOfResults, 1 do
		
		--possible statuses at this point are 'Dead', 'Unspawned', 'Approximate Time of Death Known', 'Unchecked', and 'CURRENTLY ALIVE!!!!!'

		if ResultsList[(PiecesPerResult*ResultLoop)] == 'CURRENTLY ALIVE!!!!!' then
			--all of these are broken into multiple lines of text for readability, but are one "new line" total, since it's all concatenated
			info_display = info_display .. ' \\cs(0, 175, 0)' .. ResultsList[(PiecesPerResult*ResultLoop) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop) - 6]
			info_display = info_display .. ' IS ALIVE RIGHT NOW, AS OF ' .. ResultsList[(PiecesPerResult*ResultLoop) - 1] .. '!' .. '\\cr \n'
			--this should be green text reading something like "Jormungand in Uleguerand Range IS ALIVE RIGHT NOW, AS OF 12:34:56!"
			
		elseif ResultsList[(PiecesPerResult*ResultLoop)] == 'Dead' then
			info_display = info_display .. ' \\cs(175, 0, 0)' .. ResultsList[(PiecesPerResult*ResultLoop) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop) - 6]
			info_display = info_display .. ' was dead with ToD unknown as of ' .. ResultsList[(PiecesPerResult*ResultLoop) - 1] .. '.' .. '\\cr \n'
			--this should be red text reading something like "Jormungand in Uleguerand Range was dead with ToD unknown as of 12:34:56."
			
		elseif ResultsList[(PiecesPerResult*ResultLoop)] == 'Approximate Time of Death Known' then
			info_display = info_display .. ' \\cs(0, 0, 175)' .. ResultsList[(PiecesPerResult*ResultLoop) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop) - 6]
			info_display = info_display .. ' best known ToD was ' .. ResultsList[(PiecesPerResult*ResultLoop) - 1] .. '.' .. '\\cr \n'
			--since alive and dead are green and red, known tod will be blue, I guess.
			--should read something like "Jormungand in Uleguerand Range best known ToD was: 12:34:26."
			--message is different since Sandworm could be in any of the zones. will never do: check values across all with same name cause any one tod means they're all dead, etc (already killed ixion while I tested this)
		
		elseif ResultsList[(PiecesPerResult*ResultLoop)] == 'Unspawned' then
			info_display = info_display .. ' \\cs(50, 50, 50)' .. ResultsList[(PiecesPerResult*ResultLoop) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop) - 6]
			info_display = info_display .. ': Unspawned since maintenance as of ' .. ResultsList[(PiecesPerResult*ResultLoop) - 1] .. '.' .. '\\cr \n'
			--gray text, for when we don't know enough to make confident statements.
			--should read something like "Jormungand in Uleguerand Range: Unspawned since maintenance as of 12:34:26."

		elseif ResultsList[(PiecesPerResult*ResultLoop)] == 'Unchecked' then
			info_display = info_display .. ' \\cs(50, 50, 50)' .. ResultsList[(PiecesPerResult*ResultLoop - 5)] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop) - 6]
			info_display = info_display .. ": Haven't checked yet as of " .. ResultsList[(PiecesPerResult*ResultLoop) - 1] .. '.' .. '\\cr \n'
			--gray text, for when we don't know enough to make confident statements.
			--should read something like "Jormungand in Uleguerand Range: Haven't checked yet as of 12:34:26."

		--if we get here, we have something in there that I didn't put in there myself by hand, so complain about it!
		else
			info_display = info_display .. ' \\cs(255, 255, 0)' .. ResultsList[(PiecesPerResult*ResultLoop) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop) - 6]
			info_display = info_display .. ": Improper mob status (" .. ResultsList[(PiecesPerResult*ResultLoop) - 1] ..") found at timestamp: " .. os.date("%X",os.time()) .. '.' .. '\\cr \n'
			--bright yellow is ugly so let's use it for errors so that it catches my eye, I guess

		end

	end

	if DebugVariable then
		notice('Debug: GUI update complete.')
	end

end


--this can also log the results out to a file, in case this crashes or something. never fails it'll crash at the worst time
function put_results_in_file()

	if WriteResultsToFile then --technically, this if statement is redundant, but I might call it from some other time at some other point, who knows
		if DebugVariable then
			notice('Debug: Writing most recent result to file:')
			notice('Debug: Checked ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 6] .. ' at ' .. os.date("%X",os.time())
			.. ' and found that it was ' .. NewMobStatus .. ' at ' .. NewPositionString .. ' at ' .. UpdateTime .. '.')
		end

		--write this string into the hardcoded output location, which is currently output.txt [in the same folder as this addon] - this will NOT create that file if it doesn't exist for Reasons I Do Not Comprehend(tm)
		files.append(FileOutputLocation,
		'Debug: Checked ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 5] .. ' in ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 6] .. ' at ' .. os.date("%X",os.time())
		.. ' and found that it was ' .. NewMobStatus .. ' at ' .. NewPositionString .. ' at ' .. UpdateTime .. '.'
		)
		--that string.char is a newline character, the windower documentation is not accurate about whether append natively adds a newline (the third parameter "flush" = true doesn't do it either)

		if DebugVariable then
			notice('Debug: Wrote result to file. Moving on.')
		end
	
	end

end

--below this point I'm confident these functions are fine and should never need to be changed (well, okay, the testing function lives down here too, you can change that)
--literally just waits for us to be in a different zone than we were before. possible that we want to bake in a second loop to wait for a SG/HP to load and have that be configurable, but meh
function wait_for_zone_change()
	ZoneThatWeAreInRightNow = windower.ffxi.get_info().zone
	
	while ZoneThatWeAreInRightNow == windower.ffxi.get_info().zone do
		coroutine.sleep(1) --sleep one second. no need to be faster.
	end
end

--this is versatile enough to support any mob, including our hunt targets, but I only use it for SG/HPs
function wait_for_mob_by_prefix(prefix)
	local mob_id = get_nearest_mob_by_prefix(prefix) --boy I hope this is how local variables work

	if not mob_id then
		windower.add_to_chat(2, 'Waiting for target to load...')
	end

	while mob_id == nil do
		coroutine.sleep(3) --sure, three seconds is fine
		mob_id = get_nearest_mob_by_prefix(prefix)
	end

	return mob_id
end

--handles the case where there's more than one of what we're looking for. in practice, I don't think any two HPs are within load... oh, Ru'Lude Gardens has two close to each other! existence justified.
function get_nearest_mob_by_prefix(prefix)

	local function starts_with(str, start)
		return str:sub(1, #start) == start
	end

	local ret = nil

	for index, mob in pairs(windower.ffxi.get_mob_array()) do
		if starts_with(mob.name, prefix) then
			if not ret or mob.distance < ret.distance then
				ret = mob
			end
		end
	end

	return ret and ret.id --someday I'll know how this works with the "and". doesn't a function only return one thing?
end

--DT again. not gonna reinvent the wheel, I know how to get a Euclidean distance
function get_distance(x, y)
	
	--please note, due to lack of some of DT's supporting functions, if you call this any time that you don't absolutely KNOW that the zone has loaded, me can be nil, and this will fail.
	local me = windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id) --is this *really* the most efficient way to do this?! really, DT? really, windower staff? is there no better way to get your own x-position?! I blame Stan.

	return math.sqrt(math.pow(me.x - x, 2) + math.pow(me.y - y, 2))
end

--hiding at the bottom (ctrl-end makes this one of the most accessible locations), the testing function that can be changed as needed
function testing_function()

	notice('Debug: Testing function has been called.')

	--check whether we are near a home point
	local nearest_home_point_id = get_nearest_mob_by_prefix('Home Point') --local variables still frighten me

	if nearest_home_point_id ~= nil
	then
		notice('here is the id? result: ' .. nearest_home_point_id)
	else
		notice('did not find a home point')
	end

	notice('is this a coordinate? ' .. windower.ffxi.get_mob_by_id(nearest_home_point_id).x)
	
	--this is the only part I DON'T comment out, so that I know it's working
	notice('Debug: Testing function complete.')
	
	--can you believe this is vanilla windower lmao
	--windower.play_sound(windower.addon_path .. 'sounds/UnknownBlueMagicUsed.wav')
	--I don't have a suitably funny sound clip but I sure could make one
	--or I could use CONQUERING THE WORM lmao	

end
--TODO: I MADE THE INITIAL STORAGE ARRAYS SMALLER BUT I DIDN'T ACTUALLY CHANGE ANY OF THE FUNCTIONS AT ALL SO I GOTTA FIX THAT
--TODO: ALSO THE POSTRENDERING DOESN'T NEED TO UPDATE EVERY FRAME, ZYN SHOWED THE POINTWATCH LOGIC THERE, MAKE A VARIABLE FOR LAST UPDATE TIME AND DO IT LIKE ONCE EVERY TEN SECONDS OR SOMETHING

_addon.name = 'Sandworm'; --not renaming this even though I'm broadening its scope as I type this
_addon.version = '0.5'; --20240620 changed to checking mob status directly rather than checking previous position and integrated some old DT code for funsies
_addon.author = 'DACK';
_addon.commands = { 'worm', 'sandworm' , 'sand'}; --DEAD I AM THE ONE

res = require('resources') --used to get zone names, to input superwarp commands based on the predefined English names in the results list
packets = require('packets') --"nice ffxi" "thanks! it has packets."
texts = require('texts') --used for gui
files = require('files') --used to log output to file
require('logger') --used to generate notices in the in-game chat. I prefer this to just using a naked windower.add_to_chat() but you can do that instead if you want
require('tables') --I'm gonna be honest with you. I don't know what this damn thing does. I'm pretty sure I use it somewhere?

--DEPENDENCIES:
--SCANZONE (see project tako's repo at https://github.com/ProjectTako/ffxi-addons/tree/master/scanzone/windower)
--SUPERWARP (see akaden's repo at https://github.com/AkadenTK/superwarp)
--MYHOME (this is in the default Windower launcher, but if you're curious that means you can find its code at https://github.com/Windower/Lua/tree/dev/addons/MyHome)
--DON'T START THIS IN, OR HAVE YOUR HOME POINT SET TO, ANYWHERE IN TAVNAZIAN SAFEHOLD. I'M VERY LAZY. SORRY, BUT ALSO NOT SORRY.

--set these variables to true for two levels of debug logging in the chat log. major is very spammy, minor is only "mostly" spammy.
DebugVariable = true
VerboseDebugVariable = false

--set this variable to true to also log all output to the file location defined by the second variable here - that's currently "output.txt" in the same folder as this addon (but you can give it an entire path if you want, allegedly)
WriteResultsToFile = false
FileOutputLocation = 'output.txt'

--the loop frequency, in MINUTES. this is not seconds. that means this whole thing will loop every "sixty times this number" seconds (or when the previous loop ends - this is a floor, not a ceiling.)
LoopFrequency = 10

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

NumberOfTargets = 16 --there's no easy way to just "count" a table in lua. manually total up how many mobs you have here
PiecesPerTarget = 3 --zone id,mob name, transport method
TargetsListLength = NumberOfTargets * PiecesPerTarget --magic numbers! yay!

--next, an array to store our results. for each mob there are six entries:
--a zone, then a mob in that zone (Ixion and Sandworm are each capable of spawning in Ronfaure/Batallia/Rolanberry so those zones get two lines each)
--then the time of the most recent check, the status from that most recent check, and the coordinates the mob was found at
--then the same mob's previous status, set of coordinates, and the time we obtained those (so two checks ago, aka [20 minutes])
--then the most important known status of the mob and the last time that status changed (the actually impotant output, where we store time of death known/is alive)
ResultsList = {'',''}
NumberOfResults = NumberOfTargets --there's no reason this HAS to be the same, but also it's illogical for it to ever not be
PiecesPerResult = 6 --zone, mob, last check time, last check status, last check coordinates, last alive -> dead time if known
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

	--intended output format: 'East Ronfaure [S]', 'Sandworm', time, 'Unchecked', '1, 1, 1', time
	--just to know whether they're in the right order. 
	if VerboseDebugVariable then
		notice('Startup array element: ' .. LoopCount .. ': ' .. ResultsList[AlreadyCompletedElements+1] .. ', ' .. ResultsList[AlreadyCompletedElements+2] .. ', ' .. ResultsList[AlreadyCompletedElements+3] .. ', '
		.. ResultsList[AlreadyCompletedElements+4] .. ', ' .. ResultsList[AlreadyCompletedElements+5] .. ', ' .. ResultsList[AlreadyCompletedElements+6] .. '.')
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
		notice("The only supported command is 'start'. And also 'test' if you know why you're using it. Sorry. -DACK")
	end

end)
	

--display the GUI
--dack note: this is "postrender", as in we do it immediately after every rendering tick. other relevant options are "load" (on addon load, so only once ever), "status change" which can work on zoning <-> idle, and "zone change".
windower.register_event('postrender', function()
    info:text(info_display)
    info:visible(true)
end)


--scanzone plugin's relevant messages, verbatim, are:
--[ScanZone]Found entity with name: ENTITY NAME. TargetIndex: 0xHEXADECIMAL
--[ScanZone]Position: (X, Y, Z)
--this function examines all incoming text to check whether it looks like that. if it does, formats and stores the information accordingly.
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

	--replace the startup text with the information on the targeted mobs
	--update_gui()

	--get to a survival guide
	startup_function()

	if DebugVariable then
		notice('Debug: Startup function complete. Beginning mob search loop.')
	end

	--loop forever
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
			GetToZone(PiecesPerTarget*(LoopVariable-1)+1) --for target N, skip the first N-1 targets, then look at the first thing in the array after that, which is the zone ID
			CheckZone(PiecesPerTarget*(LoopVariable-1)+1) --now that we're there, check that zone for whatever the target there is

		end

		if DebugVariable then
			notice('Debug: Search loop complete at ' .. os.date("%X",os.time()) .. '. Returning to Tavnazian Safehold.')
		end

		startup_function()

		if DebugVariable then
			notice('Waiting another ' .. math.ceilinglua ((60*LoopFrequency) - (os.clock() - LoopStartTime)) .. ' seconds to begin the next loop.') --does this even work? pretty sure it should...
		end

		--now wait until [10 minutes] have elapsed and do it again
		while os.clock() < LoopStartTime + (60*LoopFrequency) do
			coroutine.sleep(1)
		end
	
	end

end


--intended functionality: compare the previous position string to the new position string. if they are different, update the info in the array of positions. this should update the gui accordingly. maybe.
function update_target_information()

	if DebugVariable then
		notice('Debug: Started Update Target Information function.')
	end

	--variables we have arrived with:
	--currenttarget (which number mob we're looking at)
	--newpositionstring (coordinates that mob is currently located at, whether it's dead or alive)
	--updatetime (the time we got those coordinates, which is around a few seconds ago, but we can just pretend it's "right now" since it will be consistently off the same way every time)

	--if the position has changed since the last time we checked, the mob is (likely) currently alive. if it has not changed, the mob is (likely) currently dead.
	
	--the first (pieces per result) * (current target - 1) entries in the results table are the previous mobs we already looked at
	--then the Nth mob's entries are name, zone, "current" (old) status and position and time, "previous" (2 old at this point) status and position and time, relevant status change and time
	--therefore, to find the immediately previous position of the Nth mob, skip the first 10(N-1) entries which are the first N-1 mobs, then go to the 4th entry in the Nth mob's decuple, aka 10N-10+4 [= 10N-6 but screw that]
	--stored information format: 'East Ronfaure [S]', 'Sandworm', 'Unchecked', '1, 1, 1', time, 'Unchecked', '1, 1, 1', time, 'Unchecked', time
	PreviousPositionString = ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 4]
	PreviousTime = ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 5] --we store time immediately after position
	PreviousMobStatus = ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 3] --and status immediately before position

	if DebugVariable then
		notice('Debug: came in with currenttarget = ' .. CurrentTarget)
		notice('Debug: came in with newpositionstring = ' .. NewPositionString)
		notice('Debug: came in with updatetime = ' .. UpdateTime)
		notice('Debug: Zone: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 1])
		notice('Debug: Mob: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 2])
		notice('Debug: Last Status: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 3])
		notice('Debug: Last Coords: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 4])
		notice('Debug: Last Time: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 5])
		notice('Debug: Older Status: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 6])
		notice('Debug: Older Coords: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 7])
		notice('Debug: Older Time: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 8])
		notice('Debug: Relevant Status: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 9])
		notice('Debug: Relevant Status Time: ' .. ResultsList[(PiecesPerResult*(CurrentTarget-1)) + 10])
	end

	--if it was unchecked right before this, we have never looked at this mob before. we don't know if it's alive or dead yet, but we do know where it is now.
	if PreviousMobStatus == 'Unchecked' then 

		NewMobStatus = 'Unknown' --the new status is that we don't know what the status is, but at least we know that we don't know. very douglas adams of us. this replaces "unchecked" because that's not knowing at all.
		StatusUpdateTime = UpdateTime --and we WILL set the status update time to the value of updatetime, because now we definitively know that

	--if the new position string is different, the mob moved between then and now, meaning it was alive then and lived long enough to move. might not be alive now, but I don't have Tako integration so I can't do anything about it.
	elseif NewPositionString ~= PreviousPositionString then

		NewMobStatus = 'Alive'
		StatusUpdateTime = PreviousTime --we can't say whether it's still alive NOW, only whether it WAS alive between last check and this check. which it was, because it moved after that check but before this one.

	--if we know it was in the same place the last time we checked, it's dead as of last time, because it did not move between now and then (boy I hope all mobs move in [10 minutes], can't think of any I care about that don't.)
	--however, there are two cases here. most of the time, the case we don't care about: the mob was not just alive
	elseif (NewPositionString == PreviousPositionString) and (PreviousMobStatus ~= 'Alive') then
		
		NewMobStatus = 'Dead'
		StatusUpdateTime = PreviousTime --it hasn't moved since the last time we looked at it, which means that it was dead back then. it may have spawned since then and we just happened to hit it the instant it spawned, I guess...

	--THIS is the case we care most about. if the mob was alive, then it was dead, that means we have pinpointed when it died.
	elseif (NewPositionString == PreviousPositionString) and (PreviousMobStatus == 'Alive') then

		NewMobStatus = 'Approximate Time of Death Known: '
		StatusUpdateTime = PreviousTime --was alive at this time, became dead by the time we checked. ToD guaranteed to be within that window. therefore, arrive at the start of the window in case it died the instant we left the zone

	--if we hit this, quit out so I can debug, because cases two through four should logically encompass all information (because A or (not A and B) or (not A and not B)) = (A or not A) = everything)
	else
	
		print('Error: New and previous position string could not be compared. Warping to HP and stopping scanning behavior to force DACK to fix it later.')
		windower.send_command('mh')
		wait_for_zone_change()
		windower.send_command('lua u sandworm')

	end

	if DebugVariable then
		notice('Debug: Finished comparing old and new positions.')
	end

    --                            1                    2           3            4         5      6            7         8      9           10             
	--stored information format: 'East Ronfaure [S]', 'Sandworm', 'Unchecked', '1, 1, 1', time, 'Unchecked', '1, 1, 1', time, 'Unchecked', time
    --                           -9                   -8          -7           -6        -5     -4           -3         -2    -1          -0
								 
	--now update this mob in particular. first, the stuff that we do no matter what the mob's status is: coordinates and timestamps.
	--most recent position = the "new position string"
	ResultsList[(PiecesPerResult*CurrentTarget) - 6] = NewPositionString

	--older position = the "previous position string"
	ResultsList[(PiecesPerResult*CurrentTarget) - 3] = PreviousPositionString

	--most recent time = the "update time", aka "right now" ish
	ResultsList[(PiecesPerResult*CurrentTarget) - 5] = UpdateTime

	--older time = the "previous time"
	ResultsList[(PiecesPerResult*CurrentTarget) - 2] = PreviousTime

	if DebugVariable then
		notice('Debug: New position string: ' .. NewPositionString .. '.')
		notice('Debug: Previous position string: ' .. PreviousPositionString .. '.')
	end

	--now update the mob's status. whether or not to update the final two parameters, "relevant mob status and its time" is conditional.
	--most important: if was alive, is now dead, that's time of death! we want to know that most, no matter how many loops we do afterwards. (hidden assumption: not running for more than a day straight without looking...)
	if NewMobStatus ~= PreviousMobStatus then

		if DebugVariable then
			notice('Debug: Mob status has changed. Updating results list.')
			notice('Debug: It was ' .. PreviousMobStatus .. ' and it is now ' .. NewMobStatus .. '.')
		end

		--if we already know the ToD, even if it's from a while ago, we don't actually want to update the information, because there's nothing more important to store there.
		if ResultsList[(PiecesPerResult*CurrentTarget) - 1] == 'Approximate Time of Death Known: ' then
			
			ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus --still live-updating the status, just not updating the last two.
			ResultsList[(PiecesPerResult*CurrentTarget) - 4] = PreviousMobStatus --that way we don't overwrite the actually relevant ToD info that we're trying to find.
		
		--if we just got the ToD now, store it so we don't overwrite it later
		elseif NewMobStatus == 'Approximate Time of Death Known: ' then

			ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus
			ResultsList[(PiecesPerResult*CurrentTarget) - 4] = PreviousMobStatus

			ResultsList[(PiecesPerResult*CurrentTarget) - 1] = 'Approximate Time of Death Known: ' --now we know the ToD. store it here so we don't lose it.
			ResultsList[(PiecesPerResult*CurrentTarget)] = StatusUpdateTime

		--if we got the ToD last loop, I'm pretty sure we don't need this distinct logic, but I live in fear of missing things
		elseif PreviousMobStatus == 'Approximate Time of Death Known: ' then

			ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus
			ResultsList[(PiecesPerResult*CurrentTarget) - 4] = PreviousMobStatus

			ResultsList[(PiecesPerResult*CurrentTarget) - 1] = 'Approximate Time of Death Known: ' --now we know the ToD. store it here so we don't lose it.
			ResultsList[(PiecesPerResult*CurrentTarget)] = PreviousTime

		--if it was unknown (not unchecked), then we now know whether it's dead or alive. looking good!
		else

			ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus --still live-updating the info, just not updating the last two.
			ResultsList[(PiecesPerResult*CurrentTarget) - 4] = PreviousMobStatus --that way we don't overwrite the actually relevant ToD info.

			ResultsList[(PiecesPerResult*CurrentTarget) - 1] = NewMobStatus --anything other than "unchecked" is better than "unknown"
			ResultsList[(PiecesPerResult*CurrentTarget)] = StatusUpdateTime

	    end

	else

		if DebugVariable then
			notice('Debug: Mob status has not changed. Not updating relevant status variables.')
		end	

		--still update these two, but don't change the last two pieces of information
		ResultsList[(PiecesPerResult*CurrentTarget) - 7] = NewMobStatus
		ResultsList[(PiecesPerResult*CurrentTarget) - 4] = PreviousMobStatus

	end

	--once we get here, we don't have anything more to do for this mob. all done!

end


--regenerate the text information in the gui from scratch, because I honestly don't know a better way
function update_gui()

	--create the variable that will hold ALL the info we're displaying
	info_display = ' \\cs(150, 0, 200)' .. 'Notorious Monster Hunter \\cr \n'

	if DebugVariable then
		notice('Debug: Re-creating GUI.')
	end

	--update each line individually and concatenate into the same displayed variable repeatedly. each line ends with a Carriage Return and a Newline to move to the next line
	--the information we're accessing looks like: 'East Ronfaure [S]', 'Sandworm', 'new status', time, coordinates, 'old status', time, coordinates, 'important status', time
	--so take (pieces * target) and subtract:      9                    8           7            6     5             4            3     2             1                  0
	for ResultLoop = 1, NumberOfResults, 1 do
		
		if ResultsList[(PiecesPerResult*CurrentTarget) - 1] == 'Alive' then
			--all of these are broken into multiple lines of text for readability, but are one "new line" total, since it's all concatenated
			info_display = info_display .. ' \\cs(0, 175, 0)' .. ResultsList[(PiecesPerResult*ResultLoop - 8)] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop - 9)]
			info_display = info_display .. ' was: ' .. ResultsList[(PiecesPerResult*ResultLoop - 1)] .. ' as of ' .. ResultsList[(PiecesPerResult*ResultLoop)] .. '.' .. '\\cr \n'
			--this should be green text reading something like "Jormungand in Uleguerand Range was: Alive as of 12:34:56."s
			
		elseif ResultsList[(PiecesPerResult*CurrentTarget) - 1] == 'Dead' then
			info_display = info_display .. ' \\cs(175, 0, 0)' .. ResultsList[(PiecesPerResult*ResultLoop - 8)] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop - 9)]
			info_display = info_display .. ' was: ' .. ResultsList[(PiecesPerResult*ResultLoop - 1)] .. ' as of ' .. ResultsList[(PiecesPerResult*ResultLoop)] .. '.' .. '\\cr \n'
			--this should be green text reading something like "Jormungand in Uleguerand Range was: Alive as of 12:34:56."
			
		elseif ResultsList[(PiecesPerResult*CurrentTarget) - 1] == 'Approximate Time of Death Known: ' then
			info_display = info_display .. ' \\cs(0, 0, 175)' .. ResultsList[(PiecesPerResult*ResultLoop - 8)] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop - 9)]
			info_display = info_display .. ' approximate ToD was ' .. ResultsList[(PiecesPerResult*ResultLoop)] .. '.' .. '\\cr \n'
			--since alive and dead are green and red, known tod will be blue for consistency. should read something like "Jormungand in Uleguerand Range approximate ToD was: 12:34:26."
			--message is different since Sandworm could be in any of the zones. will never do: check values across all with same name cause any one tod means they're all dead, etc (already killed ixion while I tested this)
		
		elseif (ResultsList[(PiecesPerResult*CurrentTarget) - 1] == 'Unchecked') or (ResultsList[(PiecesPerResult*CurrentTarget) - 1] == 'Unknown') then --this is when we haven't seen the mob twice yet. not enough info for status.
			info_display = info_display .. ' \\cs(50, 50, 50)' .. ResultsList[(PiecesPerResult*ResultLoop - 8)] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop - 9)]
			info_display = info_display .. ': Not enough info as of ' .. ResultsList[(PiecesPerResult*ResultLoop)] .. '.' .. '\\cr \n'
			--gray text

		else
			info_display = info_display .. ' \\cs(255, 255, 0)' .. ResultsList[(PiecesPerResult*ResultLoop - 8)] .. ' in ' .. ResultsList[(PiecesPerResult*ResultLoop - 9)]
			info_display = info_display .. ": Improper mob status (" .. ResultsList[(PiecesPerResult*ResultLoop - 1)] ..") found at timestamp: " .. os.date("%X",os.time()) .. '.' .. '\\cr \n'
			--bright yellow is ugly so let's use it for errors so that it catches my eye

		end

	end

	if DebugVariable then
		notice('Debug: GUI update complete.')
	end

end


--also log the results out to a file! just in case my gui fucks up or my code is bad. you know how it is.
function put_results_in_file()

	if WriteResultsToFile then 
		if DebugVariable then
			notice('Debug: Writing most recent result to file:')
			notice('Debug: Checked ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 8] .. ' in ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 9] .. ' at ' .. os.date("%X",os.time())
			.. ' and found that it was ' .. NewMobStatus .. ' at ' .. NewPositionString .. ' at ' .. StatusUpdateTime .. '.')
		end

		--write this string into the hardcoded output location, which is currently output.txt [in the same folder as this addon] - this will NOT create that file if it doesn't exist for Reasons I Do Not Comprehend(tm)
		files.append(FileOutputLocation,
		'Debug: Checked ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 8] .. ' in ' .. ResultsList[(PiecesPerResult*CurrentTarget) - 9] .. ' at ' .. os.date("%X",os.time())
		.. ' and found that it was ' .. NewMobStatus .. ' at ' .. NewPositionString .. ' at ' .. StatusUpdateTime .. '.'
		)
		--that string.char is a newline character, the windower documentation is not accurate about whether append natively adds a newline (the third parameter "flush" = true doesn't do it either)

		if DebugVariable then
			notice('Debug: Wrote result to file. Moving on.')
		end
	
	end

end



--BELOW THIS POINT I AM CONFIDENT THIS CODE SHOULDN'T NEED TO BE TOUCHED RIGHT NOW, BECAUSE NO INDICES HAVE CHANGED AT ANY POINT--


--checks the listed zone for our current target
function CheckZone(TargetsListID)
	
	if DebugVariable then
		notice('Debug: Called CheckZone for ' .. res.zones[TargetsList[TargetsListID]].english .. '.')
		notice('Debug: Sending windower command: scanzone name ' .. TargetsList[TargetsListID+1])
	end

	--hope this also works
	windower.send_command('scanzone name ' .. TargetsList[TargetsListID+1])

	--wait for scanzone to come in so the chat reading can update the value of the target index variable.
	--if this sleep is too short, it'll break everything via an incomplete capture error (because the second scanzone message will come in and trigger the same event before the first instance of that event has finished)
    coroutine.sleep(5)

	if DebugVariable then
		notice('Debug: Sending windower command: scanzone scan ' .. TargetIndex)
	end

	--now scan the zone for the thing we're looking for
	windower.send_command('scanzone scan ' .. TargetIndex)

	--wait for scanzone to come in so the chat reading can update the value of the target position variable.
	--if this sleep is too short ... I thiiiink nothing breaks? but also it might just not update the variables properly and poop all over the results table. so don't risk it, honestly.
	coroutine.sleep(5)

	--this should now be properly set from those scanzone calls above
	NewPositionString = TargetPositionString
	
	if DebugVariable then
		notice('Debug: Current coordinates found were ' .. NewPositionString)
	end

	--save that info to the table
	update_target_information()

	--now save it to places I can see it
	update_gui()

	--and then after this second save, move on to the next mob
	put_results_in_file()

end


--navigate to Tavnazian Safehold HP #1. hardcoded because I am a lazy man.
function startup_function()

	if DebugVariable then
		notice('Debug: Started startup function.')
	end

	--check whether we are near a home point
	local nearest_home_point_id = get_nearest_mob_by_prefix('Home Point') --local variables still frighten me

	--if we find a home point within loading distance, it has an ID, so that variable is not nil
	if nearest_home_point_id ~= nil then
	
		--and it's close enough to just interact with it
		if get_mob_distance(nearest_home_point_id.x, nearest_home_point_id.x.y) < 6 then --roughly interact distance. relevant number: tavnazian safehold HP is 5.8 yalms from where you arrive when using the Survival Guide to get there
	    
			--then we do not have to warp
			if DebugVariable then
				notice('Debug: Started within interact distance of a Home Point. No Warp needed.')
			end

		else 

			if DebugVariable then
				notice("Debug: Started within 52 yalms of a Home Point, but far enough away that we can't interact with it. Warping to be sure we're at a Home Point we CAN interact with.")
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
	windower.send_command('sw hp Tavnazian Safehold 1') --beats typing 'sw hp taf sav' which is my usual
	wait_for_zone_change()

	if DebugVariable then
		notice('Debug: Should be loading into Tavnazian Safehold. Waiting to find the Survival Guide.')
	end

	wait_for_mob_by_prefix('Survival Guide') --wait for SG to load so that zone's loaded. false because survival guides are ALSO not attackable.

	if DebugVariable then
		notice('Debug: Ended startup function. We should be in Tavnazian Safehold.')
	end

end


--handles movement between zones. currently supports Home Points and Survival Guides.
--possibly relevant future types of teleportation: unity warps (arrive on same submap as khimaira), voidwatch? (can't imagine why), unity? (also can't imagine why)
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
				notice('Debug: Sending windower travel command: ' .. WarpCommand)
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
				notice('Debug: Sending windower travel command: ' .. WarpCommand)
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

			print('error: Invalid teleportation type among either ' .. WaitingFor .. ' or ' .. PreviousArrivalPoint .. ' specified. Fix it to "Home Point" or "Survival Guide", please. Unloading.')
			windower.send_command('lua u sandworm')
		
		end
		

	--otherwise, we're already here from the previous mob, so do nothing.
	else
	
		if DebugVariable then
			notice('Debug: Already here from the previous mob. Not moving.')
		end

	end


end


--just testing, don't mind me!
function testing_function()


	--check whether we are near a home point
	local mog_id = get_nearest_mob_by_prefix('Green') --local variables still frighten me


	if DebugVariable then
		notice('Debug: hey real quick: ' .. mog_id.x)
	end


	--notice('Debug: Testing function has been called.')

	--notice('Debug: Sending windower command: scanzone name Sandworm')
	--windower.send_command('scanzone name Sandworm')
	--coroutine.sleep(4)

	--notice('Debug: Sending windower command: scanzone scan ' .. TargetIndex)
	--windower.send_command('scanzone scan ' .. TargetIndex)
	--coroutine.sleep(4)

	----at this point we have forcibly loaded the target into the mob array, which means we can just poke it directly repeatedly
	--SandwormID = get_nearest_mob_by_prefix('Sandworm') --please note that without the scanzones, we will find nothing - Sandworm is far away and we won't even see if it it's not loaded if we don't force that entity packet
	--
	--notice('status? id: ' .. windower.ffxi.get_mob_by_id(SandwormID).status) --this returns 0
	--coroutine.sleep(1)
	--notice('hpp? id: ' .. windower.ffxi.get_mob_by_id(SandwormID).hpp)
	--coroutine.sleep(1)
	--notice('is this status? name: ' .. windower.ffxi.get_mob_by_name('Sandworm').status) --as does this... but 2 is dead. 0 is idle. maybe let's try a zone with nonzero coords.
	--coroutine.sleep(1)
	--notice('is this hpp? name: ' .. windower.ffxi.get_mob_by_name('Sandworm').hpp) --looks like either of these'll work just fine

	notice('Debug: Testing function complete.')
	
	--can you believe this is vanilla windower lmao
	--windower.play_sound(windower.addon_path .. 'sounds/UnknownBlueMagicUsed.wav')
	--I don't have a suitably funny sound clip but I sure could make one
	--or I could use CONQUERING THE WORM lmao	

end

--status 0 is "idle", for sure it's used when the target hasn't spawned since maintenance - this gives coords 0 0 0 too, which is awkward
--status 3 is "died engaged" - that's when someone killed it and it died while in combat
--status 2 is "dead", no clue what happens when a sandworm despawns but I wonder if that's relevant here. anyway we can 
--1 is engaged but alive, god I hope that never happens

--below this point is old stuff from DT, repurposed for this
--literally just waits for us to be in a different zone than we were before. possible that we want to bake in a second loop to wait for a SG/HP to load and have that be configurable, but meh
function wait_for_zone_change()
	ZoneThatWeAreInRightNow = windower.ffxi.get_info().zone
	
	while ZoneThatWeAreInRightNow == windower.ffxi.get_info().zone do
		coroutine.sleep(1) --sleep one second. no need to be faster.
	end
end

--this is versatile enough to support any mob, including our hunt targets, but I only use it for SG/HPs
function wait_for_mob_by_prefix(prefix)
	local mob_id = get_nearest_mob_by_prefix(prefix, attackable_only) --boy I hope this is how local variables work

	if not mob_id then
		windower.add_to_chat(2, 'Waiting for target to load...')
	end

	while mob_id == nil do
		coroutine.sleep(3) --sure, three seconds is fine
		mob_id = get_nearest_mob_by_prefix(prefix, attackable_only)
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

	return ret --and ret.id --I don't want the id of that thing, I want its full array so we can steal its coordinates
end

--DT again. not gonna reinvent the wheel, I know how to get a Euclidean distance, this code is bulletproof with one little exception
function get_distance(x, y)
	local me = windower.ffxi.get_player().id --please note, if you call this any time that you do NOT know that the zone has loaded, me may be nil, and this will fail. this is the one exception. I do not want to fix that here.
	
	return math.sqrt(math.pow(me.x - x, 2) + math.pow(me.y - y, 2))
end

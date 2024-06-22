_addon.name = 'pirates'
_addon.author = 'Suteru and me' --I took Suteru's work in zone ID and changed it from a gui to something a little more... manual
_addon.version = '0.2' --v0.2: turned this from a simple checker into an automated ferry reboarder, because I absolutely. hate. paying. attention.
_addon.language = 'English' --this exists?!
_addon.commands = {'pirates', 'pirate', 'boat'}; --rather than automatically on zone change, I made this manual.

require('logger') --used to generate notices in the in-game chat. I prefer this to just using a naked windower.add_to_chat() but you can do that instead if you want.

--DEPENDENCIES:
--FISHER, available at https://gitlab.com/svanheulen/fisher
--OPENSESAME, available at https://github.com/z16/Addons/blob/master/OpenSesame/ --I am never going to write a door opening packet function in my life, sorry)
--make sure you start this bot from inside the ferry lobby having paid for a ticket (no idea if you can tako your way in without paying, don't risk it)

--LIMITATIONS:
--this thing is hardcoded to fish on the selbina/mhaura ferry when there are, or are not, pirates. or possibly both if I fix that.
--currently only fishes in one of those two cases, since I assume you are only after a fish that only shows up in one of those two cases. if you are after ryugu titans for some godforsaken reason, I cannot help you, pal.
--...okay, probably gonna fix that.
--doesn't buy bait for you or repair a broken rod or really do any error checking.

--zone 248 selbina
--zone 249 mhaura
--windower.ffxi.get_info().time returns vana'diel time (there's also day and moon and weather but we care about 0 of those)

windower.register_event('addon command', function (...)
	args = T{...} --parse arguments input
	command = args[1] --valid inputs: "start", "check", and if you put anything else in you get the help
    PiratesOrNot = args[2] --valid inputs: yes/no/both/pirates (which is just an alias for "yes").
    FishToCatch = args[3] --valid inputs: any fish's name, any capitalization, IN QUOTES if it's more than one word (the best use case for this bot is 'Sea Zombie')
    BaitToUse = args[4] --valid inputs, any baits' name, any capitalization, IN QUOTES if it's one than one word (most baits are, but Meatball isn't for instance)

    --it catches the fish for you, can you believe it?
	if command == 'start' then
		
        windower.send_command('lua r fisher') --make sure that fisher is loaded and has nothing configured to catch simultaneously. look how clever I am.
        coroutine.sleep(0.2)
        windower.send_command('lua r opensesame') --let's not get stuck on a door, please
        coroutine.sleep(0.2)
       
        if FishToCatch ~= nil then
            windower.send_command('fisher add ' .. FishToCatch) --boy do I hope args in quotes work properly. I should reference tradenpc to confirm that.
            coroutine.sleep(0.2)
        end

        if BaitToUse ~= nil then
            windower.send_command('fisher add ' .. BaitToUse)
            coroutine.sleep(0.2)
        end

        --neverending loop, to handle zone change
		while true do
		    main()
	    end
	
    --just check manually
    elseif command == 'check' then
        
        zone = windower.ffxi.get_info().zone
        
        if zone == 220 or zone == 221 then
            notice('On a non-pirate boat. (Zone ID = ' .. zone .. '.)')
        elseif zone == 227 or zone == 228 then
            notice('On a pirate boat! (Zone ID = ' .. zone .. '.)')
        elseif zone == 248 or zone == 249 then
            notice('In town. (Zone ID = ' .. zone .. '.)')
        else
            notice("Wherever you are, it's not the Selbina-Mhaura-Ferry zones.") --well, I guess if you somehow didn't know this then I can be helpful.
        end
    
    elseif command == 'test' then

        testing_function()

    else
 
        notice("To start automatically fishing, input: " .. "'pirate start [YES/NO] " .. '"FISH NAME" "BAIT NAME"' .. "'")
        notice("Also, 'pirate check' will tell you whether your current boat has pirates.")

    end
end)


--this loop is the entire automated functionality
function main()

    --first, find out what zone we're in
	local zone = windower.ffxi.get_info().zone
  
  -- Just do one step at a time so that we can resume at any point.
	if zone == 248 then  -- Selbina

        --when the boat arrives, the player is in a cutscene. don't try to move until that's over and the player is in Idle status.
        while windower.ffxi.get_player().status ~= 0 do
            coroutine.sleep(1)
        end

        wait_for_mob_by_prefix('Humilitie') --Boat arrival time NPC

        run_to_pos(18.5, -42.5) --why does selbina dump you so far away from the boat when you get off?!
        run_to_pos(18, -58) --run to the point where the ferry will be when it's here
		
        --wait for the ferry (as determined by clock time)
        while wait_for_the_ferry() == false do
            notice("The current Vana'diel time is " .. CurrentHour .. ':' .. CurrentMinutes .. '. Waiting for the next ferry to arrive.')
            coroutine.sleep(10) --this is kind of overkill but it's fine you have plenty of time to get on the boat it's like 3 irl minutes
        end

        run_to_pos(18, -70) --then run onto the ferry
        run_to_pos(10, -70) --and into the room because that's how we used to do it in 2005, though I think the hallway is just fine
        
        wait_for_zone_change() --wait for the ferry to depart. no need to track in-game time for this.

    elseif zone == 249 then  --Mhaura
        
        --wait out the arrival cutscene
        while windower.ffxi.get_player().status ~= 0 do
            coroutine.sleep(1)
        end
        
        wait_for_mob_by_prefix('Dieh Yamilsiah') --Boat arrival time NPC

        run_to_pos(8.5, 18) --you spawn in at like 10, 17 - autorunning into the wall would work but it looks stupid, so let's not
        run_to_pos(8.5, -3.5) --run to the point where the ferry will be when it's here

        --wait for the ferry (as determined by clock time)
        while wait_for_the_ferry() == false do
            notice("The current Vana'diel time is " .. CurrentHour .. ':' .. CurrentMinutes .. '. Waiting for the next ferry to arrive.')
            coroutine.sleep(10) --this is kind of overkill but it's fine you have plenty of time to get on the boat it's like 3 irl minutes
        end

        run_to_pos(8.5, -9) --run onto the ferry
        run_to_pos(0, -8.5) --and into the room

        wait_for_zone_change() --wait for the ferry to depart. no need to track in-game time for this.

    elseif S{220,221}:contains(zone) then  --non-pirate boats. also, I am not a big fan of this notation. why is it not "zone in {220, 221}" or something
        
        --TODO: THIS WORKS ON 221, TEST ON 220.

        --wait for the zone to load
        wait_for_mob_by_prefix('Door')

        --only fish on no-pirate boats if we told ourselves that we wanted to fish on no-pirate boats
        if S{'no','both'}:contains(string.lower(PiratesOrNot)) then
            run_to_pos(2, 7) --navigate the room with the pillars
            run_to_pos(2, 0) 
            run_to_pos(6, -2.9) --arrive in front of the door
            coroutine.sleep(0.5)
            
            --since we have opensesame, don't do this:
            --targetnpc Door
            --interact via sending an enter command
            
            run_to_pos(6, -8.5) --get through the door
            run_to_pos(6.7, -15.75) --run over to the stairs
            run_to_pos(5.5, -16.8) --be sure we're ready to climb the stairs
            run_to_pos(0, -16.5) --arrive at the first landing
            run_to_pos(0, -3) --arrive at the second door
            coroutine.sleep(0.5)
            
            --and since we have opensesame, also don't do this:
            --targetnpc "Cargo Ship Door"
            --interact the same way
            
            run_to_pos(0, 12) --now we're on the deck
            run_to_pos(-9, 12) --and now we can theoretically fish, i.e. we're pointed outwards
            
            windower.send_command('fisher start') --deliberately with no number on it. you can fix that if you want.

        else
            notice('This is a non-pirate boat, but we only want to fish on pirate boats. Waiting for the next boat.')
        end

        wait_for_zone_change() --wait for the boat to arrive, whether or not we started fishing

    elseif S{227,228}:contains(zone) then  --pirate boats.

        --TODO: TESTED 227, NOT 228
        --TODO: WHY DID THIS CRASH

        wait_for_mob_by_prefix('Door') --wait for zone load

        --this is what we're all here for, really. but still, if you want to fish on non-pirate boats, don't fish here.
        if S{'yes','both','pirates'}:contains(string.lower(PiratesOrNot)) then
            run_to_pos(2, 7) --navigate the room with the pillars
            run_to_pos(2, 0) 
            run_to_pos(6, -2.9) --arrive in front of the door
            coroutine.sleep(0.5)
            
            --since we have opensesame, don't do this:
            --targetnpc Door
            --interact via sending an enter command
            
            run_to_pos(6, -8.5) --get through the door
            run_to_pos(6.7, -15.75) --run over to the stairs
            run_to_pos(5.5, -16.8) --be sure we're ready to climb the stairs
            run_to_pos(0, -16.5) --arrive at the first landing
            run_to_pos(0, -3) --arrive at the second door
            coroutine.sleep(0.5)
            
            --and since we have opensesame, also don't do this:
            --targetnpc "Cargo Ship Door"
            --interact the same way
            
            run_to_pos(0, 12) --now we're on the deck
            run_to_pos(-9, 12) --and now we can theoretically fish, i.e. we're pointed outwards
            
            windower.send_command('fisher start') --deliberately with no number on it. you can fix that if you want.

        else
            notice('This is a pirate boat, but we only want to fish on non-pirate boats. Waiting for the next boat.')

        end

        wait_for_zone_change() --wait until the boat arrives either way

	else

		notice('Found ourselves in a zone with unknown ID: ' .. zone)
        notice('Unloading for now.')
        windower.send_command('lua u pirates')
	end
end

--the native windower function windower.ffxi.get_info().time returns the time in the format "number of minutes past 00:00 in the current vana'diel day". humans do not track time in base 10, so I'm writing this.
--returns true if the ferry is here and false if the ferry is not here.
function wait_for_the_ferry()

    CurrentTime = windower.ffxi.get_info().time

    CurrentHour = math.floor(CurrentTime / 60)
    CurrentMinutes = CurrentTime % 60

    --there are three ferries. they arrive at 06:30, 14:30, and 22:30 and depart an hour and a half after that at 8:00, 16:00, and 0:00
    if
        ((CurrentHour == 14 and CurrentMinutes > 30)
        or (CurrentHour == 15)
        or (CurrentHour == 22 and CurrentMinutes > 30)
        or (CurrentHour == 23)
        or (CurrentHour == 6 and CurrentMinutes > 30)
        or (CurrentHour == 7))
    then
        return true
    
    else
        return false
    
    end

end


--below this point is things that really belong in a single file in windower\addons\libs that I am often copypasting because there's no sense reinventing the wheel
function run_to_pos(x, y)
	
	local threshold = 0.2 --this is "how close to the destination do we need to be to call it acceptable" - this may cause some trouble with how we're fishing, i.e. want to be facing over the boat edge, but I'll figure it out.
	local dist = get_distance(x, y)

	-- Make sure the concept of distance is valid (i.e. we exist in space and time, can find ourselves, so the zone isn't loading)
	if not dist then
		return false
	end

	-- if we're already at the destination, don't bother moving to it
	if dist <= threshold then
		return true
	end

    --very confused why there's a while dist here, once you've started moving you should never fail a get_distance... right?
    while dist and dist > threshold do
		
        --"run in a direction for one twentieth of a second"
		windower.ffxi.run(get_radians(x, y))
		coroutine.sleep(0.05)
		
		dist = get_distance(x, y)
	end

	windower.ffxi.run(false) --lmao the movement is literally just in windower huh

	return true
end

--DT again. not gonna reinvent the wheel, I know how to get a Euclidean distance
function get_distance(x, y)
	
	--if you call this any time that you don't absolutely KNOW that the zone has loaded, me can be nil, and this will fail. that's fine. we aren't moving in an unloaded zone.
	local me = windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id) --still lolling at this.

	return math.sqrt(math.pow(me.x - x, 2) + math.pow(me.y - y, 2))
end

--DT again. thank god, because trigonometry has never been my strong suit.
--"it's been a long time since I had to take the cosine of anything" -Scott Adams, long before he became a chud. I miss Dilbert being not-garbage. not that it was ever as good as my mind remembers it being.
--seriously though, this function tells you the angle you want to be running at to get where you want to go.
function get_radians(x, y)
	local me = windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id)
	if not me then return 0 end

	local x_diff = me.x - x
	local y_diff = me.y - y
	return math.atan2(x_diff, y_diff) + math.pi / 2
end

--always good to make sure a zone's loaded
function wait_for_mob_by_prefix(prefix)
	local mob_id = get_nearest_mob_by_prefix(prefix)

	if not mob_id then
		windower.add_to_chat(2, 'Waiting for target to load...')
	end

	while mob_id == nil do
		coroutine.sleep(3) --sure, three seconds is fine
		mob_id = get_nearest_mob_by_prefix(prefix)
	end

	return mob_id
end

--there's more than one Door on the ferry so resolving this ambiguity actually matters
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

--this one literally just waits. like that's its entire functionality.
function wait_for_zone_change()
	ZoneThatWeAreInRightNow = windower.ffxi.get_info().zone
	
	while ZoneThatWeAreInRightNow == windower.ffxi.get_info().zone do
		coroutine.sleep(1) --sleep one second. no need to be faster.
	end
end



--at the bottom for easy editing
function testing_function()

    CurrentTime = windower.ffxi.get_info().time

    CurrentHour = math.floor(CurrentTime / 60)
    CurrentMinutes = CurrentTime % 60

    notice("The current Vana'diel time is " .. CurrentHour .. ':' .. CurrentMinutes .. '.')

end
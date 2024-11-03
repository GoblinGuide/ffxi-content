_addon.name = 'pirates'
_addon.author = 'Suteru and me' --I took Suteru's work in their yarr.lua - located at https://github.com/KazyEXE/yarr - and changed it from a gui to something a little more... fully-fledged
_addon.version = '0.3' --v0.3: opensesame breaks fishing. oops. fixed.
_addon.language = 'English' --this exists?!
_addon.commands = {'pirates', 'pirate', 'boat'}; --rather than automatically on zone change, I made this manual.

require('logger') --used to generate notices in the in-game chat. I prefer this to just using a naked windower.add_to_chat() but you can do that instead if you want.
res = require('resources') --used to get zone name from zone ID, which I literally only use in an error message, but it was free :)

--DEPENDENCIES:
--FISHER, available at https://gitlab.com/svanheulen/fisher
--OPENSESAME, available at https://github.com/z16/Addons/blob/master/OpenSesame/ --I am never going to write a door opening packet function in my life, sorry)
--make sure you start this bot from inside the ferry lobby in either Selbina or Mhaura having paid for a ticket (no idea if you can tako your way in without paying, don't risk it)

--LIMITATIONS:
--this thing is hardcoded to fish only on the Selbina/Mhaura ferry.
--doesn't buy bait for you (relevant: Meatballs, mostly, though the big boys can break lines with Sinking Minnows)
--doesn't repair a broken rod (get an Ebisu)
--doesn't fight mobs for Ice Spikes (lmao) or fight mobs you fish up (configure Fisher better!)
--doesn't have any error checking (this one I actually feel bad about)

windower.register_event('addon command', function (...)
	args = T{...} --parse arguments input
	command = args[1] --valid inputs: "start", "check", and if you put anything else in you get the help
    PiratesOrNot = args[2] --valid inputs: yes/no/both/pirates (which is just an alias for "yes").
    FishToCatch = args[3] --valid inputs: any fish's name, any capitalization, IN QUOTES if it's more than one word (the best use case for this is 'Sea Zombie')
    BaitToUse = args[4] --valid inputs, any baits' name, any capitalization, IN QUOTES if it's one than one word (most baits are, but Meatball isn't, for example)

    --it catches the fish for you, can you believe it?
	if command == 'start' then
		
        windower.send_command('lua r fisher') --make sure that fisher is loaded and has nothing configured to catch simultaneously. look how clever I am.
        coroutine.sleep(0.2)
       
        --if the fish to catch is not input, we will have no fisher settings, and catch nothing... unless your fisher default is nonempty. mine is empty but hey, you do you.
        if FishToCatch ~= nil then
            windower.send_command('fisher add ' .. FishToCatch) --boy do I hope args in quotes work properly. I should reference tradenpc to confirm that.
            coroutine.sleep(0.2)
        end

        --if the bait to use is not input, we will have no fisher settings, and catch nothing... except, same note as above about default fisher settings.
        if BaitToUse ~= nil then
            windower.send_command('fisher add ' .. BaitToUse)
            coroutine.sleep(0.2)
        end

        --neverending loop, to handle zone change
		while true do
		    main()
	    end
	
    --perform a single manual zone check
    elseif command == 'check' then
        
        zone = windower.ffxi.get_info().zone
        
        if zone == 220 or zone == 221 then
        
            notice('On a non-pirate boat. (Zone ID = ' .. zone .. '.)')
        
        elseif zone == 227 or zone == 228 then
        
            notice('On a pirate boat! (Zone ID = ' .. zone .. '.)')
        
        elseif zone == 248 or zone == 249 then
        
            notice('In town. (Zone ID = ' .. zone .. '.)')
        
        else
        
            notice("You're not somewhere where Pirates works. Supported zones are Selbina/Mhaura/the ferry between them, but not " .. res.zones[windower.ffxi.get_info().zone].english .. ".")
        
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
        run_to_pos(10, -70) --and into the room because that's how we used to do it in 2005, though I think the hallway is just fine to be "on the boat" when it leaves
        
        --reload opensesame before we get on the ferry (because it's unloaded because it breaks fishing.)
        windower.send_command('lua r opensesame')
        coroutine.sleep(1)

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

        --reload opensesame before we get on the ferry (because it's unloaded because it breaks fishing.)
        windower.send_command('lua r opensesame')
        coroutine.sleep(1)

        wait_for_zone_change() --wait for the ferry to depart. no need to track in-game time for this.

    elseif S{220,221}:contains(zone) then  --non-pirate boats. also, I am not a big fan of this notation. why is it not "zone in {220, 221}" or something
        
        --TODO: TEST ON 220. (this works on 221) (this has probably worked on 220 when I wasn't looking, it hasn't broken by now)

        --wait for the zone to load
        wait_for_mob_by_prefix('Door')

        --only fish on no-pirate boats if we specified that we wanted to do so
        if S{'no','both'}:contains(string.lower(PiratesOrNot)) then

            notice('This is a non-pirate boat, and we want to fish on non-pirate boats. Beginning fishing process.')

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

            --opensesame breaks fisher because the door packet is an action.
            windower.send_command('lua u opensesame')
            coroutine.sleep(1)

            windower.send_command('fisher start') --deliberately with no number on it. you can fix that if you want.

        else

            notice('This is a non-pirate boat, but we only want to fish on pirate boats. Waiting for the next boat.')
        end

        wait_for_zone_change() --wait for the boat to arrive, whether or not we started fishing

    elseif S{227,228}:contains(zone) then  --pirate boats.

        --TODO: TEST ON 228 (this works on 227) (probably has worked on 228 by now for me)

        wait_for_mob_by_prefix('Door') --wait for zone load

        --only fish on pirate boats if we want to fish on pirate boats
        if S{'yes','both','pirates'}:contains(string.lower(PiratesOrNot)) then

            notice('This is a pirate boat, and we want to fish on pirate boats. Beginning fishing process.')

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
            
            --well, now that I know I have to unload this here it's no big deal, lmao
            windower.send_command('lua u opensesame')
            coroutine.sleep(1)

            windower.send_command('fisher start') --deliberately with no number on it. you can fix that if you want.

        else

            notice('This is a pirate boat, but we only want to fish on non-pirate boats. Waiting for the next boat.')

        end

        wait_for_zone_change() --wait until the boat arrives either way

	else

		notice('Found ourselves in a zone with unsupported ID ' .. zone .. ', a.k.a. ' .. res.zones[windower.ffxi.get_info().zone].english '.')
        notice('Unloading Pirates for now. Please reload it when you are in Selbina or Mhaura, or on a ferry between the two')
        windower.send_command('lua u pirates')

	end
end

--the native windower function windower.ffxi.get_info().time returns the time in the format "number of minutes past 00:00 in the current vana'diel day". humans do not track time in base 10, so I'm writing this.
--returns true if the ferry is here and false if the ferry is not here. ferry times are hardcoded because they have not changed in 20 irl years.
function wait_for_the_ferry()

    CurrentTime = windower.ffxi.get_info().time

    CurrentHour = math.floor(CurrentTime / 60) --for human readability
    CurrentMinutes = (CurrentTime % 60) --same

    --there are three ferries. they arrive at 06:30, 14:30, and 22:30 and depart an hour and a half after that at 8:00, 16:00, and 0:00
    if
        ((CurrentHour == 14 and CurrentMinutes > 35) --ferry "arrives" at :30 but you run forward like an idiot if you go right away
        or (CurrentHour == 15) --this one can fail by being loaded at like 15:59 and running into the wall like a moron until the next ferry, so don't do that
        or (CurrentHour == 22 and CurrentMinutes > 35) --see note two lines above
        or (CurrentHour == 23) --seriously, I don't know what'll happen if you do, you'll run onto the next ferry and then... yeah you should be ok
        or (CurrentHour == 6 and CurrentMinutes > 35) --see note four lines above
        or (CurrentHour == 7)) --but, having not tested it, I can't recommend it

        --todo: there's a more elegant way to do this if you take the time modulo 8 hours, or something. I'm not entirely certain what the most elegant way would be, so I opted to totally disregard elegance altogether :)
    then
        return true
    
    else
        return false
    
    end

end

--below this point is things that really belong in a single file in windower\addons\libs that I am often copypasting because there's no sense reinventing the wheel.
--DT wrote a bunch of this originally but I've modified it over the years
function run_to_pos(x, y)
	
	local threshold = 0.2 --"how close to the destination do we need to be to call it acceptable"
	local dist = get_distance(x, y)

	--Make sure the concept of distance is valid (i.e. we exist in space and time, and can find ourselves, which in practice means that the zone is done loading)
	if not dist then
		return false
	end

	--if we're already at the destination, don't bother moving to it
	if dist <= threshold then
		return true
	end

    --very confused why there's a while dist here, once you've started moving you should never fail a get_distance... right? I can't think of any situation where that's not the case, but why risk it?
    while dist and dist > threshold do
		
        --"run in the right direction for one twentieth of a second"
		windower.ffxi.run(get_radians(x, y))
		coroutine.sleep(0.05)
		
        --see if we're there yet
		dist = get_distance(x, y)
	end

	windower.ffxi.run(false) --wow, autorun is just a windower supported function, eh?

	return true
end

--not gonna reinvent the wheel, I know how to get a Euclidean distance
function get_distance(x, y)
	
	--if you call this any time that you don't absolutely KNOW that the zone has loaded, me can be nil, and this will fail. that's fine. we aren't moving in an unloaded zone because we check for that in run_to_pos.
	local me = windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id) --still lolling at this.

	return math.sqrt(math.pow(me.x - x, 2) + math.pow(me.y - y, 2))
end

--DT again. thank god, because trigonometry has never been my strong suit.
--seriously though, this function tells you the angle you want to be running at to get where you want to go.
function get_radians(x, y)
	local me = windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id)
	if not me then return 0 end

	local x_diff = me.x - x
	local y_diff = me.y - y
	return math.atan2(x_diff, y_diff) + math.pi / 2
end

--always good to make sure a zone's loaded. this is by prefix, not by name, so it takes partial names from the beginning. not used here, but could be relevant.
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

--there's more than one Door on the ferry so resolving this ambiguity actually matters. this also would come up if there were lots of nearly-or-identically named NPCs.
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

	return ret and ret.id --someday I'll know how this works with the "and". doesn't a function only return one thing? or does it mean I can reference .id of this function or what?
end

--this one literally just waits. like that's its entire functionality.
function wait_for_zone_change()
	ZoneThatWeAreInRightNow = windower.ffxi.get_info().zone
	
	while ZoneThatWeAreInRightNow == windower.ffxi.get_info().zone do
		coroutine.sleep(1) --sleep one second. no need to check more often than that, this is not time-sensitive content.
	end
end

--testing function is down here, but everything else's done

--at the bottom for easy editing
function testing_function()

    CurrentTime = windower.ffxi.get_info().time

    CurrentHour = math.floor(CurrentTime / 60)
    CurrentMinutes = CurrentTime % 60

    notice("The current Vana'diel time is " .. CurrentHour .. ':' .. CurrentMinutes .. '.')

end
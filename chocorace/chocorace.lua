_addon.name = 'ChocoRace'
_addon.author = 'Manque, modified by DACK'
_addon.version = '1.2.1' --handle first race of the day without the player having to think
_addon.language = 'English'
_addon.commands = {'chocorace', 'race', 'cr'}

require('logger')

notice('Welcome to ChocoRace! Set racing NPC name and item to use (if any) in the lua file. Requires the Enternity plugin. Happy racing.')
running = false
races_run_this_session = 0 --on load, set to 0 because you have not done any racing so far today (assumption!)
is_first_npc_interaction = true --first one is slooooooow

--settings, change as desired
use_items = false
item_name = 'Speed Apple'
race_npc_name = 'Rungaga'
display_debug_text = false
total_number_of_races_to_run = 16 --5,000 gil
--the 12th race costs 3,000 gil. after that it increases by 500 per up to 10k and then it goes higher faster until cap at 100k.

--called by the addon command
function loop()

	windower.add_to_chat(200, 'Chocorace: Daily racing loop started.')

	while races_run_this_session < total_number_of_races_to_run do

		windower.add_to_chat(200, 'Beginning race number ' .. (races_run_this_session + 1) .. '.')

		--20260507 only trade items when using item
		if use_items then
			windower.add_to_chat(200, 'Trading an item to the race NPC.')
			itemcycle()
			coroutine.sleep(2)
		end
		
		single_race_cycle()

		--once the race is run, increment the "races run" counter
		races_run_this_session = races_run_this_session + 1
		
	end

	--20260528 change color to see at a glance
	windower.add_to_chat(216, 'Chocorace: Daily racing quota of ' .. total_number_of_races_to_run .. " hit. Unloading addon. Have a nice day!")
	windower.send_command('lua u chocorace')

end


function single_race_cycle()
	
	windower.add_to_chat(200, 'Finding Race NPC to start racing.')
	find_racing_npc()
	coroutine.sleep(2)
	race()
	windower.add_to_chat(200, 'Race complete.')

end

--finds race npc and trades them the item, but does NOT enter interaction
function itemcycle()
	
	windower.add_to_chat(200, 'Finding Race NPC to trade item.')
	find_racing_npc()
	coroutine.sleep(1)
	item()
	coroutine.sleep(1)
	running = false
	windower.add_to_chat(200, 'Item trade complete!')
	
end

--tab through targets manually looking for race npc
function find_racing_npc()
	
	--tab to the next target
	windower.send_command('setkey TAB down')
    coroutine.sleep(0.5)
    windower.send_command('setkey TAB up')
    coroutine.sleep(0.5)
	
	--if player currently has no target at all, run this again
	if windower.ffxi.get_mob_by_target( 't' ) == nil then
        
		windower.add_to_chat(200, 'Finding Race NPC.')
		coroutine.sleep(0.5)
		find_racing_npc()
	
	--if the target is the race npc, we're good, stop running this
	elseif windower.ffxi.get_mob_by_target('t').name == race_npc_name then --20260507 parameterize
		
		windower.add_to_chat(200, 'Found Race NPC.')

	--if it's someone else, run this again to keep looking
    else
        
		coroutine.sleep(0.5)
		find_racing_npc()

	end

end	
	
--trades item. does not use tradenpc, and should if you want to remove one possible fail point.
function item()
	
	windower.add_to_chat(200, 'Race Item: Trading Item.')
	windower.chat.input('/item \"' .. item_name .. '\" <t>') --20260507 parameterize this
	coroutine.sleep(2)

	--20260514 DACK I don't actually think we need these? that's not how that item interaction works if I recall correctly...
	windower.send_command('setkey enter down')
	coroutine.sleep(0.5)
	windower.send_command('setkey enter up')		
	coroutine.sleep(0.5)
	windower.send_command('setkey enter down')
	coroutine.sleep(0.5)
	windower.send_command('setkey enter up')		
	coroutine.sleep(0.5)

end			

function race()

	windower.add_to_chat(200, 'Race time! Equipping item and starting race.')
	
	--when we get here, we have the race NPC selected. enter the race menu
	windower.send_command('setkey enter down')
	coroutine.sleep(0.2)
	windower.send_command('setkey enter up')
	coroutine.sleep(10)

	--automatically handle loading so user doesn't have to think
	if is_first_npc_interaction == true then
		windower.add_to_chat(200, 'First interaction with the race NPC since zoning in. Waiting longer for the menu to actually load.')
		coroutine.sleep(20) --this menu takes MUCH longer if it's the first time since entering the zone that you talk to the NPC. this is overkill but it's fine.
		is_first_npc_interaction = false
	end

	--move down twice to select "free run" and enter that menu
	if display_debug_text then
		windower.add_to_chat(200, 'Race menu entered. Moving to select Free Run.')
	end

	windower.send_command('setkey down down')		
	coroutine.sleep(0.2)
	windower.send_command('setkey down up')		
	coroutine.sleep(0.2)		
	windower.send_command('setkey down down')	
	coroutine.sleep(0.2)
	windower.send_command('setkey down up')		
	coroutine.sleep(0.2)
	windower.send_command('setkey enter down')
	coroutine.sleep(0.5)
	windower.send_command('setkey enter up')		
	coroutine.sleep(3) --this menu can also take a strangely long time sometimes, so I'm pushing this up to 3.
	
	--once inside the free run menu, move cursor down three times to reach "equipment" (the item menu)
	if display_debug_text then
		windower.add_to_chat(200, 'Free run menu entered.')
	end

	windower.send_command('setkey down down')
	coroutine.sleep(0.2)
	windower.send_command('setkey down up')	
	coroutine.sleep(0.2)
	windower.send_command('setkey down down')
	coroutine.sleep(0.2)
	windower.send_command('setkey down up')	
	coroutine.sleep(0.2)
	windower.send_command('setkey down down')
	coroutine.sleep(0.2)
	windower.send_command('setkey down up')
	coroutine.sleep(0.2)

	--if using items, enter the menu and set the first item on the list, which may or may not be the one you're trading if you have others banked. known fail point, do not care.
	if use_items then
		
		if display_debug_text then
			windower.add_to_chat(200, 'Setting race item.')
		end

		--select the item menu--
		windower.send_command('setkey enter down')
		coroutine.sleep(0.5)
		windower.send_command('setkey enter up')		
		coroutine.sleep(1)

		--select the first item in the list
		windower.send_command('setkey down down')	
		coroutine.sleep(0.2)
		windower.send_command('setkey down up')		
		coroutine.sleep(0.5)
		windower.send_command('setkey enter down')		
		coroutine.sleep(0.5)
		windower.send_command('setkey enter up')		
		coroutine.sleep(1)

		--confirm that you do want to use this item
		windower.send_command('setkey up down')	
		coroutine.sleep(0.2)
		windower.send_command('setkey up up')	
		coroutine.sleep(0.2)
		windower.send_command('setkey enter down')		
		coroutine.sleep(0.5)
		windower.send_command('setkey enter up')		
		coroutine.sleep(2)
	
		--confirming the item puts you back in the main menu, so move down three times to get back to where we were (at the end of this, the item menu is currently selected) so that this chunk can be fully omitted if not using items
		windower.send_command('setkey down down')
		coroutine.sleep(0.2)
		windower.send_command('setkey down up')
		coroutine.sleep(0.2)
		windower.send_command('setkey down down')
		coroutine.sleep(0.2)
		windower.send_command('setkey down up')
		coroutine.sleep(0.2)
		windower.send_command('setkey down down')
		coroutine.sleep(0.2)
		windower.send_command('setkey down up')
		coroutine.sleep(0.2)

	end

	--move the cursor down once more to "start race"
	windower.send_command('setkey down down')
	coroutine.sleep(0.2)
	windower.send_command('setkey down up')
	coroutine.sleep(0.2)

	--select "start race"
	windower.send_command('setkey enter down')
	coroutine.sleep(0.2)
	windower.send_command('setkey enter up')
	coroutine.sleep(5) --this sleep has to be long, because the bits down here are the only point where the client phones home to the server. 5 might actually be too short. we'll see.
	
	--confirm skip cutscene, which is the default option so no arrows needed
	if display_debug_text then
		windower.add_to_chat(200, 'Selected to start race. Skipping cutscene.')
	end

	windower.send_command('setkey enter down')
	coroutine.sleep(0.2)
	windower.send_command('setkey enter up')
	coroutine.sleep(1)

	--having confirmed, the race is going and will finish at some point. this is dependent on client lag so the correct thing to do here is to wait for player idle status, which means we're out of the cutscene and good to go again.
    while windower.ffxi.get_player().status ~= 0 do
        coroutine.sleep(0.1)
    end

	--now we are standing in the chocobo circuit, nothing targeted, and good to start over!

end

--handler for addon commands
function chocorace_command(...)
    if #arg > 1 then

        windower.add_to_chat(167, 'Too many arguments. Try again with one argument. All settings should be set in the lua file itself.')

    elseif #arg == 1 and arg[1]:lower() == 'start' then
        
        windower.add_to_chat(200, 'ChocoRace: Begin race loop.')
		coroutine.sleep(0.1)
		windower.send_command('lua l enternity') --just make sure it's loaded, no sense doing reload things
		coroutine.sleep(0.1)
        loop() --entry point to the loop

    elseif #arg == 1 and arg[1]:lower() == 'stop' then
        
		windower.add_to_chat(200, 'ChocoRace: Aborting all actions and reloading.')
		windower.send_command('lua r Chocorace')

	elseif #arg == 1 and arg[1]:lower() == 'race' then

        windower.add_to_chat(200, 'ChocoRace: Starting a single racing cycle.')
		racecycle()

	elseif #arg == 1 and arg[1]:lower() == 'abort' then --keeping this, but it's just "stop".

		windower.add_to_chat(200, 'ChocoRace: Aborting all actions and reloading.')
		windower.send_command('lua r chocorace')

	else

		windower.add_to_chat(200, 'ChocoRace commands are "start", "stop", and "race". See readme or complain loudly for additional information.')

	end

end

windower.register_event('addon command', chocorace_command)
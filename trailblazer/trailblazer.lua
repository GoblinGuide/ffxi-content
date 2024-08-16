_addon.name = 'trailblazer'
_addon.version = '1.0' --20240816 DACK look, it's 1.0! all done!
_addon.author = 'DACK'
_addon.commands = {'tb', 'trailblazer'}

packets = require('packets')
resources = require('resources')
logger = require('logger')
events = require('events') --this is hackish, apparently, but it works

windower.register_event("addon command", function(...)

    --I don't ever make these local variables rather than global but people who aren't me usually do, I don't really know how that stuff works
    args = T{...}
    cmd = args[1]:lower()
    qty = args[2] --no need to lowercase this, it's a number 

    --check whether input was a valid tool type. you can add aliases here to be lazy, like 'pick', if you prefer
    if (cmd == 'pickaxe' or cmd == 'sickle' or cmd == 'hatchet') then
        buy_tool(cmd, qty)
    else
        notice("Accepted commands are 'pickaxe', 'sickle', and 'hatchet', to buy those three tools from Floralie. (Followed by the number to buy.)")
    end

end)
  
--a buying loop to purchase the specified quantity of tools
function buy_tool(cmd, qty)

    --open dialogue with Floralie (in case you don't know her, she's at E-8 West Adoulin, inside the Pioneers' Coalition, right by Home Point #1. she's the only NPC who sells these items.)
    local mob_id = get_nearest_mob_by_name('Floralie', false)
    local menu_id = start_dialog(mob_id)

    --translate the word for what we're buying into the hardcoded parameter ID used in the buying packet
    --note - this purchases the +1 tools because they're 1000 bayld each and I have literally two million bayld. you'll have to change this (to 3/4/5 I assume?) if you want the garbage NQ ones.
    if cmd == 'pickaxe' then
        unknown_1 = 6
    elseif cmd == 'hatchet' then
        unknown_1 = 7
    elseif cmd == 'sickle' then
        unknown_1 = 8
    else
        notice("Got into the buying function with an improperly specified tool. I'm not certain how, but please unload this addon (and zone because we sent a bad packet here) and try again.")
    end

    --purchasing loop
    for i = 1, qty, 1 do
        
        --send the buying packet
        send_dialog_packet(mob_id, menu_id, 1, true, unknown_1, 0)
        --option_index is a hardcoded 1, unknown_1 varies by tool as specified above

        coroutine.sleep(0.5)

    end

    --send packet to exit the menu because otherwise you lock up and have to run out the door to Ceizak
    send_dialog_packet(mob_id, menu_id, 0, false, 16384, 0)
    coroutine.sleep(0.1)

    --notify the user that we're done
    --first, turn the command into a proper item name to make this reporting out cleaner
    purchased_item = 'Trailblazing ' .. string.upper(string.sub(cmd, 1, 1)) .. string.sub(cmd, 2) .. ' +1'
    notice("We should have purchased " .. qty .. ' ' .. purchased_item .. '.')
  
end

--below this point is thicket's work, repurposed from others I'm sure
--sends a dialog packet
function send_dialog_packet(mob_id, menu_id, option_index, automated, unknown_1, unknown_2)
	local mob = get_mob_by_id(mob_id)
	
    if not mob then
		return
	end

	automated = automated or false
	unknown_1 = unknown_1 or 0
	unknown_2 = unknown_2 or 0

	packets.inject(packets.new('outgoing', 0x5b,
	{
		['Target'] = mob_id,
		['Target Index'] = mob.index,
		['Option Index'] = option_index,
		['_unknown1'] = unknown_1,
		['_unknown2'] = unknown_2,
		['Automated Message'] = automated,
		['Zone'] = windower.ffxi.get_info().zone,
		['Menu ID'] = menu_id,
	}))
end

--given mob id, returns its data array
function get_mob_by_id(mob_id)
	return mob_id and windower.ffxi.get_mob_by_id(mob_id)
end

--starts dialog with the given npc
function start_dialog(mob_id)

    interact_with_mob(mob_id)
	local menu_id = wait_for_dialog_start()
	if menu_id then
		return menu_id
	end
	
end

--sends an interact packet to specified mob id
function interact_with_mob(mob_id)
	local mob = get_mob_by_id(mob_id)
	
    if not mob then
		return
	end

	packets.inject(packets.new('outgoing', 0x1a,
	{
		['Target'] = mob_id,
		['Target Index'] = mob.index,
		['Category'] = 0,  -- interact
	}))
end

--waits for the npc dialog to start so we can intercept it
function wait_for_dialog_start()
	local menu_id = nil

	wait_for('incoming chunk', function(id, data)
		if id == 0x34 then
			menu_id = packets.parse('incoming', data)['Menu ID']
			return true
		end
	end, true, 10)

	return menu_id
end

--block the menu from opening when it's not supposed to be opening (because then we can't send nice packets)
function wait_for(event_type, f, block, threshold)
	block = block or false
	threshold = threshold or 5
	local debug_info = {}

	local success = false

	local function handler(...)
		local ret = f(...)
		if type(ret) == 'boolean' and ret then
			success = true
			return block
		elseif ret then
			table.insert(debug_info, ret)
		end
	end
	
    events.register_event(event_type, handler)

	-- Safety valve - bail after X seconds if our callback is never triggered.
	local start_secs = os.clock()
	local elapsed_secs = 0

	while not success and elapsed_secs < threshold do
		coroutine.sleep(0.1)
		elapsed_secs = os.clock() - start_secs
	end

	if elapsed_secs > threshold then
		Notice('Timed out waiting for ' .. event_type .. '. This is bad. Restart addon.')
	end

	events.unregister_event(event_type, handler)
	return success
end

--get id for a mob given its name
function get_nearest_mob_by_name(names)
	if type(names) == 'string' then
		names = S{names}
	end

	if attackable_only == nil then
		attackable_only = true
	end

	local ret = nil
	
    for index, mob in pairs(windower.ffxi.get_mob_array()) do
		if not distance or mob.distance <= (distance * distance) then
			if (not names or names:contains(mob.name)) then
				if ret == nil then
					ret = mob
				end
			end
		end
	end

	return ret and ret.id or nil
end
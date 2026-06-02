--targetinfo, among other addons, will display the ID of the targeted passenger

--THE ORIGINAL INSTRUCTIONS IN CASE I MESSED UP THE CHANGES:
--To use: "Start the quest, send an addon command (//lua c whatever-you-name-this), zone into airship, send an addon command again. Should spit out the ID of the right passenger to console."

_addon.name = 'DiscerningEye';
_addon.version = '0.2';
_addon.author = 'Radec on FFXIAH, plus mods';
_addon.commands = {'eye'};

require('tables')
require('luau') --"contains"
 
--port zone IDs and airship zone IDs, respectively
ports = T{232, 236, 240, 250}
airships = T{223, 224, 225, 226}

--note: you can use literally anything here, 'eye' whatever, it doesn't even read the cmd args
windower.register_event("addon command", function (...)

    if ports:contains(zone) then
    
        get_target_model()

    end

    if airships:contains(zone) then
    
        find_target_passenger()

    end

end)
 
--when character zones into any non-airship zone (including the ports) clear the target models array
--20260528 when they zone into an airship zone, automatically run find passenger
windower.register_event("zone change", function (new, old)
    if not airships:contains(new) then
        target_models = nil
    else
        coroutine.sleep(10) --wait for zone to load, then...
        find_target_passenger()
    end
end)
 
--on addon load, initialize the target model array (with an empty one, because we don't know the target yet)
windower.register_event("load", function (...)
    target_models = nil
end)
 
--tests for a table match by concatenating the two tables and seeing if the contents are equal. is this optimal? I don't know or care!
function do_tables_match(a, b)
    return table.concat(a) == table.concat(b)
end

--20260423 automate first previously-manual command
--todo: is there a windower event for obtaining a key item? looks like there might not be?
--looks like it's a 0x02a, param 1 is key item id
windower.register_event("incoming text", function(original)

    if (original:contains("Obtained key item")) then

       get_target_model()

	end

end)

--20260423 automate storing target model
function get_target_model()

    --grab the entire mob array
    local mob_array = windower.ffxi.get_mob_array()
    
    --find current zone and use hardcoded magic numbers
    local zone = windower.ffxi.get_info()['zone']

    --the ID of the cutscene NPC in each zone? the Windurst and Kazham ones are exactly 1 after the ID of the quest giver. seems likely.
    local npc_id_list = {
        [232] = 17727618, --San d'Oria
        [236] = 17744024, --Bastok
        [240] = 17760443, --Windurst
        [250] = 17801341, --Kazham
    }
 
    --only do anything if we're in the port zones
    if ports:contains(zone) then

        for _,v in pairs(mob_array) do
    
            if v.id == npc_id_list[zone] then

                target_models = v.models

                windower.add_to_chat(213, "Passenger model saved.")

            end

        end

    end

end

--20260423 automate finding target on airship
function find_target_passenger()

    --same, hardcoded magic numbers + mob array
    local mob_array = windower.ffxi.get_mob_array()
    local zone = windower.ffxi.get_info()['zone']

    local npc_id_list = {
        [232] = 17727618, --San d'Oria
        [236] = 17744024, --Bastok
        [240] = 17760443, --Windurst
        [250] = 17801341, --Kazham
    }
 
    --only do anything if we're on an airship
    if airships:contains(zone) then

        windower.add_to_chat(213, "Airship detected. Searching for passenger ID.")

        for _,v in pairs(mob_array) do

            if do_tables_match(v.models, target_models) then

                --if desired, could use get_mob_by_index and get_mob_by_id to convert this to the hexadecimal.
                --but since I'd have to write a gui to replace targetinfo... let's not and say we did. but I might someday?
                windower.add_to_chat(213, "Passenger found. ID = ".. v.id .. ".")

            end

        end

    end


end
_addon.name = 'DiscerningEye';
_addon.version = '0.1.0';
_addon.author = 'Radec on FFXIAH';
_addon.commands = { 'eye'};

require('tables')
 
ports = T{232, 236, 240, 250}
airships = T{223, 224, 225, 226}

--to use: "Start the quest, send an addon command (//lua c whatever-you-name-this), zone into airship, send an addon command again. Should spit out the ID of the right passenger to console."
--targetinfo, among other addons, will display the ID of the targeted passenger

--TODO: just put some movement on this lmao
--SUBSEQUENT TODO BECAUSE I KNOW MYSELF send packets to rebuy airship ticket etc rather than hardcode menuing

--note: you can use literally anything here, 'eye' whatever, it doesn't even read the cmd args
windower.register_event("addon command", function (...)
    local mob_array = windower.ffxi.get_mob_array()
    local zone = windower.ffxi.get_info()['zone']
    local npc_id_list = {
        [232] = 17727618, --San d'Oria
        [236] = 17744024, --Bastok
        [240] = 17760443, --Windurst
        [250] = 17801341, --Kazham
    }
 
    for _,v in pairs(mob_array) do
        if ports:contains(zone) then
            if v.id == npc_id_list[zone] then
                target_models = v.models
            end
        end
        if airships:contains(zone) then
            if do_tables_match(v.models, target_models) then
                print("Found ID "..v.id)
            end
        end
    end
end)
 
windower.register_event("zone change", function (new, old)
    if not airships:contains(new) then
        target_models = nil
    end
end)
 
windower.register_event("load", function (...)
    target_models = nil
end)
 
function do_tables_match( a, b )
    return table.concat(a) == table.concat(b)
end
_addon.name = 'coalitions'
_addon.author = '??? | Z.'
_addon.version = '2.0'
_addon.commands = {'coalitions'}

packets = require('packets')
bit = require('bit')

local enabled = true
local valid_zones = S{256, 257}
local MAX_RANK = 0x0E

windower.register_event('incoming chunk', function(id, data)
    if not enabled or id ~= 0x034 then return end
    
    local zone = windower.ffxi.get_info().zone
    if not valid_zones:contains(zone) then return end
    
    local mob = windower.ffxi.get_mob_by_index(data:unpack('H', 0x29))
    if not mob or mob.name ~= "Task Delegator" then return end
    
    local p = packets.parse('incoming', data)
    local menu_params = p['Menu Parameters']
    
    --windower.add_to_chat(69, 'Increased coalition rank to maximum.') --if you care about reporting, uncomment this
    local byte2 = bit.bor(bit.band(menu_params:byte(2), 0x03), bit.lshift(MAX_RANK, 2))
    p['Menu Parameters'] = string.char(menu_params:byte(1), byte2) .. menu_params:sub(3)
    
    return packets.build(p)
end)

windower.register_event('addon command', function()
    enabled = not enabled
    --windower.add_to_chat(69, 'Coalitions: ' .. (enabled and '\31\158enabled\31\207' or '\31\167disabled\31\207')) --if you care about reporting, uncomment this
end)

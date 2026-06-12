_addon.name     = 'SafeSpace'
_addon.version  = '0.2.0'
_addon.author   = 'Lili'
_addon.commands = {'safespace','ss'}

require('logger')
local packets = require('packets')

local so = {
    player  = nil,
    zone    = nil,
    members = {}, -- party + alliance mob IDs
    enabled = true
}

local locations = {
    {name = 'affi', x = -356, y = -170, z = 0, r = 5, zone = 288},			-- Escha Zi'Tah - Entrance NPC
    
    {name = 'dremi', x = -8, y = -460, z = -34, r = 5, zone = 289},			-- Escha Ru'Aun - Entrance NPC
    
    {name = 'mhaurahp', x = -12, y = 87, z = -15, r = 5, zone = 249},       -- Mhaura - Home Point #1
    {name = 'mhauramoogles', x = 18, y = 62, z = -15, r = 7, zone = 249},   -- Mhaura - Moogle area
    {name = 'gorpa', x = -27, y = 52, z = -16, r = 5, zone = 249},          -- Mhaura - Ambuscade vendor (covers the book too)
    
    {name = 'oseem', x = 16, y = 22, z = 0, r = 5, zone = 252},				-- Norg - Dark Matter gambling added to draftkings
    {name = 'norghp2', x = -66, y = 54, z = -5, r = 5, zone = 252},         -- Norg - The only Home Point worth calling home
    
    {name = 'trisvain', x = 27, y = 84, z = 0, r = 5, zone = 231},          -- Northern San d'Oria HTBF entry KI vendor (a fine upstanding elvaan citizen)

    {name = 'Oboro', x = -180, y = 86, z = 11, r = 5, zone = 246},          -- Port Jeuno - RIP Odoro 2020-2021
    {name = 'monisette', x = -6, y = -10, z = 0, r = 5, zone = 246},		-- Port Jeuno - Reforge NPC in Port Jeuno
    
    {name = 'odyssea', x = 2, y = 119, z = 8, r = 5, zone = 247},           -- Rabao - Odyssea conflux and vedor
    
    {name = 'shiftrix', x = -500, y = -487, z = -19, r = 5, zone = 291},    -- Reisenjima - Entrance NPC (what a jerk)
    {name = 'incantrix', x = -358, y = -844, z = -440, r = 7, zone = 291},  -- Reisenjima - Omen entry & canteens (doesn't block avatars, sorry folks)
    {name = 'coelestrox', x = -359, y = -800, z = -440, r = 5, zone = 291}, -- Reisenjima - Omen artifact reforge

    {name = 'aurix', x = -54, y = 6, z = 6, r = 5, zone = 243}              -- Ru'Lude Gardens - Dynamis(D) NPC
}

local function update_members()
    so.members = {}
    local party = windower.ffxi.get_party()
    for _, member in pairs(party) do
        if type(member) == 'table'
        and member.mob
        and member.mob.id then
            so.members[member.mob.id] = true
        end
    end
end

-- Added a toggle because maybe you want to search some bazzars by or something idk
windower.register_event('addon command', function(cmd)
    cmd = cmd and cmd:lower() or ''

    if cmd == 'on' then
        so.enabled = true
        notice('SafeSpace enabled.')
    elseif cmd == 'off' then
        so.enabled = false
        notice('SafeSpace disabled.')
    else
        notice('Usage: its just On or Off, I\'m not that smart')
    end
end)

windower.register_event('load','login', function()
    so.player = windower.ffxi.get_player()
    so.zone   = windower.ffxi.get_info().zone
    update_members()
end)

windower.register_event('party change', update_members)

windower.register_event('zone change', function(id)
    so.zone = id
end)

windower.register_event('unload','logout', function()
    so.player  = nil
    so.zone    = nil
    so.members = {}
end)

windower.register_event('incoming chunk', function(id, org, mod, inj)
    if not so.enabled
    or inj
    or id ~= 0x00D
    or not so.player then
        return
    end

    local mob_id = string.sub(org, 5, 8):unpack('I')

    if mob_id == so.player.id or so.members[mob_id] then
        return
    end

    local p = packets.parse('incoming', org)
    if not p or not p.X or not p.Y or not p.Z then return end

    for _, loc in ipairs(locations) do
        if so.zone == loc.zone then
            local dx = loc.x - p.X
            local dy = loc.y - p.Y
            local dz = loc.z - p.Z
            local r2 = loc.r * loc.r

            if (dx*dx + dy*dy + dz*dz) <= r2 then
                p.Despawn = true
                return packets.build(p)
            end
        end
    end
end)

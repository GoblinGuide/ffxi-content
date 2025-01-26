_addon.name = 'SafeSpace'
_addon.version = '0.1'
_addon.author = 'Lili'

require('logger')
local packets = require("packets")

--20230515 DACK added the Diaphanous Transposer at Kamihr Drifts Waypoint #4 used to enter Sortie

local so = {
    player = false,
    partymembers = {},
    zone = false,
}

local blocked = {}

local mhauraHP = {x = -12, y = 87, z = -15, r = 5, zone = 249}			-- Mhaura HP

local mhauramog = {x = 18, y = 62, z = -15, r = 7, zone = 249}			-- Moogle area in Mhaura

local gorpa = {x = -27, y = 52, z = -15, r = 5, zone = 249}				-- Ambuscade vendor

local oboro = {x = -179, y = 85, z = -11, r = 5, zone = 246}			-- RIP Odoro 2020-2021

local oseem = {x = 16, y = 22, z = 0, r = 5, zone = 252}				-- Escha/Dark Matter Campaign Augment NPC

local affi = {x = -356, y = -170, z = 0, r = 5, zone = 288}				-- Escha - Zi'Tah NPC

local dremi = {x = -8, y = -460, z = -34, r = 5, zone = 289}			-- Escha - Ru'Aun NPC

local shiftrix = {x = -500, y = -487, z = -19, r = 5, zone = 291}		-- Reisenjima NPC

local odyssey = {x = 2, y = 119, z = 8, r = 5, zone = 247}				-- Odyssey conflux and vendor

local monisette = {x = -6, y = -10, z = 0, r = 5, zone = 246}			-- Reforge NPC in Port Jeuno

local trisvain = {x = 27, y = 84, z = 0, r = 5, zone = 231}				-- HTBF entry KI vendor

local aurix = {x = -54, y = 6, z = 6, r = 5, zone = 243}				-- Dynamis(D) NPC

local incantrix = {x = -357, y = -841, z = -440, r = 7, zone = 291}		-- Omen entry & canteens

local coelestrox = {x = -359, y = -800, z = -440, r = 5, zone = 291}	-- Omen artifact reforge

local ruspix = {x = -35, y = -1, z = -0, r = 5, zone = 281}	            -- Sortie NPC

local ljeunhp = {x = -98.42, y = -183.32, z = -0, r = 15, zone = 245}   -- Lower Jeuno (E) HP

local greyson = {x = -92.53, y = -165.43, z = -0, r = 10, zone = 245}   -- AMAN Trove orbs

local nsandtwo = {x = 10.06, y = 95.03, z = -0.20, r = 10, zone = 231}  -- Phantom gems (from our boy Trisvain)

local transposer = {x = -247, y = 361, z = 3, r = 7, zone = 267}		-- Sortie entry

function mhauraHP_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((mhauraHP.x - t.X)^2 + (mhauraHP.y - t.Y)^2)
    return mhauraHP.r > dist and dist
end

function mhauramog_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((mhauramog.x - t.X)^2 + (mhauramog.y - t.Y)^2)
    return mhauramog.r > dist and dist
end

function gorpa_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((gorpa.x - t.X)^2 + (gorpa.y - t.Y)^2)
    return gorpa.r > dist and dist
end

function oboro_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((oboro.x - t.X)^2 + (oboro.y - t.Y)^2)
    return oboro.r > dist and dist
end

function oseem_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((oseem.x - t.X)^2 + (oseem.y - t.Y)^2)
    return oseem.r > dist and dist
end

function affi_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((affi.x - t.X)^2 + (affi.y - t.Y)^2)
    return affi.r > dist and dist
end

function dremi_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((dremi.x - t.X)^2 + (dremi.y - t.Y)^2)
    return dremi.r > dist and dist
end

function shiftrix_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((shiftrix.x - t.X)^2 + (shiftrix.y - t.Y)^2)
    return shiftrix.r > dist and dist
end

function odyssey_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((odyssey.x - t.X)^2 + (odyssey.y - t.Y)^2)
    return odyssey.r > dist and dist
end

function monisette_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((monisette.x - t.X)^2 + (monisette.y - t.Y)^2)
    return monisette.r > dist and dist
end

function trisvain_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((trisvain.x - t.X)^2 + (trisvain.y - t.Y)^2)
    return trisvain.r > dist and dist
end

function aurix_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((aurix.x - t.X)^2 + (aurix.y - t.Y)^2)
    return aurix.r > dist and dist
end

function incantrix_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((incantrix.x - t.X)^2 + (incantrix.y - t.Y)^2)
    return incantrix.r > dist and dist
end

function coelestrox_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((coelestrox.x - t.X)^2 + (coelestrox.y - t.Y)^2)
    return coelestrox.r > dist and dist
end

function ruspix_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((ruspix.x - t.X)^2 + (ruspix.y - t.Y)^2)
    return ruspix.r > dist and dist
end

function ljeunhp_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((ljeunhp.x - t.X)^4 + (ljeunhp.y - t.Y)^4)
    return ljeunhp.r > dist and dist
end

function greyson_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((greyson.x - t.X)^4 + (greyson.y - t.Y)^4)
    return greyson.r > dist and dist
end

function nsandtwo_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((nsandtwo.x - t.X)^4 + (nsandtwo.y - t.Y)^4)
    return nsandtwo.r > dist and dist
end

function transposer_is_near(t)
    local t = t or windower.ffxi.get_mob_by_target('me')
    if t.x then t.X = t.x t.Y = t.y end
    
    local dist = math.sqrt((transposer.x - t.X)^2 + (transposer.y - t.Y)^2)
    return transposer.r > dist and dist
end

windower.register_event('load','login',function()
    so.player = windower.ffxi.get_player()
    so.zone = windower.ffxi.get_info().zone
    so.partymembers = windower.ffxi.get_party()

end)

windower.register_event('zone change',function(id)
    so.zone = id
end)

windower.register_event('unload','logout', function()
    so.player = false
    so.zone = false
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Mhaura HP
    if so.zone ~= mhauraHP.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if mhauraHP_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Moogle area in Mhaura
    if so.zone ~= mhauramog.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if mhauramog_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Ambuscade vendor
    if so.zone ~= gorpa.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if gorpa_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- RIP Odoro 2020-2021
    if so.zone ~= oboro.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if oboro_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Escha Augment NPC
    if so.zone ~= oseem.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if oseem_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Escha - Zi'Tah NPC
    if so.zone ~= affi.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if affi_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Escha - Ru'Aun NPC
    if so.zone ~= dremi.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if dremi_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Reisenjima entrance
    if so.zone ~= shiftrix.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if shiftrix_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- odyssey conflux and vedor
    if so.zone ~= odyssey.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if odyssey_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Reforge NPC in Port Jeuno
    if so.zone ~= monisette.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if monisette_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- HTBF entry KI vendor
    if so.zone ~= trisvain.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if trisvain_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Dynamis(D) NPC
    if so.zone ~= aurix.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if aurix_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Omen entry & canteens
    if so.zone ~= incantrix.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if incantrix_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Omen artifact reforge
    if so.zone ~= coelestrox.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if coelestrox_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Omen artifact reforge
    if so.zone ~= ruspix.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if ruspix_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)  -- Lower Jeuno HP E
    if so.zone ~= ljeunhp.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if ljeunhp_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)  -- Greyson
    if so.zone ~= greyson.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if greyson_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)  -- nsandtwo
    if so.zone ~= nsandtwo.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if nsandtwo_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)

windower.register_event('incoming chunk', function (id, org, mod, inj)	-- Ambuscade vendor
    if so.zone ~= transposer.zone or not so.player or inj then
        return
    end
    
    if id == 0x00D and string.sub(org, 5,8):unpack("I") ~= so.player.id then
        
        local p = packets.parse('incoming', org)
       
        if transposer_is_near(p) then
           p.Despawn = true
           return packets.build(p) 
        end
    end
end)
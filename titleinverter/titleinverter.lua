--please note that there are no addon commands. you literally just run this and talk to the bard.
--https://www.ffxiah.com/node/433 is a list of every title that existed when Mastery Rank was added
--(some posters theorize that later titles, i.e. the sortie basement bosses/final boss/RoV chapter 3+, are not counted towards MR. I am not those people. easier for SE to make raw number matter, right?)

_addon.name = 'inverter'
_addon.author = 'Bryth'
_addon.version = '1.0'
_addon.commands = {'inverter'}

require("pack")

npc_names = {
    ["Tuh Almobankha"] = true,
    ["Moozo-Koozo"] = true,
    ["Styi Palneh"] = true,
    ["Tamba-Namba"] = true,
    ["Bhio Fehriata"] = true,
    ["Cattah Pamjah"] = true,
    ["Burute-Sorute"] = true,
    ["Zuah Lepahnyu"] = true,
    ["Yulon-Polon"] = true,
    ["Willah Maratahya"] = true,
    ["Eron-Tomaron"] = true,
    ["Quntsu-Nointsu"] = true,
    ["Shupah Mujuuk"] = true,
    ["Aligi-Kufongi"] = true,
    ["Koyol-Futenol"] = true,
    ["Debadle-Levadle"] = true
}

windower.register_event('incoming chunk', function (id, original, modified, injected, blocked)
    if id == 0x033 and npc_names[windower.ffxi.get_mob_by_id(original:unpack("I",5)).name] then
        print("Inverted NPC")
        local my_string = string.sub(original,1,0x50)
        for i = 0x51,0x68 do
            my_string = my_string..string.char(255 - original:byte(i))
        end
        local flags = original:sub(0x69,0x6C)
        local gil = original:sub(0x6D,0x70)
        return my_string..flags..gil
    end
end)
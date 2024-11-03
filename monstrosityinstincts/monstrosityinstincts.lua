_addon.name = 'monstrosityinstincts'
_addon.version = '0.1' --really I should just put things as version 0 at some point, huh
_addon.author = 'me'
_addon.commands = {'instincts','mi','monstrosity','monstro','mon'} --"mon" might have an alias collision somewhere, I don't actually know, but for now it's here

res = require('resources')
packets = require('packets')
require('logger')

--this "addon" will take any command, other than nothing at all
windower.register_event('addon command', function (...)
	local args = T{...}
	local command = args[1]

    --no matter what you put in, make it work
	if (command ~= '') and (command ~= nil) then 

        test_function()

	end
end)

--this was an attempt to programmatically determine what monstrosity instincts I have set.
--that said, it currently only gets the IDs of them. 
--likely related to PUP attachments. same style of packet, same windower function. different not-visible inventory with a diferent structure of "item" id for these not-real-items. (BLU spells, too.)
function test_function()

    notice('Attempting to access current Monstrosity information.')

	--this function will also return positive if you're on PUP or BLU
    --therefore, please only use it inside the Feretory or when actively out on Monstrosity.
    if windower.ffxi.get_mjob_data() then
        notice('Success! Parsing...')
        
        species_id=windower.ffxi.get_mjob_data().species
        notice('Current species ID number: ' ..species_id)

        --stolen from gearswap slash refresh dot lua, it works and that's all I ask for
        species_name = {} --is this necessary to initialize? I honestly don't know. lua is wild. I don't think it is but I don't want to risk it

        for i,v in pairs(res.monstrosity[species_id]) do
            language_variable = i --the value of this is "en" on an English client. why is that? raw data is     [1] = {id=1,en="Rabbit",ja="ウサギ族",tp_moves={[257]=1,[258]=10,[259]=20,[314]=30}} [see below]
            species_name[i] = v
        end

		--no, really, why does that work? you're telling me the first value for "i, v in pairs(id=1,en="Rabbit",ja="ウサギ族",tp_moves={[257]=1,[258]=10,[259]=20,[314]=30})" is... "en"? that's the second value!
		--I assume the ID is inherently ignored? but then why does it not continue looping and say okay, ja is next, then tp_moves, and then end with tp moves because it's a for loop? shouldn't it be overwriting language_variable?
		--summary: no idea why this works. it's a pretty fundamental bit of lua logic, too. but it *does* work and that's all I care about.

        notice('Current species name: ' .. species_name[language_variable]) --here's the species you're actually on right now. it works!

		--here's the only other piece of data in the mjob data table. you can find this out by wrapping this in another pairs loop - code preserved below in comments
        all_instincts = windower.ffxi.get_mjob_data().instincts
        --THIS RETURNS 24 THINGS. 1-12 ARE THE INSTINCTS YOU HAVE EQUIPPED.
        --some ids: mandragora instinct 1 is 54. raptor 1 is 132. some of the job instincts were 791 and 785. racial instincts go from 768 to 777. clearly one counter starting at 1 and one at 700 or something. typical ffxi ids.
        --(what are 13-24? 13 returned 43110 which is absolutely outside the bounds of any ID I recognize, including item. 16 was 8192 lmao power of 2, some 2XXXXs in the 20s, bunch of 0s, not 1:1 with anything I can see)
        for i,v in pairs(all_instincts) do
            notice('instinct slot: ' .. i)
            notice('instinct id: ' .. v)
        end

    --the number on that instinct ID is 1 lower than the number in instincts.lua. this is fixable, if I ended up caring. but I stopped working on this altogether.

    else
        notice("Attempting to find MJob data returned nothing. Make sure you're in Monstrosity.")
    end

end

--this will show what this windower function is returning, but NOT the contents - you'll have to dig deeper for that with the other for-pairs statement above
--for i,v in pairs(windower.ffxi.get_mjob_data()) do
--	notice('looking at pair number: ' .. i )
--	notice('its content is: ' .. tostring(v)) --tostring not needed HERE but if it was to be returning numbers, we'd need it so it prevents breaking if the contents are not expected
--end
--in this specific case, you see it returns 1=species 2=instincts

--deeper than I ended up needing to go, for now, but possibly not forever if I want to read those contents if we can't get them from the raw data in the ROM folders
--instincts raw data is stored in ROM/288/80.DAT. item ID 29699 is the very first instinct after the three blank ones. remove 0x7400 from that to get the ID as used in the file provided with this lua.
--same statement with monstrosity monsters: ids 0xF000 - 0xF1FF. instincts: 0x7400 - 77FF
--outgoing 0x102 packet has instinct info

--following are verbatim copypastes from Windower/addons/libs/packets/fields.lua - could parse incoming packets for variant info or something
--someone more ambitious than me could even use the outgoing 0x102 info to write monchange.lua to work like jobchange!
-- Untraditional Equip
-- Currently only commented for changing instincts in Monstrosity. Refer to the doku wiki for information on Autos/BLUs.
-- https://gist.github.com/nitrous24/baf9980df69b3dc7d3cf
--fields.outgoing[0x102] = L{
--    {ctype='unsigned short',    label='_unknown1'},                             -- 04  -- 00 00 for Monsters
--    {ctype='unsigned short',    label='_unknown1'},                             -- 06  -- Varies by Monster family for the species change packet. Monsters that share the same tnl seem to have the same value. 00 00 for instinct changing.
--    {ctype='unsigned char',     label='Main Job',           fn=job},            -- 08  -- 00x17 for Monsters
--    {ctype='unsigned char',     label='Sub Job',            fn=job},            -- 09  -- 00x00 for Monsters
--    {ctype='unsigned short',    label='Flag'},                                  -- 0A  -- 04 00 for Monsters changing instincts. 01 00 for changing Monsters
--    {ctype='unsigned short',    label='Species'},                               -- 0C  -- True both for species change and instinct change packets
--    {ctype='unsigned short',    label='_unknown2'},                             -- 0E  -- 00 00 for Monsters
--    {ctype='unsigned short[12]',label='Instinct'},                              -- 10
--    {ctype='unsigned char',     label='Name 1'},                                -- 28
--    {ctype='unsigned char',     label='Name 2'},                                -- 29
--    {ctype='char*',             label='_unknown'},                              -- 2A  -- All 00s for Monsters
--}

-- MON
--func.incoming[0x044][0x17] = L{
--    {ctype='unsigned short',    label='Species'},                               -- 08
--    {ctype='unsigned short',    label='_unknown2'},                             -- 0A
--    {ctype='unsigned short[12]',label='Instinct'},                              -- 0C   Instinct assignments are based off their position in the equipment list.
--    {ctype='unsigned char',     label='Monstrosity Name 1'},                    -- 24
--    {ctype='unsigned char',     label='Monstrosity Name 2'},                    -- 25
--    {ctype='data[118]',         label='_unknown3'},                             -- 26   Zeroing everything beyond this point has no notable effect.
--}

--func.incoming[0x063][0x03] = L{
--    {ctype='unsigned short',    label='_flags1'},                               -- 06   Consistently D8 for me
--    {ctype='unsigned short',    label='_flags2'},                               -- 08   Vary when I change species
--    {ctype='unsigned short',    label='_flags3'},                               -- 0A   Consistent across species
--    {ctype='unsigned char',     label='Mon. Rank'},                             -- 0C   00 = Mon, 01 = NM, 02 = HNM
--    {ctype='unsigned char',     label='_unknown1'},                             -- 0D   00
--    {ctype='unsigned short',    label='_unknown2'},                             -- 0E   00 00
--    {ctype='unsigned short',    label='_unknown3'},                             -- 10   76 00
--    {ctype='unsigned short',    label='Infamy'},                                -- 12
--    {ctype='unsigned int',      label='_unknown4'},                             -- 14   00s
--    {ctype='unsigned int',      label='_unknown5'},                             -- 18   00s
--    {ctype='data[64]',          label='Instinct Bitfield 1'},                   -- 1C   See below
--    -- Bitpacked 2-bit values. 0 = no instincts from that species, 1 == first instinct, 2 == first and second instinct, 3 == first, second, and third instinct.
--    {ctype='data[128]',         label='Monster Level Char field'},              -- 5C   Mapped onto the item ID for these creatures. (00 doesn't exist, 01 is rabbit, 02 is behemoth, etc.)
--}
--
--func.incoming[0x063][0x04] = L{
--    {ctype='unsigned short',    label='_unknown1'},                             -- 06   B0 00
--    {ctype='data[126]',         label='_unknown2'},                             -- 08   FF-ing has no effect.
--    {ctype='unsigned char',     label='Slime Level'},                           -- 86
--    {ctype='unsigned char',     label='Spriggan Level'},                        -- 87
--    {ctype='data[12]',          label='Instinct Bitfield 3'},                   -- 88   Contains job/race instincts from the 0x03 set. Has 8 unused bytes. This is a 1:1 mapping.
--    {ctype='data[32]',          label='Variants Bitfield'},                     -- 94   Does not show normal monsters, only variants. Bit is 1 if the variant is owned. Length is an estimation including the possible padding.
--}
--
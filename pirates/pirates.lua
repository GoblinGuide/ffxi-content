_addon.name = 'pirates'
_addon.author = 'Suteru and me' --I took Suteru's work in zone ID and changed it from a gui to something a little more... manual
_addon.version = '0.1'
_addon.language = 'English' --this exists?!
_addon.commands = {'pirates', 'pirate', 'boat'}; --rather than automatically on zone change, I made this manual.

require('luau')
texts = require('texts')

windower.register_event('addon command', function (...)
	local cmd  = (...) and (...):lower();

	if (cmd == 'check') then

        zone = windower.ffxi.get_info().zone
        if zone == 220 or zone == 221 then
            notice('On a non-pirate boat.')
        elseif zone == 227 or zone == 228 then
            notice('On a pirate boat!')
        else
            notice("Wherever you are, it's not a Selbina-Mhaura boat. Therefore, you are safe from pirates, but also, lmao.") --removed the joke if you fire this up in Norg. ha ha what a kidder.
        end
    
	else

        notice("The only supported command is 'check', which will check the ID of your current zone to see whether you're on a pirate boat.")
	
    end

end)

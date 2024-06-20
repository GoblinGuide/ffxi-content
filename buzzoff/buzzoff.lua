--changelog:
--0.3.3: added commands "on" and "off" to toggle to a mode
--0.3.2: added the alias "toggle" to mean "switch"
--0.3.1: added "always visible" list
--0.3: created buzzoff by forking fuckoff, added toggle settings, reconfigured things to work with toggles
--it's called buzzoff because it means the same as fuckoff, but bees annoy you when they buzz yet serve a useful purpose so you want to be able to have them around. get it? :)

--To make your own wildcard matching, here's the syntax example link from the original addon author: https://riptutorial.com/lua/example/20315/lua-pattern-matching

_addon.name = 'buzzoff'
_addon.version = '0.3.3'
_addon.author = 'Chiaia (Asura) and also me'
_addon.commands = {'buzzoff','bo'}

require('luau') --the hula is MANDATORY, citizen (seriously, what the hell is lua u in this context)
packets = require('packets')

--by default, toggle list words will be filtered out
local toggle = true
windower.add_to_chat(208, "BuzzOff has loaded. Chat filter is currently toggled on. Use 'buzzoff switch' to switch.")

--Each of the five below lists take priority over all the lists below them.
--1) Any username in this list is blocked in all chat modes. This is the king and overrides everything else.
local blocked_users = T{''}

--2) Any word in this list will always be shown as long as it's not coming from a name on list 1. This is for mercs, content, or items that you actively want to see every time.
local always_visible_words = T{'segment','Crepuscular','Vagary','card','Dynamis'}

--3) Any username in this list is blocked in all chat modes like the blocked users list, but only when BO is toggled on.
--People you don't always want to see but will want to see when filter is off go here. So mercs you want to use, but only sometimes, and so on.
local toggled_users = T{'Casasi','Wakakillofu'}

--4) Any yell or shout containing these words is visible only when BO is toggled off. Takes priority over the blocked word list to make these shouts show up when BO is toggled off.
--Things that you DO want to see when you turn the filter off go here - content you want to do for example ("Aeonic" both here AND in the blocked word list means you'll see it only when it's time to buy one and you toggle off.)
local toggled_words = T{'Sortie','Omen','Ambuscade','RP','V25','Shinryu','Odyssey','Sheol'}

--5) Any yell or shout containing these words is blocked. Does not take priority over anything.
--Things that you NEVER want to see from ANYONE go here.
--Implicit assumptions: JP sellers shout for level 1-99, 500, and 2100. There's a lot of stupid sheol whack-a-mole to play, so this list got long.
local blocked_words = T{string.char(0x81,0x69),string.char(0x81,0x99),string.char(0x81,0x9A),'1%-99','Job Points.*2100','Job Points.*500','JP.*2100','JP.*500','500*ml','Master Level',
'0-20','0-30','0-40','Abyssea','Empyrean','Reisenjima','Aeonic','T1234','T1T2T3','Lilith','V0V1','Sobek','Apademak','2100p','Empy','EMP','500*jp','Mercenary','Fast Cast','Bazaar','Mars Orb'}
--First two are '☆' and '★'. (no idea what the third is, this is the original author's notes - we have a bit more research into this now in the Discord if you poke us and ask)


windower.register_event('addon command', function (...)
  local args = T{...}
  local command = args[1]
  
  --if the command put in is "switch" or "toggle", switch the status of the toggle list from true to false or vice versa
  if (command == 'switch' or command == 'toggle') then
    windower.add_to_chat(208, 'Toggling chat filter mode:')
    if toggle == true then
	  toggle = false
	  windower.add_to_chat(208, 'Chat filter is now toggled off.')
	else
	  toggle = true
	  windower.add_to_chat(208, 'Chat filter is now toggled on.')
	end
  elseif command == 'off' then
    toggle = false
	windower.add_to_chat(208, 'Chat filter is now toggled off.')
  elseif command == 'on' then
	  toggle = true
	  windower.add_to_chat(208, 'Chat filter is now toggled on.')
  else
  end
end)

windower.register_event('incoming chunk', function(id,data)
  if id == 0x017 then -- 0x017 Is incoming chat.
      local chat = packets.parse('incoming', data)
      local cleaned = windower.convert_auto_trans(chat['Message']):lower()
  
	--case 1: we explicitly want to see these words -> display them no matter what
  	for k,v in ipairs(always_visible_words) do
  	  if cleaned:match(v:lower()) then
  	    break
  	  end
  	end
  
  	--case 2: sender is on block list -> block message no matter what
  	if blocked_users:contains(chat['Sender Name']) then -- Blocks any message from X user in any chat mode.
  		return true

  	--case 3: sender is on the toggle list -> block message if toggle is on
  	elseif toggled_users:contains(chat['Sender Name']) and toggle then 
  		return true
  		
	--unlike the above, all cases below this point only filter shouts (1) and yells (26). (Tells are mode 3, if you want that too. 12 is GM! This isn't Windower-documented that I know of, so I had to Google it.)
  	elseif (chat['Mode'] == 1 or chat['Mode'] == 26) then
  	
      --case 4: toggle is on (and the message sender is not on the block list, implied by case 1) -> look for toggled words and filter out the message if one is found.
  	  if toggle then
  	    for k,v in ipairs(toggled_words) do
  		  if cleaned:match(v:lower()) then
  		    return true
  	      end
  	    end
  	  end
	  
	  --case 5: toggle is off -> look for toggled words and break this loop if one is found so that we do NOT filter it out, i.e. we DO display the message normally.
	  if (not toggle) then
  	    for k,v in ipairs(toggled_words) do
  		  if cleaned:match(v:lower()) then
  		    break --break the loop, thereby displaying the message rather than blocking it
  	      end
  	    end
  	  end

  	--case omega: block anything on the word block list that hasn't been specially loopholed by the above word lists (which means this has to go at the end, which is why this is case omega)
  	for k,v in ipairs(blocked_words) do
  	    if cleaned:match(v:lower()) then
  	      return true
  	    end
  	  end  	

	--if we've made it here, we have failed to hit any triggers, and therefore the message should not be blocked, so do nothing.
    end
  end
end)

--[[
Copyright (c) 2019-2021, Chiaia
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    * Neither the name of buzzoff nor the
    names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Chiaia BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
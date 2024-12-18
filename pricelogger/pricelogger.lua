require 'pack'
require 'lists'
require 'strings'
res = require('resources')
files = require('files')
packets = require('packets')

_addon.name = 'pricelogger'
_addon.version = '0.2' --1/23/24 DACK dusted this off, documented for other human beings, thought about adding user-friendliness but then didn't
_addon.author = 'DACK'
_addon.commands = {'pl'}

--the only command it takes is "pl start"
windower.register_event('addon command', function (...)
  local args = T{...}

  if (args[1] == 'start' or args[1] == 'manual') then --adding 'manual' as an alias too, why not
	  
    manually_appraise_your_entire_inventory()
  
  else
  
    print("Use 'pl start' to manually appraise your entire inventory. Otherwise this runs automatically every time you have an appraisal packet. No commands needed!")
  
  end

end)

--automatic logging, the original intended use. runs every time you get an appraisal packet, a.k.a. "every time you sell something"
windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

  if id == 0x03D then -- Appraisal Response
 
    --figure out what the item is
    local packet = packets.parse('incoming', original)
    local item = windower.ffxi.get_items(0, packet['Inventory Index'])
 
    --if the item isn't, then end (this should not be possible as far as I know, perhaps if you manage to sell with an unloaded inventory without crashing ffxi?
    if not item then
      return
    end

		--for human convenience, get item name
		ItemName = res.items[item['id']].name

    --then write the result to the hardcoded output location.
		files.append('output.txt','Item ID: ' .. item['id']  .. ' Item Name: ' .. ItemName .. ' Item Price: ' .. packet['Price'] .. string.char(10))
		--that string.char is a newline character, the windower documentation is not accurate about whether append natively adds a newline (the third parameter "flush" = true doesn't do it either)
		--the first parameter is output location - currently hardcoded to append to output.txt in the same folder as this addon, and create it if it doesn't exist obviously
		
    end

end)

--todo: use actual lua knowledge + matching item ID (better yet, name) + http://www.lua.org/pil/21.1.html to set up a way to remove duplicate logging

--for manual use, if so desired, dunno why you'd want to but it was good for me when I was testing other unrelated things testing
function manually_appraise_your_entire_inventory()
  
  --get inventory
  InventoryTable = windower.ffxi.get_items(0)
  InventoryCount = windower.ffxi.get_bag_info(0).count
  
  --loop over inventory
  for i = 1, InventoryCount, 1 do
    ItemID = windower.ffxi.get_items(0, i).id
	  ItemCount = windower.ffxi.get_items(0, i).count
	  ItemSlot = windower.ffxi.get_items(0, i).slot

    --send shop appraisal packet for this item
    windower.packets.inject_outgoing(0x84,string.char(0x84,0x06,0,0)..'I':pack(ItemCount)..'H':pack(ItemID)..string.char(ItemSlot,0))
  end

end
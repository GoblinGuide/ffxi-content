--TODO: FPS uncapped makes this explode because it currently refreshes every 15 frames. don't do that, may fix it later.
--thinking to look at system time instead... vanilla lua only has os.clock which works at the second level? absolutely not keeping a loop running nonstop.

_addon.name = 'Wallfacer'; --get it? because you can see whether the mob is facing the wall. those books had good ideas but the characters were two-dimensional. heh.
_addon.version = '0.2.1'; --20250303 thought about a lot of stuff, put a lot of "todo"s in, got a list of mobs, working on it
_addon.author = 'me';
_addon.commands = {'wf'}; --there's no commands other than the testing function for myself, so this shortcut is short so that I can get there faster

res = require('resources') --used to get zone name
packets = require('packets') --"nice ffxi" "thanks! it has packets." I'm not actually using this but that joke lives rent-free in my head
texts = require('texts') --used for the gui
require('logger') --used to generate in-game chat debug text. I prefer this to just using a naked windower.add_to_chat() but you can do that instead if you want and have more options for colors and formatting.
require('tables') --I'm gonna be honest with you: I have no idea whatsoever whether I need to include this. which of the T{} functions can you do without it?

--OPTIONS SECTION
--update the GUI only this many frames. remember that ffxi natively runs at 30 fps, windower "config" plugin can instead do 60 or uncapped.
HowManyTicksToUpdate = 15 --currently default to 1/2 second on native fps, 1/4 seconds with 60 cap
count = 0 --will be used to track time for the GUI display, initializing as an integer juuust in case

--set this to "false" to see Maquette Abdhaljs-Legion (A) instead of MAQUETTE ABDHALJS-LEGION (A)... except that the zone name in res\zones.lua is actually MAQUETTE ABDHALJS-LEGIONA. eyy, da legiona, am boo skah day.
ZoneNameUpperCase = true

--set this to "true" to get debug logging output to the in-game chat log. you definitely don't want to, but I do when I'm testing.
DebugVariable = false

if DebugVariable then
	notice('Wallfacer dot lua loaded. Debugging is currently ON.')
end

--these settings define the visible box. feel free to change as desired, you shouldn't break anything.
windowSettings = T{}
windowSettings.pos = {}
windowSettings.pos.x = 50 --not quite at the left edge of the screen
windowSettings.pos.y = 375 --slightly below the windower console on my monitor, obviously varies by resolution. if you use consolebg it'll make this impossible to see when the console is open without this number being much higher than 0.
windowSettings.bg = {}
windowSettings.bg.alpha = 175 --this is opacity ("alpha" as in brightness of the box background) - 255 is opaque, 0 is completely transparent
windowSettings.bg.red = 5
windowSettings.bg.green = 5
windowSettings.bg.blue = 5 --all three of RGB identical means we're on the B-W line. traditional roguelike aesthetic is black background, white font so I went with that. change as desired.
windowSettings.bg.visible = true --yes, you can make the background invisible. no, you don't want to. trust me, it's ugly.
windowSettings.flags = {}
windowSettings.flags.bold = true --unbold font looks really awful in these ugly GUI boxes, but hey, you do you
windowSettings.flags.italic = false
windowSettings.flags.draggable = true --lets you click-and-drag the window with the mouse. this is against the spirit of a true MUD from 1995 but much funnier.
windowSettings.padding = 2 --controls the margin around the edge of the box. this is good to know about even if you probably shouldn't mess with it too much. I wonder why it seems like horizontal is fatter... does the color have width?!
windowSettings.text = {}
windowSettings.text.size = 11 --12 looks so much wider than 11 for some reason that I opted to go with a size I do not normally use, although I guess Word defaults to 11 these days which is weird
windowSettings.text.font = 'Courier New' --courier is the calligraphy of my people (it's desirable because it's fixed width, I just can't resist Roast Beef quotes)
--windowSettings.text.alpha = 255 --setting this to any number doesn't seem to do anything? suspect it has to be defined in the actual lines of text we're displaying.
--windowSettings.text.stroke.alpha = 255 --same, and commenting these out doesn't change anything either, so not just ignoring the number but the full presence of the variable.

--this function, unsurprisingly, creates a new text box. see roller.lua and omen.lua for functional examples, and my own sandworm.lua for barely functional but possibly more instructional examples
info = texts.new(windowSettings)

--create the entire HUD box to be displayed
function create_HUD_box()

  --get the zone and time and convert them to the format we want
  update_nonmob_information()

  --TODO: ABSOLUTELY going to nethack-style pick a letter for each base mob sprite. it's gonna be so exciiiiiiting 
  create_mob_information_table()

  --TODO: figure out how I'm going to read the info table and define which cell goes where, likely into a 24x24 table
  read_mob_information_table()

  --top line displays the fixed info. this line has to be the same length as everything else, so it's the one that sets the length for everything else.
  info_display = ' \\cs(255, 255, 255)' .. 'ZONE: ' .. CurrentZone .. 'TIME: ' .. TimeString .. '. ' .. '\\cr \n'
  --that's "set a color" (white) concatenate "text" concatenate "line break characters - both a carriage return and a newline"

  --after this, create the rest of the HUD one line at a time
  --ultimately creates a 49x26 box. top row's a header, player fixed in the center cell, so 48x25 for mobs. you can change this as desired but I'm hardcoding these assumptions.
  --mob array goes to ~52.5 yalms, so double-spaced horizontal gives us 2 yalms per 1 vertical cell/2 horizontal cell, covers 50 in each direction and can ignore the stragglers.
  for i = 1, 25, 1 do
    
	--TODO: once the table of defined cells is created, make this programmatically generate the HUD (which is the easy part, frankly, though colors will be a thing to determine)
    info_display = info_display .. '. . . . . . . . . . . . . . . . . . . . . . . .'

	--after all content is loaded into this line, add a line break because we're done with that line
	info_display = info_display .. '\\cr \n'

  end

end

--zone, time... I could do day as well but this line is actually the one setting the width in case anyone fires it up on the Silver Sea route to Al Zahbi (lol.)
function update_nonmob_information()
  
  --get current zone name
  CurrentZone = res.zones[windower.ffxi.get_info().zone].english --pull directly from the "res" data files to get the name, which is always a string of displayable text, no worries there.
  --note that this is a slightly different name than what displays when you zone in. see https://github.com/Windower/ResourceExtractor to try to figure out why! there's many zone names per zone.
  
  --get current vana'time
  CurrentTime = windower.ffxi.get_info().time --this returns the number of minutes since midnight, because windower, because ffxi.
  CurrentHour = math.floor(CurrentTime / 60) --get the hour (int, 0-23)
  CurrentMinute = (CurrentTime % 60) --get the minute (int, 0-59)

  --convert each of hours and minutes into a guaranteed string of length 2
  if CurrentHour < 10 then
    CurrentHourString = '0' .. tostring(CurrentHour)
  else
    CurrentHourString = tostring(CurrentHour)
  end

  if CurrentMinute < 10 then
    CurrentMinuteString = '0' .. tostring(CurrentHour)
  else
    CurrentMinuteString = tostring(CurrentHour)
  end

  --concat the two into a string of fixed length 5
  TimeString = CurrentHourString .. ':' .. CurrentMinuteString

  if DebugVariable then
    notice('Current zone is: ' .. CurrentZone .. '. Current time is: ' .. tostring(CurrentTime) .. ', a.k.a. ' .. TimeString)
  end

  --pad zone length to 30 - maximum English zone length is 28, "Silver Sea route to Al Zahbi"
  for i = 1, (30 - string.len(CurrentZone)), 1 do
    CurrentZone = CurrentZone .. ' ' --add one trailing space over and over until we hit length 30
  end

  --if the "zone name in upper case" setting is on, respect it
  if ZoneNameUpperCase then
    CurrentZone = string.upper(CurrentZone)

    if DebugVariable then
      notice('Converted name to uppercase: ' .. CurrentZone)
    end
	
  end

end
	  
--pull info for every mob in loading range (~52.5 yalms) directly from the game. doesn't do anything with it until the next function.
function create_mob_information_table()

	RawMobArray = windower.ffxi.get_mob_array()

	--TODO: save all this output to a table, rather than spitting it out to the chat log and not recording it, now that I know that at least some of it is working
	for index, mob in pairs(RawMobArray) do

    --index is numeric, and seemingly fixed across the entire array
    --each "mob" is the entire table of windower.ffxi.get_mob(), so we can reference, for example, mob.id

    notice('test: mob.id=' .. tostring(mob.id))
    notice('test: mobname: ' .. tostring(Mob.name))
    notice('test: coordinates: ' .. tostring(mob.x) .. ', ' .. tostring(mob.y))
		notice('test: actual distance: ' .. tostring(get_distance(mob.x, mob.y)))
    notice('test: spawn type: ' .. tostring(mob.spawn_type))
	  notice('test: heading: ' .. tostring(mob.heading))
    notice('test: facing: ' .. tostring(mob.facing))
 
    
	end 

end

--takes the information table that has already been created and formats it to display in the HUD
function read_mob_information_table()

  --TODO: literally all of this. see all notes below.

  --loop over all mobs and:
  --the mob's position relative to us tells us which cell of the GUI to put it in

  --TODO: we have name->model, use that to go model->family (and hardcode the exceptions), then family->aggro
  --TODO: get a list of nethack monster types to populate the monster list
  --sight aggro range is 15 yalms, 60 degree cone (ffxiclopedia says "60-75 degree"/bg says "60 degree", say a cone (1/6 of 2pi radians) out to 15 yalm distance)
  --sound aggro range is 8 yalms, circle (circle of radius 8, which will look like an oval thanks to the 2:1 compression)
  --blood aggro range is 20 yalms, circle (bg says 8/15/20 for yellow/orange/red hp?), this one we can actually hardcode by mob type without issues I think (sheol gonna get me... but names work?)
  --since we have 3 we can use R, G, B and every combination thereof to visually distinguish (blood is red. for sure. that means sight is... blue, not green. arbitrarily.)

  --TODO: handle case where multiple entities are in the same cell 
  --priority ordering: attackable mob > non-attackable mob (ex. chigoe) > interactable NPC (ex. home point) > never-interactable NPC (ex. environmental abyssea soldiers/mobs)

  --spawn_type = 16 is something. 14 is something else. oh, per windower discord:
  --bit 1    PC
  --bit 2    NPC
  --bit 3    Party
  --bit 4    Alliance
  --bit 5    Monster [note: this is 0x0010 in hexadecimal, see https://github.com/lili-ffxi/FFXI-Addons/blob/master/tellapart/tellapart.lua line 133 where spawn_type references it]
  --bit 6    Object -- No Nameplate (interactables like Doors, ???, etc)
  --bit 7    Airship
  --bit 8    LocalPlayer
  --Trust is 14, NPC in party and alliance by definition.
  --16 is 010000 i.e. a monster, which I believe is the canonical "is a monster" definition?
  --another PC will be any of 1, 5, 9, 11 depending on party/alliance membership relative to self. self is always 13 because you are always in a party and in an alliance with yourself.

  --entity_type and target_type also exist, the former possibly only for campaign npcs? one has NPC for trust, there's also "player", "self", "monster" that doesn't always work
  --target_type per windower discord:
  --{
  --    PC = 0,
  --    NPC = 1,
  --    PARTY = 2,
  --    ALLIANCE = 3,
  --    ENEMY = 4,
  --    OBJECT = 5,
  --    ELEVATOR = 6,
  --    SHIP = 7,
  --    ALLY = 8,
  --    PLAYER = 9,
  --    FELLOW = 0x0B,
  --    TRUST = 0x0C
  --};

  --TODO: "you see a X" message on an extra row under the thing for when something moves into aggro range/a user-configurable range nearby?
  --TODO: "the X is looking at you" might be hilarious too for when something goes from not looking at you to looking at you slightly out of aggro range
  --TODO: test annoying noise when you should be getting aggro? this might be a bridge too far but I think it's hilarious

  --end loop over all mobs

  --TODO: after mobs, populate NPCs
  --special trust handling? unlikely to be necessary except avoid model 0 and go by target_type instead. is ally (target_type = 8) things like wyvern and carbuncle?


end

--display the GUI
--note: this is "postrender", i.e. "done immediately after every rendering tick".
--other options are "load" (on addon load, so only once ever), "status change" which includes zoning <-> idle, "zone change", "lose/gain buff", "job change"
windower.register_event('postrender', function()
	
	--this is the most elegant way I've seen to throttle it. props to zyn and also pointwatch.lua which uses very similar code. modular arithmetic is fun.
	if count % HowManyTicksToUpdate == 0 then 
		count = 0 --reset count because we don't care about the raw count, no sense memory leaking very slowly
    	create_HUD_box()
	end

	--then increment the count by 1 for this tick
	count = count + 1

end)

--determine what exactly we're looking at
function can_attack_mob(mob_id)
	
	--Is this object an actual enemy?
	local mob = windower.ffxi.get_mob_by_id(mob_id)
	if not mob or mob.id == 0 or not mob.is_npc or mob.in_party or not mob.valid_target then
		return false
	end

	--is the target a monster? see above notes on this variable.
	if mob.spawn_type ~= 16 then
		return false
	end

	--Is the mob actually alive? It's still in the array even if it's got 0 HP sometimes.
  --Valid_Target should handle that but it does not always, unsure why (per windower discord, valid_target is "can you target it and have it show up as your target in the bottom right")
	if mob.hpp <= 0 then
		return false
	end

	return true

end

--gets the distance between two points (while the z-dimension does exist, the only thing it does is a height check for "can attack" and I don't know how mob aggro works with that)
function get_distance(x_one, y_one, x_two, y_two)
	
  --if a second point isn't passed in, assume that I meant "distance to the player", because I guarantee I'll slip up and do this at some point
  if not x_two or not y_two then
    local me = windower.ffxi.get_player().id
    local x_two = me.x
    local y_two = me.y
  end
	
	return math.sqrt(math.pow(x_one - x_two, 2) + math.pow(y_one - y_two, 2))
end

--calculates the angle needed to turn from the point (x_two, y_two) to be facing point (x_one, y_one), in radians
function get_radians_between(x_one, y_one, x_two, y_two)

  --if a second point isn't passed in, assume that I meant "the player", because, again, mistakes will be made
  if not x_two or not y_two then
    local me = windower.ffxi.get_player().id
    local x_two = me.x
    local y_two = me.y
  end

  local x_diff = x_two - x_one
	local y_diff = y_two - y_one

  --please note that this relies on ffxi using old lua: per https://www.lua.org/manual/5.3/manual.html#8.2 the atan2 function was deprecated. not gonna fix, since we are in fact using old lua.
	return math.atan2(x_diff, y_diff) + math.pi / 2
end


--TODO, BUT A BIG SECRET: it's gonna be way more efficient to not use this and hardcode ffxi-supported aggro ranges. so I'm gonna do that eventually. but I'm keeping this just in case.
--calculates whether the point (point x, point y) is within the bounds of an arc of the given radius centered at the center (center x, center y)
--since a circle is just an arc of angle 2pi this handles it just as well as a cone, which is very clever and I didn't come up with it myself despite it being trivial geometry
function within_arc_area(center_x, center_y, radius, angle, point_x, point_y)

  --first, pretend the center is zero. this saves doing more arithmetic later, so it's a net time gain
  relative_x = point_x - center_x
  relative_y = point_y - center_y

  --three things to check, which we'll do in four cases because I'm an idiot:
  --1: is it within "radius" distance?
  if (relative_x)^2 + (relative_y)^2 > (radius)^ 2 then
    return false
  end

  --once we know it's within distance, if we're looking at a circle (two pi radians or greater), it's within the area
  if radius >= 2 * math.pi then
    return true
  end

  --2: if we have an actual arc, is the point NOT "before" the start of the arc
  --todo: confirm this properly returns negative
  if get_radians_between(center_x, center_y, point_x, point_y) < -(angle / 2) then
    return false
  end
  
  --3: same condition, is the point NOT "after" the end of the arc
  --todo: confirm this also works
  if get_radians_between(center_x, center_y, point_x, point_y) > (angle / 2) then
    return false
  end

  --if we got here we haven't eliminated ourselves yet i.e. we're good, inside the arc
  return true

end

--hiding at the bottom (ctrl-end makes this one of the most accessible locations, as I once learned from a very angry man) - access to the testing function that can be changed as needed
windower.register_event('addon command', function (...)
	
	args = T{...}
	command = args[1]
	
	if command == 'test' then

		notice('Starting the testing function.')
		testing_function()
    
	else

		notice("The only supported command is 'test', to test things. I know this isn't very helpful. It should be intuitive, please do let me know why it isn't.")

	end

end)

--testing function: currently not used for anything
function testing_function()

	notice('Debug: Testing function has been called.')

	notice('Debug: Testing function complete.')
	
end
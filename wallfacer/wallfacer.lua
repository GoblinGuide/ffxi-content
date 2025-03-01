--secret requirement: FPS uncapped makes this explode because it currently refreshes every 15 frames. don't do that. I can fix it later.

_addon.name = 'Wallfacer'; --get it? because you can see whether the mob is facing the wall. those books had good ideas but the characters were two-dimensional. heh.
_addon.version = '0.1.0'; --20250301 made GUI exist. very large list of functionality left
_addon.author = 'me';
_addon.commands = {'wf'}; --there's no command other than the testing function for myself, so this shortcut is short so that I can get there faster

res = require('resources') --used to get zone name
packets = require('packets') --"nice ffxi" "thanks! it has packets." I'm not actually using this but that joke lives rent-free in my head
texts = require('texts') --used for the gui
funlib = require('functionlibrary') --see addons\libs\functionlibrary.lua - used to get mob information because I didn't want to reinvent the wheel every time and had the code lying around
require('logger') --used to generate in-game chat debug text. I prefer this to just using a naked windower.add_to_chat() but you can do that instead if you want and have more options for colors and formatting.
require('tables') --I'm gonna be honest with you: I have no idea whatsoever whether I need to include this. which of the T{} functions can you do without it?

--OPTIONS SECTION
--update the GUI only this many frames. remember that ffxi natively runs at 30 fps, windower "config" plugin can instead do 60 or uncapped.
HowManyTicksToUpdate = 15 --currently default to 1/2 second on native fps, 1/4 seconds with 60 cap
--TODO: add uncapped fps compatibility that looks at system time instead... vanilla lua only has os.clock which works at the second level? absolutely not keeping a loop running nonstop.
count = 0 --will be used to track time for the GUI display, initializing as an integer juuust in case

--set this to "false" to see Maquette Abdhaljs-Legion (A) instead of MAQUETTE ABDHALJS-LEGION (A)... except that the zone name in res\zones.lua is actually MAQUETTE ABDHALJS-LEGIONA. eyy, da legiona, am boo skah day.
ZoneNameUpperCase = true

--set this to "true" to get debug logging output to the in-game chat log. you definitely don't want to, but I do when I'm testing.
DebugVariable = true

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

  --TODO: if the mob info table stores model I'm ABSOLUTELY going to nethack-style pick a letter for each base mob sprite. it's gonna be so exciiiiiiting 
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

  if DebugVariable then
    notice('Current zone is: ' .. CurrentZone .. '. Current time is: ' .. tostring(CurrentTime) .. '.')
  end

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

	--TODO: loop over the raw mob array, it's something about pairs I think
	--TODO: save all this output to a table, rather than just overwriting it instantly
	--TODO: do we want to keep things that are not attackable? is funny to have A Home Point or Some Guards In Jeuno. yeah definitely.
	for i, j in pairs(RawMobArray) do
		
		MobID = i
		MobName = windower.ffxi.get_mob_by_id(i).name
		Distance = windower.ffxi.get_mob_by_id(i).distance
		Heading = windower.ffxi.get_mob_by_id(i).heading
		Facing = windower.ffxi.get_mob_by_id(i).facing
		MobX = windower.ffxi.get_mob_by_id(i).x
		MobY = windower.ffxi.get_mob_by_id(i).y
		Model = windower.ffxi.get_mob_by_id(i).models.1 --is this [1]? either way I think it's the best we can do - can't really determine aggro type from that usually... without hardcoding! ha HA! god help me.

		notice('TESTING: Mob ID/Name: ' .. tostring(i) .. '/' .. MobName .. ', Distance: ' .. tostring(Distance) .. ', Heading: ' .. tostring(Heading) .. ', Facing: ' .. tostring(Facing) .. '.')
	end 

end

--takes the information table that has already been created and formats it to display in the HUD
function read_mob_information_table()

  --TODO: literally all of this.

  --the mob's position relative to us tells us which cell of the GUI to put it in

  --then define aggro range per mob
  --sight aggro range is 15 yalms, 60 degree cone (ffxiclopedia says "60-75 degree", bg says 60 degree)
  --sound aggro range is 8 yalms, circle
  --blood aggro range is 20 yalms, circle (bg says 8/15/20 for yellow/orange/red hp?), this one we can actually hardcode by mob type without issues I think (sheol will be wrong for the others)
  --since we have 3 we can use R, G, B and every combination thereof to visually distinguish (blood is red. for sure. that means sight is... blue, not green. arbitrarily.)
  
  --TODO: hardcode sight/sound assumptions by mob model, vs just showing both for everything which is not really that good an idea

  --TODO: handle case where multiple mobs are in the same cell 
  --priority ordering: attackable mob > non-attackable mob (ex. chigoe) > interactable NPC (ex. home point) > never-interactable NPC (ex. environmental abyssea soldiers/mobs)

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
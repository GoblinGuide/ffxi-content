require 'pack'
require 'lists'
require 'strings'
res = require('resources')
files = require('files')
packets = require('packets')

_addon.name = 'poslogger'
_addon.version = '0.3' --made it a notice AND a print, not just one
_addon.author = 'DACK'
_addon.commands = {'pl', 'poslogger', 'pos', 'logger'}

--change this number to change how often to log the player's position, in seconds. default is once every ONE second.
DelayVariable = 1

--set this to "true" if you want the addon to also spit things into the windower *and* the in-game chat log.
PrintVariable = true

--defines windower console addon commands
windower.register_event('addon command', function (...)
  local args = T{...}

  if args[1] == 'start' then
    track_path()
  elseif args[1] == 'stop' then
    --the least elegant way to stop - simply reloads the addon - but that's fine
    windower.send_command('lua r poslogger')
  elseif (args[1] == 'single' or args[1] == 'log') then
    --added this, which will log just the current position. code's gonna be a copypaste but that's fine
    log_current_position()
  else
    print("Use 'pl start' to start recording a path. Use 'pl stop' to stop.")
  end

end)

--loop used to track an entire path
function track_path()

  --get starting coordinates
  local X_Coordinate = string.format("%.2f", windower.ffxi.get_mob_by_target('me').x) --formatted as a floating point number with two decimal places
  local Y_Coordinate = string.format("%.2f", windower.ffxi.get_mob_by_target('me').y)

  --first, newline twice and mark the start of the path
  --first parameter is output location - currently hardcoded to append to output.txt in the same folder as this addon - this does NOT create it if it doesn't exist?
  --string.char(10) is a newline character, because the windower documentation is not accurate about whether append actually adds a newline by default (the third parameter "flush" = true doesn't do it either?)
  --see https://www.lua.org/pil/22.1.html for time formatting if you want something other than HH:MM:SS here
  files.append('output.txt',string.char(10))
  files.append('output.txt',string.char(10))
  files.append('output.txt',os.date("%X") .. ' New path started in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))

  if PrintVariable then
    print('Logged: ' .. os.date("%X") .. ' New path started in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))
    notice('Logged: ' .. os.date("%X") .. ' New path started in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))
  end
  
  --hey, let's count the steps! that'll be fun and also make it easier to use them later.
  local LoggingCount = 1

  --this will just be an endless loop.
  --assumptions: we are starting from the first place we want to log. we are going to end this with pl stop or by unloading poslogger.lua by hand.
  while true do

    LoggingCount = LoggingCount + 1

    --sleep the length of time we have configured
    coroutine.sleep(DelayVariable)

    --update location
    local X_Coordinate = string.format("%.2f", windower.ffxi.get_mob_by_target('me').x) --formatted as a floating point number with two decimal places
    local Y_Coordinate = string.format("%.2f", windower.ffxi.get_mob_by_target('me').y)

    --and append it to the next line of the file (ending with a newline)
		files.append('output.txt', os.date("%X") .. ' Step ' .. LoggingCount .. ' in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))
    
    if PrintVariable then
      print('Logged: ' .. os.date("%X") .. ' Step ' .. LoggingCount .. ' in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))
    end

  end

end

--one-off that doesn't loop
function log_current_position()
  
  --get coordinates
  local X_Coordinate = string.format("%.2f", windower.ffxi.get_mob_by_target('me').x) --formatted as a floating point number with two decimal places
  local Y_Coordinate = string.format("%.2f", windower.ffxi.get_mob_by_target('me').y)

  --and record
  files.append('output.txt',string.char(10))
  files.append('output.txt',string.char(10))
  files.append('output.txt',os.date("%X") .. ' Single position recorded in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))

  if PrintVariable then
    print('Logged:'.. os.date("%X") .. ' Single position recorded in zone ' .. res.zones[windower.ffxi.get_info().zone].en .. '. Position: ' .. X_Coordinate  .. ', ' .. Y_Coordinate .. string.char(10))
  end

end


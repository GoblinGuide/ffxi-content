_addon.name    = 'bsm' --Blue Sound Maker
_addon.author  = 'me'
_addon.version = '1.0' --I can't even imagine what else this would do
_addon.command = 'bsm' --irrelevant, there are no commands

require('chat') --to read chat

--using (original, mode) and (original, original_mode) both failed. okay then. we'll also add "modified" and not modify anything
windower.register_event('incoming text', function(original, modified, mode)
    
    --what even IS mode 129? I expected this to be 121 (exp gained message, same color)... but this functions, so it's fine
    if original:match('learns') and mode == 129 then

        windower.play_sound(windower.addon_path..'sounds/UnknownBlueMagicLEARNED.wav')

    end

end)

--automatically unload when changing off of BLU to any other job. I do not care about having this running while /blu. you can fix this if you do.
windower.register_event('job change', function()
    
    --this is blue mage
    if windower.ffxi.get_player()['main_job_id'] ~= 16 then

        windower.send_command('lua u bsm')

    end
    
end)
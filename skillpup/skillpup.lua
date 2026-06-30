--ASSUMPTIONS:
--1) You are TARGETING your current Deploy target at all times. I recommend using /lockon.
--2) AutoPUP is being used for maneuvers. This doesn't do those. If you aren't, that's fine, this doesn't break, just less efficient skillups.

_addon.author = 'DACK'
_addon.commands = {'skillpup'}
_addon.name = 'SkillPUP'
_addon.version = '0.1.0'

--configurable! this is high, because at lower levels 20% of your MP might be less than one spell (not likely, but wanted to be careful)
pet_mp_percentage_resummon_threshold = 20

require('tables') --this handles T{} right?

--on startup, do nothing
currently_active = false

windower.register_event('addon command', function (...)

  --don't do anything if we're not on pup (putting it here so you can load it in town and then change jobs, etc)
  if (windower.ffxi.get_player().main_job ~= "PUP") then

    windower.add_to_chat(160, "You're not on Puppetmaster main job! Unloading SkillPUP.")
    windower.send_command("lua u skillpup")

  end

  --now that we know we're on pup, parse command and act accordingly
  local args = T{...}

  if args[1]:lower() == "start" then

    windower.add_to_chat(160, 'Starting SkillPUP.')

    currently_active = true
    
  elseif args[1]:lower() == "stop" then

    windower.add_to_chat(160, 'Stopping SkillPUP.')

    currently_active = false

  else

    windower.add_to_chat(160, 'SkillPUP: Recognized commands are "start" and "stop". Doing nothing.')

  end

  --after toggling, if we're active, keep doing it
  if currently_active then

    while true do

      summoning_loop()

    end

  end

end)

--main loops, runs forever
function summoning_loop()

  --until I get this working, just use a timer
  --[[
  pet_info = windower.ffxi.get_mob_by_target('pet')

  pet_mp_percentage = windower.ffxi.get_mob_by_target('pet').mpp

  --if below threshold, resummon pet and re-Deploy it
  if pet_mp_percentage < pet_mp_percentage_resummon_threshold then

    resummon_pet()

    --this is where I made the assumption that you already had the thing targeted.
    windower.send_command('input /ja "Deploy" <t>')

  end

  --wait five seconds to check pet MP again.
  coroutine.sleep(5)

  --]]

  --bad loop for now
  coroutine.sleep(120) --two minutes? I guess?
  windower.add_to_chat(160, 'Timer hit. Resummoning.')

  windower.send_command('input /ja "Deactivate" <me>')
  coroutine.sleep(2) --have to wait for puppet to disappear before we can activate it
  wait_for_player_idle_status()
  windower.send_command('input /ja "Activate" <me>')
  coroutine.sleep(4) --wait for autopup to do its thing
  wait_for_player_idle_status()
  windower.send_command('input /ja "Deploy" <t>')
  coroutine.sleep(1) --don't say that it should be deployed before it's deployed, that just looks sloppy

  windower.add_to_chat(160, 'Should be redeployed. Sleeping two minutes before repeating.')
  
end

--handles summoning. will use Deus Ex Automata if needed (plus a Repair, but not sure if we want that)
function resummon_pet()

  local pet_hp_percentage = windower.ffxi.get_mob_by_target('pet').hpp

  --deactivate doesn't care about HP percentage, only activate
  windower.send_command('input /ja "Deactivate" <me>')
  coroutine.sleep(2) --this might be overkill, but can't activate until the puppet has disappeared
  wait_for_player_idle_status() --should not be needed but that just means it takes 0 time, not even 0.1

  --could check the cooldown on Activate here instead, but I'm not bothering because we're looping this, so don't even bother checking.
  if pet_hp_percentage < 100 then

    --summon using the only means available to us
    windower.send_command('input /ja "Deus Ex Automata" <me>')
    coroutine.sleep(5) --autopup LIKELY fires here, because it sees Maneuvers off cooldown and a fresh puppet with 0 Maneuvers, but we can't prove it so...
    wait_for_player_idle_status()

    --Deus Ex Automata summons the automaton damaged. Repair it now so it will be at full between that and its own healing for next loop.
    windower.send_command('input /ja "Repair" <me>')
    coroutine.sleep(5) --...put a sleep here too, since we can't read autopup's nonexistent mind
    wait_for_player_idle_status()

  else

    --cool, working as intended
    windower.send_command('input /ja "Activate" <me>')
    coroutine.sleep(5) --if autopup overloads it really and truly does take five seconds
    wait_for_player_idle_status()

  end

end

--exactly what it sounds like - kind of awkward actually because JAs don't have "cast times", but we'll live. as good as it gets afaik?
function wait_for_player_idle_status()

  while windower.ffxi.get_player().status ~= 0 do

    coroutine.sleep(0.1)

  end

end
require('logger') --for some reason, THIS is what's required to support "if S{2, 4, 6, 7}:contains(race)"?

_addon.name = 'pronountrouble' --name stolen from "Rabbit Seasoning" by the late great Chuck Jones and Michael Maltese: https://www.youtube.com/watch?v=XlzCPxxp8Ys
_addon.author = 'me'
_addon.version = '1.0'
_addon.commands = {'pronoun', 'pro', 'pt', 'pronouns', 'pronountrouble'}

--takes any words, ignores arguments, just 'pt' will do it
windower.register_event('addon command', function (...)

  windower.add_to_chat(207, 'Determining pronouns...')

  main_function()

end)

--called by any addon command. returns all the info by calling the other functions. really, this aggregator isn't needed until you want to call this from something else.
function main_function()

  windower.add_to_chat(207, 'Getting party and target arrays...')

  party_array = windower.ffxi.get_party()
  target_array = windower.ffxi.get_mob_by_target('t')
  
  --return information on everyone in the "party", which is actually the alliance. includes yourself.
  if party_array ~= nil then --party array should never be nil, because you are p0 of your own party even when solo... but I had it come up once, somehow?
    windower.add_to_chat(207, 'Outputting party data...')
    coroutine.sleep(0.1)
  
    for i = 0, 2, 1 do
  
      for j = 0, 5, 1 do
        local party_member_index = 10*i + j --"Table keys go from p0-p5, a10-a15, a20-a25" per windower documentation on ffxi.get_party()
        
        if i > 0 then
          party_member_index = 'a' .. party_member_index --prepend "a" for "alliance" if looking at a party beyond the first
        else 
          party_member_index = 'p' .. party_member_index --else, "p" for "party". thanks to lorand at https://github.com/lorand-ffxi/lor_libs/blob/master/lor_ffxi.lua for this trick
        end
  
        local party_member = party_array[party_member_index]
    
        if party_member ~= nil then 
          windower.add_to_chat(207, "Index %s: Named %s, race %s, pronouns %s/%s.":format(party_member_index,party_member.name,party_member.mob.race,determine_pronoun(determine_gender(party_member.mob.race),'subject'),determine_pronoun(determine_gender(party_member.mob.race),'object')))
          coroutine.sleep(0.1)
        end
  
      end
  
    end

  end

  --only return target info if there is a target
  if target_array ~= nil then
    windower.add_to_chat(207, 'Outputting target data...')
    coroutine.sleep(0.1)
    windower.add_to_chat(207, 'Target is named ' .. target_array.name .. ', race is ' .. target_array.race .. '.')
    coroutine.sleep(0.1)
    target_gender = determine_gender(target_array.race)
    windower.add_to_chat(207, 'Target gender is: ' .. target_gender)
    coroutine.sleep(0.1)
    windower.add_to_chat(207, 'Target pronouns are: ' .. determine_pronoun(target_gender,'subject') .. '/' .. determine_pronoun(target_gender,'object') .. '.')
  end

end

--code taken from xivparty / model.lua (https://github.com/Tylas11/XivParty/blob/master/model.lua) 
--local members = T(windower.ffxi.get_party())

--code taken from lor_libs (https://github.com/lorand-ffxi/lor_libs/blob/master/lor_ffxi.lua)
--local pt = windower.ffxi.get_party()
--local party = S{}
--for i = 0, 5 do
--local member = pt['p'..i]
--if member ~= nil then
--party:add(member.name)
--end --end --return party --end

--race values:
--"everything else" 0 - home point, mob, goblins, moogles, maat, cornelia, arciela, yes this will fail for all of those
--hume M 1
--hume F 2
--elvaan M 3
--elvaan F 4
--taru M 5
--taru F 6
--mithra 7
--galka 8

--determines gender given the "race" parameter that the game returns.
--there's no windower function and SE switched the order of mithra/galka relative to the M/F pairs of the three other races so we can't use modulo 2. just group 2467, 1358, 0, "how did this happen"
--noted limitation: dressup. sorry friend. wait for the fantasia. it's coming.
function determine_gender(race)

  if S{2, 4, 6, 7}:contains(race) then
    gender = 'F' --Female (including Mithra) (there's no interactable male Mithra NPC to test on)
  elseif S{1, 3, 5, 8}:contains(race) then
    gender = 'M' --Male (including Galka)
  elseif race == 0 then --includes: Maat, Home Points, ??? points, Moogles, Arciela, Goblins... (any mob, any NPC of non-player-sprites, any random interaction NPC, many other things)
    gender = 'I' --Indeterminate
  else
    gender = 'U' --Unknown (I don't think this will ever hit anything)
  end

  return gender

end

--outputs appropriate type of pronoun (subject, object, possessive, reflexive) given that type and a gender
function determine_pronoun(gender,type)

  pronoun = ''

  --supported types of pronouns:
  --subject (I verb thing)
  --object (give me thing)
  --possessive (it's mine)
  --reflexive (myself)
  
  if gender == 'F' then

    if string.lower(type) == 'subject' then
      pronoun = 'she'
    elseif string.lower(type) == 'object' then
      pronoun = 'her'
    elseif string.lower(type) == 'possessive' then
      pronoun = 'hers'
    elseif string.lower(type) == 'reflexive' then
      pronoun = 'herself'
    end

  elseif gender == 'M' then

    if string.lower(type) == 'subject' then
      pronoun = 'he'
    elseif string.lower(type) == 'object' then
      pronoun = 'him'
    elseif string.lower(type) == 'possessive' then
      pronoun = 'his'
    elseif string.lower(type) == 'reflexive' then
      pronoun = 'himself'
    end
  
  elseif gender == 'I' then

    if string.lower(type) == 'subject' then
      pronoun = 'they'
    elseif string.lower(type) == 'object' then
      pronoun = 'them'
    elseif string.lower(type) == 'possessive' then
      pronoun = 'their'
    elseif string.lower(type) == 'reflexive' then
      pronoun = 'themselves'
    end
 
  elseif gender == 'U' then

    if string.lower(type) == 'subject' then
      pronoun = 'it'
    elseif string.lower(type) == 'object' then
      pronoun = 'it'
    elseif string.lower(type) == 'possessive' then
      pronoun = 'its'
    elseif string.lower(type) == 'reflexive' then
      pronoun = 'itself'
    end
  
  else

    --we should never hit this. so let's go with parsimony and hardcode 'it'. please do contact me if this ever comes up.
    pronoun = 'it'

  end

  return pronoun

end
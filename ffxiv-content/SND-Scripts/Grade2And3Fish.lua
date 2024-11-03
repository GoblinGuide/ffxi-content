--so really this is just Umbral Treader, but reworked for different targets
--like almost all the code is the same. notes are there. don't worry about it.

--Required Starting Location:
--Literally anywhere OTHER THAN locations in the Firmament that are not "the entrance" or "within 7 yalms of Aurvael"

--Required Plugins:
--AutoHook [relevant preset already included in this file]
--Visland [relevant routes already included in this file]
--SimpleTweaks, with tweak "Bait Command" not set to anything other than the default "/bait" (it's fine if it's not currently enabled, the script handles THAT, just don't change it)
--Teleporter, used to teleport to Foundation from anywhere. not necessary if you always start this from inside Firmament/the Diadem
--Lifestream, used to teleport to the Firmament from Foundation. not necessary if you always start this from inside Firmament/the Diadem

--Things I still want to implement before I call this feature-complete:
-- 1) People who can't repair their own gear won't repair their gear here, and we have code to talk to a Mender anyway...
-- 2) I guess I could make it not wait out the entire instance by checking fish count more often. Very low priority.

--Implicit assumption that may, inexplicably, break this somehow if it isn't true:
--1) You didn't start this with the grade 2 achievement, then LOSE it while finishing grade 3. That'd cause an endless loop. It should also be impossible. But I have to document this somewhere.

--visland routes: from the entrance of the Firmament to Aurvael, from the entrance of the Diadem to the grade 2 fishing hole, and from the entrance of the Diadem to the grade 3 fishing hole (in that order, obviously.)
AurvaelRoute = "H4sIAAAAAAAACuVQy07DMBD8FbRn17KT1HF8QzykHsqjAqWAOFhkUS0RGzUbEIry7zjFVSX6B3CbmR2NZmeAK9siGLj3PoLmZBV6QmBQ26/34Dx1YJ4GuAmdIxc8mAHWYKTgSpVyzuABzEzOecbgMcplxrWQ1RhZ8Lg4B6O1YrCyjetjUM4Fg2X4wBY9gYlk4Qm39oVqR5vryf9LS+Vin24TPveXWCSmvdq3Dg/2XTvJ4KINhPsowjbB050jkdseO0p4Cq6to0PixC7D9iz4Jj0tfsQ71+Iy+sTIjiaZSc2zXGRV2kRNv06bFBUvyqxU/3UUqcq8OF5FxoOq9N9f5Xn8BoYngkRkAwAA"
Grade2Route = "H4sIAAAAAAAACuXWS2vcMBAA4L8SdHaG0czo5Vto2pJD+qKwfZCD6arEUNtl12kpy/73jm0laSmFnNf4YEsaBvljPNbBvGq6bGpz2Tbb3J293OntjExlNs2v70Pbj3tTfz6YN8O+HduhN/XBfDD1uReC6MhX5qOpKQlIoqijT7pmdc1yknjU8dDnq0tTJ06Vedds2zvNx4CVuR5+5C73o6ltZa76Me+aL+OmHW9fT/H491zZpG5rfzv8vF/R/Wi2r823fX4MnzepKZ93w5jvU425K48Xc0QZvL3L+7E8T4k3TTs+ZpxGL4bds6HflnfHZfJ92+VrjcNj9a8MRwuE6BYaRpmcQlxoiAApUFonjRUHEjGGhcYqzVRBChMIXPK0RhWbgD2yLSYRnATmWSUhoI1hlSoWQZxehYVB62ZG8QwpeZt4jSyi1eLE2oWFfAQKPLWaubkkbTwRV1kvWhDgafmIiARColBYEgEjhlXWiycHLBQeXCxzsItL1Fbj5MnlQiflwgIozv4BE2IqLhb0K5KnuuBJuTin/UWmk9zsom3Xc6IFxquS0wJaJUzQgiGmBxchLH/pc2eBCSX5VcJE/VEHVIoZhsCrhFtgxEMUPQ//zwVBA0/C5eb4G3LACfxJDQAA"
Grade3Route = "H4sIAAAAAAAACuWVTWscMQyG/0rQeSpsy1+aW2jakEP6RWGblByGrksGOuOw47SUZf97tTvepqUUct45jWWJF83DK3kLb7ohQQsXfbdOw9nlRj5nBA2sup8PuR/LBO3nLbzLU1/6PEK7hU/QvvDWYHTGN3ADrWGLlk2U6FZyWnKa2MadxHlMVxfQMnEDH7p1/yh6hKqB6/w9DWks0OoGrsaSNt2XsurL/dt9vfr7rjYpbU33+ccxI/2I2tfu25Seyg9NiuSrIZd0lCppqMfzQ0UN3j+mqdTzXnjV9eVJcR+9zpuXeVzXf1fz5cd+SNdSp3bNv2RcUAJDxQMZUg5N8OpIxil0SnAtkozVEVUI1sxotEFPMboZjVERma33S0RjFGGMOoaZjHHI1ho7k/FCxkbSbpFkWKGMj41/LBoKRzLOyjip54IxJwUmMnKwgSoYh8QhhArGa4xs/DLBiEdUIFfBGKRI/rdjBIzT/Eww6rTAaJSlwtUx4h+rmev69dajmMkuEkzwSFq76pho0AWuL7YnL5NE7r87Rh70EwFzt/sF6G0aCw0KAAA="

--AH preset: TH -> DH -> normal hook ! bites after 14 seconds, autouse Cordial, autouse Thaliak's Favor, use Prize Catch when over 899 GP (i.e. at 900, so you can PCTH and get 300 GP back right away + one extra AA stack)
AutoHookPreset = "AH3_H4sIAAAAAAAACu1YXW/iOhD9K1Ze7gu7IpSypW/cQFskuq0Kqz5Uq5UbDLFqbOQ4bblV//sd24nzQQjtwmPfujNnJueMPeNh37xBokSAYxUHi6V3/uaNOH5kZMCYd65kQlreUHAVYB4Sdi1EGGVmHTOhnOQx88x1uZ5FksSRYGBq78xwRdh6Rl6Vd+55Le8nXkEuQwfp3Mgkb3ljyNE565eyDh7FM8n5kbiUfYFZDPZBqKjgs80akP67JZwi3jzzR6fEPQ0rkffbn6T/KybIoNB4nJHvnR1O/oazjUGMuUqo9jloo4C/qb6FpeT7P45T+SBKVrrcf5KY3EeEOx2j15CQeWyoHuMsrDdGQSIl4cqpSRUaHlZb1293PyHOmmu1CcZIqPbepk8eRpbWsfUPO4quoyvnFEN/v3lj/kxkZriVVEiqNnkwY+LlBhAhXo8DZ/4TWvyExkD4AbIosvKhHJ1eD/pU/ws6q9tuv7dyX7vd87u+856cFr1lVyXQ7/X93Nspe0s+H5L+bh1zGmWlskdgaR5yBJ30CC5oHI02JN57ZU5Pj3Hp9eeQ+Z67S6dHufnX+IlMI7pQ/2Jq7r82xJlhqnD4BBrhW80iPyJxFtEYregyUigUfMFoqNALVREyM2sWYUbx0z8xusDPQubSHUNkKLqR/KkCNMy1W6woAWh+kq4EuSuNvyML/bkRlmwzo5revpl32jvG8Tsi7vR7Rzl9GBj/kQAr+6T+soPdvlLjGx4MnSZw6QfsHo5rPAeCNMRMJ6gD6A89kynD6+0Xrqahz/r9v67Qd5RVBmE+R+7gzFWBy8UY4kKhR4Lg0ZqjF1CHjGZkRCNsqBbqnPsKF+04tU4veGyvN5S7ZMg67aRVtt+RED4nzWg0VU4HWnxBZaH8B0/M5ubc6sG0XttNm9Wse2hzQtVGr0ri0lKbN9n0Ba81F7eFXGKab1TaMxMaU/G/ZcxHc6qus376ps9oK+NEFApck9H692S8hQqQHSytr5an982rjS9xqo23CBdvpvgalhAJDWtbZ0elalEfqFclbkfValEfql0T+2IFanGVOjZxbchVqOmdBgUi4YrINCfg0yTA29pSWZcSz0lnwOcnQwp/rfQrDjn02nWz0LWJzfZVaV7tMMi8PjYcXelR8CJktv+etDtnulhXQjzdE/xUSZSZ80293j+8ml3tcJmZDlOzZqZXIT9vZjtQuqU1Uj9cP/plW+HXUO6cKin4stryuadJkEWUJG3F71FVBjXrsljzJJ9UrSVtmXtCloTPsdzU0XPOJoUOtEukA+zRuYVrlurgVbXbrDOEfq+SWImV8+iY4tIwFAnwt1YrEYwzSddbRq12ayFL7VrAzr0kA0wTucBhWduE2E0+hh9IedZr/Kq3uyFhGMS2v8MLek15weR3tU2rgx+j2i6LsZmxEl9nniqxHixglgQ4gbc3f97K9gld6e3cLzjyQVQK0mooX04VAZHmh9aHp0sgMSfogm0K0wUyfE2Xr+nyNV2+pkvNdIH/qrG7TLrIPziDnTAPv9//B4mfuBGfFgAA"

--Make sure we're on fisher, leave the Diadem if we're in it, configure Autohook presets, and get to Aurvael's desk
function InitialStartup()
  yield("/echo Debug: Initial startup function begun.")

  --Make sure we're a fisher, since we can't guarantee everyone's gearset is named identically to use "gs equip" instead of yelling at the user, sadly
  if GetClassJobId() ~= 18 then
    yield("/echo You're not currently a Fisher! Please change to FSH and restart the script.")
    yield("/snd stop")
  else end
  
  --If we are in neither the Diadem nor the Firmament, teleport to Foundation and then aetheryte to The Firmament (this accounts for being in Foundation but not near an aetheryte shard)
  if (not IsInZone(886)) and (not IsInZone(939)) then
    yield("/echo Began Treader script outside the Diadem/Firmament area. Teleporting to Foundation aetheryte.")
    yield("/tp Foundation")
    yield("/wait 6") --Wait for Teleport cast to finish before checking for loading conditions, by definition
    
    --Wait for teleport to finish
    while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish teleporting to Foundation aetheryte.")
     yield("/wait 2")
    end
    
    --Make sure that the aetheryte has loaded too, just in case. This is three conditions because I have no clue how nil works in lua
    while ((GetDistanceToObject('Aetheryte') == nil) or (GetDistanceToObject('Aetheryte') == '') or (GetDistanceToObject('Aetheryte') == 0)) do
      yield("/wait 1")
    end  
    
    yield("/echo Debug: Making sure we're in range to interact with the Foundation aetheryte.")
    --Hardcoded: rounded output of GetObjectRawXPos('Aetheryte'), because the aetheryte is huge so I don't actually care about the seven decimals of precision
    AetheryteX = -64
    AetheryteY = 11
    AetheryteZ = 44
    
    --Enter the Firmament
    while GetDistanceToObject('Aetheryte') > 6.9 do --Seven is interaction distance, and Lifestream adds the Firmament to its range ~12 menu but there's something wonky here and I'm trying to squash it with this loop
      XToMoveTo = AetheryteX + (GetPlayerRawXPos() - AetheryteX)/2 --Zeno's aetheryte
      YToMoveTo = AetheryteY + (GetPlayerRawYPos() - AetheryteY)/2 --Who said a classical education was useless?
      ZToMoveTo = AetheryteZ + (GetPlayerRawZPos() - AetheryteZ)/2 --...next I'll have to implement the Sieve of Eratosthenes or something
      yield("/visland moveto " .. XToMoveTo .. " " .. YToMoveTo .. " " .. ZToMoveTo)
      yield("/wait 1") --The aetheryte hitbox is really big. This runs directly into it at any reasonable range, but sometimes, somehow, you end up NOT in a reasonable range, which is why this is a loop and not a one-off
      yield("/visland stop")
    end
    
    --Use Lifestream to enter the Firmament
    yield("/echo Debug: Using Lifestream to enter the Firmament.")
    yield("/li Firmament")
    yield("/wait 5")
  
    --Wait for teleport/zoning to finish
    while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
    end
  
  --Otherwise, if we started from in the Diadem, leave it, thereby entering the Firmament
  elseif IsInZone(939) then
    yield("/echo Began Treader script inside the Diadem. Exiting the Diadem and reentering.")
	  
    --Exit the Diadem
	  yield("/wait 1") --Superstition, honestly. I think we would be fine without this.
    LeaveDuty()
    yield("/wait 2")
    
	  --Wait to be in the Firmament
    while (not IsInZone(886)) or (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
    end
    
  else

    --It is impossible to "not be in the Diadem", "not be in the Firmament", and "not be in either the Diadem or the Firmament" simultaneously.
    --Therefore, if we get here, we are already in the Firmament, so we do nothing. This is why you can't start this from any random location in the Firmament... well, vnavmesh will let you. But I didn't implement it yet.
    yield("/echo Debug: We should be in the Firmament. Going to start trying to queue now.")
  end
  
  --Now we're a Fisher who is either at the entrance to the Firmament or at Aurvael's desk. Either way, we're safe to proceed.
  SetAutoHookState(true) --Enable AutoHook
  DeleteAllAutoHookAnonymousPresets() --Cleans up after any previous iterations
  UseAutoHookAnonymousPreset(AutoHookPreset)
  yield("/echo AutoHook preset loaded. Please remember to delete it when you're done!") --Or don't, I'm not the boss of you.
  
  --Enable the simpletweaks command to change bait with "/bait", in case it was not already enabled. This only enables, so if it's already enabled, do nothing. Turns out this chat command exists? Wild.
  yield("/tweaks e baitcommand")
  
  --Lie about where we were fishing before we started so that we pick a new point properly. This should be unnecessary, but I don't know how lua evaluates "nil == nil" and frankly I'm afraid to ask, so initialize them here.
  OldFishingPoint = 1
  NewFishingPoint = 1
end

--Enter the Diadem
function EnterDiadem()
  yield("/echo Debug: Entering the Diadem.")
  if IsInZone(886) then --If we're in the Firmament...
  
  yield("/wait 2") --Wait for Aurvael to load, which has actually come up before somehow
  
  --Move to Aurvael before you do anything else.
  if GetDistanceToObject('Aurvael') > 6.9 then --Seven is the interaction distance, which I did not know until I started testing this
    yield("/visland exectemponce " .. AurvaelRoute) --Move to Aurvael. There's no reason for this to be a variable, but hey, maybe you like to start from the Kupo of Fortune sNPC and you can modify this yourself
    yield("/wait 1") --Start moving, just in case the IsMoving() check is too fast to for visland to have started moving, I worry about these things
    
    while IsMoving() do --Wait until we are done moving
	    yield("/wait 1")
	  end
  
  else
  end
   
    --Repair your gear outside of Diadem if it can be repaired (That's what the 99's for, this is "repair everything at 99% or lower durability")
	--Assumption: you can repair your own stuff. I guess that's a silent assumption here I should document, huh?
    if NeedsRepair(99) then
  
      while not IsAddonVisible("Repair") do
        yield("/generalaction repair")
        yield("/wait 0.5")
      end
  
      yield("/pcall Repair true 0")
      yield("/wait 0.1")
  
      if IsAddonVisible("SelectYesno") then
        yield("/pcall SelectYesno true 0")
        yield("/wait 0.1")
      end
  
      while GetCharacterCondition(39) do
        yield("/wait 1")
      end

      yield("/wait 1")
      yield("/pcall Repair true -1")
    end
    
    --"While we are not queueing, try to queue"
    while GetCharacterCondition(34, false) and GetCharacterCondition(45, false) do
      
      if IsAddonVisible("ContentsFinderConfirm") then
        yield("/pcall ContentsFinderConfirm true 8")
      elseif GetTargetName()=="" then
        yield("/target Aurvael")
      elseif GetCharacterCondition(32, false) then
        yield("/pinteract")
      elseif IsAddonVisible("Talk") then
        yield("/click talk")
      elseif IsAddonVisible("SelectString") then
        yield("/pcall SelectString true 0")
      elseif IsAddonVisible("SelectYesno") then
        yield("/pcall SelectYesno true 0")
      end
      
      yield("/wait 0.5")
    end
    
    --Wait until we start entering, then wait until we're done entering, then wait 3
    while GetCharacterCondition(35, false) do
      yield("/wait 1")
    end
    
    while GetCharacterCondition(35) do
      yield("/wait 1")
    end
    
    yield("/wait 3")

  end

end

--move to the location we'll be using to fish the whole time, but not at any of the fishing holes (which means no amiss worries)
function InitialDiademEntryMove()
  yield("/echo Debug: We have entered the Diadem. Moving to the fishing hole.")
  
  --Record our entry time. Instance timer is 180 minutes = 3 hours > 40 minutes = 2400 seconds, then leave to dodge the amiss timer (Should have been easily fixed with jiggle movement. Wasn't. So I just did this instead.)
  DiademEntryTime = os.time()
  
  --Check our bait count and restock if are below 500 of a bait we are actually using for the next forty minutes. Yes, these IDs are in decreasing order. Hoverworm is for Grade 2, which comes before Grade 3 everywhere else here.
  HoverwormCount = GetItemCount(30281) --Not my fault it's the right bait for the earlier achievement! Blame SE!
  CraneFlyCount = GetItemCount(30280)
  
  --Only restock if we need more of a bait we ever plan to actually use again.
  if (HoverwormCount < 500 and Grade2Fish < 300) or (CraneFlyCount < 500 and Grade3Fish < 300) then
    RestockBait()
  else
  end
  
  --Run to the fishing hole (we are either at the diadem entry point or the Mender and this route works either way.)
  if Grade2Fish < 300 then
    
    ActiveFish = "Grade 2" --Track this now so I can report out properly later.
	  StartingFishCount = GetItemCount(30009) --Grade 2 Artisanal Skybuilders' Skyfish. Again, track this now, report out properly later.
    
    yield("/bait Diadem Hoverworm") --Equip the proper bait NOW so we don't forget to do it LATER.
	  yield("/wait 1")
    yield("/visland exectemponce " .. Grade2Route)

  elseif Grade3Fish < 300 then
    
    ActiveFish = "Grade 3" --See above.
    StartingFishCount = GetItemCount(31596) --Grade 3 Artisanal Skybuilders' Oscar.
    
    yield("/bait Diadem Crane Fly") --See above. You know it came up. Testing comments are written in sweat just like regulations are written in blood. OSHA reportables waiting to happen everywhere.
	  yield("/wait 1")
    yield("/visland exectemponce " .. Grade3Route)

  else

    yield("/echo Somehow we thought we didn't have the achievements, but then we decided we did. This is an error that should never come up. Please let the developer know. Quitting for now.")
    yield("/snd stop")

  end
  
  yield("/wait 5") --Wait for visland to start going, because you're not moving when you're mounting up.
   
  --Wait to finish moving.
  while IsMoving() do
    yield("/wait 2")
  end
  
  --You can't fish while you're mounted. This is awkward, because even when the route on VIsland has "Normal" as movement type, it does not dismount to transition, and even with the "while ismoving" check above, well... yeah.
  while GetCharacterCondition(4) do
    yield("/ac dismount")
    yield("/wait 3")
  end  
  
  yield("/echo Debug: Should have arrived at the intended fishing hole for " .. ActiveFish .. " fish.")

end


function RestockBait()
  yield("/echo Debug: Restocking bait from the Mender")
  
  --Run to the Mender
  yield("/visland moveto -640.3 285.2 -140.1") --Coordinates rounded, obviously. Note that we are always moving here from the Diadem spawn so it shouldn't cause trouble... unless we get stuck on that campfire?
  yield("/wait 5")
  
  --Target the Mender
  yield("/target Mender")
  yield("/wait 0.5")

  --Talk to the Mender, because we can't use the elegant character condition loop for a regular chat menu and we don't know if the user has YesAlready enabled or not
  yield("/pinteract")
  yield("/wait 0.5")
    
  --If YesAlready is not already configured to dump you automatically into "Purchase Items" at the Mender, select it
  if IsAddonVisible("SelectIconString") then
    yield("/pcall SelectIconString true 0")
	  yield("/wait 0.5")
  else
  end
  
  --Purchase Diadem Hoverworms until your inventory has more than 500 of them (i.e. somewhere between 501 and 598, a.k.a. more than enough for the next forty minutes of fishing)
  while (HoverwormCount < 500 and Grade2Fish < 300) do
    yield("/pcall Shop true 0 6 99 0") --Boy, I hope this is the right item ID. I'm like 99% sure it is.
	  yield("/wait 1")
    
    if IsAddonVisible("Shop") then --Again, we don't know if the user has YesAlready configured
      yield("/pcall SelectYesno true 0")
	    yield("/wait 0.5")
    else
    end
    
    HoverwormCount = GetItemCount(30281)

  end

  --Same thing, but for Diadem Crane Flies
  while (CraneFlyCount < 500 and Grade3Fish < 300) do
    yield("/pcall Shop true 0 5 99 0")
	  yield("/wait 1")

    if IsAddonVisible("Shop") then
      yield("/pcall SelectYesno true 0")
	    yield("/wait 0.5")
    else
    end

    CraneFlyCount = GetItemCount(30280)

  end

  --There's not strictly a need to exit the Mender menu since the next step could be unmounted movement, but mounted movement is faster and you can't mount up while you're in the vendor and chat menus
  yield("/pcall Shop true -1")
  yield("/wait 0.5")

end

--Equip the appropriate bait for the fish we're catching and start fishing, then leave after forty minutes have elapsed in this instance.
function FishForFortyMinutes()

  if ActiveFish == "Grade 2" then
    yield("/echo Debug: Fishing for Grade 2 fish.")
  elseif ActiveFish == "Grade 3" then
    yield("/echo Debug: Fishing for Grade 3 fish.")
  else
    yield("/echo Debug: Fishing, but not for either Grade 2 or Grade 3 fish? Please contact the developer. Starting to fish automatically now anyway, in case it was the count that was wrong.")
  end  
  
  --We just pointed ourselves in the correct direction and equipped the correct bait, so once we start casting AutoHook will handle the rest
  yield('/ac "Cast"')

  --Wait until we're about to hit the amiss timer, more or less.
  while os.time() < (DiademEntryTime + 2400) do
    yield ("/wait 1")
  end
  
  yield("/echo Debug: We should hit the amiss timer soon. Stopping fishing and leaving the Diadem to reinstance.")
  
  --Finish your cast before you go, just in case this messes up leaving the instance somehow. I am pretty sure it doesn't when I do it by hand, but I'm paranoid about SND seeing zone changes properly.
  while GetCharacterCondition(6) do
    yield("/echo Debug: Trying to stop fishing. Our current condition is:")
    yield("/echo Debug: Any gathering status: " .. tostring(GetCharacterCondition(6)))
    yield("/echo Debug: Fishing status: " .. tostring(GetCharacterCondition(43)))
    yield("/echo Debug: Mid-animation status: " .. tostring(GetCharacterCondition(42)))
    yield('/ac quit') --Cancel fishing. Apparently there is a vanilla text command for this that everyone but me already knew?! I do literally all my fishing with autohook lol lmao etc
    yield("/wait 1")
  end
  
  --Now that we are done fishing, we must have at least started to put our rod away. Wait for that animation to finish because we are polite, and then leave the Diadem. (You do not need to wait but I don't trust the script...)
  yield("/wait 2")
  LeaveDuty()
	
  --Wait to arrive at the Firmament and do the whole thing over again.
  yield("/wait 2")
  while (not IsInZone(886)) or (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
  end
  
  --Check the number of grade 2 fish you have left to go.
  if ActiveFish == "Grade 2" then
    
	  --"The number we have now" - "the number we had then" = the amount we caught in the interim, i.e. in exactly the previous Diadem instance
	  EndingFishCount = (GetItemCount(30009) - StartingFishCount)
	
	  --Achievement progress = the number of fish we have already turned in to the NPC next to Aurvael whose name escapes me
	  RequestAchievementProgress(2537)
    yield("/wait 1")
    Grade2Fish = tonumber(GetRequestedAchievementProgress()) --I hate lua typing so much even though I absolutely understand why it is the way it is. (This line updates the variable that the loop actually checks!)
	
	  --There's a third category of fish, "we caught them in a previous Diadem instance but did not turn in to the the NPC yet yet". Have to count those as well or we'll fish forever.
	  yield("/echo In the last forty minutes, you caught " .. tostring(EndingFishCount) .. " grade 2 fish for a new grand total of " .. tostring(GetItemCount(30009) + Grade2Fish) .. " grade 2 fish.")
	
	  --As above, we have to count the un-turned-in fish total + the turned-in-fish total to see if we're done yet
	  if (GetItemCount(30009) + Grade2Fish) >= 300 then
      yield("/echo Congratulations! Moving on to grade 3 fish, if you don't already have them, or ending the script now if you do.")
  	else --If we don't have at least 300, we have less than 300.
	    yield("/echo Only ".. tostring(300 - (GetItemCount(30009) + Grade2Fish)) .. " more to go!")
	  end

  --Same logic, but for grade 3 instead.
  elseif ActiveFish == "Grade 3" then

	  --"The number we have now" - "the number we had then" = the amount we caught in the interim, i.e. in exactly the previous Diadem instance
	  EndingFishCount = (GetItemCount(31596) - StartingFishCount)
	
	  --Achievement progress = the number of fish we have already turned in to the NPC next to Aurvael whose name escapes me
	  RequestAchievementProgress(2658)
    yield("/wait 1")
    Grade3Fish = tonumber(GetRequestedAchievementProgress()) --I hate lua typing so much even though I absolutely understand why it is the way it is. (This line updates the variable that the loop actually checks!)
	
	  --There's a third category of fish, "we caught them in a previous Diadem instance but did not turn in to the NPC yet". Have to count those as well or we'll fish forever.
	  yield("/echo In the last forty minutes, you caught " .. tostring(EndingFishCount) .. " grade 3 fish for a new grand total of " .. tostring(GetItemCount(31596) + Grade3Fish) .. " grade 3 fish.")
	
	  --As above, we have to count the un-turned-in fish total + the turned-in-fish total to see if we're done yet
	  if (GetItemCount(31596) + Grade3Fish) >= 300 then
  	  yield("/echo You should be all done now...")
  	else --If we don't have at least 300, we have less than 300.
	    yield("/echo Only ".. tostring(300 - (GetItemCount(31596) + Grade3Fish)) .. " more to go!")
  
  --"How did I get here?"
  else

    yield("/echo Something went horribly wrong while counting our fish at the end of a loop. Please contact the developer. Quitting for now.")
  	yield("/snd stop")

  end

end

--Container loop for the whole function, so that we only have to call this function when the script is started to loop until we're done
function MainFunctionLoop()
  
  yield("/echo Grade 2 and 3 Diadem Fish script has begun.")
  
  --On startup, check progress for both achievements.
  RequestAchievementProgress(2537)
  yield("/wait 1")
  Grade2Fish = tonumber(GetRequestedAchievementProgress()) --You can do arithmetic on numbers. Yes, this means lots of tostring() elsewhere in the function. Worth it.
  yield("/wait 1") --Just in case the above line's request also requires a wait to resolve properly. I would not be surprised if it does, since that menu is the second laggiest in the game after Shared FATEs.
  
  RequestAchievementProgress(2658)
  yield("/wait 1")
  Grade3Fish = tonumber(GetRequestedAchievementProgress()) --See above note on the grade two variable, it's worth all these tostrings.
  
  yield("/echo Starting Grade 2 and 3 Diadem Fishing script. Your current progress is " .. tostring(Grade2Fish) .. " out of 300 Grade 2 fish and " .. tostring(Grade3Fish) .. " out of 300 Grade 3 fish.")
  
  --Technically this "wants" to be while RequestAchievementProgress < 300... but that would spam the server with RequestAchievementProgress requests so we are absolutely, positively, 100% NOT doing that, ever.
  while (Grade2Fish < 300) or (Grade3Fish < 300) do
    --Make sure we are in the Firmament
    InitialStartup()
    
    --Enter the Diadem
    EnterDiadem()
    
    --Log the Diadem entry time and move to the proper fishing hole
    InitialDiademEntryMove()
    
    --While we entered the Diadem less than 40 minutes ago, fish
    while (os.time() < DiademEntryTime + 2400) do
      FishForFortyMinutes()
    end

  end
  
  DeleteAllAutoHookAnonymousPresets() --Clean up after ourselves
  yield("/echo If you see this message, you should have both The Height of Angling and Fishers of a Feather. Good job!") --Don't need a stop after this, because it's the end of the only function we have called
  yield("/snd stop") --...actually, it turns out we do need it, or else we get a "Peon has died unexpectedly." message, which is very rude to see because frankly, I expected the peon to die here. He's done working! Let him rest!

end

--The purpose of the function immediately above is to make it so the actual "meat" of this script, when run, consists of this single line.
MainFunctionLoop()
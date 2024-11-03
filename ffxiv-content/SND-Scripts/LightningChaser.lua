--this is just the Umbral Treader code, but reused to fish up Lightning Chasers to get 500k Fisher points instead.

--DO NOT START THIS SCRIPT FROM ANYWHERE IN THE FIRMAMENT. PLEASE. I'M BEGGING YOU.

--Required Starting Location:
--Literally anywhere OTHER THAN locations in the Firmament that are not "the entrance" or "within 7 yalms of Aurvael"

--Required Plugins:
--AutoHook [relevant preset already included in this file]
--Visland [relevant routes already included in this file]
--SimpleTweaks, with tweak "Bait Command" not set to anything other than the default "/bait" (it's fine if it's not currently enabled, the script handles THAT. just don't change it)
--Teleporter, used to teleport to Foundation from anywhere. not necessary if you always start this from inside Firmament/the Diadem
--Lifestream, used to teleport to the Firmament from Foundation. not necessary if you always start this from inside Firmament/the Diadem

--Visland route from the entrance of the Diadem to the place where the fishing happens
FishingPoint = "H4sIAAAAAAAACuXUTWvcMBAG4L8S5uwdRhp9+haSFgJN04TApg09mK6aFdRWWSstZdn/HnmtNKS99Fp801jDy/hB0h7ed32AFs5jtwn9ybv4sM1DHB5OzrbdGHbQwLr79T3FIY/Q3u/hQxpjjmmAdg930K6M0shOyAY+Qiu9QKXIl+pT2RPKomXFh1KmIVycQ+vZN3DTbeJjiWOkBi7Tj9CHIUMrGrgYcth1X/I65u3V1E+vv9Vhy1TjNv183injlLSv3bcxvLQfZyyRb/qUw3NUDn1dnh47anH9GMZc11Pwuov5JXGq3qbdWRo29ddp/ngb+3BZ+ujQ/A2jrUJH1lQYjc57/g2jkKW3fpEySjBaJ9Usoy2ycuSqzKTGmuQiZTyjIqX5KGMtlnPieIaRbFBY1naJMEJ5lEKTPcKsjEFN3qlZhtljuWxmiTBSKzRO+NlFTEfGSecrjHMFRthF3qXpXSFHpCuNs2iUMKWcaBTZ8h4TuX+k+YPhf6L5fHgCwIzWYuQHAAA="

--Visland route from the entrance of the Firmament to Aurvael
AurvaelRoute = "H4sIAAAAAAAACuVQy07DMBD8FbRn17KT1HF8QzykHsqjAqWAOFhkUS0RGzUbEIry7zjFVSX6B3CbmR2NZmeAK9siGLj3PoLmZBV6QmBQ26/34Dx1YJ4GuAmdIxc8mAHWYKTgSpVyzuABzEzOecbgMcplxrWQ1RhZ8Lg4B6O1YrCyjetjUM4Fg2X4wBY9gYlk4Qm39oVqR5vryf9LS+Vin24TPveXWCSmvdq3Dg/2XTvJ4KINhPsowjbB050jkdseO0p4Cq6to0PixC7D9iz4Jj0tfsQ71+Iy+sTIjiaZSc2zXGRV2kRNv06bFBUvyqxU/3UUqcq8OF5FxoOq9N9f5Xn8BoYngkRkAwAA"

--AutoHook preset: Hook ! 6-10 seconds. Mooch and hook all !!! (the Umbral fish, worth even more points, is the only other !!!). Auto-Cordial, use Makeshift Bait, use Patience when MSB is not active.
AutoHookPreset = "AH3_H4sIAAAAAAAACu1ZbW/iOBD+K1a+7Bd2RSiwbb9xQFukvqlQ9aTTqXKDIRbBRo7TlkP97ze2E+eVQBe0p5P6ZdWdGU+eZ+yZ8ZiN04sk7+NQhv3Z3DnfOEOGXwLSCwLnXIqINJwBZ7KPmUeCG849PxGrNdeUkXTNNFFdria+IKHPAxA1t3q4IsFqQt6lc+44DecWL8GXhoOUb6SdN5wR+GidnuW89l74K0nxkTDnfYaDEOQ9T1LOJusVWLofBnBssXH0H61d2N3mJ9E/hgRpKzQaJdi7p4djv2PBWluMmIyo0lnTY8femMXYz34eJ+59P1qqYD9HIXnyCbM0hu8eIdNQQ7VMYke/shVGG6J+JARh0rKJGWochlvbbbY/Qc6IK7nxICCezJ2lKgaf3IzErUXrHrYVbQtXTCmG7N44I/ZKRCK4F5QLKtfp4iDgb3dg4eHVqG/Fz56xv6YhAP4LvEiydCEcrW4XslT9D/Kq3Wx+NFJds9l1267VnnSy2ryqsNDtnrmptpXX5nRuzukXnHJ0/j5qtUgOkjmgcbwPOaGt+IRe0NAfrkm4M6M6nWPUBPU5pL9nU61zlMJwgxdk7NOZ/ANTXR6UIEwEY4m9BXDs1G9KZx+GE5+GaEnnvkQeZ7OAehK9UekjXdEnPg4oXnwL0QV+5SJlbgEijdD2q0/xr6n691hSAqbpRtoIpKp4/QOZqc8NsQjWE6rgNXcEpnuMzbc47N53j7L3UE3/IX0szW3j0XQ908FHd6w/sLxBpZr7E+zWaAoAqYcD5aDKQH3olYwDvCp3/6r8gGr5yyH6gZLQIMymyG6cPipwuIIAMS7RC0HQ0qfoDeghTRpp1ghrrJlAp7rMQTtOsOMDHprjDfHOCZJEO2nk5Q/Eg88JXRp1mOOCFl5QkYn/4T29PjtLSRgHrJy1SdDah2YnhG34LgXO3fhThuM3vFJY7CXtEtP0vqk0E65sCvpNgnw4pfImyajvapNKHq95JsIVHo1+h8d7iADZgtLoKnE6353K9TlMleuNhV2vq/gK7mgCUtbkzpZIVVrtEa/Cui1Rq7TaK3Z16LMRqLQrxLEOa42vTEwflFGfR0wSEfsE+9gJ4DaymBZmnD3rf/o+DiGNG466kd7NVFxCfTEtdA+lUL0+E5sBxVOyRFeqDrxxkYwGJ83WqQrUFeeLJ4IXBUeJOB1iqvWDq8nVFpWu6FAyKyp60eT2brLFSqWzslRt6+dZXpaZE1PlWArO5sV0TzVlQiWTLZyMcgervFE9L2OrG/JJUZrjlqivyZywKRbrKuxWWcvQWm0hafU7eJbs6qla8yLbMurEQjWrKJR8aTVqTfbKMOARwC9KJ4KuylJFt3Qfi+WKwtZ7SWIwjsQMe3l218Tc40OYHlOvN/hdXe4GJMBA123+gAZ6Q1lG1lUixQ8mdSUW2bWJMLZNlleJx5KvejOoJH0cQedNm1tefk2X6m7uZhRpGcotUmwom48lAZJ6ljL1Jm60e9WbSwH1BrXReLF+iWgwJSL8hi59KIHQ5ImgSZk+gQevdlUBKtSI2uP8VYL+8xJUUTvqmsZXAfrNBaii/jT/b/XHlJhy+RnNGRcwOpZfjA8sSkdlVtjajX7phvA/MsBRakpJ4saTWu8V00CRzhnAav21P3vL3KcMLCNMwdWOd/BOuc+Apx5JBZ2SEMUHEemTaEc5S1L/sJE8NXTODp9+cwd/c5TXgJRMCXZMp0AyJnP4m9nXjzO//8eZZNKsGCv3mlDjbFZZbidBmL4q5r7SwJguvSVw5vI4teiBBARmu9oy+PEvzaLnK8IcAAA="

--Startup function. Make sure we're on Fisher, leave the Diadem if we're in it, configure Autohook presets, and get to Aurvael's desk
function InitialStartup()
  --yield("/echo Debug: Initial startup function begun.")

  --Make sure we're a fisher, since we can't guarantee everyone's gearset is named identically to use "gs equip" instead of yelling at the user, sadly
  if GetClassJobId() ~= 18 then
    yield("/echo You're not currently a Fisher! Please change to FSH and restart the script.")
    yield("/snd stop")
  else end
  
  --If we are in neither the Diadem nor the Firmament, teleport to Foundation and then aetheryte to The Firmament (this accounts for being in Foundation but not near an aetheryte shard)
  if (not IsInZone(886)) and (not IsInZone(939)) then
    yield("/echo Began Lightning Chaser script somewhere other than the Diadem or the Firmament. Teleporting to Foundation aetheryte.")
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
    
    --yield("/echo Debug: Making sure we're in range to interact with the Foundation aetheryte.")
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
    --yield("/echo Debug: Using Lifestream to enter the Firmament.")
    yield("/li Firmament")
    yield("/wait 5")
  
    --Wait for teleport/zoning to finish
    while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
    end
  
  --Otherwise, if we started from in the Diadem, leave it, thereby entering the Firmament
  elseif IsInZone(939) then
    yield("/echo Began Lightning Chaser script inside the Diadem. Exiting the Diadem and reentering.")
	--Exit the Diadem
	yield("/wait 1") --Superstition, honestly. I think we would be fine without this.
    LeaveDuty()
    yield("/wait 2")
    
	--Wait to have entered the Firmament
    while (not IsInZone(886)) or (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
    end
    
  --It is impossible to "not be in the Diadem", "not be in the Firmament", and "not be in either the Diadem or the Firmament" simultaneously.
  --Therefore, if we get here, we are already in the Firmament, so we do nothing. This is why you can't start from any random location in the Firmament... though navmesh fixes that
  else
    yield("/echo Began Lightning Chaser script in what should be a literally impossible location. Please tell the developer how you managed this! Quitting for now.")
	yield("/snd stop")
  end
  
  --Now we're a Fisher who is either at the entrance to the Firmament or at Aurvael's desk. Either way, we're safe to proceed.
  SetAutoHookState(true) --Enable AutoHook
  DeleteAllAutoHookAnonymousPresets() --Cleans up after any previous iterations
  UseAutoHookAnonymousPreset(AutoHookPreset)
  --SetAutoHookPreset('UmbralTreader1') --This does not work, per above notes
  yield("/echo AutoHook preset loaded. Please remember to delete it when you're done!") --Or don't, I'm not the boss of you.
  
  --Enable the simpletweaks command to change bait with "/bait", in case it was not already enabled. This only enables, so if it's already enabled, do nothing. Turns out this chat command exists? Wild.
  yield("/tweaks e baitcommand")
end

--Repair any gear that can be repaired, then enter the Diadem
function EnterDiadem()
  --yield("/echo Debug: Entering the Diadem.")
  if IsInZone(886) then --If we're in the Firmament...
  
  yield("/wait 2") --Wait for Aurvael to load, this has broken the script before god help me
  
  --Move to Aurvael before you do anything else.
  if GetDistanceToObject('Aurvael') > 6.9 then --Seven is the interaction distance, which I did not know until I started testing this
    yield("/visland exectemponce " .. AurvaelRoute) --Move to Aurvael. There's no reason for this to be a variable, but hey, maybe you like to start from the Kupo of Fortune sNPC and you can modify this yourself
    yield("/wait 1") --Start moving, just in case the IsMoving() check is too fast to for visland to have started moving, I worry about these things
    while IsMoving() do --Wait until we are done moving
	  yield("/wait 1")
	end
  else end
   
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
      while GetCharacterCondition(39) do yield("/wait 1") end
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
    while GetCharacterCondition(35, false) do yield("/wait 1") end
    while GetCharacterCondition(35) do yield("/wait 1") end
    yield("/wait 3")
  end
end

--Move to the (hardcoded, singular) location we'll be fishing at
function InitialDiademEntryMove()
  --yield("/echo Debug: We have entered the Diadem. Moving to the fishing hole.")
  
  --Record our entry time. Instance timer is 180 minutes = 3 hours > 40 minutes = 2400 seconds, then leave to dodge the amiss timer (I coded the movement to dodge amiss status on purpose, then it didn't. "yeah rip.")
  DiademEntryTime = os.time()
  
  --Check Diadem Hoverworm count and restock if we're below 500. We're staying for 40 minutes, so that's 12.5 per minute or an average fish bite time of under 5 seconds, which is definitely not happening.
  BaitCount = GetItemCount(30281)
  if BaitCount < 500 then
    RestockBait()
  else end
  
  --Equip the bait.
  yield("/bait Diadem Hoverworm") --Reminder: this SimpleTweaks function doesn't take double quotes around the bait name, just raw text
  yield("/wait 0.5") --Pause to actually switch the bait, I don't know if it's needed but I'm superstitious
  yield("/bait Diadem Hoverworm") --There's no kill like overkill. Let's make REALLY sure.
  yield("/wait 0.5") --See two lines above.

  --Run to the fishing hole (we are either at the diadem entry point or the Mender and this route works either way.)
  yield("/visland exectemponce " .. FishingPoint)
  yield("/wait 5") --Wait for visland to start going, because you're not moving when you're casting your mount spell.
   
  --Either this condition or the one below is suboptimal - I think the below is superior because of "route is running but we're not moving" (think auto-spearfishing) but for this use case it doesn't matter.
  while IsMoving() do
    yield("/wait 2")
  end
   
  --See above note, but this combination works just fine for this use case so I will not change it.
  if not IsVislandRouteRunning() then
    yield("/ac Dismount")
    yield("/wait 3")
  end
    
  --Also, we have to actually dismount. If you just hit dismount once while in midair you sink like a rock but then don't actually dismount when you hit land. I had forgotten this completely despite literally doing it daily.
  while GetCharacterCondition(4) do
    yield("/ac dismount")
    yield("/wait 3")
  end  
  
  --Now we are off our mount. We need to be facing the fishing hole in order to fish. That's "outwards", aka "the direction we can't run any further", so if we run into the wall we're facing the proper direction
  --Set a run point that's far enough out in the sky that we're always facing outwards, then run to it for long enough that we hit the wall
  yield("/visland moveto 257 -188 -420")
  yield("/wait 1")
  yield("/visland stop")
  yield("/wait 1")

  --yield("/echo Debug: Arrived at the fishing hole.")
end

--Purchase Diadem Hoverworms until your inventory has more than 500 of them
function RestockBait()
  --yield("/echo Debug: Restocking bait from the Mender")
  
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
  else end
  
  --Purchase loop
  while BaitCount < 500 do
    yield("/pcall Shop true 0 3 99 0")
	yield("/wait 0.5")
    if IsAddonVisible("Shop") then --Again, we don't know if the user has YesAlready configured
      yield("/pcall SelectYesno true 0")
	  yield("/wait 0.5")
    else end
    BaitCount = GetItemCount(30281)
  end

  --There's not strictly a need to exit the Mender menu since the next step could be unmounted movement instead, but better safe than sorry because you can't mount up while you're in the chat menu and mounting is faster :3
  yield("/pcall Shop true -1")
  yield("/wait 0.5")
end

--Start fishing, wait 40 minutes, and exit the Diadem for the Firmament.
function FishInTheDiadem()
  --yield("/echo Debug: Beginning fishing.")
  
  --We just pointed ourselves in the correct direction and we know we have the correct bait equipped, so once we start casting AutoHook will handle the rest.
  yield('/ac "Cast"')
  
  --Wait until we're about to hit the amiss timer, more or less.
  while os.time() < (DiademEntryTime + 2400) do
    yield ("/wait 1")
  end
  
  --yield("/echo Debug: We should hit the amiss timer soon. Stopping fishing and leaving the Diadem to reinstance.")
  
  --Finish your cast before you go, just in case this messes up leaving the instance somehow. I am pretty sure it doesn't when I do it by hand, but I'm paranoid about SND seeing zone changes properly.
  while GetCharacterCondition(6) do
    --yield("/echo Debug: Trying to stop fishing. Our current condition is:")
    --yield("/echo Debug: Any gathering status: " .. tostring(GetCharacterCondition(6)))
    --yield("/echo Debug: Fishing status: " .. tostring(GetCharacterCondition(43)))
    --yield("/echo Debug: Mid-animation status: " .. tostring(GetCharacterCondition(42)))
    yield('/ac quit') --Cancel fishing. Apparently there is a vanilla text command for this that everyone but me already knew?! I do literally all my fishing with autohook lol lmao etc
    yield("/wait 1")
  end
  
  --Now that we are done fishing, we must have at least started to put our rod away. Wait for that animation to finish because we are polite, and then leave the Diadem.
  --yield("/echo Debug: Done fishing, leaving the Diadem.")
  yield("/wait 2")
  LeaveDuty()
	
  --Wait to arrive at the Firmament and do the whole thing over again.
  yield("/wait 2")
  while (not IsInZone(886)) or (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
  end
end

--Container loop for the whole function, so that we only have to call this function when the script is started to loop until we're done
function MainFunctionLoop()
  yield("/echo Lightning Chaser auto-fishing script has begun.")
  
  --Make sure we are in the Firmament
  InitialStartup()
  
  --No brakes on this train (this will not stop until you stop it manually)
  while 1 do
    --yield("/echo Debug: Starting (or restarting) Diadem fishing loop.")
    
    --Enter the Diadem
    EnterDiadem() 
    
    --Log the Diadem entry time and move to the fishing island
    InitialDiademEntryMove()
    
    --Fish. This function includes a timer to leave the Diadem once we've been in it for 40 minutes.
    FishInTheDiadem()
	
	--yield("/echo Debug: Completing the Diadem fishing loop.")
  end
end

--The purpose of the function immediately above is to make it so the actual "meat" of this script, when run, consists of this single line.
MainFunctionLoop()
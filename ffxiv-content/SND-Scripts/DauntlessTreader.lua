--Instance, repair, and move loop code stolen from flug, who in turn borrowed some of it from earlier existing SND community scripts
--Fishing actions, autohook and visland presets, and various bugs added by Unfortunate. Feel free to reuse any or all parts!

--Required Starting Location:
--NOT locations in the Firmament that are not "the entrance" or "within 7 yalms of Aurvael"
--Anywhere else should be fine. Theoretically. Please do let me know if it breaks.

--Required Plugins:
--AutoHook [relevant preset already included in this file]
--Visland [relevant routes already included in this file]
--SimpleTweaks, with tweak "Bait Command" not set to anything other than the default "/bait" (it's fine if it's not currently enabled, the script handles THAT. just don't change it)
--Teleporter, used to teleport to Foundation from anywhere. Not necessary if you always start this from inside Firmament/the Diadem.
--Lifestream, used to teleport to the Firmament from Foundation. Not necessary if you always start this from inside Firmament/the Diadem.

--Things I still want to implement before I call this feature-complete:
--1) Optimize the movement route a bit better:
--20240317 vnavmesh exists so the visland route is not the best way to do this anymore (also dodges a memory leak)
--After buying bait (so starting from the mender) it doubles back to near the start. also I think it's going unnecessarily high before it ends up at the fishing hole.

--2) People who can't repair their own gear won't repair their gear here, and we have code to talk to a Mender anyway... but nobody else seems to care about that lmao


--visland route from the entrance of the Diadem to the island with the fishing hole that we are using
EntrySpot = "H4sIAAAAAAAACuWUS0sDMRSF/0q56zHkncnsxFboor5Q6gMX0UYa6ExkJlVK6X/3ts1YFy7cSnc5yeXk3o+TrOHC1R4qGAY38/Xgrn5p3WIwalK7ggKmbvUeQ5M6qJ7WcBW7kEJsoFrDPVQnWmnCGFWigAeouJVEKcl1AY94yBQjKJTdoI6NHw+hogXcuFlYop0gKCbxw9e+SVCxAsZN8q17TdOQ5pe5+udebhS76ubxsz/BdtDtzS06fyjf9YiWozqm/uJx8nVenu4qsrhe+i7l9dZ46kI6OG7VeWzPYjPLo9P95m2o/QTr6Kb4BQxTpJTGfHORShiZuUhJuEB9hFyUxvGE6fOCQsnS9HnhxBol9TFyYZwYQfu8aEKZ4RlLyYhQlpfHh4VZoqyyeyoCvxOh+0ckrSVUKyGPjwovNdHaSvxmt2FBRS3Pb0gLVEKyP1HBgP1XKs+bL8kAWsC4BgAA"

--visland route from the entrance of the Firmament to Aurvael
AurvaelRoute = "H4sIAAAAAAAACuVQy07DMBD8FbRn17KT1HF8QzykHsqjAqWAOFhkUS0RGzUbEIry7zjFVSX6B3CbmR2NZmeAK9siGLj3PoLmZBV6QmBQ26/34Dx1YJ4GuAmdIxc8mAHWYKTgSpVyzuABzEzOecbgMcplxrWQ1RhZ8Lg4B6O1YrCyjetjUM4Fg2X4wBY9gYlk4Qm39oVqR5vryf9LS+Vin24TPveXWCSmvdq3Dg/2XTvJ4KINhPsowjbB050jkdseO0p4Cq6to0PixC7D9iz4Jj0tfsQ71+Iy+sTIjiaZSc2zXGRV2kRNv06bFBUvyqxU/3UUqcq8OF5FxoOq9N9f5Xn8BoYngkRkAwAA"

--AH preset: hook only !!!, autocast Chum, autouse Cordial, autouse Thaliak's Favor. could do far fancier Surface Slap and switch preset things but AH currently doesn't support it see below...
AutoHookPreset = "AH3_H4sIAAAAAAAACu1XXW/iOBT9K1Ze9oUZAaWfb0ygUySYViWjPlSjlRsMsTA2cpy2LOp/3+s4dgiEAAtvy1t077F9zrXvR5ZeO1HCx7GK/fHEu1t6XY7fGGkz5t0pmZCa1xFc+ZiHhA2ECCNr1mv6lJN8zci6fs6DSJI4EgxM9a07PBA2D8in8u48r+b9wjPYK6WD9N4o3bzm9WCP5s1tYdf2m3gnOT8SF3YfYxaDvR0qKniwmAOy8WUIZ4ill340C9yzZQXyjfqB9H/HBKUo1OtZ8lc3x5N/5GyRInpcJVT7HLRSwH+JvoFl5G+vTxN5P0pmOtx/JzF5iQh3OrqfISGjOKVa9Y72vArjjZGfSEm4cmIygSkNI63VqLcO0GbMpdIEYyRUOx/TgXdht3VsG8fdRMvRlSOKIb2XXo+/E2kNT5IKSdVi82Edn9X2TKPlqtE6Uksz03JP46i7IPHO2F9enuL16ONQep67lMuTPKEBnpJhRMfqB6bpQ9KG2BqGCodT0AhnVYvcR2IQ0RjN6CRSKBR8zGio0AdVEUpzP4gwo3j6V4zu8buQuXTHEKUUXWk7KAAV9eEJK0oAmt+kC0HuytY/k7E+roslWwRU06vviszVKa7fEXG3f3WS24fM+4f4WJnW9NsUSFPte4/c7zhN4NKN4AWuqzcCgjTETG9QBtAHvZMhw/P9OkXziPr6HdnQIMxHyN1c+lbgdTGGuFDojSCo/iP0AfJQKhqlqhFOua4EOvetvLTTBDt74bF53xDvgsGm2kWtaH8mIRwH+IYuJFWV8eL4JNzItSwsm8lpQ9M6NgkhON1PJXFhCMxfyvADzzUX17V/YppPINoTCI1Z8y8t8+6IqoHNm2/6KjZ27IuVd1yyo/Hv2PEJIkC2sDS+Up7eN690fYFT6XqDcOvTaj2Hri0hMU2GbIlUKWqPeK2t2xK1UtResativxqBUtxaHKu4VuzlYvplYXa4nr0BKpAEjyAVa16fxupxrFVDxr5u/IZoh+7YK8o7FJbOIK0YE4KjH8kki8JFvXl9A+c9CDF9IXi6ngDWno+txbOsv/MQPGxxpYUZKl9JYV6H/HoMtqB0vmqk7j7Xt0Xbyq9B7hwqKfikTI7xVAkyiC2SjHOHqCKoWpbBpm31Yt1akGbdfTIhfITlooSd81Xpc6AtEp1/h8oNXLVQB1/XuknaIqCv+0msxMx59JrVtt8RCdBftwaSzjetWu7GUJXZtYSts4UFDBM5xmFRXZ+YaTwOsW4pmXWAP/WE1iEMg9z6d2ieA8rXTVoe/Jhps1xdao1ry8vMQyXm7bEi0scJtNW8cxXtfTrTA3bDODRhyidDRUBH/at2QAl5hjkmKyMrJeT2XELOJeRcQs4lZJ8S4kvMCbpni7yA3EAROs8g5xnkPIP8X2eQP/a3Jvtbf3UGU0Re/3z9CyRMjUG0GQAA"

--20240115 THIS IS BROKEN, DO NOT USE IT YET - Because autohook does not (yet?) "slap then swap" correctly, this doesn't slap before swapping, so preset one just wastes time and GP
--20240317 note: this will never be fixed, because Autohook changed to an absolute garbage UI and I refuse to use it until it is changed. sorry I'm crotchety. feel free to steal the logic for yourself.
--Autohook Preset 1: Hook anything within 13 seconds. Hook anything under Chum within 8 seconds. Auto-cast Chum when GP > 300. Auto-use Cordials and Thaliak's Favor.
--After one catch of Ashfish or Ghost Faerie, use Surface Slap on them and switch to "UmbralTreader2". THIS DOES NOT WORK, AND IT'S AN AUTOHOOK LIMITATION. THIS ISN'T MY FAULT FOR ONCE!
--AutoHookPresetOne = "AH3_H4sIAAAAAAAACu1ZW2/iOhD+K1Ze9qW74trbGwu0RaIXFao+rFZHbjDEwsTIdtqyqP99x0nskAsBDrxt3qKZ8fj7xp6xPVk7nUDxLpZKdqcz53rt9H38xkiHMedaiYCcOT3uqy72XcLuOXc9I9ZjhtQnyZiJUd0ux54g0uMMRLWtHu4IW47Jp3KuHefMecAL8BXCQdo3Cp2fOQPw0bi8SnntvPF3kuAjMuV9ipkEecdVlPvj1RIs618R4Nhi7YQfjRT2eFgKfL12IPwXSVBohQYDA/788njwjz5bhRYDXwVU66xpKYH/E/3ILAZ/dXGayHe9YKHD/V8gyatHfMuj/+kSMpEh1LJ91NxvKSKtRN1ACOIrSyYmGMKIqLXqtdYB3CJxITXOGHHVzs104FoYtxZt/biVaFm4YkIxpPfaGfjvRBjBk6BcULXKb6zjs9rMGXE5r7eO5NKIudxQ6fVXRO6Mfbt9it2jp0PhfHZR2ifZQvd4TkYenaqfmIYbSQukEYwUdufAEeYqJ7kPxbFHJVrQmaeQy/0po65CH1R5KMz9sYcZxfNvEt3gdy4S6hYhCiHa0nZQAErqwxNWlIBpspI2BIkqHv9Mpnq6PhZsNaYaXm1XZM5PsfwWiF3985OsPmTeH9LFKjqaXqICGVX7waPf7VlOoNIHwSss12ACAKmLmXZQZKAneicjhpf7nRSNI+rrD2RCg7A/QXblwr0Cu4sx5HOF3giC6j9BH0APhaRRyBrhEOtGoBPdxk47TbDjHS6j/Q3xTglMqjXP0vJn4sJ0YF9v7zqnjk/CXK7FYcknpwlN69gkhOD0P5XAqUtgslNGH3ipsdhT+xbT5AaiNWOubTL6tUHen1B1b/Lmu16KnMch39jHBR4j/Q6PTxABsgVlpCvE6Xx3CsenMBWOjyzs+LBaL+HUFpCYUYZsiVSh1R7xyozbErVCq71iV4Z+MwKFdpk4lmEt8WVj+mXMzOV68QZWY0HwhIg6TDWkUj1ONW1I2V+5d4hW6CN7g3qPwtgF5BVjnPvoZzCLw9CsNS4uYcI7zuevBM8zrow4ubYW63t347stqrAwQ+UrKMxZk4fH8RYrna/aUp8+F1dp2cbTIFGOlOD+rABSpCjjE1lsYRQpd3BKG5WzimzDU7WZlaaYGfWQzIg/wWJVgM7qyvhZoy0UrX4Hy5xdOVFrnuWaB20s4FjvBlLxhdXoMZunfo8HAD8rHQu6zEs13dydKpZrCluvFsZgFIgpdtPshiS6jEsX6xMllt7jT31B6xGGgW69+QMOz3vqb8hqWqT5wcNMi4VZARhqZLHpZTw6Iw49jBRfdqaKiC4O4FRNDq60fEgX+n5djxQaMPVnI0WAR+3r7IAC8gzXmLiIbBSQq6qAVAWkKiBVAdldQLoC+wTdsFVSPi6hBFX3j+r+Ud0//s37x2/zoIkf6r+sICoh+QdOprTcCigtqIVG89VbQBk8kuQ3dOvBcwoaBkRQ8+Rrwv8U3Q0+GHSmsK/D3xIQvBcf5spdKUvbTc39GrKP0HQRdEIkihcdhaue+t9iUYX/jUxzrn11fL8otdHKf3Pt2T5L+ORQbzDKcI35HN9qrn5/7fj9xT7wSp7+B5hp3hR0avZq+nR54MdlwzZXpAGx2UnJNkkaqX5M4uaBwD5MYw5Fz4QRLJMU3uuVtE8V6khvqs2SAtSuClBVgKr/71UBOrQA/f76C0MI1xS1IgAA"
--AutoHook Preset 2: Named "UmbralTreader2". Hook only !!!. Auto-cast Chum when GP > 300. Auto-use Cordials and Thaliak's Favor. After one catch of any of the four Umbral fish, switch to "UmbralTreader1".
--AutoHookPresetTwo = "AH3_H4sIAAAAAAAACu1aW2/jKBT+K8gv89IZ5dL7W8ZJ20hpO2pc9WE0WlGHxCgEIsBts1H/+4Jt8DVOsslqpFm/Recc4PsO8HHAWTu9UDIXCinc6cy5XjsDCl8J6hHiXEseohOnz6h0IfURuWfMD4xZtxlhitI2E+O6XXoBRyJgRJlaG3u4Q2TpoQ/pXDvOifMAF6qvCA7QfYOo8xNnqProXF7leu29sjeU4kMi1/sUEqHsPV9iRr3VUkW2P2PAScTaiX50ctiTZjnw7dae8J8FAlEUGA4N+PPLw8E/UrKKIoZUhlj7bGgtgX+T/TgsAX91cZzMu0G40On+KxToJUDU8hh8+AhNRAS1bh11d5uK2CuAG3KOqLRkEoIRjJjaabt1uge32FxJjRGCfLl1Me05F6Zbi7Z92EycWrh8gqHa3mtnSN8QN4YfHDOO5aq8sA7f1WbMmMt5+/RALp2Eyw0WwWCFxNbcn50dY/Xo4UA0np2Us6MsoXs4R+MAT+V3iKOFpA3CGMYS+nPFUY1VT3IXil6ABVjgWSCBz+iUYF+CdywDEO19L4AEw/kXAW7gG+MpdYsQRBCttO2VgBp9+AElRio0nUmbgtSVtH9CUz3cAHKy8rCG19qWmfNjTL8FYmf//Cizr3be38iFMj6anmOBjNV++EjdvuWkXPogeFHTNZwogNiHRHdQFaAHekNjApe7nRSdA/T1GzCpAZBOgJ25aK2o1UUIoEyCVwSU+k/Au6IHItIgYg1ghDWT6NSXWWnHSXaywkW8vlW+cwaz1bonefsT8tVwKr59tu2cOnwTlvZakpby5jSpOT10E6rkDD4kh7kiMF0p43e41FjsqX0LcVqBaI/HdEzBvzbIBxMs782++aqnotTjiGXWcUWPsX9Ljz9UBtAGlLGvEqfz1alsn8NU2T6OsO0jtV6qU5urjRnvkA2ZqozaIV+FdhuyVhm1U+7q0GczUBlXyGMd1pq+bE4/TZgprhevKsrjCE4Q76ihRljIx6mmrbbsz9I9RDv0kZ2h3seq7ULtK0IYo+B7OEvS0G11Li7VgHeMzV8QnBd3gLGndWt+LOPv33l3G1yRMivpq1DmYsjDo7chSm9YHamPn4urvC1zN0idY8kZnVXRiT11hOKIDZRi5xZS+aB6WnFsdK52i9YcNeMeoRmiE8hXFeisr46fDdpA0fq3sCzF1RO14UWuZdAmQh3sbigkW1iPbpM99/ssVPCLVo/jZdmq6ZaqqsSuKWwsLkzAOORT6OfZjVBcjgsf6jMlsd7DD12i9RGBim7rmzo97zEtmjQ9dTPTZp5taoyF5lXmsWTL3lQi7sJQnavp0ZW3j/BCV9jt2KEBYzobS6R4tD5P9pCQJ1XIJDKSkZCrRkIaCWkkpJGQXSTE5ZAicENWqYBcKhFqapCmBmlqkP9rDfLLXGuS6/pPa4hFpHzNKYjLLVfiAjqgxyUWkEICxvPVa4iJujSJL8BlCySnuokRnVZbi87e2AsTtI6+UagkPlM1UKm6rH176u72OvuoXmA4niABkrkH0eTnPr5YVNFHJPNSd3Z1+ONRbr2tj/KYlhIqwc5QKpBNCB3+8Nx8DPsdH8PMQ07Fq81OD0AuC2kiHvahRRgQ2VeV4oNJO/c2k3bzgNQqzGOOTE+IICjSHbzTfalSi7qbtKjH/QAitlTqsvowetQ+b/0hevSHaVGjQ7/pozx5hyvRKNF/qUQuYeFEBJDPMzKkvzI3MtTIUPPfoEaGjloQbbyc9ShbQMJ8yLHI3M+iI7+ph5p6qPmTYlMP7SREvz7/AaT4MrfaKwAA"

--Set this variable to 'true' to spam your log with debug messages. You likely do not need this, unless either 1) someone specifically asked you to or 2) you're trying to modify this script yourself.
debugvariable = false

--Make sure we're on fisher, leave the Diadem if we're in it, configure Autohook presets, and get to Aurvael's desk
function InitialStartup()
  if debugvariable then
    yield("/echo Debug: Initial startup function begun.")
  end

  --Make sure we're a fisher, since we can't guarantee everyone's gearset is named identically to use "gs equip" instead of yelling at the user, sadly
  if GetClassJobId() ~= 18 then
    yield("/echo You're not currently a Fisher! Please change to FSH and restart the script.")
    yield("/snd stop")
  else end
  
  --If we are in neither the Diadem nor the Firmament, teleport to Foundation and then aetheryte to The Firmament (this accounts for being in Foundation but not near an aetheryte shard)
  if (not IsInZone(886)) and (not IsInZone(939)) then
    yield("/echo Began Dauntless Treader script outside the Diadem/Firmament area. Teleporting to Foundation aetheryte.")
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
    
	if debugvariable then
      yield("/echo Debug: Making sure we're in range to interact with the Foundation aetheryte.")
	end
	
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
    if debugvariable then
	  yield("/echo Debug: Using Lifestream to enter the Firmament.")
	end
    yield("/li Firmament")
    yield("/wait 5")
  
    --Wait for teleport/zoning to finish
    while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
     yield("/echo Waiting 2 seconds to finish entering the Firmament.")
     yield("/wait 2")
    end
  
  --Otherwise, if we started from in the Diadem, leave it, thereby entering the Firmament
  elseif IsInZone(939) then
    yield("/echo Began Dauntless Treader script inside the Diadem. Exiting the Diadem and reentering.")
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
    --Therefore, if we get here, we are already in the Firmament, so we do nothing. This is why you can't start this bot from any random location in the Firmament... until navmesh is publicly released.
	yield("/echo Began Dauntless Treader script inside the Firmament. Proceeding to enter the Diadem.")
    --yield("/echo Began Treader script somewhere weird in the Firmament? Maybe? Please tell the developer how you managed to trigger this error, like where you're standing right now! Quitting for now.")
	--yield("/snd stop")
  end
  
  --Now we're a Fisher who is either at the entrance to the Firmament or at Aurvael's desk. Either way, we're safe to proceed.
  SetAutoHookState(true) --Enable AutoHook
  DeleteAllAutoHookAnonymousPresets() --Cleans up after any previous iterations of this bot
  UseAutoHookAnonymousPreset(AutoHookPreset)
  --SetAutoHookPreset('UmbralTreader1') --This does not work, per above notes
  yield("/echo AutoHook preset loaded. Please remember to delete it when you're done!") --Or don't, I'm not the boss of you.
  
  --Enable the simpletweaks command to change bait with "/bait", in case it was not already enabled. This only enables, so if it's already enabled, do nothing. Turns out this chat command exists? Wild.
  yield("/tweaks e baitcommand")
  
  --Lie about where we were fishing before we started so that we pick a new point properly. This should be unnecessary, but I don't know how lua evaluates "nil == nil" and frankly I'm afraid to ask, so initialize them here.
  OldFishingPoint = 1
  NewFishingPoint = 1
end

--Enter the Diadem
function EnterDiadem()
  if debugvariable then
   yield("/echo Debug: Entering the Diadem.")
  end
  
  if IsInZone(886) then --If we're in the Firmament... (This should, theoretically, not be necessary. But I'm very, very suspicious.)
    yield("/wait 2") --Wait for Aurvael to load, this has broken the script before god help me
  
    --Move to Aurvael before you do anything else.
    if GetDistanceToObject('Aurvael') > 6.9 then --Seven is the standard interaction distance, which I did not know until I started testing this
      yield("/visland exectemponce " .. AurvaelRoute) --Move to Aurvael. There's no reason for this to be a variable, but hey, maybe you like to start from the scrip-spending NPCs desk, you can modify this yourself to do that.
      yield("/wait 1") --Start moving, just in case the IsMoving() check is too fast to for visland to have started moving, I worry about these things
      while IsMoving() do --Wait until we are done moving
	    yield("/wait 1")
	  end
    else --Otherwise, we're already in talking distance. Don't go anywhere.
	end
   
    --Repair your gear outside of Diadem if it can be repaired (That's what the 99's for, this is "repair everything at 99% or lower durability")
	--Assumption: you can repair your own stuff. I guess that's a silent assumption here I should document, huh? Did so above.
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

--move to the location we'll be using to fish the whole time, but not at any of the fishing holes (which means no amiss worries)
function InitialDiademEntryMove()
  if debugvariable then
    yield("/echo Debug: We have entered the Diadem. Moving to the fishing hole.")
  end
  
  --Record our entry time. Instance timer is 180 minutes = 3 hours > 40 minutes = 2400 seconds, then leave to dodge antibot amiss timer (I coded the movement to dodge amiss status on purpose, then it didn't. "yeah rip.")
  DiademEntryTime = os.time()
  
  --Added: check our bait count and restock if it's lower than 100 for any of the three baits
  BalloonBugCount = GetItemCount(30278)
  RedBalloonCount = GetItemCount(30279)
  CraneFlyCount = GetItemCount(30280)
  
  if (BalloonBugCount < 100 or RedBalloonCount < 100 or CraneFlyCount < 100) then
    if debugvariable then
	  yield("/echo Debug: Starting to restock bait.")
	end
    
	RestockBait()
  else end
  
  --Run to the fishing hole (we are either at the diadem entry point or the Mender and this route works either way.)
  if debugvariable then
    yield("/echo Debug: Bait check passed. We should be moving for real this time.")
  end
  
  --yield("/visland stop") --stop visland, in case it's somehow paused before doing anything else? possible fix for Wasabi issue 2/17/24. checking with croizat who is smarter than I'll ever be
  yield("/visland exectemponce " .. EntrySpot)
  
  if debugvariable then
    yield("/echo Debug: Told visland to move. Now we're moving, hopefully.")
  end
  
  yield("/wait 5") --Wait for visland to start going, you're not moving when you're casting mount, etc.
   
  --Either this condition or the one below is suboptimal - I think the below is superior because of "route is running but we're not moving" (think auto-spearfishing) but for this use case it doesn't matter.
  while IsMoving() do
    if debugvariable then
	  yield("/echo Debug: Keep it moving moving moving (for the next 2 seconds.)")
	end
    yield("/wait 2")
  end
   
  --See above note, but this combination works just fine for this use case so I will not change it.
  if not IsVislandRouteRunning() then
    if debugvariable then
	  yield("/echo Debug: Visland route has finished. Dismounting.")
	end
    yield("/ac Dismount")
    yield("/wait 3")
  end
    
  --Also, we have to actually dismount. If you just hit dismount once while in midair you sink like a rock but then don't actually dismount when you hit land. I had forgotten this completely despite literally doing it daily.
  while GetCharacterCondition(4) do
    if debugvariable then
	  yield("/echo Debug: Making sure we are actually not mounted.")
	end
    yield("/ac dismount")
    yield("/wait 3")
  end  
  
  if debugvariable then
    yield("/echo Debug: Should be at the fishing hole island now.")
  end
end


function RestockBait()
  if debugvariable then
    yield("/echo Debug: Restocking bait from the Mender")
  end
  
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
  
  --Purchase Diadem Balloon Bugs until your inventory has more than 100 of them (i.e. somewhere between 101 and 198, a.k.a. more than enough for the max case, two identical full umbral windows)
  while BalloonBugCount < 100 do
    if debugvariable then
	  yield("/echo Debug: Buying Balloon Bugs.")
	end
    yield("/pcall Shop true 0 3 99 0")
	yield("/wait 0.5")
    if IsAddonVisible("Shop") then --Again, we don't know if the user has YesAlready configured
      yield("/pcall SelectYesno true 0")
	  yield("/wait 0.5")
    else end
    BalloonBugCount = GetItemCount(30278)
  end
  
  --...Do the same for Diadem Red Balloons...
  while RedBalloonCount < 100 do
    if debugvariable then
	  yield("/echo Debug: Buying Red Balloons.")
	end
    yield("/pcall Shop true 0 4 99 0")
	yield("/wait 0.5")
    if IsAddonVisible("Shop") then
      yield("/pcall SelectYesno true 0")
	  yield("/wait 0.5")
    else end
    RedBalloonCount = GetItemCount(30279)
  end
  
  --...And for Diadem Crane Flies
  while CraneFlyCount < 100 do
    if debugvariable then
	  yield("/echo Debug: Buying Crane Flies.")
	end
    yield("/pcall Shop true 0 5 99 0")
	yield("/wait 0.5")
    if IsAddonVisible("Shop") then
      yield("/pcall SelectYesno true 0")
	  yield("/wait 0.5")
    else end
    CraneFlyCount = GetItemCount(30280)
  end

  --There's not strictly a need to exit the Mender menu since the next step could be unmounted movement, but better safe than sorry because you can't mount up while you're in the chat menu and mounting is faster :3
  yield("/pcall Shop true -1")
  yield("/wait 0.5")
  if debugvariable then
    yield("/echo Debug: Done with bait shopping. Moving on.")
  end
end

--Wait for the weather to change away from Snow. We don't care what it is as long as it's not snow, since in the Diadem the only options are Snow and some kind of Umbral
--Diadem weather alternates between 10 minutes of snow -> 10 minutes of something Umbral (I don't know if the Umbral pattern is "goes in a cycle" or "pick 1/4 at random". I also don't care.)
function WaitForUmbralWeather()
  if debugvariable then
    yield("/echo Debug: Waiting for Umbral weather.")
  end
  
  --Time passes IRL at a rate of one second per second
  while GetActiveWeatherID() == 15 do
    yield ("/wait 1")
  end
end

--If the weather isn't Snow, it's Umbral, and we should be fishing for the next ten minutes. We don't even need to track that time, because the weather change handles it.
function MoveToFishingPoint()
  if debugvariable then
    yield("/echo Debug: Moving to a new Umbral fishing point.")
  end
  
  --Select a new fishing point to dodge amiss. this is currently NOT working and just overcomplicating everything
  OldFishingPoint = NewFishingPoint
  
  while OldFishingPoint == NewFishingPoint do
    NewFishingPoint = math.random(1,7) --Yes, this *can* theoretically reroll forever at a chance of (1/7) ^ (infinity). Did you know every game of Tetris theoretically will end when you get enough Z pieces in a row?
  end
  
  --Time for the loveliest if statement you've ever seen. I picked seven points along the curve of the island as possbile fishing points. This isn't even RELEVANT anymore because I just reinstance every 40.
  if NewFishingPoint == 1
    then
	yield("/visland moveto 310 282 -626")
    elseif NewFishingPoint == 2
    then
	yield("/visland moveto 301 282 -626")
    elseif NewFishingPoint == 3
    then
	yield("/visland moveto 291 282 -627")
    elseif NewFishingPoint == 4
    then
	yield("/visland moveto 282 282 -630")
    elseif NewFishingPoint == 5
    then
	yield("/visland moveto 276 283 -637")
    elseif NewFishingPoint == 6
    then
	yield("/visland moveto 270 283 -643")
    elseif NewFishingPoint == 7
    then
	yield("/visland moveto 263 283 -645")
    else --We should never hit this else statement, because we hardcoded the seven possible values of newfishingpoint. Would you believe I've written uglier if statements in my life? Because I sure have.
    yield("/echo Something went incredibly wrong with fishing point selection. Random(1,7) yielded a value that was not an integer between one and seven inclusive. Quitting, with my sincere apologies...")
    DeleteSelectedAutoHookPreset()
    yield("/snd stop")
  end
  
  --Wait for the movement to the selected fishing point to finish
  while IsMoving() do
    yield("/wait 1")
  end
  
  --We need to be facing the fishing hole in order to fish. That's "outwards", aka "the direction we can't run any further in", so if we run into the wall we're guaranteed to be facing the proper direction
  --Set a run point that's far enough out in the sky from all seven points that we're always facing outwards, then run to it for long enough that we hit the wall
  yield("/visland moveto 297 283 -555")
  yield("/wait 2")
  yield("/visland stop")
  yield("/wait 1")
  if debugvariable then
    yield("/echo Debug: We should be in fishing position now. Just in case, the fishing point selected was number " .. NewFishingPoint)
  end
end

--Equip the appropriate bait for the Umbral fish for the weather that's currently happening:
--Umbral Flare: catch Cometfish with Diadem Balloon Bug, fish item id 30010
--Umbral Duststorm: catch Anomalocaris with Diadem Red Balloon, fish item id 30011
--Umbral Levin: catch Cloudshark with Diadem Red Balloon, fish item id 31602
--Umbral Tempest: catch Archaeopteryx with Diadem Crane Fly, fish item id 31600
--All four are non-Mooch !!! catches at Windbreaking Cloudtop (27,8) only during Umbral weather. (Windbreaking Cloudtop has no other !!! bites)
--There are better Umbral fish rates with Mooch during Flare and Duststorm elsewhere, and the rate on mooching Griffins in Tempest elsewhere is comparable but yields more scrip... but this single hole is way easier to automate.
function SelectBait()
  if debugvariable then
    yield("/echo Debug: Selecting bait.")
  end
  
  if GetActiveWeatherID() == 133 --Umbral Flare
    then
      BaitName = 'Balloon Bug'
      WeatherName = 'Flare'
      ActiveUmbralFishID = 30010
      FishName = 'Cometfish'
    elseif GetActiveWeatherID() == 134 --Umbral Duststorm
    then
      BaitName = 'Red Balloon'
      WeatherName = 'Duststorm'
      ActiveUmbralFishID = 30011
      FishName = 'Anomalocaris'
    elseif GetActiveWeatherID() == 135 --Umbral Levin
    then
      BaitName = 'Red Balloon'
      WeatherName = 'Levin'
      ActiveUmbralFishID = 31602
      FishName = 'Cloudshark'
    elseif GetActiveWeatherID() == 136 --Umbral Tempest
    then
      BaitName = 'Crane Fly'
      WeatherName = 'Tempest'
      ActiveUmbralFishID = 31600
      FishName = 'Archaeopteryx'
    elseif GetActiveWeatherID() == 15 --Snow. Somehow this can actually happen with poor timing? I should probably do something about it but the only cost is possibly wasting some bait and time so I won't.
    then
      yield("/echo We thought it was Umbral when we started checking, but it's actually Snow now. Boo. Doing nothing.")
    else
      yield("/echo We thought it was Umbral, but it's actually neither Umbral nor Snow. This should be impossible. Did you leave the Diadem?") --Seriously, you probably left the Diadem without stopping the script. It happens.
      DeleteSelectedAutoHookPreset() --Clean up after ourselves...
      yield("/snd stop") --...and quit.
	end

  --Track fish counts, because it's fun to read automated logs
  StartingFishCount = GetItemCount(ActiveUmbralFishID)
  
  yield("/echo Changing bait to Diadem " .. BaitName .. " to fish for " .. FishName .. " during Umbral " .. WeatherName .. ".")
  yield("/bait Diadem " .. BaitName) --I'll be damned, this SimpleTweaks function doesn't take double quotes around the bait name, just raw text
  yield("/wait 0.5") --Pause to actually switch the bait, I don't know if it's needed but I'm superstitious
  yield("/bait Diadem " .. BaitName) --There's no kill like overkill. Let's make REALLY sure.
  yield("/wait 0.5") --See two lines above
end

function FishDuringUmbralWeather()
  if debugvariable then
    yield("/echo Debug: Fishing during Umbral " .. WeatherName .. ".")
  end
  
  --We just pointed ourselves in the correct direction and equipped the correct bait, so once we start casting AutoHook will handle the rest
  yield('/ac "Cast"')
  
  --While it's not Snowing, wait for one second until it is, because if it's Snowing it's not Umbral so it's not fishing time anymore
  while GetActiveWeatherID() ~= 15 do
    yield ("/wait 1")
  end
  
  if debugvariable then
    yield("/echo Debug: It should be snowing now. Stopping fishing.")
  end
  
  --Technically, you are about 95% to be in the middle of a Cast that snapshotted during Umbral weather at this point - stopping immediately is throwing away an expected value of something like 0.004 Umbral fish per minute
  --Optimally, you'd check really often for "condition 42" = during a Chum, Cast, or Hook animation. Then you only make a mistake if you are halfway through a cast animation when the weather changes (even rarer!)
  --That said, I don't like having loops that run more frequently than one second, because I've locked up FFXI with too many loops without time conditions.
  while GetCharacterCondition(6) do
    if debugvariable then
	  yield("/echo Debug: Trying to stop fishing. Our current condition is:")
      yield("/echo Debug: Any gathering status: " .. tostring(GetCharacterCondition(6)))
      yield("/echo Debug: Fishing status: " .. tostring(GetCharacterCondition(43)))
      yield("/echo Debug: Mid-animation status: " .. tostring(GetCharacterCondition(42))) --how on earth does this return both true and false?
	end
    yield('/ac quit') --Cancel fishing. Apparently there is a vanilla text command for this that everyone but me already knew?! I do literally all my fishing with autohook lol lmao etc
    yield("/wait 1")
  end
  
  --Now that we are done fishing, we must have at least started to put our rod away. Wait for that to finish for sure and then move back to the last point of the arrival route. Wasted time irrelevant because it's Snowing.
  yield("/wait 2")
  yield("/visland moveto 285 285 -636")
  yield("/wait 1")
  
  while IsMoving() do
    yield("/wait 1")
  end
  yield("/visland stop") --Just in case we somehow didn't get to our destination AND also stopped moving, which I believe is impossible but I am not about to risk it
  
  if debugvariable then
    yield("/echo Debug: We are done fishing. Waiting for the next weather change.")
  end
  
  EndingFishCount = GetItemCount(ActiveUmbralFishID)
  RequestAchievementProgress(2549)
  yield("/wait 1") --Per croizat, a wait is required here to actually return the correct value
  HoldingVariable = GetRequestedAchievementProgress() --Don't update the tracking variable directly. We want to report out, not end the entire function mid-loop if you just hit 100. Oops.
  TotalCount = tonumber(HoldingVariable) --This is redundant, since I tostring it again below. Oops. I could just use HoldingVariable instead below, etc. but it ain't broke so don't fix it.
  
  yield("/echo During the last Umbral weather, you caught " .. (EndingFishCount-StartingFishCount) .. " " .. FishName .. " for a new total of " .. TotalCount .. " Umbral fish. Only " .. (100-tostring(TotalCount)) .. " more to go!")
end

function DiademFishingLoop()
  if debugvariable then
    yield("/echo Debug: Diadem Fishing Loop has been called, so either you just entered the Diadem or it just started snowing.")
  end
  
  --Wait for Snow to stop, which means Umbral weather has begun
  yield("/echo Waiting for Umbral weather.")
  WaitForUmbralWeather()
  
  --Set appropriate bait for the Umbral weather
  yield("/echo Umbral weather has begun. Fishing.")
  SelectBait()
  
  --Get to a fishing point
  MoveToFishingPoint()
  
  --Fish until it becomes Snow again
  FishDuringUmbralWeather()
  
  --Update your counter to see if you have the achievement yet (then repeat)
  RequestAchievementProgress(2549)
  yield("/wait 1") --wonder if this is why the achievement menu lags?
  HoldingVariable = GetRequestedAchievementProgress() --You want to see destruction in human form? Here it is, your boy holding variable
  NumberOfUmbralFishCaught = tonumber(HoldingVariable)
end

--Container loop for the whole function, so that we only have to call this function when the script is started to loop until we're done
function BeBotting()
  yield("/echo Dauntless Treader script has begun.")
  
  --Elegance upgrade: add an end state of "we have the achievement"
  RequestAchievementProgress(2549)
  yield("/wait 1")
  HoldingVariable = GetRequestedAchievementProgress()
  NumberOfUmbralFishCaught = tonumber(HoldingVariable)
  
  yield("/echo Current progress is " .. NumberOfUmbralFishCaught .. " out of 100 Umbral fish.")
  
  --Technically this "wants" to be while RequestAchievementProgress < 100... but that would spam the server with RequestAchievementProgress requests so we are absolutely, positively, 100% NOT doing that
  while NumberOfUmbralFishCaught < 100 do
    --Make sure we are in the Firmament
    InitialStartup()
    
    --Enter the Diadem
    EnterDiadem() 
    
    --Log the Diadem entry time and move to the fishing island
    InitialDiademEntryMove()
    
    --While we entered the Diadem less than 40 minutes ago, until we're done, fish during Umbral weather and wait during Snow
    while ((os.time() < DiademEntryTime + 2400) and (NumberOfUmbralFishCaught < 100)) do
      DiademFishingLoop()
    end
  end
  
  DeleteAllAutoHookAnonymousPresets() --Clean up after ourselves
  yield("/echo If you see this message, you should have Dauntless Treader III. Good job!") --Don't need a snd stop after this, because it's the end of the only function we have called
  yield("/snd stop") --...actually, it turns out we do need it, or else we get a "Peon has died unexpectedly." message, which is very rude to see because frankly, I expected the peon to die here. He's done working! Capitalism!
end

--The purpose of the function immediately above is to make it so the actual "meat" of this script, when run, consists of this single line. consider it a reminder of what you should be doing to get this achievement:
BeBotting()
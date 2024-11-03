function InitialStartup()
  yield("/tweaks enable maincommandcommand") --guarantees that this command is enabled. this is the correct name because the tweak we are enabling is "Main Command Command", even though this is ridiculous looking
end

--currently only exists to test automated exp grabbing
function GetShadowbringersExp()

--pcall Dawn 12 0 toggles Alphinaud in/out of the party, which will be relevant LATER but is not relevant NOW
--1 Alisaie 2 Thancred 3 Urianger 4 Yshtola 5 Ryne[shb]/Estinien[ew] 6 Graha (it goes in order)

--pcall Dawn 16 [same id as above] selects them in the right panel
--this is relevant because it will get their exp total

--node 1 is the only node in "Dawn" so that comes first every time
--inside that, node 86 is the component node with information on the selected trust member on the right
--inside that, 3 is the res node within that that holds everything below this line:
--14 holds 15 holds 2 holds the trust's level
--9 holds 12 holds current xp and 13 holds total exp to next level
--4 holds trust's name
  if IsAddonVisible("Dawn") then --if Trust menu is visible, do nothing (using this command when it is open will close it, because SE hates me)
  else
    yield("/maincommand Trust") --otherwise, open the Trust menu, which does not use the command "Dawn" because that's an internal menu name... why is this case sensitive?!
    yield("/wait 1") --wait a second for it to open - I've had bad lag before but never worse than one second on this menu so it should be fine
  end

--check whether Shadowbringers or Endwalker is selected by checking the contents of party member id 5's name (Ryne/Estinien)
yield("/pcall Dawn true 16 5") --selects the sixth trust slot, Ryne/Estinien, in the right panel
yield("/wait 1")
ExpansionPackTrustsName = GetNodeText("Dawn", 23, 15)
yield("/echo The currently selected trust is " .. ExpansionPackTrustsName)

if ExpansionPackTrustsName == "Ryne"
  then SelectedExpansion = "Shadowbringers"
elseif ExpansionPackTrustsName == "Estinien"
  then SelectedExpansion = "Endwalker"
else
  yield("/echo Somehow we didn't get a name we expected. Quitting...")
  yield("/snd stop")
end

yield("/echo ...which means we're doing dungeons from " .. SelectedExpansion)

--select Shadowbringers, if that isn't currently selected
if SelectedExpansion ~= "Shadowbringers"
then
  yield("/pcall Dawn true 20 0")
else end

--to grab the current exp for each trust, we have to select them first, so iterate from 0 to 6, 1 at a time
for i = 0, 6, 1 do
  yield("/pcall Dawn true 16 " .. i) --select the i'th trust
  yield("/wait 1") --this definitely does not need to be the full 1, but there's no reason not to...
  CurrentTrustName = GetNodeText("Dawn", 23, 15)
  CurrentTrustLevel = GetNodeText("Dawn", 23, 5, 0)  --Looks right, but doesn't work for me (signed plottingcreeper, but it doesn't work for me either, I think maybe the counter node is not actually functional)
  CurrentTrustExperience = GetNodeText("Dawn", 23, 8)
  CurrentTrustTNL = GetNodeText("Dawn", 23, 9)
  
  --echo all this information out
  yield("/echo The selected trust is " .. CurrentTrustName .. ", who is level " .. CurrentTrustLevel .. " at " .. CurrentTrustExperience .. "/" .. CurrentTrustTNL .. " to the next level.")
end

end

--currently does nothing. going to make it a copy of shadowbringers to make sure it works for both, eventually
function GetEndwalkerExp()

  if IsAddonVisible("Dawn") then --this should always be the case because we just opened it above
  else
    yield("/maincommand Dawn") --but if we messed up, open the Trust menu again
    yield("/wait 1") --and wait for it to open
  end

--check selected expansion, see notes under Shadowbringers
yield("/pcall Dawn true 16 5")
yield("/wait 1")
ExpansionPackTrustsName = GetNodeText("Dawn", 23, 15)
yield("/echo The currently selected trust is " .. ExpansionPackTrustsName)

if ExpansionPackTrustsName == "Ryne"
  then SelectedExpansion = "Shadowbringers"
elseif ExpansionPackTrustsName == "Estinien"
  then SelectedExpansion = "Endwalker"
else
  yield("/echo Somehow we didn't get a name we expected. Quitting...")
  yield("/snd stop")
end

yield("/echo So the currently selected expansion must be " .. SelectedExpansion)

--select Endwalker, if that isn't currently selected
if SelectedExpansion ~= "Endwalker"
then
  yield("/pcall Dawn true 20 1")
else end


  if IsAddonVisible("Dawn") then --this should always be the case because we just opened it above
  else
    yield("/maincommand Dawn") --but if we messed up, open the Trust menu again
    yield("/wait 1") --and wait for it to open
  end

--check selected expansion, see notes under Shadowbringers
yield("/pcall Dawn true 16 5")
yield("/wait 1")
ExpansionPackTrustsName = GetNodeText("Dawn", 23, 15)
yield("/echo The currently selected trust is " .. ExpansionPackTrustsName)

if ExpansionPackTrustsName == "Ryne"
  then SelectedExpansion = "Shadowbringers"
elseif ExpansionPackTrustsName == "Estinien"
  then SelectedExpansion = "Endwalker"
else
  yield("/echo Somehow we didn't get a name we expected. Quitting...")
  yield("/snd stop")
end

yield("/echo So the currently selected expansion must be " .. SelectedExpansion)



end

function EnterCorrectDungeon()
--pcall Dawn 20 0 switches to Shadowbringers
--pcall Dawn 20 1 switches to Endwalker

--shadowbringers:
--pcall Dawn 15 0 selects Holminster Switch
--1 Dohn Mheg 2 Qitana Ravel 3 Malikah's Well 4 Mount Gulg

--endwalker:
--pcall Dawn 15 0 is Tower of Zot
--1 Babil 2 vanaspati 3 ktisis 4 aitiascope

end

--Container loop for the whole function, so that we only have to call this function when the script is started to loop until we're done
function MainFunctionLoop()
  yield("/echo Trust leveling 71-90 script has begun.")

  InitialStartup()
  
  --currently this just queries trusts for exp
  GetShadowbringersExp()
  
  --and we'll do Endwalker too 1) to get Estinien and 2) to make sure all the transitions work properly
  GetEndwalkerExp()

  --eventual plan:
  --checktrustexp()
  --entercorrectdungeon()
  --runthedungeon() --separate function per dungeon to make it easier
  --then repeat, I don't think there's anything else you'd need to do? ooh we could add a variable to turn in every item for gc seals after every run

  yield("/snd stop") --end the script
end

MainFunctionLoop()



--my notes from trying to make this work:
--when you're in UI debug, go Focused Units -> Dawn to find these
--Dawn is the name of the pcall for basically everything in this menu
--pcall Dawn 15 0 selects Holminster Switch, 1 Dohn Mheg 2 Qitana Ravel 3 Malikah's Well 4 Mount Gulg 5 Amaurot
--pcall Dawn 20 0 switches to Shadowbringers, pcall Dawn 20 1 switches to Endwalker
--node with all the trusts in it is [#89] Res Node ptr = 1FF8DBEAFF0
--then nodes 98-101 have child node that has child node that has child node that has child node of type Counter 

--the entire party information, can we pull it all at once? don't think it's loaded when unselected but we'll see

--FOR ENDWALKER:
--node 64 is the right box with the party showing
--72-77 are the nongraha trusts left to right, then 71 is graha on the far right

--FOR SHADOWBRINGERS:
--node 49 is the right box with the party
--dunno trust numbers

--FOR BOTH:
--node 86 is the base component node with information on the selected trust member on the right
--3 is the res node that holds everything
--14 holds 15 holds 2 holds the trust's level
--9 holds 12 holds current xp and 13 holds total exp to next level
--THESE are text nodes, can we make this work?

--getnodetext will return the last index you passed in if it fails, so if you see "2" instead of what you're supposed to get, that's why
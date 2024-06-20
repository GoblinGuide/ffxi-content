--TODO:
--POMANDERS FOR BOSS (use strength, check quantities of strength and steel)
--ACTUALLY WATCH THIS THING RUN TO CONFIRM IT WORKS:
--PATHING (have seen some fuckups here for sure but they looked like visland failures... just had another, what's up with that?)
  --DUPLICATE CHECK FAILURE AND SUCCESS
  --GOING TO A NEW FLOOR
  --BEHAVIOR WHEN THERE ARE NO NEW POINTS (and random points)
--ACCEPTING DEATH
--RESETTING SAVE
--SPENDING AETHERPOOL
--MAYBE CREATE A MOVEMENT FUNCTION THAT HAS A WHILE LOOP FOR A 120 SECOND TIMEOUT OR SOMETHING, POTD ISN'T THAT BIG BUT VNAVMESH WILL OCCASIONALLY JUST RUN INTO WALLS FOR NO REASON
--IT'S RUNNING WHOLE LOOP ONCE RATHER THAN REDOING IT EVERY TIME




--Instance, repair, and move loop code stolen from flug, who in turn borrowed some of it from earlier existing SND community scripts
--everything else by Unfortunate. never used a "license" in my life. feel free to steal all of it and modify however you want and leave my name off it altogether. we're all friends here. is this "copyleft"? idk.

--Required Starting Condition:
--Whichever PotD save slot you want to use (configured on line 21 below) is empty.

--Required Plugins:
--VNAVMESH is used for all navigation - MANDATORY
--TELEPORTER is used to teleport to Quarrymill from anywhere.
  --not needed if you always start this bot from Quarrymill.
--ROTATION SOLVER (whether reborn: https://github.com/FFXIV-CombatReborn/RotationSolverReborn or the old one) is used to automate combat inside PotD - MANDATORY
  --1) Make sure it's not configured to urn off upon zone change, duty end, or death.
  --2) Make sure that Target -> Configuration is set to "All targets when solo, or previously engaged." in the first dropdown. That way you will kill things that haven't aggroed you yet.

--yeah, that's right, we're using math dot random to look marginally less like a bot (...marginally.)
math.randomseed(math.floor(os.clock()*1000000)) --wow, math.randomseed only takes integers? oh well, we invented the float function for a reason

--Set this variable to 'true' to spam your log with debug messages. You likely do not need this, unless either 1) someone specifically asked you to or 2) you're trying to modify this script yourself.
DebugVariable = true

--Set this variable to 1 to use the first save slot or 2 to use the second save slot. THIS IS DIFFERENT FROM WHAT THE EXISTING ACCURSED HOARD FARMER FOR HOH DOES. BE CAREFUL IF YOU CARE ABOUT YOUR SAVES.
SaveSlot = 2

--just in case anyone is actually reading this: all of PotD is flat. The y-coordinate for every point is functionally 0. So I hardcoded "0" into every movement's Y and called it a day. That's why coordinates are (X, Z).
--Make sure we're on MCH... or at least warn if we're not. then get to the entry NPC.
function InitialStartup()

  if DebugVariable then
    yield("/echo Initial startup function has begun.")
  end
  
  --check for being a MCH, but don't actually break if you're not. if you want to be a brd or I guess a smn that probably also works okay?
  if GetClassJobId() ~= 31 then
    yield("/echo You're not currently a MCH! I hope you know what you're doing. Bot's not stopping for that, just letting you know.")
  else end --if we're MCH, no need for any message here
    
  --if we are not in South Shroud, teleport to Quarrymill
  if (not IsInZone(153)) then
    yield("/echo Began Aetherpool farmer script outside South Shroud. Going there.")
    
    --option 1: we are in a duty. leave it, then wait to leave it, then carry on.
    if GetCharacterCondition(34) then
  
      if DebugVariable then
      yield("/echo Began bot inside a duty. Leaving duty.")
    end
    
      LeaveDuty()
    yield("/wait 10") --this is almost certainly overkill, but that's what you get for starting this bot inside a duty. how rude.

      --now we've left the duty.
    end
  
    --option 2: we are not in a duty. we can just teleport.
    if DebugVariable then
      yield("/echo Teleporting to Quarrymill.")
    end

    --teleport to Quarrymill
    yield("/tp Quarrymill")
    yield("/wait 6") --Wait for Teleport cast to finish before checking for loading status, since we won't be loading before the cast is done
  
    --Wait for teleport to finish in two-second intervals
    while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
      
      if DebugVariable then
      yield("/echo Waiting 2 seconds to finish teleporting to Quarrymill.")
    end
  
      yield("/wait 2")

      --end of teleport waiting loop
    end

    --end of "is not in South Shroud" if statement
  end
  
  if DebugVariable then
    yield("/echo Debug: Moving to the entry NPC.")
  end
    
  --now we are in South Shroud. you *can* be a punk and start from Camp Tranquil, but then vnavmesh will walk across the damn zone to Quarrymill, because I hate you personally, punk.
  --move to the Wood Wailer Expeditionary Captain, which is the direction with lower (smaller positive) X and lower (more negative) Z.
  --we pick a random value in the range (1,3) in both of those directions to look marginally less like a bot. marginally. in practice it took me one minute to write and has almost zero payoff but it's free :)
  yield("/vnavmesh moveto "
  .. string.format("%.2f", GetObjectRawXPos("Wood Wailer Expeditionary Captain") - math.random(1,2) - math.random()) --technically, since the Captain does not move, I could hardcode this, but why risk it?
  .. " " .. string.format("%.2f", GetObjectRawYPos("Wood Wailer Expeditionary Captain")) .. " "
  .. string.format("%.2f",GetObjectRawZPos("Wood Wailer Expeditionary Captain") - math.random(1,2) - math.random())
  )
  
  --wait to start moving so that ismoving actually says yes to are we moving
  yield("/wait 1")
  
  --wait to arrive. now we are there.
  while IsMoving() do
    yield("/wait 1")
  end

  if DebugVariable then
    yield("/echo Debug: Arrived at the entry NPC. Initial startup function complete.")
  end

end

--Enter PotD
function EnterPalace()

  if DebugVariable then
   yield("/echo Debug: Enter Palace function has begun.")
  end
  
  --If we haven't queued up, queue up and enter
  if GetCharacterCondition(34, false) and GetCharacterCondition(45, false)
  then
    
    --target entry NPC
    yield('/target "Wood Wailer Expeditionary Captain"')
    yield("/wait 1")
    
    --talk to him
    yield("/pinteract")
    yield("/wait 1")
  
    --the first menu you can't easily skip with YesAlready, since it has both the option to enter and the option to reset your save, both of which this bot uses.
    yield("/pcall DeepDungeonMenu true 0")
    yield("/wait 1")
  
    --theoretical future improvement: we're in the save slot selection menu now, we can see if our save already exists - this prevents a fail state where the user did not read the directions. but that can wait.
  
    if DebugVariable then
      yield("/echo Debug: Selecting save slot " .. tostring(SaveSlot - 1))
    end
  
    --now we're in the save slot selection menu. again, yesalready cannot skip this. 
    --SaveSlot is the human readable variable that is either 1 or 2. the game itself calls them slots 0 and 1, so subtract one to get the proper indexing.
    yield("/pcall DeepDungeonSaveData true " .. tostring(SaveSlot -1))
  
    --next is the box for "enter with a fixed party" and not using party finder, which yesalready can skip.
    if IsAddonVisible("SelectString") then
      yield("/pcall SelectString true 0")
      yield("/wait 1")
    end
  
    --next, "are you sure you wish to enter with a fixed party?" which yesalready can skip.
    if IsAddonVisible(SelectYesNo) then
      yield("/pcall SelectYesNo true 0")
      yield("/wait 1")
    end
  
    --next there's some dialog that you can skip with TextAdvance, but if you don't, advance through it
    if IsAddonVisible("Talk") then
      yield("/click talk")
      yield("/wait 1")
    end
  
    --next there's "are you sure you wish to enter alone?" which yesalready can skip
    if IsAddonVisible(SelectYesNo) then
      yield("/pcall SelectYesNo true 0")
      yield("/wait 1")
    end
  
    --and finally, "From which floor will you enter?" (1 or 51), which yesalready can ALSO skip by telling it "floor one" every time
    if IsAddonVisible("SelectString") then
      yield("/pcall SelectString true 0")
      yield("/wait 1")
    end
  
    if DebugVariable then
      yield("/echo Debug: Duty Finder popup should be appearing now.")
    end
  
    --now we should have a duty finder up, so confirm it if you don't have confirmation on
    if IsAddonVisible("ContentsFinderConfirm") then
      yield("/pcall ContentsFinderConfirm true 8")
    end
  
  
    if DebugVariable then
      yield("/echo Debug: Duty Finder should have been confirmed. Waiting to enter PotD.")
    end
  
    --Wait until we start entering, then wait until we're done entering, then wait 3 for a little more load time and theoretically we should be in Palace now.
    while GetCharacterCondition(35, false) do
      yield("/wait 1")
    end
    
    while GetCharacterCondition(35) do
      yield("/wait 1")
    end
    
    yield("/wait 3") 

    --end of the "if we haven't queued up, queue up and then enter" loop
  end
   
  --having made it here, we are theoretically inside PotD. yay us!   
  if DebugVariable then
    yield("/echo Debug: We should be in PotD.")
  end

end

--this is just a big loop to clear ten floors
function ClearPalace()
  
  if DebugVariable then
    yield("/echo Debug: Clear Palace function has begun.")
  end
  
  --while the player is both (not unconscious [i.e. alive]) and (in deep dungeon [i.e. in PotD]), clear the dungeon
  while ((not GetCharacterCondition(2)) and GetCharacterCondition(79)) do
    
    if DebugVariable then
      yield("/echo Debug: Beginning the Clear Palace loop now.")
    end
    
    --the first nine floors are functionally identical, so we will clear them identically.
    for LoopCount = 1, 9 do
    
      if DebugVariable then
        yield("/echo Debug: Clear Palace loop beginning to clear floor " .. LoopCount .. ".")
      end
      
      --our starting location is a place we can definitely move to - although currently I don't ever want to - so record it just in case
      InitialSpawnLocation = {tostring(GetPlayerRawXPos()), tostring(GetPlayerRawZPos())}
    
      if DebugVariable then
        yield("/echo Debug: Saved initial player spawn coordinates of X=" .. InitialSpawnLocation[1] .. ", Z=" .. InitialSpawnLocation[2])
      end
      
      --clear the list of relevant points from last floor. the future is the wave of the future, so it's time to say "so long" to the things of the past!
      InitializeVariables()
    
      --clear the floor, ending with a wait that overkills the time needed to load the next floor so that initial spawn location is properly loaded by the time the next loop starts
      ClearSingleFloor(LoopCount)
    end
    
    if DebugVariable then
      yield("/echo Debug: Clear Palace loop has arrived at floor ten. Clearing the boss...")
    end
    
    ClearBossFloor()
    
    --hopefully we never see this
    yield("/echo Debug: Clear Palace loop has cleared the boss, and should have left the dungeon, but did not. SOMETHING IS WRONG HERE!")
    yield("/echo Leaving PotD to hopefully restart the loops properly.")
    LeaveDuty()
    yield("/wait 10")

    --end of the "not dead and in PotD" loop
  end

end

--resets all the variables from the previous floor to zero
function InitializeVariables()
  
  if DebugVariable then
    yield("/echo Debug: Entered a new floor. Initializing variables.")
  end
  
  --note that initialspawnlocation is NOT cleared here. we just set it before we called this function.
  ExitLocation = {0, 0} --x coordinate and z coordinate. if the exit isn't in range when we look, it returns 0,0, so save some time and start with that populated (also y=0 but as usual we do not care)
  CairnOfReturnLocation = {0, 0} --this is literally unusable in solo play, but it does give us a waypoint to use for navigation
  DestinationList = {} --this is a list to fill with the coffers that we've found on the current floor
  OpenedCofferList = {} --easier to do this than delete from the list and worry about indexing
  LengthOfDestinationList = 0 --lua requires you to iterate a table to find its length, so instead, we'll track that automatically to be able to append to our destination list more easily at all times
  LengthOfOpenedCofferList = 0 --same note as length of destination list
  SkipThisCoffer = 0 --this will be reset for every coffer we find, but let's be sure. also, I don't know how global and local variables work lmao
  NumberOfBronzeCoffers = 0 --used to track the contents of the destination list
  NumberOfSilverCoffers = 0 --reset every floor
  NumberOfGoldCoffers = 0 --see above two comments

  if DebugVariable then
    yield("/echo Debug: Variables initialized.")
  end
  
end

--main floor clearing loop for floors 1-9. basically, look for every point of interest, go to the most interesting one (silver > working exit > gold > bronze > cairn of return > nonworking exit), open it if it's a coffer, repeat.
function ClearSingleFloor(FloorNumber)
  
  if DebugVariable then
    yield("/echo Debug: Clear Single Floor has been called for floor number " .. FloorNumber .. ".")
  end
  
  --while the exit isn't open, do all this stuff. I also check this progress elsewhere in the loop, but that's okay. we can be redundant as long as it works.
  while GetDDPassageProgress() < 100 do
  
    if DebugVariable then
      yield("/echo Debug: New Clear Single Floor loop has begun.")
    end

    --step one: look for the exit.
    if DebugVariable then
      yield("/echo Debug: Clear Single Floor is looking for the exit.")
    end

    LookForTheExit()
    
    --steps two through four: look for coffers, in priority order (not that the order matters)
    if DebugVariable then
      yield("/echo Debug: Clear Single Floor is looking for silver coffers.")
    end

    LookForCoffers('Silver')

    if DebugVariable then
      yield("/echo Debug: Clear Single Floor is looking for gold coffers.")
    end

    LookForCoffers('Gold')

    if DebugVariable then
      yield("/echo Debug: Clear Single Floor is looking for bronze coffers.")
    end

    LookForCoffers('Bronze')
    
    --step five: get the Cairn of Return coordinates - it does literally nothing solo but gives us one more waypoint to navigate to
    if DebugVariable then
      yield("/echo Debug: Clear Single Floor is looking for the Cairn of Return.")
    end

    LookForTheOtherCairn()
  
    --step six: we have now saved the coordinates of every relevant object that we can see from our current location (this is about 3 rooms out in any direction), so go somewhere else
    --priority order is silver, cairn of passage to leave the floor if it's unlocked, gold, bronze, cairn of return just to move, cairn of passage even if it's not yet unlocked, stand around like a bloody idiot
    if DebugVariable then
      yield("/echo Debug: Clear Single Floor is done looking for everything. Now selecting a destination to move to.")
    end

    MoveToTheNextDestination()

    --end of the loop that only runs while the exit is closed
  end
  
  if DebugVariable then
    yield("/echo Debug: Clear Single Floor has determined that the passage is open and isn't looking for anything right now. Attempting to move to the exit.")
  end
  
  --if we got here, the exit is open and we have finished the loop where we find destinations, so go to the next floor
  --possible future todo: this takes us straight to the exit so we skip silvers - is this a relevant complaint? 
  MoveToTheExit(100) --removing calling in with that function to see if it fixes the crash
  
end

--finds the Cairn of Passage. if we have found it already, does nothing.
function LookForTheExit()
  
  if DebugVariable then
    yield("/echo Debug: Entered Look For The Exit loop.")
  end
  
  --only look for the exit if we haven't already found it
  if (ExitLocation[1] == 0 and ExitLocation[2] == 0) then
  
    if DebugVariable then
      yield("/echo Debug: We don't already know where the exit is.")
    end
  
    PossibleExit = tostring(GetPassageLocation()) --this always returns something. if it fails, it's 0 0 0, if it finds it, it's X Y Z. but never nothing.
    XIndex, garbage = string.find(PossibleExit,",") --the first comma is right after the x coordinate. also, string.find really sucks and returns two variables even if you're finding a single character so they're equal.
    ZIndex, garbage = string.find(PossibleExit,",",XIndex+1) --the z coordinate is located immediately after the second comma, which means we want to start after the second comma, aka "the first comma AFTER the first comma".
    ColonIndex, garbage = string.find(PossibleExit,"):") --the coordinates terminate in "):" which is also the face I make when I see this whole block of code.
    XCoordinate = string.sub(PossibleExit,2,XIndex-1) --start after the fixed starting character, "(", and go until the character before the first comma to get the X coordinate.
    ZCoordinate = string.sub(PossibleExit,ZIndex+2,ColonIndex-1) --start after the second ", " and go until the "):" to get the Z coordinate.

    --end of the "do we already know where the exit is?" if statement
  end
  
  --safe assumption: the exit will never be at 0, 0. ten decimal places, we'll be fine, worst case it's at something insane like 2E-7. (actually witnessed as a y-coordinate...)
  if XCoordinate ~= 0 or ZCoordinate ~= 0 then
    ExitLocation[1] = XCoordinate
    ExitLocation[2] = ZCoordinate
  
  if DebugVariable then
      yield("/echo Debug: Found the exit at X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. ".")
    end
  
  else
  
    if DebugVariable then
      yield("/echo Debug: We did not find the exit this attempt. Must be somewhere else.")
    end

    --end of the "did we find the exit" if statement
  end

  if DebugVariable then
    yield("/echo Debug: Look For The Exit loop complete.")
  end

end

--generalized function to look for any type of coffer within loaded object range (which is NOT the entire floor, just about three rooms)
function LookForCoffers(CofferType)

  if DebugVariable then
    yield("/echo Debug: Look For Coffers has begun. Looking for " .. CofferType .. " Coffers within object range.")
  end

  --look, I know something called uh, indirect? indirection? something, I know you can run a function named get[VARIABLE]chestlocations but I don't know how and frankly at this point I'm too afraid to ask
  if CofferType == "Silver" then
    Chests = GetSilverChestLocations() --native SND function to get the coordinates of every silver chest in range, which is about three rooms away. this is NOT everything on the floor. I know I said that above too.
  elseif CofferType == "Gold" then
    Chests = GetGoldChestLocations() --same but golds
  elseif CofferType == "Bronze" then
    Chests = GetBronzeChestLocations() --same but bronzes
  else
    yield("/echo An incorrect coffer type was passed into the Look For Coffers function, and this will probably break. Go yell at the developer! It was: " .. CofferType .. ", just fyi.")
  end
      
  --only do anything if we actually found any coffers
  if Chests.Count > 0 then
    
    if DebugVariable then
      yield("/echo Debug: Function found " .. Chests.Count .. " " .. CofferType .. " coffers within range.")
    end
    
    --first loop: extract silver coffer information from the giant list we just got from the function
    for LoopOneVariable = 1, Chests.Count do
    
      if DebugVariable then
      yield("/echo Debug: Examining coffer number " .. LoopOneVariable .. ".")
      end
  
      Coffer = tostring(Chests[LoopOneVariable-1]) --croizat indexes from 0, so the i'th loop is the i'th coffer which has index i-1. sorry, I don't make the rules.
  
      if DebugVariable then
      yield("/echo Debug: Raw function output: " .. Coffer)
      end
    
      XIndex, garbage = string.find(Coffer,",") --the first comma is right after the x coordinate. ("garbage" is the end of the "," string, which we do not care about because we know the length)
      ZIndex, garbage = string.find(Coffer,",",XIndex+1) --the z coordinate is located immediately after the second comma, which means we want to start after the second comma, aka the first comma AFTER the first comma
      ColonIndex, garbage = string.find(Coffer,"):") --the coordinates end with "):" every time, so find where the colon is and we know where the coordinates end
      XCoordinate = string.sub(Coffer,2,XIndex-1) --start after "(" and go until first comma to get X coordinate
      ZCoordinate = string.sub(Coffer,ZIndex+2,ColonIndex-1) --start after the second ", " and go until "):" to get Z coordinate. also coincidentally the latter is the face I make when I see this code.
    SkipThisCoffer = 0 --begin by assuming that every coffer is new
  
    if DebugVariable then
      yield("/echo Debug: Checking for a duplicate entry for the coffer at X=" .. XCoordinate .. ", Z=" .. ZCoordinate)
      end

    --second loop inside first loop: make sure this coffer is new, i.e. does not already exist on the list
    for LoopTwoVariable = 0, (LengthOfDestinationList-2), 3 do --coffers are a triple, see notes below in movetothenextdestination which I wrote first even though it's lower down
  
        if DebugVariable then
        yield("/echo Debug: Duplicate check beginning. We are on loop iteration number " .. math.floor((LoopTwoVariable+3)/3) .. " out of " .. math.floor((LengthOfDestinationList/3)) .. ".") --floor not needed, I hate seeing "1.0"
        end
  
      --check whether we have already stored this coffer, by checking whether we've found a coffer within one yalm of it. close enough to true dupe check
      if (LengthOfDestinationList > 0) --oops. we can't have a duplicate if we don't have anything on the list to be a duplicate.
        and (math.abs(tonumber(DestinationList[LoopTwoVariable+2]) - XCoordinate) < 1) and (math.abs(tonumber(DestinationList[LoopTwoVariable+3]) - ZCoordinate) < 1) --if coffer coordinates match, it's a duplicate
        then
   
          SkipThisCoffer = 1
  
          if DebugVariable then
          yield("/echo Debug: Found a duplicate of that coffer. Moving on.")
          end
      
        else --otherwise, not a duplicate yet. do nothing (except this debug statement)
      
      if DebugVariable then
          yield("/echo Debug: Entry number " .. math.floor((LoopTwoVariable+3)/3) .. " on the existing coffer list was not a duplicate. Continuing duplicate check.")
          end
  
      end
    
      if DebugVariable then
        yield("/echo Debug: Single iteration of the duplicate coffer check for this coffer complete.")
        end
  end
  
      if DebugVariable then
      yield("/echo Debug: All iterations of the duplicate coffer check for this coffer complete.")
      end 
  
      --if we finished that loop and didn't find a duplicate in our list, it's a new coffer! add it to the list of coffers.
      if SkipThisCoffer == 0 then
      DestinationList[LengthOfDestinationList+1] = CofferType --we store a coffer as a three-dimensional vector: type of coffer, 
      DestinationList[LengthOfDestinationList+2] = XCoordinate --X coordinate,
      DestinationList[LengthOfDestinationList+3] = ZCoordinate --Z coordinate.
      LengthOfDestinationList = LengthOfDestinationList+3 --record that we have three more items in our destinations list, so that the next one is recorded immediately after it
  
        --tried looking up how to do this indirection thing in lua and got as far as "the _G namespace" and said no
        --this adds one to the count of "coffers of this type we haven't opened yet"
        if CofferType == "Silver" then
          NumberOfSilverCoffers = NumberOfSilverCoffers + 1
        elseif CofferType == "Gold" then
          NumberOfGoldCoffers = NumberOfGoldCoffers + 1
        elseif CofferType == "Bronze" then
          NumberOfBronzeCoffers = NumberOfBronzeCoffers + 1
        else --if this is going to break it breaks sooner than this because this is the second such check
        end

      if DebugVariable then
        yield("/echo Debug: New " .. CofferType .. " Coffer at X=" .. XCoordinate .. ", Z=" .. ZCoordinate .. " added to the list of extant coffers.")
        end

        --end of loop over LoopVariableTwo to check for existing duplicates
      end

    --end of loop over LoopVariableOne to extract all silver coffer information
    end

  else
    
    if DebugVariable then
      yield("/echo Debug: No " .. CofferType .. " Coffers found. Moving on to the next search.")
    end

    --end of the "how many coffers of this type do we have" if statement
  end

end
  
--find and store the coordinates for the Cairn of Return, which we can literally never use but is a waypoint that exists and we can navigate to
function LookForTheOtherCairn()
  
  if DebugVariable then
    yield("/echo Debug: Entered Look For The Other Cairn loop.")
  end

  --only look for the exit if we haven't already found it
  if (CairnOfReturnLocation[1] == 0 and CairnOfReturnLocation[2] == 0) then

    if DebugVariable then
      yield("/echo Debug: We do not know where the other cairn is. Looking for it now.")
    end

    XCoordinate = GetObjectRawXPos("Cairn of Return") --these also return 0 if they fail
    ZCoordinate = GetObjectRawZPos("Cairn of Return") --so we will have a 0 value if we have not found it yet *and* did not find it this time, which is perfect
  
    --safe assumption: this cannot actually spawn at the origin, since every "real" position has up to ten decimal places
    if not (XCoordinate == 0 and ZCoordinate == 0) then
      CairnOfReturnLocation[1] = XCoordinate
      CairnOfReturnLocation[2] = ZCoordinate

    if DebugVariable then
        yield("/echo Debug: Found the Cairn of Return at X=" .. CairnOfReturnLocation[1] .. ", Z=" .. CairnOfReturnLocation[2])
      end

    else

      if DebugVariable then
        yield("/echo Debug: We did not find the Cairn of Return this attempt. Must be somewhere else.")
      end

      --end of the "did we find the Cairn" check
    end

  else

    if DebugVariable then
      yield("/echo Debug: We already know where the Cairn of Return is. Not going to look for it again.")
    end

    --end of the "do we know where the Cairn is already" check
  end

  if DebugVariable then
    yield("/echo Debug: Look For The Other Cairn loop complete.")
  end

end

--main function used for evaluating the next destination via a very large set of if statements
function MoveToTheNextDestination()
  
  if DebugVariable then
    yield("/echo Debug: Moving to next destination.")
  end

  --priority order of destinations: unopened silver > working exit > unopened gold > unopened bronze > other cairn > nonworking exit
  --case one: we have a silver coffer left to open. that's what we're here for! go do it.
  if NumberOfSilverCoffers > 0 then
    OpenedCheck('Silver')
  end
  
  if DebugVariable then
    yield("/echo Debug: No silver coffers remaining on the destination list. Checking exit progress.")
  end

  --case two: no silver coffers left. check whether the exit is open, and whether we know where it is, and if yes to both, go there and leave, otherwise do not go there
  if GetDDPassageProgress() == 100 and (ExitLocation[1] ~= 0 or ExitLocation[2] ~= 0) then --exit can be at X,0 or 0,Z... theoretically.
  
    if DebugVariable then
      yield("/echo Debug: Exit found and open. Moving to it at X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. ".")
    end
  
    MoveToTheExit(100) --no sense calling function again, hardcoding 100
  
  elseif GetDDPassageProgress() < 100 and (ExitLocation[1] ~= 0 or ExitLocation[2] ~= 0) then
  
    if DebugVariable then
      yield("/echo Debug: Exit known (X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. ") but not yet open. Ignoring it for now.")
    end
  
  elseif GetDDPassageProgress() == 100 and (ExitLocation[1] == 0 and ExitLocation[2] == 0) then

    if DebugVariable then
      yield("/echo Debug: Exit is open, but we don't know where it is. Ignoring it for now.")
    end
  
  elseif GetDDPassageProgress() < 100 and (ExitLocation[1] == 0 and ExitLocation[2] == 0) then

    if DebugVariable then
      yield("/echo Debug: Exit is not yet open AND we don't know where it is. Back to work.")
    end
  
  else --should be impossible. so do nothing.
    yield("/echo This should be impossible. Please tell the developer how you managed this. Sorry. Leaving PotD and retrying.")
    LeaveDuty()
    yield("/wait 10")
  end

  if DebugVariable then
    yield("/echo Debug: Can't exit this floor yet. Moving on to gold coffers.")
  end

  --case three: no silvers, and can't leave yet. go to a gold coffer. for comments, see silver above.
  if NumberOfGoldCoffers > 0 then
    OpenedCheck('Gold')
  end

  if DebugVariable then
    yield("/echo Debug: No gold coffers remaining on the destination list. Moving on to bronze.")
  end

  --case four: we have no silver coffers left, we cannot leave, we have no gold coffers left. go to a bronze coffer to find some more enemies, and while we're there open it for the 1% or whatever shot at a potsherd.
  if NumberOfBronzeCoffers > 0 then
    OpenedCheck('Bronze')
  end

  if DebugVariable then
    yield("/echo Debug: No bronze coffers remaining on the destination list. Moving on to the Cairn of Return.")
  end

  --case five: we are out of coffers and the exit is not open. this sucks. go to the cairn of return if we know where it is and we are more than 30 yalms aka about half a room away from it
  if (CairnOfReturnLocation[1] ~= 0) and (CairnOfReturnLocation[2] ~= 0) --if we know where it is --COULD THIS BE A DATA TYPE PROBLEM?
    then
      
      if (GetDistanceToPoint(CairnOfReturnLocation[1], 0, CairnOfReturnLocation[2]) > 30) then --AND we are far away from it (so if we don't know where it is we never bother evaluating this)

        if DebugVariable then
          yield("/echo Debug: Traveling to the Cairn of Return.")
        end

        MoveAndOpenCoffer(CairnOfReturnLocation[1],CairnOfReturnLocation[2],'Cairn') --third parameter means "not coffer, do not open"

      else 
    
        if DebugVariable then
          yield("/echo Debug: We know where the Cairn of Return is, but believe that we are within 30 yalms of it. Not going there.")
          yield("/echo Debug: Current distance to the Cairn of Return is ".. GetDistanceToPoint(CairnOfReturnLocation[1], 0, CairnOfReturnLocation[2]))
          yield("/echo Debug: Player coordinates are X=" .. GetPlayerRawXPos() .. ", Z=" .. GetPlayerRawZPos() .. ".")
          yield("/echo Debug: Cairn coordinates stored are X=" .. CairnOfReturnLocation[1] .. ", Z=" .. CairnOfReturnLocation[2] .. ".")
        end

      --end of it statement checking for Cairn distance from player
    end

  else --this else means "we do not know where the Cairn is"

    if DebugVariable then
      yield("/echo Debug: We do not know where the Cairn of Return is.")
    end

    --end of if statement checking whether we know where the Cairn is
  end
  
  --case six: no coffers, exit closed, we already went to the cairn of return because we're less than half a room away from it.
  --if we know where the exit is, go there regardless of our current distance from it
  if GetDDPassageProgress() < 100 and (ExitLocation[1] ~= 0 or ExitLocation[2] ~= 0) then

    if DebugVariable then
      yield("/echo Debug: We don't have any good destinations and the exit isn't open, but we know where it is so we're going to it anyway.")
    end

    InsufficientProgress = GetDDPassageProgress() --this should be fine, documentation says GDPP returns an int32, so theoretically...?

    --like I said, we're moving to the exit
    MoveToTheExit(InsufficientProgress)

  end
  
  --getting here is the final catchall. no coffers left, been to the cairn of return, been to the exit and it stayed closed even after arrival. therefore, pick a random coffer and hope for mobs on the way there and back.
  if DebugVariable then
    yield("/echo We have reached the end of the object-movement loop without finding any more coffers or the exit. Going to a random coffer on our list to hopefully find more mobs and open the exit.")
  end

  JustGoSomewhere()

end

--evaluates whether a coffer in our destination list is one that we have already opened
function OpenedCheck(CofferType)

  if DebugVariable then
    yield("/echo Debug: Opened Check has begun. Checking the destination list for " .. CofferType .. " Coffers that have already been visited.")
  end

  --every third item in the destination list is "type of coffer" for a single coffer. the next two on the list are its coordinates. last item on the list occupies the three final slots, aka n-2, n-1, and n=lengthofdestinationlist
  --therefore, loop by threes and look in threes (starting with slots 1 2 3, ending with slots n-2 n-1 n where n equals lengthofdestinationlist)
  for LoopOneVariable = 1, (LengthOfDestinationList-2), 3 do

    --if the coffer is the type we passed in, then
    if DestinationList[LoopOneVariable] == CofferType then
        
      --default to planning to open it, unless we find a duplicate
      OpenThisCoffer = 1
      
      --next, confirm that we haven't already opened it by looking at every coffer that we have marked as already opened (really "already visited", we don't record whether opening fails)
      --since this list is stored in the same way, we can use the same format of loop to loop over the entire opened list
    for LoopTwoVariable = 1, (LengthOfOpenedCofferList-2), 3 do
        if OpenedCofferList[LoopTwoVariable] == CofferType --if this already-opened coffer is all three of "the same type"...
        and math.abs(OpenedCofferList[LoopTwoVariable+1] - DestinationList[LoopOneVariable+1]) < 1 --...and "within 1 yalm in X distance of the coffer we're looking at"... (fuck decimal places!)
        and math.abs(OpenedCofferList[LoopTwoVariable+2] - DestinationList[LoopOneVariable+2]) < 1 --...and "within 1 yalm in Z distance of the coffer we're looking at"...
        then
          
          --...then it's the same coffer. don't bother going there.
          OpenThisCoffer = 0

          if DebugVariable then
            yield("/echo Debug: Duplicate ".. CofferType .. " coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. " is being ignored.")
            yield("/echo Debug: The match found was a " .. CofferType .. " coffer at " .. OpenedCofferList[LoopTwoVariable+1] .. ", " ..  OpenedCofferList[LoopTwoVariable+2] .. ".")
          end

       else
          
          --otherwise this coffer isn't a duplicate, so we cannout rule out that it's new yet
          if DebugVariable then
            yield("/echo Debug: Non-match number " .. math.floor((LoopTwoVariable+2)/3).. " found for the " .. CofferType .. " coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
          end

        --end of the if statement that determines whether the new coffer is a duplicate of a specific already opened coffer
        end

        if DebugVariable then
          yield("/echo Debug: Duplicate comparison finished for " .. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
          yield("/echo Debug: Hopefully we either reported that it was a duplicate of an existing coffer or that it failed to be a duplicate every single time.")
        end

        --end of the for loop over LoopVariableTwo (the opened coffer list) that determines whether the new coffer is a duplicate of ANY already opened coffer
      end

      --once we get here, we're out of the duplicate check.
      if DebugVariable then
        yield("/echo Debug: Duplicate check loop complete for the " .. DestinationList[LoopOneVariable] .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
        yield("/echo Debug: And the results were...")
      end

      --if we still want to open the coffer, it is actually a new coffer. add it to the list of "opened" coffers (before we open it, heh)...
      if OpenThisCoffer == 1 then
        OpenedCofferList[LengthOfOpenedCofferList+1] = CofferType
        OpenedCofferList[LengthOfOpenedCofferList+2] = DestinationList[LoopOneVariable+1]
        OpenedCofferList[LengthOfOpenedCofferList+3] = DestinationList[LoopOneVariable+2]
        LengthOfOpenedCofferList = LengthOfOpenedCofferList + 3
          
        if DebugVariable then
          yield("/echo Debug: New " .. CofferType .. " Coffer found at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ". Going to open it.")
        end
                    
        --...then subtract one from the "coffers remaining to open" count for the appropriate type...
        if CofferType == "Silver" then
          NumberOfSilverCoffers = NumberOfSilverCoffers - 1
        elseif CofferType == "Gold" then
          NumberOfGoldCoffers = NumberOfGoldCoffers - 1
        elseif CofferType == "Bronze" then
          NumberOfBronzeCoffers = NumberOfBronzeCoffers - 1
        else
          yield("/echo This should literally be impossible. Show the developer this, mostly so he can laugh at it but also so he can fix it.")
        end            
        
        XCoordinate = DestinationList[LoopOneVariable+1]
        ZCoordinate = DestinationList[LoopOneVariable+2]

        --...then go open it
        MoveAndOpenCoffer(XCoordinate,ZCoordinate,'Coffer')

      else
        
        --otherwise, this coffer's a duplicate and we told ourselves to ignore it. onto the next one.
        if DebugVariable then
          yield("/echo Debug: This " .. CofferType .. " Coffer was a duplicate.")
        end

       --end of the if loop that determines whether or not we will open this coffer
      end

      --end of the for loop over the LoopVariableTwo, the opened coffer list (when we get here, we are done comparing. start looking at the next coffer.)
      if DebugVariable then
        yield("/echo Debug: Duplicate comparison finished for " .. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
        yield("/echo Debug: Hopefully we either reported that it was a duplicate of an existing coffer or already ran off and opened it.")
      end

      --end of the if statement for "is this the coffer type we're interested in" - don't need an else here, we just do nothing otherwise
    end

    if DebugVariable then
      yield("/echo Debug: Finished evaluating the " .. DestinationList[LoopOneVariable] .. " Coffer while looking for " .. CofferType .. " Coffer duplicates. And yes, those likely don't match.")
    end

    --end of the initial for loop that looks at every single coffer to see whether it's the right type and then, if it is, checks for duplicates
  end

  --finally, end of the open check function itself
  if DebugVariable then
    yield("/echo Debug: Finished the Open Check function. Returning to the main loop.")
  end

end  

--moves to a point. if the third parameter is set to literally anything (i.e. not null), the bot will not try to open a (hardcoded) treasure coffer when we get to the destination.
function MoveAndOpenCoffer(X, Z, ObjectType)
  
  if DebugVariable then
    yield("/echo Debug: Move And Open Coffer called. Moving to the coffer at X=" .. X .. ", Z=" .. Z)
  end
  
  --start moving
  yield("/vnavmesh moveto " .. X .. " 0 " .. Z)
  yield("/wait 2") --make sure we're moving before we start evaluating WHETHER we're moving. if that makes sense.
  
  --wait to be done moving
  while IsMoving() do
    yield("/wait 0.2") 
  end  
  
  --getting here means we're moving (combat doesn't create a movement stop early on MCH, thankfully)
  if GetCharacterCondition(26) and DebugVariable then
    yield("/echo Debug: Move And Open Coffer should have arrived at its destination and is waiting to be out of combat.")
  elseif DebugVariable then
    yield("/echo Debug: Move And Open Coffer should have arrived at its destination and is not in combat.")
  else --if no debug, no need to print any report
  end
  
  --once we're at the point, while we're in combat, target the nearest thing and start autoing it. rotationsolver will likely not care, but there's a semi-bug with it (see large comments below this while statement)
  while GetCharacterCondition(26) do
    TargetClosestEnemy()
    yield("/wait 0.1")
    yield("/pinteract")
    yield("/wait 0.9")
  end
  --this one's WILD. if you're in combat and hit the mob down to EXACTLY 1 HP, rotationsolver won't kill it because it thinks it's invuln/phase change or something.
  --normally it'd die to your next autoattacks. but! if there is also another mob, RS will switch to that one so you won't auto the one at 1 HP (you put your weapon away when you kill your active target)
  --this never comes up, except in potd where you have mobs with level 1-4 stats on floor 1, so it can come up fairly often
  --BUT, since it's attacking us, it's near us. we can target it, interact with it so we kill it with the next autoattack, and wait for the auto to go off, which should theoretically handle any number of 1 HP mobs
  --please note, this may also be solvable with rotationsolver settings? hell if I know

  if DebugVariable then
    yield("/echo Debug: Arrived at the destination and outside combat.")
  end
  
  --if the Object is a Coffer, try to open it, otherwise don't.
  if ObjectType == "Coffer" then

    if DebugVariable then
      yield("/echo Debug: Attempting to open Treasure Coffer.")
    end

    yield("/wait 2") --added this because for some reason I needed it. why on earth?
    yield('/target "Treasure Coffer"') --note: this can fail if you are between targets but still in combat (it's those damn fire sprites) but the fail state is "you just don't open that coffer" so whatever
    yield("/wait 1")
    yield("/pinteract")
    yield("/wait 1")

  else

    if DebugVariable then
      yield("/echo Debug: Arrived at a non-coffer destination. We passed in that we're at a " .. ObjectType .. ", so we're not opening it.")
    end

  end

end
  
--path to the exit and either wait to go to the next floor or give it five seconds because we're presumably waiting on monster respawns
function MoveToTheExit(ExitProgress)
  
  if DebugVariable then
    yield("/echo Debug: Moving to the exit at X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. " with " .. ExitProgress .. "% progress towards the exit opening.")
  end

  --move to the exit
  yield("/vnavmesh moveto " .. ExitLocation[1] .. " 0 " .. ExitLocation[2])
  yield("/wait 1")
  
  --wait to be done moving
  while IsMoving() do
    yield("/wait 0.2") 
  end  
  
  --if we got here, we should be done moving (combat doesn't ruin this on mch thankfully)
  if GetCharacterCondition(26) and DebugVariable then
    yield("/echo Debug: Move And Open Coffer should have arrived at its destination and is waiting to be out of combat.")
  elseif DebugVariable then
    yield("/echo Debug: Move And Open Coffer should have arrived at its destination and is not in combat.")
  else end
  
  --while in combat, wait to be out of combat
  while GetCharacterCondition(26) do
    yield("/wait 1")
  end
  
  --now try to leave, or else wait five seconds and go back into our loop
  if ExitProgress == 100 then --if the exit's open...
  
    if DebugVariable then
      yield("/echo Debug: Exit should be open. Waiting fifteen seconds to zone.")
    end
  
    yield("/wait 15") --you CAN zone up in slightly less than ten seconds, assuming you run onto the zone circle, never leave it, and aren't in combat. but I'm not confident in that. so here's some extra time!

  else
    
    if DebugVariable then
      yield("/echo Debug: At the exit, but it's not open. However, we got here because we're desperate, so let's go somewhere else at random...")
    end
    
    --the name of the function is what it does
    JustGoSomewhere()

    --end of the "is exit open or not" if statement
  end

end

--goes to a random location the saved destination list, used when there's literally nothing new to go to and the exit's still closed
function JustGoSomewhere()
  
  --pick a random coffer on the destination list
  NewDestination = math.random(0,math.floor(LengthOfDestinationList/3))

  XCoordinate = DestinationList[3*NewDestination+2]
  ZCoordinate = DestinationList[3*NewDestination+3]

  if DebugVariable then
    yield("/echo Debug: Going to a random coffer: the " .. DestinationList[3*NewDestination+1] .. " Coffer at X=" .. XCoordinate .. ", Z=" .. ZCoordinate .. ".")
  end

  --and go there
  MoveAndOpenCoffer(XCoordinate,ZCoordinate,'Previously Opened Coffer') --we don't want to open this coffer, it's already open

end

--bizarre circle kiting is the best way to survive the boss at noncapped aetherpool... and also at capped aetherpool.
function ClearBossFloor()
  
  if DebugVariable then
    yield("/echo Debug: Entered Clear Boss Floor function.")
  end
  
  --TODO: USE STRENGTH ALSO WHY NOT
  --NEED: OPEN POMANDER MENU, FIND NUMBER OF STRENGTH/STEEL, STEAL THE USAGE CODE FROM THE HOARD FARMING LUA
  --open pomander menu: if isvisible deepdungeonstatus do nothing else pcall DeepDungeonStatus 13 1
  --steel: pcall DeepDungeonStatus true 11 4
  
  --implicit assumption throughout: we're on MCH. if you're not on a job with a zero-cast-time ranged attack, this will not work for you. I recommend just being mch. kiting is STRONG against this boss. literally one raidwide.
  --player spawn location is -300, -200ish, in case you were wondering. arena's about 30 yalms radius so I used 20 as the distance from the center for the points to run to.
  PlayerPosition = 3 --1 is north, 2 is east, 3 is south, 4 is west. work with me here, it's clockwise. we spawn in to the south, so let's stay to the south at first.
  OldPlayerPosition = 3 --this will be the previous position once we start moving. since we haven't moved yet, it's the current position.
  
  --there is exactly one enemy and it's the boss, so we're fine
  TargetClosestEnemy()
  
  --how far are we from the boss? right now we actually know, but hey, no harm in recording anyway
  BossDistance = GetDistanceToTarget()
  
  --while we're not in combat, try to move onto the boss (thereby aggroing it, thereby engaging it even if we don't attack first) and then wait one second and then stop moving
  while not IsTargetInCombat() do
  
    if DebugVariable then
      yield("/echo Debug: Outside combat. Moving towards boss for one second.")
    end
    
    yield("/vnavmesh moveto "
    .. string.format("%.2f", GetTargetRawXPos()) --that's "floating point number, two decimal places"
    .. " 0 " --again, potd is flat
    .. string.format("%.2f",GetTargetRawZPos()) --we don't need to move to 313.283423 when we can just move to 313.28, although, honestly, I just stole this from someone else and never removed it
    )
    
    --only move for one second before we do it again, and honestly I don't expect to see this loop trigger more than once or twice
    yield("/wait 1")
    yield("/vnavmesh stop")

    --end of the "boss is not in combat" loop that hopeully doesn't actually need to loop
  end
  
  --once we get here, the boss is in combat, which means WE are in combat. therefore, until we're not in combat, we know RotationSolver is handling everything but movement. we will handle movement.
  while GetCharacterCondition(26) do

    --update where the boss is and where we are
    BossDistance = GetDistanceToTarget()
    BossX = GetTargetRawXPos()
    BossZ = GetTargetRawZPos()
    PlayerX = GetPlayerRawXPos()
    PlayerZ = GetPlayerRawZPos()
    
    --if the boss is less than ten yalms away, we would like to get away from it to eat fewer autoattacks / hopefully never the conal. therefore, rotate around the arena ninety degrees at a time to try to make that happen
    if BossDistance < 10 then
      if PlayerPosition == 1 --if we are currently north, move east
    then
      MoveToXCoordinate = -280
      MoveToZCoodinate = -220
      PreviousPlayerPosition = PlayerPosition
      PlayerPosition = 2
    elseif PlayerPosition == 2 --if east, move south
    then
      MoveToXCoordinate = -300
      MoveToZCoodinate = -200
      PreviousPlayerPosition = PlayerPosition
      PlayerPosition = 3
      elseif PlayerPosition == 3 --if south, move west
    then
      MoveToXCoordinate = -320
      MoveToZCoodinate = -220
      PreviousPlayerPosition = PlayerPosition
      PlayerPosition = 4
    elseif PlayerPosition == 4 --if west, move north
    then
      MoveToXCoordinate = -300
      MoveToZCoodinate = -240
      PreviousPlayerPosition = PlayerPosition
      PlayerPosition = 1
    else
      yield("/echo Boss dodging planning failed! Current variables are PlayerPosition = " .. tostring(PlayerPosition) .. " and PreviousPlayerPosition= " .. tostring(PreviousPlayerPosition))
      yield("/echo And also the player's current coordinates are X=" .. tostring(PlayerX) .. ", Z=" .. tostring(PlayerZ))
      yield("/echo And also the boss info is BossDistance=" .. tostring(BossDistance) .. ", BossX/Z=" .. tostring(BossX) .. ", " .. tostring(BossZ))
    end
    
      --now we have figured out where to move to
    if DebugVariable then
        yield("/echo Debug: Starting a move from ".. tostring(OldPlayerPosition) .. " to " .. tostring(PlayerPosition) .. ".")
      end
   
      --so move to where we want to be
    yield("/vnavmesh moveto " .. MoveToXCoordinate .. " 0 " .. MoveToZCoordinate)
  
      --Wait to do anything else until we are done moving, and check pretty frequently so we can start over relatively quickly after getting there
      while IsMoving() do 
      yield("/wait 0.1") 
    end
  
    if DebugVariable then
        yield("/echo Debug: Finished a move from ".. tostring(OldPlayerPosition) .. " to " .. tostring(PlayerPosition) .. ".")
      end

      --end of the movement loop
    end
  
  --now the boss is hopefully at least ten yalms away. wait one second, then go back to checking if we want to run away.
    yield("/wait 1")

    --end of the "we are in combat" loop
  end
  
  --if we get here, combat is over, so the boss is dead. Leave the Palace.
  yield("/wait 1")
  LeaveDuty()
  yield("/wait 2") --wait for the leaving to start

  --now while we're not in South Shroud, wait to arrive in South Shroud
  while (not IsInZone(153)) do
    yield("/wait 1")
  end
  
  if DebugVariable then
    yield("/echo Palace clearing function has finished with a boss kill. We should be in South Shroud.")
  end

end

--when we are at +30/+30 or higher, cash in aetherpool grips until we hit +29/+29 or lower. since you cash in 10 at a time and the cap for the boss floor is 20/20, you never go below cap.
function SpendAetherpool()
  
  if DebugVariable then
    yield("/echo Aetherpool check and spend function has begun.")
  end
  
  --we have just left potd. therefore, we are in quarrymill, standing at the entry npc.
  --target the entry NPC
  yield('/target "Wood Wailer Expeditionary Captain"')
  yield("/wait 1")
  
  --and talk to him
  yield("/pinteract")
  yield("/wait 1")
    
  --first, reset your save, and while we're in this menu grab total aetherpool to check whether we can spend some after the reset
  AetherpoolArm = tonumber(GetNodeText("DeepDungeonMenu", 6, 1)) --everywhere in the game it's called "aetherpool arm and armor", why the hell is this in reverse numerical order?
  AetherpoolArmor = tonumber(GetNodeText("DeepDungeonMenu", 5, 1))
  
  if DebugVariable then
    yield("/echo Debug: Aetherpool Arm is currently +" .. tostring(AetherpoolArm) .. " and Aetherpool Armor is currently +" .. tostring(AetherpoolArmor) .. ".") --making them numbers for later means I need tostring here. I can't win.
  end
  
  --look, there's NO WAY you have yesalready set to automatically reset your progress. I am not going to mess around with isvisible() here. there's just no way.
  yield("/pcall DeepDungeonMenu true 1") --select "Reset your progress"
  yield("/wait 1")
  yield("/pcall DeepDungeonSaveData true " .. (SaveSlot -1)) --select your save file
  
  --the "are you sure" prompt can be skipped via yesalready
  if IsAddonVisible(SelectYesNo) then
    yield("/pcall SelectYesNo true 0")
    yield("/wait 1")
  end
  
  if DebugVariable then
    yield("/echo Save reset complete.")
  end
  
  yield("/pcall DeepDungeonMenu true -1") --leave the Deep Dungeon menu real quick, even if we're not burning aetherpool, because I am very lazy
  
  --aetherpool cap is (allegedly) floor level + 10, we are farming up to floor 10, so if we are at 30+ we can spend in increments of 10 down to the 20-29 range.
  --TODO: CONFIRM FLOOR TEN IS CAPPED (YELLOW NUMBER) AT 20
  while (AetherpoolArm > 29) and (AetherpoolArmor > 29)  do
  
    yield("/wait 10") --if we just left the menu we should not try to simultaneously interact with another npc
    
    --talk to E-Una-Kotor
    yield('/target "E-Una-Kotor"')
    yield("/wait 10")
    yield("/pinteract")
    yield("/wait 10")
    
    --reminder, TextAdvance can skip useless dialogue
    if IsAddonVisible("Talk") then
      yield("/click talk")
      yield("/wait 10")
    end
  
    --select "Forge an aetherpool grip." which I will not fault you for not having YesAlready set up to skip because this is the same menu to open the other trades too
    if IsAddonVisible("SelectString") then
      yield("/pcall SelectString true 2")
      yield("/wait 10")
    end
  
    --reminder, TextAdvance can STILL skip useless dialogue
    if IsAddonVisible("Talk") then
      yield("/click talk")
      yield("/wait 10")
    end
  
    --"Forge an aetherpool grip? *The strength of your aetherpool arm and armor will be reduced by 10." selecting YES here is the point deduction / item gain.
    if IsAddonVisible(SelectYesNo) then
      yield("/pcall SelectYesNo true 0")
      yield("/wait 10")
    end
    
    --since we just spent 10 arm/armor points, adjust accordingly
    AetherpoolArm = AetherpoolArm - 10
    AetherpoolArmor = AetherpoolArmor - 10
    
    yield("/echo One Aetherpool Grip purchased. Many to go, probably!")

  end

  if DebugVariable then
    yield("/echo Debug: Aetherpool spending function complete. We are now at +" .. AetherpoolArm .. "/+" .. AetherpoolArmor .. " and going back into PotD.")
  end

end

--Container loop for the rest of the functions, so that the bot only has to call this function once when the script is started to loop until manually stopped
function BeBotting()
  yield('/echo Automatic Palace of the Dead aetherpool farmer has begun. Use "/snd stop" to stop.')
  
  --travel to PotD entrance
  InitialStartup()
    
  --currently an infinite loop. possible future improvement: user-configurable constant "number of aetherpool grips to stop at" that will then break the loop and unload the function.
  while 1 do
    --Enter PotD
    EnterPalace() 
      
    --Clear PotD
    ClearPalace()
      
    --aetherpool check, cash out, and repeat
    SpendAetherpool()
  end

  --the above loop is endless. we should never see this.
  yield("/echo We escaped the endless main loop? This should never have happened. Please tell the developer how you got here!")
  yield("/snd stop")

end

--The purpose of the function immediately above this is to make it so that this script, when run, just executes this single line. consider it an elegant reminder of what you should be doing to get this and many other achievements:
BeBotting()
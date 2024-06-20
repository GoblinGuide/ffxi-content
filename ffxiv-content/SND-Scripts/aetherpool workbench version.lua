--TODO:
--add a jiggle function to open the coffer that moves you a small distance away, then back again, to ensure you're 1: facing it 2: not on top of it cause i'm getting sick of not being able to open
--add movement to the wood wailer npc (copy paste is fine) in the spend aetherpool function in case of death
--POMANDERS FOR BOSS (get the "is node visible" for strength and steel)
--POMANDERS FOR EVERY OTHER FLOOR ("is node visible" for pomander of affluence)
--ACTUALLY WATCH THIS THING RUN TO CONFIRM IT WORKS OBVIOUSLY:
  --AETHERPOOL TRADEIN
  --RESETTING SAVE
  --MOVEMENT TIMEOUT
  --accepting death

--Instance, repair, and move loop code stolen from flug, who in turn borrowed some of it from earlier existing SND community scripts
--everything else by Unfortunate. never used a "license" in my life. feel free to steal all of it and modify however you want and leave my name off it altogether. we're all friends here. is this "copyleft"? idk.

--Required Starting Condition:
--Whichever PotD save slot you want to use (configured on line 31 below) is empty.

--Required Plugins:
--VNAVMESH is used for all navigation - MANDATORY
--TELEPORTER is used to teleport to Quarrymill from anywhere.
  --not needed if you always start this bot from Quarrymill.
--ROTATION SOLVER (whether reborn: https://github.com/FFXIV-CombatReborn/RotationSolverReborn or the old one) is used to automate combat inside PotD - MANDATORY
  --1) Make sure it's not configured to urn off upon zone change, duty end, or death.
  --2) Make sure that Target -> Configuration is set to "All targets when solo, or previously engaged." in the first dropdown. That way you will kill things that haven't aggroed you yet.

--yeah, that's right, we're using math dot random to look marginally less like a bot (...marginally.)
math.randomseed(math.floor(os.clock()*1000000)) --wow, math.randomseed only takes integers? oh well, we ever invented the floor function

--Set this variable to 'true' to spam your log with debug messages. You likely do not need this, unless either 1) someone specifically asked you to or 2) you're trying to modify this script yourself.
DebugVariable = true

--Set this variable to 1 to use the first save slot. Set it to 2 to use the second save slot. THIS IS DIFFERENT FROM WHAT THE EXISTING HEAVEN-ON-HIGH ACCURSED HOARD FARMER SND SCRIPT DOES. BE CAREFUL!
SaveSlot = 2

--if you would like the bot to stop on its own when you have a certain number of aetherpool grips, put that number here. it takes 3 per weapon and there are 20 weapons as of dawntrail, so by default this.
GripCountToStop = 60

--number of seconds to keep trying to move to a destination before giving up, for when vnavmesh breaks
GlobalMovementTimeout = 60

--just in case anyone is actually reading this: all of PotD is flat. The y-coordinate for every point is functionally 0. So I hardcoded "0" into every movement's Y and called it a day. That's why coordinates are (X, Z).
--Make sure we're on MCH... or at least warn if we're not. then get to the entry NPC.
function InitialStartup()

  if DebugVariable then
    yield("/echo Initial startup function has begun.")
  end
  
  AetherpoolGripCount = GetItemCount(23165)

  if DebugVariable then
    yield("/echo Running until we reach " .. GripCountToStop .. " Aetherpool Grips. We currently have " .. AetherpoolGripCount .. ".")
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
    yield("/echo Debug: Clear Palace of the Dead function has begun.")
  end
  
  --while the player is both (not unconscious [i.e. alive]) and (in deep dungeon [i.e. in PotD]), clear the dungeon
  while ((not GetCharacterCondition(2)) and GetCharacterCondition(79)) do
    
    --the first nine floors are functionally identical, so we will clear them identically.
    for LoopCount = 1, 9 do
    
      if DebugVariable then
        yield("/echo Debug: Clear Palace loop beginning for floor " .. LoopCount .. ".")
      end
      
      --our starting location is a place we can definitely move to - although currently I don't ever want to - so record it just in case
      InitialSpawnLocation = {tostring(GetPlayerRawXPos()), tostring(GetPlayerRawZPos())}
    
      if DebugVariable then
        yield("/echo Debug: Saved initial player spawn coordinates of X=" .. InitialSpawnLocation[1] .. ", Z=" .. InitialSpawnLocation[2] .. ".")
      end
      
      --clear the list of relevant points from last floor. the future is the wave of the future, so it's time to say "so long" to the things of the past!
      InitializeVariables()
    
      --clear the floor, ending with a wait that overkills the time needed to load the next floor so that initial spawn location is properly loaded by the time the next loop starts
      ClearSingleFloor(LoopCount) --this variable is literally passed in just to debug echo it out at the start of the function, even though we just echoed it out above. yes, I am insane.

      --end of loop, meaning end of floor.
    end
    
    --when we are out of that loop, we have cleared nine floors, thus we are on floor ten.
    if DebugVariable then
      yield("/echo Debug: Clear Palace loop has arrived at floor 10. Clearing the boss.")
    end
    
    --this function includes leaving potd after the boss is dead...
    ClearBossFloor()
    
    --...therefore, hopefully we never see this message
    yield("/echo Debug: Clear Palace loop has cleared the boss, and should have left PotD, but did not. SOMETHING IS WRONG HERE!")
    yield("/echo Leaving PotD to hopefully restart the loops properly.")
    LeaveDuty()
    yield("/wait 10")

    --end of the "not dead and in PotD" loop
  end

end

--resets all the variables from the previous floor to their default values - clears all destinations, cairn locations, and so on
function InitializeVariables()
  
  if DebugVariable then
    yield("/echo Debug: Entered a new floor. Initializing variables.")
  end
  
  --note that initialspawnlocation is NOT cleared here. we just set it before we called this function.
  ExitLocation = {'0', '0'} --x coordinate and z coordinate. if the exit isn't in range when we look, it returns 0,0, so save some time and start with that populated (also y=0 but as usual we do not care)
  CairnOfReturnLocation = {'0', '0'} --this is literally unusable in solo play, but it does give us a waypoint to use for navigation in cases without any chests left
  DestinationList = {} --this list will contain all coffers found on the current floor
  OpenedCofferList = {} --this list will contain every coffer that the bot has already navigated to
  LengthOfDestinationList = 0 --lua requires you to iterate all of a table to find its length, so instead we'll update that manually to make adding new destinations to our destination list easier
  LengthOfOpenedCofferList = 0 --same reason as length of destination list
  NumberOfBronzeCoffers = 0 --used to track the contents of the destination list
  NumberOfSilverCoffers = 0 --and reset every floor
  NumberOfGoldCoffers = 0 --see above two comments
  SkipThisCoffer = false --this will be reset for every coffer we find, but let's be sure. also, I don't know how global and local variables work lmao
  CurrentDestination = {'0', '0', 'None'} --the next place we will be moving to (with some additional information about what we're doing when we get there in the third parameter)
  WeHaveADestination = false --this will be reset every time the movemeent loop is called, but again, better sure than sorry, and again, someday I'll learn what a global variable is

  if DebugVariable then
    yield("/echo Debug: Variables initialized.")
  end
  
end

--finds the Cairn of Passage. if we have found it already, does nothing.
function LookForTheExit()
  
  if DebugVariable then
    yield("/echo Debug: Entered Look For The Cairn of Passage loop.")
  end
  
  --only look for the exit if we haven't already found it
  if (ExitLocation[1] == '0' and ExitLocation[2] == '0') then
  
    if DebugVariable then
      yield("/echo Debug: We don't already know where the Cairn of Passage is.")
    end
  
    PossibleExit = tostring(GetPassageLocation()) --this always returns something. if it fails, it's 0 0 0, if it finds it, it's z y z. but never nothing.
    XIndex, garbage = string.find(PossibleExit,",") --the first comma is right after the x coordinate. also, string.find really sucks and returns two variables even if you're finding a single character so they're equal.
    ZIndex, garbage = string.find(PossibleExit,",",XIndex+1) --the z coordinate is located immediately after the second comma, which means we want to start after the second comma, aka "the first comma AFTER the first comma".
    ColonIndex, garbage = string.find(PossibleExit,"):") --the coordinates terminate in "):" which is also the face I make when I see this whole block of code.
    XCoordinate = string.sub(PossibleExit,2,XIndex-1) --start after the fixed starting character, "(", and go until the character before the first comma to get the X coordinate.
    ZCoordinate = string.sub(PossibleExit,ZIndex+2,ColonIndex-1) --start after the second ", " and go until the "):" to get the z coordinate.

  else --if we already know where the exit is, don't look for it again and just set the coordinate variables equal to it (since we reuse these variable names elsewhere and I still don't know how local variables work)
 
    if DebugVariable then
      yield("/echo Debug: We already know where the Cairn of Passage is. It's at X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. ".")
    end
      
    XCoordinate = ExitLocation[1]
    ZCoordinate = ExitLocation[2]

    --end of the "do we already know where the exit is?" if statement
  end
  
  --safe assumption: the exit will never be at exactly (0, 0). so many decimal places, we'll be fine, worst case one coordinate is something insane like 2E-7. (actually witnessed as a y-coordinate...)
  if not (XCoordinate == '0' and ZCoordinate == '0') then
    ExitLocation[1] = XCoordinate --kind of funny to be doing this given the else-statement above, but it's not a big deal.
    ExitLocation[2] = ZCoordinate
  
    if DebugVariable then
      yield("/echo Debug: Found the Cairn of Passage at X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. ".")
    end
  
  else
  
    if DebugVariable then
      yield("/echo Debug: We did not find the Cairn of Passage this attempt. Must be somewhere else.")
    end

    --end of the "did we find the exit" if statement
  end

  if DebugVariable then
    yield("/echo Debug: Look For The Cairn of Passage loop complete.")
  end

end
  
--find and store the coordinates for the Cairn of Return, which we can literally never use but is a waypoint that exists and we can navigate to
function LookForCairnOfReturn()
  
  if DebugVariable then
    yield("/echo Debug: Entered Look For Cairn of Return loop.")
  end

  --only look for the cairn if we haven't already found it
  if (CairnOfReturnLocation[1] == '0' and CairnOfReturnLocation[2] == '0') then

    if DebugVariable then
      yield("/echo Debug: We do not know where the Cairn of Return is. Looking for it now.")
    end

    XCoordinate = GetObjectRawXPos("Cairn of Return") --these also return 0 if they fail
    ZCoordinate = GetObjectRawZPos("Cairn of Return") --so we will have a 0 value if we have not found it yet *and* did not find it this time, which is perfect
  
  else --if we already know where the cairn is, don't look for it again and just set the coordinate variables equal to it (since we reuse these variable names elsewhere and I still don't know how local variables work)

    if DebugVariable then
      yield("/echo Debug: We already know where the Cairn of Return is.")
    end

    XCoordinate = CairnOfReturnLocation[1]
    ZCoordinate = CairnOfReturnLocation[2]
  
  end

  --same assumption as other cairn, it's not spawning at precisely (0,0) ever, hopefully. therefore, if we found it, save its coordinates
  if not (XCoordinate == '0' and ZCoordinate == '0') then
    CairnOfReturnLocation[1] = XCoordinate
    CairnOfReturnLocation[2] = ZCoordinate
   
    if DebugVariable then
      yield("/echo Debug: Found the Cairn of Return at X=" .. CairnOfReturnLocation[1] .. ", Z=" .. CairnOfReturnLocation[2])
    end

  else --and if we didn't find it, do nothing

    if DebugVariable then
      yield("/echo Debug: We did not find the Cairn of Return this attempt. Must be somewhere else.")
    end
    
    --end of the "did we find the Cairn" check
  end

  if DebugVariable then
    yield("/echo Debug: Look For Cairn of Return loop complete.")
  end

end

--clearing loop for floors 1-9: until the exit's open, repeatedly look for every point of interest, then go to the most interesting one (silver > gold > bronze > cairn of return > nonworking exit) and open it if it's a coffer
function ClearSingleFloor(FloorNumber)
  
  if DebugVariable then
    yield("/echo Debug: Clear Single Floor has been called for floor number " .. FloorNumber .. ".")
  end
  
  --PomanderOfAffluence(FloorNumber) --todo: uncomment this when I have the code to pull my number of pomanders

  --while the exit isn't open AND WE'RE ALIVE (so that this will break properly on death)
  while (GetDDPassageProgress() < 100) and (not GetCharacterCondition(2)) do

    --check whether the exit is open
    ExitProgress = GetDDPassageProgress()

    --scan the floor for all points of interest including the exit
    SavePointsToTable()

    --decide where to go
    SelectDestination()

    if DebugVariable then
      yield("/echo Debug: Clear Single Floor: New destination found: X=" .. CurrentDestination[1] .. ", Z=" .. CurrentDestination[2] .. ", Object=" .. CurrentDestination[3] .. ".")
    end

    --and then go there
    SafeMovementLoop()

    --don't need a wait here because the movement loop ends with a wait

  end
  
  --if we got here, either the exit is open or we're dead. so if we're not dead, go to the exit
  if (not GetCharacterCondition(2)) then
    MoveToTheExit()
  else
    yield("/echo We died! Leaving PotD and (hopefully) starting over.")
    LeaveDuty()
  end
  
end

--save all our points to the table of destinations. includes a duplicate check so we don't duplicate unnecessarily
function SavePointsToTable()

  --note that this function is not called once the exit is open, so this debug message is accurate
  if DebugVariable then
    yield("/echo Debug: Clear Single Floor: The exit is not yet open. Looking for objects, then selecting the next destination. Current exit progress is ".. ExitProgress .. "%.")
  end
  
  --destinations we care about finding: silver coffers, cairn of passage (aka "exit"), gold coffers, bronze coffers, cairn of return. these are in priority order of how much we care about them, but they don't need to be!
  LookForCoffers('Silver')
  LookForTheExit()
  LookForCoffers('Gold')
  LookForCoffers('Bronze')
  LookForCairnOfReturn()

  if DebugVariable then
    yield("/echo Debug: Clear Single Floor: Destination choice function complete.")
  end

  --now we should have a fully updated locations list. note that we want to call this every time we go anywhere, in case the floor is big enough that we don't have everything in range from the first search when we enter
end

--select the appropriate destination from our list. priority order: unopened silver > unopened gold > unopened bronze > cairn of return > closed exit (open exit means we don't call this function again, so we ignore it)
function SelectDestination()

  WeHaveADestination = false --if this is set to "true" by an instance of OpenedCheck later in the function, that means we have a destination and don't need to keep looking.

  if DebugVariable then
    yield("/echo Debug: Clear Single Floor: Selecting the next destination to move to.")
  end
  
  --case one: we have a silver coffer left to open. that's what we're here for! go do it. there's no WeHaveADestination check here because this is priority one so we cannot have a destination yet.
  if NumberOfSilverCoffers > 0 then
    OpenedCheck('Silver')
  end
  
  if DebugVariable and not WeHaveADestination then
    yield("/echo Debug: No unopened silver coffers remaining. Checking gold coffers next.")
  end
   
   --case two: no silvers. go to a gold coffer.
  if NumberOfGoldCoffers > 0 and not WeHaveADestination then
    OpenedCheck('Gold')
  end

  if DebugVariable and not WeHaveADestination then
    yield("/echo Debug: No unopened gold coffers remaining. Checking bronze coffers next.")
  end

   --case three: no silvers, no golds. go to a bronze coffer
  if NumberOfBronzeCoffers > 0 and not WeHaveADestination then
    OpenedCheck('Bronze')
  end

  if DebugVariable and not WeHaveADestination then
    yield("/echo Debug: No unopened bronze coffers remaining. Checking Cairns next.")
  end

   --case four: no coffers. go to the cairn of return if we know where it is and we are more than 30 yalms (about half a room) away from it
  if (CairnOfReturnLocation[1] ~= '0') and (CairnOfReturnLocation[2] ~= '0') and not WeHaveADestination --if we know where it is
    then
      
      if (GetDistanceToPoint(CairnOfReturnLocation[1], 0, CairnOfReturnLocation[2]) > 30) then --AND we are far away from it
          
        if DebugVariable then
          yield("/echo Debug: Traveling to the Cairn of Return.")
        end

        WeHaveADestination = true
        XCoordinate = tostring(CairnOfReturnLocation[1])
        ZCoordinate = tostring(CairnOfReturnLocation[2])
        CurrentDestination = {XCoordinate, ZCoordinate, 'Cairn'}

      else --otherwise, if we're too close to it, don't bother
    
        if DebugVariable then
          yield("/echo Debug: We know where the Cairn of Return is, but we're only " ..GetDistanceToPoint(CairnOfReturnLocation[1], 0, CairnOfReturnLocation[2]) .. " yalms from it. Not going there.")
        end
        
       --end of if statement checking for Cairn distance from player
    end
   
  else --otherwise, we do not know where the Cairn is, so don't do anything
  
    if DebugVariable and not WeHaveADestination then --only report this out if it's relevant, i.e. we aren't already going somewhere else from earlier in this function
      yield("/echo Debug: We don't know where the Cairn of Return is.")
    end
  
    --end of if statement checking whether we know where the Cairn is
  end
    
  --case five: the final catchall. no coffers left, standing near the cairn of return, exit's still closed. pick a random coffer and hope for mob respawns (every 40 seconds, so in a few iterations of this at worst)
  if not WeHaveADestination then 
    
    if DebugVariable then
      yield("/echo Debug: Reached the end of the Select Destination function without finding any unopened coffers or a distant Cairn of Return. Going to a random coffer's location.")
    end
  
    --make doubly sure that we don't think we have anywhere planned before we try to go to a random place
    WeHaveADestination = false
    XCoordinate = '0'
    ZCoordinate = '0'
    CurrentDestination = {'0','0','None'}

    --and then pick one at random to be our next destination
    JustGoSomewhere()
  
  else --if we already have a destination, we're fine
  
    if DebugVariable then
      yield("/echo Debug: Reached the end of the Select Destination function, but already successfully selected a destination. We're fine.")
    end
    
    --end of the final if statement
  end
 
  --now we either have a current destination saved or we know for a fact we don't have a destination. therefore, when we end this function and call "move to the next destination", we will know what to do.
  if DebugVariable then
    yield("/echo Debug: Select Destination Complete.")
  end

end

--looks for all instances of a specific type of coffer within loaded object range (which is NOT the entire floor, only about three rooms (100 yalms), but that's almost whole floor in lower potd)
function LookForCoffers(CofferType)

  if DebugVariable then
    yield("/echo Debug: Look For Coffers: Looking for " .. CofferType .. " Coffers within object range.")
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
      yield("/echo Debug: Function found " .. Chests.Count .. " " .. CofferType .. " Coffers within range.")
    end
    
    --first loop: extract individual coffer information from the list of coffers we just found
    for LoopOneVariable = 1, Chests.Count do
    
      if DebugVariable then
        yield("/echo Debug: Examining coffer number " .. LoopOneVariable .. ".")
      end
  
      Coffer = tostring(Chests[LoopOneVariable-1]) --croizat indexes from 0, so the i'th loop is the i'th coffer which has index i-1. sorry, I don't make the rules.
  
      if DebugVariable then
        yield("/echo Debug: Raw function output is: " .. Coffer)
      end
    
      XIndex, garbage = string.find(Coffer,",") --the first comma is right after the x coordinate. ("garbage" is the end location of the "," string, which we do not care about because we know the length of that string)
      ZIndex, garbage = string.find(Coffer,",",XIndex+1) --the z coordinate is located immediately after the second comma, which means we want to start after the second comma, aka the first comma AFTER the first comma
      ColonIndex, garbage = string.find(Coffer,"):") --the coordinates end with "):" every time, so find where the sad face is and we know where the coordinates end
      XCoordinate = string.sub(Coffer,2,XIndex-1) --start after the fixed "(" at the start of every output and go until the first comma to get the full X coordinate
      ZCoordinate = string.sub(Coffer,ZIndex+2,ColonIndex-1) --start after the fixed second ", " and go until the fixed "):" to get the full Z coordinate. coincidentally, the latter is the also face I make when I see this code.
      SkipThisCoffer = false --begin by assuming that every coffer is new
  
      if DebugVariable then
        yield("/echo Debug: Checking for a duplicate entry for the coffer at X=" .. XCoordinate .. ", Z=" .. ZCoordinate)
      end

      --second loop inside first loop: make sure this coffer is new, i.e. does not already exist on the list
      for LoopTwoVariable = 0, (LengthOfDestinationList-2), 3 do --coffers are a triple, see comments in move to the next destination if you want the most information I ever wrote (probably still not full information)
  
        if DebugVariable then
          yield("/echo Debug: Duplicate check beginning. We are on loop iteration number " .. math.floor((LoopTwoVariable+3)/3) .. " out of " .. math.floor((LengthOfDestinationList/3)) .. ".") --floor not needed, but I hate "1.0"
        end
  
        --check whether we have already stored this coffer, by checking whether we've found a coffer within one yalm of it. close enough to true dupe check
        if (LengthOfDestinationList > 0) --if we have something that it can be a duplicate of (technically unnecessary given the below condition, but it's very intuitive to have it here)
        and (math.abs(tonumber(DestinationList[LoopTwoVariable+2]) - XCoordinate) < 1) and (math.abs(tonumber(DestinationList[LoopTwoVariable+3]) - ZCoordinate) < 1) --if coffer coordinates are within 1 yalm of a preexisting coffer
        then
   
          SkipThisCoffer = true
  
          if DebugVariable then
            yield("/echo Debug: Found a duplicate of that coffer. Moving on.")
          end
      
        else --otherwise, this entry on our destination list is not a duplicate, so do nothing (except debug message) and continue on to the next entry on our list
      
          if DebugVariable then
            yield("/echo Debug: Entry number " .. math.floor((LoopTwoVariable+3)/3) .. " on the existing coffer list was not a duplicate. Continuing duplicate check.")
          end

        end
    
        if DebugVariable then
          yield("/echo Debug: Single iteration of the duplicate coffer check for this coffer complete.")
        end

        --end of the second loop comparing one existing destination to the possibly new coffer
      end
  
      if DebugVariable then
        yield("/echo Debug: All iterations of the duplicate coffer check for this coffer complete.")
      end 
  
      --if we finished that entire loop and didn't find a duplicate in our list, it's a new coffer! add it to the list of coffers.
      if SkipThisCoffer == false then
        DestinationList[LengthOfDestinationList+1] = CofferType --we store a coffer as a three-dimensional vector: type of coffer, 
        DestinationList[LengthOfDestinationList+2] = XCoordinate --X coordinate, (NOTE: THESE VARIABLES ARE STRINGS. NOT INTS. THEY ARE NUMBERS, BUT THEY ARE STRINGS. CHECK ALL EQUALITY ACCORDINGLY.)
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

      else --if we found a duplicate, we don't care, do nothing
        --end of large if statement to add a coffer identified as non-duplicate to the end of the list of destinations
      end
     
      --end of loop over LoopVariableOne to extract individual coffer information and duplicate check each one
    end
 
  else --i.e. "if we didn't find any coffers of this type"
    
    if DebugVariable then
      yield("/echo Debug: No " .. CofferType .. " Coffers found. Moving on to the next search.")
    end

    --end of the "how many coffers of this type do we have" if statement
  end

end  

--evaluates whether a coffer in our destination list is one that we have already opened, and ultimately sets our next destination equal to the first unopened coffer of that type, if there is one
function OpenedCheck(CofferType)

  if DebugVariable then
    yield("/echo Debug: Opened Check has begun. Checking the destination list for " .. CofferType .. " Coffers that have not already been visited.")
  end

  --every third item in the destination list is "type of coffer", and the two items after that are that coffer's coordinates. last item on the list occupies the three final slots, aka n-2, n-1, and n=lengthofdestinationlist
  --therefore, loop by threes and look in threes (starting with slots 1 2 3, ending with slots n-2 n-1 n where n equals lengthofdestinationlist)
  for LoopOneVariable = 1, (LengthOfDestinationList-2), 3 do
     
    if DebugVariable then
      yield("/echo Debug: Duplicate check currently examining coffer number " .. math.floor((LoopOneVariable+2)/3) .. ".") --first one is (1+2)/3 = 1, second one is (4+2)/3 = 2, ... (n-2 + 2)/3 = n/3)
    end

    --if the coffer is the type we passed in - AND we haven't already decided on a place to go - then do a bunch of stuff:
    if (DestinationList[LoopOneVariable] == CofferType) and (WeHaveADestination == false) then
        
      --start by planning to open it unless we find a duplicate
      OpenThisCoffer = 1
      
      --...oops. only check against previously opened coffers if we HAVE any previously opened coffers.
      if LengthOfOpenedCofferList > 0 then

        --confirm that we haven't already opened this coffer by looking at every coffer that we have already opened (really "already visited", we don't record whether opening fails)
        --since this list is stored in the same way, we can use the same format of loop to loop over the entire opened list
        for LoopTwoVariable = 1, (LengthOfOpenedCofferList-2), 3 do
          
          if OpenedCofferList[LoopTwoVariable] == CofferType --if this already-opened coffer is all three of "the same type"...
          and math.abs(OpenedCofferList[LoopTwoVariable+1] - DestinationList[LoopOneVariable+1]) < 1 --...and "within 1 yalm in X distance of the coffer we're looking at"... (fuck decimal places!)
          and math.abs(OpenedCofferList[LoopTwoVariable+2] - DestinationList[LoopOneVariable+2]) < 1 --...and "within 1 yalm in Z distance of the coffer we're looking at"...
          then
            
            --...then it's the same coffer. not interested in opening that, since we already did.
            OpenThisCoffer = 0
            
            if DebugVariable then
              yield("/echo Debug: Duplicate ".. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. " is being ignored.")
              yield("/echo Debug: The match found was a " .. CofferType .. " Coffer at " .. OpenedCofferList[LoopTwoVariable+1] .. ", " ..  OpenedCofferList[LoopTwoVariable+2] .. ".")
            end
  
          else --otherwise this coffer isn't a duplicate of that coffer
            
            if DebugVariable then
              yield("/echo Debug: Non-match number " .. math.floor((LoopTwoVariable+2)/3).. " found for the " .. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
            end
  
            --end of the if statement that determines whether the new coffer is a duplicate of a specific already opened coffer
          end
  
          if DebugVariable then
            yield("/echo Debug: Single duplicate comparison finished for the " .. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
          end
  
           --end of the for loop over LoopVariableTwo (the opened coffer list) that determines whether the new coffer is a duplicate of ANY already opened coffer
        end
      
        --if we have an opened coffer list of length 0, we have no opened coffers, so it cannot possibly be a dpulicate
      else

        if DebugVariable then
          yield("/echo Debug: The " .. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. " is the first coffer examined. Therefore, it's not a duplicate.")
        end

        --end of the "do we have any opened coffers" if statement that contains the duplicate check
      end

       --once we get here, we're out of the duplicate check and have a conclusive result for that coffer.
      if DebugVariable then
        yield("/echo Debug: Duplicate check loop complete for the " .. DestinationList[LoopOneVariable] .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
      end

      --if we haven't proven that this coffer is a duplicate yet, it must be new. add it to the destinations list.
      if (OpenThisCoffer == 1) then
        OpenedCofferList[LengthOfOpenedCofferList+1] = CofferType
        OpenedCofferList[LengthOfOpenedCofferList+2] = DestinationList[LoopOneVariable+1]
        OpenedCofferList[LengthOfOpenedCofferList+3] = DestinationList[LoopOneVariable+2]
        LengthOfOpenedCofferList = LengthOfOpenedCofferList + 3
          
        if DebugVariable then
          yield("/echo Debug: New " .. CofferType .. " Coffer found at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ". Set it as the next destination.")
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
        
        --now populate the variables that tell us whether we have a new destination and where it is
        WeHaveADestination = true --now that we have set this to true, we will no longer examine future coffers in this loop, nor future types of coffer further down in the destination-finding function
        XCoordinate = DestinationList[LoopOneVariable+1]
        ZCoordinate = DestinationList[LoopOneVariable+2]
        CurrentDestination = {XCoordinate, ZCoordinate, CofferType}

       else
        
        --otherwise, this coffer's a duplicate, so we will ignore it. move on to check the next coffer.
        if DebugVariable then
          yield("/echo Debug: This " .. CofferType .. " Coffer was a duplicate.")
        end

        --end of the if loop that determines whether or not we will open this coffer
      end

      --end of the for loop over the LoopVariableTwo, the opened coffer list (when we get here, we are done comparing. start looking at the next coffer.)
      if DebugVariable then
        yield("/echo Debug: Duplicate comparison finished for " .. CofferType .. " Coffer at " .. DestinationList[LoopOneVariable+1] .. ", " .. DestinationList[LoopOneVariable+2] .. ".")
      end

    else --if the coffer's a different type, do nothing
        
      --end of the if statement that examines coffer type
    end
     
    if DebugVariable then
      yield("/echo Debug: Finished evaluating a " .. DestinationList[LoopOneVariable] .. " Coffer while looking for " .. CofferType .. " Coffer duplicates.") --this will output LOTS, including nonmatching, because it's all coffers
    end

    --end of the initial for loop that looks at every single coffer to see whether it's the right type and then, if it is, checks for duplicates
  end
  
  --finally, end of the open check function itself
  if DebugVariable then
    yield("/echo Opened Check function complete for " .. CofferType .. " Coffers.")
  end
  
end 

--move to the exit and then stand there until we leave
function MoveToTheExit()

  if DebugVariable then
    yield("/echo Debug: Moving to the exit at X=" .. ExitLocation[1] .. ", Z=" .. ExitLocation[2] .. " with " .. tostring(GetDDPassageProgress()) .. "% progress towards the exit opening.")
  end

  --move to the exit
  yield("/vnavmesh moveto " .. ExitLocation[1] .. " 0 " .. ExitLocation[2])
  yield("/wait 2") --wait to start moving
  
  --wait to stop moving now that we've started
  while IsMoving() do
    yield("/wait 0.5")
  end  
  
  --if we got here, we should be done moving (combat doesn't ruin this on mch thankfully)
  if GetCharacterCondition(26) and DebugVariable then
    yield("/echo Debug: Arrived at the exit. Waiting to be out of combat.")
  elseif DebugVariable then
      yield("/echo Debug: Arrived at the exit and not in combat.")
  else
    --if no debug, no debug message
  end
  
  --while in combat, wait to be out of combat
  while GetCharacterCondition(26) do
    yield("/wait 1")
  end
  
  if DebugVariable then
    yield("/echo Debug: Exit should be open. Waiting to zone.")
  end

  yield("/wait 15") --this can take less than ten seconds, if you start this wait when you're already on the pad, but I hate it.

  --just in case we have not yet changed zones, wait a little more...
  while ((math.abs(GetPlayerRawXPos() - tonumber(ExitLocation[1])) < 1) and (math.abs(GetPlayerRawXPos() - tonumber(ExitLocation[2])) < 1)) do
    yield("/wait 1") --if we haven't moved away from where we were when we ran to the exit, wait one second until we are. I don't know a more elegant way to do this.
  end

end
  
--sets the next destination to a random coffer on the saved destinations list. used when there's no unopened coffers left and the exit's still closed, to try to find more monsters
function JustGoSomewhere()
  
  if DebugVariable then
    yield("/echo Debug: Just Go Somewhere has begun.")
  end

  --pick a random coffer on the existing destination list
  NewDestination = math.random(0, math.floor(LengthOfDestinationList/3)-1)

  if DebugVariable then
    yield("/echo Debug: Just Go Somewhere has picked the random number " .. NewDestination .. ", meaning the destination stored in index " ..
    ((3*NewDestination) + 1) .. ", " .. ((3*NewDestination) + 2) .. ", and" .. ((3*NewDestination) + 3) .. " on the list.")
  end

  --set our current destination equal to it
  CurrentDestination[1] = DestinationList[3*NewDestination+1]
  CurrentDestination[2] = DestinationList[3*NewDestination+2]
  CurrentDestination[3] = 'Previously Opened Coffer'

  if DebugVariable then
    yield("/echo Debug: Going to a random coffer: the " .. DestinationList[3*NewDestination+1] .. " Coffer at X=" .. XCoordinate .. ", Z=" .. ZCoordinate .. ".")
  end

end

--TODO: THIS IS UNTESTED
--bizarre circle kiting is the best way to survive the boss
--TODO: I THINK THIS NEEDS TO GO FURTHER OUT THAN 20 FROM THE CENTER. IT WORKS TO DODGE THE CHARGED ATTACK, BUT NOT THE AUTOS AS MUCH
--todo 2: running in a circle is a solved problem. generalize the locations and just do an arc idiot
function ClearBossFloor()

  if DebugVariable then
    yield("/echo Debug: Entered Clear Boss Floor function.")
  end
  
  --TODO: USE STRENGTH ALSO WHY NOT
  --open pomander menu: if isvisible deepdungeonstatus do nothing else pcall DeepDungeonStatus 13 1 see the affluence function
  --use a steel: pcall DeepDungeonStatus true 11 4
  --use a strength: pcall DeepDungeonStatus true 11 3



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
  
  --once we get here, the boss is in combat, which means WE are in combat. therefore, until we're either dead or out of combat, we know that RotationSolver is handling everything but movement. we will handle movement.
  while (GetCharacterCondition(26) and not GetCharacterCondition(2)) do

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
     
     --wait until we are done moving, and check pretty frequently so we can start over relatively quickly after getting there
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
  
  --if we get here, either we died (so we're done) or combat is over (so the boss died, so we're done)

  if DebugVariable then
    yield("/echo Either the boss died or we did. Either way, this run is over. Leaving the Palace.")
  end

  yield("/wait 1")
  LeaveDuty()
  yield("/wait 2") --wait for the leaving to start

  --now while we're not in South Shroud, wait to arrive in South Shroud
  while (not IsInZone(153)) do
    yield("/wait 1")
  end
  
  if DebugVariable then
    yield("/echo Reentered South Shroud. Palace function is finished. Moving on to check aetherpool levels and restart.")
  end

end
  
--TODO: THIS IS UNTESTED
--TODO: CAP IS LOWER, 16/24 IS CAPPED ON FLOOR 11, 18 is uncapped on 19 but 24 is capped, AND YOU WANT TO GO MAXIMALLY LOW BECAUSE YOU WANT TO GET MORE PLUSES FROM THE SILVERS WHICH IS THE GOAL
--when we are at +30/+30 or higher, cash in aetherpool grips until we hit +29/+29 or lower. since you cash in 10 at a time and the cap for the boss floor is 20/20, you never go below cap.
--35 is uncapped on 32, 50 is capped (36 uncap on 33)
--56 is capped on 51, failed an armor plus at 67
--59 uncapped on 56?! 67 uncapped on 63 it looks like Floor +5 is the formula (so 15 is the max cap for floor 10 good to know)
--failed an uncapped +66 increasing on 68
function SpendAetherpool()
  
  if DebugVariable then
    yield("/echo Aetherpool check and spend function has begun.")
  end
  
  --we have just left potd. therefore, we are in quarrymill, standing at the entry npc... unless we died, in which case we are NEAR the entry NPC TODO: ADD MOVEMENT HERE
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

--Moves to a single destination. Takes its destination directly from the global values stored in the Current Destination variable. Name comes from having a timeout, because, frankly, vnavmesh shits the bed.
function SafeMovementLoop()
  
  --had trouble passing these in so just using globals
  XCoordinate = CurrentDestination[1]
  ZCoordinate = CurrentDestination[2]
  ObjectType = CurrentDestination[3] --this will be used in an if statement below

  --if we have a destination, move to it
  if not (XCoordinate == '0' and ZCoordinate == '0') then

    MovementTimeStarted = os.time() --track the time before we started moving (this returns an integer = number of seconds since I have no idea - unix epoch perhaps? - but it's an integer number of seconds is all that matters)
    MovementEndTime = MovementTimeStarted + GlobalMovementTimeout --end time is start time plus maximum time we want to spend moving

    if DebugVariable then
      yield("/echo Debug: Moving to our next destination, the " .. ObjectType .. " at X=" .. XCoordinate .. ", Z=" .. ZCoordinate .. ".")
      yield("/echo Debug: Current timestamp is: " .. MovementTimeStarted .. ".")
    end

    --begin moving to the saved destination
    yield("/vnavmesh moveto " .. XCoordinate .. " 0 " .. ZCoordinate)
    yield("/wait 2") --wait to start moving before checking if we're moving. I have had this break at 1 exactly once ever so now I'm superstitious about 2. length doesn't matter as long as it's shorter than global movement timeout.

    --wait until we are done moving OR we hit the global timeout variable length of time (minus the two second wait above)
    --POSSIBLE IMPROVEMENT: WOULD PATHISRUNNING() BE BETTER THAN ISMOVING()?
    while (os.time() <= (MovementEndTime)) and (IsMoving()) do
      yield("/wait 1")
    end
  
    --TODO: IF WE HIT THE GLOBAL TIMEOUT, DIFFERENT BEHAVIOR THAN THE BELOW, WHICH IS WHEN WE ARRIVED SUCCESSFULLY
    if os.time() > MovementEndTime then
      yield("/echo ERROR: Move And Open Coffer timed out. Vnavmesh probably made the same error it always makes where it just runs into a wall. Canceling current movement and continuing...")
      yield("/vnavmesh stop")
      yield("/wait 1")
      --do nothing else here -  do not open the coffer or anything, just end what we're doing and go back to calculating destinations

    else --if we got out of the above loop without timing out, we know we arrived at our destination.

      if DebugVariable then
        yield("/echo Debug: Move And Open Coffer arrived at its destination successfully.")
      end

      --getting here means we're moving (combat doesn't stop movement on MCH, thankfully)
      if GetCharacterCondition(26) and DebugVariable then
        yield("/echo Debug: Move And Open Coffer is waiting to be out of combat.")
      end
    
      --once we're at our destination, while we're still in combat, target the nearest thing and start autoattacking it. (see large comments below this while statement)
      while GetCharacterCondition(26) do
        TargetClosestEnemy()
        yield("/wait 0.1")
        yield("/pinteract")
        yield("/wait 0.9")
      end
      --this one's WILD. if you're in combat and hit the mob down to EXACTLY 1 HP, by default rotationsolver will not hit any actions targeting it, because it thinks it's invulnerable or changing phase or something.
      --normally it'd die to your next autoattack... but if there is another mob, RS will switch to that one that it can still hit actions on.
      --since you put your weapon away when you kill your active target, you will then kill mob 2 and never attack mob 1, which is still at 1 HP, attacking you
      --this almost never comes up, except in potd where you have mobs with level 1-4 stats on floor 1
      --BUT, since it's attacking us, we can target it, interact with it so we kill it with our next autoattack, and wait for the auto to go off. this should theoretically handle any number of 1 HP mobs, not just one.
      --please note, this may also be solvable with rotationsolver settings? hell if I know. seems like something I bet they have configured.
  
      if DebugVariable then
        yield("/echo Debug: We have arrived at the destination and we are outside combat.")
      end
      
      --if the Object is a Coffer, try to open it, otherwise don't.
      if (ObjectType == 'Bronze' or ObjectType == 'Silver' or ObjectType == 'Gold') then
    
        if DebugVariable then
          yield("/echo Debug: Attempting to open the " .. ObjectType .. " Coffer.")
        end
    
        yield("/wait 2") --added this because for some reason I needed it. why on earth?
        yield('/target "Treasure Coffer"') --note: this can fail if you are between targets but still in combat (it's those damn fire sprites) but the fail state is "you just don't open that coffer" so whatever
        yield("/wait 1")
        yield("/pinteract")
        yield("/wait 1")
    
      elseif (ObjectType == 'Cairn' or ObjectType == 'Previously Opened Coffer') then
    
        if DebugVariable then
          yield("/echo Debug: Arrived at a " .. ObjectType .. ". Just standing around, thanks.")
        end
  
        yield("/wait 1") --I don't think we actually need this but once we finish this function we restart the object checker which may process a LOT of data so let's give it a second to clear out everything first
    
      else --if it's not any of the three types of coffer or the cairn, do nothing because we didn't tell it to do anything in particular, but also, throw this error so I fix it
    
        if DebugVariable then
          yield("/echo Debug: Move To The Next Destination called with improper ObjectType. Variables were X=" .. XCoordinate .. ", Z=" .. ZCoordinate .. ", ObjectType=" .. ObjectType .. ".")
        end
            
        --end of "what do we do when we get there"
      end

      --end of "did we time out"
    end
  
    --if we did not have a destination, then we have no destination. tautological!
  else 
    
    if DebugVariable then
      yield("/echo Debug: Move to The Next Destination called with no destination. THIS SHOULD NEVER HAPPEN. PLEASE FIX IT!")
    end

    --end of "did we have a destination"
  end

end

--at the start of a new floor, use a Pomander of Affluence if we have one and the floor number is less than 9 (so that we get benefit from it)
--todo: currently not called because I can't get the quantity of 1 differentiated from 0, see below
function PomanderOfAffluence(FloorNumber)

  --do not use on floor nine. if we somehow call this on floor ten, also do not use it there, but we won't.
  if FloorNumber < 9 then
    
    if DebugVariable then
      yield("/echo Debug: Checking whether we have a Pomander of Affluence. Right now this does nothing.")
    end

    --open the pomander window if it is not visible
    if IsAddonVisible(DeepDungeonStatus) then
      --if the pomander window is visible, do nothing.
    else
      yield("/pcall DeepDungeonStatus true 13 1")
      yield("/wait 1")
    end

    --check for presence of a pomander of affluence
    --text node with count if you have 2+ pom of a specific type is:
    --affluence DeepDungeonStatus 65 (pomander base component node) 0 [parent node] 4 (text node)
    --strength 67 0 4
    --steel 66 0 4 yes these do go in reverse wtf lmao
    --if you have only one, you have to go by an image node - does GetNodeListCount change? no that only takes a string addon name jesus christ lmao okay
    --asked croizat and juffa and hopefully I get some deets
   
  
    --to use an affluence: pcallDeepDungeonStatus true 11 5

    --end the loop
  end

end


--Container loop for the rest of the functions, so that the bot only has to call this function once when the script is started to loop until manually stopped
function BeBotting()
  yield('/echo Automatic Palace of the Dead aetherpool farmer has begun. Use "/snd stop" to stop.')
  
  --travel to PotD entrance
  InitialStartup()
    
  --currently an infinite loop. possible future improvement: user-configurable constant "number of aetherpool grips to stop at" that will then break the loop and unload the function.
  while AetherpoolGripCount < GripCountToStop do
    --Enter PotD
    EnterPalace() 
      
    --Clear PotD
    ClearPalace()
      
    --aetherpool check, cash out, and repeat
    SpendAetherpool()

    --check your inventory for aetherpool grips again, as we may have purchased some (but it's better to do this here than in the buying loop imo)
    AetherpoolGripCount = GetItemCount(23165)
  end

  --the above loop is endless. we should never see this.
  yield("/echo We escaped the endless main loop? This should never have happened. Please tell the developer how you got here!")
  yield("/snd stop")

end

--The purpose of the function immediately above this is to make it so that this script, when run, just executes this single line. consider it an elegant reminder of what you should be doing to get this and many other achievements:
BeBotting()

--REQUIRED SETUP: HAVE EMANATION (EXTREME) UNSYNCED SELECTED IN THE DUTY FINDER BEFORE STARTING
--BE WARNED: THIS CRASHES SOMETIMES RANDOMLY SOMEWHERE BETWEEN LEAVING AND REENTERING THE FIGHT. I HAVE NEVER PINNED DOWN WHY.

--DEPENDENCIES:
--YESALREADY is assumed, but should theoretically not be mandatory. however, I have not tested without it.
--ROTATIONSOLVER set to any sort of "on" and configured to not turn off when you change zones or complete a duty (so that you actually ever kill anything)
--make sure you're autoskipping cutscenes. I didn't bother coding to handle that at any point and I assume everyone already is but I wanted to document that

--my dubious "improvements" to the existing community script:
--handle targeting and vril usage without using any keybinds
--move to center of arena at start
--track tank achievements automatically and stop when done
--setting for coffer opening

--tank job to farm achievement on. if set to a nontank job or left blank, this script will loop forever
JobVariable = 'PLD'

--whether or not to open the treasure coffer after the fight
OpenCoffers = false

--set to "true" to get a lot of spam in your chat log for debugging purposes. you don't need to turn this on unless you're trying to fix a thing
DebugVariable = false

--if you set this to "true", the script will try to set up the proper Duty Finder settings itself. I can't get it to work. Feel free to try to fix it yourself, reader.
TryToAutoSetup = false

--okay, rant about duty finder over. let's start the actual code:
function InitialSetup()

  if DebugVariable then
    yield("/echo Debug: Beginning initial setup.")
  end

  JobAchievement = 999999 --set this to very large nonsense so we know it's an int. I may not be good at code but I'm real good at messing things up
  FirstRun = 1 --set this to 0 to report out your achievement count before entering the instance every time. I don't know why you'd want this but it is, technically, configurable. enjoy.

  --make sure that if you're here for a tank achievement, you're actually on that tank job
  ConfirmJobSelection()

  --check achievement progress before we start
  CheckForAchievements()

  --20240408 added this, defaulted to not doing it because I can't get it to work
  --IF THIS VARIABLE IS SET TO FALSE (AS IT IS BY DEFAULT), YOU NEED TO START MAKE SURE THAT EMANATION (EXTREME) (UNSYNCED) IS ALREADY SELECTED IN DUTY FINDER. I ALREADY SAID THIS ONCE, BUT I'M SAYING IT AGAIN.
  if TryToAutoSetup then 
  
    --opens the DF with Emanation (extreme) the visible fight on the right pane. Does NOT Nselect it to enter.
    OpenRegularDuty(264)
    yield("/wait 1")
  
    if DebugVariable then
      yield("/echo Debug: Duty Finder should be open, previous selections should be unchanged.")
    end
  
    yield("/wait 1")
  
    --sets unrestricted party to true... except we also want to clear our existing state and selections because we're starting for the first time
    --(the other way to make that happen is specifically to toggle FROM restricted TO unrestricted party, but we do not know the user's start state because there's no function for that.)
    yield("/pcall ContentsFinder true 12 1") --this hits the "Clear Selection" button, even if you have zero things selected so that button is greyed out. sketchy, but yesalready does worse every day.
    yield("/wait 1")
  
    if DebugVariable then
      yield("/echo Debug: Duty Finder should be open, previous selections should have been cleared.")
    end
  
    SetDFUnrestricted(true) --this is not the bug. I don't think, at least.
    yield("/wait 1")
  
    if DebugVariable then
      yield("/echo Debug: Duty Finder open, Unrestricted Party should have been toggled to on.")
    end
  
    --20240401: there's a bug here somewhere. dunno where. but I don't like it, no I do not. see my frantic comment notes below
    yield("/wait 1") --upped 1 -> 2 -> 3 and sometimes it STILL doesn't work? reverted to wait 1 and just called it good
  
    if DebugVariable then
      yield("/echo Debug: Wait 1 before Lakshmi toggle attempt complete.")
    end
  
    --toggle Emanation (Extreme) to be selected
    --PRETTY sure this is where the bug comes in. but we can't just repeat this function because then if it's currently selected it will become unselected. but it really does look like another iteration of this would work
    yield("/pcall ContentsFinder true 3 51") --theoretically, this would also unselect the fight if it was currently selected. but that doesn't help. just the opposite. means we can't spam it.
  
    if DebugVariable then
      yield("/echo Debug: Sent the pcall to select Emanation (Extreme). This step frequently breaks, so it's a good thing it's only at the beginning. Please confirm this is working!")
    end
  
    yield("/wait 2")
  
    if DebugVariable then
      yield("/echo Duty Finder open, Emanation (Extreme) selected... or possibly not? See above note. Make sure it is.")
    end

  end

end

function EnterEmanation()

  yield("/wait 2") --initial wait

  if DebugVariable then
    yield("/echo Debug: Beginning the function that enters Emanation (Extreme).")
  end

  --repair your gear if it can be repaired. code originally found in flug's diadem script, but I think that it came from somewhere else before that. we really oughta make a canonical SND library, oughtn't we? (one now exists on the snd git wiki I think?)
  if NeedsRepair(99) then

    if DebugVariable then
      yield("/echo Debug: Repairing gear.")
    end
  
    while not IsAddonVisible("Repair") do
      yield("/generalaction repair")
      yield("/wait 1")
    end
  
    yield("/pcall Repair true 0")
    yield("/wait 0.5")
  
    --this accounts for yesalready
    if IsAddonVisible("SelectYesno") then
      yield("/pcall SelectYesno true 0")
      yield("/wait 0.1")
    end
  
    --wait for repairs to finish
    while GetCharacterCondition(39) do yield("/wait 1") end
  
    --and close the repair window
    yield("/wait 1")
    yield("/pcall Repair true -1")
  
    if DebugVariable then
      yield("/echo Debug: Repair complete.")
    end

  end
    
  if DebugVariable then
    yield("/echo Debug: Repair check finished.")
  end

  --this is the Diadem entry code, but changed
  --"While we are not queueing, try to queue" (20230328 added the DF opening/joining to this loop condition)
  while GetCharacterCondition(34, false) and GetCharacterCondition(45, false) do --34 = boundbyduty. 45 = between areas. theoretically if we are neither of these we have successfully entered
  
    --open the DF - specifically, with Emanation (Extreme) visible, though this should not be necessary because we already selected it in the initial setup function and nothing has changed.
    OpenRegularDuty(264)
    yield("/wait 1.5")
  
    if DebugVariable then
      yield("/echo Debug: Opened Duty Finder")
    end
  
    --hits the "Join" button to queue into Emanation (Extreme)
    yield("/pcall ContentsFinder true 12 0")
    yield("/wait 1.5")

    if DebugVariable then
      yield("/echo Debug: Clicked 'Join' on Emanation (Extreme)")
    end
  
    if IsAddonVisible("ContentsFinderConfirm") then
      yield("/pcall ContentsFinderConfirm true 8")
    end
  
    yield("/wait 3") --20240328 lengthened wait to see if this prevents that crash I just cannot seem to nail down
  end

  if DebugVariable then
    yield("/echo Debug: Theoretically, we should have successfully entered Emanation (Extreme).")
  end

  --while we're not in cutscene, wait until we are
  while GetCharacterCondition(35, false) do
    yield("/wait 1")
  end

  --while we're in cutscene, wait until we're not
  while GetCharacterCondition(35) do
    yield("/wait 1")
  end

  --wait three seconds for the combat barrier (not technically necessary because the combat loop will wait anyway but might as well)
  yield("/wait 3")

  if DebugVariable then
    yield("/echo Debug: Entering process complete. Moving to combat.")
  end

end

function ClearEmanation()

  if DebugVariable then
    yield("/echo Debug: Should have entered Emanation (Extreme).")
  end

  --we have zoned in and waited 3 for the barrier so we can tell it to move to 0 0 0 aka the center of the arena (thank you, developers) and wait until we're done moving
  yield("/visland moveto 0 0 0")
  
  while IsMoving() do
    yield("/wait 1")
  end

  --while we are not in combat - I believe the first adds actually aggro you at this physical location, but it shouldn't matter if not - that'd put you in combat and this loop would get skipped.
  while not GetCharacterCondition(26) do
  
    --if we have no target, target the closest enemy
    if not current_target or current_target == "" then

      TargetClosestEnemy()
      local current_target = GetTargetName()
  
      yield("/wait 0.1") --superstition, likely unnecessary
  	  yield("/visland moveto " .. GetTargetRawXPos() .. " " .. GetTargetRawYPos() .. " " ..  GetTargetRawZPos())
	
  	  if DebugVariable then
        yield("/echo Debug: Outside combat, moving to " .. GetTargetRawXPos() .. " " .. GetTargetRawYPos() .. " " ..  GetTargetRawZPos())
      end
	
	    yield("/wait 0.5") --wait time for movement

    end

  end

  --now we are in combat. we will not be OUT of combat until lakshmi is dead, because it goes 2x Dreaming Kshatriya -> Lakshmi -> various Dreaming Brahmin and Dreaming Shudra -> Lakshmi again -> win
  --therefore, we can use a single while loop for "is in combat" to handle all combat behavior and vril usage
  while GetCharacterCondition(26) do

    --behavior 1: use Vril as needed
    --Retrieve the action ID of the current target's cast
    local ActionID = GetTargetActionID()
 
    --todo: divine denial is not properly even triggering the vril thing... I think I fixed this?

    -- if the target (i.e. Lakshmi) is using Divine Denial, Divine Desire, or Divine Doubt...
    if ActionID == 8521 or ActionID == 8522 or ActionID == 8523 then

      -- ...and we do not have Vril status...
      if not HasStatus("Vril") then
      
        if DebugVariable then
          yield("/echo Debug: Trying to use Vril.")
        end
  
	      --...execute Duty Action 1 to give us Vril status as yoship intended
        ExecuteGeneralAction(26) --can this break if we're busy? like if rotationsolver's busy using an action.
	      yield("/wait 0.5")
	      ExecuteGeneralAction(26) --since I don't know, vril's so nice we did it twice
	  
	      if DebugVariable then
          yield("/echo Debug: Hopefully we have used Vril properly.")
        end

      end

    end

    --behavior 2: select a target if we don't already have one (i.e. we just killed adds but Lakshmi hasn't autoattacked us yet)
    local current_target = GetTargetName()
  
    if not current_target or current_target == "" then

      TargetClosestEnemy()
      local current_target = GetTargetName()
      if current_target == "" then

        if DebugVariable then
  		    yield("/echo Debug: No target or distance information available mid-fight. Waiting one second...")
        end
		  
        yield("/wait 1")  --chill for a second if we can't find a target, since we have no need to move immediately
      end
    end
  
    --behavior 3: move to the target, to be sure we're hitting it (and to not die to Lakshmi's knockback, which she very politely only uses AFTER going to the middle. that's wild.)
    local dist_to_enemy = GetDistanceToTarget()
  
    if dist_to_enemy and dist_to_enemy > 3 then
      local enemy_x = GetTargetRawXPos()
      local enemy_y = GetTargetRawYPos()
      local enemy_z = GetTargetRawZPos()
    
	    yield("/visland moveto " .. enemy_x .. " " .. enemy_y .. " " .. enemy_z)
	    
      if DebugVariable then
	      yield("/echo Debug: Inside combat but far from enemy. Moving to " .. enemy_x .. ", " .. enemy_y .. ", " .. enemy_z .. ".")
      end
		  
      yield("/wait 2")  -- Adjust wait time as necessary for movement completion
      yield("/visland stop")  -- Stop movement after reaching near the target
    else --if we are less than 3 yalms away, we have no need to move for now.
    end
  
    -- now wait half a second and evaluate all three of these behaviors again. this might even be too high a wait. not sure.
    yield("/wait 0.5")
  end

  --getting here means we are not in combat, after previously being in combat, so theoretically we won. yay!
  if DebugVariable then
    yield("/echo Debug: Combat has ended.")
  end

  yield("/wait 3") --make sure we've skipped the cutscene

  --open the treasure coffer, if you want
  if OpenCoffers then

    yield("/target Treasure Coffer") --this works?! I am amazed.
    yield("/wait 1") --make sure we've targeted it before trying to move to it
    yield("/visland moveto 0 0 -6.5") --coffer spawns at 0 0 -7
    yield("/wait 1") --wait for movement
    yield("/pinteract") --open the coffer. I tested this and it works lmao.
  
    if DebugVariable then
      yield("/echo Debug: Opened Treasure Coffer. Waiting one second for loot, just in case.")
    end
  
    yield("/wait 1") --make sure that loot hits your inventory

  end

  if DebugVariable then
    yield("/echo Debug: Leaving duty.")
  end

  LeaveDuty()
  yield("/wait 2") --wait for the process of zoning out to begin

  --continue waiting until we've actually left. this should never actually be relevant with how fast it is to leave this instance, but we'll handle it gracefully anywas.
  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
    
    if DebugVariable then
      yield("/echo Debug: Waiting to exit Emanation (Extreme).")
    end
  
    yield("/wait 2")

  end

--now we should be out, but see the note above in the entering function
end

--fetches achievement progress so we know when to stop, if we want to stop
function CheckForAchievements()

  if DebugVariable then
    yield("/echo Debug: Beginning achievement check.")
  end

  if JobAchievement < 9000 then --this means if it's been defined above earlier that we're actually here for tank farming. otherwise, we won't worry about it.
    RequestAchievementProgress(JobAchievement)
    yield("/wait 1") --Per croizat, a wait is required here to actually return the correct value
    TotalCount = tonumber(GetRequestedAchievementProgress())
  
    --if we just started, report out where we're at
    if FirstRun == 1 then
      yield("/echo Current progress towards the final " .. JobVariable .. " achievement is " .. TotalCount .. "/700. Good luck!")
      FirstRun = 0
    end
  
    if TotalCount > 699 then
      CompletionVariable = true --for now, 700 kills is the last achievement. this has to be updated by hand if they added more in DT. sorry.
    end

  end

  if DebugVariable then
    yield("/echo Debug: Achievement check complete.")
  end

end

--validate job selection
function ConfirmJobSelection()

  if DebugVariable then
    yield("/echo Debug: Validating selected job/defined job variable combination.")
  end

  --possible improvement: assume that all jobsets have default names and put in a /gs equip command to try to fix nonmatching. however, I am very lazy.
  if JobVariable == 'WAR' then

    JobAchievement = 2991
    
    if GetClassJobId() ~= 21 then
      QuitOut()
    end

    yield("/echo Currently farming on WARRIOR.")

  elseif JobVariable == 'DRK' then

    JobAchievement = 2992
    
    if GetClassJobId() ~= 32 then
      QuitOut()
    end

    yield("/echo Currently farming on DARK KNIGHT.")

  elseif JobVariable == 'GNB' then

    JobAchievement = 2993

    if GetClassJobId() ~= 37 then
      QuitOut()
    end

    yield("/echo Currently farming on GUN'SBRASTER.") --they call him the Dark Draker

  elseif JobVariable == 'PLD' then

    JobAchievement = 2990
  
    if GetClassJobId() ~= 19 then
      QuitOut()
    end

    yield("/echo Currently farming on PALADIN.")

else

  yield("/echo The job variable (on line 16 of the script) is not set to a tank job. Achievement tracking is not activated and this script will run until you stop it manually.")

end

if DebugVariable then
  yield("/echo Debug: Job variable validation complete.")
end

end

--quit out if we did not match jobs. honestly, this does not need to be its own function, but I like not copying and pasting.
function QuitOut()
  yield("/echo Selected job (defined on line 16 of the script) is " .. JobVariable .. ", but you're currently not that job. Please either change jobs or change that variable. Quitting...")
  yield("/snd stop")
end

--this variable will be set to true when you complete a tank farm achievement and used to stop. if you're not on a tank job, this will run forever until you stop it.
--this is hiding down here ON PURPOSE so you don't mess with it, dear user. please do not ever change it ever.
CompletionVariable = false

--wrapper function for everything else, called at the start and loops until done or forever, as desired
function MainFunctionLoop()

  --sets up everything for the first time
  InitialSetup()

  --until we have the tank achievement (if we have one we want), repeat the following. function names self-explanatory imo.
  while not CompletionVariable do

    CheckForAchievements()

    EnterEmanation()

    ClearEmanation()
  end

  --if we made it here, the completion variable is true, which means we should have the 700 tank farm achievement for the tank we defined above
  yield("/echo You got the final " .. JobVariable .. " achievement. Good job!")
  yield("/snd stop")
end

--this is the only code that actually runs when you start this in SND
MainFunctionLoop()
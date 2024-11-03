--REQUIRED SETUP: HAVE IFRIT TRIAL SELECTED UNSYNC IN THE DUTY FINDER.
--(never did get the duty finder selection by id working)

--DEPENDENCIES:
--YESALREADY is assumed, but should theoretically not be mandatory. however, I have not tested without it
--ROTATIONSOLVER set to any sort of "on" and configured to not turn off when you change zones or complete a duty (so that you actually ever kill anything)
--make sure you're autoskipping cutscenes. I didn't code to handle that at any point and I assume everyone already is but I wanted to document that

--set to "true" to get a lot of spam in your chat log for debugging purposes. you don't need to turn this on unless someone has specifically asked you to.
DebugVariable = true

--fetches achievement progress so we know when to stop
function CheckForAchievements()

  if DebugVariable then
    yield("/echo Debug: Beginning achievement check.")
  end

  yield("/wait 1")
  RequestAchievementProgress(1227)
  yield("/wait 1") --Per croizat, a wait is required here to actually return the correct value
  TotalCount = tonumber(GetRequestedAchievementProgress())
    
  if TotalCount > 9999 then --Lifer 3 is literally from 3.0, but yeah, sure, update this if they add lifer 4, whatever.
    CompletionVariable = true
  end
  
  if DebugVariable then
    yield("/echo Debug: Achievement check complete.")
  end

end

function EnterIfrit()
  
  if DebugVariable then
    yield("/echo Debug: Beginning the function that enters Ifrit.")
  end
  
  --repair your gear if it can be repaired. code from flug's diadem, but I think it predates that. go see the SND wiki function library I bet it's there.
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
  
  yield("/wait 1") -- trying to nail down this crash

  --"While we are not queueing, try to queue"
  while GetCharacterCondition(34, false) and GetCharacterCondition(45, false) do --34 = boundbyduty. 45 = between areas. theoretically if we are neither of these we have successfully entered
    
    --open the DF - specifically with Ifrit visible, except this is not ifrit? but it shouldn't matter anyway because you have to set it up in advance
    OpenRegularDuty(6) --sure, open to haukke manor, whatever, see above, have Ifrit selected
    yield("/wait 2") --wow, the DF takes forever to open sometimes? sorry about this wait that does add up, I know how it is
    
    if DebugVariable then
      yield("/echo Debug: Opened Duty Finder.")
    end
    
    --hits the "Join" button to queue into Ifrit
    yield("/pcall ContentsFinder true 12 0")
    yield("/wait 1")
  
    if DebugVariable then
      yield("/echo Debug: Clicked 'Join' on the Bowl of Embers.")
    end
    
    if IsAddonVisible("ContentsFinderConfirm") then
      yield("/pcall ContentsFinderConfirm true 8")
      yield("/wait 1")
    end
    
    yield("/wait 3") --wait in case something went wrong, which it never should
  end

  if DebugVariable then
    yield("/echo Debug: Now entering Ifrit.")
  end
  
  yield("/wait 1") --hmm. testing.
  
  --while we're not in cutscene, wait until we are (as in, we're zoning in and hitting cutscene)
  while GetCharacterCondition(35, false) do yield("/wait 1") end
  
  --while we're in cutscene, wait until we're not, which means we're in just fine
  while GetCharacterCondition(35) do yield("/wait 1") end
  
  if DebugVariable then
    yield("/echo Debug: Entering process complete. Moving to combat.")
  end

end

function ClearIfrit()

  if DebugVariable then
    yield("/echo Debug: We have entered Ifrit.")
  end
  
  --wait for the zone to load before doing anything. this may have to be adjusted if you have a bad connection somehow.
  yield("/wait 2")
  
  --target Ifrit
  TargetClosestEnemy()
  
  --move to middle of arena, which will kill him via RotationSolver being on (confirmed that this is the actual coordinates)
  yield("/vnavmesh moveto 0 0 0")
  yield("/wait 0.2") --wait to start moving
  
  --while we're moving, before we have killed Ifrit, wait
  while IsMoving() and not GetCharacterCondition(26) do
    yield("/wait 0.5")
  end

  --while in combat, wait one second for murder.
  while GetCharacterCondition(26) do
    if DebugVariable then
      yield("/echo Debug: We have entered combat. Waiting one second. If you see this message twice, maybe I should fix it.")
    end
  
    yield("/vnavmesh stop") --stop moving, since we don't actually care where we are.
    yield("/wait 1") --turns out you don't see this message twice, in general
  end

  --getting here means we were not in combat, then in combat, then not in combat, which means we are done
  if DebugVariable then
    yield("/echo Debug: Combat has ended. Leaving duty.")
  end

  yield("/wait 1") --make sure we've skipped the cutscene... is this necessary? it feels like it should not be, but I'm willing to sacrifice some time
  LeaveDuty()
  yield("/wait 1") --wait for the process of zoning out to begin
  
  --continue waiting until we've actually left. load times can be a jerk for no reason sometimes.
  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
    if DebugVariable then
      yield("/echo Debug: Waiting to exit Ifrit.")
    end
    
    yield("/wait 1")
  end

  yield("/wait 1") -- does this slow it down enough?

end

--wrapper function for everything else, called at the start and loops until done
function MainFunctionLoop()

  --until we have lifer 3, repeat the battle loop
  while not CompletionVariable do
    CheckForAchievements()

    EnterIfrit()

    ClearIfrit()
  end

  --if we made it here, the completion variable is true, which means we have done ten thousand instances.
  yield("/echo You got Lifer III. Good job!")
  yield("/snd stop")
end

--this is the only code that actually runs when you start this in SND
MainFunctionLoop()
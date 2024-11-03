--please note: DOESN'T WORK FOR CHARACTERS IN THE MAELSTROM YET. SORRY. I DIDN'T RECORD THE NECESSARY VALUES.
--OTHER DEPENDENCY: IF YOU HAVE ITEMS TRADABLE FOR GC SEALS THAT ARE HIGHER THAN i190, YOU'LL END UP TRYING TO BUY DUPLICATE ALEX ITEMS. TRADE THESE ALL IN IN BEFORE STARTING.

--ADDON DEPENDENCY: LIFESTREAM, USED TO EASILY NAVIGATE TO SABINA
--ADDON DEPENDENCY: TELEPORTER, USED TO AVOID HAVING TO USE PCALL TO TELEPORT TO IDYLLSHIRE/NEW GRIDANIA
--ADDON DEPENDENCY: VISLAND, USED TO PATH TO BOTH SABINA AND GC HEADQUARTERS (vnavmesh has likely replaced this at some point but I haven't touched this since I finished all HW relics)

--KIND OF VAGUE BUT PROBABLY A THING ADDON DEPENDENCIES:
--some combination of YesAlready, TextAdvance, and Pandora's Box is required to automatically exchange the Gordian items for the actual gear and confirm some boxes somewhere and I have no idea where
--this could probably be worked around, but I didn't bother to test it because it works on my machine :)

--UPDATE THIS TO: 'Storm' for Limsa / 'Flame' for Ul'dah (it's the word in the Personnel Officer/Quartermaster's name) [LIMSA IS NOT ROUTED. DO NOT DO STORM.]
CharacterGC = 'Flame'

--Set item ID for the GC seal for the GC we belong to. Have to do this before we do anything else.
if CharacterGC == 'Serpent'
  then SealID = 21
elseif CharacterGC == 'Storm'
  then SealID = 20
elseif CharacterGC == 'Flame'
  then SealID = 22
else
  SealID = 28 --if improperly configured, check against Poetics instead, which you're guaranteed to have less than 20k of => never try to make a purchase to be safe from bad situations. Don't do this.
end

--Set the item to purchase. Currently supported: 'Materiel4', 'Materiel3', 'Cashmere' (you want materiel container 4.0, trust me. I guess 5.0 exists now. sorry.) (don't ask about the Cashmere.)
ItemToPurchase = 'Cashmere'

--assign the correct purchase cost to this variable in advance
if ItemToPurchase == 'Materiel4'
  then CostToPurchase = 20000
elseif ItemToPurchase == 'Materiel3'
  then CostToPurchase = 20000
elseif ItemToPurchase == 'Cashmere'
  then CostToPurchase = 1500
else
  yield("/echo Item to Purchase is improperly configured. Please edit line 27. Quitting...")
  yield("/snd stop")
end

--tarnished gordian item ids, hardcoded for all later references. if they ever change, this'll break.
LensID = 12674
ShaftID = 12675
CrankID = 12676
SpringID = 12677
PedalID = 12678
BoltID = 12680

--initialize item counts. shouldn't matter. doing it anyways. don't want to run into stupid data type errors later when I accidentally create these as a string somehow. voice of experience.
LensCount = GetItemCount(LensID)
ShaftCount = GetItemCount(ShaftID)
CrankCount = GetItemCount(CrankID)
SpringCount = GetItemCount(SpringID)
PedalCount = GetItemCount(PedalID)
BoltCount = GetItemCount(BoltID)
GCSealCount = GetItemCount(SealID)
ItemExchangeCount = 0 --this is "how many items are currently in our inventory to hand over to the personnel officer". we'll update this from zero later, but it's assuming 0 to start. I already noted this above.

--generic functions for purchasing items, thankfully the pcall doesn't change across menus
--I think I could actually have only one function here named PurchaseItem, and take two parameters in, where the other is the Gordian item name, but I'm lazy.
function PurchaseLensItem(ItemID)
  
  --yield("/echo Debug: Starting PurchaseLensItem")
  --purchase the ID we called in with
  yield("/pcall ShopExchangeItem true 0 " .. ItemID .." 1 0")
  
   --decrement Lens count by 2, which is what all Lens items cost
  LensCount = LensCount - 2
  ItemExchangeCount = ItemExchangeCount + 1
  
  --and wait one second
  yield("/wait 1")

end

function PurchaseShaftItem(ItemID)

  --yield("/echo Debug: Starting PurchaseShaftItem")
  --purchase the ID we called in with
  yield("/pcall ShopExchangeItem true 0 " .. ItemID .." 1 0")
  
   --decrement Shaft count by 4, which is what all Shaft items cost
  ShaftCount = ShaftCount - 4
  ItemExchangeCount = ItemExchangeCount + 1
  
  --and wait one second
  yield("/wait 1")

end

function PurchaseCrankItem(ItemID)

  --yield("/echo Debug: Starting PurchaseCrankItem")
  --purchase the ID we called in with
  yield("/pcall ShopExchangeItem true 0 " .. ItemID .." 1 0")
  
   --decrement Crank count by 2, which is what all Crank items cost
  CrankCount = CrankCount - 2
  ItemExchangeCount = ItemExchangeCount + 1
  
  --and wait one second
  yield("/wait 1")

end

function PurchaseSpringItem(ItemID)

  --yield("/echo Debug: Starting PurchaseSpringItem")
  --purchase the ID we called in with
  yield("/pcall ShopExchangeItem true 0 " .. ItemID .." 1 0")
  
   --decrement Spring count by 4, which is what all Spring items cost
  SpringCount = SpringCount - 4
  ItemExchangeCount = ItemExchangeCount + 1
  
  --and wait one second
  yield("/wait 1")

end

function PurchasePedalItem(ItemID)

  --yield("/echo Debug: Starting PurchasePedalItem")
  --purchase the ID we called in with
  yield("/pcall ShopExchangeItem true 0 " .. ItemID .." 1 0")
  
   --decrement Pedal count by 2, which is what all Pedal items cost
  PedalCount = PedalCount - 2
  ItemExchangeCount = ItemExchangeCount + 1
  
  --and wait one second
  yield("/wait 1")

end

function PurchaseBoltItem(ItemID)

  --yield("/echo Debug: Starting PurchaseBoltItem")
  --purchase the ID we called in with
  yield("/pcall ShopExchangeItem true 0 " .. ItemID .." 1 0")
  
   --decrement Bolt count by 1, which is what all Bolt items cost
  BoltCount = BoltCount - 1
  ItemExchangeCount = ItemExchangeCount + 1
  
  --and wait one second
  yield("/wait 1")

end

function PurchaseItemsFromSabina()

  --yield("/echo Debug: Starting PurchaseItemsFromSabina")
  
  --talk to Sabina, open the menu
  yield("/target Sabina")
  yield("/wait 1")
  yield("/pinteract")
  yield("/wait 1")
  
  --purchase from the top option, Gordian Part Exchange (DoW) I
  --this menu has 3x2 lens hats, 3x4 shaft bodies, 3x2 crank hands, 3x4 spring pants, 3x2 pedal feet, 4x1 bolt accessories
  yield("/pcall SelectIconString true 0")
  yield("/wait 1")
  yield("/pcall SelectString true 0") --there is a shopexchangeitem true 5 here that I don't know the purpose of when you click manually. it is not necessary to open the menu. very strange.
  yield("/wait 1")
  
  --now that we are inside the menu, purchase everything we have the materials for
  --this could be a for loop (for i=1,3,1 do... keep count same... purchaseitem(X+i) for fixed X = sum of previous items) but space and elegance are not priorities here at the moment
  --for clarity, this is saying "if we have at least 2 lenses, purchase the lens item at the top of the list. otherwise, do nothing."
  if LensCount > 1
  then PurchaseLensItem(0)
  else
  end
  
  --now we do the same thing two more times with the next two items, which are both lens items
  if LensCount > 1
  then PurchaseLensItem(1)
  else end
  
  if LensCount > 1
  then PurchaseLensItem(2)
  else end
  
  --now we do the same thing with shafts, cranks, springs, pedals, and bolts...
  if ShaftCount > 3
  then PurchaseShaftItem(3)
  else end
  
  if ShaftCount > 3
  then PurchaseShaftItem(4)
  else end
  
  if ShaftCount > 3
  then PurchaseShaftItem(5)
  else end
  
  --cranks
  if CrankCount > 2
  then PurchaseCrankItem(6)
  else end
  
  if CrankCount > 2
  then PurchaseCrankItem(7)
  else end
  
  if CrankCount > 2
  then PurchaseCrankItem(8)
  else end
  
  --springs
  if SpringCount > 3
  then PurchaseSpringItem(9)
  else end
  
  if SpringCount > 3
  then PurchaseSpringItem(10)
  else end
  
  if SpringCount > 3
  then PurchaseSpringItem(11)
  else end
  
  --pedals
  if PedalCount > 2
  then PurchasePedalItem(12)
  else end
  
  if PedalCount > 2
  then PurchasePedalItem(13)
  else end
  
  if PedalCount > 2
  then PurchasePedalItem(14)
  else end
  
  --bolts
  if BoltCount > 0
  then PurchaseBoltItem(15)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(16)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(17)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(18)
  else end
  
  --we do not need a standalone wait here, since we ended the "enter shop" menu with a wait 1 and we end all purchases with a wait 1
  yield("/pcall ShopExchangeItem true -1")
  yield("/wait 1")
  
  --yield("/echo Debug: Starting second Sabina menu within PurchaseSabinaItem")
  
  --enter the second menu
  yield("/pcall SelectString true 1") --there is a shopexchangeitem true 5 here that I don't know the purpose of. omitting it seems to cause no problems.
  yield("/wait 1")
  
  --purchase from the second option, Gordian Part Exchange (DoW) II
  --this menu has 2x2 lens hats, 2x4 shaft bodies, 2x2 crank hands, 2x4 spring pants, 2x2 pedal feet, 8x1 bolt accessories
  --now that we are inside the menu, we will purchase everything we have the materials for, in the same way
  if LensCount > 1
  then PurchaseLensItem(0)
  else end
  
  if LensCount > 1
  then PurchaseLensItem(1)
  else end
  
  if ShaftCount > 3
  then PurchaseShaftItem(2)
  else end
  
  if ShaftCount > 3
  then PurchaseShaftItem(3)
  else end
  
  if CrankCount > 2
  then PurchaseCrankItem(4)
  else end
  
  if CrankCount > 2
  then PurchaseCrankItem(5)
  else end
  
  if SpringCount > 3
  then PurchaseSpringItem(6)
  else end
  
  if SpringCount > 3
  then PurchaseSpringItem(7)
  else end
  
  if PedalCount > 2
  then PurchasePedalItem(8)
  else end
  
  if PedalCount > 2
  then PurchasePedalItem(9)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(10)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(11)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(12)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(13)
  else end
  
  --same logic as first standalone wait
  yield("/pcall ShopExchangeItem true -1")
  yield("/wait 1")
  
  --yield("/echo Debug: Starting third shop menu within PurchaseSabinaItem")
  
  --enter the third menu
  yield("/pcall SelectString true 2")
  yield("/wait 1")
  
  --purchase from the third option, Gordian Part Exchange (DoM)
  --this menu has 2x2 lens hats, 2x4 shaft bodies, 2x2 crank hands, 2x4 spring pants, 2x2 pedal feet, 8x1 bolt accessories
  if LensCount > 1
  then PurchaseLensItem(0)
  else end
  
  if LensCount > 1
  then PurchaseLensItem(1)
  else end
  
  if ShaftCount > 2
  then PurchaseShaftItem(2)
  else end
  
  if ShaftCount > 3
  then PurchaseShaftItem(3)
  else end
  
  if CrankCount > 2
  then PurchaseCrankItem(4)
  else end
  
  if CrankCount > 2
  then PurchaseCrankItem(5)
  else end
  
  if SpringCount > 3
  then PurchaseSpringItem(6)
  else end
  
  if SpringCount > 3
  then PurchaseSpringItem(7)
  else end
  
  if PedalCount > 2
  then PurchasePedalItem(8)
  else end
  
  if PedalCount > 2
  then PurchasePedalItem(9)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(10)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(11)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(12)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(13)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(14)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(15)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(16)
  else end
  
  if BoltCount > 0
  then PurchaseBoltItem(17)
  else end

  --leave the sabina menu
  yield("/pcall ShopExchangeItem true -1")
  yield("/wait 1")
  yield("/pcall SelectString true -1")
  yield("/wait 1")
  
  --and then teleport to the correct GC NPC, which we're putting here rather than in the global loop for marginal elegance
  if CharacterGC == 'Serpent'
  then GoToGridaniaGCNPC()
  elseif CharacterGC == 'Storm'
  then
  --GoToLimsaGCNPC()
  yield("I HAVEN'T PATHED OUT LIMSA YET. SORRY!")
  yield("/snd stop")
  elseif CharacterGC == 'Flame'
  then GoToUldahGCNPC()
  else
  yield("/echo Grand Company name is incorrectly configured. I'm looking for Serpent/Storm/Flame. AND STORM IS NOT YET IMPLEMENTED.")
  end  
end

function GoToSabina()

  --yield("/echo Debug: Starting GoToSabina")
  yield("/tp Idyllshire")
  --alternatively there's: yield("/pcall Teleport true 0 33 8") but this is much smoother with Teleporter
  yield("/wait 6") --wait for Teleport cast/load, typically this takes about ten seconds for me
  
  --wait for teleport to finish
  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
    yield("/echo Waiting 2 seconds to finish Idyllshire teleport.")
    yield("/wait 2")
  end
  
  --todo: replace visland movement with vnavmesh movement eventually. heck, this could remove teleport dependency too.
  --you can end up anywhere near the aetheryte. X coordinate range [53,90]. Y coordinate range [207.3, 207.8]. Z coordinate range [1,-38].
  --BUT if you run to the aetheryte for two seconds, even if you run into the raised platform it's on, you're within interact range...
  yield("/wait 2") --lifestream is supposed to run to aetherytes for you but it doesn't. perhaps it never did and that's only for world travel. wahtever, this is fine.
  yield("/visland moveto 71 211 -19") --approx aetheryte coords
  yield("/wait 2") --run directly into the wall like a moron
  yield("/visland stop") --visland pause can be visland resume'd later, but we want a full stop because we don't ever want to resume this
  yield("/li west") --dependency: Lifestream 
  
  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do --wait to arrive, you should never hit this I think because it's same-zone transition, better safe than sorry
   yield("/echo Debug: Waiting 2 seconds for Idyllshire aetheryte")
   yield("/wait 2")
  end
  
  --path from Aetheryte to Sabina
  yield("/visland moveto -55 206 -15") --a random spot on the stone path by the aetheryte
  yield("/wait 6")
  yield("/visland moveto -39 206 -12") --at the bottom of the stairs, nice and safe in the middle so we don't fall off the side or run into the wall
  yield("/wait 5")
  yield("/visland moveto -28, 211, -3") --up the stairs
  yield("/wait 5")
  yield("/visland moveto -7, 211, -23") --into the building
  yield("/wait 6")
  yield("/visland moveto -20, 211, -35") --Sabina's desk
  yield("/wait 4") --arrive at Sabina's desk so we can talk to her, obviously
end

--three distinct copy and pasted functions. bad, but functional.
function GoToGridaniaGCNPC()

  --yield("/echo Debug: Starting GoToGridaniaGCNPC")
  TeleportToGCTown()
  yield("/wait 8") --wait for Teleport cast/load, typically this takes about fourteen for me

  --wait for teleport to finish
  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
    yield("/wait 2")
    yield("/echo Waiting 2 seconds to finish New Gridania teleport.")
  end

  --run from aetheryte plaza to gc turnin npc
  yield("/visland moveto 24 1 32") --I hope you can't get stuck on the aetheryte. never seen that happen but worse things have happened.
  yield("/wait 5") --long on purpose, because I don't know what governs when you arrive
  yield("/visland moveto 22 1 25")
  yield("/wait 5") --again, these are kind of wonky
  yield("/visland moveto -2 -1 11")
  yield("/wait 5")
  yield("/visland moveto -22 -4 12")
  yield("/wait 5")
  yield("/visland moveto -50 -4 12")
  yield("/wait 5")
  yield("/visland moveto -58 -2 11")
  yield("/wait 5")
  yield("/visland moveto -67 -1 -3")
  yield("/wait 5")
  yield("/visland moveto -68 -1 -8") --arrive between the two npcs so we don't have to move later
  yield("/wait 5")
end

--second of three distinct copy and pasted functions
function GoToUldahGCNPC()
  
  --yield("/echo Debug: Starting GoToUldahGCNPC")
  TeleportToGCTown()
  yield("/wait 8") --wait for Teleport cast/load, typically this takes about fourteen for me total. probably all the underground bots at the aetheryte loading in, not a joke somehow.

  --wait for teleport to finish
  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
   yield("/wait 2")
   yield("/echo Waiting 2 seconds to finish Ul'dah teleport.")
  end

  --run from aetheryte plaza to gc turnin npc
  yield("/visland moveto -132 -2 -155") --entrance of the Weird Aetheryte Nook, uldah doesn't even have guards on it, how do they stop people from smuggling things in (...oh, I get it)
  yield("/wait 5")
  yield("/visland moveto -97 4 -114") --straight shot up the stairs
  yield("/wait 10")
  yield("/visland moveto -125 4 -90") --run over to the flame lieutenant by the entrance to the hall
  yield("/wait 7")
  yield("/visland moveto -142 4 -106") --and arrive at the desk
  yield("/wait 5")
end

--THIS IS NOT A REAL ROUTE. I JUST COPYPASTED GRIDANIA. DO NOT USE THIS. MAELSTROM / STORM / LIMSA IS NOT YET IMPLEMENTED. PLEASE DO NOT TRY IT.
--function GoToLimsaGCNPC()
--
--  TeleportToGCTown()
--  --or there's yield("/pcall Teleport true 0 12 1")
--  yield("/wait 8") --wait for Teleport cast/load, typically this takes about fourteen for me
--
--  --wait for teleport to finish
--  while (GetCharacterCondition(45) or GetCharacterCondition(51)) do
--   yield("/wait 2")
--   yield("/echo Waiting 2 seconds to finish Limsa Lominsa teleport.")
--  end
--
--  --run from aetheryte plaza to gc turnin npc THIS IS THE GRIDANIA ROUTE, DO NOT USE IT
--  --yield("/visland moveto 24 1 32") --I hope you can't get stuck on the aetheryte. should test that at some point
--  --yield("/wait 5") --long on purpose, because I don't know what governs when you arrive
--  --yield("/visland moveto 22 1 25")
--  --yield("/wait 2")
--  --yield("/visland moveto -2 -1 11")
--  --yield("/wait 5")
--  --yield("/visland moveto -22 -4 12")
--  --yield("/wait 4")
--  --yield("/visland moveto -50 -4 12")
--  --yield("/wait 4")
--  --yield("/visland moveto -58 -2 11")
--  --yield("/wait 3")
--  --yield("/visland moveto -67 -1 -3")
--  --yield("/wait 4")
--  --yield("/visland moveto -68 -1 -8") --arrive between the two npcs so we don't have to move later
--  --yield("/wait 3")
--end

function TurnInGCItems()

  --yield("/echo Debug: Starting TurnInGCItems")
  yield("/target " .. CharacterGC .. " Personnel Officer") --generalized!
  yield("/wait 1")
  yield("/pinteract")
  yield("/wait 1")
  
  --if you're not bypassing this via Yes Already, get into the GC turnin menu
  if IsAddonVisible("SelectString") then
    yield("/pcall SelectString true 0")
  end
  
  yield("/wait 2") --this takes a while to open, for some reason, for me. making this wait longer so that we actually end up on the ED tab and don't do nothing
  
  yield("/pcall GrandCompanySupplyList true 0 2 0") --move to the Expert Delivery tab

  --for each item that we purchased, turn in the top tradable item in your list
  for i = 1, ItemExchangeCount, 1 do

    yield("/pcall GrandCompanySupplyList true 1 0 0")
    yield("/wait 1") --this sometimes does not work if I make this 0.5 and 0.5, and I'm not certain why
	
	  --yes already means I do not have to care about this, but splitting the waits in half is no burden and I'm trying to futureproof this for other people
    if IsAddonVisible("GrandCompanySupplyReward") then
      yield("/pcall GrandCompanySupplyReward true 0")
    end
    
	  --out of paranoia, reset this afterwards
	  ItemExchangeCount = 0
	
	  yield("/wait 1")

  end

  --now leave the menu (original code stolen from AutoED, thanks plottingcreeper) - added a loop with a single extra iteration here in case lag causes us to drop one of these button presses (originally a pyes adaptation)
  for i = 1, 3, 1 do
    
    if IsAddonVisible("GrandCompanySupplyList") then
      yield("/pcall GrandCompanySupplyList true -1") --exit gc supply menu if you're in it
    end
    
    if IsAddonVisible("SelectString") then
      yield("/pcall SelectString true 3") --select "nothing" and stop talking if you're in the menu you get when you talk to the guy
    end
    
    yield("/wait 1")

  end

end

function SpendGCSeals()

  --yield("/echo Debug: Starting SpendGCSeals")
  
  --update seal count, which determines item purchase count
  GCSealCount = GetItemCount(SealID)
  CountToPurchase = math.floor(GCSealCount/CostToPurchase)
  
  yield("/echo Exchanging ".. CountToPurchase * CostToPurchase .." GC seals for " .. CountToPurchase .. " lovely pieces of loot.")
  
  --purchase things
  yield("/target " .. CharacterGC .. " Quartermaster")
  yield("/wait 1")
  yield("/pinteract")
  yield("/wait 2") --long wait to make sure when we tell it to change tabs it actually does so
  
  --look at me, I added configurable options!
  if ItemToPurchase == 'Materiel4'
  then

    yield("/pcall GrandCompanyExchange true 2 1 0 0 0 0 0 0 0") --change tabs to Materiel
    yield("/wait 2") --this also seems to require a bit more of a wait than I expected, so I've extended this
    if CharacterGC == 'Flame' --the second portrait of Nanamo with Raubahn pushes everything else down one ID. this isn't even a joke. the Flames have one more item for sale and it's above the things I want
    then 
    
      yield("/pcall GrandCompanyExchange true 0 39 " .. CountToPurchase .. " 0 true false 0 0 0")
      
    else
    
      yield("/pcall GrandCompanyExchange true 0 38 " .. CountToPurchase .. " 0 true false 0 0 0") --second parameter is the item's position in the list, zero-indexed

    end

  elseif ItemToPurchase == 'Materiel3'
  then

    yield("/pcall GrandCompanyExchange true 2 1 0 0 0 0 0 0 0") --change tabs to Materiel
    yield("/wait 2")
    
    if CharacterGC == 'Flame' --Nanamo, my code could at least pretend to be elegant before you :(
    then 
      
      yield("/pcall GrandCompanyExchange true 0 38 " .. CountToPurchase .. " 0 true false 0 0 0") --one above the other one
    
    else
    
      yield("/pcall GrandCompanyExchange true 0 37 " .. CountToPurchase .. " 0 true false 0 0 0")
    
    end

  elseif ItemToPurchase == 'Cashmere'
  then
    
    yield("/pcall GrandCompanyExchange true 2 4 0 0 0 0 0 0 0") --change tabs to Materials
    yield("/wait 2")
	  
    if CharacterGC == 'Flame' --Nanamo strikes again
    then 
    
      yield("/pcall GrandCompanyExchange true 0 17 " .. CountToPurchase .. " 0 true false 0 0 0") --one above the other one
    
    else
    
      yield("/pcall GrandCompanyExchange true 0 16 " .. CountToPurchase .. " 0 true false 0 0 0")
    
    end

  else
    
    yield("/echo Item to Purchase is improperly configured. Please edit line 27. Also, you shouldn't have managed to ever see this message because there's an earlier one you failed to hit. Quitting, very confusedly...")
    yield("/snd stop")
  
  end
  
  --exit menu
  yield("/wait 2")
  yield("/pcall GrandCompanyExchange true -1")
  yield("/wait 2")
end	

--wrapper function for the functions defined above, in case there's ever anything new to add here like a GC selector, or support for resuming midway rather than always restarting from scratch
function SpendAllYourThings()
  --yield("/echo Debug: entering wrapper function...")
  GoToSabina()
  PurchaseItemsFromSabina() --now includes GoToNATIONGCNPC() inside this function
  TurnInGCItems()
  SpendGCSeals()
end

 --assumption: bolt supply lasts longest. it's the only one that definitely goes to 0, because you spend them 1 at a time rather than 2 or 4, so at least this won't loop forever
while BoltCount>0 do
  --yield("/echo Debug: Starting main loop.")
  SpendAllYourThings() --call wrapper function defined immediately above
end

if BoltCount == 0 then
  yield("/echo You have no Precision Gordian Bolts in your inventory. All done!")
  yield("/snd stop")
else
  yield("/echo Somehow, we managed to get into the quitting loop while we still had bolts left. This should not happen, go bother the developer.") --should never see this
end
--Motenten gearswap, flattened by me to just use to farm RP in Sheol Gaol with hp-10% debuff

--[[
    Custom commands:
    
    Ctrl-F8 : Cycle through available pet food options.
    Alt-F8 : Cycle through correlation modes for pet attacks.
]]

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
    ready_moves_to_check = S{'Sic','Purulent Ooze','Corrosive Ooze', --the three relevant ones
        'Whirl Claws','Dust Cloud','Foot Kick','Sheep Song','Sheep Charge','Lamb Chop','Sweeping Gouge',
        'Rage','Head Butt','Scream','Dream Flower','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang',
        'Roar','Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Venom','Geist Wall','Toxic Spit',
        'Numbing Noise','Nimble Snap','Cyclotail','Spoil','Rhino Guard','Rhino Attack','Power Attack',
        'Hi-Freq Field','Sandpit','Sandblast','Venom Spray','Mandibular Bite','Metallic Body','Bubble Shower',
        'Bubble Curtain','Scissor Guard','Big Scissors','Grapple','Spinning Top','Double Claw','Filamented Hold',
        'Frog Kick','Queasyshroom','Silence Gas','Numbshroom','Spore','Dark Spore','Shakeshroom','Blockhead',
        'Secretion','Fireball','Tail Blow','Plague Breath','Brain Crush','Infrasonics','1000 Needles',
        'Needleshot','Chaotic Eye','Blaster','Scythe Tail','Ripper Fang','Chomp Rush','Intimidate','Recoil Dive',
        'Water Wall','Snow Cloud','Wild Carrot','Sudden Lunge','Spiral Spin','Noisome Powder','Wing Slap',
        'Beak Lunge','Suction','Drainkiss','Acid Mist','TP Drainkiss','Back Heel','Jettatura','Choke Breath',
        'Fantod','Charged Whisker','Tortoise Stomp','Harden Shell','Aqua Breath','Zealous Snort','Pentapeck',
        'Sensilla Blades','Tegmina Buffet','Molting Plumage','Swooping Frenzy',
        }
end

function user_setup()

    --define aliases for gear
    gear.TaeonTabard = { name="Taeon Tabard", augments={'Accuracy+20 Attack+20','"Fast Cast"+5',}}
    gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}

    --define the parent node of ambu capes, then ambu cape
    gear.AmbuCape = {}
    gear.AmbuCape.PetMacc = {}
    

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Define sets and vars used by this job file.
function init_gear_sets()

    --------------------------------------
    -- Precast sets
    --------------------------------------

    --actually matters
    sets.precast.JA['Call Beast'] = {
        --head="Acro Helm", --can augment with 5 delay
        --body="Acro Tabard", --can augment with 5 delay
        hands="Ankusa Gloves +1", --"Call Beast +2"
        --legs="Acro Breeches", --can augment with 5 delay
        feet="Gleti's Boots", --"Summoned Pet: Lv.+1"
        }

    --one of these two also matters, but I do not know which
    sets.precast.JA['Ready'] = {
        main="Charmer's Merlin", --5 seconds cooldown
        legs="Gleti's Breeches", --5 seconds cooldown
        }
    
    sets.precast.JA['Purulent Ooze'] = sets.precast.JA['Ready']

    --don't matter
    sets.precast.JA['Reward'] = {}
    sets.precast.JA['Charm'] = {}
    sets.precast.WS = {} --hell yeah no WSes ever, get out

    --total FC is 30+6 quick
    --this is kinda lousy but hell, I ain't even summoning trusts...
    sets.precast.FC = {
        ammo="Impatiens", --0+2
        body=gear.TaeonTabard, --9
        hands=gear.LeylineGloves, --8
        left_ring="Weatherspoon Ring +1", --6+4
        neck="Baetyl Pendant", --4
        left_ear="Loquacious Earring", --2
        right_ear="Etiolation Earring", --1
        }

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    --not doing fancy crap here
    sets.midcast.FC = sets.precast.FC

    --The Pet Set(tm)
    sets.midcast.Pet.WS = {
        main="Pangu", --to save gil, could use Mdomo Axe +1, it is also pet 50 macc just like this, this has a big dt augment but I don't know if I actually care
        offhand="Agwu's Axe", --ongo clear+gil
        ammo="Hesperiidae", --dealan-dhe clear+gil
        head="Nyame Helm", --nyame 50 macc, same as gleti's, so give myself dt just in case it matters
        neck="Bst. Collar +2", --gil
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Gleti's Boots", --do I have to fulltime these for the pet level? no macc diff so let's do it
        left_ear="Enmerkar Earring",
        right_ear="Kyrene Earring", --20k gil on AH until I get the sortie BST earring
        left_ring="Tali'ah Ring", --ambu finger voucher
        right_ring="Cath Palug Ring",
        waist="Incarnation Sash",
        back=gear.AmbuCape.PetMacc,
        }

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    --idle set, which includes pet stats
    sets.idle = {
        main="Pangu", --same weapons as above
        offhand="Agwu's Axe", --couuld be Izizoeksi (plasm) for pet dt
        ammo="Hesperiidae",
        head="Twilight Helm", --auto-reraise set bonus (1/2) [could be crep lol]
        body="Twilight Mail", --auto-reraise set bonus (2/2)
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Gleti's Boots", --again, do I need this lol
        neck="Loricate Torque +1", --don't need pet dt here, do I? (Shepherd's Chain)
        left_ring="Chirich Ring +1", --no DT option for self OR pet here
        right_ring="Defending Ring",
        left_ear="Etiolation Earring", --or in ears, sigh
        right_ear="Eabani Earring", --will be sortie BST ear eventually
        waist="Plat. Mog. Belt", --or here (Isa Belt)
        back=gear.AmbuCape.PetMacc, --sure whatever
        }

    --------------------------------------
    -- Engaged sets
    --------------------------------------

    --lol whatever
    sets.engaged = sets.midcast.Pet.WS

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    -- Define class for Sic and Ready moves.
    if ready_moves_to_check:contains(spell.english) and pet.status == 'Engaged' then
        classes.CustomClass = "WS"
    end
end

--removed all custom modes and such. we'll see if it breaks.

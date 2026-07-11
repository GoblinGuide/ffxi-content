--Motenten gearswap, flattened by me to just use to farm RP in Sheol Gaol with hp-10% debuff

--only "real" set containing gear I own is the engaged set. everything else is totally fake because I do not care even a little.

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

    --this is kinda lousy but hell, I ain't even summoning trusts...
    sets.precast.FC = {
        --adhemar jacket?
        hands=gear.LeylineGloves,
        left_ring="Prolix Ring",
        neck="Orunmila's Torque",
        left_ear="Loquacious Earring",
        }

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    --not doing fancy crap here
    sets.midcast.FC = sets.precast.FC

    --The Pet Set(tm)
    sets.midcast.Pet.WS = {
        main="Agwu's Axe",
        --no dw in sheol
        ammo="Voluspa Tathlum",
        head="Nyame Helm", --nyame 50 pet macc, same as gleti's, so give myself dt just in case it matters
        neck="Bst. Collar +2", --gil
        body="Nyame Mail", --see above notes
        hands="Nyame Gauntlets", --see above notes
        legs="Nyame Flanchard", --see above notes
        feet="Gleti's Boots", --fulltime these for the pet level, same macc as nyame
        left_ear="Alabaster Earring", --tied for highest macc, but "Kyrene's Earring" if I care about actual pet stats at some point
        right_ear="Nukumi Earring +1", --pet level
        left_ring="Murky Ring", --highest macc
        right_ring="Varar Ring", --2 less than "Cath Palug Ring" but I didn't farm that
        waist="Incarnation Sash",
        back=gear.AmbuCape.PetMacc,
        }

    
    --idle set, which includes pet stats
    sets.idle = {
        main="Agwu's Axe",
        ammo="Hesperiidae",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Gleti's Boots", --keep pet level
        neck="Warder's Charm +1",
        left_ring="Shneddick Ring +1",
        right_ring="Murky Ring",
        left_ear="Alabaster Earring",
        right_ear="Nukumi Earring +1", --keep pet level
        waist="Carrier's Sash",
        back=gear.AmbuCape.PetMacc, --whatever
        }

    --lol whatever not bothering
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves", 
        legs="Malignance Tights",
        feet="Gleti's Boots", --pet level
        neck="Null Loop",
        left_ring="Varar Ring +1", --no DT option for pet here that I know of
        right_ring="Murky Ring",
        left_ear="Alabaster Earring", --or here that I know of
        right_ear="Nukumi Earring +1", --pet level
        waist="Reiki Yotai", --whatever
        back="Null Shawl",
    }

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

--removed all custom modes and such. we'll see if it breaks?
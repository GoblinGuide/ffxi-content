-- Original: Motenten / Modified: Arislan / gutted: me :)

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
        
    --also testing this	
    --include('CastStill.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['Sneak Attack'] or false
    state.Buff['Trick Attack'] = buffactive['Trick Attack'] or false
    state.Buff['Feint'] = buffactive['Feint'] or false
	
	no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",}

    include('Mote-TreasureHunter')

	--20230522 test putting this in job underscore setup, looks like it works just fine to toggle me into tag mode and then never have to sweat it
    --20240704 replaced "gs c treasuremode cycle" with "gs c set treasuremode Tag" to work the same way every time across multiple job changes in one session
	windower.send_command('gs c set treasuremode Tag')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    --20251110 adding "default to party chat mode" so that I don't say "r legion" in norg, instead putting it in empty party chat
    windower.send_command('input /cm p')

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    
    --combatform caused many complaints, I have no idea what I'm doing
    state.WeaponMode = M{['description']='Weapon Mode', 'Daggers', 'AeolianSet', 'Naegling'}
    
    --bind f10 to cycle
    send_command('bind F10 gs c cycle WeaponMode')

   --not sure about dt on these
    gear.AmbuCape = {} --if I don't specify one, I don't know which one I want, so leave it blank for sure
    gear.AmbuCape.Evisc = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Damage taken-5%',}} --good enough for now
    --gear.AmbuCape.TP = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Damage taken-5%',}} --lazy

    gear.HercHelmFC = { name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+6','"Mag.Atk.Bns."+12',}}
    
    --trying something new
    gear.AFHead = {name="Pillager's Bonnet"} --nope
    gear.AFBody = {name="Pillager's Vest +1"} --hide duration (eventually also crit damage, ta)
    gear.AFHands = {name="Pillager's Armlets"} --nope
    gear.AFLegs = {name="Pillager's Culottes"} --nope
    gear.AFFeet = {name="Pillager's Poulaines"} --flee duration (honestly, do I care?)

    gear.RelicHead = {name="Plunderer's Bonnet"} --nope
    gear.RelicBody = {name="Plunderer's Vest"} --crit hit rate/damage (evisceration set, if I ever make one)
    gear.RelicHands = {name="Plunderer's Armlets +1"} --th while I tag set test
    gear.RelicLegs = {name="Plunderer's Culottes"} --nope
    gear.RelicFeet = {name="Plunderer's Poulaines"} --triple attack + also TA damage (tping if I don't care about dt)
    
    gear.EmpyHead = {name="Skulker's Bonnet"} --5 TA, 7 PDL (up to 6/10) if I bother to reforge this
    gear.EmpyBody = {name="Skulker's Vest"} --nope
    gear.EmpyHands = {name="Skulker's Armlets"} --nope
    gear.EmpyLegs = {name="Skulker's Culottes"} --nope
    gear.EmpyFeet = {name="Skulker's Poulaines +1"} --TH+3 at +1, don't need higher with Volte Jupon

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--thief natively has 3, need +5 for 8 (this is not nearly how I want it long term but it IS capped)
    --due to hoxne -hp, trying out hp+ items with higher priority to try to mitigate losing HP during swaps
    sets.TreasureHunter = {
        --body="Volte Jupon", --2
        hands=gear.RelicHands, --3, overkilling it
        left_ring={name="Hoxne Ring", priority=1}, --2
        right_ring={name="Moonlight Ring", bag="wardrobe2", priority=2}, --110 HP, slot won't collide with engaged set
        feet=gear.EmpyFeet --3 (can reforge up to +5 but who cares, jupon's for every other job anyway)
    }

    --sets.buff['Sneak Attack'] = {hands="Raid. Armlets +1",
	--back=gear.AmbuCape.TP}
	--
    --sets.buff['Trick Attack'] = {hands=gear.AFHands,}
	--
    --actions to always use to flag TH
    --sets.precast.Step = sets.TreasureHunter
    --sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --sets.precast.JA['Collaborator'] = {head="Raid Bonnet +1",}
    --sets.precast.JA['Accomplice'] = {head="Raid Bonnet +1",}
    --sets.precast.JA['Conspirator'] = set_combine(sets.TreasureHunter, {body="Raider's Vest +1",})
    --sets.precast.JA['Feint'] = {}
    --sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    --sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

	sets.precast.JA['Flee'] = {feet=gear.AFFeet,} --turns out reforging this gives you one additional second per reforge
    sets.precast.JA['Hide'] = {body=gear.AFBody,}
	--sets.precast.JA['Perfect Dodge'] = {hands=gear.RelicHands,} --I don't actually care, +1 inventory
    
    --theoretically relevant for Impish Box?
    sets.precast.JA['Steal'] = {
        --ammo="Barathrum", --3 (warder of faith off euvhi in ru'aun island /2)
        --hands="Thief's Kote", --3 (tonberry NM in uggalepih, tako there)
        --legs=gear.AFLegs, --2 (reforge further will get 0 instead, be aware)
        --feet=gear.AFFeet, --3 (reforge further get 10, then 15)
        --neck="Pentalagus Charm", --2 (ah ~2m)
        --waist="Key Ring Belt", --1 (some godawful bastok quest)
        --head="Rogue's Bonnet", --1 (level 54 AF, loses it on any reforge, requires redoing the quest)
    }

	--FC cap is 80 but I'll never hit it
    sets.precast.FC = {
	head = gear.HercHelmFC, --13
	body="Adhemar Jacket +1", --10 (23)
	hands="Leyline Gloves", --5+2 --one point short of max
	neck="Orunmila's Torque", --5 (36)
    left_ear="Enchntr. Earring +1", --2 (38)
	right_ear="Loquac. Earring", --2 (40)
    left_ring="Kishar Ring", --4 (44)
	right_ring="Prolix Ring", --3 (47)
    }

    --do I even need to define base midcast to overwrite with TH? well, anyway, do that.
    sets.midcast = sets.precast.FC
    sets.midcast.TreasureHunter = set_combine(sets.precast.FC, sets.TreasureHunter)

    --explicitly minimize trust recast time for legioning purposes (do not use the level 99 8 fc legs!)
	sets.midcast['Trust'] = sets.precast.FC

    --in the SPECIFIC case I'm nuking for damage in abyssea or voidwatch or something, or also just to kill things with elements. overwriting stone1/stonega1 for TH tag purposes immediately below this.
    sets.midcast['Elemental Magic'] = {
        head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
	    waist="Orpheus's Sash", --lol
        --left_ear="Novio Earring", --or cremation or whatever
        right_ear="Friomisi Earring",
        left_ring="Dingir Ring", --lmao
        right_ring="Stikini Ring +1", --sure, it's not the right stats but it's fine
        }

    --tag with stone = want TH
    sets.midcast['Stone'] = set_combine(sets.midcast['Elemental Magic'], sets.midcast.TreasureHunter)
    sets.midcast['Stonega'] = sets.midcast['Stone']

	--mug steals 5% of dex/agi as HP, so maybe ever make a set
    sets.precast.JA['Mug'] = {}

    --Despoil drains TP but the items only buff the item-theft success rate. however, item theft also gives a -10% enfeeble (can be slow/def down?), so if I have the gear anyway this is free
    sets.precast.JA['Despoil'] = {
        --feet=gear.EmpyFeet,
    }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--generic fallback for undefined WSes
    sets.precast.WS = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
	    body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget", --whatever
	    waist="Sailfi Belt +1",
	    left_ear="Alabaster Earring",
        right_ear="Moonshade Earring",
        left_ring="Ilabrat Ring", --stats
        right_ring="Murky Ring", --"Cornelia's Ring",
	    back=gear.AmbuCape.Evisc, --crit on all WS apparently
    }

    --very lazy. mummu > gleti's apparently.
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,{
	    ammo="Yetshila", --+1 is 8m, don't care at all
        head="Blistering Sallet +1", --big number
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamashes +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Odr Earring",
	    right_ear="Moonshade Earring", --until "Sherida Earring"
        left_ring="Ilabrat Ring", --stats
        right_ring="Mummu Ring", --until "Regal Ring",
        back=gear.AmbuCape.Evisc, --this is what this cape's for
	})

    --naegling.
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    	ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail", 
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
        waist="Fotia Belt",
	    left_ear="Odr Earring",
        right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring",
        back=gear.AmbuCape.Evisc, --wrong main stat, ok for now
	    })


    --rudra's is 80 dex, physical, single hit, ftp doubles from 1k to 2k but then only 30% more at 3k, fix this when I make a twashtar, add tp logic too
	--sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS['Evisceration'], {}) --this is garbage for now, fix it

    --not using a set-combine for magical ws because while the Nyame overlaps I still like having this explicitly defined so I can read it
	--40 dex 40 int magical aoe
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
	    ammo="Coiste Bodhar", --osha treatise inventory etc
        head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
	    waist="Orpheus's Sash", --lol
        left_ear="Moonshade Earring",
        right_ear="Friomisi Earring",
        left_ring="Cornelia's Ring", --is regal better than this? pretty sure not?
        --right_ring="Dingir Ring", --lmao
        back=gear.AmbuCape.Evisc, --this does nothing but wsd but it's fine
        })

    --my god.
    sets.precast.WS['Burning Blade'] = sets.precast.WS['Aeolian Edge']

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	--thf has native 30 DW (25 in thf traits, 5 in jp bonus), with capped magic haste need 6 so reiki yotai handles
    --malig 31 dt, alabaster 5, moonlight 5 = 41 dt (will lose alabaster when sherida)
	sets.engaged = {
	    ammo="Coiste Bodhar",
        head="Malignance Chapeau", --gear.EmpyHead, --5 TA
        body="Malignance Tabard", --gear.AFBody, --7 TA
        hands="Malignance Gloves", --eventually gleti's with augments
        legs="Malignance Tights", --eventually gleti's with augments (has to get TA, it's a lot of rp)
        feet="Malignance Boots", --gear.RelicFeet, --5 TA, 11 TA dmg
        neck="Asn. Gorget +2", --good enough
        waist="Reiki Yotai", --7 dw
        left_ear="Alabaster Earring", --"Sherida Earring", --someday it'll drop
	    right_ear="Skulker's Earring +1", --maybe someday plus two?!
        left_ring={name="Moonlight Ring", bag="wardrobe1"}, --ffxiah pure tp set recommends Epona's to maximize TA, idk
        right_ring="Gere Ring", --5 TA
        back="Null Shawl", --good enough won't make a real thf tp cape
	}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Other Set --------------------------------------------
    ------------------------------------------------------------------------------------------------

	--ignoring DT, maximizing regain
    sets.idle = {
        ammo="Staunch Tathlum +1",
	    head="Gleti's Mask", --until "Null Masque"
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches", 
	    feet="Gleti's Boots",
	    neck="Warder's Charm +1", --element resist
	    waist="Carrier's Sash", --element resistance
        left_ear="Alabaster Earring", --5 dt
        right_ear="Hearty Earring", --status resist
        left_ring="Shneddick Ring +1", --movespeed
        right_ring="Murky Ring", --10 dt sorry "Shadow Ring"
	    back="Null Shawl", --meva
	}

    AfterZoneChangeFromWarpRing = sets.idle --testing: is it something about the name "idle"? seems not to be...

    --20260301 this is stupid but I added code to Fisher to equip this when I load that. so it's actually genius.
    --sets.Fishing = {
    --ranged={name="Ebisu Fishing Rod +1", priority=100},
    --body="Fisherman's Apron",
    --ring2="Noddy Ring", --fewer monsters
    --}


    ---------------------------------------------------------------------------
    -- STUPID GARBAGE FOR COMBAT MODES
    ---------------------------------------------------------------------------

    --https://github.com/Kinematics/GearSwap-Jobs/wiki/Sets has notes on CombatForm if I need them but I couldn't get that to work like I wanted
    sets.RealDaggers = {main="Tauret", sub="Gleti's Knife"} --"Crepuscular Knife" --testing swap
    sets.AeolianSet = {main="Tauret", sub="Naegling"}
    sets.Naegling = {main="Naegling", sub="Gleti's Knife"}

    --for gearswap
    sets.Legion = sets.RealDaggers
    
    --oops. init gear sets ends here.
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Aeolian Edge' then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
			end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

    --used for doom nicander's necklace etc, but I don't have that set up, so it's an active detriment without that
    --if buff == "doom" then
    --    if gain then
    --        equip(sets.buff.Doom)
    --        disable('neck')
    --    else
    --        enable('neck')
    --        handle_equipping_gear(player.status)
    --    end
    --end

    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if (category == 2) or --ranged attack
        (category == 4) or --spell
        (category == 3 and param == 30) or --Aeolian Edge
        (category == 3 and param == 38) or --Circle Blade
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

--at least one of the below are redundant
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
    check_weaponmode()
end

--but I don't know which
function job_state_change(stateField, newValue, oldValue)
    check_weaponmode()
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_weaponmode()
end

--might be this one
function customize_melee_set(meleeSet)
    check_weaponmode()

    return meleeSet
end

--they all just do this
function check_weaponmode()
   equip(sets[state.WeaponMode.current])
end

--11112025 trying to have legion no warp ring swap etc, seems to be working
function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.AfterZoneChangeFromWarpRing) --quick test to see if I can stop this changing my weapons after myhome uses warp ring
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.AfterZoneChangeFromWarpRing)
        end
    end
)

-- Original: Motenten / Modified: Arislan


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode: Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob 
--             SATA / Fulltime (lol)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
	
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
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.CombatForm = M{['description']='Engaged Gear Set', 'Legion', 'Sheol',} --this takes precedence over weaponset, which I use on corsair. trying to do what you're "supposed" to here
    send_command('bind F10 gs c cycle CombatForm')

    --define ambu capes
    gear.AmbuCape = {} --if I don't specify one, I don't know which one I want, so leave it blank for sure
    gear.AmbuCape.Evisc = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
    gear.AmbuCape.TP = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Damage taken-5%',}}
    
    --define herculean boots
    gear.HercBoots = {}
    gear.HercBoots.TH = { name="Herculean Boots", augments={'Pet: VIT+13','AGI+12','"Treasure Hunter"+2',}}
    gear.HercBoots.FC = { name="Herculean Boots", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+6','CHR+8',}}
    
    --only one of each of these
    gear.TaeonTabard = { name="Taeon Tabard", augments={'Accuracy+20 Attack+20','"Fast Cast"+5',}}
    gear.Moonshade = { name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}}
    gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}

    --trying something new
    gear.AFHead = {name="Pillager's Bonnet"} --nope
    gear.AFBody = {name="Pillager's Vest +3"} --hide duration, 6 crit damage, 7 ta
    gear.AFHands = {name="Pillager's Armlets"} --nope
    gear.AFLegs = {name="Pillager's Culottes +1"} --at +3, this is 5 ta, 5 crit damage (and right now it's +steal instead lmao, so I'm not actually using it)
    gear.AFFeet = {name="Pill. Poulaines +1"} --flee duration, 18 move speed
    gear.RelicHead = {name="Plunderer's Bonnet"} --nope
    gear.RelicBody = {name="Plunderer's Vest +3"} --crit hit rate/damage
    gear.RelicHands = {name="Plunderer's Armlets +1"} --nope (TH+3 and also a Perfect Dodge boost I don't care about vs one inventory slot)
    gear.RelicLegs = {name="Plunderer's Culottes"} --nope
    gear.RelicFeet = {name="Plunderer's Poulaines +3"} --triple attack + also TA damage
    gear.EmpyHead = {name="Skulker's Bonnet +2"} --5 TA, 7 PDL (up to 6/10)
    gear.EmpyBody = {name="Skulker's Vest"} --nope
    gear.EmpyHands = {name="Skulker's Armlets"} --nope
    gear.EmpyLegs = {name="Skulker's Culottes"} --nope
    gear.EmpyFeet = {name="Skulker's Poulaines +1"} --TH+3, don't need higher because I have Volte Jupon for other jobs anyway, it's just a DT and Despoil piece beyond that

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--thief natively has 3, need +5 for 8, this is 3+2
    sets.TreasureHunter = {
        --hands=gear.RelicHands, --3
        body="Volte Jupon", --2
        feet=gear.EmpyFeet --3 (can reforge further but will never save an inventory slot cause I use Jupon for other jobs)
    }

    --sets.buff['Sneak Attack'] = {hands="Raid. Armlets +1",
	--back=gear.AmbuCape.TP}
	--
    --sets.buff['Trick Attack'] = {hands=gear.AFHands,}
	--
    --actions to always use to flag TH
    --sets.precast.Step = sets.TreasureHunter
    --sets.precast.Flourish1 = sets.TreasureHunter
    --sets.precast.JA.Provoke = sets.TreasureHunter

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
    
    --steal sets are actually relevant in 2024 to steal the box from apex imps for the pudding fight to get Adamantite Armor (well, "relevant", I don't care about it now but it may be a sign of things to come...)
    sets.precast.JA['Steal'] = {
        --ammo="Barathrum", --3 (warder of faith off euvhi in ru'aun island 2)
        --hands="Thief's Kote", --3 (tonberry NM in uggalepih, tako there)
        --legs=gear.AFLegs, --2 (reforge further will get 0 instead, be aware)
        feet=gear.AFFeet, --3 (reforge further get 10, then 15)
        --neck="Pentalagus Charm", --2 (tails of woe II or 1m gil)
        --waist="Key Ring Belt", --1 (some godawful bastok quest)
        --head="Rogue's Bonnet", --1 (level 54 AF, loses it on any reforge, requires redoing the quest)
    }

	--FC is currently 51 + 2 occ quicken out of cap 80 + 10.
    sets.precast.FC = {
	ammo="Impatiens", --occ quicken 2 (0 + 2)
	head="Haruspex Hat", --8 (8 + 2)
	body=gear.TaeonTabard, --4+5 augment (17 + 2) adhemar +1 path D has 10 but inv
	hands=gear.LeylineGloves, --8 (5+3) (23 + 2)
	neck="Orunmila's Torque", --5 (28 + 2)
	legs="Enif Cosciales", --8 (36 + 2) --level 99 lol, lmao, this theoretically affects my trusts but I do not actually care cause legion is for haste not damage
	feet=gear.HercBoots.FC, --6 (42 + 2) --maxed aug
	left_ring="Prolix Ring", --2 (44 + 2)
	right_ring="Kishar Ring", --4 (48 + 2)
	left_ear="Loquac. Earring", --2 (50 + 2)
	right_ear="Etiolation Earring", --1 (51 + 2)
	--back could be a distinct ambu cape for 10 FC but that's currently DT on everything I use
	}

    --moving this here because I have zero other midcast sets
	sets.midcast.FastRecast = sets.precast.FC

    --in the SPECIFIC case I'm nuking for damage, use this
    --sets.midcast = {
    --head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
    --body="Nyame Mail",
    --hands="Nyame Gauntlets",
    --legs="Nyame Flanchard",
    --feet="Nyame Sollerets",
    --neck="Sibyl Scarf", --+10 int -3 mab vs "Baetyl Pendant",
	--waist="Orpheus's Sash", --lol
    --left_ear="Novio Earring",
    --right_ear="Friomisi Earring",
    --left_ring="Dingir Ring", --lmao
    --right_ring="Metamor. Ring +1", --lol
    --}
	
	--mug steals 5% of dex/agi as HP, so I made a set for it because you can get some insane heals
    sets.precast.JA['Mug'] = {
	--ammo="Coiste Bodhar", --could put like 3 dex in this slot but inv space
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Asn. Gorget +2", --dex augment haha
    --waist="Chaac Belt", --5 dex+5 agi, can probably do better but inv
    left_ear="Odr Earring", --10 dex
    right_ear="Sherida Earring", --5 dex
    left_ring="Ilabrat Ring", --10 dex 10 agi
	right_ring="Regal Ring", --10 dex 10 agi
    back=gear.AmbuCape.TP, --30 dex
    }

    --Despoil drains TP but the items only buff the item-theft success rate. however, item theft also gives a -10% enfeeble (can be slow, def down, and uh, garbage?), so if I have the gear anyway this is free
    sets.precast.JA['Despoil'] = {
    --ammo="Barathrum", --3 (warder of faith off euvhi in ru'aun island 2)
    --feet="Skulker's Poulaines +3", --8 enfeeble potency (theoretically I ever make this as a TH+5 piece when I can spare 80k galli)
    }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--have to define this to evisceration
    sets.precast.WS = {}

	--this is not optimal but I'm *very* unconvinced by ffxiah's arguments, so I'm gonna fly by the seat of my pants
	sets.precast.WS['Evisceration'] = {
	ammo="Yetshila +1", --2 crit, 6 crit damage
    head="Adhemar Bonnet +1", --5 crit damage, until empy +3 head "skulker's bonnet +3" (6 ta, 10 pdl, this actually doesn't seem better, apparently multihit procs are actually good?)
    body=gear.RelicBody, --6 crit, 5 crit damage, and some atk (vs pill vest 6 crit damage nothing else)
    hands="Mummu Wrists +2", --6 crit rate, confused why this isn't gleti's NQ, will def be gleti's when auged
    legs="Gleti's Breeches", --7 crit rate, until af +3 pants "Pillager's Culottes +3" (5 crit damage), until gleti's again at... R25?
    feet=gear.RelicFeet, --allegedly +600 average damage on 32k average evisc wtf, but gleti's will win eventually?
    neck="Fotia Gorget",
    waist="Fotia Belt",
	left_ear="Sherida Earring", --allegedly second best earring for evisc, period, which blows my mind
    right_ear="Odr Earring", --Moonshade is only 2.5% crit rate at 1k tp
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back=gear.AmbuCape.Evisc,
	}

    --suffice it to say that triple attack is really good on evisc because it has 5 chances to proc and produce up to 8 hits, but 8's the cap, so... uh... idk.

    --okay so here's the deal. if I don't have anything defined, it falls back to this. so if I'm using garbage like Gust Slash in Omen, let's make sure there's a set defined.
    sets.precast.WS = set_combine(sets.precast.WS['Evisceration'], {})

    --rudra's is 80 dex, physical, single hit, ftp doubles from 1k to 2k but then only 30% more at 3k
	--also I'm never going to use it because I don't have a real weapon
	--but if I one day do have a real weapon I'll want this set so let's not remove it
	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS['Evisceration'], { --sets.precast.WS, { --heh, don't actually use evisc set for rudras, but atm I want to be not WSing in TP set.
	--ammo="Yetshila +1",
    --head="Nyame Helm",
    --body="Skulker's Vest +3",
    --hands="Nyame Gauntlets",
    --legs="Nyame Flanchard",
    --feet="Nyame Sollerets",
    --neck="Asn. Gorget +2",
    --waist="Kentarch Belt +1",
    --left_ear="Odr Earring",
    --right_ear=gear.Moonshade,
    --left_ring="Regal Ring",
    --right_ring="Epamonidas's Ring",
    --back=gear.AmbuCape.Evisc,
	})

	--40 dex 40 int magical aoe
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
	ammo="Oshasha's Treatise", --meh, whatever, wardrobe 3
    head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf", --+10 int -3 mab vs "Baetyl Pendant",
	waist="Orpheus's Sash", --lol
    left_ear=gear.Moonshade,
    right_ear="Friomisi Earring",
    left_ring="Cornelia's Ring", --is regal better than this? pretty sure not?
    right_ring="Dingir Ring", --lmao
    back=gear.AmbuCape.Evisc, --it's got dex, shrug
	})

    --bumba want coin
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
	body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal", 
	waist="Sailfi Belt +1", --huh, thief's on this
	left_ear=gear.Moonshade, --tp bonus good
	right_ear="Odr Earring", --whatever, this is wrong, who cares
    left_ring="Defending Ring", --10 dt
    right_ring="Cornelia's Ring", --10 wsd
	back=gear.AmbuCape.Savage,back=gear.AmbuCape.Evisc, --this completely sucks but I am too lazy to change it
    })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	--thf has native 30 DW (25 in thf traits, 5 in jp bonus)
	--cap is 36 total with capped magical haste
    --currently 37 because reiki yotai > shetal stone

	--20230701 overnight test: while the bot has served me well, I want to see if it's time for triple attack swapsies, it appears that it is and it's not close
	--currently 32% TA, +41 TA damage (+6% from traits, +5% from merits, +8% from jp gifts, +20 atk from jp bonus, final total 51% / +41 + 20 are these the same term they don't read like it)
    sets.engaged = {
	main="Tauret",
    sub="Crepuscular Knife",
	ammo="Coiste Bodhar", --3 stp, 3 da cause it's free
    head=gear.EmpyHead, --5 TA
    body=gear.AFBody, --7 TA
    hands="Adhemar Wrist. +1", --4 ta, eventually gleti's with augments (70 atk, 20 str, 1 stp improvement once gleti's gets to 4 ta)
    legs="Malignance Tights", --10 stp, eventually gleti's with augments (has to get TA, it's a lot of rp)
    feet=gear.RelicFeet, --5 TA, 11 TA dmg
    neck="Asn. Gorget +2", --4 TA, 5 TA dmg (bot thinks perhaps iskur gorget)
    waist="Reiki Yotai", --7 dw
	right_ear="Skulker's Earring", --3 TA
	left_ear="Dedition Earring", --swapping out Sherida
    right_ring="Gere Ring", --5 TA
    left_ring="Hetairoi Ring", --2 TA, 5 TA dmg (bot thinks perhaps chirich ring, ffxiah pure tp set recommends Epona's of all things to maximize TA)
    back=gear.AmbuCape.TP, --10 stp
	}

    --per ffxiah, changes to this for the the "optimal" glass cannon don't-care-about-dt set is
    --gil: aurgelmir +1, gerdr belt +1
    --actual work: empy +3 head, maxed samnuha tights (lol, but I'm actually pretty close, but no cigar yet sigh)
    --gleti's: hands and legs but they need triple attack so it'll be a while
    --have: iskur gorget, af +3 body, dedition earring, epona's ring over gere
    --suspect I'd want to change most of these at once because it messes with my DW numbers and so on
	
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	--capped DT, loricate has def that null doesn't while null has hp which sucks for blood aggro
    sets.idle = { 
	main="Tauret",
    sub="Crepuscular Knife",
	ammo="Coiste Bodhar", --could be staunch tathlum if I buy it for a "real" job
	head="Nyame Helm", --7 dt (7)
    body="Malignance Tabard", --9 dt (16) (same dt/meva as nyame, more store tp for tp gain when getting hit, what an optimization)
    hands="Nyame Gauntlets", --7 dt (23) vs "Gleti's Gauntlets", --7 pdt, also +2 regain (inventory space)
    legs="Gleti's Breeches", --8 pdt (31+23) vs 8 dt on Nyame, but also 3 regain (3)
	feet="Nyame Sollerets", --7 dt (38+30)
	neck="Loricate Torque +1", --6 dt (44+36)
	left_ring="Shneddick Ring +1", --18 movespeed, this is the slot Warp Ring goes in when myhome uses it so DRing moved to other slot to keep dt while warping
	right_ring="Defending Ring", --10 dt (54+46)
	waist="Carrier's Sash", --elemental resistance
	right_ear="Odnowa Earring +1", --3 pdt, 5 mdt, def, 110 mp -> hp (51 mdt)
	left_ear="Eabani Earring", --evasion lmao
	back="Null Shawl", --meva and all that
	}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- More Granular Melee Sets-------------------------------
    ------------------------------------------------------------------------------------------------

    --https://github.com/Kinematics/GearSwap-Jobs/wiki/Sets has all the notes on how this works

    --to be backwards compatible with my current stuff. working on it.
    sets.engaged.Legion = set_combine(sets.engaged, {})

    --for segment farming. 1 pdt short of capped but honestly I'm not going to waste even a second worrying about that. could figure out evasion somewhere or something?
    sets.engaged.Sheol = {
        main="Tauret", --no clue if I actually want to define weapons here, as above
        sub="Crepuscular Knife",
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",--6 dt (6)
        body="Malignance Tabard", --9 dt (15)
        hands="Malignance Gloves", --5 dt (20)
        legs="Malignance Tights", --7 dt (27)
        feet="Malignance Boots", --4 dt (31)
        neck="Asn. Gorget +2",
        waist="Reiki Yotai",
        left_ear="Odnowa Earring +1", --3/5 dt (34/36)
        right_ear="Skulker's Earring",
        left_ring="Gere Ring",
        right_ring="Defending Ring", --10 dt (44/46)
        back=gear.AmbuCape.TP, --5 dt (49/51)
    }

    --for future V25 mercing, or anywhere else I'm expected to drop savage blades and not die
    sets.engaged.Naegling = set_combine(sets.engaged.Sheol, {
        main="Naegling",
        sub="Crepuscular Knife",
    })

    --for future abyssea farming, or Omen, or anywhere else I'm expected to drop aeolian edges and not die
    sets.engaged.Aeolian = set_combine(sets.engaged.Sheol, {
        main="Tauret",
        sub="Naegling", --someday we get another magic damage dagger that can compare, give it ten years
    })

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
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

--idk something about th
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end


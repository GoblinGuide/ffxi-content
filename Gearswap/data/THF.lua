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

    --20251110 adding "default to party chat mode" so that I don't say "r legion" in norg, instead putting it in empty party chat
    windower.send_command('input /cm p')

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.CombatForm = M{['description']='Engaged Gear Set', 'Legion', 'Real'} --this takes precedence over weaponset, which I use on corsair. trying to do what you're "supposed" to here
    send_command('bind F10 gs c cycle CombatForm')

    --define ambu capes
    gear.AmbuCape = {} --if I don't specify one, I don't know which one I want, so leave it blank for sure
    gear.AmbuCape.Evisc = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
    gear.AmbuCape.TP = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Damage taken-5%',}}

    --trying something new
    gear.AFHead = {name="Pillager's Bonnet"} --nope
    gear.AFBody = {name="Pillager's Vest +4"} --hide duration, 6 crit damage, 7 ta
    gear.AFHands = {name="Pillager's Armlets"} --nope
    gear.AFLegs = {name="Pillager's Culottes +1"} --unused, at +3, this is 5 ta / 5 crit damage (and right now it's +steal instead lmao) but it doesn't beat auged gleti's at +3 and doesn't beat r0 gleti's right now
    gear.AFFeet = {name="Pill. Poulaines +1"} --flee duration (honestly, do I care?!)
    gear.RelicHead = {name="Plunderer's Bonnet"} --nope
    gear.RelicBody = {name="Plunderer's Vest +3"} --crit hit rate/damage (evisceration set)
    gear.RelicHands = {name="Plunderer's Armlets +1"} --nope (TH+3 and also a Perfect Dodge boost I don't care about)
    gear.RelicLegs = {name="Plunderer's Culottes"} --nope
    gear.RelicFeet = {name="Plunderer's Poulaines +3"} --triple attack + also TA damage
    gear.EmpyHead = {name="Skulker's Bonnet +2"} --5 TA, 7 PDL (up to 6/10)
    gear.EmpyBody = {name="Skulker's Vest"} --nope
    gear.EmpyHands = {name="Skulker's Armlets"} --nope
    gear.EmpyLegs = {name="Skulker's Culottes"} --nope
    gear.EmpyFeet = {name="Skulker's Poulaines +1"} --TH+3, don't need higher with Volte Jupon, it's just a DT and Despoil piece beyond that (can't lose this when have Hoxne, that's only 2+2, so use this over Hoxne for no -HP)

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--thief natively has 3, need +5 for 8, this is 3+2 (Hoxne Ring + 1 other can replace Empy Feet)
    sets.TreasureHunter = {
        body="Volte Jupon", --2
        feet=gear.EmpyFeet --3 (can reforge up to +5 but who cares, jupon's for every other job)
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
    
    --steal set's theoretically relevant for Impish Box?
    sets.precast.JA['Steal'] = {
        --ammo="Barathrum", --3 (warder of faith off euvhi in ru'aun island 2)
        --hands="Thief's Kote", --3 (tonberry NM in uggalepih, tako there)
        --legs=gear.AFLegs, --2 (reforge further will get 0 instead, be aware)
        feet=gear.AFFeet, --3 (reforge further get 10, then 15)
        --neck="Pentalagus Charm", --2 (ah ~2m)
        --waist="Key Ring Belt", --1 (some godawful bastok quest)
        --head="Rogue's Bonnet", --1 (level 54 AF, loses it on any reforge, requires redoing the quest)
    }

	--FC is 45, cap is 80
    sets.precast.FC = {
	head="Herculean Helm", --7+6 (13) --using on cor
	body="Adhemar Jacket +1", --10 (23) --using on cor
	hands="Leyline Gloves", --5+3 (31) --using on everyone
	neck="Orunmila's Torque", --5 (36) --using on everyone
	--legs="Enif Cosciales", --8 --not ilevel but it is bis (gyve trousers exist, but inventory)
	--feet=gear.HercBoots.FC, --6 --maxed aug, inventory
    --left_ear="Etiolation Earring", --1, inventory
	right_ear="Loquac. Earring", --2 (38)
	left_ring="Prolix Ring", --3 (41)
	right_ring="Kishar Ring", --4 (45)
    --back could be a distinct ambu cape for 10 FC but that's currently DT on all my ambu capes, weird slot to share
	}

    --moving this here because I have zero other midcast sets (could care about utsu or something at some point? idk)
	sets.midcast.FastRecast = sets.precast.FC

    --in the SPECIFIC case I'm nuking for damage in abyssea or voidwatch or some shit, uncomment this I guess
    --sets.midcast = {
    --head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
    --body="Nyame Mail",
    --hands="Nyame Gauntlets",
    --legs="Nyame Flanchard",
    --feet="Nyame Sollerets",
    --neck="Sibyl Scarf",
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
    waist="Chaac Belt", --5 dex+5 agi, actually have this for treasure hunter
    left_ear="Sherida Earring", --5 dex --this is left ear because it's left in engaged slot etc because of empy ear
    right_ear="Odr Earring", --10 dex
    left_ring="Ilabrat Ring", --10 dex 10 agi
	right_ring="Regal Ring", --10 dex 10 agi
    back=gear.AmbuCape.TP, --30 dex
    }

    --Despoil drains TP but the items only buff the item-theft success rate. however, item theft also gives a -10% enfeeble (can be slow, def down, and uh, garbage?), so if I have the gear anyway this is free
    sets.precast.JA['Despoil'] = {
    --ammo="Barathrum", --3 (warder of faith off euvhi in ru'aun island 2)
    --feet="Skulker's Poulaines +3", --8 enfeeble potency (theoretically I ever make this, in practice, galli)
    }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--this is a savage blade set (wsd, str, no fotia) as fallback for undefined WSes
    sets.precast.WS = {
        ammo="Coiste Bodhar", --inventory lol, could be osha treatise for 3 wsd
        head="Nyame Helm",
	    body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal", 
	    waist="Sailfi Belt +1", --huh, thief's on this?
	    left_ear="Sherida Earring", --DA (not putting DT here because I'm testing it for Legion)
        right_ear="Moonshade Earring", --tp bonus good
        left_ring="Regal Ring", --stats (not putting DT here because I'm testing it for Legion
        right_ring="Cornelia's Ring", --10 wsd
	    back=gear.AmbuCape.Evisc, --this completely sucks but I am too lazy to make another cape
    }

    --didn't like this for legion use, but still need it for stupid things like mercing bumba v20
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {})

    --this is not optimal but I'm *very* unconvinced by ffxiah's arguments, so I'm gonna fly by the seat of my pants
    --triple attack is good on evisc because it has 5 chances to proc and produce up to 8 hits, but 8's the cap, so don't go overboard
	sets.precast.WS['Evisceration'] = {
	ammo="Yetshila +1", --2 crit, 6 crit damage
    head="Adhemar Bonnet +1", --5 crit damage, until empy +3 head "skulker's bonnet +3" (6 ta, 10 pdl, apparently TA is better here?)
    body=gear.RelicBody, --6 crit, 5 crit damage, and some atk (vs pill vest 6 crit damage nothing else)
    hands="Mummu Wrists +2", --6 crit rate, confused why this isn't gleti's NQ, will def be gleti's when auged
    legs="Gleti's Breeches", --7 crit rate, until af +3 pants "Pillager's Culottes +3" (5 crit damage), until gleti's again at... R25?
    feet=gear.RelicFeet, --allegedly +600 average damage on 32k average evisc, but gleti's will win eventually?
    neck="Fotia Gorget", --good for evisc
    waist="Fotia Belt", --good for evisc
	left_ear="Sherida Earring", --allegedly second best earring for evisc, period, which blows my mind, Moonshade is only 2.5% crit rate at 1k tp so put actual damage ear here
    right_ear="Odr Earring", --this is obviously the stone best here
    left_ring="Ilabrat Ring", --stats
    right_ring="Regal Ring", --stats
    back=gear.AmbuCape.Evisc,
	}

    --rudra's is 80 dex, physical, single hit, ftp doubles from 1k to 2k but then only 30% more at 3k
	--also I have to care if I make a twashtar
	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS['Evisceration'], {}) --this is garbage for now

    --not using a set-combine for magical ws because while the Nyame overlaps I still like having this explicitly defined so I can read it
	--40 dex 40 int magical aoe
    sets.precast.WS['Aeolian Edge'] = {
	ammo="Coiste Bodhar", --osha treatise inventory etc
    head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget", --per my stupid research, I think this is better than Sibyl Scarf's 10 INT 10 MAB
	waist="Orpheus's Sash", --lol
    left_ear="Friomisi Earring",
    right_ear="Moonshade Earring",
    left_ring="Cornelia's Ring", --is regal better than this? pretty sure not?
    right_ring="Dingir Ring", --lmao
    back=gear.AmbuCape.Evisc, --it's got dex, shrug
    }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
    --this is the glass-cannon Legion Engaged Set, we will give it a proper name below
	--thf has native 30 DW (25 in thf traits, 5 in jp bonus). cap is 36 total with capped magical haste. currently at 37 because reiki yotai is way better than shetal stone (gerdr belt +1 exists, 55m, +4 dw)
	--32% TA, +41 TA damage (+6% from traits, +5% from merits, +8% from jp gifts, +20 atk from jp bonus, final total 51% / +41 + 20 are these the same term they don't read like it)
    sets.engaged = {
	ammo="Coiste Bodhar", --3 stp, 3 da cause it's free
    head=gear.EmpyHead, --5 TA
    body=gear.AFBody, --7 TA
    hands="Adhemar Wrist. +1", --4 ta, eventually gleti's with augments (70 atk, 20 str, 1 stp improvement but you lose TA)
    legs="Malignance Tights", --10 stp, eventually gleti's with augments (has to get TA, it's a lot of rp)
    feet=gear.RelicFeet, --5 TA, 11 TA dmg
    neck="Asn. Gorget +2", --4 TA, 5 TA dmg (bot thinks perhaps iskur gorget)
    waist="Reiki Yotai", --7 dw
    left_ear="Sherida Earring", --could Dedition but +1 inv slot this way and frankly even if the DA doesn't matter much (only procs on not-TA) the -atk is not super desirable when white thf damage does technically matter
	right_ear="Skulker's Earring", --3 TA (right ear only etc)
    left_ring="Hetairoi Ring", --2 TA, 5 TA dmg (bot thinks perhaps chirich ring, ffxiah pure tp set recommends Epona's of all things to maximize TA)
    right_ring="Gere Ring", --5 TA
    back=gear.AmbuCape.TP, --10 stp and some dt (so I think this is better than null shawl?)
	}

    --per ffxiah, changes to this for the the "optimal" glass cannon don't-care-about-dt set is
    --gil: aurgelmir +1, gerdr belt +1
    --actual work: empy +3 head, gleti's hands, gleti's legs
    --have: iskur gorget, epona's ring over hetairoi
    --suspect I'd want to change most of these at once because it messes with my DW numbers and so on
	
    --https://github.com/Kinematics/GearSwap-Jobs/wiki/Sets has all the notes on how this works

    --combatmode does this, not sets.Legion or anything, that's like weaponmode
    --was trying out naegling but no thanks at the moment
    sets.engaged.Legion = set_combine(sets.engaged, {main="Tauret", sub="Crepuscular Knife"})

    --for anything from segment farming and omen to gaol mercing and possibly someday beyond. dt capped.
    sets.engaged.Real = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",--6 dt (6)
        body="Malignance Tabard", --9 dt (15)
        hands="Malignance Gloves", --5 dt (20)
        legs="Malignance Tights", --7 dt (27)
        feet="Malignance Boots", --4 dt (31)
        neck="Asn. Gorget +2", --no idea if this is actually optimal. is iskur gorget better?
        waist="Reiki Yotai", --one source of dual wield because thf needs 6 with capped magic haste
        left_ear="Alabaster Earring", --5 dt (36)
        right_ear="Skulker's Earring",
        left_ring="Gere Ring",
        right_ring="Murky Ring", --10 dt (46)
        back=gear.AmbuCape.TP, --5 dt (51)
    }

    --also hardcoded weapons on the "real" engaged set
    sets.engaged.Real = set_combine(sets.engaged.Real, {main="Tauret", sub="Crepuscular Knife"})

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	--DT: 59/51 overcap, also 5 regain currently
    --once gleti hands are auged, put those in over nyame and use null loop in neck + ambu cape for 10 mdt to replace that 7 if I want more regain
    sets.idle = { 
    --oops. no weapons specified here, that's only changed by engaged sets.
	ammo="Staunch Tathlum +1", --3 dt (this is ok, I don't use a ranged weapon on anything)
	head="Null Masque", --10 dt (13) and 2 regain
    body="Malignance Tabard", --9 dt (22) (same dt/meva as nyame but more store tp for tp gain when getting hit, what an optimization) (also doesn't make me look as stupid)
    hands="Nyame Gauntlets", --7 dt (29) --"Gleti's Gauntlets", --7 pdt, also +2 regain (once aug'd)
    legs="Gleti's Breeches", --8 pdt (37+29) --8 dt on Nyame, but this has 3 regain
	feet="Nyame Sollerets", --7 dt (44+36)
	neck="Warder's Charm +1", --elemental resistance
	waist="Carrier's Sash", --elemental resistance
    left_ear="Alabaster Earring", --5 dt (49+41)
    right_ear="Eabani Earring", --evasion lmao (second ear is still the worst idle slot in existence)
    left_ring="Shneddick Ring +1", --18 movespeed, this is the slot Warp Ring goes in when myhome uses it to keep dt while warping
	right_ring="Murky Ring", --10 dt (59+51)
	back="Null Shawl", --meva, no need for cape dt for now
	}

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

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
end


--11112025 let's try to have legion no warp ring swap etc
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
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

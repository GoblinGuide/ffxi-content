--todo: replace weaponmode with combatform
--also make a tp ambu cape with 10 PDT to swap for murky from my engaged set!

-- Original: Motenten / Modified: Arislan / gutted: me :)

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
    elemental_ws = S{"Aeolian Edge", "Leaden Salute", "Wildfire"}
    
    include('Mote-TreasureHunter')
    
    --202407904 replaced "gs c treasuremode cycle" with "gs c set treasuremode Tag"
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

    state.WeaponMode = M{['description']='Weapon Set', 'Naegling', 'Daggers', 'DP_Melee', 'DP_Ranged','Fomalhaut_Melee'}
    --currently unused: 'Fomalhaut_Ranged', 'AeolianSet',
	send_command('bind F10 gs c cycle WeaponMode')

    gear.RAbullet = "Chrono Bullet"
    gear.RAccbullet = "Chrono Bullet"
    gear.PhysWSbullet = "Chrono Bullet"
    gear.MagicWSbullet = "Living Bullet"
    gear.QDbullet = "Living Bullet"

	gear.AmbuCape = {}
    gear.AmbuCape.Savage = {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
    gear.AmbuCape.MagicWS = { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%'}}
	gear.AmbuCape.Snapshot = { name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10', 'Mag. Evasion+15'}}

    --only one pair of leyline gloves so I didn't bother exporting them, especially since they're not a +3 yet
    gear.HercHelmFC = {name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+6','"Mag.Atk.Bns."+12',}}
    
    --stopgap until Volte Jupon takes same inventory slot
    gear.HercBootsTH = {name="Herculean Boots", augments={'Enmity-2','"Mag.Atk.Bns."+6','"Treasure Hunter"+2',}}
    
    --all 5 AF unused forever rip
    gear.AFHead = {name="Laksamana's Tricorne +1"} --additive bonus to quick draw damage, also provides macc, maybe I do want this but I'm skeptical, because inventory is too precious
    gear.AFBody = {name="Laksamana's Frac +1"} --20 rapid shot, max 12 wsd/no dt
    gear.AFHands = {name="Laksamana's Gants +1"}
    gear.AFLegs = {name="Laksamana's Trews +1"}
    gear.AFFeet = {name="Laksamana's Bottes +1"} --QD damage, worse than both same-element buff on empy feet and MAB on relic feet
    
    --relic reforging finished
    gear.RelicHead = {name="Lanun Tricorne +1"} --30 sec duration, 50% to give roll job bonus when job not in party (the good rolls are the jobs we don't have)
    gear.RelicBody = {name="Lanun Frac +1"} --50% for random deal to work on two things (worth imo) - could be LS body with 64 MAB / 6 PDT / 0 WSD but awkward
    gear.RelicHands = {name="Lanun Gants +4"} --13 snapshot, triple shot occasionally becomes quad shot (also fold two busts chance, free real estate)
    gear.RelicLegs = {name="Lanun Trews +1"} --unused, 4% per merit for Snake Eye 0 recast
    gear.RelicFeet = {name="Lanun Bottes +4"} --12 wsd 6 pdt 58 mab 71 ratk + changes wild card odds in your favor (but 0 atk lol so ONLY LS)

    --take all five empy to +3
    gear.EmpyHead = {name="Chasseur's Tricorne +2"} --16 rapid shot, 9 dt (up to 18/10)
    gear.EmpyBody = {name="Chasseur's Frac +2"} --10 tp regain on tactician's roll, +13% triple shot procs if equipped, 12 dt (up to 13 dt, 14 triple shot)
    gear.EmpyHands = {name="Chasseur's Gants +2"} --roll duration (crit, wsd, no dt, I guess also for evisc?)
    gear.EmpyLegs = {name="Chasseur's Culottes +2"} --11 dt (12 at +3 and also better tp stats)
    gear.EmpyFeet = {name="Chasseur's Bottes +2"} --QD same-element subsequent-damage buff

end

--sets and vars used by this job file
function init_gear_sets()

    --TH 2+2, replace when have Jupon
	sets.TreasureHunter = {
        feet=gear.HercBootsTH,
        left_ring="Hoxne Ring",
		--body="Volte Jupon", --2
		}

    --define weapon modes, cycles with F10 see above
	sets.Naegling = {main="Naegling", sub="Crepuscular Knife", ranged="Ataktos"} --default: Naegling set w/TP bonus gun
    sets.Daggers = {main="Tauret", sub="Crepuscular Knife", ranged="Ataktos"} --for evisc in Sheol
    sets.Fomalhaut_Melee = {main="Rostam", sub="Tauret", ranged="Fomalhaut"} --second rostam has 50 macc, but that's not worth the gil and an inventory slot
    sets.DP_Melee = {main="Tauret", sub="Naegling", ranged="Death Penalty"} --sacrifices 10 macc for 16 mab and +magic damage
    sets.DP_Ranged = {main="Rostam", sub="Tauret", ranged="Death Penalty"} --rostam has racc/macc so this is superior if I'm actively not meleeing at all because then I need all the racc I can get
    
    --sets.Fomalhaut_Ranged = {main="Rostam", sub="Tauret", ranged="Fomalhaut"}
    --sets.AeolianSet = {main="Tauret", sub="Naegling", ranged="Ataktos"} --tauret and naegling have +magic damage and MAB, rostam only has +magic damage

    --automatically equipped when not capable of dual wielding, see logic in function below
    sets.DefaultShield = {sub="Nusku Shield"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Snake Eye'] = {} --{legs=gear.RelicLegs,} --12% chance of 0 recast (4% per merit), inventory
    sets.precast.JA['Wild Card'] = {feet=gear.RelicFeet,} --changes odds from uniform 1/6 to 2/16 2/16 3/16 3/16 3/16 3/16
    sets.precast.JA['Random Deal'] = {body=gear.RelicBody,} --50% to reset two abilities instead of one

	--41 pdt 31 mdt - could use... plat mog belt, or something? or sacrifice the recast for empy
    sets.precast.CorsairRoll = {
		main="Rostam", --roll +8
		ranged="Compensator", --roll duration +20
        head=gear.RelicHead, --duration +30 and roll effect up (50% to give job bonus if job not in party, drk/sam/rng rolls are all great, lol)
        body="Nyame Mail", --9 dt (9 dt)
        hands=gear.EmpyHands, --55 duration
        legs="Desultor Tassets", --minus 5 seconds recast (comparatively squishy but I love recast down)
        feet="Nyame Sollerets", --7 dt (16 dt)
        neck="Regal Necklace", --20 duration
		waist="Carrier's Sash", --no blood aggro from plat mog belt, this is fine, whatever
        left_ear="Alabaster Earring", --5 dt (21 dt)
        --right_ear="Etiolation Earring", --3 mdt, inventory, also I don't care
        left_ring="Luzaf's Ring", --roll aoe up (8' -> 16')
        right_ring="Murky Ring", --10 dt (31 dt)
        back=gear.AmbuCape.Snapshot, --this is the one with meva on it
        }

    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body=gear.EmpyBody,}) --tp regain, actually useful
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands=gear.EmpyHands,}) --skillchain damage, but I have these for the duration bonus in this slot anyway so I might as well explicitly define
    sets.precast.FoldDoubleBust = {hands=gear.RelicHands,} --lets me fold two busts at once, which hopefully will never happen. but I use this for other stuff anyway

	--FC is 44, cap is 80. I don't really care.
    sets.precast.FC = {
		head=gear.HercHelmFC, --7+6 (13) --keeping this single item 
        body="Adhemar Jacket +1", --10 (23) (lol)
        hands="Leyline Gloves", --7 --needs to be 8 sadly
        --legs="Gyve Trousers", --4, gear.Herclegs.FC is 6, Enif Cosciales is 8 but not ilevel, inventory
        --feet=gear.HercBoots.FC, --6 aug, inventory
        neck="Orunmila's Torque", --5 (36)
        left_ear="Loquacious Earring", --2 (38)
        --right_ear="Etiolation Earring", --1, inventory
        left_ring="Prolix Ring", --2 (42)
        right_ring="Kishar Ring", --4 (44)
        }
		
    --snapshot cap is 60 (+10 from gifts, 70 is the real cap), rapid shot cap does not seem to exist (it's like quick cast, but good instead of bad)
	--currently 60 + 27 (ikenga's boots is 5, relic hands +4 is 13, can't free up another slot here)
    sets.precast.RA = {
        head=gear.EmpyHead, --0+16 --more at +3?
        body="Oshosi Vest +1", --14+0
        hands=gear.RelicHands, --9+0 (9/11/13/13 at +1/2/3/4)
        legs="Adhemar Kecks +1", --10+13
        feet="Meg. Jam. +2", --10+0 --if I can replace this it's +1 inv slot, but I do not think there's a way to do this even with ikenga's boots
        neck="Comm. Charm +2", --4+0
		waist="Yemaya Belt", --0+5
        --left_ring="Crepuscular Ring", --3+0
        --back=gear.AmbuCape.Snapshot, --10+0
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    --all WS sets have as close to 50 DT as I could get because I got sick of dying
    --relevant numbers: Nyame is 7 9 7 8 7 = 38, murky ring plus either alabaster earring or dt ambu cape is capped
    --putting in relic feet instead is 37 pdt so that changes nothing, 32 mdt requiring shell but that's fine

	--base ws set for irrelevant ws
    sets.precast.WS = {
        ammo=gear.PhysWSbullet, --assume physical by default
        head="Nyame Helm",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet=gear.RelicFeet, --6 pdt 12 wsd vs nyame 7 dt 11 wsd 5 da at cap (and mine's not capped)
        waist="Fotia Belt",
        neck="Fotia Gorget",
        left_ear="Alabaster Earring", --default to dt cap
        right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring",
        back=gear.AmbuCape.Savage,
        }

	--non-dark-elemental magic WS set
    --wildfire specifically is your agi minus your-enemy... dint, lmao
    sets.precast.WS['Wildfire'] = set_combine(sets.precast.WS, {
        ammo=gear.MagicWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet=gear.RelicFeet, --MAB!
        neck="Comm. Charm +2",
		waist="Orpheus's Sash", --"Skrymir Cord +1", --not buying
        left_ear="Friomisi Earring",
        right_ear="Hoxne Earring",
        left_ring="Cornelia's Ring",
        right_ring="Dingir Ring",
        back=gear.AmbuCape.MagicWS,
        })

	--other magic WS that aren't LS
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {
        ammo=gear.MagicWSbullet, --this isn't actually changed, but I'm specifying it again here
        right_ear="Moonshade Earring", --tp actually matters here
        })

    --hot shot has good ftp scaling from moonshade
    sets.precast.WS['Hot Shot'] = {
        ammo=gear.MagicWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet=gear.RelicFeet, --MAB!
        neck="Fotia Gorget",
		waist="Fotia Belt", --apparently beats the sash?!
        left_ear="Friomisi Earring", --mab, this is hybrid
        right_ear="Hoxne Earring",
        left_ring="Cornelia's Ring",
        right_ring="Dingir Ring",
        back=gear.AmbuCape.MagicWS,
    }

    --DT is 9+7+8 from 3/5 Nyame (24), 6+10 PDT from relic feet+ambu cape (40+34 and Shell V caps me on magic)
    sets.precast.WS['Leaden Salute'] = {
        ammo=gear.MagicWSbullet,
        head="Pixie Hairpin +1", --minus 7 dt from nyame head, plus 28 dark affinity (nearly two osash!)
		body="Nyame Mail", --DT, allegedly gear.RelicBody 34 more MAB is actually superior even with no WSD, don't care, only has 6 pdt
        hands="Nyame Gauntlets", --DT
        legs="Nyame Flanchard", --DT
        feet=gear.RelicFeet, --6 pdt
        neck="Comm. Charm +2",
		waist="Orpheus's Sash", --skrymir +1 I guess
        left_ear="Friomisi Earring", --MAB
        right_ear="Moonshade Earring",
        left_ring="Archon Ring", --I have no idea why they say regal might be even with this? pretty sure stats do not work that way?
        right_ring="Dingir Ring",
        back=gear.AmbuCape.MagicWS, --10 pdt
        }

    --we love it
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo=gear.PhysWSbullet,
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal", 
        waist="Sailfi Belt +1",
        left_ear="Hoxne Earring", --ignoring Alabaster DT for now, I guess
	    right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring", --regal might be better?
        back=gear.AmbuCape.Savage,
	    })

    --fomalhaut WS. 85% agi modifier, physical, ftp good
    sets.precast.WS['Last Stand'] = {
        ammo=gear.PhysWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands=gear.EmpyHands, --better than "Nyame Gauntlets", --per the simulations, and more macc too
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Comm. Charm +2", --over fotia apparently
		waist="Fotia Belt",
        left_ear="Hoxne Earring", --ignoring Alabaster DT for now, I guess
        right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring",
        right_ring="Dingir Ring",
        back=gear.AmbuCape.Savage, --until gear.AmbuCape.PhysWS if one such beast exists
        }

	--really, who cares? mnd modifier that I will never use
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        left_ear="Hoxne Earring", --ignoring Alabaster DT for now, I guess
        right_ear="Moonshade Earring",
        })

	--for sheol 
    sets.precast.WS['Evisceration'] = {
		ammo=gear.PhysWSbullet, --evisceration physical
        head="Blistering Sallet +1", 
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
        back=gear.AmbuCape.Savage, --not making crit cape lol maybe gear.AmbuCape.PhysWS
		}

    --rarely used, still gear for
    sets.precast.WS['Aeolian Edge'] = {
        ammo=gear.MagicWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet=gear.RelicFeet,
        neck="Comm. Charm +2",
		waist="Orpheus's Sash", --skrymir +1?
        left_ear="Friomisi Earring", --MAB
        right_ear="Moonshade Earring",
        left_ring="Archon Ring", --"Regal Ring" when I have it
        right_ring="Dingir Ring",
        back=gear.AmbuCape.MagicWS,
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    
    --default to idle set for precast to not die
    sets.midcast = sets.idle

    --for trusts, use the FC set for shorter recasts
    sets.midcast['Trust'] = set_combine(sets.idle, sets.precast.FC)

    --no reason not to define this, honestly
    --black magic didn't work, testing
    sets.midcast['Elemental Magic'] =  {
        ammo=gear.MagicWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet=gear.RelicFeet,
        neck="Comm. Charm +2",
		waist="Orpheus's Sash", --it's fine
        left_ear="Friomisi Earring", --MAB
        right_ear="Telos Earring", --10 macc lol
        left_ring="Stikini Ring +1", --"Regal Ring" when I have it, I only have one stikini now
        right_ring="Dingir Ring",
        back=gear.AmbuCape.MagicWS,
        }

    -- Ranged gear, store tp mostly
    --malignance set is 6 9 5 7 4 = 31 DT. empy legs is +4 over tights plus murky + alabaster = 50 exactly
    --todo: make ranged cape?
    sets.midcast.RA = {
        ammo=gear.RAbullet, --ranged attack bullet duh
        head="Malignance Chapeau", --until augmented --"Ikenga's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs=gear.EmpyLegs, --until augmented --"Ikenga's Trousers",
        feet="Malignance Boots",
        neck="Iskur Gorget", --stp
        left_ear="Telos Earring", --no need for enervating/crep here, but I guess I could crep
        right_ear="Alabaster Earring", --5 dt, eventually augments make this actually best too (lol)
        left_ring="Mummu Ring", --6 racc lmao until "Crepuscular Ring",
        right_ring="Murky Ring", --10 dt
        waist="Yemaya Belt", --stp, racc, ratk
		back="Null Shawl", --oh god the base cor cape has 5 triple shot yes I need a ranged cape even if it's leaden salute
        }

    --base 60% triple shot activation rate after job point bonuses, so 40 is max in gear and I don't even think that much exists.
    --this set is 13+5+5 = 23 to take to 83% activation total
    --loses 6 dt from head, 5 dt from hands, gains 3 dt on empy body vs malig = 41 dt total (todo: like I said above, if I had an inventory slot for a proper RA cape, put PDT on it and this would cap then...?)
    sets.TripleShot = {
        head="Oshosi Mask +1", --5%, Triple Shot damage +13 (this is a percentage)
        body=gear.EmpyBody, --13% (becomes 14% at +3)
        hands=gear.RelicHands, --occ. becomes Quad Shot (good)
        back=gear.AmbuCape.Snapshot, --5 triple shot, is this right?
        }

    --just one set - element-buffing Bottes and near-cap MDT (element buff only works for Leaden Salute if the Dispel from Dark Shot actually dispels a thing, sigh)
    --QD is MAGIC accuracy. not ranged. don't forget that. (actively slamming more magic accuracy in this single set)
	--recast hardcap is 35 seconds = 60 base, -10 category 1 merits, -10 from JP gift, -5 from Mirke Wardecors or tatter and scrap synergy
    --DT capped if I don't use Mirke Wardecors
    sets.QuickDraw = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau", --6 dt (6)
        body="Malignance Tabard", --"Mirke Wardecors", --recast -5 but I hate missing so much I want the macc
        hands="Malignance Gloves", --5 dt (11)
        legs=gear.EmpyLegs, --11 dt (22)
        feet=gear.EmpyFeet, --25% more damage on next hit of this element within 10 seconds (more damage from lanun MAB, but this is for LS)
        neck="Null Loop", --5 dt (27) but also 50 macc
        waist="Orpheus's Sash", --until "Skrymir Cord +1", --7 macc, if I buy it for another reason, which I won't
	    left_ear="Alabaster Earring", --5 dt (33) "Dedition Earring", --8 stp
        right_ear="Telos Earring", --macc
        left_ring="Petrov Ring", --until "Crepuscular Ring", --stp
        right_ring="Murky Ring", --10 dt (43)
        back="Null Shawl", --macc
        }

	------------------------------------------------------------------------------------------------
    ------------------------------------------- TP Set ---------------------------------------------
    ------------------------------------------------------------------------------------------------

	--capped DT, 11 DW (perfect w/capped magic haste), gear haste handled by alabaster earring
    --swap to ambu cape
    sets.engaged = {
        head="Malignance Chapeau", --6 dt (6)
        body="Malignance Tabard", --9 dt (15)
        hands="Malignance Gloves", --5 dt (20)
        legs=gear.EmpyLegs, --11 dt (31)
        feet="Malignance Boots", --4 dt (35)
        neck="Iskur Gorget", --stp
		waist="Reiki Yotai", --7 dw
        left_ear="Alabaster Earring", --5 dt (40) + need the gear haste with empy legs (5/5 malig is 26, empy legs are -3)
        right_ear="Eabani Earring", --4 dw
        left_ring="Epona's Ring",
        right_ring="Murky Ring", --10 dt (50, capped)
        back="Null Shawl", --7 da 7 stp > 10 da from tp ambu cape that I no longer use and -1 inventory slot, lol
        }

    ------------------------------------------------------------------------------------------------
    ---------------------- DT Sets Except Actually Just Idle In 50/50 ------------------------------
    ------------------------------------------------------------------------------------------------

	--this dt caps with null masque and +3 empy legs, good enough for now
    sets.idle = {
        ammo=gear.RAbullet, --have a bullet equipped to make ranged attacks work out of comabt
		head="Nyame Helm", --7 dt (7) until --"Null Masque", --10 dt (10) (-23 meva relative to nyame, but regain/regen)
		body="Malignance Tabard", --9 dt (16) --same as nyame but also store tp
		hands="Nyame Gauntlets", --7 dt (23) --higher than malignance
		legs=gear.EmpyLegs, --11 dt (34) --vs nyame this is +3 dt, -35 meva (at +3 it's +4, -25) and also free store tp
		feet="Nyame Sollerets", --7 dt (41) --higher than malignance
		neck="Warder's Charm +1", --elemental resistance/magic null
		waist="Carrier's Sash", --elemental resistance
        left_ear="Alabaster Earring", --5 dt (46)
		right_ear="Hearty Earring", --status ailment resist
		left_ring="Shneddick Ring +1", --18 movespeed
		right_ring="Shadow Ring", --magic null
        back=gear.AmbuCape.Snapshot --45 meva 20 int vs "Null Shawl", -- 50 meva assuming marginally better with dint
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --20260311 this is stupid but I can integrate this with Fisher...
    --sets.Fishing = {
        --main="Rostam", --+8 for bolter's roll so I move fast
        --ranged={name="Ebisu Fishing Rod +1", priority=100}, --I don't know why I prioritied this tbh
        --body="Fisherman's Apron",
        --ring2="Noddy Ring", --fewer monsters
        --}


    --sets.buff.Doom = {
    --    neck="Nicander's Necklace", --20
    --    --left_ring={name="Eshmun's Ring", bag="wardrobe3"}, --20
    --    --right_ring={name="Eshmun's Ring", bag="wardrobe4"}, --20
    --    --waist="Gishdubar Sash", --10
    --    }

    --for the Glavoid Gals
    --sets.Legion = set_combine(sets.engaged, sets.Naegling)

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if elemental_ws:contains(spell.name) then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

--technically this is after the midcast, so I can actually just leave waist alone in the QD set.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairShot' then
        if (spell.english ~= 'Light Shot' and spell.english ~= 'Dark Shot') then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
			else --otherwise do nothing
			end
                --equip(sets[state.QuickDraw.current]) --automatically equip whatever set is toggled, if I did this right
                equip(sets.QuickDraw) --and then put on the quick draw set
        end
    elseif spell.action_type == 'Ranged Attack' then
        if buffactive['Triple Shot'] then
            equip(sets.TripleShot)
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if player.status ~= 'Engaged' then --readded no change while engaged, which I think is actually wrong?
        check_weaponmode()
    end
end

function job_buff_change(buff,gain)
    
    --if buff == "doom" then
    --    if gain then
    --        equip(sets.buff.Doom)
    --        disable('neck') --add one of these...
    --    else
    --        enable('neck') --...for each slot there's holy water/cursna gear in
    --        handle_equipping_gear(player.status)
    --    end
    --end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    check_weaponmode()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    check_weaponmode()

    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack, this seems wrong...
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

--enforce selected wepaon and also shield if no DW
function check_weaponmode()
   equip(sets[state.WeaponMode.current])

    if ((player.sub_job ~= 'NIN') and (player.sub_job ~= 'DNC')) then
        equip(sets.DefaultShield)
    end
end
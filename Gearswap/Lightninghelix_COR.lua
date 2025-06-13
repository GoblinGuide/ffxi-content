-- Original: Motenten / Modified: Arislan / gutted: me :)
--here's sets for future reference https://www.ffxiah.com/forum/topic/52018/luck-of-the-draw-a-corsairs-guide-new#_user-5

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
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal')
    --state.HybridMode:options('Normal', 'DT') --I do not actually use this toggle
    state.RangedMode:options('STP', 'Normal') --by default, aim for ranged tp rather than damage per shot
    state.WeaponskillMode:options('Normal')
    state.IdleMode:options('Normal')

    state.WeaponSet = M{['description']='Weapon Set', 'Ataktos', 'DeathPenalty_Melee', 'Fomalhaut_Melee', 'Evisceration', 'AeolianSet'} --by default, the blade is savage --'DeathPenalty_Ranged', 'Fomalhaut_Ranged'
	--state.QuickDraw = M{['description']='Quick Draw Mode', 'QDDebuff', 'QDSTP'} --by default, QD for the debuff, but a toggle for maximum store tp
	send_command('bind F10 gs c cycle WeaponSet')
	--send_command('bind F11 gs c cycle QuickDraw')

    gear.RAbullet = "Chrono Bullet" --correct
    gear.RAccbullet = "Chrono Bullet" --correct
    gear.PhysWSbullet = "Chrono Bullet" --this does nothing for savage, but it helps with Fomalhaut!
    gear.MagicWSbullet = "Living Bullet" --correct
    gear.QDbullet = "Living Bullet" --macc on this bullet too so it's fine

	--define ambu capes
	gear.AmbuCape = {}
	gear.AmbuCape.MagicWS = { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	gear.AmbuCape.TP = { name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy + 10','"Double Attack"+10%','Phys. dmg. taken-10%',}}
	gear.AmbuCape.PhysWS = { name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Mag. Evasion+15',}} --this is for Savage Blade, specifically
	gear.AmbuCape.Snapshot = { name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10','Mag. Evasion+15',}} --snapshot, meva, good for phantom roll
	
	--define other stuff
	gear.HercBoots = {}
	gear.HercBoots.TH = { name="Herculean Boots", augments={'Pet: VIT+13','AGI+12','"Treasure Hunter"+2',}}
	gear.HercBoots.FC = { name="Herculean Boots", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+6','CHR+8',}}
	
	gear.HercVest = {}
	gear.HercVest.TH = { name="Herculean Vest", augments={'INT+2','Pet: Haste+1','"Treasure Hunter"+2','Accuracy+5 Attack+5',}}

	--only one of each of these
	gear.TaeonTabard = { name="Taeon Tabard", augments={'Accuracy+20 Attack+20','"Fast Cast"+5',}} --fast cast
	gear.Moonshade = { name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}} --obviously
	gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}} --fast cast
	
    --trying something new
    gear.AFHead = {name="Laksamana's Tricorne +3"} --20 quick draw damage
    gear.AFBody = {name="Laksamana's Frac +3"} --20 rapid shot, 10 wsd
    gear.AFHands = {name="Laksamana's Gants +1"} --nope
    gear.AFLegs = {name="Laksamana's Trews +1"} --nope
    gear.AFFeet = {name="Laksamana's Bottes +2"} --10 quick draw damage
    gear.RelicHead = {name="Lanun Tricorne +1"} --30 sec duration, 50% to give roll job bonus when job not in party
    gear.RelicBody = {name="Lanun Frac +3"} --50% random deal work on two things
    gear.RelicHands = {name="Lanun Gants +3"} --20% (per merit) to fold two busts... but also 13 snapshot and triple shot occasionally becomes quad shot
    gear.RelicLegs = {name="Lanun Trews +1"} --12% (4 per merit) to make Snake Eye 0 recast
    gear.RelicFeet = {name="Lanun Bottes +3"} --changes wild card odds in your favor, 10 wsd
    gear.EmpyHead = {name="Chasseur's Tricorne +2"} --16 rapid shot, 9 dt
    gear.EmpyBody = {name="Chasseur's Frac +2"} --10 tp regain on tactician's roll, +13% triple shot procs if equipped, 12 dt
    gear.EmpyHands = {name="Chasseur's Gants +2"} --roll duration +55 up to +60, 7 crit rate up to 8, 8 wsd up to 12
    gear.EmpyLegs = {name="Chasseur's Culottes +1"} --nope (12 dt but inventory)
    gear.EmpyFeet = {name="Chasseur's Bottes +1"} --this is the garbage quick draw piece, currently unused within this gearswap, but if I need it I'd better make sure to change that, lots of notes here so I see this

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    --TH 2+2 = 4
    --until I get one more Volte TH1 piece, at which point I'll move these Herc Boots because I can use those on every job and get +1 inventory slot total from -3 +4
	sets.TreasureHunter = {
		body="Volte Jupon", --2
		feet=gear.HercBoots.TH, --2
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Snake Eye'] = {legs=gear.RelicLegs,} --12% chance or 0 recast
    sets.precast.JA['Wild Card'] = {feet=gear.RelicFeet,} --goes from 1/6 all around to 2/16 2/16 3/16 3/16 3/16 3/16
    sets.precast.JA['Random Deal'] = {body=gear.RelicBody,} --50% to reset two abilities instead of one

    --roll +8, duration +100, aoe up, recast -5
	--DT in nonbuff relevant slots (total is currently 42 pdt 32 mdt - snapshot cape is meva instead if I end up wanting that)
    sets.precast.CorsairRoll = {
		main="Rostam", --path C, pr + 8
		ranged="Compensator", --roll duration +20
        head="Lanun Tricorne +1", --duration +30 and roll effect up (50% to give job bonus if job not in party, DRK and SAM and RNG are the best rolls, this works out)
        body="Nyame Mail", --9 dt, HP
        hands=gear.EmpyHands, --55 duration
        legs="Desultor Tassets", --roll recast -5 (can be 8 dt on nyame legs here if I want to cap)
        feet="Nyame Sollerets", --7 dt, HP
        neck="Regal Necklace", --20 duration
		--waist="Plat. Mog. Belt", --3 DT, HP, sick of blood aggro
        left_ear="Odnowa Earring +1", --3 dt, hp
        right_ear="Eabani Earring", --15 eva/hp (could be etiolation for 1 mdt)
        left_ring="Luzaf's Ring", --roll aoe up
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.TP, --10 pdt
        }

    sets.precast.CorsairRoll.Duration = sets.precast.CorsairRoll
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body=gear.EmpyBody,}) --tp regain, useful if not nearly as good as chaos/samurai
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands=gear.EmpyHands,}) --skillchain damage, but I have these for the duration bonus so might as well define
    sets.precast.FoldDoubleBust = {hands=gear.RelicHands,} --lets me fold two busts at once, which hopefully will never happen. but I use this for other stuff anyway

	--43 FC + 0 occ quicken
    sets.precast.FC = {
		head="Haruspex Hat", --8 (8)
        body=gear.TaeonTabard, --9 (17)
        hands=gear.LeylineGloves, --6 (23)
        --legs="Rawhide Trousers", --5 if I care to get these
        feet=gear.HercBoots.FC, --6 (29)
        neck="Orunmila's Torque", --5 (34)
        left_ear="Loquacious Earring", --2 (36)
        right_ear="Etiolation Earring", --1 (37)
        left_ring="Prolix Ring", --2 (39)
        right_ring="Kishar Ring", --4 (43)
        }
		
    --snapshot cap is 60 (+10 from gifts, 70 is the real cap), rapid shot cap does not seem to exist (it's like quick cast)
    --have an extra 3 from crep ring if I need it for some reason, can't free up an inventory slot YET but we'll see...prog
	--this set takes me to 61 + 27
    sets.precast.RA = {
        head=gear.EmpyHead, --0+14 --upgrade this someday, but not really worth it
        body="Oshosi Vest +1", --14+0
        hands=gear.RelicHands, --11+0
        legs="Adhemar Kecks +1", --10+13
        feet="Meg. Jam. +2", --10+0
        neck="Comm. Charm +2", --4+0
		waist="Yemaya Belt", --0+5
        back=gear.AmbuCape.Snapshot, --10+0
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    --all WS sets have as close to 50 DT as I could get because I got sick of dying
    --relevant numbers: Nyame is 7 9 7 8 7 = 38. plus dring is 48, plus either odnowa earring +1 or a,bu cape is capped

	--base WS set: if not defined, Nyame, etc.
    sets.precast.WS = {
        ammo=gear.PhysWSbullet, --assume physical by default
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget", --default to fotia is likely wrong but I'm very, very lazy
		waist="Fotia Belt",
        left_ear=gear.Moonshade,
        right_ear="Odr Earring", --default to wsd, I guess, without knowing what stat's what
        left_ring="Cornelia's Ring", --10 wsd seems fine
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.MagicWS, --default to magic because it has -PDT (may want to needle one of the two to regular DT?)
        }

	--non-dark-elemental magic WS set
    sets.precast.WS['Wildfire'] = {
        ammo=gear.MagicWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets", --over "Lanun Bottes +3", --10 wsd
        neck="Comm. Charm +2",
		waist="Skrymir Cord +1", --autoequip sash logic below
        left_ear="Odnowa Earring +1", --dt
        right_ear="Friomisi Earring",
        left_ring="Cornelia's Ring",
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.MagicWS,
        }

	--other magic WS that aren't LS
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {
        --ammo=gear.QDbullet,
        right_ear=gear.Moonshade, --tp actually matters here
        })

    sets.precast.WS['Hot Shot'] = sets.precast.WS['Aeolian Edge'] --not really sure why I had this with not moonshade befofre, the ftp scaling seems real?

	--really though we're here for these two
    sets.precast.WS['Leaden Salute'] = {
        ammo=gear.MagicWSbullet,
        head="Pixie Hairpin +1", --minus 7 dt from nyame head
		body="Nyame Mail", --DT
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets", --DT, "Lanun Bottes +3", --10 wsd
        neck="Comm. Charm +2",
		waist="Skrymir Cord +1", --there is autoequip orph sash logic below
        left_ear="Friomisi Earring", --MAB
        right_ear=gear.Moonshade,
        left_ring="Archon Ring", --I have no idea why they say regal might be even with this. cornelia will be better until my nyame's auged but not so much that I'd notice
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.MagicWS, --and here's the rest of that dt back, truth be told I actually... hmm. yes I think I can actually get away with just this and not odnowa, it's 10 pdt, mdt is covered by Shell
        }

    sets.precast.WS['Savage Blade'] = {
		ammo=gear.PhysWSbullet,
        head="Nyame Helm",
		body="Nyame Mail", --DT
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets", --DT, "Lanun Bottes +3", --10 wsd
        neck="Comm. Charm +2", --15 str aug
		waist="Sailfi Belt +1",
		left_ear="Odr Earring", --sucks, but better than wasting an inv slot on 2 wsd
        right_ear=gear.Moonshade,
        left_ring="Cornelia's Ring",
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.PhysWS,
        }

    --yeah ok I did make a fomalhaut so this matters too, 85% agi modifier, physical, ftp good
    sets.precast.WS['Last Stand'] = {
        ammo=gear.PhysWSbullet,
        head="Nyame Helm",
		body="Nyame Mail", --DT
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets", --DT, "Lanun Bottes +3", --10 wsd
        neck="Fotia Gorget", --default to fotia is likely wrong but I'm very, very lazy
		waist="Fotia Belt",
        left_ear="Odnowa Earring +1", --this gives me 3 dt and I have no actual relevant earring here
        right_ear=gear.Moonshade,
        left_ring="Dingir Ring", --wow that's a lot of stats
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.PhysWS,
        }

	--really, who cares? mnd modifier that I will never use
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        left_ear=gear.Moonshade,
        right_ear="Telos Earring",
        })

	--for sheol 
    sets.precast.WS['Evisceration'] = {
		ammo=gear.PhysWSbullet, --evisceration physical
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
        left_ear="Sherida Earring", --allegedly second best earring for evisc, period, which blows my mind
        right_ear="Odr Earring", --Moonshade is only 2.5% crit rate at 1k tp
        left_ring="Ilabrat Ring", --stats for days
        right_ring="Defending Ring", --10 dt
        back=gear.AmbuCape.PhysWS, --not optimal, double not making crit cape
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    --todo: find actual sird gear?
    sets.midcast.SpellInterrupt = {
        --body="" --0, taeon tabard does NOT have ten natively so I removed the errant reference here
        --hands="Rawhide Gloves", --15
        legs="Carmine Cuisses +1", --20
        --feet=gear.Taeon_Phalanx_feet, --10
        neck="Loricate Torque +1", --5
        --waist="Rumination Sash", --10
        --left_ear="Halasz Earring", --5
        --right_ear="Magnetic Earring", --8
        --right_ring="Evanescence Ring", --5
        }

    --for this, obviously. should figure out how do work DT here and so on and so forth
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Ranged gear, store tp mostly
    --full malignance set is 6 9 5 7 4 = 15 + 12 + 4 = 31 DT so with dring and cape and shell V this is also capped
    --todo: figure out ranged set, make ranged cape?
    sets.midcast.RA = {
		--sub="Nusku Shield", --this eats tp if I'm dual wielding
        ammo=gear.PhysWSbullet, --ranged attack is physical attack, too lazy to rename bullet
        head="Malignance Chapeau", --"Ikenga's Hat", --needs augs to beat the macc
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", --"Ikenga's Trousers", --same
        feet="Malignance Boots",
        neck="Iskur Gorget",
        left_ear="Crepuscular Earring", --lose 7 ratk from enervating, gain 3 racc+1 stp
        right_ear="Telos Earring",
        left_ring="Crepuscular Ring", --racc and stp
        right_ring="Defending Ring", --10 dt
        waist="Yemaya Belt",
		back=gear.AmbuCape.TP, --I don't have an actual ranged attack/ranged accuracy cape apparently
        }

	--haven't got any racc sets, should definitely work out a toggle for that eventually

    --base 60% triple shot activation rate after job point bonuses, so 40 is max in gear
    --18 currently, cap of 33 with existing gear that I know of
    --this sacrifices some DT
    sets.TripleShot = {
        --head="Oshosi Mask +1", --buy, 5 + some damage bonus
        body=gear.EmpyBody, --13, upgrade eventually to 14 (also 12 DT to make up for missing currently 14 in malignance)
        hands=gear.RelicHands, --occ. becomes Quad Shot
        --legs="Osh. Trousers +1", --buy, 6
        --feet="Osh. Leggings +1", --buy, 3
        back=gear.AmbuCape.TP, --5, want the pdt and not the meva
        }

	 ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--assuming max haste, need 36 DW, but I love not dying so let's figure out malig options
	--/nin is 25 DW so 11 in gear needed, currently at 7+4 is perfect
	--full malig is 26 gear haste = capped, barely
	--current engaged DT is 31 from malignance + 10 DT from dring (41/41) (need 9 more)
    --with empy +3 legs: empy legs + null loop + offhand gleti's knife + figure out ear situation (cessance that I don't have > telos that I do > idk because cor is its own source of store tp? + malig has some obv)
    sets.engaged = {
        ammo=gear.RAbullet, --no coiste bodhar because weapon swap
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", --7 dt, empy legs +3 vs this gives +5 dt +13 acc +2 stp but -3 haste (see above)
        feet="Malignance Boots",
        neck="Iskur Gorget",
		waist="Reiki Yotai", --7 dw
        left_ear="Telos Earring",
        right_ear="Eabani Earring", --suppanomimi is +1 dw
        left_ring="Epona's Ring", --is this optimal?
        right_ring="Defending Ring",
        back="Null Shawl", --7 da 7 stp > 10 da from ambucape tp that I no longer use
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ DT Sets ---------------------------------------------
    ------------------------------------------------------------------------------------------------

	--dt capped, ring slot is '1 regen' and could be better. could get null masuqe eventually. heh.
    sets.idle = {
		ammo="Chrono Bullet", --always have "a bullet" equipped to avoid weird RA situations
		head="Nyame Helm", --7 dt (7)
		body="Nyame Mail", --12 dt (19)
		hands="Nyame Gauntlets", --7 dt (26)
		legs="Nyame Flanchard", --8 dt (34)
		feet="Nyame Sollerets", --7 dt (41)
		neck="Loricate Torque +1", --6 dt (47)
		waist="Carrier's Sash", --elemental resistance
        left_ear="Odnowa Earring +1", --3 dt (52)
		right_ear="Eabani Earring", --15 evasion, the ear slots are awful for idle sets
		left_ring="Shneddick Ring +1", --18 movespeed
		right_ring="Chirich Ring +1", --1 regen, because I'm dt capped elsewhere
        back="Null Shawl", -- 50 meva, since dt is overcap
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --sets.buff.Doom = {
    --    neck="Nicander's Necklace", --20
    --    --left_ring={name="Eshmun's Ring", bag="wardrobe3"}, --20
    --    --right_ring={name="Eshmun's Ring", bag="wardrobe4"}, --20
    --    --waist="Gishdubar Sash", --10
    --    }

    --define weapon modes
	sets.Ataktos = {main="Naegling", sub="Crepuscular Knife", ranged="Ataktos"} --the only Naegling set because why bother with Coiste Bodhar (swap to gleti's when I get emp+3 legs)
    sets.DeathPenalty_Melee = {main="Rostam", sub="Tauret", ranged="Death Penalty"} --tauret and naegling have +magic damage and MAB, rostam only has +magic damage
	sets.Fomalhaut_Melee = {main="Rostam", sub="Crepuscular Knife", ranged="Fomalhaut"} --(swap to gleti's when I get emp+3 legs? offhand is only contributing chr mod here, rostam has 50 racc)
    sets.AeolianSet = {main="Tauret", sub="Naegling", ranged="Death Penalty"} --tauret and naegling have +magic damage and MAB, rostam only has +magic damage
    sets.Evisceration = {main="Tauret", sub="Crepuscular Knife", ranged="Ataktos"} --ataktos doesn't do much here, two piercing weps cause it's for piercing resistant damage type (swap to gleti's when I get emp+3 legs)
    sets.DeathPenalty_Ranged = {main="Rostam", sub="Crepuscular Knife", ranged="Death Penalty"} --Rostam has 50 racc on it so it's best for ranged uses (offhand is doing 0 but chr mod here)
    sets.Fomalhaut_Ranged = {main="Rostam", sub="Crepuscular Knife", ranged="Fomalhaut"} --see above set note
    
    --curently just one set, for stp return
    --quick draw takes MAGIC accuracy. not ranged. don't forget that.
	--recast hardcap is 35 seconds: 60 base, -10 from category 1 merits, -10 from JP gift, -5 from Mirke Wardecors, no need to do Blood Mask tatter+scrap synergy for another 5s
    --without loricate + dedition this set is 42 pdt 32 mdt which felt too low so I capped it
    sets.QuickDraw ={
        ammo=gear.QDbullet,
        head="Malignance Chapeau", --stp and dt
        body="Mirke Wardecors", --5s cooldown
        hands="Malignance Gloves", --stp and dt
        legs="Malignance Tights", --stp and dt
        feet="Malignance Boots",
        neck="Loricate Torque +1", --"Iskur Gorget", --8 stp
        waist="Skrymir Cord +1", --7 macc, eschan stone is same
	    left_ear="Odnowa Earring +1", --"Dedition Earring", --8 stp
        right_ear="Telos Earring", --macc
        left_ring="Chirich Ring +1", --stp
        right_ring="Defending Ring", --dt
        back=gear.AmbuCape.MagicWS, --macc and pdt
        }

    --TODO: someday implement bottes debuff, but for now I get +1 inventory slot by just always going stp
    --quick draw set 1, with bottes for debuff
    --sets.QDDebuff = {
    --	ranged="Death Penalty", --60% damage, 60 macc
	--	feet="Chass. Bottes +1", --25% more damage on next hit of this element within 10 seconds (no laksa bottes, this is the important thing to make Leaden Salute even better, honestly I don't care)
    --}
	
	--automatically equipped when not capable of dual wielding, see logic in function below
    sets.DefaultShield = {sub="Nusku Shield"}

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
        check_weaponset()
    end
end

function job_buff_change(buff,gain)
    --if buff == "doom" then
    --    if gain then
    --        equip(sets.buff.Doom)
    --        disable('neck') --the only doom gear I have right now is neck, change accordingly
    --    else
    --        enable('neck')
    --        handle_equipping_gear(player.status)
    --    end
    --end

	--20230701 attempted to handle automatic charm stripping naked
	if buff == "charm" then
        if gain then
            equip(sets.naked)
            disable('all') --stay naked until morale improves
        else
            enable('all')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    check_weaponset()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    check_weaponset()

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

function check_weaponset()
   equip(sets[state.WeaponSet.current])

    if player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC' then
        equip(sets.DefaultShield)
    end
end
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
    --20251118 if I don't run into trouble from removing these in a week, delete them
    --state.OffenseMode:options('Normal')
    --state.HybridMode:options('Normal', 'DT') --all my sets are
    --state.RangedMode:options('STP', 'Normal') --
    --state.WeaponskillMode:options('Normal')
    --state.IdleMode:options('Normal')

    state.WeaponSet = M{['description']='Weapon Set', 'Ataktos', 'DeathPenalty_Melee', 'Fomalhaut_Melee', 'Evisceration', 'AeolianSet'} --default to SB on job change
    --unused: 'DeathPenalty_Ranged', 'Fomalhaut_Ranged' (for ra only situations)
	send_command('bind F10 gs c cycle WeaponSet')


    gear.RAbullet = "Chrono Bullet" --optimal
    gear.RAccbullet = "Chrono Bullet" --optimal
    gear.PhysWSbullet = "Chrono Bullet" --doesn't do anything for Savage Blade, good with Last Stand?
    gear.MagicWSbullet = "Living Bullet" --optimal
    gear.QDbullet = "Living Bullet" --macc, so optimal I think

	--define ambu capes
	gear.AmbuCape = {}
	gear.AmbuCape.MagicWS = { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	gear.AmbuCape.TP = { name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy + 10','"Double Attack"+10%','Phys. dmg. taken-10%',}}
	gear.AmbuCape.PhysWS = { name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Mag. Evasion+15',}} --this is for Savage Blade, specifically
	gear.AmbuCape.Snapshot = { name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10','Mag. Evasion+15',}} --snapshot, meva, good for phantom roll
	
	--define other stuff
    gear.HercHelm = {} --technically not needed if I just rename the item below, but a legacy of when I had TH herc helms (never gonna have a wsd one ever, but 13 FC seems worth 1 inv slot)
    gear.HercHelm.FC = { name="Herculean Helm", augments={'"Mag.Atk.Bns."+8','"Fast Cast"+6','MND+8',}}

	gear.Moonshade = { name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}}
	gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}
	
    --trying something new
    gear.AFHead = {name="Laksamana's Tricorne +3"} --unused forever (quick draw damage)
    gear.AFBody = {name="Laksamana's Frac +3"} --unused, 20 rapid shot, 10 wsd, reforges to 12 wsd (nyame goes to 13) no dt
    gear.AFHands = {name="Laksamana's Gants +1"} --unused forever
    gear.AFLegs = {name="Laksamana's Trews +1"} --unused forever
    gear.AFFeet = {name="Laksamana's Bottes +2"} --unused forever (quick draw damage, yes there are really two such pieces)
    gear.RelicHead = {name="Lanun Tricorne +1"} --30 sec duration, 50% to give roll job bonus when job not in party
    gear.RelicBody = {name="Lanun Frac +3"} --50% random deal work on two things
    gear.RelicHands = {name="Lanun Gants +3"} --13 snapshot and triple shot occasionally becomes quad shot (also fold two busts chance)
    gear.RelicLegs = {name="Lanun Trews +1"} --12% (4 per merit) to make Snake Eye 0 recast
    gear.RelicFeet = {name="Lanun Bottes +3"} --changes wild card odds in your favor, 10 wsd -> 12 on reforge but only 6 pdt (no thanks)
    gear.EmpyHead = {name="Chasseur's Tricorne +2"} --16 rapid shot, 9 dt (up to 18/10)
    gear.EmpyBody = {name="Chasseur's Frac +2"} --10 tp regain on tactician's roll, +13% triple shot procs if equipped, 12 dt (up to 13 dt, 14 triple shot)
    gear.EmpyHands = {name="Chasseur's Gants +2"} --roll duration +55 up to +60, 7 crit rate 7 up to 8, 8 wsd up to 12 (also no dt, very rude)
    gear.EmpyLegs = {name="Chasseur's Culottes +1"} --currently unused until +3 reforge (12 dt once I get there)
    gear.EmpyFeet = {name="Chasseur's Bottes +2"} --quick draw same-element subsequent-damage buff

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    --may be optimal to change Volte pieces at some point, or use Hoxne Ring with HP swaps, or whatever. this is fine for now.
    --TH 2+1+1, all items work on all jobs and are i119
	sets.TreasureHunter = {
		body="Volte Jupon", --2
		hands="Volte Bracers", --1
        waist="Chaac Belt", --1
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Snake Eye'] = {legs=gear.RelicLegs,} --12% chance of 0 recast
    sets.precast.JA['Wild Card'] = {feet=gear.RelicFeet,} --changes odds from 1/6 uniform to 2/16 2/16 3/16 3/16 3/16 3/16
    sets.precast.JA['Random Deal'] = {body=gear.RelicBody,} --50% to reset two abilities instead of one

    --roll +8, duration +100, aoe up, recast -5
	--41 pdt 31 mdt - could use nyame legs over desultor tassets, or plat mog belt, or something?
    sets.precast.CorsairRoll = {
		main="Rostam", --roll +8
		ranged="Compensator", --roll duration +20
        head="Lanun Tricorne +1", --duration +30 and roll effect up (50% to give job bonus if job not in party)
        body="Nyame Mail", --9 dt (9 dt)
        hands=gear.EmpyHands, --55 duration
        legs="Desultor Tassets", --roll recast -5 (vs 8 dt on nyame legs here if I want to cap)
        feet="Nyame Sollerets", --7 dt (16 dt)
        neck="Regal Necklace", --20 duration
		--waist="Plat. Mog. Belt", --3 DT, HP, sick of blood aggro so nothing here for now (maybe flume belt +1, 4 pdt?)
        left_ear="Alabaster Earring", --5 dt (21 dt)
        --right_ear="Etiolation Earring", --3 mdt, inventory, but if needed
        left_ring="Luzaf's Ring", --roll aoe up because I love it (could put dring here lol?)
        right_ring="Murky Ring", --10 dt (31 dt)
        back=gear.AmbuCape.TP, --10 pdt (41 pdt, 31 mdt)
        }

    sets.precast.CorsairRoll.Duration = sets.precast.CorsairRoll --no thank you, just gonna figure out one set
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body=gear.EmpyBody,}) --tp regain, actually useful
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands=gear.EmpyHands,}) --skillchain damage, but I have these for the duration bonus in this slot anyway so I might as well explicitly define
    sets.precast.FoldDoubleBust = {hands=gear.RelicHands,} --lets me fold two busts at once, which hopefully will never happen. but I use this for other stuff anyway

	--FC is 44, cap is 80. I don't really care. anything BLU can use we can use here.
    sets.precast.FC = {
		head=gear.HercHelm.FC, --7+6 (13) --keeping this single item 
        body="Adhemar Jacket +1", --10 (23) (lol)
        hands=gear.LeylineGloves, --8 (31)
        --legs="Gyve Trousers", --4, gear.Herclegs.FC is 6, inventory
        --feet=gear.HercBoots.FC, --6 aug, inventory
        neck="Orunmila's Torque", --5 (36)
        left_ear="Loquacious Earring", --2 (38)
        --right_ear="Etiolation Earring", --1, inventory
        left_ring="Prolix Ring", --2 (42)
        right_ring="Kishar Ring", --4 (44)
        }
		
    --snapshot cap is 60 (+10 from gifts, 70 is the real cap), rapid shot cap does not seem to exist (it's like quick cast, but good instead of bad)
	--this is currently 64 + 27 (ikenga's boots is 5 so it leaves me literally one short, taeon can go to 10 per slot in the big five but those are already as good as they get)
    sets.precast.RA = {
        head=gear.EmpyHead, --0+16 --upgrade this someday, eventually
        body="Oshosi Vest +1", --14+0
        hands=gear.RelicHands, --11+0
        legs="Adhemar Kecks +1", --10+13
        feet="Meg. Jam. +2", --10+0 --if I can replace this it's +1 inv slot, but I do not think there's a way to do this even with ikenga's boots
        neck="Comm. Charm +2", --4+0
		waist="Yemaya Belt", --0+5
        left_ring="Crepuscular Ring", --3+0
        back=gear.AmbuCape.Snapshot, --10+0
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    --all WS sets have as close to 50 DT as I could get because I got sick of dying
    --relevant numbers: Nyame is 7 9 7 8 7 = 38, murky ring plus either alabaster earring or dt ambu cape is capped

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
        left_ear="Alabaster Earring", --default to dt cap
        right_ear=gear.Moonshade,
        left_ring="Cornelia's Ring", --10 wsd seems fine
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.MagicWS, --default to magic because it has -PDT (may want to needle one of the two to regular DT?)
        }

	--non-dark-elemental magic WS set
    sets.precast.WS['Wildfire'] = {
        ammo=gear.MagicWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Comm. Charm +2",
		waist="Skrymir Cord +1", --autoequip sash logic below
        left_ear="Alabaster Earring", --5 dt
        right_ear="Friomisi Earring",
        left_ring="Cornelia's Ring",
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.MagicWS,
        }

	--other magic WS that aren't LS
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {
        --ammo=gear.QDbullet,
        right_ear=gear.Moonshade, --tp actually matters here
        })

    sets.precast.WS['Hot Shot'] = sets.precast.WS['Aeolian Edge'] --not really sure why I had this with not moonshade befofre, the ftp scaling seems real?

	--really though we're here for these two
    --DT in the Leaden set is 9+7+8+7 from 4/5 Nyame (31), 10 from Murky Ring (41), 10 PDT from ambu cape (51+41 Shell V handles)
    --could use Alabaster over Friomisi and needle Cape to regular DT for double cap at the cost of 10 MAB which honestly... doesn't really bother me at all, but I'll wait on more Nyame aug for WSD to compensate
    sets.precast.WS['Leaden Salute'] = {
        ammo=gear.MagicWSbullet,
        head="Pixie Hairpin +1", --minus 7 dt from nyame head, plus 28 dark affinity (that's twice as much as orpheus sash!)
		body="Nyame Mail", --DT, allegedly "Lanun Frac +4" having 64 MAB > 30 MAB is actually superior
        hands="Nyame Gauntlets", --DT
        legs="Nyame Flanchard", --DT
        feet="Nyame Sollerets", --DT
        neck="Comm. Charm +2",
		waist="Skrymir Cord +1", --there is autoequip orph sash logic below
        left_ear="Friomisi Earring", --MAB
        right_ear=gear.Moonshade,
        left_ring="Archon Ring", --I have no idea why they say regal might be even with this. cornelia will be better until my nyame's auged but not so much that I'd notice
        right_ring="Murky Ring", --10 dt (Dingir Ring is better if I don't care about dt cap))
        back=gear.AmbuCape.MagicWS, --10 pdt
        }

    --want to dt cap, this cape has magic evade...
    --38 dt from 5/5 nyame, so need 12. alabaster+murky, or cape+murky, so flex is either an earring (bleh) or a cape augment (okay, meva it is)
    sets.precast.WS['Savage Blade'] = {
		ammo=gear.PhysWSbullet,
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets", --DT, "Lanun Bottes +3", --10 wsd, full nyame is 38 dt
        neck="Comm. Charm +2", --15 str aug
		waist="Sailfi Belt +1",
		left_ear="Alabaster Earring", --whatever, good enough, 5 dt to go 48 with ring -> 53 and capped
        right_ear=gear.Moonshade,
        left_ring="Cornelia's Ring",
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.PhysWS, --this cape has magic evade
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
        left_ear="Alabaster Earring", --cap DT
        right_ear=gear.Moonshade,
        left_ring="Dingir Ring", --wow that's a lot of stats
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.PhysWS,
        }

	--really, who cares? mnd modifier that I will never use
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        left_ear="Telos Earring",
        right_ear=gear.Moonshade,
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
        left_ear="Alabaster Earring", --cap dt (allegedly Sherida if I can do this a different way/care)
        right_ear="Odr Earring", --crit
        left_ring="Ilabrat Ring", --stats for days
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.PhysWS, --not optimal, but double not making crit cape
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    --todo: find actual sird gear? I have half this crap but none of it's in my wardrobe for space reasons
    sets.midcast.SpellInterrupt = {
        --hands="Rawhide Gloves", --15
        --legs="Carmine Cuisses +1", --20
        --neck="Loricate Torque +1", --5
        --waist="Rumination Sash", --10
        --left_ear="Halasz Earring", --5
        --right_ear="Magnetic Earring", --8
        --right_ring="Evanescence Ring", --5
        }

    --for this, obviously. should figure out how do work DT here and so on and so forth
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Ranged gear, store tp mostly
    --full malignance set is 6 9 5 7 4 = 15 + 12 + 4 = 31 DT so with ring and cape and shell V this is also capped
    --todo: figure out ranged set, make ranged cape? do I care about... well, anything?
    sets.midcast.RA = {
		--sub="Nusku Shield", --this eats tp if I'm dual wielding
        ammo=gear.PhysWSbullet, --ranged attack is physical attack, too lazy to rename bullet
        head="Malignance Chapeau", --"Ikenga's Hat", --needs augs to beat the racc
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", --"Ikenga's Trousers", --same
        feet="Malignance Boots",
        neck="Iskur Gorget",
        left_ear="Crepuscular Earring", --lose 7 ratk from enervating, gain 3 racc+1 stp
        right_ear="Telos Earring", --these are both 10 racc 5 stp so it doesn't matter which I put here for triple shot to overwrite with dt
        left_ring="Crepuscular Ring", --racc and stp
        right_ring="Murky Ring", --10 dt
        waist="Yemaya Belt",
		back=gear.AmbuCape.TP, --I don't have an actual ranged attack/ranged accuracy cape apparently
        }

	--haven't got any racc sets, should definitely work out a toggle for that eventually

    
    --base 60% triple shot activation rate after job point bonuses, so 40 is max in gear
    --this set is 13+5+5 = 23 to take to 83% activation total
    --DT is 12 (empy body) + 7 + 4 (malignance boots and tights) + 10 (murky) + 5 (alabaster) = 12 + 7 + 4 + 10 + 5 = 13 + 11 + 15 = 38 + 10 PDT from Ambu cape = 48 PDT, 38 MDT
    --there's a reasonable argument for not using the oshosi pieces, but I think it's correct to use them? not sure. let's give it a shot for a while.
    sets.TripleShot = {
        head="Oshosi Mask +1", --5%, Triple Shot damage +13 (this is a percentage)
        body=gear.EmpyBody, --13% (becomes 14% at +3)
        hands=gear.RelicHands, --occ. becomes Quad Shot (good)
        legs="Malignance Tights",
        feet="Malignance Boots",
        left_ear="Alabaster Earring", --5 dt
        back=gear.AmbuCape.TP, --5%
        }

	 ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--assuming max haste, need 36 DW, but I love not dying so let's figure out malig options
	--/nin is 25 DW so 11 in gear needed, currently at 7+4 is perfect
	--full malig is 26 gear haste = capped, barely
	--current engaged DT is 31 from malignance + 10 DT from dring (41/41) (need 9 more)
    --EVENTUAL swaps: alabaster earring over telos, empy +3 legs over malignance, end up +2 haste, 7 dt -> 12+5 = 17 and capped DT (once I have gallimaufry)
    sets.engaged = {
        ammo=gear.RAbullet, --no coiste bodhar because weapon swap
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", --7 dt, empy legs +3 vs this gives +5 dt +13 acc +2 stp but -3 haste (see above)
        feet="Malignance Boots",
        neck="Iskur Gorget",
		waist="Reiki Yotai", --7 dw
        left_ear="Telos Earring", --this will become alabaster earring when I have empy +3 legs
        right_ear="Eabani Earring", --4 dw
        left_ring="Epona's Ring", --assume this beats petrov
        right_ring="Murky Ring",
        back="Null Shawl", --7 da 7 stp > 10 da from ambucape tp that I no longer use, though if there's the inventory slot this is another way to solve the DT issue to free up earring slot (meh, lazy)
        }

    ------------------------------------------------------------------------------------------------
    ---------------------- DT Sets Except Actually Just Idle In 50/50 ------------------------------
    ------------------------------------------------------------------------------------------------

	--4 over dt cap, no idea what to do about it. can get higher with empy +3 but what does that even do for me, free up an ear?
    sets.idle = {
		ammo="Living Bullet", --always have "a bullet" equipped to avoid weird RA situations, and I always have Living Bullets in inventory because they're Leaden Salute bullets
		head="Null Masque", --10 dt + 2 regain + 3 regen lol (10) (-23 meva relative to nyame, but regain/regen and the dt lets me use null shawl over ambu cape for 20 meva back, this is fine)
		body="Nyame Mail", --12 dt (22)
		hands="Nyame Gauntlets", --7 dt (29)
		legs="Nyame Flanchard", --8 dt (37)
		feet="Nyame Sollerets", --7 dt (44)
		neck="Null Loop", --5 dt (49) (regrettable +50 HP and less defense than Loricate, but +1 inventory slot)
		waist="Carrier's Sash", --elemental resistance
        left_ear="Alabaster Earring", --5 dt (54)
		right_ear="Eabani Earring", --15 evasion, the ear slots are awful for idle sets
		left_ring="Shneddick Ring +1", --18 movespeed
		right_ring="Chirich Ring +1", --1 regen
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
	sets.Ataktos = {main="Naegling", sub="Crepuscular Knife", ranged="Ataktos"} --the only Naegling set because why bother with Coiste Bodhar (swap to gleti's when I get emp+3 legs, unless haste meta has changed)
    sets.DeathPenalty_Melee = {main="Rostam", sub="Tauret", ranged="Death Penalty"} --tauret and naegling have +magic damage and MAB, rostam only has +magic damage
	sets.Fomalhaut_Melee = {main="Rostam", sub="Crepuscular Knife", ranged="Fomalhaut"} --(swap to gleti's when I get emp+3 legs? offhand is only contributing chr mod here, rostam has 50 racc)
    sets.AeolianSet = {main="Tauret", sub="Naegling", ranged="Death Penalty"} --tauret and naegling have +magic damage and MAB, rostam only has +magic damage
    sets.Evisceration = {main="Tauret", sub="Crepuscular Knife", ranged="Ataktos"} --ataktos doesn't do much here, two piercing weps cause it's for piercing resistant damage type (swap to gleti's when I get emp+3 legs)
    sets.DeathPenalty_Ranged = {main="Rostam", sub="Crepuscular Knife", ranged="Death Penalty"} --Rostam has 50 racc on it so it's best for ranged uses (offhand is doing 0 but chr mod here)
    sets.Fomalhaut_Ranged = {main="Rostam", sub="Crepuscular Knife", ranged="Fomalhaut"} --see above set note
    
    --curently just one set, with the element-buffing Bottes and almost-capped MDT
    --quick draw takes MAGIC accuracy. not ranged. don't forget that.
	--recast hardcap is 35 seconds: 60 base, -10 from category 1 merits, -10 from JP gift, -5 from Mirke Wardecors, no need to do Blood Mask tatter+scrap synergy for another 5s
    --48 PDT, 38 MDT (caps with shell), so not quite perfect, but nowhere to get more without sacrifices
    sets.QuickDraw ={
        ammo=gear.QDbullet,
        head="Malignance Chapeau", --6 dt
        body="Mirke Wardecors", --minus 5 seconds cooldown
        hands="Malignance Gloves", --5 dt (11)
        legs="Malignance Tights", --7 dt (18)
        feet=gear.EmpyFeet, --25% more damage on next hit of this element within 10 seconds (no laksa bottes, this is the important thing to make Leaden Salute even better)
        neck="Null Loop", --5 dt (23) but also 50 macc over 6 dt torque / 8 stp neck
        waist="Skrymir Cord +1", --7 macc, eschan stone is same
	    left_ear="Alabaster Earring", --5 dt (28) "Dedition Earring", --8 stp
        right_ear="Telos Earring", --macc
        left_ring="Chirich Ring +1", --stp
        right_ring="Murky Ring", --10 dt (38)
        back=gear.AmbuCape.MagicWS, --macc and pdt (48 pdt, 38 mdt)
        }

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
--todo: make sure one of the paeons has a specific set to have daurdabla and is labelled as the dummy song (there's gotta be a better way than this?)
--todo: destroy this

-- Original: Motenten / Modified: Arislan / Gutted: me :)

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--F10:            Cycle through weapon sets

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[

    --TODO: FIGURE OUT ALL THIS SHIT EVENTUALLY
    --BROADLY, JUST MAKE A MACRO FOR A PLACEHOLDER SONG LIKE THIS
    Custom commands:
    SongMode may take one of three values: None, Placeholder, FullLength

    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle SongMode
    gs c set SongMode Placeholder

    The Placeholder state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.

    Simple macro to cast a placeholder Daurdabla song:
    /console gs c set SongMode Placeholder
    /ma "Shining Fantasia" <me>

    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    include('Mote-TreasureHunter')

    --set TH mode to tag by default
	windower.send_command('gs c set treasuremode Tag')

    --NOT included: special JA TH stuff. I don't care, I'm on bard, this is for like dynamis trials.

    state.SongMode = M{['description']='Song Mode', 'None', 'Placeholder'}

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
    elemental_ws = S{"Aeolian Edge"}


end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

    --are these the weapons I care about?
    state.WeaponSet = M{['description']='Weapon Set', 'Carnwenhan', 'Twashtar', 'Tauret', 'Naegling'}

    state.LullabyMode = M{['description']='Lullaby Instrument', 'Harp', 'Horn'}

    state.Carol = M{['description']='Carol',
        'Fire Carol', 'Fire Carol II', 'Ice Carol', 'Ice Carol II', 'Wind Carol', 'Wind Carol II',
        'Earth Carol', 'Earth Carol II', 'Lightning Carol', 'Lightning Carol II', 'Water Carol', 'Water Carol II',
        'Light Carol', 'Light Carol II', 'Dark Carol', 'Dark Carol II',
        }

    state.Threnody = M{['description']='Threnody',
        'Fire Threnody II', 'Ice Threnody II', 'Wind Threnody II', 'Earth Threnody II',
        'Ltng. Threnody II', 'Water Threnody II', 'Light Threnody II', 'Dark Threnody II',
        }

    state.Etude = M{['description']='Etude', 'Sinewy Etude', 'Herculean Etude', 'Learned Etude', 'Sage Etude',
        'Quick Etude', 'Swift Etude', 'Vivacious Etude', 'Vital Etude', 'Dextrous Etude', 'Uncanny Etude',
        'Spirited Etude', 'Logical Etude', 'Enchanting Etude', 'Bewitching Etude'}

    -- Adjust this if I make Loughnashade
    info.ExtraSongInstrument = 'Daurdabla'

    -- How many extra songs we can keep from Daurdabla/Terpander/Loughnashade
    info.ExtraSongs = 2

    -- Designates instruments used to sing Horde Lullaby
    info.LullabyHarp = 'Daurdabla'
    info.LullabyHorn = 'Gjallarhorn'
    info.LullabyMaxDuration = 'Marsyas' -- Used with Troubadour

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    --Individual pieces of equipment
    gear.Linos = {}
    gear.Linos.TP = {range={ name="Linos", augments={'Accuracy+20','"Store TP"+4','Quadruple Attack +3',}},} --could be 15 acc+att, but that roll is too rare for me
    gear.Linos.WS = {range={ name="Linos", augments={'Attack+20','Weapon skill damage +3%','STR+6 DEX+6',}},} --never gonna make two distinct ws ones, so 6/6 rather than 8/0 on these two stats. see acc+att note above
    
    --when on new character, check my notes about damage taken, some of these are wrong
    gear.AmbuCape = {}
    gear.AmbuCape.Savage = {back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}},}
    gear.AmbuCape.Rudras = gear.AmbuCape.Savage --need to make another with same stats except dex (reuse this one for Mordant Rime too, it's good enough)
    gear.AmbuCape.TP = {back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}},}
    gear.AmbuCape.MAcc = {back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    --leftover rdm pieces that cost me nothing but inventory... but I still need inventory slots so I might not keep all these, at least not in wardrobe 2 (they're in w3 for now)
    --gear.TelchineHead = { name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}}
	--gear.TelchineBody = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}}
	--gear.TelchineLegs = { name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}}

    gear.AFHead = {name="Brioso Roundlet +4"} --macc, string skill for lullaby (set bonus on these is +15 per piece of set / regal ear up to 5)
    gear.AFBody = {name="Brioso Justaucorps +3"} --macc (can skip +4 for lullaby string skill here to save units, but macc is great, might as well)
    gear.AFHands = {name="Brioso Cuffs +3"} --macc / +2 lullaby
    gear.AFLegs = {name="Brioso Cannions +3"} --UNUSED (leg slot has song duration, total of -13 macc to use regal ear instead of this+macc ear)
    gear.AFFeet = {name="Brioso Slippers +4"} --song duration! also best in slot macc. they're really nice

    gear.RelicHead = {name="Bard's Roundlet"} --UNUSED
    gear.RelicBody = {name="Bihu Justaucorps"} --troubadour duration, wsd (to +4)
    gear.RelicHands = {name="Bard's Cuffs"} --UNUSED
    gear.RelicLegs = {name="Bihu Cannions"} --soul voice duration (to +1)
    gear.RelicFeet = {name="Bihu Slippers"} --nightingale duration, string skill for lullaby (to +4)
    
    gear.EmpyHead = {name="Fili Calot +2"} --madrigal
    gear.EmpyBody = {name="Fili Hongreline +2"} --minuet, 14 duration
    gear.EmpyHands = {name="Fili Manchettes +2"} --march, 11 dt
    gear.EmpyLegs = {name="Fili Rhingrave +1"} --13 dt and also more meva than nyame, idle pants
    gear.EmpyFeet = {name="Fili Cothurnes +2"} --fast cast 10 -> 13 at +3. generates more inventory slots than it consumes.

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --TH 3 for now until I get the body
	sets.TreasureHunter = {
		--body="Volte Jupon", --2
        left_ring="Hoxne Ring", --1
        waist="Chaac Belt", --1
		}

    --FC cap is 80, this is 2 over cap without requiring any tp-loss swaps (6 FC Linos does exist, won't lose TP. but -1 inventory.)
    --could swap prolix ring for enchntr. earring +1 for -1 fc, +5 dt... but also -1 inventory slot so it will not happen.
    sets.precast.FC = {
        head="Bunzi's Hat", --10 (10)
        body="Inyanga Jubbah +2", --14 (24)
        hands="Leyline Gloves", --8 (32)
        legs="Volte Brais", --8 (40)
        feet=gear.EmpyFeet, --10 at +2 -> 13 at +3 (53)
        neck="Orunmila's Torque", --5 (58)
        waist="Embla Sash", --5 (63)
        left_ear="Alabaster Earring", --free slot, dt
        right_ear="Loquac. Earring", --2 (65)
        left_ring="Kishar Ring", --4 (69)
        right_ring="Prolix Ring", --3 (72)
        back=gear.BRD_Song_Cape, --10 (82)
        }

    --inventory slots are making a looot of this turn into empty sets
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {})

    --frankly, I don't see a need to mess with this to get more dt into a precast fc set, but it doesn't consume inventory slots, so maybe?
    --if I do, pieces are head=gear.EmpyHead, --14, feet=gear.RelicFeet, --9
    sets.precast.FC.BardSong = set_combine(sets.precast.FC, {})
    
    sets.precast.FC.SongPlaceholder = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})

    --dispelga requires daybreak in main hand
    --(the priority here is not currently needed BUT if I ever need to use daybreak as DW offhand for other stuff, put shield at higher priority to bump it out of offhand before mainhanding it)
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main={name="Daybreak", priority=10},sub={name='Ammurapi Shield', priority=9}})

    -- Precast sets to enhance JAs
    sets.precast.JA.Nightingale = {feet=gear.RelicFeet}
    sets.precast.JA.Troubadour = {body=gear.RelicBody}
    sets.precast.JA['Soul Voice'] = {legs=gear.RelicLegs}


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    --DT: 29 from 4xNyame + 7 pdt from relic body + 5 from alabaster = 41 pdt / 39 mdt
    --putting 10 PDT on the SB cape caps me and lets me use Sroda Ring over Murky Ring cause either way I'd need Shell V to be MDT capped
    sets.precast.WS = {
        range=gear.Linos.WS,
        head="Nyame Helm", --7 dt
        body=gear.RelicBody, --7 PDT (0 mdt!)
        hands="Nyame Gauntlets", --7 dt
        legs="Nyame Flanchard", --8 dt
        feet="Nyame Sollerets", --7 dt
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Alabaster Earring", --5 dt
        right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring",
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.Savage, --sure, sb by default, str good stat
        }

    --this is the Naegling ws
    --40 str, 40 mnd, fotia good
    --DT: 29 from 4xNyame + 7 pdt from relic body + 5 from alabaster + 10 pdt from cape = 51 pdt / 39 mdt (caps with shell V)
    sets.precast.WS['Savage Blade'] = {
        range=gear.Linos.WS,
        head="Nyame Helm", --7 dt
        body=gear.RelicBody, --7 PDT
        hands="Nyame Gauntlets", --7 dt
        legs="Nyame Flanchard", --8 dt
        feet="Nyame Sollerets", --7 dt
        neck="Rep. Plat. Medal",
        waist="Sailfi Belt +1",
        left_ear="Alabaster Earring", --5 dt
        right_ear="Regal Earring", --until I get Hoxne Earring, and consider not using Alabaster here?
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring",
        back=gear.AmbuCape.Savage, --10 pdt
        }

    --this is the Carnwenhan WS
    --70 chr, 30 dex, fotia bad, multihit probably good idk, tp bonus increases chance of movement speed decrease?! (NIXON: (Muttering) Jesus Christ.)
    sets.precast.WS['Mordant Rime'] = { 
        range=gear.Linos.WS,
        head="Nyame Helm", --7 dt
        body=gear.RelicBody, --7 PDT (0 mdt!)
        hands="Nyame Gauntlets", --7 dt
        legs="Nyame Flanchard", --8 dt
        feet="Nyame Sollerets", --7 dt
        neck="Bard's Charm +2",
        waist="Sailfi Belt +1",
        left_ear="Alabaster Earring", --5 dt
        right_ear="Regal Earring",
        left_ring="Cornelia's Ring",
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.MordantRime,
        }

    --this is the Twashtar WS
    --80 dex, multihit good, fotia apparently not good
    sets.precast.WS['Rudra\'s Storm'] = {
        range=gear.Linos.WS,
        head="Nyame Helm", --7 dt
        body=gear.RelicBody, --7 PDT (0 mdt!)
        hands="Nyame Gauntlets", --7 dt
        legs="Nyame Flanchard", --8 dt
        feet="Nyame Sollerets", --7 dt
        neck="Bard's Charm +2", --quad attack lmao, does this really beat fotia gorget?
        waist="Kentarch Belt +1", --haha stat go brr
        left_ear="Alabaster Earring", --5 dt
        right_ear="Moonshade Earring", --left_ear="Mache Earring +1", --apparently?
        left_ring="Cornelia's Ring",
        right_ring="Murky Ring", --10 dt not necessary lmao
        back=gear.AmbuCape.Rudras, --yay dex
        }

    --this is the Tauret WS
    --honestly, this is never happening, so I won't bother wasting time to define it
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        range=gear.Linos.TP, --wsd less important than multiattack
        right_ring="Ilabrat Ring",
        })

    --this is the Aeneas WS
    --73-85 agi (merits), ftp replicating (fotia good)
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        range=gear.Linos.TP, --wsd less important than multiattack
        right_ear="Telos Earring", --see above note
        })


    --honestly, probably more real than at least one WS above, and all the mab pieces are just things I have for COR anyway
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        --back="Argocham. Mantle", --if have a mab cape, put it here, otherwise don't bother with whatever this is
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --in general, keep fc for recast benefits (sorry about lack of dt, not sorry)
    sets.midcast.FastRecast = sets.precast.FC

    --this is not real, at least not yet
    sets.midcast.SpellInterrupt = {
        --ammo="Staunch Tathlum +1", --11
        --body="Ros. Jaseran +1", --25
        --hands=gear.Chironic_WSD_hands, --20
        --legs="Querkening Brais" --15
        --neck="Loricate Torque +1", --5
        --left_ear="Halasz Earring", --5
        --right_ear="Magnetic Earring", --8
        --right_ring="Evanescence Ring", --5
        --waist="Rumination Sash", --10
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Gear to enhance certain classes of songs.
    sets.midcast.Carol = {hands="Mousai Gages +1"}
    sets.midcast.HonorMarch = {range="Marsyas", hands=gear.EmpyHands}
    sets.midcast.Lullaby = {body=gear.EmpyBody, hands=gear.AFHands}
    sets.midcast.Madrigal = {head=gear.EmpyHead, feet=gear.EmpyFeet}
    sets.midcast.March = {hands=gear.EmpyHands}
    sets.midcast.Minuet = {body=gear.EmpyBody}
    sets.midcast.Paeon = {head=gear.AFHead}
    sets.midcast.Prelude = {feet=gear.EmpyFeet}
    sets.midcast.Threnody = {body="Mou. Manteel +1"} --20 resist and 10 meva extra taken away from target
    sets.midcast['Adventurer\'s Dirge'] = {range="Marsyas"} --for some reason there were also relic hands in this set - why, to avoid buffing duration?
    sets.midcast['Foe Sirvente'] = {head=gear.RelicHead}
    sets.midcast["Sentinel's Scherzo"] = {feet=gear.EmpyFeet}
    sets.midcast["Chocobo Mazurka"] = {range="Marsyas"} --this is probably for range? horns are loud strings are soft, right?

    --ones that I don't care about
    --sets.midcast.Ballad = {legs=gear.EmpyLegs} --this makes you lose duration from ambu pants so it's a bad idea because that messes with song overwriting, apparently
    --sets.midcast.Etude = {head="Mousai Turban +1"} --not going with -1 inventory for +4 stat
    --sets.midcast.Mambo = {feet="Mou. Crackows +1"} --lol evasion song, inventory
    --sets.midcast.Minne = {legs="Mou. Seraweels +1"} --inventory
    --sets.midcast['Magic Finale'] = {legs=gear.EmpyLegs} --there is no reason for this that I can tell - to have dt because no other stat matters?
    
    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEnhancing = {
        main="Carnwenhan",
        range="Gjallarhorn",
        head=gear.EmpyHead,
        body=gear.EmpyBody,
        hands=gear.EmpyHands,
        legs="Inyanga Shalwar +2",
        feet=gear.AFFeet,
        neck="Mnbw. Whistle +1",
        left_ear="Alabaster Earring",
        right_ear="Fili Earring +1", --8 dt, 15 singing skill
        left_ring="Moonlight Ring", --only 5 dt
        right_ring="Murky Ring", --10 dt
        --waist="Plat. Mog. Belt", --blood aggro will drive me insane, figure out what actually goes here
        back=gear.AmbuCape.MAcc, --good enough
        }

    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongEnfeeble = {
        main="Carnwenhan",
        sub="Ammurapi Shield",
        range="Gjallarhorn",
        head=gear.AFHead,
        body=gear.AFBody,
        hands=gear.AFHands,
        legs="Inyanga Shalwar +2",
        feet=gear.AFFeet,
        neck="Mnbw. Whistle +1",
        left_ear="Regal Earring",
        right_ear="Fili Earring +1",
        left_ring="Metamor. Ring +1",
        right_ring={name="Stikini Ring +1", bag="wardrobe2"},
        waist="Acuity Belt +1",
        back=gear.AmbuCape.MAcc,
        }

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.SongEnfeebleAcc = set_combine(sets.midcast.SongEnfeeble, {}) --this had AF Legs, but it's only 13 more macc to swap that+regal ear and that isn't worth -1 inv

    --For NOTHING BUT Horde Lullaby maxiumum AOE range. String skill breakpoints: 6, 7, 8 yalms at 486, 567, 648. (last one requires ML46+Hoxne, no thanks)
    --425 base with merits, 1 skill per ML. want 567, this set is 111 for 536 before MLs, need ML29 => go to 30 and call it good. (this is all +4 reforged AF/Relic in skill math)
    sets.midcast.SongStringSkill = {
        main="Kali", --10 (10) --alternatively to the below, can Carnwenhan here instead if I truly want to
        --sub="Kali", --10, inventory
        range="Daurdabla", --20 (30)
        head=gear.AFHead, --14 (44)
        body=gear.AFBody, --15 (59)
        hands=gear.RelicHands, --lullaby +2
        legs="Inyanga Shalwar +2", --duration, but can put macc here instead if needed?
        feet=gear.RelicFeet, --16 (75)
        waist="Harfner's Sash", --5 (80) --can ditch this at ML39
        back=gear.AmbuCape.MAcc, --"Erato's Cape" 4 skill and never want to have to get that
        left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8 (88)
        right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --8 (96)
        left_ear="Gersemi Earring", --10 (106)
        right_ear="Darkside Earring", --5 (111) --can ditch this at ML34
        }

    -- Placeholder song; minimize duration to make it easy to overwrite.
    sets.midcast.SongPlaceholder = set_combine(sets.midcast.SongEnhancing, {main="Tauret", range=info.ExtraSongInstrument}) --loses duration from Carnwenhan to be lower duration guaranteed

    -- Other general spells and classes.
    --this has no respect for inventory space
    sets.midcast.Cure = {
        main="Daybreak", --30
        sub="Ammurapi Shield",
        --head="Kaykaus Mitra +1", --11
        --body="Kaykaus Bliaut +1", --(+4)/(-6)
        --hands="Kaykaus Cuffs +1", --11(+2)/(-6)
        --legs="Kaykaus Tights +1", --11/(+2)/(-6)
        --feet="Kaykaus Boots +1", --11(+2)/(-12)
        neck="Incanter's Torque",
        --waist="Bishop's Sash",
        --left_ear="Beatific Earring",
        --right_ear="Meili Earring",
        --left_ring="Menelaus's Ring",
        --right_ring="Haoma's Ring",
        --back="Solemnity Cape", --7
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        --neck="Nuna Gorget +1",
        waist="Luminary Sash",
        left_ring={name="Stikini Ring +1", bag="wardrobe1"},
        right_ring="Metamor. Ring +1",
        })

    sets.midcast.StatusRemoval = {
        --head="Vanya Hood",
        --body="Vanya Robe",
        --legs="Aya. Cosciales +2", --is this just dt?
        --feet="Vanya Clogs",
        neck="Incanter's Torque",
        --waist="Bishop's Sash",
        --right_ear="Meili Earring",
        --left_ring="Menelaus's Ring",
        --right_ring="Haoma's Ring",
        back=gear.AmbuCape.MAcc,
        }

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {})

    --...actually, I do have RDM telchine stuff
    sets.midcast['Enhancing Magic'] = {
        main="Carnwenhan",
        sub="Ammurapi Shield",
        head=gear.TelchineHead,
        body=gear.TelchineBody,
        --hands=gear.Telchine_ENH_hands,
        legs=gear.TelchineLegs,
        --feet=gear.Telchine_ENH_feet,
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Mimir Earring",
        right_ear="Andoaa Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe1"},
        right_ring={name="Stikini Ring +1", bag="wardrobe2"},
        --back="Fi Follet Cape +1", --inventory
        }

    sets.midcast.Haste = sets.midcast['Enhancing Magic']
    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    sets.midcast['Enfeebling Magic'] = {
        main="Carnwenhan",
        sub="Ammurapi Shield",
        head=gear.AFHead,
        body=gear.AFBody, --"Cohort Cloak +1", --brd isn't on crep cloak, huh. oh well. too lazy to +1 this, the A in AF is for Accuracy, etc
        hands=gear.AFHands,
        legs=gear.EmpyLegs, --AF legs are marginally superior but Regal Earring maxes out the set bonus so it's -1 inventory slot for 3 macc on spells I never cast anyway
        feet=gear.AFFeet,
        neck="Mnbw. Whistle +1",
        waist="Acuity Belt +1",
        left_ear="Regal Earring",
        right_ear="Fili Earring +1",
        left_ring="Kishar Ring",
        right_ring="Metamor. Ring +1",
        back="Aurist's Cape +1", --currently in wardrobe 3
        }

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield", })

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    --dt capped
    sets.idle = {
        range="Daurdabla", --should this be a horn? think it doesn't matter at all
        head="Null Masque", --10 dt (also regen/regain) (10) (1 dt more on empy +3 but I like regen and regain)
        body="Nyame Mail", --9 dt (19)
        hands="Bunzi's Gloves", --8 dt (27) (3 dt more on empy +3, swap when I make it for more meva)
        legs="Nyame Flanchard", --8 dt (35) (5 dt more on empy +3 but inventory)
        feet="Nyame Sollerets", --7 dt (42)
        neck="Warder's Charm +1", --elemental resistance/magic absorb
        waist="Carrier's Sash", --elemental resistance, plat mog belt has meva
        left_ear="Alabaster Earring", -- 5 DT (47)
        right_ear="Fili Earring +1", --5 DT (52, capped)
        left_ring="Shneddick Ring +1", --movespeed
        right_ring="Shadow Ring", --magic absorb
        back="Null Shawl", --meva
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Set -------------------------------------------
    ------------------------------------------------------------------------------------------------

    --42 dt. melee DT options are thin on the ground, and switching one Moonlight to Murky doesn't fix it on its own so I'm not gonna bother
    --TODO: CHECK WHETHER THE MOONLIGHT RINGS SET OFF BLOOD AGGRO WHEN GOING IDLE -> ENGAGED OR ENGAGED -> WS -> ENGAGED (yes, I'm worried lol)
    sets.engaged = {
        range=gear.Linos.TP,
        head="Bunzi's Hat", --7 dt (7)
        body="Ashera Harness", --7 dt (14)
        hands="Bunzi's Gloves", --8 dt (22)
        legs="Volte Tights",
        feet="Volte Spats",
        neck="Bard's Charm +2",
        waist="Sailfi Belt +1",
        left_ear="Alabaster Earring", --5 dt (27)
        right_ear="Telos Earring",
        left_ring={name="Moonlight Ring", bag="wardrobe1"}, --5 dt (32)
        right_ring={name="Moonlight Ring", bag="wardrobe2"}, --5 dt (37)
        back=gear.AmbuCape.TP, --5 dt (42)
        }


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.SongDWDuration = {main="Carnwenhan",} --sub="Kali"} --carnwenhan should be sufficient duration on its own imo, inventory

    --for cursna received/holy water received. inevntory space etc.
    sets.buff.Doom = {
        --neck="Nicander's Necklace", --20
        --left_ring={name="Eshmun's Ring", bag="wardrobe5"}, --20
        --right_ring={name="Eshmun's Ring", bag="wardrobe6"}, --20
        --waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    
    sets.Carnwenhan = {main="Carnwenhan", sub="Crepuscular Knife"} --is this actually Gleti's? I have no idea
    sets.Twashtar = {main="Twashtar", sub="Centovente"} --is this always Centovente?
    sets.Tauret = {main="Tauret", sub="Crepuscular Knife"} --also not sure
    sets.Naegling = {main="Naegling", sub="Centovente"} --this one I'm pretty sure on at least!

    sets.DefaultShield = {sub="Ammurapi Shield"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        --[[ Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then

            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end]]
        if spell.name == 'Honor March' then
            equip({range="Marsyas"})
        end
        if string.find(spell.name,'Lullaby') then
            if buffactive.Troubadour then
                equip({range=info.LullabyMaxDuration})
            elseif state.LullabyMode.value == 'Harp' and spell.english:contains('Horde') then
                equip({range=info.LullabyHarp})
            else
                equip({range=info.LullabyHorn})
            end
        end
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        -- layer general gear on first, then let default handler add song-specific gear.
        local generalClass = get_song_class(spell)
        if generalClass and sets.midcast[generalClass] then
            equip(sets.midcast[generalClass])
        end
        if spell.name == 'Honor March' then
            equip({range="Marsyas"})
        end
        if string.find(spell.name,'Lullaby') then
            if buffactive.Troubadour then
                equip(sets.LullabyMaxDuration)
            elseif state.LullabyMode.value == 'Harp' and spell.english:contains('Horde') then
                equip({range=info.LullabyHarp})
                equip(sets.midcast.SongStringSkill)
            else
                equip({range=info.LullabyHorn})
            end
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if player.status ~= 'Engaged' and (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
            equip(sets.SongDWDuration)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:contains('Lullaby') and not spell.interrupted then
        get_lullaby_duration(spell)
    end
    if player.status ~= 'Engaged' then
        check_weaponset()
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

    check_weaponset()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'SongEnfeebleAcc'
        else
            return 'SongEnfeeble'
        end
    elseif state.SongMode.value == 'Placeholder' then
        return 'SongPlaceholder'
    else
        return 'SongEnhancing'
    end
end

function get_lullaby_duration(spell)
    local self = windower.ffxi.get_player()

    local troubadour = false
    local clarioncall = false
    local soulvoice = false
    local marcato = false

    for i,v in pairs(self.buffs) do
        if v == 348 then troubadour = true end
        if v == 499 then clarioncall = true end
        if v == 52 then soulvoice = true end
        if v == 231 then marcato = true end
    end

    local mult = 1

    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Marsyas" then mult = mult + 0.5 end

    if player.equipment.main == "Carnwenhan" then mult = mult + 0.5 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.main == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.neck == "Mnbw. Whistle" then mult = mult + 0.2 end
    if player.equipment.neck == "Mnbw. Whistle +1" then mult = mult + 0.3 end
    if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
    if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
    if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
    if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end
    if player.equipment.hands == 'Brioso Cuffs +1' then mult = mult + 0.1 end
    if player.equipment.hands == 'Brioso Cuffs +2' then mult = mult + 0.1 end
    if player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.2 end

    --JP Duration Gift
    if self.job_points.brd.jp_spent >= 1200 then
        mult = mult + 0.05
    end

    if troubadour then
        mult = mult * 2
    end

    if spell.en == "Foe Lullaby II" or spell.en == "Horde Lullaby II" then
        base = 60
    elseif spell.en == "Foe Lullaby" or spell.en == "Horde Lullaby" then
        base = 30
    end

    totalDuration = math.floor(mult * base)

    -- Job Points Buff
    totalDuration = totalDuration + self.job_points.brd.lullaby_duration
    if troubadour then
        totalDuration = totalDuration + self.job_points.brd.lullaby_duration
        -- adding it a second time if Troubadour up
    end

    if clarioncall then
        if troubadour then
            totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2 * 2)
            -- Clarion Call gives 2 seconds per Job Point upgrade.  * 2 again for Troubadour
        else
            totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2)
            -- Clarion Call gives 2 seconds per Job Point upgrade.
        end
    end

    if marcato and not soulvoice then
        totalDuration = totalDuration + self.job_points.brd.marcato_effect
    end

    -- Create the custom timer
    if spell.english == "Foe Lullaby II" or spell.english == "Horde Lullaby II" then
        send_command('@timers c "Lullaby II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00377.png')
    elseif spell.english == "Foe Lullaby" or spell.english == "Horde Lullaby" then
        send_command('@timers c "Lullaby ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00376.png')
    end
end


function check_gear()

    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("left_ring")
    else
        enable("left_ring")
    end


    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("right_ring")
    else
        enable("right_ring")
    end

end

function check_weaponset()

    equip(sets[state.WeaponSet.current])

    --overwrite DW offhand weapon when not DWing
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
        equip(sets.DefaultShield)
    end

end

windower.register_event('zone change',function()

        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("left_ring")
            equip(sets.idle)
        end

        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("right_ring")
            equip(sets.idle)
        end

    end
)
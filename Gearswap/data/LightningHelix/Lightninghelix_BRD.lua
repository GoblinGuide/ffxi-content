-- Original: Motenten / Modified: Arislan / Gutted: me :)
--todo: confirm equipping two stikini ring +1s in same wardrobe works properly. if not, update this, and rdm, and blu
--todo: finish burning this to the ground, figure some stuff out, you know how it is
--figure out if I'm gonna get the stupid prime

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--F10:            Cycle through weapon sets

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[

    --TODO: FIGURE OUT ALL THIS SHIT EVENTUALLY
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

    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'

    -- How many extra songs we can keep from Daurdabla/Terpander
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
    gear.Linos.TP = {range={ name="Linos", augments={'Accuracy+20','"Store TP"+4','Quadruple Attack +3',}},}
    gear.Linos.WS = {range={ name="Linos", augments={'Attack+20','Weapon skill damage +3%','STR+6 DEX+6',}},} --never gonna make TWO of these lmao
    
    gear.AmbuCape = {}
    gear.AmbuCape.Savage = {} --str
    gear.AmbuCape.Rudras = {} --dex
    gear.AmbuCape.TP = {}
    gear.AmbuCape.MAcc = {}

    gear.TelchineHead = { name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}}
	gear.TelchineBody = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}}
	gear.TelchineLegs = { name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}}

    gear.AFHead = {name="Brioso Roundlet +3"} --macc (+15 per piece of set / regal ear in addition to what's on here natively)
    gear.AFBody = {name="Brioso Justaucorps +3"} --macc
    gear.AFHands = {name="Brioso Cuffs +3"} --lullaby only, really
    gear.AFLegs = {name="Brioso Cannions +3"} --macc, 8 dt
    gear.AFFeet = {name="Brioso Slippers+2"} --15 song duration also macc
    gear.RelicHead = {name="Bihu Roundlet +3"} --unused, ws piece that doesn't beat nyame
    gear.RelicBody = {name="Bihu Justaucorps +3"} --ws piece at +4, troubadour augment
    gear.RelicHands = {name="Bihu Cuffs +3"} --unused
    gear.RelicLegs = {name="Bihu Cannions +3"} --soul voice duration
    gear.RelicFeet = {name="Bihu Slippers +3"} --nightingale duration, string skill
    gear.EmpyHead = {name="Fili Calot +2"} --madrigal
    gear.EmpyBody = {name="Fili Hongreline +2"} --minuet, 14 duration
    gear.EmpyHands = {name="Fili Manchettes +2"} --march, 11 dt
    gear.EmpyLegs = {name="Fili Rhingrave +2"} --ballad, 13 dt, not actually good for ballad to keep duration working with overwriting
    gear.EmpyFeet = {name="Fili Cothurnes +2"} --fast cast. not a joke, somehow. 10 at +2 -> 13 at +3

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

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
    --Sroda Ring is a lot of stat but I actively want 50 dt in all my sets so I don't have it
    --DT: 29 from 4xNyame + 7 pdt from relic body + 5 from alabaster = 41 pdt / 39 mdt
    --putting 10 PDT on the SB cape caps me and lets me use Sroda Ring over Murky Ring cause either way I'd need Shell V to be MDT capped
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck="Rep. Plat. Medal",
        waist="Sailfi Belt +1",
        right_ear="Regal Earring", --over Ishvara, apparently, since Moonshade's no good
        right_ring="Sroda Ring",
        back=gear.AmbuCape.Savage, --this is in my default set above, but I'm confirming it here too
        })

    --this is the Twashtar WS
    --80 dex, multihit good, fotia good
    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        feet="Nyame Sollerets",
        neck="Bard's Charm +2",
        --waist="Kentarch Belt +1", --10 dex + da, if this ws is that good this is worth it
        --left_ear="Mache Earring +1",
        back=gear.AmbuCape.Rudras, --yay dex
        })

    --this is the Carnwenhan WS
    --70 chr, 30 dex, fotia bad, multihit probably good idk whatever
    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS, { 
        neck="Bard's Charm +2",
        left_ear="Regal Earring",
        waist="Sailfi Belt +1",
        back=gear.AmbuCape.MordantRime,
        })


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
        --back="Argocham. Mantle", --what even is this? if we have a mab cape, put it here, otherwise don't bother
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --in general, keep fc for recast benefits (sorry about lack of dt, not sorry)
    sets.midcast.FastRecast = sets.precast.FC

    --this is not real
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
    --likely I won't have to ever change any of this unless they drop some really hot new items
    --sets.midcast.Ballad = {legs=gear.EmpyLegs} --this makes you lose duration from ambu pants so it's a bad idea because that messes with song overwriting, apparently
    sets.midcast.Carol = {hands="Mousai Gages +1"}
    --sets.midcast.Etude = {head="Mousai Turban +1"} --not going with -1 inventory for +4 stat
    sets.midcast.HonorMarch = {range="Marsyas", hands=gear.EmpyHands}
    sets.midcast.Lullaby = {body=gear.EmpyBody, hands=gear.AFHands}
    sets.midcast.Madrigal = {head=gear.EmpyHead, feet=gear.EmpyFeet}
    --sets.midcast.Mambo = {feet="Mou. Crackows +1"} --lol evasion song
    sets.midcast.March = {hands=gear.EmpyHands}
    sets.midcast.Minne = {legs="Mou. Seraweels +1"}
    sets.midcast.Minuet = {body=gear.EmpyBody}
    sets.midcast.Paeon = {head=gear.AFHead}
    sets.midcast.Prelude = {feet=gear.EmpyFeet}
    sets.midcast.Threnody = {body="Mou. Manteel +1"} --is this real? it's -20 resist -10 meva? seems real
    sets.midcast['Adventurer\'s Dirge'] = {range="Marsyas"} --for some reason there were relic hands in this set and I don't know why, I think it was some kind of placeholder thing to avoid buffing duration?
    sets.midcast['Foe Sirvente'] = {head=gear.RelicHead}
    sets.midcast['Magic Finale'] = {legs=gear.EmpyLegs}
    sets.midcast["Sentinel's Scherzo"] = {feet=gear.EmpyFeet}
    sets.midcast["Chocobo Mazurka"] = {range="Marsyas"} --this is probably for range? string has bigger range, right?

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
        --waist="Plat. Mog. Belt", --blood aggro will drive me insane
        back=gear.AmbuCape.MAcc, --think this is the one I want, will confirm someday
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
    sets.midcast.SongEnfeebleAcc = set_combine(sets.midcast.SongEnfeeble, {legs="Brioso Cannions +3"})

    -- For Horde Lullaby maxiumum AOE range.
    sets.midcast.SongStringSkill = {
        left_ear="Gersemi Earring",
        right_ear="Darkside Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe1"},
        }

    -- Placeholder song; minimize duration to make it easy to overwrite.
    sets.midcast.SongPlaceholder = set_combine(sets.midcast.SongEnhancing, {range=info.ExtraSongInstrument})

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
        --legs="Aya. Cosciales +2",
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
        body=gear.AFBody, --"Cohort Cloak +1", --brd isn't on crep cloak, huh. oh well. too lazy to farm. the A in AF is for Accuracy anyway
        hands=gear.AFHands,
        legs=gear.AFLegs,
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

    --over DT cap, don't really have anything else to put here though
    sets.idle = {
        range="Gjallarhorn", --not sure why a horn. could maybe have stats of some sort here? no clue what though. staunch tathlum loses tp on swap right?
        head="Nyame Helm", --7 dt
        body="Nyame Mail", --9 dt
        hands="Nyame Gauntlets", --7 dt
        legs="Nyame Flanchard", --8 dt
        feet="Nyame Sollerets", --7 dt
        neck="Null Loop", -- 5 dt (I could put a Warder's Charm +1 here if I ever farm one)
        waist="Carrier's Sash",
        left_ear="Alabaster Earring", -- 5 DT
        right_ear="Eabani Earring", --still the best I got
        left_ring="Shneddick Ring +1", --movespeed
        right_ring="Murky Ring", --10 DT
        back=gear.AmbuCape.TP, --assuming 5 dt. --"Moonlight Cape" has 6 dt but 275 HP that's so much omg
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Set -------------------------------------------
    ------------------------------------------------------------------------------------------------

    --42 dt. melee DT options are thin on the ground, and switching one Moonlight to Murky doesn't fix it on its own so I'm not gonna bother
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

    sets.SongDWDuration = {main="Carnwenhan", sub="Kali"}

    sets.buff.Doom = {
        --neck="Nicander's Necklace", --20
        --left_ring={name="Eshmun's Ring", bag="wardrobe5"}, --20
        --right_ring={name="Eshmun's Ring", bag="wardrobe6"}, --20
        --waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    
    sets.Carnwenhan = {main="Carnwenhan", sub="Gleti's Knife"} --is this actually Gleti's? I have no idea
    sets.Twashtar = {main="Twashtar", sub="Centovente"} --is this always Centovente?
    sets.Tauret = {main="Tauret", sub="Gleti's Knife"} --so many questions
    sets.Naegling = {main="Naegling", sub="Centovente"} --this one I'm pretty sure on at least, I guess

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
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
        equip(sets.DefaultShield)
    elseif player.sub_job == 'NIN' and player.sub_job_level < 10 or player.sub_job == 'DNC' and player.sub_job_level < 20 then
        equip(sets.DefaultShield)
    end
end

windower.register_event('zone change',
    function()
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
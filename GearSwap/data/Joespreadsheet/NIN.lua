-- Original: Motenten / Modified: Arislan / gutted: DACK (just using it for Abyssea procs)
--todo: make sure this is good now that it's Joe and not Helix

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
    
    include('Mote-TreasureHunter')
    
    --202407904 replaced "gs c cycle treasuremode" with "gs c set treasuremode Tag" (to always turn on th tag mode when we switch to ninja, because I only use it for abyssea proccing)
	windower.send_command('gs c set treasuremode Tag')

end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

	--fc hat
    gear.HercHelmFC = { name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+6','"Mag.Atk.Bns."+12',}}
    
    --quick stopgap until Volte Jupon
    gear.HercBootsTH = { name="Herculean Boots", augments={'Enmity-2','"Mag.Atk.Bns."+6','"Treasure Hunter"+2',}}

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--as much as I have that NIN can wear
    sets.precast.FC = {
        head=gear.HercHelmFC,
        body="Adhemar Jacket +1", --10 and I use it for cor lmao
        --hands="Leyline Gloves", --8
        neck="Orunmila's Torque", --5
        --left_ear="Etiolation Earring", --1 --inventory
        right_ear="Loquacious Earring", --2
        left_ring="Prolix Ring", --2
        --right_ring="Kishar Ring", --4
        }
	
    --testing, testing... this still doesn't seem to be working
    sets.precast.FC.ElementalNinjutsu = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --hmm. if I'm casting on ninja I just want to be fast, right?
    sets.midcast = sets.precast.FC
    sets.midcast.FastRecast = sets.precast.FC
    sets.midcast.Ninjutsu = sets.precast.FC
    sets.midcast.ElementalNinjutsu = sets.precast.FC
    

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--deliberately blank, so that when I'm trying to Abyssea proc I don't kill the target
    sets.precast.WS = {}
        
    --if I'm using this I actually want to do damage
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
	    left_ear="Moonshade Earring",
        right_ear="Odr Earring", --wev
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring",
        back="Null Shawl",
	    })

    --someday maybe who cares blah blah
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Savage Blade'], {
    neck="Fotia Gorget", --let's try this over "Sibyl Scarf", --see if the ftp improvevment makes me oneshot those stupid marids at 1000 tp
    waist="Orpheus's Sash", --affinity
    right_ear="Friomisi Earring", --mab
    right_ring="Dingir Ring", --mab
    })
    
    --if I'm using this I actually want to heal myself and thus do damage
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Aeolian Edge'],
        {
        head="Pixie Hairpin +1", --28% (stacks w/archon+sash)
        right_ring="Archon Ring", --5% (stacks w/pixie+sash) (beats the dingir mab I think)
        })	

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--no optimization at all. big ol DT, some TP in other slots.
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Null Loop", --"Combatant's Torque", --whatever
		waist="Sailfi Belt +1", --gear haste to counteract 15% slow from Atma of the Sea Daughter if I'm in Abyssea, also DA etc
        left_ear="Alabaster Earring", --dt and gear haste
        right_ear="Dedition Earring",
        left_ring="Epona's Ring",
        right_ring="Ilabrat Ring",
        back="Null Shawl", --thank god, all jobs
        }

    ------------------------------------------------------------------------------------------------
    --------------------------------------- Idle Set, Singular -------------------------------------
    ------------------------------------------------------------------------------------------------

	--whatever, dt capped with nyame
    sets.idle = { 
	--ammo="Coiste Bodhar", --update no weapons specified here, that's only changed by engaged sets
    head="Malignance Chapeau", --"Null Masque"
    body="Malignance Tabard", --"Nyame Mail"
    hands="Malignance Gloves", --"Nyame Gauntlets"
    legs="Malignance Tights", --"Nyame Flanchard"
    feet="Malignance Boots", --"Nyame Sollerets"
	neck="Null Loop", --"Warder's Charm +1",
	waist="Carrier's Sash",
    left_ear="Alabaster Earring",
    right_ear="Eabani Earring",
    left_ring="Shneddick Ring +1",
	right_ring="Murky Ring", --want to dt cap for sure
	back="Null Shawl",
	}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    
    --TH 2+2 until jupon functional
	sets.TreasureHunter = {
        feet=gear.HercBootsTH,
        left_ring="Hoxne Ring",
		}

end

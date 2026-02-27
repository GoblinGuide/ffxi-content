--this is just my rdm gearswap but gutted so I have fast cast swaps and a dt engaged set for farming skillups

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
	
	--20230522 test putting this in job underscore setup, looks like it works just fine to toggle me into tag mode and then never have to sweat it
    --20240704 replaced "gs c treasuremode cycle" with "gs c set treasuremode Tag"
	windower.send_command('gs c set treasuremode Tag')

    lockstyleset = 1
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--non-thf TH cap is 4
    sets.TreasureHunter = {
	}
	
    --80 cap, none natively
    sets.precast.FC = {
	head="Amalric Coif +1", --11 (11)
    body="Zendik Robe", --13 (24)
    hands={ name="Merlinic Dastanas", augments={'Attack+9','"Fast Cast"+7','"Mag.Atk.Bns."+4',}}, --7 (31)
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','"Fast Cast"+7','DEX+6','Mag. Acc.+6','"Mag.Atk.Bns."+2',}}, --7 (38)
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+12','"Fast Cast"+7','INT+8',}}, --7 (45)
	left_ear="Loquac. Earring", --2 (47)
	right_ear="Malignance Earring", --4 (51)
	left_ring="Kishar Ring", --4 (55)
	right_ring="Prolix Ring",  --2 (57)
    waist="Embla Sash", --5 (61)
    neck="Orunmila's Torque", --5 (66)
	back="Perimede Cape", --4 occ
	}

    --testing
    sets.precast['Impact'] = set_combine(sets.precast.FC, {head=empty,body='Crepuscular Cloak'})
    sets.precast.Impact = sets.precast['Impact'] --test
    sets.precast.FC.Impact = sets.precast['Impact'] --think this is the one that ended up working, too lazy to care
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--look I don't have real ws gear for goddamn GEOMANCER so we'll make do
    sets.precast.WS = {
	--ammo="Oshasha's Treatise", --we have bell
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
	left_ring="Cornelia's Ring",
	right_ring="Murky Ring",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Moonshade Earring", --whatever
    right_ear="Regal Earring",
    back="Aurist's Cape +1",
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
 
    --just defining one, that has MAB in it for nuking, and hopefully that's all
    sets.midcast = {
    head="Nyame Helm",
    body="Nyame Mail", --crep cloak better but no thank you dt
    hands="Nyame Gauntlets", --jhakri a bit better but no thank you, DT
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Sacro Cord", --no clue if skyrmir cord is better (8 mab 8 int 8 macc vs 7 macc 7 mab 35 magic damage)
    left_ring="Freke Ring",
    right_ring="Metamor. Ring +1",
    left_ear="Malignance Earring", --friomisi has 3 higher mab...
    right_ear="Regal Earring", --or 2 higher mab than this, but both of these have int too
    back="Aurist's Cape +1",
    }

    --testing
    sets.midcast['Impact'] = set_combine(sets.midcast, {head=empty,body='Crepuscular Cloak'})
    sets.midcast.Impact = sets.midcast['Impact']
    sets.midcast.Utsusemi = sets.precast.FC --fast recast

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	--PDT/MDT cap is 50
    sets.idle = {
	head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
	neck="Null Loop", --dt
	waist="Plat. Mog. Belt", --dt
	left_ear="Alabaster Earring", --dt
	right_ear="Etiolation Earring", --dt
	left_ring="Shneddick Ring +1", --movespeed
	right_ring="Stikini Ring +1", --1 refresh
	back="Aurist's Cape +1", --meva, better than nothing
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
	head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Combatant's Torque", --stp
	waist="Plat. Mog. Belt", --dt
	left_ear="Odnowa Earring +1", --dt, apparently
    right_ear="Telos Earring", --tp
	left_ring="Chirich Ring +1", --1 refresh
	right_ring="Murky Ring", --dt cap
	back="Aurist's Cape +1", --meh
	}
	

end
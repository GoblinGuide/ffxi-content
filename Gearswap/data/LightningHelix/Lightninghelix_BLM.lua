--this is just my rdm gearswap but gutted so I have fast cast swaps and a dt engaged set for Provenance Watcher Voidwatch procs

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

    --weapon set, used for dual wielding compatibility
    state.WeaponSet = M{['description']='Weapon Set', 'Default'}

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--non-thf TH cap is 4
    sets.TreasureHunter = {
	}
	
    sets.precast.FC = {
	head="Amalric Coif +1", --11
    --legs="Amalric Slops +1", --8 elemental magic recast delay, lmao
	left_ear="Loquac. Earring", --2
	right_ear="Malignance Earring", --4
	left_ring="Weather. Ring +1", --6 + 4 occ
	right_ring="Kishar Ring", --4
    waist="Embla Sash", --5
    neck="Baetyl Pendant", --4
	back="Perimede Cape", --4 occ
	}

	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--have to kill physical fetters, god help me
    sets.precast.WS = {
	ammo="Oshasha's Treatise",
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
	left_ring="Cornelia's Ring",
	right_ring="Epaminondas's Ring",
    left_ear="Moonshade Earring", --only have the one
    waist="Fotia Belt",
    neck="Fotia Gorget",
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
 
    --just use this set, I'm not particularly fussed about more damage unless and until I find out I need it
    sets.midcast = sets.precast.FC

    --yeah ok I want to whammbo the fetters
    sets.midcast['Elemental Magic'] = {
    head="C. Palug Crown",
    body="Amalric Doublet +1",
    hands="Amalric Gages +1",
    legs="Amalric Slops +1",
    feet="Nyame Sollerets", --lmao
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Regal Earring",
    right_ear="Malignance Earring",
    left_ring="Metamor. Ring +1",
    right_ring="Freke Ring",
    back="Aurist's Cape +1",
    }

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.idle = {
    ammo="Impatiens", --meh
	head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
	neck="Loricate Torque +1", --dt
	waist="Plat. Mog. Belt", --dt
	left_ear="Odnowa Earring +1", --dt
	right_ear="Etiolation Earring", --dt
	left_ring="Stikini Ring +1", --1 refresh
	right_ring="Stikini Ring +1", --1 refresh
	back="Perimede Cape" --meh
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --tp gain mostly irrelevant, maximizing dt
    sets.engaged = {
    ammo="Impatiens",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Loricate Torque +1", --dt
    waist="Plat. Mog. Belt", --dt
    left_ear="Odnowa Earring +1", --dt
    right_ear="Etiolation Earring", --dt
    left_ring="Stikini Ring +1", --1 refresh
    right_ring="Defending Ring", --dt
    back="Aurist's Cape +1", --macc
    }

    --by default, this is the engaged set
    sets.Default = {main="Maxentius", sub="Ammurapi Shield"}
    sets.DualWieldWeapons = {main="Maxentius", sub="Bunzi's Rod"}


end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job. (stolen from corsair logic, then reversed)
-------------------------------------------------------------------------------------------------------------------
function job_aftercast(spell, action, spellMap, eventArgs)
    check_weaponset()
end

function check_weaponset()
    equip(sets[state.WeaponSet.current])
 
     if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
         equip(sets.DualWieldWeapons)
     end
 end
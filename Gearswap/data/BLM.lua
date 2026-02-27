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
    --state.WeaponSet = M{['description']='Weapon Set', 'Default'}

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --TH 2+1+1, all items work on all jobs and are i119
	sets.TreasureHunter = {
		body="Volte Jupon", --2
		hands="Volte Bracers", --1
        waist="Chaac Belt", --1
		}
	
    --don't have lots of stuff for this, don't care either
    sets.precast.FC = {
    legs="Volte Brais", --8
	left_ear="Loquac. Earring", --2
	right_ear="Malignance Earring", --4
	left_ring="Prolix Ring", --3
	right_ring="Kishar Ring", --4
    waist="Embla Sash", --5
    neck="Orunmila's Torque", --5
	}

	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--have to kill physical fetters, god help me
    sets.precast.WS = {
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
	head="Null Masque", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
	neck="Sibyl Scarf", --refresh
	waist="Embla Sash", --lmao whatever
	left_ear="Alabaster Earring", --dt
	right_ear="Etiolation Earring", --mdt I guess
	left_ring="Shneddick Ring +1", --movespeed
	right_ring="Stikini Ring +1", --1 refresh
	back="Null Shawl" --meva
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --tp gain, god help me
    sets.engaged = {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Combatant's Torque", 
    --waist="Plat. Mog. Belt", --literally nothing relevant
    left_ear="Alabaster Earring", --gear haste, LOL
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Crepuscular Ring",
    back="Null Shawl",
    }

    --by default, this is the engaged set
    --sets.Default = {main="Maxentius", sub="Ammurapi Shield"}
    --sets.DualWieldWeapons = {main="Maxentius", sub="Bunzi's Rod"}


end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job. (stolen from corsair logic, then reversed)
-------------------------------------------------------------------------------------------------------------------
--function job_aftercast(spell, action, spellMap, eventArgs)
--    check_weaponset()
--end
--
--function check_weaponset()
--    equip(sets[state.WeaponSet.current])
-- 
--     if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
--         equip(sets.DualWieldWeapons)
--     end
--end
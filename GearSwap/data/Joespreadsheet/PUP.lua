--this is just so I have one so I can use gs equip naked to get the puppet to heal me, lol

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
    
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.FC = {}
        
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--not needed for now
    sets.precast.WS = {}
        

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--no optimization at all. big ol DT, some TP in other slots.
    sets.engaged = {
        ranged="Animator",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Null Loop",
		waist="Moonbow Belt +1",
        left_ear="Alabaster Earring",
        right_ear="Schere Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Murky Ring",
        back="Null Shawl",
        }

    ------------------------------------------------------------------------------------------------
    --------------------------------------- Idle Set, Singular -------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = { 
	    ranged="Animator",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
	    neck="Warder's Charm +1",
	    waist="Carrier's Sash",
        left_ear="Alabaster Earring",
        right_ear="Hearty Earring",
        left_ring="Shneddick Ring +1",
	    right_ring="Murky Ring",
	    back="Null Shawl",
	}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    
end

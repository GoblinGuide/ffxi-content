-- Original: Motenten / Modified: Arislan / gutted: DACK
--here's sets https://www.ffxiah.com/forum/topic/52018/luck-of-the-draw-a-corsairs-guide-new#_user-5

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
    
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


	--this is ltierally warrior lmao
    sets.precast.FC = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--base WS set: warrior lmao
    sets.precast.WS = {
        ammo="Coiste Bodhar", 
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
        right_ring="Murky Ring", --10 dt
        --back=gear.AmbuCape.MagicWS, --lol
        }

	------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

	------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--prioritizing multihit for this laughable chaosbringer quest
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Combatant's Torque",
		waist="Sailfi Belt +1", --TA/DA
        left_ear="Telos Earring",
        right_ear="Alabaster Earring", --overcapped on haste, don't care
        left_ring="Chirich Ring +1", --stp I guess
        right_ring="Hetairoi Ring", --sure, triple attack
        back="Null Shawl", --sure
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ DT Sets ---------------------------------------------
    ------------------------------------------------------------------------------------------------

	--waaaay over dt capped, don't care
    sets.idle = {
		ammo="Coiste Bodhar", 
		head="Null Masque", --10 dt (10)
		body="Nyame Mail", --12 dt (22)
		hands="Nyame Gauntlets", --7 dt (29)
		legs="Nyame Flanchard", --8 dt (37)
		feet="Nyame Sollerets", --7 dt (44)
		neck="Warder's Charm", --elemental resist
		waist="Carrier Sash", --elemental resist
        left_ear="Alabaster Earring", --5 dt (49)
		right_ear="Eabani Earring", --15 evasion, the ear slots are awful for idle sets
		left_ring="Shneddick Ring +1", --18 movespeed
		right_ring="Murky Ring", --way over cap who cares (59)
        back="Null Shawl", --50 meva
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --TH 2+1+1 = 4
	sets.TreasureHunter = {
		body="Volte Jupon",
        hands="Volte Bracers",
        waist="Chaac Belt",
		}

end
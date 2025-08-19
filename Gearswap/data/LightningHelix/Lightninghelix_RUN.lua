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

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


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
		

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    --all WS sets have as close to 50 DT as I could get because I got sick of dying, lol, lmao
    --relevant numbers: Nyame is 7 9 7 8 7 = 38. plus dring is 48, plus either odnowa earring +1 or a,bu cape is capped

	--base WS set: if not defined, Nyame, etc.
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
        right_ring="Defending Ring", --10 dt
        --back=gear.AmbuCape.MagicWS, --we ain't got no capes on RUN
        }

	sets.precast.WS['Savage Blade'] = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
		body="Nyame Mail", --DT
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal", 
		waist="Sailfi Belt +1",
		left_ear="Ishvara Earring", --lmao storage
        right_ear=gear.Moonshade,
        left_ring="Cornelia's Ring", --10 wsd seems fine
        right_ring="Defending Ring", --10 dt
        --back=gear.AmbuCape.PhysWS,
        }

    sets.precast.WS['Dimidiation'] = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
		body="Nyame Mail", --DT
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal", 
		waist="Sailfi Belt +1",
		left_ear="Ishvara Earring", --lol storage
        right_ear=gear.Moonshade,
        left_ring="Ilabrat Ring", --removing the dring DT I might need the damage
        right_ring="Regal Ring", --stats?
        --back=gear.AmbuCape.PhysWS,
        }



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

	------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--this is run idgaf just do what looks best
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
		body="Ashera Harness",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Anu Torque", --had to drag this out of storage lmao
		waist="Reiki Yotai", --the 4 stp lol
        left_ear="Telos Earring",
        right_ear="Sherida Earring", 
        left_ring="Ilabrat Ring", --run is on the weirdest stuff, I swear
        right_ring="Defending Ring", --"Epona's Ring", removed for DT
        --back=gear.AmbuCape.TP, --no capes
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ DT Sets ---------------------------------------------
    ------------------------------------------------------------------------------------------------

	--waaaay over dt capped without ambu cape at the moment, cause I swapped in Nyame 8 DT for the movespeed pants I replaced with movespeed ring, so consider meva somewhere here?
    sets.idle = {
		ammo="Coiste Bodhar", 
		head="Nyame Helm", --7 dt (7)
		body="Nyame Mail", --12 dt (19)
		hands="Nyame Gauntlets", --7 dt (26)
		legs="Nyame Flanchard", --8 dt (34)
		feet="Nyame Sollerets", --7 dt (41)
		neck="Loricate Torque +1", --6 dt (47)
		waist="Reiki Yotai", --4 stp lmao, carrier sash is an option for sure?
        left_ear="Odnowa Earring +1", --3 dt (50)
		right_ear="Eabani Earring", --15 evasion, the ear slots are awful for idle sets
		left_ring="Shneddick Ring +1", --18 movespeed
		right_ring="Defending Ring", -- 10 DT (60)
        --back=gear.AmbuCape.Snapshot, --meva, since we're dt capped
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

    --TH 2+2 = 4
	sets.TreasureHunter = {
		body=gear.HercVest.TH,
		feet=gear.HercBoots.TH, 
		}

end
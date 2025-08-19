-- Original: Motenten / Modified: Arislan / gutted: DACK (this was COR and I'm just using it for Abyssea procs)

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
	gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}} --fast cast
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--as much as I got
    sets.precast.FC = {
        body=gear.TaeonTabard, --9
        hands=gear.LeylineGloves, --6
        feet=gear.HercBoots.FC, --6
        neck="Orunmila's Torque", --5
        left_ear="Loquacious Earring", --2
        right_ear="Etiolation Earring", --1
        left_ring="Prolix Ring", --2
        right_ring="Kishar Ring", --4
        }
		
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--deliberately blank, trying to abyssea proc, don't kill the target
    sets.precast.WS = {
        }
        
    --if I'm using this I actually want to do damage
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        --ammo="Oshasha's Treatise",  --removed so I can ra with Aureole to pull
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Odnowa Earring +1",
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        --back=gear.AmbuCape.PhysWS,
        })

    --if I'm using this I actually want to do damage and also default to TH4
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
    --ammo="Oshasha's Treatise", --removed so I can ra with Aureole
    head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
    body=gear.HercVest.TH, --"Nyame Mail", --want to th large crowds
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet=gear.HercBoots.TH, --"Nyame Sollerets",
    neck="Sibyl Scarf", --+10 int -3 mab vs "Baetyl Pendant",
    waist="Orpheus's Sash", --15% max
    left_ear=gear.Moonshade,
    right_ear="Friomisi Earring",
    left_ring="Dingir Ring", --lmao
    right_ring="Cornelia's Ring", --is regal better than this? pretty sure not?
    --back=
    })
 
    --if I'm using this I actually want to heal myself and thus do damage
    sets.precast.WS['Sanguine Blade'] = {
    --ammo="Oshasha's Treatise", --removed so I can ra with Aureole
	head="Pixie Hairpin +1", --28% (stacks w/archon+sash)
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard", 
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",  --int
	waist="Orpheus's Sash", --15% (stacks w/pixie+archon)
    left_ear=gear.Moonshade, --does nothing iirc
    right_ear="Friomisi Earring",
    left_ring="Cornelia's Ring", --10 wsd, eventually with maxed nyame I think this is "Metamor. Ring +1" again, but it might well win back out if I'm ML50
    right_ring="Archon Ring", --5% (stacks w/pixie+sash)
    --back=
	}
	

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--no optimization at all. big ol DT, some TP in other slots.
    sets.engaged = {
        --ammo="Coiste Bodhar", --removed so I can ra with Aureole
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Loricate Torque +1", --to cap
		waist="Reiki Yotai", --this shouldn't be this but also I do not care. at all.
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        left_ring="Chirich Ring +1",
        right_ring="Defending Ring", --dt
        --back=gear.AmbuCape.TP, --I have literally no cape that ninja can wear lmao
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ DT Sets ---------------------------------------------
    ------------------------------------------------------------------------------------------------

	--again, idgaf
    sets.idle = set_combine(sets.engaged,{left_ring="Shneddick Ring +1"})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    --TH 2+2 = 4
	sets.TreasureHunter = {
		body=gear.HercVest.TH,
		feet=gear.HercBoots.TH, 
		}

end

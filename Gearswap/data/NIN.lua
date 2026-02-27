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
    
    --202407904 replaced "gs c treasuremode cycle" with "gs c set treasuremode Tag" (to always turn on th tag mode when we switch to ninja, because I only use it for abyssea proccing)
	windower.send_command('gs c set treasuremode Tag')

end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

	--nobody here but us chickens

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	--as much as I have that NIN can wear
    sets.precast.FC = {
        head="Herculean Helm", --7+6=13, I only have the one so I don't need to disambiguate
        body="Adhemar Jacket +1", --10 and I use it for cor lmao
        hands="Leyline Gloves", --8
        neck="Orunmila's Torque", --5
        --left_ear="Etiolation Earring", --1 --inventory
        right_ear="Loquacious Earring", --2 --preserve 5 gear haste from alabaster, though I think I'm capped, it can't hurt to be sure
        left_ring="Prolix Ring", --2
        right_ring="Kishar Ring", --4
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
        left_ear="Alabaster Earring", --nin can't wear sherida lol
		right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        --back=gear.AmbuCape.PhysWS,
        })

    --if I'm using this I actually want to do damage and also default to TH4
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
    --ammo="Oshasha's Treatise", --removed so I can ra with Aureole
    head="Nyame Helm", --every piece of this has 30 mab for no reason, how lucky
    body="Volte Jupon", --TH
    hands="Volte Bracers", --TH
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget", --let's try this over "Sibyl Scarf", --see if the ftp improvevment makes me oneshot those stupid marids at 1000 tp
    waist="Chaac Belt", --TH over 15% damage hopefully this doesn't bite me in the butt... and it looks like it immediately did, sigh, we'll figure something out, we need the TH
    left_ear="Moonshade Earring", --ftp 2.0 -> 3.0 is not zero improvement from this
    right_ear="Friomisi Earring",
    left_ring="Dingir Ring", --lmao
    right_ring="Cornelia's Ring", --is regal better than this? pretty sure not?
    --back="Null Shawl", 
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
    left_ear="Moonshade Earring", --does nothing iirc
    right_ear="Friomisi Earring",
    left_ring="Cornelia's Ring", --effort
    right_ring="Archon Ring", --5% (stacks w/pixie+sash)
    --back="Null Shawl", 
	}
	

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
        neck="Null Loop", --I think this dt caps, or at least comes close, who cares
		waist="Reiki Yotai", --this shouldn't be this but also I do not care. at all.
        left_ear="Alabaster Earring", --dt capped
        right_ear="Telos Earring", --do I even care about the nin sortie earring? no! am I still sticking to convention? yes!
        left_ring="Chirich Ring +1",
        right_ring="Murky Ring", --dt
        back="Null Shawl", --thank god, all jobs
        }

    ------------------------------------------------------------------------------------------------
    --------------------------------------- Idle Set, Singular -------------------------------------
    ------------------------------------------------------------------------------------------------

	--stolen from thf, dt capped
    sets.idle = { 
	--ammo="Coiste Bodhar", --update no weapons specified here, that's only changed by engaged sets
	head="Null Masque",
    body="Malignance Tabard",
    hands="Nyame Gauntlets",
    legs="Gleti's Breeches",
	feet="Nyame Sollerets",
	neck="Null Loop",
	waist="Carrier's Sash",
    left_ear="Alabaster Earring",
    right_ear="Eabani Earring",
    left_ring="Shneddick Ring +1",
	right_ring="Murky Ring",
	back="Null Shawl",
	}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    
    --TH 2+1+1, all items work on all jobs and are i119
	sets.TreasureHunter = {
		body="Volte Jupon", --2
		hands="Volte Bracers", --1
        waist="Chaac Belt", --1
		}

end

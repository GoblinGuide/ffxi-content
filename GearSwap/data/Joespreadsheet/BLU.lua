-- Original: Motenten / Modified: Arislan / gutted: me :)

--------------------------------------------------------------------------------------------------------------------
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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells
    blue_magic_maps.StunPhysical = S{'Frypan','Head Butt','Sudden Lunge','Tail slap','Whirl of Rage'}
    blue_magic_maps.StunMagical = S{'Blitzstrahl','Temporal Shift','Thunderbolt'}

    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}

    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}

    no_swap_gear = S{"Lizard Skin"}
	--"Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)", "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
    elemental_ws = S{'Flash Nova', 'Sanguine Blade'}

    include('Mote-TreasureHunter')
	
    --202407904 replaced "gs c treasuremode cycle" with "gs c set treasuremode Tag"
	windower.send_command('gs c set treasuremode Tag')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
 
    --don't load this unless I actually want to load it
    --todo: steal my sets from azuresets folder and make sure they're right
    --send_command('lua l azureSets')

    --the casting cape is not yet made
	gear.AmbuCape = {}
	--gear.AmbuCape.MAcc = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}} --also for int nukes

    gear.HercHelmFC = { name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+6','"Mag.Atk.Bns."+12',}}
    gear.HercBootsTH = { name="Herculean Boots", augments={'Enmity-2','"Mag.Atk.Bns."+6','"Treasure Hunter"+2',}}

    --do not care about this job enough to have the rest of the item details
    --gear.AFHead = {name="Assimilator's Keffiyeh"}
    --gear.AFBody = {name="Assimilator's Jubbah"}
    gear.AFHands = {name="Assimilator's Bazubands +1"} --BLUE MAGIC LEARNING CHANCE UP HELL YEAH
    --gear.AFLegs = {name="Assimilator's Shalwar"}
    --gear.AFFeet = {name="Assimilator's Charuqs"}
    --gear.RelicHead = {name="Luhlaza Keffiyeh"}
    --gear.RelicBody = {name="Luhlaza Jubbah"}
    --gear.RelicHands = {name="Luhlaza Bazubands"}
    --gear.RelicLegs = {name="Luhlaza Shalwar"}
    --gear.RelicFeet = {name="Luhlaza Charuqs"}
    --gear.EmpyHead = {name="Hashishin Kavuk +2"}
    --gear.EmpyBody = {name="Hashishin Mintan +2"}
    --gear.EmpyHands = {name="Hashi. Bazu. +2"}
    --gear.EmpyLegs = {name="Hashishin Tayt +2"}
    --gear.EmpyFeet = {name="Hashishin Basmak +2"}

end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    --send_command('lua u azureSets')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    -- Enmity set lmao never but we'll leave it in here juuuust in case
	sets.Enmity = {
    --ammo="Sapience Orb", --2
    --head="Halitus Helm", --8
    --body="Emet Harness +1", --10
    --hands="Kurys Gloves", --9
    --feet="Ahosi Leggings", --7
    --neck="Unmoving Collar +1", --10
    --left_ear="Cryptic Earring", --4
    --right_ear="Trux Earring", --5
    --left_ring="Pernicious Ring", --5
    --right_ring="Eihwaz Ring", --5
    --waist="Kasiri Belt", --3
    }

    --sets.precast.JA['Provoke'] = sets.Enmity

    --TH 2+2 fine for now
	sets.TreasureHunter = {
        left_ring="Hoxne Ring", --2
        feet=gear.HercBootsTH,
		}

	--FC cap is 80
	--BLU gets FC traits - current spells set is Erratic Flutter (mandatory) + Auroral Drape + Wind Breath to spend an extra 6 points to get 10% FC instead of 5%
    --gear is 44, traits is +10 = 54/80 total, if I cared about this job I would at least put fc on an ambu cape and get some boots
    sets.precast.FC = {
        head="Herculean Helm", --13 (beats amalric coif +1 which is 11 and I'm using it on COR and THF too)
        body="Adhemar Jacket +1", --10 (23) (path D)
        hands="Leyline Gloves", --8 (31) --actually 7 rn
        --legs="Gyve Trousers" --4, inventory space (enif cosciales 8 but not ilevel so not happening)
        --feet=gear.HercBoots.FC, --6 augment, inventory space (carmine greaves +1 8, amalric nails +1 6)
        neck="Orunmila's Torque", --5 (36)
		--waist="Witful Belt", --3, inventory space
        left_ear="Loquacious Earring", --2 (38)
        --right_ear="Etiolation Earring", --1, inventory space
        --left_ring="Kishar Ring", --4 (42)
        right_ring="Prolix Ring", --2 (44)
        --could use an ambu cape here for 10 fc if I actually care about BLU
        }

    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {
    	--body=gear.EmpyBody, --clearly this is relevant
	})
    
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
	    --waist="Siegel Sash"
	})
    
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
	})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        --left_ring="Lebeche Ring",
        --waist="Rumination Sash",
    })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--whatever
    sets.precast.WS = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
	    left_ear="Moonshade Earring",
        right_ear="Odr Earring",
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring",
        back="Null Shawl", --whatever
    }

	--this is fine for now
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
        waist="Sailfi Belt +1",
	    left_ear="Moonshade Earring",
        right_ear="Hoxne Earring", --lol
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring",
        --back=gear.AmbuCape.Rudras, --wrong main stat, ok for now
	    })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        --ammo="Oshasha's Treatise",
		--head="Nyame Helm",
		--body="Nyame Mail",
		--hands="Nyame Gauntlets",
		--legs="Nyame Flanchard",
		--feet="Nyame Sollerets",
		--neck="Fotia Gorget",
		--waist="Fotia Belt",
		--left_ear="Moonshade Earring",
		--right_ear="Regal Earring",
		--left_ring="Cornelia's Ring",
		--right_ring="Murky Ring", --screw it, dt
		--back=gear.AmbuCape.WS,
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']

    sets.precast.WS['Requiescat'] = {
        --ammo="Oshasha's Treatise",
		--head="Nyame Helm",
		--body="Nyame Mail",
		--hands="Nyame Gauntlets",
		--legs="Nyame Flanchard",
		--feet="Nyame Sollerets",
		--neck="Fotia Gorget",
		--waist="Fotia Belt",
		--left_ear="Moonshade Earring",
		--right_ear="Regal Earring",
		--left_ring="Cornelia's Ring",
		--right_ring="Murky Ring", --screw it, dt
		--back=gear.AmbuCape.WS,
        }

    sets.precast.WS['Expiacion'] = sets.precast.WS['Savage Blade']

	--bothering to actually use this one because it full heals me no matter what so I'm going to use it sometimes and therefore might as well max damage
    --2026 this should not be precast savage blade if I ever truly care
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Savage Blade'], {
		--ammo="Sroda Tathlum", --10% chance for a +25% crit, inventory
		head="Pixie Hairpin +1", --28% (stacks w/archon)
		--body="Nyame Mail",
		--hands="Nyame Gauntlets",
		--legs="Nyame Flanchard",
		--feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		--waist="Orpheus's Sash", --15%
		--left_ear="Friomisi Earring", --moonshade is 2.5% more healing, so add mab instead
		--right_ear="Regal Earring",
		--left_ring="Cornelia's Ring",
		right_ring="Archon Ring", --5% (stacks w/pixie)
		--back=gear.AmbuCape.MAcc, --wrong mainstat and everything but it has MAB so it's "fine"
		})
	
    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    --SIRD set
    --1024/1024 is cap
    sets.midcast.SpellInterrupt = {
        --ammo="Impatiens", --10 (staunch tathlum +1 is 11)
        --body=gear.Taeon_Phalanx_body, --10
        --hands="Rawhide Gloves", --15, in safe
        --legs="Carmine Cuisses +1", --20 vs "Assim. Shalwar +2" --22 at cost of an inventory slot
        --neck="Loricate Torque +1", --5
        --left_ear="Halasz Earring", --5
        --right_ear="Magnetic Earring", --8
        --right_ring="Evanescence Ring", --5
        --waist="Emphatikos Rope", --12 --ah 800k
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    --insane: temporarily add MAB for dia so that it deas at least 1 damage to higher mdef mobs to feed tp better :)
    sets.midcast['Dia'] = set_combine(sets.midcast.FastRecast, {
        right_ear = "Friomisi Earring", 
    })

	--honestly, this set's made up of what I have lying around
    sets.midcast['Blue Magic'] = {
        --ammo="Mavi Tathlum", --lol I had one of these once but 5 for an inv slot? no thank you!
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets", 
        neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Alabaster Earring",
        right_ear="Friomisi Earring", -- 10 mab
        left_ring="Mummu Ring", --sold second stikini and this is the best macc I have
        right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --11 + 8 blue magic skill
		back="Null Shawl", --"Cornflower Cape", --15 blu skill --or an ambu cape or something
        }

    sets.midcast['Blue Magic'].Physical = set_combine(sets.midcast['Blue Magic'], {
        ammo="Coiste Bodhar",
		--neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
        left_ear="Odr Earring",
		right_ear="Telos Earring", --10 acc lol
        })

    sets.midcast['Blue Magic'].Magical = set_combine(sets.midcast['Blue Magic'], {})

    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {})
    
    --this is macc
    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        --right_ring="Archon Ring",
        })

    --rip weatherspoon ring, it never scored
    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicAccuracy = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].StunPhysical = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {})

    sets.midcast['Blue Magic'].StunMagical = sets.midcast['Blue Magic'].MagicAccuracy

    sets.midcast['Blue Magic'].Healing = set_combine(sets.midcast['Blue Magic'].MagicalMnd, {})
        
    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {})

    sets.midcast['Blue Magic']['White Wind'] = set_combine(sets.midcast['Blue Magic'].Healing, {})

    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']

	sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {
		--head="Amalric Coif +1", --2 potency
		})

	--might ever actually use this job for Cruel Joke. macc and nothing but macc except I don't actually care about this job at all right now
    sets.midcast['Blue Magic']['Cruel Joke'] = set_combine(sets.midcast['Blue Magic'].Magical, {})
		
    --20241113 OKAY FARMING TESTING YEAH OKAY THIS IS FINE I DIDN'T NOTICE MY LACK OF DAMAGE
    --UNLESS I WANT TO KEEP MAX MP SIGH
    --sets.midcast['Blue Magic']['Subduction'] = set_combine(sets.midcast['Blue Magic'].Magical, sets.TreasureHunter)
	
	--1 shadow per 50 skill, so 500/550/600 breakpoints. this is 507 (10 shadows)
    sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {
        --hands=gear.EmpyHands,
        --left_ear="Njordr Earring", --what even is this
        --right_ear="Hashishin Earring", --10 (yep, still mog safe)
		--left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8 --sold this
		right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --8
    	--back="Cornflower Cape", --15
        })

    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        --head="Amalric Coif +1", --it's aquaveil
        --hands="Regal Cuffs", --still aquaveil
        })

    sets.midcast['Enhancing Magic'] = set_combine(sets.midcast['Blue Magic'].Buff, {})

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {})

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
		--head="Amalric Coif +1",
		})
	
    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {})

	--I do not have any Phalanx Received gear, nor do I care about not having any etc
    sets.midcast.Phalanx = set_combine(sets.midcast.EnhancingDuration, {})

	--aquaveil is aquaveil
    sets.midcast.Aquaveil = set_combine(sets.midcast['Blue Magic']['Carcharian Verve'], {})

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {})

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	--want null masque for one more idle refresh, watch max hp
    sets.idle = {
        ammo = "Staunch Tathlum +1", --3 dt (3)
		head="Malignance Chapeau", --7 dt (10) until "Null Masque", --10 dt (+3 over numbers below) (plus another free refresh)
		body="Malignance Tabard", --9 dt (19) (more stp lol)
		hands="Nyame Gauntlets", --7 dt (26)
		legs="Nyame Flanchard", --8 dt (27)
		feet="Nyame Sollerets", --7 dt (34)
		neck="Sibyl Scarf", --1 refresh --"Warder's Charm +1", --magic null
		waist="Carrier's Sash", --elemental resistance
        left_ear="Alabaster Earring", --5 dt (39)
        right_ear="Eabani Earring", --15 evasion lol
		left_ring="Shneddick Ring +1", --movespeed lol
		right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --1 refresh --"Murky Ring" if dt concerns etc etc
		back="Null Shawl", --meva/eva
	    }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Set ------------------------------------------=
    ------------------------------------------------------------------------------------------------

    --46 dt, no optimization at all
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6 dt
        body="Malignance Tabard", --9 dt
        hands="Malignance Gloves", --5 dt
        legs="Malignance Tights", --7 dt
        feet="Malignance Boots", --4 dt
        neck="Null Loop", --"Combatant's Torque",  --5 dt
		waist="Reiki Yotai", --DW
        left_ear="Alabaster Earring", --5 dt
        right_ear="Eabani Earring", --DW
        left_ring="Murky Ring", --10 dt
        right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --"Epona's Ring", --I like refresh tbh
        back="Null Shawl", --inventory space over ambu capes
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical,{})

    --realistically, this is sets.cursna, but whatever.
    sets.buff.Doom = {} --"Nicander's Necklace","Eshmun's Ring","Eshmun's Ring","Gishdubar Sash"

    --for the healing RoEs and also I guess for Omen objectives in the faaaar future. needs like 100 more HP to be correct
    sets.maxhpset = {
        main="Bunzi's Rod", --30 cure potency to get white wind from 700 to > 750 for RoE
        ammo="Staunch Tathlum +1", --0, don't have anything
        head="Nyame Helm", --91
        body="Nyame Mail", --136
        hands="Nyame Gauntlets", --91
        legs="Nyame Flanchard", --114
        feet="Nyame Sollerets", --68
        neck="Null Loop", --50
		waist="Carrier's Sash", --20
        left_ear="Alabaster Earring", --100
        right_ear="Eabani Earring", --45
        left_ring="Ilabrat Ring", --60
        right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --0, didn't have another ring, refresh
        back="Null Shawl", --0, don't have anything
    }


end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

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

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Magical' then
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
        --if spellMap == 'Healing' and spell.target.type == 'SELF' then
        --    equip(sets.midcast['Blue Magic'].HealingSelf)
        --end
    end
end









-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            disable('neck')
        else
            enable('neck')
            handle_equipping_gear(player.status)
        end
    end

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        equip(sets.buff['Burst Affinity'])
    end

    if state.Buff.Efflux and spellMap == 'Physical' then
        equip(sets.buff['Efflux'])
    end

    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
        equip(sets.buff['Diffusion'])
    end

    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        category == 4 or -- any magic action --20241113 yes this has to happen or Subduction farming breaks
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end
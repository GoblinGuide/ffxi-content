-- Original: Motenten / Modified: Arislan
--stripped the fuck outta this one by DACK

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
 
    --send_command('lua l azureSets')

	--define specific pieces below
	gear.AmbuCape = {}
	gear.AmbuCape.TP = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10',}} --could put dt on this to cap engaged
	gear.AmbuCape.WS = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	gear.AmbuCape.MAcc = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}} --also for int nukes
	
	gear.Moonshade = { name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}}
	gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}
	gear.TelchineHead = { name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}}
	gear.TelchineBody = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}}
	gear.TelchineLegs = { name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}}

    gear.HercHelm = {}
    gear.HercHelm.FC = { name="Herculean Helm", augments={'"Mag.Atk.Bns."+8','"Fast Cast"+6','MND+8',}}
	
    --lol I didn't even rewrite the names of the not-empy gear here
    --gear.AFHead = {name="Pillager's Bonnet"} --nope
    --gear.AFBody = {name="Pillager's Vest +3"} --hide duration, 6 crit damage, 7 ta
    --gear.AFHands = {name="Pillager's Armlets"} --nope
    --gear.AFLegs = {name="Pillager's Culottes +1"} --at +3, this is 5 ta, 5 crit damage (and right now it's +steal instead lmao)
    --gear.AFFeet = {name="Pillager's Poulaines +1"} --flee duration, 18 move speed
    --gear.RelicHead = {name="Plunderer's Bonnet"} --nope
    --gear.RelicBody = {name="Plunderer's Vest +3"} --crit hit rate/damage
    --gear.RelicHands = {name="Plunderer's Armlets +1"} --TH+3 until I spend galli on the boots
    --gear.RelicLegs = {name="Plunderer's Culottes"} --nope
    --gear.RelicFeet = {name="Plunderer's Poulaines +3"} --triple attack + also TA damage
    gear.EmpyHead = {name="Hashishin Kavuk +2"}
    gear.EmpyBody = {name="Hashishin Mintan +2"}
    gear.EmpyHands = {name="Hashi. Bazu. +2"}
    gear.EmpyLegs = {name="Hashishin Tayt +2"}
    gear.EmpyFeet = {name="Hashishin Basmak +2"}

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

    --TH 2+1+1, all items work on all jobs and are i119
	sets.TreasureHunter = {
		body="Volte Jupon", --2
		hands="Volte Bracers", --1
        waist="Chaac Belt", --1
		}
	
    --these will all just fail gracefully, it's fine
	sets.buff['Burst Affinity'] = {}--legs="Assim. Shalwar +3", feet="Hashi. Basmak +1"}
    sets.buff['Diffusion'] = {}--feet="Luhlaza Charuqs +3"}
    sets.buff['Efflux'] = {}--legs="Hashishin Tayt +1"}

    sets.precast.JA['Azure Lore'] = {}--hands="Luh. Bazubands +1"}
    sets.precast.JA['Chain Affinity'] = {}--feet="Assim. Charuqs +1"}
    sets.precast.JA['Convergence'] = {}--head="Luh. Keffiyeh +3"}
    sets.precast.JA['Enchainment'] = {}--body="Luhlaza Jubbah +3"}

	--FC cap is 80
	--BLU gets FC traits - current spells set is Erratic Flutter (mandatory) + Auroral Drape + Wind Breath to spend an extra 6 points to get 10% FC instead of 5%
    --gear is 44, traits is +10 = 54/80 total, if I cared about this job I would at least put fc on an ambu cape and get some boots
    sets.precast.FC = {
        head=gear.HercHelm.FC, --13 (beats amalric coif +1 which is 11 and I'm using it on COR and THF too)
        body="Adhemar Jacket +1", --10 (23) (path D)
        hands="Leyline Gloves", --8 (31)
        --legs="Gyve Trousers" --4, inventory space (enif cosciales 8 but not ilevel so not happening)
        --feet=gear.HercBoots.FC, --6 augment, inventory space (carmine greaves +1 8, amalric nails +1 6)
        neck="Orunmila's Torque", --5 (36)
		--waist="Witful Belt", --3, inventory space
        left_ear="Loquacious Earring", --2 (38)
        --right_ear="Etiolation Earring", --1, inventory space
        left_ring="Kishar Ring", --4 (42)
        right_ring="Prolix Ring", --2 (44)
        --could use an ambu cape here for 10 fc if I actually care about BLU
        }

    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {
	body=EmpyBody, --idk what this does lmao
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

	--copypasted savage blade set, don't care
    sets.precast.WS = {
        ammo="Oshasha's Treatise",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear=gear.Moonshade,
		right_ear="Regal Earring",
		left_ring="Cornelia's Ring",
		right_ring="Murky Ring", --screw it, dt
		back=gear.AmbuCape.WS,
        }

	--intended use
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		ammo="Oshasha's Treatise",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear=gear.Moonshade,
		right_ear="Regal Earring",
		left_ring="Cornelia's Ring",
		right_ring="Murky Ring", --screw it, dt
		back=gear.AmbuCape.WS,
        })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        ammo="Oshasha's Treatise",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear=gear.Moonshade,
		right_ear="Regal Earring",
		left_ring="Cornelia's Ring",
		right_ring="Murky Ring", --screw it, dt
		back=gear.AmbuCape.WS,
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']

    sets.precast.WS['Requiescat'] = {
        ammo="Oshasha's Treatise",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear=gear.Moonshade,
		right_ear="Regal Earring",
		left_ring="Cornelia's Ring",
		right_ring="Murky Ring", --screw it, dt
		back=gear.AmbuCape.WS,
        }

    sets.precast.WS['Expiacion'] = sets.precast.WS['Savage Blade']

	--bothering to actually use this one because it full heals me no matter what so I'm going to use it sometimes and therefore might as well max damage
    sets.precast.WS['Sanguine Blade'] = {
		ammo="Sroda Tathlum", --10% chance for a +25% crit
		head="Pixie Hairpin +1", --28% (stacks w/archon)
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash", --15%
		left_ear=gear.Moonshade, --2.5% more healing! not even joking!
		right_ear="Regal Earring",
		left_ring="Cornelia's Ring",
		right_ring="Archon Ring", --5% (stacks w/pixie)
		back=gear.AmbuCape.MAcc, --wrong mainstat and everything but it has MAB so it's "fine"
		}
	
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

	--honestly, this set's made up of what I have lying around
    sets.midcast['Blue Magic'] = {
        --ammo="Mavi Tathlum", --lol I had one of these once but 5 for an inv slot? no thank you!
		head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        neck="Sibyl Scarf",
		waist="Sacro Cord", --8 mab 8 macc 8 int/mnd
		left_ear="Friomisi Earring", -- 10 mab
		right_ear="Hashishin Earring", --right ear only, 10 blu skill, 6 macc
        left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --11 + 8 blue magic skill
        right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --11 + 8 blue magic skill
		back="Cornflower Cape", --15 blu skill
        }

    sets.midcast['Blue Magic'].Physical = {
        ammo="Coiste Bodhar",
		head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
        left_ear="Odr Earring",
		right_ear="Telos Earring", --10 acc lol
        left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --"Petrov Ring", --str, inventory
        right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --lol whatever
		back=gear.AmbuCape.WS, --physical damage cape
        }

    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
        left_ear="Odr Earring",
		--right_ear="Mache Earring +1",
        --right_ring="Ilabrat Ring",
		back=gear.AmbuCape.TP,
        --waist="Chaac Belt", --5 dex lmao
        })

    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
        --hands=gear.Adhemar_B_hands,
        --right_ring="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
        left_ring="Metamor. Ring +1", --this isn't actually anywhere atm but that's fine it may be when I get around to BRD
		waist="Sacro Cord", --wardrobe 3 but so is the rest of blu now
		left_ear="Regal Earring",
        back=gear.AmbuCape.MAcc,
        })

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
		left_ear="Regal Earring",
        right_ring="Metamor. Ring +1",
        })

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {
		left_ear="Regal Earring",
		--right_ear="Enchntr. Earring +1"
		right_ring="Metamor. Ring +1",
		})

    sets.midcast['Blue Magic'].Magical = {
        ammo="Sroda Tathlum", --negative 10 macc but I'm defining the important sets separately
		head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        neck="Sibyl Scarf", --over bae because inv/int
        left_ear="Friomisi Earring",
        right_ear="Regal Earring",
		left_ring="Metamor. Ring +1",
        right_ring={name="Stikini Ring +1", bag="wardrobe2"},
        back=gear.AmbuCape.MAcc,
        waist="Orpheus's Sash", --haha yessss
        }

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {
        --head="Assim. Keffiyeh +3",
        --hands="Jhakri Cuffs +2",
        --legs="Luhlaza Shalwar +3",
        --neck="Mirage Stole +2",
        --left_ear="Digni. Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe1"},
        --waist="Acuity Belt +1",
        })

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        right_ring="Archon Ring",
        })

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
        --right_ring="Weather. Ring +1"
        })

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {
        left_ring={name="Stikini Ring +1", bag="wardrobe1"},
        right_ring={name="Stikini Ring +1", bag="wardrobe2"},
        back="Aurist's Cape +1",
        })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        --ammo="Aurgelmir Orb +1",
        --right_ear="Mache Earring +1", --sold this.
        right_ring="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {
        --ammo="Aurgelmir Orb +1",
        })

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {
        --ammo="Voluspa Tathlum",
        left_ear="Regal Earring",
        --right_ear="Enchntr. Earring +1"
        })

    sets.midcast['Blue Magic'].MagicAccuracy = {
        ammo="Coiste Bodhar", --get sroda tathlum unequipped just in case
        head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        neck="Incanter's Torque", --no stole lol
		waist="Luminary Sash", --10
        right_ear="Hashishin Earring", --10 skill is 10 acc
        --left_ear="Digni. Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --11 + 8 blue magic skill beats 13 on weatherspoon
        right_ring={name="Stikini Ring +1", bag="wardrobe2"},--11 + 8 blue magic skill
        back=gear.AmbuCape.MAcc,
        }

    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {
		--head="Luh. Keffiyeh +3"
		})

    sets.midcast['Blue Magic'].StunPhysical = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        --ammo="Voluspa Tathlum",
        head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        --neck="Mirage Stole +2",
        --right_ear="Mache Earring +1",
        --waist="Eschan Stone",
        back="Aurist's Cape +1",
        })

    sets.midcast['Blue Magic'].StunMagical = sets.midcast['Blue Magic'].MagicAccuracy

    sets.midcast['Blue Magic'].Healing = {
        head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        --neck="Nodens Gorget", --5 cure pot lol
		waist="Luminary Sash",
        left_ear="Eabani Earring", --HP, mendi. earring is 5
        right_ear="Regal Earring",
        left_ring="Menelaus's Ring", --5
		right_ring={name="Stikini Ring +1", bag="wardrobe2"},
        left_ring="Metamor. Ring +1",
        back=gear.AmbuCape.MAcc, --DT
        }

    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {
		--hands="Buremte Gloves", --13
        --legs="Gyve Trousers", -- 10
        --neck="Phalaina Locket", -- 4(4)
        --right_ring="Asklepian Ring", -- (3)
        --back="Solemnity Cape", --7
        --waist="Gishdubar Sash", -- (10)
        })

    sets.midcast['Blue Magic']['White Wind'] = set_combine(sets.midcast['Blue Magic'].Healing, {
        --head=gear.Adhemar_D_head,
        --neck="Sanctity Necklace", --is this for HP?
        --right_ear="Etiolation Earring",
        --right_ring="Eihwaz Ring",
        --back="Moonlight Cape",
        waist="Plat. Mog. Belt", --10% HP
        })

    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']

	sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {
		head="Amalric Coif +1", --2 potency
		--waist="Gishdubar Sash",
		--back="Grapevine Cape",
		})

	--I'm using this job for Cruel Joke. So let's make sure it's hardcoded. macc, and nothing but macc
    sets.midcast['Blue Magic']['Cruel Joke'] = set_combine(sets.midcast['Blue Magic'], {
		main="Naegling", --lol rip sakpata's
		sub="Bunzi's Rod",
		head=gear.EmpyHead,
		body=gear.EmpyBody,
		hands=gear.EmpyHands,
		legs=gear.EmpyLegs,
		feet=gear.EmpyFeet,
        waist="Luminary Sash", --10 macc
		neck="Incanter's Torque", --10 blue skill = 10 macc, no stole
		right_ear="Hashishin Earring", --10 skill = 10 macc
		left_ear="Eabani Earring", --Digni. Earring from Strophadia i135 has actual macc, regal doesn't without an AF piece on
		left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --11 + 8 blue magic skill
		right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --11 + 8 blue magic skill
		back=gear.AmbuCape.MAcc, --20
		})

    --20241113 OKAY FARMING TESTING
    sets.midcast['Blue Magic']['Subduction'] = set_combine(sets.midcast['Blue Magic'].Magical, sets.TreasureHunter)
	
	--1 shadow per 50 skill, so 500/550/600 breakpoints. this is 507 (10 shadows) and would not hit 550 with every other item I know of
    sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {
        --hands="Hashishin Bazubands +2",
        --left_ear="Njordr Earring",
        right_ear="Hashishin Earring", --10
		left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8
		right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --8
    	--back="Cornflower Cape", --15
        })

    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        head="Amalric Coif +1", --it's aquaveil
        hands="Regal Cuffs", --still aquaveil
        --waist="Emphatikos Rope",
        })

    sets.midcast['Enhancing Magic'] = {
        --ammo="Pemphredo Tathlum",
        head=gear.TelchineHead, --10 duration
        body=gear.TelchineBody, --10 duration
        hands="Hashishin Bazubands +2", --9 dt
        legs=gear.TelchineLegs, --10 duration over "Carmine Cuisses +1", 18 skill
        feet="Malignance Boots",
        neck="Incanter's Torque", --10 skill
        left_ear="Mimir Earring", --10 skill
        right_ear="Andoaa Earring", --5 skill
		left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8
		right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --8
        waist="Olympus Sash", --5 skill
		--back="Fi Follet Cape +1",
        }

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
        head=gear.TelchineHead,
        body=gear.TelchineBody,
        legs=gear.TelchineLegs,
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
		head="Amalric Coif +1",
		--waist="Gishdubar Sash",
		--back="Grapevine Cape"
		})
	
    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {})

	--I do not have any Phalanx Received gear, nor do I care about not having any etc
    sets.midcast.Phalanx = set_combine(sets.midcast.EnhancingDuration, {
        --body=gear.Taeon_Phalanx_body, --3(10)
        --hands=gear.Taeon_Phalanx_hands, --3(10)
        --legs=gear.Taeon_Phalanx_legs, --3(10)
        --feet=gear.Taeon_Phalanx_feet, --3(10)
        })

	--aquaveil is aquaveil
    sets.midcast.Aquaveil = set_combine(sets.midcast['Blue Magic']['Carcharian Verve'], {})

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        --head=empty;
        --body="Cohort Cloak +1",
		hands="Regal Cuffs", --20 duration, cause if you got it, flaunt it
        --right_ear="Vor Earring",
        })

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	--maxed DT even pre-shell
    --also 1 refresh so that einherjar botting works because in an hour that'll cap me
    --also *really* high max HP, like really high. might wanna work on that somehow. already no null loop so idk, but like, I go to 79% after any spell, which is too close to blood aggro for my tastes
    sets.idle = {
		head="Null Masque", --10 dt (+3 over numbers below, can move Alabaster out if I want or something) (plus another free refresh)
		body="Nyame Mail", --9 dt (16)
		hands="Nyame Gauntlets", --7 dt (23)
		legs="Nyame Flanchard", --8 dt (31)
		feet="Nyame Sollerets", --7 dt (38)
		neck="Sibyl Scarf", --1 refresh when Windurst native (if I change nation, put a Stikini on instead and Loricate Torque here to get to 49 dt?)
		waist="Carrier's Sash", --elemental resistance
        left_ear="Alabaster Earring", --5 dt (43)
        right_ear="Eabani Earring", --15 evasion lol
		left_ring="Shneddick Ring +1", --movespeed lol
		right_ring="Murky Ring", --10 dt (53)
		back="Null Shawl", --meva/eva
	    }

    --not currently used, but I see why I'd want to be doing this, theoretically, for segment farming solo
    --nyame and malig all 5 pieces have same eva/meva/mdb. some volte all-jobs pieces from jeuno with TH have higher MDB (and status ailment res) but lower everything else. 
    sets.idle.OmenEvasion = {
        --ammo="Amar Cluster", --currently not in inventory, 10 eva (could use staunch tathlum for 3 dt if it frees up a main slot elsewhere)
		head="Null Masque", --10 dt (10) and more eva than nyame, wild
		body="Nyame Mail", --9 dt (19)
		hands="Nyame Gauntlets", --7 dt (26)
		legs="Nyame Flanchard", --8 dt (34)
		feet="Nyame Sollerets", --7 dt (41)
		neck="Null Loop", --5 dt (46) 
		waist="Carrier's Sash", --elemental res, still almost caps dt without dring barely, this is -meva relative to play mog belt but I don't mind
        left_ear="Alabaster Earring", --5 dt (51) until "Infused Earring" --for more meva
        right_ear="Eabani Earring", --15 evasion
		left_ring="Shneddick Ring +1", --movespeed
		right_ring="Murky Ring", --10 dt (over cap without this, can use something else here)
		back="Null Shawl", --lots and lots of eva
	    }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

	--I did not optimize this at all, no DW math, no nothing
    --46 dt currently
    sets.engaged = {
		main="Naegling", --laaaaazy
        ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6 dt
        body="Malignance Tabard", --9 dt
        hands="Malignance Gloves", --5 dt
        legs="Malignance Tights", --7 dt
        feet="Malignance Boots", --4 dt
        neck="Combatant's Torque",
		waist="Reiki Yotai",
        left_ear="Alabaster Earring", --dt
        right_ear="Telos Earring",
        left_ring="Epona's Ring", --Petrov is out of my inventory now
        right_ring="Murky Ring", --10 dt
        back=gear.AmbuCape.TP, --no resin here, 
        }
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
        --legs="Assim. Shalwar +3", --10
        --feet="Hashishin Basmak +2", --10
        --neck="Warder's Charm +1", --10
        --left_ear="Static Earring",--5
        --left_ring="Mujin Band", --(5)
        --right_ring="Locus Ring", --5
        --back="Seshaw Cape", --5
        })

    --sets.Kiting = {legs="Carmine Cuisses +1"}
    --sets.Learning = {hands="Assim. Bazu. +1"}
    --sets.latent_refresh = {waist="Fucho-no-obi"}

	--realistically, this is sets.cursna, but whatever.
    sets.buff.Doom = {
        --neck="Nicander's Necklace", --20
        --left_ring="Eshmun's Ring", --20
        --right_ring="Eshmun's Ring",--20
        --waist="Gishdubar Sash", --10
        }

	--removed: this should not ALWAYS be the case, just when tagging
    --sets.midcast.Dia = sets.TreasureHunter
    --sets.midcast.Diaga = sets.TreasureHunter
    --sets.midcast.Bio = sets.TreasureHunter
    --sets.Reive = {neck="Ygnas's Resolve +1"}

    --sets.Almace = {main="Almace", sub="Sequence"}
    --sets.Naegling = {main="Naegling", sub="Thibron"}
    --sets.Maxentius = {main="Maxentius", sub="Thibron"}
    --sets.Nuking = {main="Naegling", sub="Bunzi's Rod"} --lol, lazy

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
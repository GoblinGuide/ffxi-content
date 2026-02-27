-- Original: Motenten / Modified: Arislan / absolutely gutted: DACK on 5/20/23 (to replace existing because TH tag was broken)
-- here's the bis gearsets node on ffxiah https://www.ffxiah.com/node/349

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

    state.Buff.Composure = buffactive.Composure or false
    state.Buff.Saboteur = buffactive.Saboteur or false
    state.Buff.Stymie = buffactive.Stymie or false

	--mapping uses acc for lesser tiers of Distract/Frazzle to land them, then skill for the top tiers to overwrite the lesser tiers
    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle', 'Frazzle II',  'Gravity', 'Gravity II', 'Silence','Poison'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
	
	--dia and blind are very special boys and only effect matters
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga', 'Blind', 'Blind II'}
    enfeebling_magic_sleep = S{'Sleep', 'Sleep II', 'Sleepga'}

    --these are spells where you literally just want maximum skill, rather than spells that care about other stuff too. I think.
    skill_spells = S{'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II', 'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

    include('Mote-TreasureHunter')
	
	--20230522 test putting this in job underscore setup, looks like it works just fine to toggle me into tag mode and then never have to sweat it
    --20240704 replaced "gs c treasuremode cycle" with "gs c set treasuremode Tag"
	windower.send_command('gs c set treasuremode Tag')

    lockstyleset = 1

    --20251110 adding "default to party chat mode" so that I don't say "r legion" in norg, instead putting it in empty party chat
    windower.send_command('input /cm p')

end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    --state.HybridMode:options('Normal', 'DT') --removed because I fulltime 50 DT
    
    state.WeaponSet = M{['description']='Weapon Set', 'Crocea', 'Naegling', 'Tauret', 'Maxentius', 'Daggers'} --Daggers is kind of misleading, because it's the enspell set, but whatever
    state.EnspellSet = M(false, 'Enspell') --okay I think I did this right. adding a toggle for enspell set. not that I will ever use it.
	state.MagicBurst = M(false, 'Magic Burst') --maybe someday I will care so not deleted
    
	--F10 is my button to do this on COR too
	send_command('bind F10 gs c cycle WeaponSet')

    --testing enspell too
    send_command('bind F11 gs c cycle EnspellSet')

    --capes
	gear.AmbuCape = {} --if I don't specify one, I have stopped breathing, so I can leave this node blank
	--gear.AmbuCape.TP = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}} --stp over DW now that I have reiki yotai
	gear.AmbuCape.INT = { name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}} --SIRD
	gear.AmbuCape.Seraph = { name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%','Damage taken-5%',}} --note DT (not PDT) here, to use for idle set too
	gear.AmbuCape.Savage = { name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}} --dt is actually right when I'm trying for 50 on everything

    --somehow, I made this entire cape and I never use it. it would work for Banish I guess. or a magical mnd ws, except that it doesn't have wsd on it
    --gear.AmbuCape.MND = { name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}} --10 mnd over macc because... um?

    --Occult Acumen gear for Impact for Aminon TP generation
	gear.MerlinicHandsImpact = { name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+6','"Occult Acumen"+11','Mag. Acc.+2',}}
    gear.MerlinicFeetImpact = { name="Merlinic Crackows", augments={'"Occult Acumen"+11',}}

    --have a chironic hose with +macc for optimal immunobreaking just because the DM augs are free, have to put that in my enfeeble sets, lazy

	--I only have one relevant copy of each of these things, but it never hurts to be foolproof
	gear.Moonshade = { name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}}
	gear.LeylineGloves = { name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}
	gear.TelchineHead = { name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}}
	gear.TelchineBody = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}}
	gear.TelchineLegs = { name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}}

    --not listed here: my current Ghostfyre Cape is 19 aug duration (max 20), 9 enh skill (max 10) (could reroll that someday, I suppose, but I'll never have TWO)

    --trying something new
    gear.AFHead = {name="Atrophy Chapeau +3"} --16 fc
    gear.AFBody = {name="Atrophy Tabard +3"} --21 enfeeble skill, 2 refresh potency
    gear.AFHands = {name="Atrophy Gloves +3"} --20 enhance duration normal
    gear.AFLegs = {name="Atrophy Tights +3"} --21 enhance skill, 12 cure pot
    gear.AFFeet = {name="Atrophy Boots +2"} --nope (reforged +4 has max macc for slot, but I cannot bring myself to care at this time since I'm off rdm)
    gear.RelicHead = {name="Vitiation Chapeau +3"} --26 enfeeble skill, 3 refresh, 15 macc augment if merited (it is)
    gear.RelicBody = {name="Vitiation Tabard +3"} --23 enhance skill, 15 enhance duration, 15 fc, +20 sec chainspell duration
    gear.RelicHands = {name="Vitiation Gloves +3"} --24 enhance skill, 30 gain-spell stat, 15 enh duration if merited (it isn't)
    gear.RelicLegs = {name="Vitiation Tights +3"} --enspell piece
    gear.RelicFeet = {name="Vitiation Boots +3"} --16 enfeeble skill, 10 enfeeble effect, 5 immunobreak chance if merited
    gear.EmpyHead = {name="Lethargy Chappel +2"} --10 dt, composure set bonus
    gear.EmpyBody = {name="Lethargy Sayon +2"} --3 refresh, 13 dt, 16 enfeeble effect, composure set bonus
    gear.EmpyHands = {name="Lethargy Gantherots +2"} --24 enfeeble skill, saboteur +13% potency/duration, 10 dt, composure set bonus
    gear.EmpyLegs = {name="Lethargy Fuseau +2"} --3 refresh potency, composure set bonus
    gear.EmpyFeet = {name="Lethargy Houseaux +2"} --8 wsd, 30 enhance skill, 35% enhance duration normal, 45 MAB, 20 magic damage, composure set bonus

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

	--automatically used when I am not /nin or /dnc (see end of file for very simple logic. note that it does not prevent some of the "you need dual wield" errors in level cap situations or no-sub situations)
	sets.DefaultShield = {sub="Ammurapi Shield"}

	--JA precast goes above spell precast because there isn't much of it. Saboteur cares about the buff being on, not the initial activation, so this is the only one I have at the moment.
    sets.precast.JA['Chainspell'] = {body="Vitiation Tabard +3"}

	--FC cap is 80, rdm has 38 native => 42 from gear needed, this set caps without weapon swap to Crocea Mors for 20 more
	--other slots have HP swaps with priority=HP the item gives (the goal is to not get blood aggro ever - so not too high here to trigger it, and not too low to end up in it when we stop casting)
    sets.precast.FC = {
	head=gear.AFHead, --16 (16)
	body=gear.RelicBody, --15 (31)
	hands={name="Nyame Gauntlets",priority=91}, --these have priority equal to the HP they give
	--waist={name="Plat. Mog. Belt",priority=200}, --10% HP, but inventory
	legs={name="Nyame Flanchard",priority=114},
	feet={name="Nyame Sollerets",priority=68},
	left_ear={name="Alabaster Earring",priority=100}, --this thing has 100 HP in addition to the 5 dt?!
	right_ear="Lethargy Earring", --7 (38)
    left_ring="Kishar Ring", --4 (42)
    right_ring="Murky Ring", --no reason not to put DT here, i think we're not actually capped
	}

	--only relevant spell-specific set, because Crepuscular Cloak doesn't have FC on it (-31 FC from head and body)
    --this is 5 + 8 + 8 + 2 + 2 = 25 is 6 short (also loses alabaster/murky DT)
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {
	body="Crepuscular Cloak", --mandatory
    neck="Orunmila's Torque", --5
	hands=gear.LeylineGloves, --8
    legs="Volte Brais", --8
    --feet="Volte Gaiters", --6 (would cap, tied with augmented Herculean feet, inventory)
	left_ear="Loquac. Earring", --2
    right_ring="Prolix Ring", --2
	})
	
	--to cast Dispelga, you need to have Daybreak in your main hand
    --this means it can't be in your offhand because then equipping to mainhand fails, so put Ammurapi in the offhand first. this is not an issue anymore but was when I was using Seraph Blade fulltime to drop WSes.
	--priority is equipped in order from highest to lowest, default is priority = 0 for all unspecified items
	--default behavior for items of the same priority (including an unprioritized set) is equip left to right, top to bottom (in that order, so main first feet last)
	sets.precast.Dispelga = set_combine(sets.precast.FC, {main={name="Daybreak", priority=999},sub={name='Ammurapi Shield', priority=1000}})

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--if undefined, generic all-purpose WSD and don't sweat the jewelry too much
    sets.precast.WS = {
	ammo="Oshasha's Treatise",
	head="Nyame Helm",
	body="Nyame Mail",
	hands="Nyame Gauntlets",
	legs="Nyame Flanchard",
	feet="Nyame Sollerets",
    left_ring="Cornelia's Ring",
	right_ring="Murky Ring",
	back=gear.AmbuCape.Savage, --WSD and STR for generic set
	}

	--ws damage formula, oversimplified:
	--physical: (weapon damage + relevant stats percentage + str vs target's vit calculation) * ftp (gorgets, tp you have) * pdif * wsd multiplier
	--magical: ((weapon damage + relevant stats percentage) * ftp + raw magic damage stat + relevant dstat) * affinity * wsd multiplier * crocea mors 100% bonus
	--upshot: raw magic damage stat does not matter because it doesn't even get ftp multiplied, wsd equally good for physical and magical as long as it's a one-hit WS, wsd less good for multihits

	--savage: physical, 50% str 50% mnd, fotia not good, tp bonus good, ws damage ok (first hit does the big damage, second hit is about 10%)
    --this is dt capped (38 nyame, 10 ring, 5 cape = 53)
    sets.precast.WS['Savage Blade'] = {
	ammo="Coiste Bodhar", --too lazy to waste a slot on "Oshasha's Treatise" even without augs on coiste
	head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Rep. Plat. Medal",
	waist="Sailfi Belt +1",
    left_ear=gear.Moonshade, --tp bonus good
	right_ear="Regal Earring", --10 mnd --theoretically this will be lethargy +2 once I have one but that's likely never happening, but maybe I get super lucky with roe objective +1 cases?
    left_ring="Cornelia's Ring", --10 wsd
	right_ring="Murky Ring", --10 dt
    back=gear.AmbuCape.Savage,
	}

	--sanguine: magical, 50% mnd 30% str, but dstat is based on target's int like black magic for some reason? tp bonus blank because tp only affects damage -> HP gain conversion rate
    --relative to savage blade set, this is -7 dt from nyame helm +5 from Null Loop = 51, still capped
    sets.precast.WS['Sanguine Blade'] = {
	ammo="Coiste Bodhar", --over "Sroda Tathlum" for inventory
	head="Pixie Hairpin +1", --28% (stacks w/archon+sash)
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Null Loop", --dt
	waist="Orpheus's Sash", --15% (stacks w/pixie+archon)
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Archon Ring", --5% (stacks w/pixie+sash)
	right_ring="Murky Ring", --10 dt
    back=gear.AmbuCape.Seraph, --10 wsd and mnd, even if it was not the intended main use
	}
	
	--seraph: magical, 40% str 40% mnd, tp bonus good, ftp bad, ws damage does work on these things
	--dt capped
	sets.precast.WS['Seraph Blade'] = {
	ammo="Coiste Bodhar", --over "Sroda Tathlum" for inventory
    head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Sibyl Scarf", --apparently not fotia
	waist="Orpheus's Sash", --15%, better than fotia even with weatherspoon which I no longer have lol
    left_ear=gear.Moonshade,
    right_ear="Regal Earring",
    left_ring="Cornelia's Ring", --10 wsd
	right_ring="Murky Ring", --10 dt
    back=gear.AmbuCape.Seraph, --the actual intended use for this poor cape I just throw on every WS
	}
	
	--red lotus blade: 40 str / 40 int, magical, ftp not worth, wsd good
	sets.precast.WS['Red Lotus Blade'] = set_combine(sets.precast.WS['Seraph Blade'], {
	right_ring="Freke Ring", --not sure if this is better or worse than epaminondas's, pretty sure it's this but whatever
    })

	--requiescat: physical equation technically, 73-85% mnd (3% per merit), fotia good, tp bonus good, ws damage meh
    sets.precast.WS['Requiescat'] = {
	ammo="Regal Gem", --7 mnd, with enough WSD elsewhere beats "Oshasha's Treatise", so just put it here now who cares
	head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Fotia Gorget", --ftp
	waist="Fotia Belt", --ftp
    left_ear=gear.Moonshade, --tp is linear from -20% at 1k to -0% at 3k, so this is a flat 2.5% damage bonus
	right_ear="Malignance Earring", --8 mnd > 2 wsd
    left_ring="Cornelia's Ring", --10 wsd
	right_ring="Murky Ring", --10 dt
	back=gear.AmbuCape.Seraph, --it says seraph but it's MND and WSD so it's fine for requiescat, although it doesn't have atk so it's technically not optimal
	}

	--cdc: physical, 80% dex, ws damage mediocre, fotia good, tp bonus crit rate so... actually I have no idea if it'd be correct here if I care about crit rate on the ammo slot? whatever, I'm never gonna use this
	sets.precast.WS['Chant du Cygne'] = {
	ammo="Yetshila +1", --crit rate is better than a few dex, apparently? weird.
    head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Fotia Gorget", --ftp
	waist="Fotia Belt", --ftp
    left_ear="Sherida Earring", --5 dex
    right_ear="Telos Earring", --acc, poor ws I never use isn't worth an inventory slot
    left_ring="Cornelia's Ring", --10 wsd
	right_ring="Murky Ring", --10 dt
    back=gear.AmbuCape.Savage, --if I cared, I'd make a CDC cape. I do not care.
	}
	
	--aeolian: magical, 40 dex / 40 int, aoe, wind damage so can't do anything fun with affinity on relevant gear other than sash
	sets.precast.WS['Aeolian Edge'] = {
	ammo="Coiste Bodhar", --over "Sroda Tathlum" for inventory
    head="Nyame Helm", --dt
    body="Nyame Mail", --dt
    hands="Nyame Gauntlets", --dt
    legs="Nyame Flanchard", --dt
    feet="Nyame Sollerets", --dt
    neck="Sibyl Scarf", --apparently not fotia
	waist="Orpheus's Sash", --15% is love
    left_ear=gear.Moonshade,
    right_ear="Regal Earring",
    left_ring="Cornelia's Ring", --10 wsd
	right_ring="Murky Ring", --10 dt
    back=gear.AmbuCape.Seraph, --eh, close enough. I don't have a dex OR an int ws cape. because I'm not insane.
	}
	
	--black halo: physical, 70 mnd 30 str, it's just a savage blade, technically you value mnd higher but not enough for me to care
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
 
    sets.midcast.FastRecast = sets.precast.FC
	
	--SIRD caps at 102% because all values are X/1024 on the backend
	--also, I have 10% in merits if I actually care about legitimately trying to cap this, which I might, it's kind of useful for utsusemi
    --no idea when this set'd be used for non-utsusemi purposes with Aquaveil existing
    sets.midcast.SpellInterrupt = {
	--ammo="Impatiens", --10 --inventory
	--legs="Carmine Cuisses +1", --20 --inventory
	--neck="Loricate Torque +1", --5 inventory
	left_ring = "Freke Ring", --10
	--right_ring ="Evanescence Ring", --10 inventory
	--left_ear = "Halasz Earring", --4 inventory
	back=gear.AmbuCape.INT, --10
	}

    --like I said, utsusemi
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

	--cure potency caps at 50.
    --daybreak randomly has 30 so this set got a lot less complicated and more hardcoded as long as I'm willing to assume Dual Wield and also it's still only 48 because lol inventory but this is fine
	--dt in every other slot (nyame over malig so that max hp doesn't fall as far)
	sets.midcast.Cure = {
	sub="Daybreak", --this thing has 30 cure potency for no reason! (30, at the cost of TP, because if I'm curing something has gone south)
	head={name="Nyame Helm",priority=50}, --no clue how much HP it actually has
	--waist={name="Plat. Mog. Belt",priority=200}, --inventory
	body={name="Nyame Mail",priority=100}, --HP, fake --body="Bunzi's Robe", --15 --inventory
	hands={name="Nyame Gauntlets",priority=70}, --HP, priority fake
	legs=gear.AFLegs, --12 (42)
    feet={name="Nyame Sollerets",priority=68}, --68 HP
    neck="Null Loop", --50 HP to try to drop less, why was I even losing so much max HP here anyway?
    back="Ghostfyre Cape", --6 (48)
	}

    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {}) --{hands="Buremte Gloves"}) --13 cure pot received, but also, -1 inventory slot
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {}) --yeah sure whatever
    sets.midcast.StatusRemoval = {}
    --sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {neck="Nicander's Necklace"}) --if I care, drag this back out of storage
	--sets.buff.Doom = sets.midcast.Cursna --it's really for getting doomed in all cases I guess, but "buff doom" is not how I'd describe the doom status ailment which is funny

	--enhancing magic duration formula is the product of five terms:
	--A) Base Duration + merit point category 2 points I don't have + RDM Job Points + gear that lists explicit seconds of duration
	--B) lethargy set's "Augments Composure" set bonus when targeting OTHERS (2 pc = 10, 3 = 20, 4 = 35, 5 = 50)
	--C) composure is a flat tripling to targeting SELF regardless of the lethargy set
	--D) percentage bonuses to duration naturally on gear (+ Naturalist's Roll as though anyone ever uses that)
	--E) percentage bonuses to duration augments on gear
	--simplifies to (base + explicit seconds) * (lethargy or composure, mutually exclusive) * (percentage on gear) * (percentage on augment)

	--default enhancing magic set. listed values are DURATION only! composure sets for casting on others below - this is self-casting since I "always" have composure up
	--currently 554 enhancing skill in this set and everything but temper2/enspell1 caps at 500
	--using ghostfyre cape totals 1.82 * 1.68 = 3.0576 duration multiplier, slightly greater than:
	--with ambu cape instead it's 2.02 * 1.49 = 3.0098
    sets.midcast['Enhancing Magic'] = {
	main="Colada", --4 aug, costs tp but I don't care
	sub="Ammurapi Shield", --10 reg, costs tp but I don't care
	head=gear.TelchineHead, --10 aug
	body=gear.TelchineBody, --10 aug
	hands=gear.AFHands, --20 reg
	legs=gear.TelchineLegs, --10 aug
	feet=gear.EmpyFeet, --35 reg
	neck="Dls. Torque +2", --25 aug
	waist="Embla Sash", --10 reg
	left_ear="Alabaster Earring", --Mimir earring is 10 skill but I'm worried about the HP drop from this set when weak
    right_ear="Lethargy Earring", --7 reg
	left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8 skill
	right_ring="Ilabrat Ring", --somehow, not a joke, 60 max HP --{name="Stikini Ring +1", bag="wardrobe2"}, --8 skill
	back="Ghostfyre Cape", --19 aug vs ambu cape's 20 reg, see above math
	}

	--for anything that is not affected by skill at all (it's just haste), I could put something like DT here instead over the few skill pieces I still have
	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {})
	
	--when targeting someone else with Composure, with five Lethargy pieces it's bonus 1.5  * (1+regular)    [where regular = "rest of the regular non-augmented duration term"]
    --with four Lethargy pieces, plus the best replacement, Atrophy Gloves, it's bonus 1.35 * (1.2+regular)
	--breakeven point is at x = 1.8 so if I have 80% in non-augment duration on gear then the fifth lethargy piece is superior (currently 82% with NQ sortie earring, which was the tipping point piece)
	--with 5 lethargy it's 1.5 bonus  * (1 + 0.1 + 0.0 + 0.35 + 0.1 + 0.2 + 0.07) nonaug * 1.29 aug = 1.50 * 1.82 * 1.29 = 3.5217  is greater than the below
	--with 4 lethargy it's 1.35 bonus * (1 + 0.1 + 0.2 + 0.35 + 0.1 + 0.2 + 0.07) nonaug * 1.29 aug = 1.35 * 2.02 * 1.29 = 3.51783 is less    than the above
	sets.buff.ComposureOther = set_combine(sets.midcast['Enhancing Magic'], {
	head=gear.EmpyHead, 
	body=gear.EmpyBody, 
	hands=gear.EmpyHands, --see above math
	legs=gear.EmpyLegs, 
	feet=gear.EmpyFeet, --this is probably going to be in the default set as well forever due to its +35%, but I specify it here so that I notice that I'm putting all five on
	})

	--this is the set for raw enhancing skill points - relevant uncapped spells are Temper II (10 skill = 1% TA) and Enspells I (25 skill = 3 damage)
    sets.midcast.EnhancingSkill = 
	{
	--sub="Forfend +1", --unity shield, wing augments are cheap, from i135 Tolba, augments to +10, but inventory / changing weapons
	head="Befouled Crown", --16
	body=gear.RelicBody, --23
    hands=gear.RelicHands,  --24
	legs=gear.AFLegs, --21
	feet=gear.EmpyFeet, --30
	neck="Incanter's Torque", --10
	waist="Olympus Sash", --5
	left_ear="Mimir Earring", --10
    right_ear="Andoaa Earring", --5
	left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8
	right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --8
	back="Ghostfyre Cape", --9 (max 10)
	}
	
    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
	--neck="Nodens Gorget", --honestly, I don't know if this matters at all. removed. it's also a cure potency item, but idgaf
	--waist="Siegel Sash", --have, but not wasting inv slot on stoneskin buff
	})

    sets.midcast.GainSpell = set_combine(sets.midcast.EnhancingDuration, {
	hands=gear.RelicHands, --+30 stats
	})
    
	--I never even remember I have these spells tbh
	sets.midcast.SpikesSpell = set_combine(sets.midcast.EnhancingDuration, {
	--legs=gear.RelicLegs", --inv slot
	})
	
	sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
	head="Amalric Coif +1", --2 potency
	body=gear.AFBody, --3 potency
	legs=gear.EmpyLegs, --2 potency
	})

	--self-targeted phalanx buffs, I never bother
	sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
	--main="Sakpata's Sword", --5, does not go up with augments
	--sub="Egeking", --from Oboro
	--five possible pieces of taeon augmented with phalanx received +3 from duskdim stones/merlinic or chironic augmented with phalanx received +4-5 from dark matter campaign
	})

	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
	head="Amalric Coif +1", --2 interrupts prevented before Aquaveil wears off
	hands="Regal Cuffs", --2 here also
	})
	
	--unused spell-specific sets, I don't want to waste an inventory slot on a grapevine cape/inspirited boots/whatever for self-targeted refresh, ditto protect buffs and so on, but define just to prevent garbage
    sets.midcast.Storm = sets.midcast.EnhancingDuration --lol I never sub sch who's kidding who
	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {}) --feet="Inspirited Boots" for 15 seconds base duration if I so desire, could also buy a back="Grapevine Cape", but inventory space.
    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    --Custom spell classes
    --enfeebles where potency matters and mnd is the important stat (duration matters for everything obviously)
	sets.midcast.MndEnfeebles =	{
	ammo="Regal Gem", --10 pot
    head=gear.RelicHead, --26 skill, 15 skill merits augment, 37 macc
    body=gear.EmpyBody, --18 pot, 54 macc
    hands="Regal Cuffs", --20 duration (alternatives are 24 enf skill, +7 macc over this from empy hands +2, which are always on during saboteur)
    legs=gear.EmpyLegs, --"Psycloth Lappas", better until +3, this is +2, I'm lazy
    feet=gear.RelicFeet, --10 pot, 16 skill, 43 macc
    neck="Dls. Torque +2", --10 pot, 30 macc, 15 mnd, 25 duration, this thing has it all
	waist="Obstin. Sash", --5 mnd, 5 duration vs "Luminary Sash", --10 macc 10 mnd
    left_ear="Snotra Earring", --10 macc 8 mnd 10 duration
    right_ear="Malignance Earring", --8 mnd 8 macc vs "Regal Earring", --10 mnd, plus 10 macc per Atrophy piece, which is actually zero in this set as defined
	left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --8 mnd, 8 skill, 11 macc
	right_ring={name="Stikini Ring +1", bag="wardrobe2"}, --8 mnd, 8 skill, 11 macc
    back="Aurist's Cape +1", --33 int, 33 mnd, 33 macc
	}

    --for int enfeebles, I don't see a reason to not just use the same stuff because I am very lazy.
	--snotra has specifically mnd, but it also has macc and duration, "play that same set"
	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {})

    --for when accuracy is a more important concern than potency (i.e. stuff that doesn't scale with potency)
    sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
	--ranged="Ullr", --40 macc, costs tp, commenting out for now
	legs=gear.EmpyLegs, --53 beats malignance 50
	feet=gear.EmpyFeet, --50
	})

	--when a very high amount of pure enfeebling skill actually matters
	--used for Frazzle III (cap 625) and Distract III (cap 615)
	--breakpoint: at ML 26, removed incanter's torque and still hit cap.
    --at ML36 I can remove Vor Earring as well.
	sets.midcast.SkillEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
	head=gear.RelicHead, --26, this is actually not a change from the base set currently
	body=gear.AFBody, --21
	hands=gear.EmpyHands, --24
	--neck="Incanter's Torque", --10
	right_ear="Vor Earring", --10
	})

    sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.MndEnfeeblesAcc, {}) --can you believe I didn't have this combining an acc set until a month after I made the acc set?!
	sets.midcast.Sleep = set_combine(sets.midcast.IntEnfeeblesAcc, {}) --is there sleep-specific gear I don't know about?
	sets.midcast.MndEnfeeblesEffect = set_combine(sets.midcast.MndEnfeebles, {}) --"effect" as in "only potency matters", I think
	sets.midcast.IntEnfeeblesEffect = set_combine(sets.midcast.IntEnfeebles, {})
    sets.midcast.EffectEnfeebles = set_combine(sets.midcast.MndEnfeebles, {})
	sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles --what, like burn shock choke? why does this exist?
	
	--specific carveouts, for... reasons? the first three make sense but what on earth is with the last two, oh well
    sets.midcast['Blind II'] = set_combine(sets.midcast.IntEnfeebles, sets.midcast.EffectEnfeebles, {})
    sets.midcast['Dia III'] = set_combine(sets.midcast.MndEnfeebles, sets.midcast.EffectEnfeebles, {})
    sets.midcast['Dia II'] = set_combine(sets.midcast.MndEnfeebles, sets.midcast.EffectEnfeebles)
    sets.midcast['Paralyze II'] = set_combine(sets.midcast.MndEnfeebles, {})
    sets.midcast['Slow II'] = set_combine(sets.midcast.MndEnfeebles, {})

    --generic nuke set
    --commented out costing TP
    sets.midcast['Elemental Magic'] = {
	--main="Bunzi's Rod", --someday, augment this, but it'll be a longass time, rip my maxentius
	--sub="Daybreak", --offhand's magic damage works
	--ranged="Ullr", --I am a coward, this is +50 macc relative to "Sroda Tathlum" 10% chance of +25% damage, I hate getting resisted and if I'm nuking I don't care about TP
	head=gear.EmpyHead, --doesn't actually beat cait crown until +3 but +1 inv
    body=gear.EmpyBody,
    hands=gear.EmpyHands,
    legs=gear.EmpyLegs,
    feet=gear.EmpyFeet,
    neck="Sibyl Scarf", --10 int > 3 more mab from baetyl pendant
    waist="Orpheus's Sash", --screw it, even standing far away this is +1 inv over "Sacro Cord", even 1% is a lot though I imagine the 
    left_ear="Regal Earring",
    right_ear="Malignance Earring",
    left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --"Metamor. Ring +1", --this is the literal only place I reference this, it's 16 int / 15 macc, swapped out for +1 inventory even though that's bad
    right_ring="Freke Ring",
    back="Aurist's Cape +1", --gear.AmbuCape.INT has 20 mab but loses some macc and int and I hate getting resisted
	}

    --this is probably wrong honestly
    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Elemental Magic'], {
	    left_ring="Archon Ring",
	    --right_ring="Evanescence Ring", --not wasting a wardrobe slot until I'm ACTUALLY doing Aminon fight, but I do have this
	})

	--dark affinity works on Drain too, since it deals damage
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
	head="Pixie Hairpin +1",
	})

    sets.midcast.Aspir = sets.midcast.Drain --Aspir deals damage, just to MP and not HP (this is really how the formula works)
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {}) --what is this second one even for? accuracy set? I guess?
    sets.midcast['Bio III'] = set_combine(sets.midcast['Dark Magic'], {})
    
    --this spell is actually used for Aminon (the pendant is just chilling in some safe somewhere I'm sure)
    --per a Japanese twitter post I cannot read, Erra does work. beyond that we want maximum macc, so I'm gonna just write a whole set out here...
    sets.midcast['Absorb-TP'] = set_combine(sets.midcast['Dark Magic'], {neck="Erra Pendant",})

	--you need crep cloak on to cast Impact
    --beyond that, its best use is to spend 666 MP, thereby returning a lot of TP with Occult Acumen + Store TP (Impact can't miss, only get a duration down resist, so macc doesn't matter)
    sets.midcast.Impact = set_combine(sets.midcast.MndEnfeeblesAcc, {
        ammo="Coiste Bodhar", --3 stp
        head=empty, --I believe this does not require specification, but I am not willing to risk it
        body="Crepuscular Cloak", --impact, thank you
        hands=gear.MerlinicHandsImpact, --11 OA
        legs="Perdition Slops", --30 OA for some godawful reason why did the shadow lord have these okay it kind of makes flavor sense
        feet=gear.MerlinicFeetImpact, --11 OA
        neck="Combatant's Torque", --4 stp
        waist="Reiki Yotai", --4 stp
        left_ear="Crepuscular Earring", --5 stp
        right_ear="Telos Earring", --5 stp
        left_ring="Crepuscular Ring", --6 stp
        right_ring="Chirich Ring +1", --6 stp
        back="Null Shawl", --7 stp
    })

	--to cast Dispelga, you need to have Daybreak in your main hand.
	--this actually does not work as defined if Daybreak is in your offhand when you trigger it. see the alias I have defined for specifically Dispelga in init.txt for full details.
	sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeeblesAcc, {main="Daybreak"})

    --Trusts have to come out at i119 base, so make sure that you don't swap out of the i119 fast cast gear (and my fc gear is i119) - I'm frankly uncertain if this needs to exist, or if it's just because generic midcast is undefined?
    sets.midcast.Trust = sets.precast.FC

    --Job-specific buff sets
    --this is "while casting with Saboteur active", since that is what Saboteur cares about
    sets.buff.Saboteur = {
	    hands=gear.EmpyHands, --currently 13 potency+duration (regal cuffs is 0 potency 20 duration, so this is better at the cost of a small amount of duration)
	    right_ear="Regal Earring", --having a Lethargy piece on makes Regal give 10 macc, making it better than Malignance
	}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    --capped dt, 4 refresh. may have max hp issues with enhancing? haven't checked. watch for blood aggro I guess.
    sets.idle = {
	ammo="Staunch Tathlum +1", --3 dt (3)
	head="Null Masque", --10 dt, 1 refresh (13)
    body=gear.EmpyBody, --12 dt, 3 refresh (25)
    hands="Nyame Gauntlets", --7 dt (32)
    legs="Nyame Flanchard", --8 dt (40)
    feet="Nyame Sollerets", --7 dt (47)
	neck="Warder's Charm +1", --elemental res/magic null
    waist="Carrier's Sash", --elemental resistance
	left_ear="Alabaster Earring", --5 dt (51)
	right_ear="Eabani Earring", --15 eva lmao
    left_ring="Shneddick Ring +1", --movespeed
    right_ring="Shadow Ring", --magic null (could put stikini in for 1 more refresh, don't care. regen isn't at 0 because of null masque so I don't need chirich)
	back="Null Shawl", --meva
	}

	--never have I ever defined this set
    sets.magic_burst = set_combine(sets.midcast['Elemental Magic']),{
	--main="Bunzi's Rod", --10, sheol
	--sub=Ammurapi Shield, --this is so you can be sch
    --head="Ea Hat +1", --7+7, gil
    --body="Ea Houppe. +1", --9+9, gil
    hands="Regal Cuffs", --30 acc, could buy ea hands for more damage but I like accuracy
    --legs="Ea Slops +1", --8+8, gil
    feet="Bunzi's Sabots", --6, turns out I have this for smn lmao
    --ring2="Mujin Band", --5, gil
    }

    ------------------------------------------------------------------------------------------------
    --------------------------------------- In-Combat Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------

	--equip haste cap is 25%, malignance has that covered
	--magic haste cap is 43.75%, that's self-haste 2 + one external haste source (Ulmia/Joachim/Cornelia/another human/...Mayakov?)
	--nin dw trait is 25% (until nin 65, master levels might make that relevant in 2040) so need 11 DW, have 11 (reiki yotai 7 + 4 eabani earring)
	--current engaged DT is 31 from malignance + 10 from Ring + 5 from Alabaster Earring is 46 DT eh close enough (saves having a proper TP cape, it's in my mog locker)
    sets.engaged = {
	ammo="Coiste Bodhar", --DA
	head="Malignance Chapeau", --eventually bunzi hat at like r25+, but the other four aren't going anywhere (I will have that because brd uses it too)
    body="Malignance Tabard", --because I prioritize DT cap
    hands="Malignance Gloves", --over slightly more damage --no wait bunzi's gloves has 8 dt too
    legs="Malignance Tights", --from better pieces
    feet="Malignance Boots", --for melee damage
    neck="Combatant's Torque", --15 acc 15 atk 4 store tp (wardrobe 3 for inventory)
	waist="Reiki Yotai", --7 DW
    left_ear="Eabani Earring", --4 DW to hit exact cap
    right_ear="Alabaster Earring", --5 DT
    left_ring="Chirich Ring +1", --store tp, some subtle blow to be considerate to other people too
    right_ring="Murky Ring", --10 dt
    back="Null Shawl", --oops
	}
	
    --at some point I may want a subtle blow capped set but I don't think I'm bringing rdm and meleeing in those situations YET (or ever, really)
    --if I do, figure one out

    --swapped in automatically, see far below, wow it does orph sash based on proximity too, what nice mathw
    sets.Obi = {waist="Hachirin-no-Obi"}

	--fancy automatic weaponsets! thanks arislan!
	sets.Crocea = {main="Crocea Mors", sub="Bunzi's Rod"} --my default, really, 500% to enfire is cracked
    sets.Naegling = {main="Naegling", sub="Bunzi's Rod"} --no Thibron here, I don't want to sacrifice accuracy blindly
	sets.Tauret = {main="Tauret", sub="Bunzi's Rod"} --Aeolian Edge set
	sets.Maxentius = {main="Maxentius", sub="Bunzi's Rod"} --Black Halo set, really
    sets.Daggers = {main="Aern Dagger", sub="Aern Dagger II"} --lowest-delay I have (master trial dagger better, lmao)
    --note lack of a nuke-weapon-set. that's all done in the individual gearsets above for now
    --note lack of a dedicated Seraph Blade set (mh croc, oh db for +50 light affinity)

    --IF I EVER PLAN TO USE THIS SET: swap rdm category 2 merit points out of either immunobreak chance or magic accuracy (no idea if 25 macc is worth 15% immunobreak chance? immunobreak seems better?) to put in enspell
    --notes: enspell +X is additive with base damage and applied before the multiplicative boost from composure (and also crocea mors, which I think is additive with composure?)
    --yes, elemental affinity works on enspells
    --current stats: enspell +28, earth affinity +20, sroda tathlum crit2 chance. if legs merited, enspell +5 more.
    sets.Enspell = {
    ammo="Sroda Tathlum", --10% for +25% damage, including on enspell, and nothing else is better in the ranged slot (mab doesn't seem to do anything, right?)
    head="Umuthi Hat", --enspell +8
    body="Malignance Chapeau", --9 dt because nothing else more relevant
    hands="Aya. Manopolas +2", --enspell +17, 3 dt
    legs=gear.RelicLegs, --enspell +5 when enspell is fully merited, 5 pdt (this only benefits enspells WHEN MERITED, see notes above, so if not, eh, I don't care enough to change this)
    feet="Malignance Boots", --4 dt
    waist="Orpheus's Sash", --15 all affinity
    neck="Quanpur Necklace", --5 earth affinity - there's not any better specific affinity on any other piece so Enstone it is (Ongo V25 actively want stone, Odin indifferent)
    left_ear="Alabaster Earring", --5 gear haste, 5 dt (the gear haste actually matters)    --right_ear="Lycopodium Earring", --enspell +2 IF I HAD IT (never will at this rate, sheesh)
    right_ear="Hollow Earring", --enspell +3
    left_ring="Chirich Ring +1", --subtle blow and store tp (could use Hetairoi Ring for 2% TA on top of Temper, but it also gives +TA damage and I don't want to risk hitting Odin for 1. RDM not on Epona's.)
    right_ring="Murky Ring", --10 dt (41+36)
    back=gear.AmbuCape.TP, --stp, 10 pdt (51+36 and capped with Shell V)
    }
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Stupid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

	--for omen cure 500 hp objective, here's a +HP set to target myself with cure4 after equipping sets.naked, of course it's full nyame, lol.
	sets.HP = {
	head="Nyame Helm", --91 HP
    body="Nyame Mail", --136 HP
    hands="Nyame Gauntlets", --91 HP
    legs="Nyame Flanchard", --114 HP
    feet="Nyame Sollerets", --68 HP
	neck="Null Loop", --100 HP
	--waist="Plat. Mog. Belt", --10% HP lol inventory
	left_ear="Eabani Earring", --45 HP
	right_ear="Malignance Earring", --4 FC
	left_ring="Prolix Ring", --2 FC
	right_ring = "Kishar Ring", --4 FC
	}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end

	if spell.name == 'Dispelga' then
	    equip(sets.precast.Dispelga) --20230531 this doesn't solve "daybreak is in offhand and gs can't move it directly to main" but I solved that via my init.txt aliases
	end

    --if I accidentally try to cast Phalanx II on myself, cancel it
    if spell.english == "Phalanx II" and spell.target.type == 'SELF' then --sure let's leave this intact, cannot imagine why it matters at all but hey, phalanx 2 can go on allies, that's good to know!
        cancel_spell()
        send_command('@input /ma "Phalanx" <me>')
    end

end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)

    --equip appropriate enhancing magic set
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)

            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
                
                if spell.target.type == 'SELF' then
                    equip (sets.midcast.RefreshSelf)
                end
            end
        
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        
        elseif spell.english:startswith('Gain') then
            equip(sets.midcast.GainSpell)
        
        elseif spell.english:contains('Spikes') then
            equip(sets.midcast.SpikesSpell)
        end
        
        --truth be told, I think this may not always be correct - this is "buff duration with composure AFTER all skill etc swaps" which may not always be what I want - I'm just too lazy to think it through
        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
            equip(sets.buff.ComposureOther)
        end
    
    end
    
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
    
    --impact and dispelga need special traetment
    if spell.english == "Impact" then
        equip(sets.midcast.Impact)
    end
		
    if spell.english == 'Dispelga' then
	    equip(sets.midcast.Dispelga)
	end
    
    --20240712 second, distinct elemental magic if statement here? no. merged.
    if (spell.skill == 'Elemental Magic') or (spell.english == "Kaustra") then

        --first, check for magic burst. we'll replace with correct waist later because waist doesn't have mb gear. pretty sure you can MB death, why not set that here? I ain't using it to instagib things, I wanna do 99999.
        --not that rdm even GETS death...
        --also I don't have a magic burst state OR set defined
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end

        --very large if statement to handle equipping obi and sash correctly
        if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
            equip(sets.Obi)
        
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        
        -- Matching day and weather.
        elseif spell.element == world.day_element and spell.element == world.weather_element then
            equip(sets.Obi)
        
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        
        -- Match day or weather.
        elseif spell.element == world.day_element or spell.element == world.weather_element then
            equip(sets.Obi)
        end
    end
    
end

function job_aftercast(spell, action, spellMap, eventArgs)
        check_weaponset()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

--theoretically I care about this someday
--function job_buff_change(buff,gain)
--    if buff == "doom" then
--        if gain then
--            equip(sets.buff.Doom)
--            --send_command('@input /p Doomed.')
--             disable('ring1','ring2','waist')
--        else
--            enable('ring1','ring2','waist')
--            handle_equipping_gear(player.status)
--        end
--    end
--end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    check_weaponset()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
function job_handle_equipping_gear(playerStatus, eventArgs)
    --do nothing, lmao
end

--eventargs is some gearinfo garbage
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
        if spell.skill == 'Enfeebling Magic' then
            if enfeebling_magic_skill:contains(spell.english) then
                return "SkillEnfeebles"
            elseif spell.type == "WhiteMagic" then
                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                    return "MndEnfeeblesAcc"
                elseif enfeebling_magic_effect:contains(spell.english) then
                    return "MndEnfeeblesEffect"
                else
                    return "MndEnfeebles"
              end
            elseif spell.type == "BlackMagic" then
                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                    return "IntEnfeeblesAcc"
                elseif enfeebling_magic_effect:contains(spell.english) then
                    return "IntEnfeeblesEffect"
                elseif enfeebling_magic_sleep:contains(spell.english) then
                    return "Sleep"
                else
                    return "IntEnfeebles"
                end
            else
                return "MndEnfeebles"
            end
        end
    end
end

function customize_melee_set(meleeSet)
    --this will never be true
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end 

    --this is weapon set, real
    check_weaponset()

    --I don't know why it's called sets.engaged.enspell for arislan by default
    if state.EnspellSet.value == true then
        meleeSet = set_combine(meleeSet, sets.Enspell) 
    end
    
    return meleeSet
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or --any ranged attack
        category == 4 or -- any magic action
        (category == 3 and param == 30) -- Aeolian Edge
        then return true
    end
end

function check_weaponset()
    equip(sets[state.WeaponSet.current])
    
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
       equip(sets.DefaultShield)
    end
end
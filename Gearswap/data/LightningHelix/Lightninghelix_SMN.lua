--this is Kinematics, which builds off Mote. Arislan doesn't have a SMN lua. So really it's just a shell and I did the rest of the work.

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
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false

    magicalRagePacts = S{
        'Inferno','Earthen Fury','Tidal Wave','Aerial Blast','Diamond Dust','Judgment Bolt','Searing Light','Howling Moon','Ruinous Omen',
        'Fire II','Stone II','Water II','Aero II','Blizzard II','Thunder II',
        'Fire IV','Stone IV','Water IV','Aero IV','Blizzard IV','Thunder IV',
        'Thunderspark','Burning Strike','Meteorite','Nether Blast','Flaming Crush',
        'Meteor Strike','Heavenly Strike','Wind Blade','Geocrush','Grand Fall','Thunderstorm',
        'Holy Mist','Lunar Bay','Night Terror','Level ? Holy'}
		
	--fun fact, perfect defense has duration based on summoning magic skill like a BP Ward but is actually a BP Rage. see custom logic at very end of file.
	perfectdefense = S{'Perfect Defense'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

	gear.AmbuCape = {} --if I don't specify one, I am braindead, so I can leave this node blank
	gear.AmbuCape.PhysicalBP = { name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Mag. Evasion+15',}}
	gear.AmbuCape.MagicBP = { name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Eva.+20 /Mag. Eva.+20','Pet: Magic Damage+10','"Fast Cast"+10','Damage taken-5%',}}
	
	--I don't think there's a use for a second one of these, but just in case... max augs are 5 smn skill (yes) and 5 bp damage, 3 blood pact recast II, 15 enmity
	gear.JSECape = {}
	gear.JSECape.SummoningSkill = { name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+6','Blood Pact Dmg.+3',}}
	
	--could have a FC augmented pair of these too, but I don't care at the moment
	gear.MerlinicDastanas = {}
	gear.MerlinicDastanas.BP = { name="Merlinic Dastanas", augments={'Pet: Mag. Acc.+17 Pet: "Mag.Atk.Bns."+17','Blood Pact Dmg.+10','Pet: "Mag.Atk.Bns."+9',}}
	
	gear.Espiritus = {}
	gear.Espiritus.PathA = { name="Espiritus", augments={'Enmity-6','Pet: "Mag.Atk.Bns."+30','Pet: Damage taken -4%',}}
	gear.Espiritus.PathB = { name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}}

	gear.ApogeePumps = {}
	gear.ApogeePumps.PathA = { name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}}
	gear.ApogeePumps.PathB = { name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}}
	
    --trying something new
    gear.AFHead = {name="Convoker's Horn +2"} --unused, +4 makes it best pet macc for debuffs
    gear.AFBody = {name="Convoker's Doublet +3"} --45 macc/acc, 16 bp damage
    gear.AFHands = {name="Convoker's Bracers +2"} --unused, +4 makes it 58 acc/macc, 10 da, but I think I don't care?
    gear.AFLegs = {name="Convoker's Spats +2"} --+3 is 50 macc + 15 more from set bonus (beats empy +3), +4 gives another 10, more importantly empy pants are otherwise useless
    gear.AFFeet = {name="Convoker's Pigaches"} --unused
	gear.RelicHead = {name="Glyphic Horn +1"} --30 seconds astral flow duration
    gear.RelicBody = {name="Glyphic Doublet"} --unused
    gear.RelicHands = {name="Glyphic Bracers"} --unused
    gear.RelicLegs = {name="Glyphic Spats"} --unused
    gear.RelicFeet = {name="Glyphic Pigaches"} --unused
	gear.EmpyHead = {name="Beckoner's Horn +2"} --avatar's favor +4 up to +5, 3 refresh, 9 dt
    gear.EmpyBody = {name="Beckoner's Doublet +2"} --7 perp cost, 12 dt
    gear.EmpyHands = {name="Beckoner's Bracers +2"} --unused, mana cede +130% tp granted
    gear.EmpyLegs = {name="Beckoner's Spats +2"} --unused, arciela sinister reign pants have same tp bonus and +bp damage
    gear.EmpyFeet = {name="Beckoner's Pigaches"} --unused (technically not useless, elemental siphon +70, but I don't care)

end


-- Define sets and vars used by this job file.
function init_gear_sets()

    --------------------------------------
    -- Precast Sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Astral Flow'] = {
		head=gear.RelicHead,
		}
    
	--elemental siphon returns 1.05 * summoning magic skill, caps at 700, with some other irrelevant factors
    sets.precast.JA['Elemental Siphon'] = {
		--ammo="Esper Stone +1", --20 mp, eighth walk surged, inventory
		head=gear.EmpyHead, --18 skill
		body="Baayami Robe +1",
		hands="Baayami Cuffs +1",
		legs="Baayami Slops +1",
		feet="Baaya. Sabots +1", --empy feet superior if I find myself with many many free inventory slots and spare time
		left_ring="Evoker's Ring",
		right_ring={name="Stikini Ring +1", bag="wardrobe2"},
		left_ear="C. Palug Earring",
		right_ear="Lodurr Earring",
		--waist="Kobo Obi", --if inventory space is unlimited there's "Ligeia Sash" from siren fight
		neck="Incanter's Torque",
		back=gear.JSECape.SummoningSkill, --the base effect on this cape is +30 mp returned
		}

	--lol no, inventory slot
    sets.precast.JA['Mana Cede'] = {
		--hands=gear.EmpyHands, --+130% TP granted
		}

	--for all pact precasts, want Beckoner's Horn on, Avatar's Favor tiers give distinct recast reduction that you can't get anywhere else
    --bp delay reduction terms: 10 from jp when mastered, 10 from avatar's favor, cap of 20 from "bp delay I/II" which each individually cap at 15
	--sancus sachet +1 (II, 5) or epitaph (II, 5) plus baayami cuffs +1 (I, 7) and baayami slops +1 (I, 8) hit total cap (15+5) without having to use Mirke Wardecors/another reive cape
    sets.precast.BloodPactWard = {
		main=gear.Espiritus.PathB, --for summoning skill
		sub="Khonsu", --elan strap does not have any relevant stats, so DT here
		ammo="Sancus Sachet +1",
		head=gear.EmpyHead, --avatar's favor
		body="Baayami Robe +1",
		hands="Baayami Cuffs +1",
		legs="Baayami Slops +1",
		feet="Baaya. Sabots +1",
		left_ring="Evoker's Ring",
		right_ring={name="Stikini Ring +1", bag="wardrobe2"},
		left_ear="C. Palug Earring",
		right_ear="Lodurr Earring",
		--waist="Kobo Obi", --seiryu in escha-ruaun
		neck="Incanter's Torque",
		back=gear.JSECape.SummoningSkill,
		}

	--nirv is best for bp rage
    sets.precast.BloodPactRage = set_combine(sets.precast.BloodPactWard,{
		main="Nirvana"
		})

	--cap is 80 FC, this is 58
	--merlinic augments exist if I really, truly care, which I don't
    sets.precast.FC = {
		head="Amalric Coif +1", --11 (11) --keeping this, albeit in wardrobe 3, because it's rdm refresh potency, so might as well use it here
		body="Baayami Robe +1", --12 (23) --it's not summoning magic fc, weirdly, it's just normal fc!
		legs="Volte Brais", --8 (31)
		waist={name="Plat. Mog. Belt", priority=100}, --HP swap for safety
		neck="Orunmila's Torque", --5 (36)
		right_ear="Malignance Earring", --4 (42)
		--left_ear="Etiolation Earring", --1, inventory
		left_ring="Kishar Ring", --4 (46)
		right_ring="Prolix Ring", --2 (48)
		back=gear.AmbuCape.MagicBP, --10, lol (58)
		}

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = set_combine(sets.precast.FC, {
		})

	--baayami robe +1 is 100, caps SIRD with merits that I already have (because the cap is 1024/1024 = 102%)
	sets.midcast['Summoning Magic'] = {body = "Baayami Robe +1"}
        
    sets.midcast.Cure = {
		--main="Daybreak", --30, commented out to keep fulltime nirvana, but leaving it here for notes
		--ammo="Impatiens", --10 sird lmao
		head={name="Nyame Helm",priority=68}, --idk how many hp
		body={name="Nyame Mail",priority=100}, --HP, fake body="Bunzi's Robe", --15 pot
		hands={name="Nyame Gauntlets",priority=68}, --idk how many hp (bokwus gloves is 13 pot, but -1 inv)
		legs={name="Nyame Flanchard",priority=68}, --idk how many hp
		feet={name="Nyame Sollerets",priority=68}, --68 hp
		left_ear={name="Eabani Earring",priority=45}, --45 hp
		right_ear="Malignance Earring", --I'm sure if there's a MND cap we hit it but hey, can't hurt I guess?
        --left_ring="Lebeche Ring", --3 inventory
		--right_ring="Menelaus's Ring", --5 inventory
        neck="Nodens Gorget", --5 pot, wardrobe 3
		waist={name="Plat. Mog. Belt",priority=200}, --10% hp
		back=gear.AmbuCape.PhysicalBP, --pdt
		}

    sets.midcast.Stoneskin = {
		neck="Nodens Gorget",
		--waist="Siegel Sash"
		}

	sets.midcast.StatusRemoval = {}
    sets.midcast.Cursna = {} --set_combine(sets.midcast.StatusRemoval, {neck="Nicander's Necklace"}) --inventory

	--lmao never happening
    sets.midcast['Elemental Magic'] = {}
    sets.midcast['Dark Magic'] = {} --"Perimede Cape" 7 skill but ambu cape macc better anyway
    
	--for midcasts, losing the beckoner's horn drops you back down those bonus tiers, but they snap right back up when you have it back on
	--see custom mapping down there
	--ward is buffs, +1 second duration per summoning skill above 300
    sets.midcast.Pet.BloodPactWard = {
		sub="Elan Strap +1", --this is actually only mab and BP damage, but that's fine
		ammo="Sancus Sachet +1",
		head="Baayami Hat +1",
        body="Baayami Robe +1",
		hands="Baayami Cuffs +1",
		legs="Baayami Slops +1",
		feet="Baaya. Sabots +1",
		left_ring="Evoker's Ring",
		right_ring="Stikini Ring +1",
		left_ear="C. Palug Earring",
		right_ear="Lodurr Earring",
		neck="Incanter's Torque",
        --waist="Kobo Obi", --seiryu in escha ruaun
		back=gear.JSECape.SummoningSkill,
		}

	--debuffs need pet macc set
    sets.midcast.Pet.DebuffBloodPactWard = {
		sub="Elan Strap +1", --this is actually only mab and BP damage, but that's fine
		ammo="Sancus Sachet +1",
        head=gear.EmpyHead, --AF Head beats this at +4 (57+15 set vs 61 on +3 empy)
        body=gear.AFBody, --set bonus
		hands="Lamassu Mitts +1",
		legs=gear.AFLegs, --set bonus
		feet="Bunzi's Sabots", --this is 50 macc, BUT ALSO +1 pet level so losing convoker's set bonus like 10 macc is ok because you get raw stats from the level
		neck="Smn. Collar +2",
        waist="Regal Belt",
		left_ring="Evoker's Ring",
		right_ring="C. Palug Ring",
		left_ear="Lugalbanda Earring",
		right_ear="Enmerkar Earring",
		back=gear.JSECape.MagicBP,
		}
    
	--this is a pow pow set for hitting for damage, DA strong, BP easier to get so you need it in a lot higher amount to be better than DA
    sets.midcast.Pet.PhysicalBloodPactRage = {
		main="Nirvana",
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="Apogee Crown +1",
		body=gear.AFBody,
		hands=gear.MerlinicDastanas.BP,
		legs="Apogee Slacks +1",
		feet=gear.ApogeePumps.PathB, --per frod, the +1 level from bunzi's raw stats is not nearly as good as this
		neck="Smn. Collar +2",
		waist="Incarnation Sash", --the DA makes this better than Regal, allegedly
		left_ring={name="Varar Ring +1", bag="wardrobe1"},
		right_ring={name="Varar Ring +1", bag="wardrobe2"},
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring", --until smn sortie earring, even NQ
		back=gear.AmbuCape.PhysicalBP,
		}

	--for magical damage, don't want physical stats, obviously
    sets.midcast.Pet.MagicalBloodPactRage = {
		main=gear.Espiritus.PathA, --sorry Nirvana!
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="C. Palug Crown",
		body="Apo. Dalmatica +1",
		hands=gear.MerlinicDastanas.BP,
		legs="Enticer's Pants", --haha yesss thanks deeds
		feet=gear.ApogeePumps.PathA,
		neck="Smn. Collar +2",
		waist="Regal Belt",
		left_ring={name="Varar Ring +1", bag="wardrobe1"},
		right_ring={name="Varar Ring +1", bag="wardrobe2"},
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring", --until sortie earring, even NQ
		back=gear.AmbuCape.MagicBP,
		}

    --Spirits cast magic spells, which can be identified in standard ways, and also I don't think I care!
    sets.midcast.Pet.WhiteMagic = set_combine(sets.midcast.Pet.DebuffBloodPactWard, {}) --macc, enemy-targeted white magic is always debuffs (I'm not using a spirit to Banish)
    sets.midcast.Pet['Elemental Magic'] = set_combine(sets.midcast.Pet.BloodPactRage, {}) --magic damage oriented set

    --------------------------------------
    -- Idle set
    --------------------------------------
    
	--15 perp + 4 refresh + 2 refresh from smn traits = 21 total = 21 max perp cost with avatar's favor (because it's 14 * 1.5)
	--dt is capped, could needle cape to meva
	sets.idle = {
		main="Nirvana", --8 perp cost (8 perp)
		sub="Khonsu", --6 dt (6 dt, 8 perp)
		ammo="Sancus Sachet +1", --keep avatar at 119 at all times
        head=gear.EmpyHead, --9 dt, 4 favor tiers (15 dt, 8 perp)
		body=gear.EmpyBody, --12 dt, 7 perp cost (27 dt, 15 perp)
		hands="Nyame Gauntlets", --7 dt (34 dt, 15 perp) (-5 perp option here with lamassu mitts +1 if I need it)
		legs="Nyame Flanchard", --8 dt (42 dt, 15 perp) (over "Assiduity Pants +1" which give refresh/perp)
		feet="Bunzi's Sabots", --6 dt, avatar level +1 (48 dt, 15 perp, 1 refresh)
		neck="Sibyl Scarf", --1 refresh WHEN WINDURST CITIZEN [always] (48 dt, 15 perp, 2 refresh) (yes I genuinely need this 1 refresh here)
		waist="Carrier's Sash", --elemental resistance (48 dt, 15 perp, 2 refresh)
		left_ring={name="Stikini Ring +1", bag="wardrobe1"}, --1 refresh (48 dt, 15 perp, 3 refresh)
		right_ring="Shneddick Ring +1", --movespeed (48 dt, 15 perp, 3 refresh)
        left_ear="Alabaster Earring", --5 dt (53 dt, 15 perp, 3 refresh)
		right_ear="C. Palug Earring", --1 refresh (53 dt, 15 perp, 4 refresh)
        back=gear.AmbuCape.MagicBP --5 DT (58 dt, 18 perp, 4 refresh)
		}

    --------------------------------------
    -- Engaged set
    --------------------------------------
    
    --god help me I'm below gear haste cap here, it's literally 4+3+3+3+5+3 = 21
	--also I just have nothing better than nyame in these slots, like no store tp gear that smn can wear or anything
    sets.engaged = {
		main="Nirvana", --if I'm engaged, I'm building TP for Nirvana aftermath
		sub="Khonsu", --if I'm engaged, want -DT, 4 haste
		ammo="Sancus Sachet +1", --keep avatar at 119 at all times
		head=gear.EmpyHead, --favor tiers, 3 haste
		body="Nyame Mail", --3 haste
		hands="Nyame Gauntlets", --3 haste
		legs="Nyame Flanchard", --5 haste
		feet="Bunzi's Sabots", --+1 avatar level, 3 haste
		neck="Combatant's Torque", --thank god for job-agnostic store TP
		waist="Plat. Mog. Belt", --literally have no relevant melee belt, so keep the meva/dt
		left_ring="Chirich Ring +1", --stp
		right_ring="Murky Ring", --dt
        left_ear="Telos Earring", --da
		right_ear="Dedition Earring", --minus 10 acc but I'm assuming that if I'm meleeing I can hit stuff, because otherwise I'd be using wings/corsair regain roll
		back=gear.AmbuCape.PhysicalBP, --for the DT
		}

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for every WS except the Nirvana one below, which is the only one I'd ever actually use
    sets.precast.WS = {
        head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ring="Cornelia's Ring",
		right_ring="Epaminondas's Ring",
        left_ear="Malignance Earring",
		right_ear="Friomisi Earring",
		back=gear.AmbuCape.PhysicalBP, --for the DT
		}

	--this is the Nirvana mythic WS, so let's pretend its damage matters
	--magical, 70 mnd 30 str, formula based on dmnd, stack mnd and mab
	--at some point, some of this mab stuff should go to nyame once I augment it, except it's just nyame now because #lazy
    sets.precast.WS['Garland of Bliss'] = {
		head="C. Palug Crown", --in wardrobe 3 because rdm, so during free login use nyame
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Bunzi's Sabots", --this has +magic damage on it? that seems insane, actually
		neck="Sibyl Scarf", --inferior to baetyl pendant but lazy
		waist="Orpheus's Sash",
		left_ring="Cornelia's Ring",
		right_ring="Epaminondas's Ring", --sure, wst, whatever
		left_ear="Malignance Earring", --wardrobe 3
		right_ear="Friomisi Earring",
		back="Aurist's Cape +1", --raw mnd, could make an ambu cape but there's no way I ever bother, this is also in wardrobe 3
		}
		
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

-- Runs when pet completes an action. not currently used because custom ward timers eww
--function job_pet_aftercast(spell, action, spellMap, eventArgs)
--end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    elseif storms:contains(buff) then
        handle_equipping_gear(player.status)
    end
end


-- Called when the player's pet's status changes.
-- This is also called after pet_change after a pet is released.  Check for pet validity.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if pet.isvalid and not midaction() and not pet_midaction() and (newStatus == 'Engaged' or oldStatus == 'Engaged') then
        handle_equipping_gear(player.status, newStatus)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell)
    if spell.type == 'BloodPactRage' then
        if magicalRagePacts:contains(spell.english) then
            return 'MagicalBloodPactRage'
		elseif perfectdefense:contains(spell.english) then
			return 'BloodPactWard' --boy, do I hope this works
        else
            return 'PhysicalBloodPactRage'
        end
    elseif spell.type == 'BloodPactWard' and spell.target.type == 'MONSTER' then
        return 'DebuffBloodPactWard'
    end
end
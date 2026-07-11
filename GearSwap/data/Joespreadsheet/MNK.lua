--original: Motenten

--remaining to do: (ctrl-f for "to do" no space etc)
--hoxne ampulla swapped out
--stress test "combat form" and state.buff and all that to make sure that everything's working the way I expect it to on a dummy
--xoanon toggle and shell crusher set
--spinning attack set

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
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false
    state.Buff.Boost = buffactive.Boost or false --used for Ask Sash TP regain

    include('Mote-TreasureHunter')

    --tag mode for now
	windower.send_command('gs c set treasuremode Tag')
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    
    --normal mode is normal. expensive mode is full time hoxne ampulla.
    state.OffenseMode:options('Normal', 'Expensive')

    send_command('bind F10 gs c cycle OffenseMode')
    
    update_combat_form()
    update_melee_groups()

    --the two I care about here are done
    gear.AFHead = {name="Anchorite's Crown"} --no, focus buff
    gear.AFBody = {name="Anchorite's Cyclas"} --no, chakra buff
    gear.AFHands = {name="Anchorite's Gloves +4"} --BOOST PERCENTAGE DAMAGE BONUS also wsd+sb for the no-dt-yes-sb situation
    gear.AFLegs = {name="Anchorite's Hose"} --no, counter buff
    gear.AFFeet = {name="Anchorite's Gaiters +4"} --footwork! also, footwork! and additionally, footwork! (and a boost... boost.)
    
    --don't need to +4 any of these, can if I'm swimming in gil and units to have higher defensive stats just in case?
    gear.RelicHead = {name="Hesychast's Crown +2"} --Chi Blast enhance
    gear.RelicBody = {name="Hesychast's Cyclas +2"} --no (Formless Strikes duration)
    gear.RelicHands = {name="Hesychast's Gloves +2"} --Chakra removes plague/disease
    gear.RelicLegs = {name="Hesychast's Hose"} --no (Hundred Fists duration, don't care)
    gear.RelicFeet = {name="Hesychast's Gaiters"} --no (Mantra and Counterstance buffs)

    --take all five empy to +3
    gear.EmpyHead = {name="Bhikku Crown +2"} --tp piece, sb+dt
    gear.EmpyBody = {name="Bhikku Cyclas +2"} --tp piece when impetus up
    gear.EmpyHands = {name="Bhikku Gloves +2"} --atk/pdl ws piece
    gear.EmpyLegs = {name="Bhikku Hose +2"} --tp piece, allows extra kick attacks even without footwork
    gear.EmpyFeet = {name="Bhikku Gaiters +2"} --footwork buff
    
    --ambu capes, deliberately with stp because hoxne ampulla exists
    gear.AmbuCape = {}
    gear.AmbuCape.WS = {name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
    gear.AmbuCape.TP = {name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}

    --other augmented items
    gear.HercHelmFC = {name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+6','"Mag.Atk.Bns."+12',}}

    --stopgap until Volte Jupon takes same inventory slot
    gear.HercBootsTH = {name="Herculean Boots", augments={'Enmity-2','"Mag.Atk.Bns."+6','"Treasure Hunter"+2',}}

end


-- Define sets and vars used by this job file.
function init_gear_sets()

    --TH 2+2, replace when have Jupon
	sets.TreasureHunter = {
        feet=gear.HercBootsTH,
        left_ring="Hoxne Ring",
		--body="Volte Jupon", --2
		}

    --JA precast sets
    sets.precast.JA['Boost'] = {hands=gear.AFHands, waist="Ask Sash",} --ask sash gives TP on Boost, I believe it has to be equipped on use but I'm not sure, it's fine
    sets.precast.JA['Footwork'] = {feet=gear.EmpyFeet}
    sets.precast.JA['Dodge'] = {feet=gear.AFFeet} --free, because used for other real purposes
    --sets.precast.JA['Formless Strikes'] = {body=gear.RelicBody}
    --sets.precast.JA['Hundred Fists'] = {legs=gear.RelicLegs} --duration, but inventory
    --sets.precast.JA['Focus'] = {head=gearAFHead} --naw
    --sets.precast.JA['Counterstance'] = {feet=gear.RelicFeet} --never
    --sets.precast.JA['Mantra'] = {feet=gear.RelicFeet} --have I ever cared

    sets.precast.JA['Chi Blast'] = {
        head=gear.RelicHead,
        hands=gear.AFHands, --Boost works on Chi Blast, so I'm putting this here so I never have to think about it
        }

    sets.precast.JA['Chakra'] = {
        hands=gear.RelicHands,
        }

    --whatever I have lying around from other jobs that monk can also wear
    sets.precast.FC = {
        head=gear.HercHelmFC, --12
        body="Adhemar Jacket +1", --10
        hands="Leyline Gloves", --7, eventually 8
        neck="Orunmila's Torque", --5
        left_ear="Loquacious Earring", --2
        right_ear="Enchntr. Earring +1", --2
        left_ring = "Prolix Ring", --2
    }
    
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {}) --"Magoraga Beads" exists

    -- Midcast sets (do I care?)
    sets.midcast.FastRecast = {}
    sets.midcast.Utsusemi = {}

    --default WS set, for content that isn't good. just copypasted the Expensive set, honestly. not bothering to deal with DT or anything.
    --SB cap
    sets.precast.WS = {
        ammo="Coiste Bodhar",
        head="Mpaca's Cap",
        body="Ken. Samue +1", --I hate this so much but it cabs subtle blow
        hands=gear.EmpyHands,
        legs="Mpaca's Hose",
        feet="Mpaca's Boots",
        neck="Mnk. Nodowa +2", 
        waist="Moonbow Belt +1",
        left_ear="Hoxne Earring", --until "Sherida Earring" until MR7 "Hoxne Earring",
        right_ear="Moonshade Earring",
        left_ring="Cornelia's Ring", --until "Niqmaddu Ring",
        right_ring="Ilabrat Ring", --until "Regal Ring", --(unless I take Ephramad's Ring for tryhard Expensiveing and swap back after done)
        back=gear.AmbuCape.WS,
    }

    --default WS set going to match non-Footwork WS set for this combat mode
    --serious time, so yes PDL, yes capped SB, not even close to capped DT
    sets.precast.WS.Expensive = set_combine(sets.precast.WS, {
        ammo="Hoxne Ampulla",
        head="Mpaca's Cap",
        body="Ken. Samue +1", --I hate this so much
        hands=gear.EmpyHands,
        legs="Mpaca's Hose", --5 sb2 so I can swap Sherida when Hoxne is up to speed
        feet="Mpaca's Boots",
        neck="Mnk. Nodowa +2", 
        waist="Moonbow Belt +1",
        left_ear="Hoxne Earring", --until "Sherida Earring" until MR7 "Hoxne Earring",
        right_ear="Moonshade Earring",
        left_ring="Niqmaddu Ring", --stats!
        right_ring="Ilabrat Ring", --until "Regal Ring", --(unless I take Ephramad's Ring for tryhard Expensiveing and swap back after done)
        back=gear.AmbuCape.WS,
    })

    --the two kick WSes
    --TODO: this allegedly should not be full time, only when Footwork is up? I'm skeptical, but test
    sets.precast.WS['Dragon Kick'] = set_combine(sets.precast.WS, {
        feet=gear.AFFeet,
    })

    --TODO: confirm this (and all others) works correctly
    sets.precast.WS['Dragon Kick'].Expensive = set_combine(sets.precast.WS.Expensive, {
        feet=gear.AFFeet,
    })

    sets.precast.WS['Tornado Kick'] = sets.precast.WS['Dragon Kick']
    sets.precast.WS['Tornado Kick'].Expensive = sets.precast.WS['Dragon Kick'].Expensive
    
    --other wses that see use. set underscore combine used here for more modifiability in future, as though I'd ever care
    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Shijin Spiral'].Expensive = set_combine(sets.precast.WS.Expensive, {})
    sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Raging Fists'].Expensive = set_combine(sets.precast.WS.Expensive, {})
    sets.precast.WS['Howling Fist'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Howling Fist'].Expensive = set_combine(sets.precast.WS.Expensive, {})

    --other wses that exist enough for me to namedrop them here
    sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Asuran Fists'].Expensive = set_combine(sets.precast.WS.Expensive, {})
    sets.precast.WS["Victory Smite"] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Victory Smite'].Expensive = set_combine(sets.precast.WS.Expensive, {})
    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Cataclysm'].Expensive = set_combine(sets.precast.WS.Expensive, {})

    --this is a defense down that relies on magic accuracy to land, so it has to be a max macc set
    --did NOT consider subtle blow here - should I?
    sets.precast.WS['Shell Crusher'] = {
        ammo="Hoxne Ampulla",
        head=gear.EmpyHead,
        body=gear.EmpyBody,
        hands=gear.AFHands, --beats empy hands with set bonus
        legs=gear.EmpyLegs,
        feet=gear.AFFeet, --beats empy feet with set bonus
        neck="Null Loop",
        waist="Moonbow Belt +1", --no macc in this slot
        left_ear="Enchntr. Earring +1", --macc, godawful
        right_ear="Moonshade Earring", --duration is 180 -> 360 -> 540 in TP so this gives half a minute
        left_ring="Stikini Ring", --macc
        right_ring="Ilabrat Ring", --stats I guess, until "Regal Ring",
        back="Null Shawl",
    }

    sets.precast.WS['Shell Crusher'].Expensive = set_combine(sets.precast.WS['Shell Crusher'], {ammo="Hoxne Ampulla",})
    
    --notes about how this works that I don't think I need but I'm checking:
    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first. (ex: sets.engaged.Dagger.Accuracy.Evasion)
    
    --normal engaged set - SB capped and all that, but NOT hoxne ampulla (todo: do I literally ever use this?)
    --todo: figure out when I swap in the Duty gear - might just be instantly to be DT capped too?
    --note: logic far below handles "equip empy body during Impetus"
    --46 PDT, 36 MDT
    --subtle blow capped (empy head + schere earring 35+14+3 SB1 hits 50 cap, moonbow+niqmaddu+sherida = 25 SB2 for 75 overall cap)
    --might want to cap martial arts over dedition earring? one mache earring +1 is cap with capped gear haste and capped magic haste, apparently
    sets.engaged = {
        ammo="Coiste Bodhar",
        head=gear.EmpyHead, --11 dt (11)
        body="Mpaca's Doublet", --10 pdt when not in Impetus (0 when in impetus, not counted above)
        hands="Malignance Gloves", --5 dt (16)
        legs=gear.EmpyLegs, --30% kicks, 14 dt (30)
        feet=gear.AFFeet, --10% kicks, 120 base kick damage
        neck="Mnk. Nodowa +2", --25% kicks, 20 base kick damage
        waist="Moonbow Belt +1", --6 dt (36)
        left_ear="Dedition Earring", --until "Sherida Earring"
        right_ear="Schere Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Gere Ring",
        back=gear.AmbuCape.TP, --10 pdt
    }

    --is this needed to function? no clue.
    sets.engaged.Normal = sets.engaged

    --since I only made the one set, this is just the same as the normal set, except keeping hoxne on
    sets.engaged.Expensive = set_combine(sets.engaged.Normal, {
        ammo="Hoxne Ampulla",
    })

    --TODO: FIGURE OUT IF THIS WORKS
    -- Footwork combat form (doesn't actually change anything lol)
    sets.engaged.Footwork = set_combine(sets.engaged, {
        feet=gear.AFFeet,
    })

    sets.engaged.Expensive.Footwork = set_combine(sets.engaged.Expensive, {
        feet=gear.AFFeet,
    })

    --todo: does this work or is it in the wrong order
    sets.engaged.Impetus = set_combine(sets.engaged, {
        body=gear.EmpyBody,
    })

    sets.engaged.Expensive.Impetus = set_combine(sets.engaged.Expensive, {
        body=gear.EmpyBody,
    })

    
    --default idle set
    --dt: 3 + 10 + 9 + 7 + 14 + 7 + 5 = 55 so when empy legs are +3 can swap out Alabaster Earring
    sets.idle = {
        ammo="Staunch Tathlum +1", --3 dt
        head="Nyame Helm", --7 dt 123 meva until "Null Masque" which costs meva but gives regain
        body="Malignance Tabard", --9 dt 139 meva (same as Nyame) plus store TP
        hands="Nyame Gauntlets", --7 dt 112 meva
        legs=gear.EmpyLegs, --14 dt at +3, still capped at +2
        feet="Nyame Sollerets", --7 dt 150 meva
        neck="Warder's Charm +1", --magic null
        waist="Carrier's Sash", --Ask Sash logic below
        left_ear="Alabaster Earring", --"Eabani Earring" --8 meva is the best I can do in this ear without wasting an inventory slot, don't need Alabaster with +3 empy legs, keep it until then
        right_ear="Hearty Earring", --status resist
        left_ring="Shneddick Ring +1", --movespeed
        right_ring="Shadow Ring", --magic null 
        back="Null Shawl", --50 meva to compensate for Masque for Regain
    }

    --Regain (medal/masque) and Hoxne Ampulla locked in, other slots maxed meva and DT
    sets.idle.Expensive = {
        ammo="Hoxne Ampulla",
        head="Null Masque", --regain
        body="Malignance Tabard", --9 dt 139 meva (same as Nyame) plus store TP
        hands="Nyame Gauntlets", --7 dt 112 meva
        legs=gear.EmpyLegs, --14 dt at +3, still capped at +2
        feet="Nyame Sollerets", --7 dt 150 meva
        neck="Warder's Charm +1", --"Rep. Plat. Medal" if I switch citizenship literally just for this regain, which feels likely honestly
        waist="Carrier's Sash", --automatic Ask Sash swap is handled far below
        left_ring="Shneddick Ring +1", --honestly even this is flexible, right?
        right_ring="Shadow Ring", --surely we're not Roller's Ringing, are we?
        left_ear="Alabaster Earring", --dt?
        right_ear="Schere Earring", --minus enmity (and MP) I guess
        back=gear.AmbuCape.TP,
    }

    --see bottom of file here - some dark wizardry to make sure we get the FIRST tick
    sets.buff.Boost = {waist="Ask Sash"}
    sets.midcast['Boost'] = sets.precast.JA['Boost'] --likely irrelevant, it's the aftercast that's slamming on idle belt. even though aftercast doesn't.

    --used for Omen cure objectives
    sets.Omen = {
        main="Godhands",
        ammo="Coiste Bodhar", --not using Ampulla in Omen cure farming
        head=empty,
        body=empty,
        hands=empty,
        legs=empty,
        feet=empty,
        neck=empty,
        waist=empty,
        left_ring="Shneddick Ring +1", --haha there's no HP on this
        right_ring=empty,
        left_ear=empty,
        right_ear=empty,
        back=empty,
    }

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    
    -- Set Footwork as combat form any time it's active (removed Hundred Fists logic here)
    if buff == 'Footwork' and gain then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
    
    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Impetus" then
        classes.CustomMeleeGroups:clear()
        
        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
    end

    -- Update gear if any of the above changed
    if buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end

    --20260524 okay trying this here too - this should equip sets dot buff dot boost? - yes it does but it's too "late" to prevent an aftercast swap
    if buff == 'Boost' then
        handle_equipping_gear(player.status)
    end

end

--"Return true if we handled the aftercast work.  Otherwise it will fall back to the general aftercast() code in Mote-Include." ...except this quote doesn't mean RETURN TRUE, it means set eventargs dot handled to true here. thanks, ffxiah posters.
--this has to be here because the above job buff change function only kicks in when we get the buff, which is about 0.5 seconds after the activation, so we miss a Regain tick from the Sash if we don't have it. yes, it sucks, yes, I hate it, no, I don't know how to be more granular and not trigger every action.
function job_aftercast(spell, action, spellMap, eventArgs)
   
    if spell.english == "Boost" then
        equip(sets.buff.Boost)
        eventArgs.handled = true --I assume this is cleared later?
    else
        --otherwise, do nothing
    end

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

--this works, but only equips the Sash when something else triggers to take me to idle and I'm not certain why. trying above logic as well... and between the two it's fine, sure
function customize_idle_set(idleSet)
    
    --changed hardcoded waist = sash to this set so that I can add other things to that set if they ever give us any
    if buffactive.Boost then
        idleSet = set_combine(idleSet, sets.buff.Boost)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_combat_form()
    update_melee_groups()
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if buffactive.Footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    
    if buffactive.Impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
end
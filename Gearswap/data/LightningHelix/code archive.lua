--rdm odin botting
    --state.OffenseMode:options('None', 'Normal', 'Odin') --for botting --removed cause I got everything I want from him
    --state.EnspellMode = M(false, 'Enspell Melee Mode') --works, but currently unbound because I never use raw enspell damage
	--send_command('bind F10 gs c cycle EnspellMode')

	--no need to keep this around now, but eh
	sets.engaged.Odin = {
	main="Norgish Dagger",
	sub="Wind Knife", --eventually clear the Lion/Zeid/Aldo Zinnia Orb fight, make my current Norgish Dagger into Esikuva, then get another Norgish Dagger for offhand for -15 delay
	ammo="Coiste Bodhar", --DA is good, don't care about STP
	head="Umuthi Hat", --8 enspell damage! totally what this was intended for!
    body="Malignance Tabard", --nothing better in inventory, could be taeon or something but that requires aug chase
    hands="Aya. Manopolas +2", --enspell damage
    legs="Carmine Cuisses +1", --dw, not haste capped
    feet="Malignance Boots", --nothing better in inventory. could be taeon or something?
    neck="Combatant's Torque",
	waist="Orpheus's Sash", --enspell damage
	left_ear="Suppanomimi", --DW, because only 1 da/some acc from "Telos Earring", Eabani's 4 this is 5
    right_ear="Sherida Earring",
    left_ring="Hetairoi Ring", --assuming I don't miss Chirich's accuracy this is all upside
    right_ring="Petrov Ring", --see above
    back="Ghostfyre Cape", --5 enspell damage, don't have a DW cape so I'm only losing some accuracy in return, seems fine
	}
	
	sets.Odin = sets.engaged.Odin --just in case I make a mistake
	
	function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

	--20230530 added Odin botting mode
	--if state.OffenseMode.value == 'Odin' then
	--	meleeSet = sets.engaged.Odin
	--end
	--
    check_weaponset()

    return meleeSet
end


--thf cait botting

    --20230625 DACK remove these when done with cait botting
    --state.caitsith = M{'Normal', 'caitsith'}
    --state.WeaponskillMode:options('Normal', 'caitsith')

	--sets.caitsith = {legs="Nyame Flanchard", feet="Nyame Sollerets"}
	--takes HP when engaged to a prime number, lmao
	
	--sets.precast.WS['Evisceration'].caitsith = set_combine(sets.precast.WS['Evisceration'], {hands="Malignance Gloves"})	
	--takes HP when in evisc set to divisible by 29 and 71, or Prime Enough For Cat
	
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
	
	--remove this when done botting
	--if state.caitsith.current == 'caitsith' then
	--  meleeSet = set_combine(meleeSet, sets.caitsith)
	--end
	
    return meleeSet
end

--20230625 remove this, and all references to it, when done botting cait
--function check_caitsith()
    --if state.caitsith.current == 'caitsith' then
    --  equip(sets.caitsith)
    --end
--end

-- Handle notifications of general user state change. I have no clue what this does but it was in the RDM code that made the weapon set work there...
--function job_state_change(stateField, newValue, oldValue)
--    check_caitsith()
--end



-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
	elseif spell.en == ranged and not spell.interrupted then
		send_command('wait 1.2;input /ra <t>')
	end
	--check_caitsith()
end



--okay, let's see if I can get this no swap gear actually working the way I want it to
--jesus christ yeah it works by individual slot hell no let's not
--function job_buff_change(buff,loss)
  --if no_swap_gear:contains(player.equipment.left_ring) then
  --  disable("ring1")
  --else
  --  enable("ring1")
  --end
  --
  --if no_swap_gear:contains(player.equipment.right_ring) then
  --  disable("ring2")
  --else
  --  enable("ring2")
  --end

--todo: figure out where to put this, shouldn't be buff loss right? when it's used for fishing I mean
--if no_swap_gear:contains(player.equipment.ranged) then
    --disable("ranged")
  --else
--    enable("ranged")
--  end
--end

--used to unlock and unequip warp ring after zoning, which makes no sense
--windower.register_event('zone change',
--function()
--  enable("ring1")
--  enable("ring2")
--equip(sets.idle)
--end
--)
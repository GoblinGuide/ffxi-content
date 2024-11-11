_addon.name = 'targetstatuschecker'
_addon.author = 'me'
_addon.version = '1.0' --this will never do anything else therefore this is v1.0
_addon.language = 'English' --this exists?!
_addon.commands = {'targetstatuschecker', 'targetstatus', 'tsc'};

require('logger') --I like printing to chat log better and I don't like using windower.add_to_chat when I can just do notice()
res = require('resources') --gonna need a Rosetta Stone for status name to status id

--run the function when you tell it to
windower.register_event('addon command', function (...)
	args = T{...} --parse arguments input
	command = args[1] --valid inputs: "start", "check", anything else gets you the help
    StatusName = args[2] --valid inputs: hopefully, any status, bonus or malus

    --having learned this one trick, I will now apply it everywhere
	if S{'start','check'}:contains(command) then
		
        notice('Beginning status check for ' // StatusName
        check_target_status(StatusName)
	
    --just check manually
    
    else
 
        notice("Acceptable TSC commands are 'start' and 'check', both of which just run it. Second parameter's the buff you want to check for")

    end
end)


--this loop is the entire automated functionality
function check_target_status(StatusName)

    --note: this is your CURRENT IN-GAME TARGET. if you aren't targeting anything, you won't get anything out.
    TargetTable = windower.ffxi.get_mob_by_target('t')

    if TargetTable then

        notice('Current target is ' .. TargetTable.name .. '. Checking for ' .. StatusName '.')

        --buffs, as of 2024/07/03, start at ID 0 and go up to ID 633
        --thankfully, we are not looping over ALL buffs. we're looping over the buffs that our target HAS, which is far faster

        --...except this doesn't work.
        --mobs have debuffs - which is easy.
        --the player has windower.ffxi.get_player()
        --other party members are, per xivparty/partybuffs, included in update packets of type 0x076.
        --there's definitely a way to check puppets/summons/beastmaster pets/wyverns. I don't know it but it exists.
        --fellows... uh. um. er. yeah. not even documented anywhere.
        --this addon is literally not functional because I don't think it's done anywhere, BUT they can receive buffs...?


    else
        
        notice('No in-game target selected. Therefore, no target to be checked. Try again.')

    end

end

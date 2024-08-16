-- hack - workaround for windower.unregister_event being broken (https://github.com/Windower/Issues/issues/619)

local events = {
  last_attacked_target = nil,
  last_attacked_time = 0,
}

local handlers = {}
local registered_event_types = {}

windower.register_event('incoming chunk', function(id, data)
  if id ~= 0x28 then
    return
  end

  local action = packets.parse('incoming', data)

  if action['Actor'] == windower.ffxi.get_mob_by_target('me').id and
     action['Category'] == 1 then
    events.last_attacked_target = action['Target 1 ID']
    events.last_attacked_time = os.clock()
  end
end)

function events.register_event(event_type, f)
  if handlers[event_type] then
    bot.warning('Handler for ' .. event_type .. ' events already defined.')
  end
  handlers[event_type] = f

  if not registered_event_types[event_type] then
    windower.register_event(event_type, function(...)
      if handlers[event_type] then
        return handlers[event_type](...)
      end
    end)
    registered_event_types[event_type] = true
  end
end

function events.unregister_event(event_type, f)
  if handlers[event_type] == f then
    handlers[event_type] = nil
  end
end

function events.unregister_all()
  handlers = {}
end

return events
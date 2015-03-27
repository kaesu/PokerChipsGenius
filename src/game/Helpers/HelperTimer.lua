Timer = {
	create = function(duration, on_end, cycled)
		return TimeManager:shared():createTimer(duration, on_end, cycled)
	end,
	delete = function(id)
		TimeManager:shared():deleteTimer(id)
	end,
	deleteRef = function(timer_ref)
		if (timer_ref ~= nil) then
			assert(types.isTable(timer_ref))
			if (types.isTable(timer_ref)) then
				if (timer_ref.timer ~= nil) then
					Timer.delete(timer_ref.timer.id)
				end
			end
		end
	end,
}
class 'TimeManager' (Manager)

------------------------------------------------------------------------------------------

function TimeManager:onInit()
	self.info.timers = {}
	self.info.listeners = {}
	self.info.listeners.screens = {}
	self.info.listeners.entities = {}
	self.info.last_timer_id = 0
	self.info.time_since_last_frame = 0

	self:createSheduler()
	self:resume()
end

function TimeManager:onSceneRegistered()
	self:resume()
end

function TimeManager:onSceneUnregistered()
	for i, timer in pairs(self.info.timers) do
		self:deleteTimer(i)
	end
	self.info.timers = {}
	self:pause()
end

------------------------------------------------------------------------------------------

function TimeManager:deleteSheduler()
	if (self.sheduler_id ~= nil) then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.sheduler_id)
		self.sheduler_id = nil
	end
end

function TimeManager:createSheduler()
	self:deleteSheduler()
	self.sheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt) self:update(dt) end, 0, false)
end

function TimeManager:pause()
	self.info.pause = true
end

function TimeManager:resume()
	self.info.pause = false
end

------------------------------------------------------------------------------------------

function TimeManager:countTimers()
	assert(self.info)
	return table.size(self.info.timers)
end

------------------------------------------------------------------------------------------

function TimeManager:createTimer(duration, onEnd, cycled)
	assert(self.info)
	assert(types.isNumber(duration))
	assert(onEnd == nil or types.isFunction(onEnd))
	assert(cycled == nil or types.isBoolean(cycled))

	self.info.last_timer_id = self.info.last_timer_id + 1
	local timer_id = self.info.last_timer_id

	local timer = { id = timer_id, current_time = 0, duration = duration, onEnd = onEnd, cycled = cycled }
	local ref = { timer = timer }
	timer.ref = ref

	self.info.timers[timer_id] = timer

	return ref
end

function TimeManager:deleteTimer(id)
	assert(self.info)
	assert(types.isNumber(id))
	if (self.info.timers[id] == nil) then
		table.log(self.info.timers)
	end
	assert(self.info.timers[id] ~= nil)
	if (self.info.timers[id] ~= nil) then
		self.info.timers[id].ref.timer = nil
		self.info.timers[id].ref = nil
		self.info.timers[id] = nil
	end
end

function TimeManager:removeAssociatedTimers(object)
	for i, timer in pairs(self.info.timers) do
		if (timer.associated_object == object) then
			self:deleteTimer(i)
		end
	end
end

------------------------------------------------------------------------------------------

function TimeManager:update(dt)
	self.info.time_since_last_frame = dt

	for i, timer in pairs(self.info.timers) do
		if (timer.delete == true) then
			self:deleteTimer(i)
		end
	end

	for i, timer in pairs(self.info.timers) do
		timer.current_time = timer.current_time + dt
		if (timer.current_time >= timer.duration) then
			if (timer.cycled) then
				timer.current_time = timer.current_time - timer.duration
			else
				timer.delete = true
			end
			if (timer.onEnd) then
				timer.onEnd()
			end
		end
	end
	for i, listener in pairs(self.info.listeners.screens) do
		listener:update(dt)
	end
	for i, listener in pairs(self.info.listeners.entities) do
		listener:update(dt)
	end
end

function TimeManager:getTimeSinceLastFrame()
	return self.info.time_since_last_frame
end

------------------------------------------------------------------------------------------

function TimeManager:addUpdateListener(entity)
	assert(types.isEntity(entity) or types.isScreen(entity))
	if (types.isEntity(entity)) then
		assert(self.info.listeners.entities[entity:getID()] == nil)
		self.info.listeners.entities[entity:getID()] = entity
	end
	if (types.isScreen(entity)) then
		assert(self.info.listeners.screens[entity:getID()] == nil)
		self.info.listeners.screens[entity:getID()] = entity
	end
end

function TimeManager:removeUpdateListener(entity)
	assert(types.isEntity(entity) or types.isScreen(entity))
	if (types.isEntity(entity)) then
		assert(self.info.listeners.entities[entity:getID()] ~= nil)
		self.info.listeners.entities[entity:getID()] = nil
	end
	if (types.isScreen(entity)) then
		assert(self.info.listeners.screens[entity:getID()] ~= nil)
		self.info.listeners.screens[entity:getID()] = nil
	end
end

------------------------------------------------------------------------------------------
class 'TouchManager' (Manager)

------------------------------------------------------------------------------------------

function TouchManager:onInit()
	self.touches = {}
	self.touchLastID = 0
	self.info.touchable_entities = {}
end

function TouchManager:onSceneRegistered()
	self:enableInteraction()
end

function TouchManager:onSceneUnregistered()
	self:disableInteraction()
end

------------------------------------------------------------------------------------------

function TouchManager:registerTouchableLayer(entity)
	assert(types.isEntity(entity))
	assert(entity:getCocosEntity().registerScriptTouchHandler)
	assert(self.info.touchable_layer == nil)

	self.info.touchable_layer = entity
	self.info.touchable_entities = {}

	local function onTouchBegan(point)
		self:__onTouchBegan(point)
		return true
	end
	local function onTouchMoved(point)
		self:__onTouchMoved(point)
	end
	local function onTouchEnded(point)
		self:__onTouchEnded(point)
	end
	local function onTouch(eventType,x,y)
		local point = cc.p(x,y)
		local result
		if eventType == "began" then
			result = onTouchBegan(point)
		elseif eventType == "moved" then
			result = onTouchMoved(point)
		else
			result = onTouchEnded(point)
		end
--		PRINT(eventType, self:countTouches())
		return result
	end

	entity:getCocosEntity():registerScriptTouchHandler(onTouch)
	entity:getCocosEntity():setTouchEnabled(true)
end

function TouchManager:unregisterTouchableLayer(entity)
	assert(types.isEntity(entity))

	self.info.touchable_layer = nil
	entity:getCocosEntity():unregisterScriptTouchHandler()
	entity:getCocosEntity():setTouchEnabled(false)
end

function TouchManager:registerTouchListener(entity, onTouchBegan, onTouchMoved, onTouchEnded, onTouchCancelled)
	assert(types.isEntity(entity))
	assert(self.info.touchable_entities[entity:getID()] == nil)
	assert(types.isFunction(onTouchBegan))
	assert(types.isFunction(onTouchMoved))
	assert(types.isFunction(onTouchEnded))
	assert(types.isFunction(onTouchCancelled))

	self.info.touchable_entities[entity:getID()] = { entity = entity, onTouchBegan = onTouchBegan, onTouchMoved = onTouchMoved, onTouchEnded = onTouchEnded, onTouchCancelled = onTouchCancelled }
end

function TouchManager:unregisterTouchListener(entity)
	assert(types.isEntity(entity))
	assert(self.info.touchable_entities[entity:getID()] ~= nil)

	self.info.touchable_entities[entity:getID()] = nil
end

function TouchManager:__onTouchBegan(point)
	local touch = self:createTouch(point)
	if (self.interaction == true) then
		for i, data in pairs(self.info.touchable_entities) do
			if (types.isFunction(data.onTouchBegan)) then
				data.onTouchBegan(touch)
			end
		end
	end
end

function TouchManager:__onTouchMoved(point)
	local touch = self:getNearestTouch(point)
	self:updateTouch(touch, point)
	if (self.interaction == true and touch.active == true) then
		for i, data in pairs(self.info.touchable_entities) do
			if (types.isFunction(data.onTouchMoved)) then
				data.onTouchMoved(touch)
			end
		end
	end
end

function TouchManager:__onTouchEnded(point)
	local touch = self:getNearestTouch(point)
	self:updateTouch(touch, point)
	if (self.interaction == true and touch.active == true) then
		for i, data in pairs(self.info.touchable_entities) do
			if (types.isFunction(data.onTouchEnded)) then
				data.onTouchEnded(touch)
			end
		end
	end
	self:deleteTouch(touch)
end

------------------------------------------------------------------------------------------

function TouchManager:enableInteraction()
	self:setInteraction(true)
end

function TouchManager:disableInteraction(delay)
	self:setInteraction(false)
	if (types.isNumber(delay)) then
		assert(delay > 0)
		Timer.deleteRef(self.info.delay_enable_touches_timer_ref)
		self.info.delay_enable_touches_timer_ref = Timer.create(delay, function() self:enableInteraction() end)
	end
end

function TouchManager:setInteraction(interaction)
	assert(types.isBoolean(interaction))
	self.interaction = interaction
	if (self.interaction == false) then
		self:setTouchesInactive()
	end
end

function TouchManager:setTouchesInactive()
	for id, touch in pairs(self.touches) do
		touch.active = false
		for name, listener in pairs(self.info.touchable_entities) do
			listener.onTouchCancelled(touch)
		end
	end
end

------------------------------------------------------------------------------------------

function TouchManager:countTouches()
	assert(self.info)
	assert(self.touches)
	return table.size(self.touches)
end 

function TouchManager:getNearestTouch(point)
	assert(types.isPoint(point))
	assert(self.info)
	assert(self.touches)
	if (self.info) then
		local nearest = nil
		local distance = nil
		for i,touch in pairs(self.touches) do
			local touchPoint = touch.point
			local touchDistance = Point.distance(point, touchPoint)
			if (nearest == nil or touchDistance < distance) then
				nearest = touch
				distance = touchDistance
			end
		end
		return nearest
	end
	return nil
end

------------------------------------------------------------------------------------------

function TouchManager:getTouchWithID(id)
	assert(types.isNumber(id))
	assert(self.info)
	assert(self.touches)
	assert(self.touches[id])
	return self.touches[id]
end

function TouchManager:createTouch(point)
	assert(types.isPoint(point))
	assert(self.info)
	assert(self.touches)
	self.touchLastID = self.touchLastID + 1

	local responder = SceneManager:shared():getMainEntity():getResponderForTouchPoint(point)
	local responderID   = (responder ~= nil and responder:getID()   or nil)
	local responderName = (responder ~= nil and responder:getName() or nil)

	if (types.isNumber(responderID)) then
		local drag = DragManager:shared():getDragEntityWhoHasChildWithID(responderID)
		if (types.isEntity(drag)) then
			responder = drag
			responderID = drag:getID()
			responderName = drag:getName()
		end
	end

	PRINT('responder: { id = ' .. tostring(responderID) .. ', name = ' .. tostring(responderName) .. '}')

	local newTouch = {
		id = self.touchLastID,
		point = point,
		x = point.x,
		y = point.y,
		active = self.interaction,
		responder = responder,
	}
	self.touches[self.touchLastID] = newTouch

	return newTouch
end

function TouchManager:updateTouch(touch, point)
	assert(types.isTouch(touch))
	assert(types.isPoint(point))
	assert(self.info)
	assert(self.touches)
	assert(self.touches[touch.id])

--	local touch = self:getTouchWithID(touch.id)

	touch.prevPoint     = touch.point
	touch.point         = point
	touch.x             = point.x
	touch.y             = point.y
	touch.delta         = Point.subtract(touch.point, touch.prevPoint)
	touch.timeSincePrev = TimeManager:shared():getTimeSinceLastFrame()

	return touch
end

function TouchManager:deleteTouch(touch)
	assert(types.isTouch(touch))
	assert(self.info)
	assert(self.touches)
	assert(self.touches[touch.id])
	self.touches[touch.id] = nil
	return nil
end

------------------------------------------------------------------------------------------

function TouchManager:getTouches()
	local copied = {}
	for i, touch in pairs(self.touches) do
		copied[i] = table.copy(touch)
		copied[i].responder = touch.responder
	end
	return copied
end

------------------------------------------------------------------------------------------
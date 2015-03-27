class 'Screen' (Entity)

------------------------------------------------------------------------------------------

function Screen:__init(name)
	assert(types.isString(name))

	local cocos_entity = HelperCocos.createSpriteEntity()
	cocos_entity:setName(name)

	Entity.__init(self, cocos_entity)

	self.entities = {}
end

function Screen:init()
	self:loadContent()
	self:onInit()

	TimeManager:shared():addUpdateListener(self)
end

function Screen:onDestroy()
	TimeManager:shared():removeUpdateListener(self)
end

------------------------------------------------------------------------------------------

function Screen:respondsForTouchPoint(point)
	return false
end

------------------------------------------------------------------------------------------

function Screen:loadContent()
	local table = self:makeContent()

	local array = {}
	local last_id = 1

	for i, data in pairs(table) do
		local entity = EntityManager:shared():createEntity(data)
		local name = entity:getName()
		array[last_id] = { e = entity, p = data.parent, }
		last_id = last_id + 1
		self:registerEntity(entity)
	end

	for i, data in ipairs(array) do
		local entity = data.e
		local order = entity:getOrder()
		local parent = self
		local parentName = data.p
		if (types.isString(parentName)) then
			if (self.entities[parentName] == nil) then
				WARNING('Screen:loadContent', 'did not found entity with key {' .. parentName .. '}')
				assert(false)
			end
			parent = self.entities[parentName]
		end
		parent:addChild(entity, order)
	end
end

function Screen:onScreenSizeChanged()
	local table = self:makeContent()

	for i, data in pairs(table) do
		if (types.isString(data.key) and string.len(data.key) > 0) then
			EntityManager:shared():updateEntity(self.entities[data.key], data)
		end
	end
end

------------------------------------------------------------------------------------------

function Screen:registerEntity(entity)
	assert(types.isEntity(entity))
	local name = entity:getName()
	local id   = entity:getID()
	if (string.len(name) > 0) then
		if (self.entities[name] == nil) then
			self.entities[name] = entity
		else
			if (self.entities[name]:getID() ~= id) then
				WARNING('Screen:registerEntity', 'can not add two or more entities with same key on screen {' .. entity:getName() .. '}')
				assert(false)
			end
		end
	end
end

------------------------------------------------------------------------------------------

function Screen:getEntityNamed(name)
	assert(types.isString(name))
	assert(string.len(name) > 0)
	if (self:existEntityNamed(name) == false) then
		if (SceneManager:shared():getCurrentScene():existEntityNamed(name) == true) then
			return SceneManager:shared():getCurrentScene().entities[name]
		end
		table.log(self.entities)
		WARNING('Screen:getEntityNamed', 'is not exist entity with name {' .. name .. '}')
		assert(false)
	end
	return self.entities[name]
end

function Screen:existEntityNamed(name)
	assert(types.isString(name))
	assert(string.len(name) > 0)
	return (self.entities[name] ~= nil)
end

------------------------------------------------------------------------------------------

function Screen:addTimer(duration, onEnd, cycled)
	local associated_object = self
	return TimeManager:shared():createTimer(duration, onEnd, cycled, associated_object)
end

------------------------------------------------------------------------------------------
------                                    virtual                                   ------
------------------------------------------------------------------------------------------

function Screen:makeContent()
	return {}
end -- virtual

function Screen:onInit()
end -- virtual

function Screen:onUpdate(dt)
end -- virtual

function Screen:onScreenOrientationChanged()
end -- virtual

------------------------------------------------------------------------------------------
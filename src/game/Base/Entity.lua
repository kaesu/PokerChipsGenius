class 'Entity'

------------------------------------------------------------------------------------------

local ENTITY_MOVING_SEQUENCE_ID = 53209428
local ENTITY_FADING_SEQUENCE_ID = 10238912

------------------------------------------------------------------------------------------

Entities = {
	getNextID = function()
		Entities.entity_last_id = Entities.entity_last_id + 1
		return Entities.entity_last_id
	end,
	entity_last_id = 0,
}

------------------------------------------------------------------------------------------

function Entity:__init(cocos_entity)
	assert(cocos_entity ~= nil)
	assert(self.__cname ~= Entity.__cname) -- prevent to create object of class Entity, sort of abstract

	self.info = {}

	self.info.id = Entities.getNextID()
	assert(types.isNumber(self.info.id))

	self.info.children = {}
	self.info.entity = cocos_entity
	self.info.entityType = ce_type
	self.info.order = 0

	self:setMaxOpacity(1)
	self:setRespondable(true)
end

------------------------------------------------------------------------------------------

function Entity:destroy()
	self:onDestroy()

	self:unregisterUpdateListener()

	for i = table.size(self.info.children),1,-1 do
		self.info.children[i].entity:destroy()
	end

	if (self:getParent() ~= nil) then
		self:getParent():removeChild(self)
	else
		self.info.entity:removeFromParent()
		assert(false)
	end

	self.info = nil
end

function Entity:onDestroy()
end -- virtual

------------------------------------------------------------------------------------------

function Entity:getID()
	return self.info.id
end

function Entity:getType()
	return self.__cname
end

------------------------------------------------------------------------------------------

function Entity:update(dt)
	if (types.isFunction(self.info.onUpdate)) then
		self.info.onUpdate(dt)
	end
	self:onUpdate(dt)
end

function Entity:onUpdate(dt)
end -- virtual

function Entity:setOnUpdate(f)
	assert(types.isFunction(f))
	self.info.onUpdate = f
	self:registerUpdateListener()
end

function Entity:registerUpdateListener()
	if (self.info.update_listener_registered == nil) then
		self.info.update_listener_registered = true
		TimeManager:shared():addUpdateListener(self)
	end
end

function Entity:unregisterUpdateListener()
	if (self.info.update_listener_registered ~= nil) then
		self.info.update_listener_registered = nil
		TimeManager:shared():removeUpdateListener(self)
	end
end

------------------------------------------------------------------------------------------

function Entity:setName(name)
	assert(types.isString(name))
	self.info.entity:setName(name)
end

function Entity:getName()
	return self.info.entity:getName()
end

------------------------------------------------------------------------------------------

function Entity:setPosition(...)
	local args = {...}
	if (#args == 1) then
		assert(types.isPoint(args[1]))
	elseif (#args == 2) then
		assert(types.isNumber(args[1]) and types.isNumber(args[2]))
	else
		assert(false)
	end
	self.info.entity:setPosition(...)
end

function Entity:setPositionX(x)
	assert(types.isNumber(x))
	self.info.entity:setPositionX(x)
end

function Entity:setPositionY(y)
	assert(types.isNumber(y))
	self.info.entity:setPositionY(y)
end

function Entity:getPosition()
	return Point.position(self.info.entity)
end

function Entity:getPositionX()
	return self.info.entity:getPositionX()
end

function Entity:getPositionY()
	return self.info.entity:getPositionY()
end

function Entity:getScrX()
	return self:getScrPosition().x
end

function Entity:getScrY()
	return self:getScrPosition().y
end

--function Entity:getScrPosition()
--	return self.info.entity:convertToWorldSpace(self:getPosition())
--end

function Entity:getScrPosition()
	if (self.info.parent ~= nil) then
		local pp = self.info.parent:getScrPosition()
		local ps = self.info.parent:getContentSize()
		return cc.p(pp.x + self:getPositionX() - ps.width/2, pp.y + self:getPositionY() - ps.height/2)
	end
	return self:getPosition()
end

------------------------------------------------------------------------------------------

function Entity:setRotation(rotation)
	assert(types.isNumber(rotation))
	self.info.entity:setRotation(rotation)
end

function Entity:getRotation()
	return self.info.entity:getRotation()
end

------------------------------------------------------------------------------------------

function Entity:getWidth()
	return self:getContentSize().width
end

function Entity:getHeight()
	return self:getContentSize().height
end

------------------------------------------------------------------------------------------

function Entity:setScale(scale)
	assert(types.isNumber(scale) or types.isPoint(scale))
	local scale = (types.isNumber(scale)) and cc.p(scale, scale) or scale
	self:setScaleX(scale.x)
	self:setScaleY(scale.y)
end

function Entity:setScaleX(scale)
	assert(types.isNumber(scale))
	self.info.entity:setScaleX(scale)
end

function Entity:setScaleY(scale)
	assert(types.isNumber(scale))
	self.info.entity:setScaleY(scale)
end

function Entity:getScaleX()
	return self.info.entity:getScaleX()
end

function Entity:getScaleY()
	return self.info.entity:getScaleY()
end

------------------------------------------------------------------------------------------

function Entity:moveTo(time, destination, onEnd)
	assert(types.isNumber(time))
	assert(types.isPoint(destination))
	assert(onEnd == nil or types.isFunction(onEnd))

	if (self.info.old_respondable == nil) then
		self.info.old_respondable = self:isRespondable()
	end
	self:setRespondable(false)

	self.info.entity:stopActionByTag(ENTITY_MOVING_SEQUENCE_ID)

	local function _onEnd()
		self:setRespondable(self.info.old_respondable)
		self.info.old_respondable = nil
		if (types.isFunction(onEnd)) then
			onEnd()
		end
	end

	if (time == 0) then
		self:setPosition(destination)
		_onEnd()
	elseif (time > 0) then
		local MoveToAction = cc.MoveTo:create(time, destination)
		local CallFunction = cc.CallFunc:create(_onEnd)
		local Sequence = cc.Sequence:create(MoveToAction, CallFunction)
		Sequence:setTag(ENTITY_MOVING_SEQUENCE_ID)
		self.info.entity:runAction(Sequence)
	else
		assert(false)
	end
end

------------------------------------------------------------------------------------------

function Entity:setVisible(visible)
	self.info.entity:setVisible(visible)
end

function Entity:__fade(cocos_entity, time, toOpacity, onEnd)
	cocos_entity:stopActionByTag(ENTITY_FADING_SEQUENCE_ID)

	assert(types.isNumber(time))
	assert(types.isNumber(toOpacity))
	assert(toOpacity >= 0 and toOpacity <= 1)
	assert(onEnd == nil or types.isFunction(onEnd))

	if (types.isFunction(onEnd)) then
		local fading = cc.FadeTo:create(time, toOpacity * 255)
		local callFunction = cc.CallFunc:create(onEnd)
		local sequence = cc.Sequence:create(fading, callFunction)
		sequence:setTag(ENTITY_FADING_SEQUENCE_ID)
		cocos_entity:runAction(sequence)
	else
		local fading = cc.FadeTo:create(time, toOpacity * 255)
		fading:setTag(ENTITY_FADING_SEQUENCE_ID)
		cocos_entity:runAction(fading)
	end
end

function Entity:fade(time, toOpacity, onEnd)
	self:__fade(self.info.entity, time, toOpacity, onEnd)
end

function Entity:show(time, respond, _onEnd)
	assert(time == nil or (types.isNumber(time) and time >= 0))
	if (time == nil or time == 0) then
		self.info.entity:setVisible(true)
		self:restoreOpacity()
		if (types.isBoolean(respond)) then
			self:setRespondable(respond)
		else
			self:setRespondable(true)
		end
		if (types.isFunction(respond)) then
			respond()
		end
		if (types.isFunction(_onEnd)) then
			_onEnd()
		end
	else
		local onEnd = function()
			if (types.isBoolean(respond)) then
				self:setRespondable(respond)
			else
				self:setRespondable(true)
			end
			if (types.isFunction(respond)) then
				respond()
			end
			if (types.isFunction(_onEnd)) then
				_onEnd()
			end
		end
		Entity:__fade(self.info.entity, time, 1, onEnd)
		self.info.entity:setVisible(true)
	end
end

function Entity:hide(time, _onEnd)
	assert(time == nil or (types.isNumber(time) and time >= 0))
	if (time == nil or time == 0) then
		self.info.entity:setVisible(false)
		self:setRespondable(false)
		if (types.isFunction(_onEnd)) then
			_onEnd()
		end
	else
		local onEnd = function()
			self:hide()
			if (types.isFunction(_onEnd)) then
				_onEnd()
			end
		end
		Entity:__fade(self.info.entity, time, 0, onEnd)
	end
end

function Entity:isVisible()
	return self.info.entity:isVisible()
end

------------------------------------------------------------------------------------------

function Entity:getParentScreen()
	if (types.isScreen(self.info.parent)) then
		return self.info.parent
	elseif (types.isEntity(self.info.parent)) then
		return self.info.parent:getParentScreen()
	end
	return nil
end

------------------------------------------------------------------------------------------

function Entity:getParent()
	return self.info.parent
end

function Entity:setParent(parent)
	assert(types.isEntity(parent))
	assert(self.info.parent == nil)
	self.info.parent = parent
end

function Entity:setOrder(order)
	self.info.order = order
	if (self:getParent()) then
		self:getParent():reorderChild(self, order)
	end
end

function Entity:reorderChild(child, order)
	assert(types.isEntity(child))
	assert(types.isNumber(order))
	self.info.entity:reorderChild(child:getCocosEntity(), order)
	self:sortChildrenByOrder()
end

function Entity:addChild(entity, order)
	assert(types.isEntity(entity))
	assert(order == nil or types.isNumber(order))

	if (string.len(entity:getName()) > 0) then
		if (types.isScreen(self)) then
			self:registerEntity(entity)
		else
			local parentScreen = self:getParentScreen()
			if (parentScreen ~= nil) then
				parentScreen:registerEntity(entity)
			end
		end
	end

	entity:setParent(self)
	local e = entity:getCocosEntity()
	local o = order and order or entity:getOrder()
	self.info.entity:addChild(e, o)
	entity:setOrder(o)

	table.insert(self.info.children, { entity = entity })
	self:sortChildrenByOrder()
end

function Entity:removeChild(entity)
	assert(types.isEntity(entity))
	for i,k in pairs(self.info.children) do
		if (k.entity == entity) then
			table.remove(self.info.children, i)
			break
		end
	end
	self.info.entity:removeChild(entity:getCocosEntity())
end

function Entity:existChildNamed(name)
	assert(types.isString(name))
	assert(string.len(name) > 0)
	for i, k in pairs(self.info.children) do
		if (k.entity:getName() == name) then
			return true
		else
			local exist = k.entity:existChildNamed(name)
			if (exist == true) then
				return true
			end
		end
	end
	return false
end

function Entity:existChildWithID(id)
	assert(types.isNumber(id))
	for i, k in pairs(self.info.children) do
		if (k.entity:getID() == id) then
			return true
		else
			local exist = k.entity:existChildWithID(id)
			if (exist == true) then
				return true
			end
		end
	end
	return false
end

function Entity:sortChildrenByOrder()
	local function sort_predicate (a,b)
		assert(types.isEntity(a.entity))
		assert(types.isEntity(b.entity))
		return a.entity:getOrder() > b.entity:getOrder()
	end

	table.sort(self.info.children, sort_predicate)
end

function Entity:getOrder()
	return self.info.order
end

function Entity:logChildren(str)
	str = str and str or ''
	if (str == '') then
		PRINT('------------- CHILDREN: ----------------')
	end
	for i, v in pairs(self.info.children) do
		local child = v.entity
		assert(types.isEntity(child))
		local name = child:getName()
		local order = child:getOrder()
		local pos = child:getPosition()
		local size = child:getContentSize()
		local id = child:getID()
		local respondable = tostring(child:isRespondable())
		cclog('%s %4d %12s %5.1f, %5.1f, %5.1f, %5.1f, %4d, %3d, %s', str, i, name, size.width, size.height, pos.x, pos.y, order, id, respondable)
		child:logChildren(str .. ' ')
	end
	if (str == '') then
		PRINT('----------------------------------------')
	end
end

------------------------------------------------------------------------------------------

function Entity:getResponderForTouchPoint(point)
	if (self:isRespondable() == true) then
		local self_checked = nil
		for i, child in pairs(self.info.children) do
			child = child.entity
			if (self_checked ~= true and child:getOrder() < 0) then
				self_checked = true
				if (self:respondsForTouchPoint(point) == true) then
					return self
				end
			end
			local responder = child:getResponderForTouchPoint(point)
			if (responder ~= nil) then
				return responder
			end
		end
		if (self_checked ~= true and self:respondsForTouchPoint(point) == true) then
			return self
		end
	end
	return nil
end

function Entity:respondsForTouchPoint(point)
	if (self:isRespondable() == false) then
		return false
	end

	assert(types.isPoint(point))

	if (self.info.bounding_box_circle ~= nil) then
		local center_point = cc.p(self:getContentSize().width/2, self:getContentSize().height/2)
		local pw = self:getCocosEntity():convertToWorldSpace(center_point)
		return (Point.distance(pw, point) <= self.info.bounding_box_circle.radius)
	end

	local bbEntity = (self.info.bounding_box_entity ~= nil) and self.info.bounding_box_entity:getCocosEntity() or self:getCocosEntity()
	local bb = bbEntity:getBoundingBox()
	local p  = Point.position(bbEntity)
	local pw = bbEntity:convertToWorldSpace(cc.p(0,0))
	bb.x = pw.x
	bb.y = pw.y

	local result = cc.rectContainsPoint(bb, point)
--	cclog('%s respondsForTouchPoint? {%d, %d} = %d' , self:getName(), point.x, point.y, (result==true and 1 or 0))
	return result
end

function Entity:setBoundingBoxEntity(entity)
	assert(types.isEntity(entity))
	self.info.bounding_box_entity = entity
end

function Entity:setBoundingBoxCircle(point, radius)
	assert(types.isPoint(point))
	assert(types.isNumber(radius))
	assert(radius > 0)
	self.info.bounding_box_circle = { point = point, radius = radius }
end

------------------------------------------------------------------------------------------

function Entity:getCocosEntity()
	return self.info.entity
end

------------------------------------------------------------------------------------------

function Entity:isRespondable()
	return self.info.respondable
end

function Entity:setRespondable(respondable)
	assert(types.isBoolean(respondable))
	self.info.respondable = respondable
end

------------------------------------------------------------------------------------------

function Entity:setColor(color)
	self.info.entity:setColor(color)
end

function Entity:getColor()
	return self.info.entity:getColor()
end

function Entity:setOpacity(opacity)
	assert(types.isNumber(opacity))
	assert(opacity >= 0 and opacity <= 1)
	self.info.entity:setOpacity(opacity * 255)
end

function Entity:getOpacity()
	return self.info.entity:getOpacity() / 255
end

function Entity:restoreOpacity()
	self:setOpacity(self.info.max_opacity)
end

function Entity:setMaxOpacity(opacity)
	assert(types.isNumber(opacity))
	assert(opacity >= 0 and opacity <= 1)
	self.info.max_opacity = opacity
	if (self:getOpacity() > self.info.max_opacity) then
		self:restoreOpacity()
	end
end

------------------------------------------------------------------------------------------

function Entity:getContentSize()
	return self.info.entity:getContentSize()
end

function Entity:setContentSize(size)
	assert(types.isSize(size))
	self.info.entity:setContentSize(size)
end

------------------------------------------------------------------------------------------

function Entity:setTextureRect(rect)
	assert(types.isRect(rect))
--	if (self:getType() == 'sprite') then
		if (self.info.entity.setTextureRect) then
			self.info.entity:setTextureRect(rect)
		end
--	end
end

function Entity:setAnchorPoint(point)
	assert(types.isPoint(point))
	self.info.entity:setAnchorPoint(point)
end

------------------------------------------------------------------------------------------

function Entity:setMaskTexture(texture)
	assert(types.isFunction(self.info.entity.setMaskTexture))
	self.info.entity:setMaskTexture(texture)
end

------------------------------------------------------------------------------------------
class 'Drag' (Control)

------------------------------------------------------------------------------------------

local DRAGGING_TOP_ORDER = 9000

------------------------------------------------------------------------------------------

function Drag:__init(texture, size)
	local cocos_entity = HelperCocos.createSpriteEntity()
	Control.__init(self, cocos_entity)

	self.info.drag_entity = Sprite(texture, size)
	Control.addChild(self, self.info.drag_entity)

	self:setStartPosition(self:getPosition())
	self:setStartOrder(self:getOrder())
	self.info.dragging_in_the_moment = false

	DragManager:shared():registerDragEntity(self, self)
end

function Drag:onDestroy()
	Control.onDestroy(self)

	DragManager:shared():unregisterDragEntity(self)
end

------------------------------------------------------------------------------------------

function Drag:setStartPosition(point)
	assert(types.isPoint(point))
	self.info.start_position = point
end

function Drag:getStartPosition()
	return self.info.start_position
end

function Drag:setStartOrder(order)
	assert(types.isNumber(order))
	self.info.start_order = order
end

------------------------------------------------------------------------------------------

function Drag:onClickBegin(touch)
	self.info.delta_point = Point.subtract(touch.point, self:getPosition())
	self.info.dragging_in_the_moment = true
	self:setOrder(DRAGGING_TOP_ORDER)

	if (self.info.elevating == true) then
		self.info.drag_entity:moveTo(0.3, cc.p(self.info.delta_point.x, self.info.delta_point.y + 100))
	end

	Control.onClickBegin(self, touch)
end

function Drag:onDrag(touch)
	local point = cc.p(touch.point.x - self.info.delta_point.x, touch.point.y - self.info.delta_point.y)
	self:setPosition(point)
	Control.onDrag(self, touch)
end

function Drag:onClickEnd(touch)
	if (self.info.elevating == true) then
		self.info.drag_entity:moveTo(0.3, cc.p(0,0))
	end

	self:setOrder(self.info.start_order)
	local info = self:createSenderInfo(touch)
	local f = self.info.drop_predicate
	local successDrop = (f ~= nil) and f(info) or false
	if (successDrop == true) then
		self.info.dragging_in_the_moment = false
		if (self.info.on_drop_success ~= nil) then
			self.info.on_drop_success(info)
		end
	else
		if (self.info.on_drop_fail ~= nil) then
			self.info.dragging_in_the_moment = false
			self.info.on_drop_fail(info)
		else
			self:moveToStartPosition()
		end
	end

	Control.onClickEnd(self, touch)
end

------------------------------------------------------------------------------------------

function Drag:moveToStartPosition(factor)
	self.info.dragging_in_the_moment = true

	factor = (types.isNumber(factor) and factor >= 0) and factor or 1.0

	local destination = self.info.start_position
	local distance = Point.distance(destination, self:getPosition())
	local time = factor * 0.8 * distance / math.sqrt(math.pow(GET_SCREEN_WIDTH(), 2) + math.pow(GET_SCREEN_HEIGHT(), 2))
	self:setOrder(DRAGGING_TOP_ORDER)

	local function onEnd()
		self:setOrder(self.info.start_order)
		self.info.dragging_in_the_moment = false
		if (self.info.on_end_moving) then
			self.info.on_end_moving()
		end
	end

	self:moveTo(time, destination, onEnd)
end

------------------------------------------------------------------------------------------

function Drag:setDropPredicate(f)
	assert(types.isFunction(f))
	self.info.drop_predicate = f
end

function Drag:setOnDropSuccess(f)
	assert(types.isFunction(f))
	self.info.on_drop_success = f
end

function Drag:setOnDropFail(f)
	assert(types.isFunction(f))
	self.info.on_drop_fail = f
end

function Drag:setOnEndMovingToStartPosition(f)
	assert(types.isFunction(f))
	self.info.on_end_moving = f
end

------------------------------------------------------------------------------------------

function Drag:isDraggingInTheMoment()
	return self.info.dragging_in_the_moment
end

------------------------------------------------------------------------------------------

function Drag:enableElevatingOnStart()
	self.info.elevating = true
end

function Drag:disableElevatingOnStart()
	self.info.elevating = nil
end

------------------------------------------------------------------------------------------

function Drag:getPosition()
	return Point.sum(Control.getPosition(self),self.info.drag_entity:getPosition())
end

------------------------------------------------------------------------------------------

function Drag:getDragEntity()
	return self.info.drag_entity
end

------------------------------------------------------------------------------------------

function Drag:setColor(color)
	self:getDragEntity():setColor(color)
end

function Drag:getColor()
	return self:getDragEntity():getColor()
end

------------------------------------------------------------------------------------------

function Drag:addChild(child)
	self:getDragEntity():addChild(child)
end

------------------------------------------------------------------------------------------

function Drag:getContentSize()
	return self:getDragEntity():getContentSize()
end

------------------------------------------------------------------------------------------
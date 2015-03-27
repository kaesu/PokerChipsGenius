class 'Scroller' (Control)

------------------------------------------------------------------------------------------

function Scroller:__init(texture, size)
	local cocos_entity = HelperCocos.createSpriteEntity(texture, size)
	Control.__init(self, cocos_entity)

	self.info.scrolling_anchors = {}
	self:setScrollingEntity(self)
	self:setScrollingSpeedFactor(1)
	self:registerUpdateListener()
	self:setSwipeTime(0.3)
end

------------------------------------------------------------------------------------------

function Scroller:setScrollingEntity(entity)
	assert(types.isEntity(entity))
	self.info.scrolling_entity = entity
end

function Scroller:setScrollingRect(rect)
	assert(types.isRect(rect))
	self.info.scrolling_rect = rect
end

function Scroller:setScrollingLine(p1, p2)
	assert(types.isPoint(p1))
	assert(types.isPoint(p2))
	self.info.scrolling_line = {}
	self.info.scrolling_line[1] = p1
	self.info.scrolling_line[2] = p2
end

function Scroller:getScrollingLine()
	return self.info.scrolling_line
end

function Scroller:addScrollingAnchorPoint(point, power)
	assert(types.isPoint(point))
	assert(types.isNumber(power))
	assert(power > 0)
	table.insert(self.info.scrolling_anchors, { point = point, power = power,} )
	assert(table.size(self.info.scrolling_anchors) <= 2)
end

function Scroller:setScrollingSpeedFactor(factor)
	assert(types.isNumber(factor))
	self.info.scrolling_speed_factor = factor
end

function Scroller:removeScrollingAnchorPoints()
	self.info.scrolling_anchors = {}
end

------------------------------------------------------------------------------------------

function Scroller:onClickBegin(touch)
	Control.onClickBegin(self, touch)

	self.info.speed = cc.p(0,0)

	self.info.inertion_scrolling = nil
	self.info.scrolling_point = Point.subtract(touch.point, Point.position(self.info.scrolling_entity))
end

function Scroller:onDrag(touch)
	Control.onDrag(self, touch)

	self.info.speed = cc.p(touch.delta.x / touch.timeSincePrev * self.info.scrolling_speed_factor, touch.delta.y / touch.timeSincePrev * self.info.scrolling_speed_factor)

	local delta_x = touch.delta.x
	local delta_y = touch.delta.y

	local current_x = self.info.scrolling_entity:getPositionX() + self.info.scrolling_point.x + delta_x * self.info.scrolling_speed_factor
	local current_y = self.info.scrolling_entity:getPositionY() + self.info.scrolling_point.y + delta_y * self.info.scrolling_speed_factor

	local new_x = touch.point.x - self.info.scrolling_point.x
	local new_y = touch.point.y - self.info.scrolling_point.y
--	local new_x = current_x - self.info.scrolling_point.x
--	local new_y = current_y - self.info.scrolling_point.y
	local new_position = cc.p(new_x, new_y)

	if (self.info.scrolling_rect ~= nil) then
		new_position = Rect.getClosestPoint(self.info.scrolling_rect, new_position)
	elseif (self.info.scrolling_line ~= nil) then
		new_position = Line.getClosestPoint(self.info.scrolling_line[1], self.info.scrolling_line[2], new_position)
	else
		assert(false)
	end

	self.info.scrolling_entity:setPosition(new_position)
end

function Scroller:onClickEnd(touch)
	Control.onClickEnd(self, touch)

	assert(table.size(self.info.scrolling_anchors) == 2)
	local anchors_distance = Point.distance(self.info.scrolling_anchors[1].point, self.info.scrolling_anchors[2].point)
	assert(self.info.speed)

	local is_end = false
	for i, anchor in pairs(self.info.scrolling_anchors) do
		local distance = Point.distance(anchor.point, self.info.scrolling_entity:getPosition())
		if (distance == 0) then
			is_end = true
			break
		end
	end

	if (is_end == true) then
		self:inertionMoveEnd()
	else
		if (self.info.swipe_enabled == true and self:isSwipeGesture(self.info.speed)) then
			self.info.swiping = true
			if (self.info.swiping_left_point ~= nil and self:isSwipeLeft(self.info.speed)) then
				self:performSwipingMove(self.info.swiping_left_point, self.info.swipe_time)
			elseif (self.info.swiping_right_point ~= nil and self:isSwipeRight(self.info.speed)) then
				self:performSwipingMove(self.info.swiping_right_point, self.info.swipe_time)
			elseif (self.info.swiping_up_point ~= nil and self:isSwipeUp(self.info.speed)) then
				self:performSwipingMove(self.info.swiping_up_point, self.info.swipe_time)
			elseif (self.info.swiping_down_point ~= nil and self:isSwipeDown(self.info.speed)) then
				self:performSwipingMove(self.info.swiping_down_point, self.info.swipe_time)
			else
				self:performScrollingMove(self.info.speed, touch.point, anchors_distance)
			end
		else
			self:performScrollingMove(self.info.speed, touch.point, anchors_distance)
		end
	end
end

------------------------------------------------------------------------------------------

function Scroller:performSwipingMove(destination, time)
	local function onEnd()
		self:swipeMoveEnd()
	end
	self.info.scrolling_entity:moveTo(time, destination, onEnd)
end

function Scroller:performScrollingMove(speed, point, anchors_distance)
	self.info.inertion_scrolling = { speed = speed, point = point, anchors_distance = anchors_distance, }
	self.info.last_respondable = self:isRespondable()
	self:setRespondable(false)
end

------------------------------------------------------------------------------------------

function Scroller:setSwipingLeftPoint(point)
	assert(types.isPoint(point))
	self:enableSwipe()
	self.info.swiping_left_point = point
end

function Scroller:setSwipingRightPoint(point)
	assert(types.isPoint(point))
	self:enableSwipe()
	self.info.swiping_right_point = point
end

function Scroller:setSwipingUpPoint(point)
	assert(types.isPoint(point))
	self:enableSwipe()
	self.info.swiping_up_point = point
end

function Scroller:setSwipingDownPoint(point)
	assert(types.isPoint(point))
	self:enableSwipe()
	self.info.swiping_down_point = point
end

function Scroller:getSwipeValue()
	return 100 / 1136 * GET_SCREEN_WIDTH()
end

function Scroller:isSwipeUp(vector)
	return vector.y >= self:getSwipeValue()
end

function Scroller:isSwipeDown(vector)
	return vector.y <= -self:getSwipeValue()
end

function Scroller:isSwipeLeft(vector)
	return vector.x <= -self:getSwipeValue()
end

function Scroller:isSwipeRight(vector)
	return vector.x >= self:getSwipeValue()
end

function Scroller:isSwipeGesture(vector)
	return self:isSwipeUp(vector) or self:isSwipeDown(vector) or self:isSwipeLeft(vector) or self:isSwipeRight(vector)
end

------------------------------------------------------------------------------------------

function Scroller:inertionMoveEnd()
	if (self.info.last_respondable ~= nil) then
		self:setRespondable(self.info.last_respondable)
		self.info.last_respondable = nil
	end
	self.info.inertion_scrolling = nil
	if (self.info.on_inertion_move_end ~= nil) then
		self.info.on_inertion_move_end()
	end
end

function Scroller:setOnInertionMoveEnd(f)
	assert(types.isFunction(f))
	self.info.on_inertion_move_end = f
end

------------------------------------------------------------------------------------------

function Scroller:swipeMoveEnd()
	self.info.swiping = nil
	if (self.info.on_swipe_move_end ~= nil) then
		self.info.on_swipe_move_end()
	end
end

function Scroller:setOnSwipeMoveEnd(f)
	assert(types.isFunction(f))
	self.info.on_swipe_move_end = f
end

------------------------------------------------------------------------------------------

function Scroller:enableSwipe()
	self.info.swipe_enabled = true
end

function Scroller:disableSwipe()
	self.info.swipe_enabled = false
end

function Scroller:setSwipeTime(time)
	self.info.swipe_time = time
end

------------------------------------------------------------------------------------------

function Scroller:onUpdate(dt)
	if (self.info.inertion_scrolling ~= nil) then
		local current_position = self.info.scrolling_entity:getPosition()

		local inertion_power_sum = self.info.inertion_scrolling.speed
		assert(self.info.inertion_scrolling.speed ~= nil)
		self.info.inertion_scrolling.speed.x = self.info.inertion_scrolling.speed.x * 0.9
		self.info.inertion_scrolling.speed.y = self.info.inertion_scrolling.speed.y * 0.9

		for i, anchor in pairs(self.info.scrolling_anchors) do
			local distance_x = math.abs(anchor.point.x - current_position.x)
			local distance_y = math.abs(anchor.point.y - current_position.y)
			local distance = self.info.inertion_scrolling.anchors_distance
			local power_x = anchor.power * (distance - distance_x) / distance
			local power_y = anchor.power * (distance - distance_y) / distance
			if (anchor.point.x < current_position.x) then
				power_x = -power_x
			end
			if (anchor.point.y < current_position.y) then
				power_y = -power_y
			end
			inertion_power_sum.x = inertion_power_sum.x + power_x
			inertion_power_sum.y = inertion_power_sum.y + power_y
		end

		local new_x = self.info.scrolling_entity:getPositionX() + (inertion_power_sum.x * dt)
		local new_y = self.info.scrolling_entity:getPositionY() + (inertion_power_sum.y * dt)
		local new_position = cc.p(new_x, new_y)

		if (self.info.scrolling_rect) then
			new_position = Rect.getClosestPoint(self.info.scrolling_rect, new_position)
		elseif (self.info.scrolling_line ~= nil) then
			new_position = Line.getClosestPoint(self.info.scrolling_line[1], self.info.scrolling_line[2], new_position)
		else
			assert(false)
		end

		local is_end = false
		for i, anchor in pairs(self.info.scrolling_anchors) do
			local distance = Point.distance(anchor.point, new_position)
			if (distance == 0) then
				is_end = true
				break
			end
		end

		self.info.scrolling_entity:setPosition(new_position)

		if (self.info.on_inertion_move_update ~= nil) then
			self.info.on_inertion_move_update()
		end

		if (is_end) then
			self:inertionMoveEnd()
		end
	end
end

------------------------------------------------------------------------------------------

function Scroller:isInMoveNow()
	return self.info.inertion_scrolling ~= nil or self.info.swiping ~= nil
end

------------------------------------------------------------------------------------------

function Scroller:setOnInertionMoveUpdate(f)
	assert (types.isFunction(f))
	self.info.on_inertion_move_update = f
end

------------------------------------------------------------------------------------------
class 'Control' (Entity)

------------------------------------------------------------------------------------------

function Control:__init(cocos_entity)
	assert(cocos_entity ~= nil)
	assert(self.__cname ~= Control.__cname) -- prevent to create object of class Control, sort of abstract

	Entity.__init(self, cocos_entity)

	self.info.in_use = false

	local function onTouchBegan(touch)
		self:__onTouchBegan(touch)
	end
	local function onTouchMoved(touch)
		self:__onTouchMoved(touch)
	end
	local function onTouchEnded(touch)
		self:__onTouchEnded(touch)
	end
	local function onTouchCancelled(touch)
		self:__onTouchCancelled(touch)
	end
	TouchManager:shared():registerTouchListener(self, onTouchBegan, onTouchMoved, onTouchEnded, onTouchCancelled)
end

function Control:onDestroy()
	TouchManager:shared():unregisterTouchListener(self)
end

------------------------------------------------------------------------------------------

function Control:__onTouchBegan(touch)
	assert(types.isTouch(touch))
	if (touch.responder == self and self.info.touch_id == nil) then
		assert(self:isRespondable() == true)
		self.info.touch_id = touch.id
		self.info.in_use = true
		self:clickBegin(touch)
	end
end

function Control:__onTouchMoved(touch)
	if (self.info.touch_id == touch.id) then
		assert(self:isRespondable() == true)
		self:drag(touch)
	end
	if (self:respondsForTouchPoint(touch.point)) then
		self:dragInside(touch)
	else
		self:dragOutside(touch)
	end
end

function Control:__onTouchEnded(touch)
	assert(types.isTouch(touch))
	if (self.info.touch_id == touch.id) then
		assert(self:isRespondable() == true)
		self.info.in_use = false
		self:clickEnd(touch)
		local delay = BUTTON_DOUBLE_CLICK_MAX_DELAY

		if (self:respondsForTouchPoint(touch.point)) then
			if (self.info.double_click_enabled == true) then
				local timer = nil
				if (self.info.double_click_cooldown_timer_ref ~= nil) then
					timer = self.info.double_click_cooldown_timer_ref.timer
				end
				if (timer ~= nil) then
					Timer.delete(timer.id)
					self:doubleClick(touch)
				else
					self.info.double_click_cooldown_timer_ref = Timer.create(delay, nil)
					self:click(touch)
				end
			else
				self:click(touch)
			end
		end

		if (self.info ~= nil) then
			self.info.touch_id = nil
		end
	end
end

function Control:__onTouchCancelled(touch)
	assert(types.isTouch(touch))

	if (self.info == nil) then
		table.log(self.class)
		assert(false)
	end

	if (self.info.touch_id == touch.id) then
		self.info.touch_id = nil
		self.info.in_use = false
		self:cancelled(touch)
	end
end

------------------------------------------------------------------------------------------

function Control:abortTouch() -- use from scene
	assert(types.isNumber(self.info.touch_id))
	self:__onTouchCancelled(TouchManager:shared():getTouchWithID(self.info.touch_id))
end

------------------------------------------------------------------------------------------

function Control:setOnClick(onClick)
	assert(types.isFunction(onClick))
	self.info.onClick = onClick
end

function Control:setOnDoubleClick(onDoubleClick)
	assert(types.isFunction(onDoubleClick))
	self:enableDoubleClick()
	self.info.onDoubleClick = onDoubleClick
end

function Control:setOnDrag(onDrag)
	assert(types.isFunction(onDrag))
	self.info.onDrag = onDrag
end

function Control:setOnClickBegin(onClickBegin)
	assert(types.isFunction(onClickBegin))
	self.info.onClickBegin = onClickBegin
end

function Control:setOnClickEnd(onClickEnd)
	assert(types.isFunction(onClickEnd))
	self.info.onClickEnd = onClickEnd
end

function Control:setOnDragInside(onDragInside)
	assert(types.isFunction(onDragInside))
	self.info.onDragInside = onDragInside
end

function Control:setOnDragOutside(onDragOutside)
	assert(types.isFunction(onDragOutside))
	self.info.onDragOutside = onDragOutside
end

function Control:setOnCancelled(onCancelled)
	assert(types.isFunction(onCancelled))
	self.info.onCancelled = onCancelled
end

------------------------------------------------------------------------------------------

function Control:clickBegin(touch)
	self:onClickBegin(touch)
end

function Control:clickEnd(touch)
	self:onClickEnd(touch)
end

function Control:click(touch)
	self:onClick(touch)
end

function Control:doubleClick(touch)
	self:onDoubleClick(touch)
end

function Control:drag(touch)
	self:onDrag(touch)
end

function Control:dragInside(touch)
	self:onDragInside(touch)
end

function Control:dragOutside(touch)
	self:onDragOutside(touch)
end

function Control:cancelled(touch)
	self:onCancelled(touch)
end

------------------------------------------------------------------------------------------

function Control:createSenderInfo(touch)
	assert(types.isTouch(touch))
	local info = { touch = table.copy(touch), sender = self }
	return info
end

------------------------------------------------------------------------------------------

function Control:onClickBegin(touch)
	if (self.info.onClickBegin) then
		self.info.onClickBegin(self:createSenderInfo(touch))
	end
end

function Control:onClickEnd(touch)
	if (self.info.onClickEnd) then
		self.info.onClickEnd(self:createSenderInfo(touch))
	end
end

function Control:onClick(touch)
	if (self.info.onClick) then
		self.info.onClick(self:createSenderInfo(touch))
	end
end

function Control:onDoubleClick(touch)
	if (self.info.onDoubleClick) then
		self.info.onDoubleClick(self:createSenderInfo(touch))
	end
end

function Control:onDrag(touch)
	if (self.info.onDrag) then
		self.info.onDrag(self:createSenderInfo(touch))
	end
end

function Control:onDragInside(touch)
	if (self.info.onDragInside) then
		self.info.onDragInside(self:createSenderInfo(touch))
	end
end

function Control:onDragOutside(touch)
	if (self.info.onDragOutside) then
		self.info.onDragOutside(self:createSenderInfo(touch))
	end
end

function Control:onCancelled(touch)
	if (self.info.onCancelled) then
		self.info.onCancelled(self:createSenderInfo(touch))
	end
end

------------------------------------------------------------------------------------------

function Control:enableDoubleClick()
	self.info.double_click_enabled = true
end

function Control:disableDoubleClick()
	self.info.double_click_enabled = false
end

------------------------------------------------------------------------------------------

function Control:isInUseNow()
	return self.info.in_use
end

------------------------------------------------------------------------------------------
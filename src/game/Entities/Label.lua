class 'Label' (Entity)

------------------------------------------------------------------------------------------

function Label:__init(text, font, fontSize, size, alignment, bg_color)
	local cocos_entity = HelperCocos.createSpriteEntity()
	Entity.__init(self, cocos_entity)

	self.info.text_entity = HelperCocos.createTextEntity(text, font, fontSize, cc.size(size.width,0), alignment)

	self.info.entity:addChild(self.info.text_entity, 1)
	if (types.isSize(size)) then
		self.info.texture_rect = cc.rect(0,0,size.width,size.height)
	else
		self.info.texture_rect = cc.rect(0,0,0,0)
	end

	if (types.isString(bg_color)) then
		self:setBackgroundColor(HelperColor.colorFromString(bg_color))
	elseif (types.isColor(bg_color)) then
		self:setBackgroundColor(cc.c3b(bg_color.r,bg_color.g,bg_color.b))
	end
end

------------------------------------------------------------------------------------------

function Label:setBackgroundColor(color)
	assert(types.isColor(color))
	self.info.bg_color = color
	self:requireBG()
end

function Label:getBackgroundColor()
	return self.info.bg_color
end

function Label:requireBG()
	if (self.info.bg_color ~= nil) then
		if (self.info.bg_entity == nil) then
			self.info.bg_entity = HelperCocos.createSpriteEntity()
			self.info.entity:addChild(self.info.bg_entity, 0)
		end
		local rect = self.info.texture_rect
		self.info.bg_entity:setTextureRect(rect)
--		self.info.bg_entity:setPosition(rect.width/2,rect.height/2)
		self.info.bg_entity:setColor(self.info.bg_color)
	end
end

------------------------------------------------------------------------------------------

function Label:setText(str)
	self:setString(str)
end

function Label:setString(str)
	assert(types.isString(str))
	self.info.text_entity:setString(str)
	self:requireBG()
end

function Label:getText()
	return self:getString()
end

function Label:getString()
	return self.info.text_entity:getString()
end

------------------------------------------------------------------------------------------

function Label:setFontSize(size)
	self.info.text_entity:setFontSize(size)
end

------------------------------------------------------------------------------------------

function Label:setContentSize(size)
	assert(types.isSize(size))
	self.info.entity:setContentSize(size)
	
	self.info.text_entity:setContentSize(size)
	self.info.text_entity:setPosition(size.width/2,size.height/2)

	if (self.info.bg_entity ~= nil) then
		self.info.bg_entity:setContentSize(size)
		self.info.bg_entity:setPosition(size.width/2,size.height/2)
	end
end

function Label:getContentSize()
	return self.info.text_entity:getContentSize()
end

------------------------------------------------------------------------------------------

function Label:setTextureRect(rect)
--	self.info.text_entity:setTextureRect(rect)
--	self.info.text_entity:setPosition(rect.width/2, rect.height/2)
	self.info.texture_rect = rect
end

------------------------------------------------------------------------------------------

function Label:setColor(color)
	self.info.text_entity:setColor(color)
end

function Label:getColor()
	return self.info.text_entity:getColor()
end

function Label:setOpacity(opacity)
	assert(types.isNumber(opacity))
	assert(opacity >= 0 and opacity <= 1)
	self.info.entity:setOpacity(opacity * 255)
	self.info.text_entity:setOpacity(opacity * 255)
	if (self.info.bg_entity ~= nil) then
		self.info.bg_entity:setOpacity(opacity * 255)
	end
end

function Label:getOpacity()
	if (self.info.text_entity ~= nil) then
		return self.info.text_entity:getOpacity() / 255
	end
	return Entity.getOpacity(self)
end

------------------------------------------------------------------------------------------

function Label:show(time, respond, _onEnd)
	assert(time == nil or (types.isNumber(time) and time >= 0))
	if (time == nil or time == 0) then
		self.info.entity:setVisible(true)
		self.info.text_entity:setVisible(true)
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
		Entity:__fade(self.info.entity,      0.5, 1, onEnd)
		Entity:__fade(self.info.text_entity, 0.5, 1, onEnd)
		self.info.entity:setVisible(true)
		self.info.text_entity:setVisible(true)
	end
end

function Label:hide(time, _onEnd)
	assert(time == nil or (types.isNumber(time) and time >= 0))
	if (time == nil or time == 0) then
		self.info.entity:setVisible(false)
		self.info.text_entity:setVisible(false)
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
		Entity:__fade(self.info.entity,      0.5, 0, onEnd)
		Entity:__fade(self.info.text_entity, 0.5, 0, onEnd)
	end
end

------------------------------------------------------------------------------------------

function Label:setVisible(visible)
	self.info.entity:setVisible(visible)
	self.info.text_entity:setVisible(visible)
end

------------------------------------------------------------------------------------------
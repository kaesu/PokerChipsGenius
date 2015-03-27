class 'Button' (Control)

------------------------------------------------------------------------------------------

function Button:__init(texture, size)
	local cocos_entity = HelperCocos.createSpriteEntity(texture, size)
	Control.__init(self, cocos_entity)
end

------------------------------------------------------------------------------------------

function Button:hide(duration)
	Control.hide(self, duration)
	if (self.info.onHide) then
		self.info.onHide()
	end
end

function Button:show(duration)
	Control.show(self, duration)
	if (self.info.onShow) then
		self.info.onShow()
	end
end

function Button:enable()
	self:setRespondable(true)
	if (self.info.onEnable) then
		self.info.onEnable()
	end
end

function Button:disable()
	self:setRespondable(false)
	if (self.info.onDisable) then
		self.info.onDisable()
	end
end

------------------------------------------------------------------------------------------

function Button:setOnDisable(f)
	assert(types.isFunction(f))
	self.info.onDisable = f
end

function Button:setOnEnable(f)
	assert(types.isFunction(f))
	self.info.onEnable = f
end

function Button:setOnHide(f)
	assert(types.isFunction(f))
	self.info.onHide = f
end

function Button:setOnShow(f)
	assert(types.isFunction(f))
	self.info.onShow = f
end

------------------------------------------------------------------------------------------

function Button:requireTextEntity(str)
	if (self.info.text_entity == nil) then
		str = str or ''
		local w = self:getWidth()
		local h = self:getHeight()
		local font = cc.FileUtils:getInstance():fullPathForFilename(DEFAULT_FONT_NAME)
		self.info.text_entity = HelperCocos.createTextEntity(str, font, h * 0.8, cc.size(0,0), cc.TEXT_ALIGNMENT_CENTER)
		self.info.text_entity:setAnchorPoint(cc.p(0.5,0.5))
		self.info.text_entity:setPosition(cc.p(w/2, h/2))
		self.info.entity:addChild(self.info.text_entity, 2)
	end
end

function Button:setText(str)
	assert(types.isString(str))
	self:requireTextEntity(str)
	self.info.text_entity:setString(str)
end

function Button:setTextColor(color)
	assert(types.isColor(color))
	self:requireTextEntity()
	self.info.text_entity:setColor(color)
end

function Button:setTextFontSize(size)
	assert(types.isNumber(size))
	self:requireTextEntity()
	self.info.text_entity:setFontSize(size)
end

------------------------------------------------------------------------------------------

function Button:setTextureRect(rect)
	assert(types.isRect(rect))
	Control.setTextureRect(self,rect)
	if (self.info.text_entity ~= nil) then
		self.info.text_entity:setPosition(rect.width/2,rect.height/2)
	end
	if (self.info.rounded ~= nil) then
		self:updateRoundedSize(self:getContentSize())
	end
end

------------------------------------------------------------------------------------------

function Button:setColor(color)
	assert(types.isColor(color))
--	Control.setColor(self,color)
	if (self.info.rounded ~= nil) then
		self.info.rounded.left:setColor(color)
		self.info.rounded.right:setColor(color)
		self.info.rounded.center:setColor(color)
	else
		self.info.entity:setColor(color)
	end
end

function Button:setOpacity(opacity)
	assert(types.isNumber(opacity))
	assert(opacity >= 0 and opacity <= 1)
--	Control.setOpacity(self,opacity)
--	if (self.info.text_entity ~= nil) then
--		self.info.text_entity:setOpacity(opacity)
--	end
	if (self.info.rounded ~= nil) then
		self.info.rounded.left:setOpacity(opacity*255)
		self.info.rounded.right:setOpacity(opacity*255)
		self.info.rounded.center:setOpacity(opacity*255)
		self.info.entity:setOpacity(0)
	else
		self.info.entity:setOpacity(opacity*255)
	end
end

------------------------------------------------------------------------------------------

function Button:setStyle(style)
	if (style == 'rounded') then
		self:updateRoundedSize(self:getContentSize())
	end
end

function Button:updateRoundedSize(size)
	assert(types.isSize(size))

	local w = size.width
	local h = size.height
	local center_w = w-h

	if (self.info.rounded == nil) then
		self.info.rounded = {}

--		self.info.rounded.left   = Sprite('common/circle_64.png', cc.size(h,h))
--		self.info.rounded.right  = Sprite('common/circle_64.png', cc.size(h,h))
--		self.info.rounded.center = Sprite('',                     cc.size(center_w,h))

--		self.info.rounded.left:setRespondable(false)
--		self.info.rounded.right:setRespondable(false)
--		self.info.rounded.center:setRespondable(false)

		self.info.rounded.left   = HelperCocos.createSpriteEntity('common/circle_64.png', cc.size(h,h))
		self.info.rounded.right  = HelperCocos.createSpriteEntity('common/circle_64.png', cc.size(h,h))
		self.info.rounded.center = HelperCocos.createSpriteEntity('',                     cc.size(center_w,h))

		local a = self.info.rounded.left:getContentSize().width
		self.info.rounded.left:setTextureRect(cc.rect(0,0,a/2,a))
		self.info.rounded.right:setTextureRect(cc.rect(a/2,0,a/2,a))

		self.info.entity:addChild(self.info.rounded.left,   1)
		self.info.entity:addChild(self.info.rounded.center, 1)
		self.info.entity:addChild(self.info.rounded.right,  1)
	end

	self:setColor(self:getColor())
	self.info.entity:setOpacity(0)

	local x = w/2
	local y = h/2
	local dx = (center_w + h/2)/2
	self.info.rounded.left:setPosition(cc.p(x-dx,y))
	self.info.rounded.right:setPosition(cc.p(x+dx,y))
	self.info.rounded.center:setPosition(cc.p(x,y))
end

------------------------------------------------------------------------------------------
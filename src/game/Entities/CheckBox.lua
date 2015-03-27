class 'CheckBox' (Entity)

------------------------------------------------------------------------------------------

function CheckBox:__init(size, text)
	local cocos_entity = HelperCocos.createSpriteEntity('',size)
	Entity.__init(self, cocos_entity)

	local w = self:getContentSize().width
	local h = self:getContentSize().height

	self.info.text_entity      = Label(text,FONT,h*0.4,cc.size(w*0.8,h*0.6),'left')
	self.info.slider_bg_entity = Sprite('controls/checkbox/bg.png')
	self.info.slider_entity    = Slider('controls/checkbox/hexagon.png')

	local cs = self.info.slider_bg_entity:getContentSize()
	self.info.slider_tap_frame = Sprite('',cc.size(cs.width+80,cs.height+80))
	self.info.slider_tap_frame:setOpacity(0)

	self.info.text_entity:setColor(cc.c3b(0,0,0))
	self.info.text_entity:setPosition(w*0.4,h/2)

	self.info.slider_bg_entity:setPosition(cc.p(w*0.85, h/2))
	self.info.slider_tap_frame:setPosition(cc.p(w*0.85, h/2))

	self.info.slider_entity:setScaleX(0.3)
	self.info.slider_entity:setScaleY(0.3)

	local x1 = self.info.slider_bg_entity:getContentSize().width * 0.25
	local x2 = self.info.slider_bg_entity:getContentSize().width * 0.75
	local y = self.info.slider_bg_entity:getContentSize().height/2
	self.info.slider_entity:setPosition(cc.p(x1, y))
	self.info.slider_entity:setColor(cc.c3b(255,0,0))
	self.info.slider_entity:setScrollingLine(cc.p(x1, y), cc.p(x2, y))
	self.info.slider_entity:addScrollingAnchorPoint(cc.p(x1, y), 1000)
	self.info.slider_entity:addScrollingAnchorPoint(cc.p(x2, y), 1000)
	self.info.slider_entity:setValues(0, 1)
	self.info.slider_entity:setBoundingBoxEntity(self.info.slider_tap_frame)

	self:addChild(self.info.text_entity, 1)
	self:addChild(self.info.slider_tap_frame, 1)
	self:addChild(self.info.slider_bg_entity, 2)

	self.info.slider_bg_entity:addChild(self.info.slider_entity, 1)

	self:registerUpdateListener()
end

function CheckBox:onDestroy()
	Entity.onDestroy(self)
end

------------------------------------------------------------------------------------------

function CheckBox:onUpdate(dt)
	local value = self.info.slider_entity:getValue()

	local r = 255*(1-value)
	local g = 255*value
	local b = 100
	local color = cc.c3b(r,g,b)

	self.info.slider_entity:setColor(color)
end

------------------------------------------------------------------------------------------

function CheckBox:isChecked()
	return self.info.slider_entity:getValue() == 1
end

------------------------------------------------------------------------------------------
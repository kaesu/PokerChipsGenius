class 'ScrollView' (Control)

------------------------------------------------------------------------------------------

function ScrollView:__init(position, size)
	assert(types.isPoint(position))
	assert(types.isSize(size))

	local frame = HelperCocos.createSpriteEntity(nil, size)
	Control.__init(self, frame)

	self:setVisibleSize(size)
end

function ScrollView:onDestroy()
	Control.onDestroy(self)
end

------------------------------------------------------------------------------------------

function ScrollView:onClickBegin(touch)
	Control.onClickBegin(self,touch)
	self.info.delta_point = Point.subtract(touch.point, self:getPosition())
end

function ScrollView:onClickEnd(touch)
	Control.onClickEnd(self,touch)
end

function ScrollView:onDrag(touch)
	Control.onDrag(self,touch)
	local point = Point.subtract(touch.point, self.info.delta_point)
	point = self:normalizePosition(point)
	self:setPosition(point)
end

------------------------------------------------------------------------------------------

function ScrollView:normalizePosition(point)
	if (self.info.scrolling_static == true) then
		point = cc.p(0,0)
	elseif (self.info.scrolling_line ~= nil) then
		point = Line.getClosestPoint(self.info.scrolling_line[1],self.info.scrolling_line[2],point)
	elseif (self.info.scrolling_rect ~= nil) then
		point = Rect.getClosestPoint(self.info.scrolling_rect,point)
	end
	return point
end

function ScrollView:setVisibleSize(size)
	assert(types.isSize(size))
	self.info.visible_size = size
end

function ScrollView:setScrollableSize(size)
	assert(types.isSize(size))
	self:setContentSize(size)

	local d_w = size.width  - self.info.visible_size.width
	local d_h = size.height - self.info.visible_size.height

	local x = self:getPositionX() - d_w/2
	local y = self:getPositionY() - d_h/2
	local w = d_w
	local h = d_h

	if (w < 0) then
		w = 0
	end
	if (h < 0) then
		h = 0
	end

	assert(w >= 0)
	assert(h >= 0)
	if (w == 0 and h == 0) then
		self.info.scrolling_static = true
	elseif (w == 0) or (h == 0) then
		self.info.scrolling_line = {cc.p(x,y),cc.p(x+w,y+h)}
	else
		self.info.scrolling_rect = cc.rect(x,y,w,h)
	end

	self:setPosition(x,y)
end

------------------------------------------------------------------------------------------
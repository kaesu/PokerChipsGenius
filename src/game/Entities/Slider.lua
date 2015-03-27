class 'Slider' (Scroller)

------------------------------------------------------------------------------------------

function Slider:__init(texture, size)
	Scroller.__init(self, texture, size)

	local point = self:getPosition()
	self:setScrollingLine(point, point) -- линия, по которой будет двигаться слайдер
	self:setValues(0.0, 1.0)
end

------------------------------------------------------------------------------------------

function Slider:setValues(min, max)
	assert(types.isNumber(min))
	assert(types.isNumber(max))
	assert(min < max)
	self.info.min = min
	self.info.max = max
end

------------------------------------------------------------------------------------------

function Slider:getValue()
	assert(self:getScrollingLine() ~= nil)
	local current_point = self:getPosition()
	local distance = Point.distance(self:getScrollingLine()[1], current_point)
	local lineLength = Point.distance(self:getScrollingLine()[1], self:getScrollingLine()[2])
	local value = self.info.max - self.info.min
	return value * distance/lineLength
end

function Slider:setValue(value)
	assert(types.isNumber(value))
	assert(self:getScrollingLine() ~= nil)

	if (value > self.info.max) then
		value = self.info.max
	end
	if (value < self.info.min) then
		value = self.info.min
	end

	local valueLine = self.info.max-self.info.min
	local value = value - self.info.min
	local valueCoef = 0.0
	if (valueLine > 0.0) then
		valueCoef = value / valueLine
	end

	local d_x = self:getScrollingLine()[1].x - self:getScrollingLine()[2].x
	local d_y = self:getScrollingLine()[1].y - self:getScrollingLine()[2].y
	local point = Point.sum(cc.p(d_x * valueCoef, d_y * valueCoef), self:getScrollingLine()[1])

	self:setPosition(point)
end

------------------------------------------------------------------------------------------

function Slider:onClickBegin(touch)
	Scroller.onClickBegin(self, touch)

	local scrPoint = self.info.scrolling_entity:getScrPosition()
	local curPoint = self.info.scrolling_entity:getPosition()
	local point = touch.point
	point = cc.p(point.x + curPoint.x - scrPoint.x, point.y + curPoint.y - scrPoint.y)
	assert(self:getScrollingLine() ~= nil)
	point = Line.getClosestPoint(self:getScrollingLine()[1], self:getScrollingLine()[2], point)

	self.info.scrolling_entity:setPosition(point)
	self.info.scrolling_point = Point.subtract(touch.point, point)
end

function Slider:onDrag(touch)
	Scroller.onDrag(self, touch)
	local scrPoint = self.info.scrolling_entity:getScrPosition()
	local curPoint = self.info.scrolling_entity:getPosition()
	local point = touch.point

	point = cc.p(point.x + curPoint.x - scrPoint.x, point.y + curPoint.y - scrPoint.y)
	point = Line.getClosestPoint(self:getScrollingLine()[1], self:getScrollingLine()[2], point)
	self.info.scrolling_entity:setPosition(point)
end

function Slider:onClickEnd(touch)
	Scroller.onClickEnd(self, touch)
end

------------------------------------------------------------------------------------------
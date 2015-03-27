class 'ScissorBox' (Entity)

------------------------------------------------------------------------------------------

function ScissorBox:__init(position, size)
	local rect = cc.rect(position.x-size.width, position.y-size.height, size.width, size.height)
	local clipping = HelperCocos.createClippingRectEntity(rect)
	Entity.__init(self, clipping)
	self.info.rect = rect
	self.info.bounding_box = cc.rect(position.x-size.width/2, position.y-size.height/2, size.width, size.height)
end

function ScissorBox:getResponderForTouchPoint(point)
	if (self:respondsForTouchPoint(point)) then
		return Entity.getResponderForTouchPoint(self,point)
	end
end

function ScissorBox:respondsForTouchPoint(point)
	return cc.rectContainsPoint(self.info.bounding_box, point)
end

------------------------------------------------------------------------------------------
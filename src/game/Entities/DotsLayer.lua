class 'DotsLayer' (Entity)

------------------------------------------------------------------------------------------

function DotsLayer:create(point, size, margin)
	local cocos_entity = HelperCocos.createLayerEntity()
	return DotsLayer(cocos_entity, point, size, margin)
end

------------------------------------------------------------------------------------------

function DotsLayer:__init(cocos_entity, point, size, margin)
	Entity.__init(self, cocos_entity)
	self:createDots(point, size, margin)
	self:setRespondable(false)
end

------------------------------------------------------------------------------------------

function DotsLayer:createDots(point, size, margin)
	assert(types.isPoint(point))
	assert(types.isSize(size))
	assert(types.isNumber(margin))
	assert(size.width >= 1)
	assert(size.height >= 1)

	assert(self.info.created_dots == nil)
	self.info.created_dots = true

	local function createDot(position)
		local dot = HelperCocos.createSpriteEntity('game/bet/pattern/im_pattern.png')
		dot:setPosition(position)
		return dot
	end

	for x = 0, size.width-1 do
		for y = 0, size.height-1 do
			local position = cc.p(point.x + x * margin, point.y + y * margin)
			self:getCocosEntity():addChild(createDot(position))
		end
	end
end

------------------------------------------------------------------------------------------
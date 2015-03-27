class 'Sprite' (Entity)

------------------------------------------------------------------------------------------

function Sprite:__init(texture, size)
	local cocos_entity = HelperCocos.createSpriteEntity(texture, size)
	Entity.__init(self, cocos_entity)
end

function Sprite:onDestroy()
end

------------------------------------------------------------------------------------------
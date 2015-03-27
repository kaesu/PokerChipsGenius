class 'Layer' (Entity)

------------------------------------------------------------------------------------------

function Layer:__init()
	local cocos_entity = HelperCocos.createLayerEntity()
	Entity.__init(self, cocos_entity)
end

function Layer:onDestroy()
end

------------------------------------------------------------------------------------------

function Layer:respondsForTouchPoint(point)
	return false
end

------------------------------------------------------------------------------------------
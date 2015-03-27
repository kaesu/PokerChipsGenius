class 'TextField' (Entity)

------------------------------------------------------------------------------------------

function TextField:__init()
	local cocos_entity = HelperCocos.createTextFieldEntity()
	Entity.__init(self, cocos_entity)
end

function TextField:onInit()
end

function TextField:onDestroy()
	Entity.onDestroy(self)
end

------------------------------------------------------------------------------------------

function TextField:setText(str)
	assert(types.isString(str))
	if (self.info.entity.setText) then
		self.info.entity:setText(str)
	end
	if (self.info.entity.setString) then
		self.info.entity:setString(str)
	end
end

function TextField:setString(str)
	assert(types.isString(str))
	self:setText(str)
end

function TextField:getText()
	if (self.info.entity.getString) then
		return self.info.entity:getString()
	end
	if (self.info.entity.getText) then
		return self.info.entity:getText()
	end
	return ''
end

function TextField:getString()
	return self:getText()
end

------------------------------------------------------------------------------------------
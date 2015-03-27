class 'EditBox' (Entity)

------------------------------------------------------------------------------------------

function EditBox:__init(texture_bg, size)
	local cocos_entity = HelperCocos.createEditBoxEntity(texture_bg, size)
	Entity.__init(self, cocos_entity)

	local line_height = GET_SCREEN_HEIGHT()*0.01
	local line = Sprite('',cc.size(size.width,line_height))
		  line:setOrder(-1)
		  line:setColor(COLOR('gray'))
		  line:setPosition(size.width*0.5,line_height*0.5)
		  line:setRespondable(false)
	self:addChild(line)

	local text_hint = Label(':',DEFAULT_FONT_NAME,size.height*0.3,cc.size(size.width,0),'left')
		  text_hint:setOrder(-1)
		  text_hint:setColor(COLOR('black'))
		  text_hint:setPosition(size.width*0.5,size.height+text_hint:getHeight()*0.5)
		  text_hint:setRespondable(false)
	self:addChild(text_hint)
	self.info.text_hint = text_hint

	local function editboxEventHandler(eventType)
		if eventType == "began" then
			-- triggered when an edit box gains focus after keyboard is shown
			PRINT('EditBox event began')
		elseif eventType == "ended" then
			-- triggered when an edit box loses focus after keyboard is hidden.
			PRINT('EditBox event ended')
		elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
			PRINT('EditBox event changed: ' .. self:getText())
			self:updateTextHint()
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
			PRINT('EditBox event return')
		end
	end
	cocos_entity:registerScriptEditBoxHandler(editboxEventHandler)

	self:updateTextHint()
end

function EditBox:onDestroy()
	Entity.onDestroy(self)
end

------------------------------------------------------------------------------------------

function EditBox:updateTextHint()
	if (string.len(self:getText()) > 0) then
		self.info.text_hint:show(0,false)
	else
		self.info.text_hint:hide(0)
	end
end

------------------------------------------------------------------------------------------

function EditBox:setText(str)
	assert(types.isString(str))
	if (self.info.entity.setText) then
		self.info.entity:setText(str)
	end
	if (self.info.entity.setString) then
		self.info.entity:setString(str)
	end
	self:updateTextHint()
end

function EditBox:setString(str)
	assert(types.isString(str))
	self:setText(str)
end

function EditBox:getText()
	if (self.info.entity.getString) then
		return self.info.entity:getString()
	end
	if (self.info.entity.getText) then
		return self.info.entity:getText()
	end
	return ''
end

function EditBox:getString()
	return self:getText()
end

------------------------------------------------------------------------------------------

function EditBox:setPlaceHolder(str)
	assert(types.isString(str))
	self.info.entity:setPlaceHolder(str)
	self.info.text_hint:setString(str..':')
end

------------------------------------------------------------------------------------------
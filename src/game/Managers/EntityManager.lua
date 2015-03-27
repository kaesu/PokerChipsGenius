class 'EntityManager' (Manager)

------------------------------------------------------------------------------------------

function EntityManager:onInit()
	self.info.cached_entities = {}
end

function EntityManager:onSceneRegistered()
	self.info.cached_entities = {}
end

function EntityManager:onSceneUnregistered()
	self.info.cached_entities = {}
end

------------------------------------------------------------------------------------------

function EntityManager:getCachedEntityValue(entityKey, param)
	if (self.info.cached_entities[entityKey] ~= nil) then
		return self.info.cached_entities[entityKey][param]
	end
	WARNING('EntityManager:getCachedEntityValue', 'has no cached entity with key: ' .. entityKey)
	return 0
end

function EntityManager:cacheEntityInfo(data)
	if (types.isString(data.key) and string.len(data.key) > 0) then
--		print('EntityManager:cacheEntityInfo, key = ' .. data.key .. ', w = ' .. data.w .. ', h = ' .. data.h)
		self.info.cached_entities[data.key] = { w = data.w, h = data.h, }
	end
end

------------------------------------------------------------------------------------------

function EntityManager:parseString(str, parentKey, isW, reverseEnabled)
	local number = tonumber(string.match(str, '-?%d+[.%d+]*'))
	if (types.isNumber(number)) then
--		PRINT('number from string {' .. str .. '} is: ' .. tostring(number))

		local length = 0

		local isPixels  = string.find(str, 'px')
		local isProcent = string.find(str, '%%')

		if (isPixels ~= nil and isProcent ~= nil) then
			WARNING('EntityManager:parseString', 'string format has opposite values \'%\' and \'px\'')
		end

		if (isProcent ~= nil) then
			local isWidth  = string.find(str, 'W')
			local isHeight = string.find(str, 'H')
			local param = 'w'
			if (isW ~= true) then
				param = 'h'
			end
			if (isWidth ~= nil) then
				param = 'w'
			elseif (isHeight ~= nil) then
				param = 'h'
			end
			if (isWidth ~= nil and isHeight ~= nil) then
				WARNING('EntityManager:parseString', 'string format has opposite values \'W\' and \'H\': {' .. str .. '}')
			end

			local isParent = string.find(str, 'P')
			if (isParent ~= nil) then
				length = self:getCachedEntityValue(parentKey or '',param)
			else
				length = (param == 'w') and GET_SCREEN_WIDTH() or GET_SCREEN_HEIGHT()
			end

			number = length * number / 100
		end

		if (reverseEnabled == true) then
			local isReverse = string.find(str, 'R')
			if (isReverse ~= nil) then
				local isParent = string.find(str, 'P')
				local param = (isW == true) and 'w' or 'h'
				local l = 0
				if (isParent ~= nil) then
					l = self:getCachedEntityValue(parentKey or '',param)
				else
					l = (param == 'w') and GET_SCREEN_WIDTH() or GET_SCREEN_HEIGHT()
				end
				number = l - number
			end
		end
	else
		WARNING('EntityManager:parseString', 'string format has no number: {' .. str .. '}')
		return 0
	end

	return number
end

function EntityManager:parseWidth(str, parentKey)
	return self:parseString(str,parentKey,true,false)
end
function EntityManager:parseHeight(str, parentKey)
	return self:parseString(str,parentKey,false,false)
end
function EntityManager:parseX(str, parentKey)
	return self:parseString(str,parentKey,true,true)
end
function EntityManager:parseY(str, parentKey)
	return self:parseString(str,parentKey,false,true)
end
function EntityManager:parseTextSize(str, parentKey)
	return self:parseString(str,parentKey,false,false)
end

------------------------------------------------------------------------------------------

function EntityManager:normalizeSize(data)
	local size = cc.size(0,0)
	if (types.isNumber(data.wp)) then
		size.width = data.wp / 100 * GET_SCREEN_WIDTH()
	end
	if (types.isNumber(data.hp)) then
		size.height = data.hp / 100 * GET_SCREEN_HEIGHT()
	end
	if (types.isString(data.w)) then
		size.width = self:parseWidth(data.w, data.parent)
	end
	if (types.isString(data.h)) then
		size.height = self:parseHeight(data.h, data.parent)
	end
	if (types.isNumber(data.ratio)) then
		if (size.width > size.height) then
			size.width = size.height * data.ratio
		else
			assert(data.ratio ~= 0)
			size.height = size.width / data.ratio
		end
	end
	return size
end
function EntityManager:normalizePosition(data)
	local position = cc.p(0,0)
	if (types.isNumber(data.xp)) then
		position.x = data.xp / 100 * GET_SCREEN_WIDTH()
	end
	if (types.isNumber(data.yp)) then
		position.y = data.yp / 100 * GET_SCREEN_HEIGHT()
	end
	if (types.isString(data.x)) then
		position.x = self:parseX(data.x, data.parent)
	end
	if (types.isString(data.y)) then
		position.y = self:parseY(data.y, data.parent)
	end
	return position
end
function EntityManager:normalizeFontSize(size, parent)
	if (types.isString(size)) then
		return self:parseTextSize(size, parent)
	end
	return size or DEFAULT_FONT_SIZE
end

------------------------------------------------------------------------------------------

function EntityManager:createEntity(data)
	local entityType = data.entityType or data.entity or nil

	local position = self:normalizePosition(data)
	local size = self:normalizeSize(data)
	data.x = position.x
	data.y = position.y
	data.w = size.width
	data.h = size.height

	local entity = nil
	if (entityType == 'sprite') then
		entity = Sprite(data.texture, size)
		local contentSize = entity:getContentSize()
		data.w = contentSize.width
		data.h = contentSize.height
	elseif (entityType == 'button') then
		entity = Button(data.texture, size)
		if (types.isString(data.text)) then
			entity:setText(data.text)
		end
		if (types.isString(data.textcolor)) then
			entity:setTextColor(HelperColor.colorFromString(data.textcolor))
		end
		if (types.isString(data.style)) then
			entity:setStyle(data.style)
		end
		data.textsize = self:normalizeFontSize(data.textsize, data.parent)
		entity:setTextFontSize(data.textsize)
	elseif (entityType == 'scroller') then
		entity = Scroller(data.texture, size)
	elseif (entityType == 'slider') then
		entity = Slider(data.texture, size)
	elseif (entityType == 'drag') then
		entity = Drag(data.texture, size)
	elseif (entityType == 'text') then
		data.size = self:normalizeFontSize(data.size, data.parent)
		entity = Label(data.text, data.font, data.size, size, data.alignment, data.bg)
	elseif (entityType == 'layer') then
		entity = Layer()
	elseif (entityType == 'checkbox') then
		entity = CheckBox(size, data.text)
	elseif (entityType == 'editbox') then
		entity = EditBox(data.texture_bg, size)
		self:adjustEditbox(entity, data)
	elseif (entityType == 'textfield') then
		entity = TextField()
	elseif (entityType == 'tabs') then
		local style = data.style or 'rounded'
		entity = Tabs(size, style)
		if (types.isTable(data.tabs)) then
			for i,k in pairs(data.tabs) do
				entity:addTabInfo(tostring(k))
			end
		end
	elseif (entityType == 'scissorbox') then
		entity = ScissorBox(position, size)
	elseif (entityType == 'scrollview') then
		entity = ScrollView(position, size)
	elseif (entityType == 'screen') then
		entity = SceneManager:shared():createScreen(data.screen)
		entity:init()
	else
		WARNING('EntityManager:createEntity', 'unknown entity type {' .. tostring(entityType) .. '}')
		assert(false)
	end

	self:adjustEntity(entity, data)
	self:adjustTextfield(entity, data)
	self:adjustDrag(entity, data)

	self:cacheEntityInfo(data)

	if true then
		local key = tostring(data.key)
		local w = tostring(data.w)
		local h = tostring(data.h)
		local x = tostring(data.x)
		local y = tostring(data.y)
--		PRINT('Create Entity, key = ' .. key .. ' size = {' .. w .. ',' .. h .. '} position = {' .. x .. ',' .. y .. '}')
	end

	return entity
end

function EntityManager:updateEntity(entity, data)
	local position = self:normalizePosition(data)
	local size     = self:normalizeSize(data)

	data.x = position.x
	data.y = position.y
	data.w = size.width
	data.h = size.height

	if (entity:getType() == 'Label') then
		local fontSize = self:normalizeFontSize(data.size, data.parent)
		entity:setFontSize(fontSize)
	end

	if (entity:getType() == 'Sprite' and types.isString(data.mask)) then
		entity:setMaskTexture(data.mask)
	end

	if (types.isString(data.texture)) then
		if (types.isSize(size)) then
			local contentSize = entity:getContentSize()
			if (contentSize.width > 0 and contentSize.height > 0) then
				local n_scale_x = size.width / contentSize.width
				local n_scale_y = size.height / contentSize.height
				local scale = math.min(n_scale_x, n_scale_y)
				entity:setScaleX(scale)
				entity:setScaleY(scale)
				data.w = contentSize.width
				data.h = contentSize.height
			end
		end
	else
		entity:setTextureRect(cc.rect(0,0,data.w,data.h))
	end

	entity:setPosition(position)
	entity:setAnchorPoint(cc.p(0.5,0.5))

	if true then
		local key = tostring(data.key)
		local w = tostring(data.w)
		local h = tostring(data.h)
		local x = tostring(data.x)
		local y = tostring(data.y)
--		PRINT('Update Entity, key = ' .. key .. ' size = {' .. w .. ',' .. h .. '} position = {' .. x .. ',' .. y .. '}')
	end

	self:cacheEntityInfo(data)
end

------------------------------------------------------------------------------------------

function EntityManager:adjustEntity(entity, data)
	local point = cc.p((data.x or 0), (data.y or 0))
	entity:setPosition(point)

	local w = entity:getContentSize().width
	local h = entity:getContentSize().height

	local scale_x = entity:getScaleX() * (data.scale or data.scaleX or 1)
	local scale_y = entity:getScaleY() * (data.scale or data.scaleY or 1)
	entity:setScale(cc.p(scale_x,scale_y))

	if (types.isString(data.key)) then
		entity:setName(data.key)
	end

	if (types.isNumber(data.order)) then
		entity:setOrder(data.order or 0)
	end

	if (types.isBoolean(data.visible)) then
		entity:setVisible(data.visible)
	end

	if (types.isBoolean(data.respondable)) then
		entity:setRespondable(data.respondable)
	end

	if (types.isNumber(data.r)) then
		entity:setRotation(data.r)
	end

	if (types.isString(data.mask)) then
		entity:setMaskTexture(data.mask)
	end

	if (types.isString(data.color)) then
		entity:setColor(HelperColor.colorFromString(data.color))
		if (data.color == 'transparent') then
			entity:setOpacity(0)
		end
	end

	if (types.isNumber(data.max_opacity)) then
		entity:setMaxOpacity(data.max_opacity)
	end

	if (types.isNumber(data.opacity)) then
		entity:setOpacity(data.opacity)
	end

	entity:setAnchorPoint(cc.p(0.5,0.5))
end

function EntityManager:adjustDrag(entity, data)
	if (data.entity == 'drag') then
		entity:setStartPosition(entity:getPosition())
		entity:setStartOrder(entity:getOrder())
	end
end

function EntityManager:adjustEditbox(entity, data)
	if (data.entity == 'editbox') then
		local edit = entity:getCocosEntity()

		edit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
--			cc.EDITBOX_INPUT_MODE_ANY
--			cc.EDITBOX_INPUT_MODE_EMAILADDR
--			cc.EDITBOX_INPUT_MODE_NUMERIC
--			cc.EDITBOX_INPUT_MODE_PHONENUMBER
--			cc.EDITBOX_INPUT_MODE_URL
--			cc.EDITBOX_INPUT_MODE_DECIMAL
--			cc.EDITBOX_INPUT_MODE_SINGLELINE

		if (data.mode == 'password') then
			edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
		else
			edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
		end

		local fontname = cc.FileUtils:getInstance():fullPathForFilename(DEFAULT_EDITBOX_FONT_NAME)
--		print(fontname)

		edit:setFontName(fontname)
		edit:setFontSize(24)
		edit:setFontColor(cc.c3b(0,0,0))
		edit:setPlaceHolder(data.placeholder or DEFAULT_EDITBOX_PLACEHOLDER)
		edit:setPlaceholderFontName(fontname)
		edit:setPlaceholderFontSize(24)
		edit:setPlaceholderFontColor(cc.c3b(0,0,0))
		edit:setMaxLength(16)
		entity:setPlaceHolder(data.placeholder or DEFAULT_EDITBOX_PLACEHOLDER)

		edit:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
--			cc.KEYBOARD_RETURNTYPE_DEFAULT
--			cc.KEYBOARD_RETURNTYPE_SEND
--			cc.KEYBOARD_RETURNTYPE_GO
--			cc.KEYBOARD_RETURNTYPE_SEARCH
--			cc.KEYBOARD_RETURNTYPE_DONE
	end
end

function EntityManager:adjustTextfield(entity, data)
	if (data.entity == 'textfield') then
		local edit = entity:getCocosEntity()
			local fontname = cc.FileUtils:getInstance():fullPathForFilename(DEFAULT_EDITBOX_FONT_NAME)
--			print(fontname)
			edit:setFontName(fontname)
			edit:setFontSize(24)
			edit:setMaxLength(16)
			edit:setMaxLengthEnabled(true)
--			edit:setPasswordEnabled(true)
			edit:setPlaceHolder(data.placeholder or DEFAULT_EDITBOX_PLACEHOLDER)
			edit:setPlaceHolderColor(cc.c3b(0,0,0))
			edit:setTextColor(cc.c3b(0,0,0))
			edit:setTextAreaSize(edit:getContentSize())
			edit:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
			edit:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
--			edit:setTouchAreaEnabled(true)
--			edit:setTouchSize(edit:getContentSize())
	end
end

------------------------------------------------------------------------------------------
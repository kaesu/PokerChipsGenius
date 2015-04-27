HelperCocos = {
	createSceneEntity = function()
		return cc.Scene:create()
	end,
	createLayerEntity = function()
		return cc.Layer:create()
	end,
	createLayerColorEntity = function(color)
		local c = color or cc.c4b(255, 255, 255, 255)
		assert(types.isColor(c))
		return cc.LayerColor:create(c)
	end,
	createSpriteEntity = function(texture, size)
		local sprite = nil
		assert(size == nil or types.isSize(size))
		if (types.isString(texture) and string.len(texture) > 0) then
			local path = cc.FileUtils:getInstance():fullPathForFilename(texture)
			if (false == cc.FileUtils:getInstance():isFileExist(path)) then
				path = cc.FileUtils:getInstance():fullPathForFilename(TEXTURES_MAIN_FOLDER_NAME .. TEXTURES_DEFAULT_DESIGN_NAME .. texture)
			end

			sprite = cc.Sprite:create(path)
			if (sprite ~= nil and types.isSize(size)) then
				local contentSize = sprite:getContentSize()
				if (contentSize.width > 0 and contentSize.height > 0) then
					local n_scale_x = size.width  / contentSize.width
					local n_scale_y = size.height / contentSize.height
					scale = math.min(n_scale_x, n_scale_y)
					sprite:setScaleX(scale)
					sprite:setScaleY(scale)
				end
			end
		else
			sprite = cc.Sprite:create()
			if (sprite ~= nil and types.isSize(size)) then
				sprite:setTextureRect(cc.rect(0,0,size.width,size.height))
			end
		end
		if (sprite == nil) then
			print('FAIL TO LOAD TEXTURE: '..texture)
		end
		assert(sprite ~= nil)
		return sprite
	end,
	createTextEntity = function(_text, _font, _fontSize, _size, _alignment)
		local text      = GET_STRING(_text) or _text or ''
		local font      = cc.FileUtils:getInstance():fullPathForFilename(_font or DEFAULT_FONT_NAME)
		local fontSize  = _fontSize or DEFAULT_FONT_SIZE
		local size      = _size or cc.size(32,32)
		local alignment = cc.TEXT_ALIGNMENT_CENTER
		if (_alignment == 'left') then
			alignment = cc.TEXT_ALIGNMENT_LEFT
		elseif (_alignment == 'right') then
			alignment = cc.TEXT_ALIGNMENT_RIGHT
		end
		assert(types.isString(text))
		assert(types.isString(font))
		assert(types.isNumber(fontSize))
		assert(types.isSize(size))
		return cc.LabelTTF:create(text, font, fontSize, size, alignment)
	end,
	createEditBoxEntity = function(texture_bg_src, size)
		texture_bg_src = texture_bg_src or DEFAULT_EDITBOX_TEXTURE_BG
		size = size or cc.size(32,32)
		assert(types.isSize(size))
		assert(types.isString(texture_bg_src))
		return ccui.EditBox:create(size, texture_bg_src, 0)
	end,
	createTextFieldEntity = function()
		return ccui.TextField:create()
	end,
	createClippingRectEntity = function(rect)
		assert(types.isRect(rect))
		return cc.ClippingRectangleNode:create(rect)
	end,
}
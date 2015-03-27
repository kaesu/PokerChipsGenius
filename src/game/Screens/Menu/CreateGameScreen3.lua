class 'CreateGameScreen3' (Screen)

------------------------------------------------------------------------------------------

function CreateGameScreen3:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Dzagurda\npassword: 123')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('close')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
	end)
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		startScene('GameScreen')
	end)

	self:initButtonMultiplayer()
	self:updatePlayers()
end

function CreateGameScreen3:onDestroy()
end

------------------------------------------------------------------------------------------

function CreateGameScreen3:initButtonMultiplayer()
	local btn = self.entities.btn_m
	local size = cc.size(btn:getWidth()*0.5,btn:getHeight()*0.5)

	local sprite = Sprite('menu/creategame/_multiplayer-ico.png',size)
	local sprite_width = sprite:getWidth() * sprite:getScaleX()
		  sprite:setOrder(1)
		  sprite:setRespondable(false)

	local text = Label('MULTIPLAYER', DEFAULT_FONT_NAME, GET_SCREEN_HEIGHT()*0.03, cc.size(0,0), 'center')
	local text_width = text:getWidth()
		  text:setOrder(1)
		  text:setRespondable(false)

	local w_sum = (sprite_width + text_width) * 1.05
	local p1 = sprite_width / w_sum
	local p2 = text_width / w_sum
	local p3 = (w_sum - sprite_width - text_width) / w_sum

	sprite:setPosition(((p3+p1)/2)*btn:getWidth(),btn:getHeight()/2)
	text:setPosition((p1+(p2+p3)/2)*btn:getWidth(),btn:getHeight()/2)

	btn:addChild(sprite)
	btn:addChild(text)
end

------------------------------------------------------------------------------------------

function CreateGameScreen3:updatePlayers()
	local function createPlayerInfo(size, data)
		local _holder = Sprite()

		local w = size.width
		local h = size.height

		local line_height = GET_SCREEN_HEIGHT()*0.01
		local name_height = h*0.3
		local margin      = w*0.05
		local opacity     = 1

		local _frame = Sprite('',size)
			  _frame:setOrder(1)
			  _frame:setRespondable(false)
			  _frame:setColor(COLOR('light_gray'))
		_holder:addChild(_frame)

		local icon_texture = 'menu/creategame/_small-pic.png'
		if (data.id == nil) then
			icon_texture = 'menu/creategame/_ellipse.png'
			opacity = 0.25
		end
		local _icon = Sprite(icon_texture, cc.size(w*0.8,h*0.8))
		local icon_width = _icon:getWidth() * _icon:getScaleX()
			  _icon:setOrder(3)
			  _icon:setRespondable(false)
			  _icon:setOpacity(opacity)
			  _icon:setPosition(margin+icon_width*0.5-w*0.5,line_height*0.5)
		_holder:addChild(_icon)

		if (data.status ~= nil) then
			local i_size = cc.size(w*0.4,h*0.4)
			local i_position = cc.p(h*0.1+margin+icon_width-w*0.5,line_height*0.5)
			local _circle = Sprite('common/circle.png', i_size)
				  _circle:setOrder(4)
				  _circle:setRespondable(false)
				  _circle:setPosition(i_position)
			local _status = nil
			if (data.status == 'admin') then
				_status = Sprite('menu/creategame/_admin-ico.png', i_size)
			elseif (data.status == 'mp') then
				_status = Sprite('menu/creategame/_profile-transparent-ico.png', i_size)
			else
				assert(false)
			end
			_status:setOrder(5)
			_status:setPosition(i_position)
			_holder:addChild(_status)
			_holder:addChild(_circle)
		end

		local _name = Label(data.name,DEFAULT_FONT_NAME,name_height,cc.size(w-icon_width,0),'right')
			  _name:setColor(COLOR('black'))
			  _name:setOrder(3)
			  _name:setRespondable(false)
			  _name:setPosition(icon_width*0.5-margin,line_height*0.5)
			  _name:setOpacity(opacity)
		_holder:addChild(_name)

		local _line = Sprite('',cc.size(w,line_height))
			  _line:setColor(COLOR('gray'))
			  _line:setOrder(2)
			  _line:setPosition(0,(line_height-h)*0.5)
			  _line:setRespondable(false)
			  _line:setOpacity(opacity)
		_holder:addChild(_line)

		local info = {}
		info.entity = _holder

		return info
	end

	local data = {
		{ name = 'TONNY',    id = 1,   status = 'admin',    },
		{ name = 'MAX',      id = 2,   },
		{ name = 'YAN WU',   id = 3,   status = 'mp',  },
		{ name = 'ROBERTO',  id = 4,   },
		{ name = 'MARIA',    id = 5,   },
		{ name = 'PLAYER_6', id = nil, },
		{ name = 'PLAYER_7', id = nil, },
		{ name = 'PLAYER_8', id = nil, },
	}

	local size = self.entities.phold:getContentSize()
	local pl_size = cc.size(size.width*0.45,size.height*0.2)

	local cur_x = 0.25
	local cur_y = 0.875

	for i,row in pairs(data) do
		local info = createPlayerInfo(pl_size, row)

		info.entity:setOrder(1)
		info.entity:setPosition(cur_x * size.width, cur_y * size.height)

		cur_x = cur_x + 0.5
		if (cur_x > 0.75) then
			cur_x = 0.25
			cur_y = cur_y - 0.25
		end

		self.entities.phold:addChild(info.entity)
	end
end

------------------------------------------------------------------------------------------

function CreateGameScreen3:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg',    w = '100%W', h = '100%H',  x = '50%W', y = '50%H',    order = 1, color = 'white', },

		{ entity = 'text',   key = 'txt1',  w = '95%W',  h = '12.5%H', x = '50%W', y = '81.25%H', order = 2, text = 'STRING_SCAN_QR_1', size = '3.5%H', color = 'black', },
		{ entity = 'sprite', key = 'qr',    w = '30%W',  h = '30%H',   x = '50%W', y = '65%H',    order = 2, texture = 'menu/creategame/_qr.png', },

		{ entity = 'sprite', key = 'frm1',  w = '100%W', h = '55%H',   x = '50%W', y = '27.5%H',  order = 2, color = 'light_gray', },
		{ entity = 'text',   key = 'txtp',  w = '95%W',  h = '10%H',   x = '50%W', y = '49.5%H',  order = 3, text = 'PLAYERS', size = '5%H', color = 'black', alignment = 'left', },
		{ entity = 'button', key = 'btn_m', w = '50%W',  h = '6%H',    x = '72%W', y = '49.5%H',  order = 3, color = 'blue', style = 'rounded', },
		{ entity = 'sprite', key = 'phold', w = '100%W', h = '44%H',   x = '50%W', y = '22%H',    order = 3, color = 'light_gray', },
	}
	return table
end

------------------------------------------------------------------------------------------
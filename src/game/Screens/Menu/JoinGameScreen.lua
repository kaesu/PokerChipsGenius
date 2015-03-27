class 'JoinGameScreen' (Screen)

------------------------------------------------------------------------------------------

function JoinGameScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Join Game')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('accept')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		startScene('MainMenuScreen')
	end)
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		startScene('GameScreen')
	end)

	self:updateGamesList()
end

------------------------------------------------------------------------------------------

function JoinGameScreen:createGameInfo(size, data)
	local _holder = Sprite()

	local w = size.width
	local h = size.height

	local line_height = GET_SCREEN_HEIGHT()*0.01
	local name_height = h*0.3
	local margin      = w*0.05

	local _frame = Sprite('',size)
		  _frame:setColor(COLOR('white'))
		  _frame:setOrder(1)
		  _frame:setRespondable(false)
		  _frame:setPosition(w*0.5,h*0.5)
	_holder:addChild(_frame)

	local _name = Label(data.name,DEFAULT_FONT_NAME,name_height,cc.size(w,0),'left')
		  _name:setColor(COLOR('black'))
		  _name:setOrder(3)
		  _name:setRespondable(false)
		  _name:setPosition(margin+w*0.5,h-margin-_name:getHeight()*0.5)
	_holder:addChild(_name)

	local _location = Label(data.location..', '..data.distance, DEFAULT_FONT_NAME, h*0.2, cc.size(w,0), 'left')
		  _location:setColor(COLOR('black'))
		  _location:setOrder(3)
		  _location:setRespondable(false)
		  _location:setPosition(margin+w*0.5,margin+line_height+_location:getHeight()*0.5)
	_holder:addChild(_location)

	local _spr = Sprite('',cc.size(w*0.15,h*0.33))
		  _spr:setColor(COLOR('light_gray'))
		  _spr:setOrder(3)
		  _spr:setRespondable(false)
		  _spr:setPosition(w-w*0.075,h-margin-_name:getHeight()*0.5)
	_holder:addChild(_spr)

	local _players = Label(tostring(data.players),DEFAULT_FONT_NAME,h*0.2,cc.size(w,0),'center')
		  _players:setColor(COLOR('black'))
		  _players:setOrder(4)
		  _players:setRespondable(false)
		  _players:setPosition(w-w*0.075-_spr:getWidth()*0.25,h-margin-_name:getHeight()*0.5)
	_holder:addChild(_players)

	local _p_icon = Sprite('menu/joingame/_profile-transparent-ico.png',cc.size(w*0.2,h*0.33))
		  _p_icon:setOrder(4)
		  _p_icon:setRespondable(false)
		  _p_icon:setPosition(w-w*0.075+_spr:getWidth()*0.25,h-margin-_name:getHeight()*0.5)
	_holder:addChild(_p_icon)

	local _line = Sprite('',cc.size(w,line_height))
		  _line:setColor(COLOR('gray'))
		  _line:setOrder(2)
		  _line:setRespondable(false)
		  _line:setPosition(0+w*0.5,(line_height-h)*0.5+h*0.5)
	_holder:addChild(_line)

	local info = {}
		  info.entity = _holder
		  info.width  = w
		  info.height = h

	return info
end

function JoinGameScreen:updateGamesList()
	local data = {
		{ name = 'GAME NAME', players = 9, location = 'San Francisco', distance =  '500m', },
		{ name = 'GAME NAME', players = 5, location = 'San Francisco', distance = '1000m', },
	}

	local count = table.size(data) + 1
	local w = self.entities.tab:getWidth()
	local h = GET_SCREEN_HEIGHT() * 0.16666

	local scr_w = self.entities.tab:getWidth()
	local scr_h = (count*1.125)*h
	if (scr_h < self.entities.tab:getHeight()) then
		scr_h = self.entities.tab:getHeight()
	end
	local scr_size  = cc.size(scr_w,scr_h)
	local item_size = cc.size(w*0.95,h)

	self.entities.tab:setColor(COLOR('white'))
	self.entities.tab:setScrollableSize(scr_size)

	local margin = h * 0.125
	local cur_x  = w * 0.025
	local cur_y  = scr_size.height

	for i,row in pairs(data) do
		local info = self:createGameInfo(item_size, row)
		cur_y = cur_y - margin - info.height

		info.entity:setPosition(cur_x, cur_y)
		info.entity:setOrder(1)

		self.entities.tab:addChild(info.entity)
	end
end

------------------------------------------------------------------------------------------

function JoinGameScreen:makeContent()
	local table = {
		{ entity = 'sprite',     key = 'bg',                 w = '100%W', h = '100%H',  x = '50%W', y = '50%H',    order = 1, color = 'white', },

		{ entity = 'editbox',    key = 'edit_search',        w = '95%W',  h = '12.5%W', x = '50%W', y = '80.75%H', order = 5, placeholder = 'Search', },

		{ entity = 'scissorbox', key = 'sc',                 w = '100%W', h = '75%H',   x = '50%W', y = '37.5%H',  order = 3, color = 'blue', },
		{ entity = 'scrollview', key = 'tab', parent = 'sc', w = '100%W', h = '75%H',                              order = 2, color = 'red', },
	}
	return table
end

------------------------------------------------------------------------------------------
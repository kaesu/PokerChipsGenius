class 'CreateGameScreen2' (Screen)

------------------------------------------------------------------------------------------

function CreateGameScreen2:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Create Game')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		startScene('CreateGameScreen')
	end)
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		startScene('CreateGameScreen3')
	end)

	SceneManager:shared():getScreenNamed('MenuScreen'):disableRButton()

	SceneManager:shared():requireScreen('ModalSettingsGameTypeScreen', 7)
	SceneManager:shared():getScreenNamed('ModalSettingsGameTypeScreen'):hide()

	SceneManager:shared():requireScreen('ModalSettingsPayoutsScreen', 7)
	SceneManager:shared():getScreenNamed('ModalSettingsPayoutsScreen'):hide()

	SceneManager:shared():requireScreen('ModalSettingsRebuysScreen', 7)
	SceneManager:shared():getScreenNamed('ModalSettingsRebuysScreen'):hide()

	SceneManager:shared():requireScreen('ModalInfoScreen', 10)
	SceneManager:shared():getScreenNamed('ModalInfoScreen'):hide()

	self:initTabs()
end

function CreateGameScreen2:onDestroy()
	SceneManager:shared():destroyScreen('ModalSettingsGameTypeScreen')
	SceneManager:shared():destroyScreen('ModalSettingsPayoutsScreen')
	SceneManager:shared():destroyScreen('ModalSettingsRebuysScreen')
	SceneManager:shared():destroyScreen('ModalInfoScreen')
end

------------------------------------------------------------------------------------------

function CreateGameScreen2:changeTab(index)
	self.entities.tab1:hide()
	self.entities.tab2:hide()
	self.entities.tab3:hide()
	self.entities['tab'..index]:show()

	self.entities.tabs:setCompleted(index)

	if (self.entities.tabs:isCompleted()) then
		SceneManager:shared():getScreenNamed('MenuScreen'):enableRButton()
	else
		SceneManager:shared():getScreenNamed('MenuScreen'):disableRButton()
	end
end

------------------------------------------------------------------------------------------

function CreateGameScreen2:createTabMenuItemInfo(size, data)
	local function createIcon(size, texture, key, value)
		local w = size.width
		local h = size.height

		local _icon  = Sprite(texture, cc.size(w*0.6,h*0.6))
		local text_margin_left = _icon:getScaleX() * _icon:getWidth() * 1.5
			  _icon:setOrder(1)
			  _icon:setPosition(text_margin_left*0.5,h*0.5)

		local _value = Label(value, DEFAULT_FONT_NAME, h*0.4, cc.size(w,0), 'left')
			  _value:setColor(COLOR('black'))
			  _value:setOrder(1)
			  _value:setPosition(text_margin_left+w/2,h*0.75)

		local _key = Label(key, DEFAULT_FONT_NAME, h*0.3, cc.size(w,0), 'left')
			  _key:setColor(COLOR('black'))
			  _key:setOrder(1)
			  _key:setPosition(text_margin_left+w/2,h*0.75 - (_value:getHeight()+_key:getHeight())/2)

		local holder = Sprite('', size)
			  holder:setColor(COLOR('white'))
			  holder:setRespondable(false)
			  holder:addChild(_icon)
			  holder:addChild(_key)
			  holder:addChild(_value)

		return holder
	end

	local w = size.width
	local h = size.height

	local name_margin    = w * 0.02
	local descr_margin   = w * 0.02
	local icon_size      = cc.size(w*0.3,h*0.45)
	local button_size    = cc.size(w*0.4,h*0.4)
	local name_font_size = h*0.4
	local line_height    = GET_SCREEN_HEIGHT()*0.01 --h*0.04
	local icon_y         = icon_size.height*0.5+line_height

	local menu_item = Sprite()

	if (data.description ~= nil) then
		local _description = Label(data.description, DEFAULT_FONT_NAME, h*0.2, cc.size(w,0), 'left')
			  _description:setOrder(3)
			  _description:setColor(COLOR('black'))
			  _description:setPosition(descr_margin+w*0.5,descr_margin+line_height+_description:getHeight()/2)
			  _description:setRespondable(false)
		menu_item:addChild(_description)

		if (h/2 < descr_margin*2+_description:getHeight()) then
			h = h/2 + descr_margin*2+_description:getHeight()
		end
	end

	local _frame = Sprite('', cc.size(w,h))
		  _frame:setColor(COLOR('white'))
		  _frame:setOrder(1)
		  _frame:setPosition(w/2,h/2)
		  _frame:setRespondable(false)
	menu_item:addChild(_frame)

	local _line = Sprite('', cc.size(w,line_height))
		  _line:setColor(COLOR('gray'))
		  _line:setOrder(2)
		  _line:setPosition(w*0.5,line_height*0.5)
		  _line:setRespondable(false)
	menu_item:addChild(_line)

	if (data.button ~= nil) then
		local _button = nil
		if (data.button == 'edit') then
			_button = Button('menu/creategame/edit-btn.png', button_size)
			if (types.isFunction(data.onbclick)) then
				_button:setOnClick(data.onbclick)
			end
		elseif (data.button == 'info') then
			_button = Button('menu/creategame/question-ico.png', button_size)
			_button:setOnClick(function()
				SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
				SceneManager:shared():getScreenNamed('ModalInfoScreen'):setInfoCaption(data.name)
				SceneManager:shared():getScreenNamed('ModalInfoScreen'):setInfoText('')
			end)
		end
		if (_button ~= nil) then
			_button:setPosition(w-_button:getWidth()*_button:getScaleX()/2,h-_button:getHeight()*_button:getScaleY()/2)
			_button:setOrder(3)
			menu_item:addChild(_button)
		end
	end
	if (data.stack ~= nil) then
		local _stack = createIcon(icon_size, 'menu/creategame/chips-pack-ico.png', 'stack', data.stack)
			  _stack:setOrder(3)
			  _stack:setPosition(name_margin+icon_size.width*0.5,icon_y)
			  _stack:setRespondable(false)
		menu_item:addChild(_stack)
	end
	if (data.blind ~= nil) then
		local _blind = createIcon(icon_size, 'menu/creategame/chips-ico.png', 'blind', data.blind)
			  _blind:setOrder(3)
			  _blind:setPosition(w*0.5,icon_y)
			  _blind:setRespondable(false)
		menu_item:addChild(_blind)
	end
	if (data.time ~= nil) then
		local _time = createIcon(icon_size, 'menu/creategame/no-time-ico.png', 'time', data.time)
			  _time:setOrder(3)
			  _time:setPosition(w-icon_size.width*0.5-name_margin,icon_y)
			  _time:setRespondable(false)
		menu_item:addChild(_time)
	end

	if (data.name ~= nil) then
		local _name = Label(data.name, DEFAULT_FONT_NAME, name_font_size, cc.size(w,0), 'left')
			  _name:setOrder(3)
			  _name:setColor(COLOR('black'))
			  _name:setPosition(name_margin+w*0.5, h-_name:getHeight()/2)
			  _name:setRespondable(false)
		menu_item:addChild(_name)
	end

	local info = {}
		  info.entity = menu_item
		  info.width  = w
		  info.height = h

	return info
end

function CreateGameScreen2:fillTabData(tab, data)
	local count = table.size(data) + 1
	local w = tab:getWidth()
	local h = GET_SCREEN_HEIGHT() * 0.16666

	local scr_size  = cc.size(w,(count*1.125)*h)
	local item_size = cc.size(w*0.95,h)

	tab:setColor(COLOR('white'))
	tab:setScrollableSize(scr_size)

	local margin = h * 0.125
	local cur_x  = w * 0.025
	local cur_y  = scr_size.height

	for i,row in pairs(data) do
		local info = self:createTabMenuItemInfo(item_size, row)
		cur_y = cur_y - margin - info.height

		info.entity:setPosition(cur_x, cur_y)
		info.entity:setOrder(1)

		tab:addChild(info.entity)
	end
end

function CreateGameScreen2:initTabs()
	self.entities.tabs:addTabInfo('Game Type')
	self.entities.tabs:addTabInfo('Rebuys')
	self.entities.tabs:addTabInfo('Payouts')
	self.entities.tabs:setOnTabChanged(function(index) self:changeTab(index) end)

	self:changeTab(1)

	if (self.entities.test ~= nil) then
		self.entities.test:setStyle('rounded')
		self.entities.test:setOnClick(function()
			print('test')
		end)
	end

	local function fun1()
		SceneManager:shared():getScreenNamed('ModalSettingsGameTypeScreen'):show()
	end
	local function fun2()
		SceneManager:shared():getScreenNamed('ModalSettingsRebuysScreen'):show()
	end
	local function fun3()
		SceneManager:shared():getScreenNamed('ModalSettingsPayoutsScreen'):show()
	end

	self:fillTabData(self.entities.tab1, {
		{ name = 'STARTER',  stack = '100',  blind = '25/50',   time = 'no time', button = 'info', },
		{ name = 'CLASSIC',  stack = '500',  blind = '50/100',  time = '10 min',  button = 'info', },
		{ name = 'TURBO',    stack = '1000', blind = '100/200', time = '15 min',  button = 'info', },
		{ name = 'FAVORITE', stack = '5000', blind = 'medium',  time = '10 min',  button = 'edit', onbclick = fun1, },
		{ name = 'CUSTOM', },
	})
	self:fillTabData(self.entities.tab2, {
		{ name = 'NO REBUYS',  description = 'Lorem ipsum Lorem',            button = 'info', },
		{ name = 'TEMPLATE 1', description = 'Lorem ipsum Lorem',            button = 'info', },
		{ name = 'STRUCTURE',  description = 'Rebuy period - 3\nAdd-on - 2', button = 'edit', onbclick = fun2, },
		{ name = 'CUSTOM', },
	})
	self:fillTabData(self.entities.tab3, {
		{ name = 'CLASSIC',   description = '25% of plrs in cash',                        button = 'info', },
		{ name = 'TAKES ALL', description = 'Lorem ipsum Lorem',                          button = 'info', },
		{ name = 'NOTHING',   description = '25% of plrs in cash',                        button = 'info', },
		{ name = 'FAVORITE',  description = '1st - 50%\n2nd - 10%\n3rd - 10%\n4th - 10%', button = 'edit', onbclick = fun3, },
		{ name = 'CUSTOM', },
	})
end

------------------------------------------------------------------------------------------

function CreateGameScreen2:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%W', h = '100%H', x = '50%W', y = '50%H', color = 'white', order = 1, },

		{ entity = 'tabs',   key = 'tabs', w = '100%W', h = '12.5%H', x = '50%W', y = '81.25%H', order = 2, color = 'light_gray', },

		{ entity = 'scissorbox', key = 'sc', w = '100%W', h = '75%H', x = '50%W', y = '37.5%H', order = 3, color = 'blue', },
		{ entity = 'scrollview', key = 'tab1', parent = 'sc', w = '100%W', h = '75%H', order = 2, color = 'red', },
		{ entity = 'scrollview', key = 'tab2', parent = 'sc', w = '100%W', h = '75%H', order = 2, color = 'yellow', },
		{ entity = 'scrollview', key = 'tab3', parent = 'sc', w = '100%W', h = '75%H', order = 2, color = 'green', },

--		{ entity = 'drag',   key = 'dr',   parent = 'tab2', w = '50%W',  h = '50%H',   x = '50%W', y = '50%HP', order = 2, texture = 'game/bet/chips/ic_chips_big_red@2x.png', },
--		{ entity = 'button', key = 'test', parent = 'tab3', w = '90%W',  h = '12.5%H', x = '50%W', y = '50%HP', order = 2, color = 'blue', text = 'testround', textcolor = 'white', textsize = '5%H', },
	}
	return table
end

------------------------------------------------------------------------------------------
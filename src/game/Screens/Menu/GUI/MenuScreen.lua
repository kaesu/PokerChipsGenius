class 'MenuScreen' (Screen)

------------------------------------------------------------------------------------------

function MenuScreen:onInit()
	self.entities.menu_l_button:setOnClick(function() self:onLButtonClick() end)
	self.entities.menu_r_button:setOnClick(function() self:onRButtonClick() end)

	local function b_on_enable(letter)
		self.entities['menu_' .. letter .. '_button']:setOpacity(1)
	end
	local function b_on_disable(letter)
		self.entities['menu_' .. letter .. '_button']:setOpacity(0.5)
	end

	self.entities.menu_l_button:setOnDisable(function()
		b_on_disable('l')
	end)
	self.entities.menu_l_button:setOnEnable(function()
		b_on_enable('l')
	end)
	self.entities.menu_r_button:setOnDisable(function()
		b_on_disable('r')
	end)
	self.entities.menu_r_button:setOnEnable(function()
		b_on_enable('r')
	end)
end

------------------------------------------------------------------------------------------

function MenuScreen:setMenuText(str)
    self.entities.menu_text:setString(str)
end

------------------------------------------------------------------------------------------

function MenuScreen:onLButtonClick()
	if (types.isFunction(self.info.on_l_button_click)) then
		self.info.on_l_button_click()
	end
end

function MenuScreen:onRButtonClick()
	if (types.isFunction(self.info.on_r_button_click)) then
		self.info.on_r_button_click()
	end
end

function MenuScreen:setOnLButtonClick(f)
	assert(types.isFunction(f))
	self.info.on_l_button_click = f
end

function MenuScreen:setOnRButtonClick(f)
	assert(types.isFunction(f))
	self.info.on_r_button_click = f
end

------------------------------------------------------------------------------------------

function MenuScreen:setButtonStyle(letter, style)
	assert(letter == 'l' or letter == 'r')

	if (types.isString(style)) then
		self.entities['menu_' .. letter .. '_button']:show()
		self.entities['menu_' .. letter .. '_button']:setColor(HelperColor.colorFromHex(COLOR_BLACK))
		self.entities['menu_' .. letter .. 'b_style_accept']:hide()
		self.entities['menu_' .. letter .. 'b_style_arrow']:hide()
		self.entities['menu_' .. letter .. 'b_style_close']:hide()
		self.entities['menu_' .. letter .. 'b_style_options']:hide()
		self.entities['menu_' .. letter .. 'b_style_question']:hide()
		if (style == 'accept') then
			self.entities['menu_' .. letter .. 'b_style_accept']:show(0, false)
			self.entities['menu_' .. letter .. '_button']:setColor(HelperColor.colorFromHex(COLOR_BLUE))
		elseif (style == 'arrow') then
			self.entities['menu_' .. letter .. 'b_style_arrow']:show(0, false)
		elseif (style == 'close') then
			self.entities['menu_' .. letter .. 'b_style_close']:show(0, false)
		elseif (style == 'hidden') then
			self.entities['menu_' .. letter .. '_button']:hide()
		elseif (style == 'options') then
			self.entities['menu_' .. letter .. 'b_style_options']:show(0, false)
		elseif (style == 'question') then
			self.entities['menu_' .. letter .. 'b_style_question']:show(0, false)
		elseif (style == 'scan_qr') then
			--
		else
			assert(false)
		end
	end
end

function MenuScreen:setLButtonStyle(style)
	self:setButtonStyle('l', style)
end

function MenuScreen:setRButtonStyle(style)
	self:setButtonStyle('r', style)
end

------------------------------------------------------------------------------------------

function MenuScreen:enableLButton()
	self.entities.menu_l_button:enable()
end

function MenuScreen:disableLButton()
	self.entities.menu_l_button:disable()
end

function MenuScreen:enableRButton()
	self.entities.menu_r_button:enable()
end

function MenuScreen:disableRButton()
	self.entities.menu_r_button:disable()
end

------------------------------------------------------------------------------------------

function MenuScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'menu_frame', w = '100%', h = '12.5%', x = '50%', y = '93.75%', color = 'yellow', order = 1, },

		{ entity = 'button', key = 'menu_l_button', parent = 'menu_frame', w = '50%HP', h = '50%HP', x = '50%HP',  y = '50%HP', color = 'black', order = 2, },
		{ entity = 'button', key = 'menu_r_button', parent = 'menu_frame', w = '50%HP', h = '50%HP', x = '50%HPR', y = '50%HP', color = 'black', order = 2, },

		{ entity = 'sprite', key = 'menu_lb_style_accept',   parent = 'menu_l_button', w = '100%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/accept.png',     order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_lb_style_arrow',    parent = 'menu_l_button', w =  '60%HP', h =  '60%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/arrow_left.png', order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_lb_style_close',    parent = 'menu_l_button', w = '100%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/close.png',      order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_lb_style_options',  parent = 'menu_l_button', w =  '80%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/options.png',    order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_lb_style_question', parent = 'menu_l_button', w = '100%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/question.png',   order = 3, visible = false, opacity = 0, respondable = false, },

		{ entity = 'sprite', key = 'menu_rb_style_accept',   parent = 'menu_r_button', w = '100%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/accept.png',      order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_rb_style_arrow',    parent = 'menu_r_button', w =  '60%HP', h =  '60%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/arrow_right.png', order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_rb_style_close',    parent = 'menu_r_button', w = '100%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/close.png',       order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_rb_style_options',  parent = 'menu_r_button', w =  '80%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/options.png',     order = 3, visible = false, opacity = 0, respondable = false, },
		{ entity = 'sprite', key = 'menu_rb_style_question', parent = 'menu_r_button', w = '100%HP', h = '100%HP', x = '50%HP', y = '50%HP', texture = 'menu/screen/question.png',    order = 3, visible = false, opacity = 0, respondable = false, },

		{ entity = 'text', key = 'menu_text', parent = 'menu_frame', w = '60%WP', h = '50%HP', x = '50%WP', y = '50%HP', color = 'black', order = 2, text = 'Menu', size = '30%HP', },
	}
	return table
end

------------------------------------------------------------------------------------------
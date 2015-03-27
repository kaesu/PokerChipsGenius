class 'ModalSettingsPayoutsScreen' (Screen)

------------------------------------------------------------------------------------------

function ModalSettingsPayoutsScreen:onInit()
	self.entities.btn_done:setOnClick(function() self:onOkClick() end)
	self:setInfoCaption('Favorite')
	self:setInfoTag('Payouts')

	SceneManager:shared():requireScreen('ModalInfoScreen', 10)
	SceneManager:shared():getScreenNamed('ModalInfoScreen'):hide()

	if (self.entities.b_1 ~= nil) then
		self.entities.b_1:setOnClick(function()
			SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
		end)
	end

	self:initPie()
end

function ModalSettingsPayoutsScreen:onDestroy()
end

------------------------------------------------------------------------------------------

function ModalSettingsPayoutsScreen:onOkClick()
	self:hide()
	if (types.isFunction(self.info.on_ok_click)) then
		self.info.on_ok_click()
	end
end

function ModalSettingsPayoutsScreen:setOnOkClick(f)
	assert(types.isFunction(f))
	self.info.on_ok_click = f
end

------------------------------------------------------------------------------------------

function ModalSettingsPayoutsScreen:setInfoCaption(str)
	self.entities.txt_info:setText(str)
end

function ModalSettingsPayoutsScreen:setInfoTag(str)
	self.entities.txt_tag:setText(str)
end

------------------------------------------------------------------------------------------

function ModalSettingsPayoutsScreen:initPie()
	local function create_pie_slider_info(data, radius)
		local tap_area_radius = radius*0.6
		local slider_w        = radius*0.4

		local entity = Sprite()

		local function dropPredicate()
			return true
		end
		local slider = Drag() -- Drag('',cc.size(tap_area_radius,tap_area_radius))
--			  slider:setColor(COLOR('green'))
			  slider:setOrder(1)
			  slider:setDropPredicate(dropPredicate)
			  slider:setBoundingBoxCircle(cc.p(0,0), tap_area_radius)
		entity:addChild(slider)

		local sprite_holder = Sprite()
			  sprite_holder:setOrder(2)
			  sprite_holder:setPosition(slider:getWidth()/2,slider:getHeight()/2)
			  sprite_holder:setRespondable(false)
		slider:addChild(sprite_holder)

		local sector = Sprite('',cc.size(GET_SCREEN_WIDTH()*0.01,radius))
			  sector:setColor(COLOR('gray'))
			  sector:setOrder(1)
			  sector:setPosition(0,-sector:getHeight()/2)
			  sector:setRespondable(false)
		sprite_holder:addChild(sector)

		local spr = Sprite('menu/pie_slider.png',cc.size(slider_w,slider_w))
			  spr:setOrder(2)
			  spr:setRespondable(false)
		sprite_holder:addChild(spr)

		local line = Sprite('',cc.size(spr:getWidth(),spr:getHeight()*0.2))
			  line:setOrder(1)
			  line:setColor(COLOR(data.color))
			  line:setPosition(spr:getWidth()*0.5,spr:getHeight()*0.9)
			  line:setRespondable(false)
		spr:addChild(line)

		local function onDrag(info)
			local x = slider:getPositionX()
			local y = slider:getPositionY()
			local angle_rad = math.atan2(x,y)
			local angle_deg = angle_rad * 180 / math.pi
			sprite_holder:setRotation(angle_deg)
			local n_x = radius * 1.2 * math.sin(angle_rad)
			local n_y = radius * 1.2 * math.cos(angle_rad)
			slider:setPosition(n_x,n_y)
		end
		slider:setOnDrag(onDrag)

		local info = {}
			  info.entity = entity
			  info.slider = slider

		return info
	end

	local data = {
		{ color = '#8de800', description = '1st place', },
		{ color = '#40c8c7', description = '2nd place', },
		{ color = '#fc3600', description = '3rd place', },
		{ color = 'yellow',  description = '4th place', },
		{ color = 'gray',    description = '5th place', },
	}

	for i,row in pairs(data) do
		local radius = self.entities.pie:getWidth() * self.entities.pie:getScaleX() / 2
		local info = create_pie_slider_info(row, radius)
		local entity = info.entity
			  entity:setPosition(self.entities.pie:getPosition())
			  entity:setOrder(2)
		self.entities.pie_holder:addChild(entity)
	end

	local function onTabChanged()
		local tab_index = self.entities.payouts_tabs:getCurrentTabIndex()
		print('tab changed: ', tab_index)
	end
	self.entities.payouts_tabs:setOnTabChanged(onTabChanged)
end

------------------------------------------------------------------------------------------

function ModalSettingsPayoutsScreen:makeContent()
	local table = {
		{ entity = 'sprite', w = '100%W', h = '5%H',  x = '50%W', y = '97.5%H', order = 1, color = 'black',      opacity = 0.5, },
		{ entity = 'sprite', w = '100%W', h = '5%H',  x = '50%W', y = '92.5%H', order = 1, color = 'light_gray', },
		{ entity = 'sprite', w = '100%W', h = '85%H', x = '50%W', y = '47.5%H', order = 1, color = 'white',      },
		{ entity = 'sprite', w = '100%W', h = '5%H',  x = '50%W', y = '2.5%H',  order = 1, color = 'dark_gray',  },

		{ entity = 'text',   key = 'txt_info', w = '50%W', h = '5%H', x = '27.5%W', y = '92.5%H', order = 2, color = 'blue',  text = 'Info', size = '3%H', alignment = 'left', },
		{ entity = 'text',   key = 'txt_tag',  w = '50%W', h = '5%H', x = '50%W',   y = '92.5%H', order = 2, color = 'black', text = 'Tag',  size = '3%H', },
		{ entity = 'text',   key = 'txt_done', w = '50%W', h = '5%H', x = '72.5%W', y = '92.5%H', order = 2, color = 'blue',  text = 'Done', size = '3%H', alignment = 'right', },
		{ entity = 'button', key = 'btn_done', w = '30%W', h = '5%H', x = '85%W',   y = '92.5%H', order = 3, color = 'transparent', },

--vv
		{ entity = 'text', key = 'txt_1', w = '100%W', h = '5%H', x = '50%W', y = '85%H', order = 2, color = 'black', text = 'NUMBER OF PLAYERS WIN', size = '3%H', },
--		{ entity = 'button', key = 'b_1', w = '6.25%H', h = '6.25%H', x = '6.25%HR', y = '85%H', order = 2, texture = 'common/question-ico.png', },
		{ entity = 'tabs', key = 'payouts_tabs', w = '25%W', h = '25%W', x = '50%W', y = '73%H', order = 2, style = 'rectangle', tabs = {1,2,3,4,5,}, },

--pie
		{ entity = 'sprite', key = 'pie_holder', order = 2, },
		{ entity = 'sprite', key = 'pie', parent = 'pie_holder', w = '50%W', h = '50%W', x = '50%W', y ='50%W', order = 1, texture = 'menu/pie.png', },
	}
	return table
end

------------------------------------------------------------------------------------------
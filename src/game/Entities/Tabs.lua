class 'Tabs' (Entity)

------------------------------------------------------------------------------------------

function Tabs:__init(size, style)
	assert(types.isSize(size))
	assert(types.isString(style))

	local cocos_entity = HelperCocos.createSpriteEntity('', size)
	cocos_entity:setAnchorPoint(cc.p(0.5,0.5))

	Entity.__init(self, cocos_entity)

	self.info.tabs = {}
	self.info.current_tab_index = 0

	self:setStyle(style)
end

function Tabs:onDestroy()
end

------------------------------------------------------------------------------------------

function Tabs:setStyle(style)
	assert(types.isString(style))
	if (style == 'rounded') then
		local h_2 = self:getHeight()/2
		self:setTabOpenedSize(cc.size(h_2*4,h_2))
		self:setTabClosedSize(cc.size(h_2,h_2))
		self:setTabDistance(h_2*0.75)
	elseif (style == 'rectangle') then
		local size = self:getContentSize()
		local w = size.width
		local h = size.height

		local function updateIndex()
			local p = self.info.platform:getPosition()
			local platform_w = self.info.platform:getWidth()
			local x = platform_w/2-p.x+w/2
			local index = math.floor(x/w)+1
			if (index < 1) then
				index = 1
			end
			if (index > self:getTabsCount()) then
				index = self:getTabsCount()
			end
			self.info.current_tab_index = index
		end
		local function onMoveEnd()
			self:updateScrollerAnchors(true)
			updateIndex()
		end
		local function onDragEnd(info)
			self:updateScrollerAnchors(false)
		end
		local scroller = Scroller('',size)
			  scroller:setColor(COLOR('red'))
			  scroller:setOrder(5)
			  scroller:setOnClickEnd(onDragEnd)
			  scroller:setSwipeTime(0.3)
			  scroller:enableSwipe()
			  scroller:setOnInertionMoveEnd(onMoveEnd)
			  scroller:setOnSwipeMoveEnd(onMoveEnd)
		self:addChild(scroller)

		self.info.platform = scroller
		self:updateScrollerAnchors(true)

		local frame_width = GET_SCREEN_HEIGHT() * 0.01
		local frame_info = {
			{ size = cc.size(frame_width,h+frame_width), position = cc.p(w*0,h*0.5), },
			{ size = cc.size(frame_width,h+frame_width), position = cc.p(w*1,h*0.5), },
			{ size = cc.size(w+frame_width,frame_width), position = cc.p(w*0.5,h*0), },
			{ size = cc.size(w+frame_width,frame_width), position = cc.p(w*0.5,h*1), },
		}
		for i,k in pairs(frame_info) do
			local spr = Sprite('',k.size)
			spr:setColor(COLOR('blue'))
			spr:setOrder(10)
			spr:setRespondable(false)
			spr:setPosition(k.position)
			self:addChild(spr)
		end
	elseif (style == 'text') then
	else
		assert(false)
	end
	self.info.style = style
end

------------------------------------------------------------------------------------------

function Tabs:setTabOpenedSize(size)
	assert(types.isSize(size))
	self.info.tab_opened_size = size
end

function Tabs:setTabClosedSize(size)
	assert(types.isSize(size))
	self.info.tab_closed_size = size
end

function Tabs:setTabDistance(num)
	assert(types.isNumber(num))
	self.info.tab_distance = num
end

------------------------------------------------------------------------------------------

function Tabs:addTabInfo(name)
	assert(types.isString(name))

	if (self.info.style == 'rounded') then
		local function createTabInfo(text, index)
			local info = {}

			info.name = text
			info.entity = Sprite()
			info.entity:setName(self:getName() .. '_a' .. index)

			local size_max = self.info.tab_opened_size
			local size_min = self.info.tab_closed_size

			info.text_entity = Button('', size_max)
			info.text_entity:setColor(COLOR('blue'))
			info.text_entity:setName(self:getName() .. '_b' .. index)
			info.text_entity:setText(tostring(index) .. ' ' .. text)
			info.text_entity:setTextColor(COLOR('white'))
			info.text_entity:setTextFontSize(size_max.height * 0.5)
			info.text_entity:setStyle('rounded')

			info.button_entity = Button('', size_min)
			info.button_entity:setText(tostring(index))
			info.button_entity:setName(self:getName() .. '_c' .. index)
			info.button_entity:setTextColor(COLOR('black'))
			info.button_entity:setTextFontSize(size_min.height * 0.5)
			info.button_entity:setStyle('rounded')
			info.button_entity:setOnClick(function()
				self:onTabClick(index)
			end)

			info.accept_entity = Sprite('controls/tabs/accept.png', size_min)
			info.accept_entity:setColor(COLOR('black'))
			info.accept_entity:setRespondable(false)
			info.accept_entity:setName(self:getName() .. '_d' .. index)

			info.entity:addChild(info.button_entity, 3)
			info.entity:addChild(info.text_entity,   4)
			info.entity:addChild(info.accept_entity, 5)

			return info
		end

		local index = self:getTabsCount() + 1
		local tab_info = createTabInfo(name, index)

		self:addChild(tab_info.entity, 5)

		self.info.tabs[index] = tab_info
		self.info.current_tab_index = 1
	elseif (self.info.style == 'rectangle') then
		local function createTabInfo(text, index)
			local size = self:getContentSize()
			local w = size.width
			local h = size.height

			local main = Sprite()
				  main:setColor(COLOR('green'))
				  main:setName(self:getName() .. '_a' .. index)
				  main:setRespondable(false)
				  main:setOrder(1)

			local elem = Sprite('',size)
				  elem:setColor(COLOR('white'))
				  elem:setPosition(w*0.5,h*0.5)
				  elem:setRespondable(false)
			main:addChild(elem)

			local text = Label(name,DEFAULT_FONT_NAME,h*0.5,cc.size(w,0),'center')
				  text:setColor(COLOR('black'))
				  text:setPosition(w*0.5,h*0.5)
				  text:setRespondable(false)
			elem:addChild(text)

			local frame_width = GET_SCREEN_HEIGHT() * 0.01
			local g_frame_info = {
				{ size = cc.size(frame_width/2,h), position = cc.p(w*0,h*0.5), },
				{ size = cc.size(frame_width/2,h), position = cc.p(w*1,h*0.5), },
				{ size = cc.size(w,frame_width/2), position = cc.p(w*0.5,h*0+frame_width/4), },
				{ size = cc.size(w,frame_width/2), position = cc.p(w*0.5,h*1-frame_width/4), },
			}
			for i,k in pairs(g_frame_info) do
				local spr = Sprite('',k.size)
				spr:setColor(COLOR('light_gray'))
				spr:setOrder(1)
				spr:setRespondable(false)
				spr:setPosition(k.position)
				elem:addChild(spr)
			end

			local info = {}
				  info.name = text
				  info.entity = main

			return info
		end

		local index = self:getTabsCount() + 1
		local tab_info = createTabInfo(name, index)

		local w = self:getWidth()
		local h = self:getHeight()

		tab_info.entity:setPosition(w*(index-1),h*0)
		self.info.platform:addChild(tab_info.entity, 1)
		self.info.platform:setContentSize(cc.size(w*index,h))

		self.info.tabs[index] = tab_info
		self.info.current_tab_index = 1
	end

	self:updateTabs()
end

function Tabs:updateTabs()
	if (self.info.style == 'rounded') then
		local count = self:getTabsCount()
		if (count > 0) then
			local w = self:getWidth()
			local h = self:getHeight()

			local distance = self.info.tab_distance
			local b_w      = self.info.tab_opened_size.width
			local s_w      = self.info.tab_closed_size.width

			local tabs_width = b_w + s_w * (count-1) + distance * (count-1)
			local n_x = (w - tabs_width)/2
			local n_y = h/2

			for i,tab in pairs(self.info.tabs) do
				if (i == self.info.current_tab_index) then
					tab.text_entity:show()
					tab.button_entity:hide()
					tab.accept_entity:hide()
					tab.entity:setPosition(n_x+b_w/2, n_y)
					n_x = n_x + b_w + distance
				else
					tab.text_entity:hide()
					if (tab.completed == true) then
						tab.button_entity:show()
						tab.button_entity:setTextColor(COLOR('white'))
						tab.accept_entity:show(0, false)
					else
						tab.button_entity:show()
						tab.button_entity:setTextColor(COLOR('black'))
						tab.accept_entity:hide()
					end
					tab.entity:setPosition(n_x+s_w/2, n_y)
					n_x = n_x + s_w + distance
				end
			end
		end
	elseif (self.info.style == 'rectangle') then
		local count = self:getTabsCount()
		if (count > 0) then
			local w = self:getWidth()
			local h = self:getHeight()

			local platform_w = self.info.platform:getWidth()

			local cur_index = self:getCurrentTabIndex()
			
			self.info.platform:setPosition((w*(cur_index-1))+platform_w/2,h*0.5)
		end
		self:updateScrollerAnchors(true)
	end
end

function Tabs:updateScrollerAnchors(is_on_move_end)
	if (self.info.style == 'rectangle') then
		local size = self:getContentSize()
		local w = size.width
		local h = size.height
		local position = self.info.platform:getPosition()
		local platform_w = self.info.platform:getWidth()
		local tabs_count = self:getTabsCount()

		local p1 = cc.p(w/2-w/2,h/2)
		local p2 = cc.p(w/2+w/2,h/2)

		local x = platform_w/2-position.x
		local index = x/w+1

		local l = math.floor(index)
		local r = math.ceil(index)

		if (l < 1) then
			l = 1
		end
		if (r > tabs_count) then
			r = tabs_count
		end

		local p1 = cc.p(w*(l+tabs_count/2), h/2)
		local p2 = cc.p(w*(r+tabs_count/2), h/2)

		local p1 = cc.p(platform_w/2-w*(r-1),h*0.5)
		local p2 = cc.p(platform_w/2-w*(l-1),h*0.5)

		if (l == r) then
			p2.x = p2.x + 0.001
		end

		self.info.platform:setScrollingLine(p1,p2)
		self.info.platform:removeScrollingAnchorPoints()
		self.info.platform:addScrollingAnchorPoint(p1,1000)
		self.info.platform:addScrollingAnchorPoint(p2,1000)
		self.info.platform:setSwipingLeftPoint(p1)
		self.info.platform:setSwipingRightPoint(p2)

		if (is_on_move_end) then
			local platform_w = self.info.platform:getWidth()
			local scr1 = cc.p( platform_w/2,   h/2)
			local scr2 = cc.p(-platform_w/2+w, h/2)
			self.info.platform:setScrollingLine(scr1,scr2)
		end
	end
end

------------------------------------------------------------------------------------------

function Tabs:getCurrentTabIndex()
	return self.info.current_tab_index
end

function Tabs:getTabsCount()
	return table.size(self.info.tabs)
end

------------------------------------------------------------------------------------------

function Tabs:onTabClick(index)
	self.info.current_tab_index = index
	self:updateTabs()
	if (types.isFunction(self.info.on_tab_changed)) then
		self.info.on_tab_changed(self:getCurrentTabIndex())
	end
end

------------------------------------------------------------------------------------------

function Tabs:setCompleted(index)
	self.info.tabs[index].completed = true
end

function Tabs:isCompleted()
	for i,tab in pairs(self.info.tabs) do
		if (tab.completed ~= true) then
			return false
		end
	end
	return true
end

------------------------------------------------------------------------------------------

function Tabs:setOnTabChanged(f)
	assert(types.isFunction(f))
	self.info.on_tab_changed = f
end

------------------------------------------------------------------------------------------
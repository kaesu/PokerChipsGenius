class 'ModalSettingsRebuysScreen' (Screen)

------------------------------------------------------------------------------------------

function ModalSettingsRebuysScreen:onInit()
	self.entities.btn_done:setOnClick(function() self:onOkClick() end)
	self:setInfoCaption('Favorite')
	self:setInfoTag('Rebuys')

	SceneManager:shared():requireScreen('ModalInfoScreen', 10)
	SceneManager:shared():getScreenNamed('ModalInfoScreen'):hide()

	if (self.entities.b_1 ~= nil) then
		self.entities.b_1:setOnClick(function()
			SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
		end)
	end
	if (self.entities.b_2 ~= nil) then
		self.entities.b_2:setOnClick(function()
			SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
		end)
	end
end

function ModalSettingsRebuysScreen:onDestroy()
end

------------------------------------------------------------------------------------------

function ModalSettingsRebuysScreen:onOkClick()
	self:hide()
	if (types.isFunction(self.info.on_ok_click)) then
		self.info.on_ok_click()
	end
end

function ModalSettingsRebuysScreen:setOnOkClick(f)
	assert(types.isFunction(f))
	self.info.on_ok_click = f
end

------------------------------------------------------------------------------------------

function ModalSettingsRebuysScreen:setInfoCaption(str)
	self.entities.txt_info:setText(str)
end

function ModalSettingsRebuysScreen:setInfoTag(str)
	self.entities.txt_tag:setText(str)
end

------------------------------------------------------------------------------------------

function ModalSettingsRebuysScreen:makeContent()
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
		{ entity = 'text', key = 'txt_1', w = '100%W', h = '5%H', x = '50%W', y = '85%H', order = 2, color = 'black', text = 'REBUY PERIOD', size = '3%H', },
		{ entity = 'text', key = 'txt_2', w = '100%W', h = '5%H', x = '50%W', y = '50%H', order = 2, color = 'black', text = 'ADD-ON AMOUNT', size = '3%H', },

--		{ entity = 'button', key = 'b_1', w = '6.25%H', h = '6.25%H', x = '6.25%HR', y = '85%H', order = 2, texture = 'common/question-ico.png', },
--		{ entity = 'button', key = 'b_2', w = '6.25%H', h = '6.25%H', x = '6.25%HR', y = '50%H', order = 2, texture = 'common/question-ico.png', },

		{ entity = 'tabs', w = '25%W', h = '25%W', x = '50%W', y = '70%H', order = 2, style = 'rectangle', tabs = {'Not','x1','x2','x3','x4','x5',}, },
		{ entity = 'tabs', w = '25%W', h = '25%W', x = '50%W', y = '35%H', order = 2, style = 'rectangle', tabs = {'Not','x1','x2','x3','x4','x5',}, },
	}
	return table
end

------------------------------------------------------------------------------------------
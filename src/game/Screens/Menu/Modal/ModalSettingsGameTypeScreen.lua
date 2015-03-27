class 'ModalSettingsGameTypeScreen' (Screen)

------------------------------------------------------------------------------------------

function ModalSettingsGameTypeScreen:onInit()
	self.entities.btn_done:setOnClick(function() self:onOkClick() end)
	self:setInfoCaption('Favorite')
	self:setInfoTag('Game Type')

	SceneManager:shared():requireScreen('ModalInfoScreen', 10)
	SceneManager:shared():getScreenNamed('ModalInfoScreen'):hide()

	self.entities.b_1:setOnClick(function()
		SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
		SceneManager:shared():getScreenNamed('ModalInfoScreen'):setInfoCaption('STARTING STACK')
	end)
	self.entities.b_2:setOnClick(function()
		SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
		SceneManager:shared():getScreenNamed('ModalInfoScreen'):setInfoCaption('LEVELS')
	end)
	self.entities.b_3:setOnClick(function()
		SceneManager:shared():getScreenNamed('ModalInfoScreen'):show()
		SceneManager:shared():getScreenNamed('ModalInfoScreen'):setInfoCaption('STARTING STACK')
	end)
end

function ModalSettingsGameTypeScreen:onDestroy()
end

------------------------------------------------------------------------------------------

function ModalSettingsGameTypeScreen:onOkClick()
	self:hide()
	if (types.isFunction(self.info.on_ok_click)) then
		self.info.on_ok_click()
	end
end

function ModalSettingsGameTypeScreen:setOnOkClick(f)
	assert(types.isFunction(f))
	self.info.on_ok_click = f
end

------------------------------------------------------------------------------------------

function ModalSettingsGameTypeScreen:setInfoCaption(str)
	self.entities.txt_info:setText(str)
end

function ModalSettingsGameTypeScreen:setInfoTag(str)
	self.entities.txt_tag:setText(str)
end

------------------------------------------------------------------------------------------

function ModalSettingsGameTypeScreen:makeContent()
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
		{ entity = 'text', key = 'txt_1', w = '100%W', h = '5%H', x = '50%W', y = '85%H', order = 2, color = 'black', text = 'STARTING STACK (CHIPS)', size = '3%H', },
		{ entity = 'text', key = 'txt_2', w = '100%W', h = '5%H', x = '50%W', y = '55%H', order = 2, color = 'black', text = 'LEVELS',                 size = '3%H', },
		{ entity = 'text', key = 'txt_3', w = '100%W', h = '5%H', x = '50%W', y = '25%H', order = 2, color = 'black', text = 'STARTING STACK (CHIPS)', size = '3%H', },

		{ entity = 'button', key = 'b_1', w = '6.25%H', h = '6.25%H', x = '6.25%HR', y = '85%H', order = 2, texture = 'common/question-ico.png', },
		{ entity = 'button', key = 'b_2', w = '6.25%H', h = '6.25%H', x = '6.25%HR', y = '55%H', order = 2, texture = 'common/question-ico.png', },
		{ entity = 'button', key = 'b_3', w = '6.25%H', h = '6.25%H', x = '6.25%HR', y = '25%H', order = 2, texture = 'common/question-ico.png', },

		{ entity = 'tabs', key = 't1', w = '50%W', h = '25%W', x = '50%W', y = '70%H', order = 2, style = 'rectangle', tabs = {500,1000,1500,2000,2500,}, },
		{ entity = 'tabs', key = 't2', w = '25%W', h = '25%W', x = '50%W', y = '40%H', order = 2, style = 'rectangle', tabs = {1,2,3,4,5,}, },
		{ entity = 'tabs', key = 't3', w = '50%W', h = '25%W', x = '50%W', y = '10%H', order = 2, style = 'rectangle', tabs = {'slow','medium','fast',}, },
	}
	return table
end

------------------------------------------------------------------------------------------
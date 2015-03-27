class 'ModalInfoScreen' (Screen)

------------------------------------------------------------------------------------------

function ModalInfoScreen:onInit()
	self.entities.btn_close:setOnClick(function() self:onOkClick() end)
end

function ModalInfoScreen:onDestroy()

end

------------------------------------------------------------------------------------------

function ModalInfoScreen:onOkClick()
	self:hide()
	if (types.isFunction(self.info.on_ok_click)) then
		self.info.on_ok_click()
	end
end

function ModalInfoScreen:setOnOkClick(f)
	assert(types.isFunction(f))
	self.info.on_ok_click = f
end

------------------------------------------------------------------------------------------

function ModalInfoScreen:setInfoCaption(str)
	self.entities.txt_info:setText(str)
end

function ModalInfoScreen:setInfoText(str)
	self.entities.txt_text:setText(str)
end

------------------------------------------------------------------------------------------

function ModalInfoScreen:makeContent()
	local table = {
		{ entity = 'sprite', w = '100%W', h = '5%H',  x = '50%W', y = '97.5%H', order = 1, color = 'black',      opacity = 0.5, },
		{ entity = 'sprite', w = '100%W', h = '5%H',  x = '50%W', y = '92.5%H', order = 1, color = 'light_gray', },
		{ entity = 'sprite', w = '100%W', h = '85%H', x = '50%W', y = '47.5%H', order = 1, color = 'white',      },
		{ entity = 'sprite', w = '100%W', h = '5%H',  x = '50%W', y = '2.5%H',  order = 1, color = 'dark_gray',  },

		{ entity = 'button', key = 'btn_close', w = '30%W', h = '5%H', x = '15%W', y = '92.5%H', order = 2, color = 'transparent', text = 'Close', textcolor = 'blue', textsize = '3%H', },
		{ entity = 'text',   key = 'txt_info',  w = '50%W', h = '5%H', x = '50%W', y = '92.5%H', order = 2, color = 'black', text = 'Info', size = '3%H', },
		{ entity = 'text',   key = 'txt_text',  w = '100%W', h = '90%H', x = '50%W', y = '50%H', order = 2, color = 'black', text = 'Text Lorem Ipsum', },
	}
	return table
end

------------------------------------------------------------------------------------------
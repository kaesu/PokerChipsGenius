class 'OkCancel' (Screen)

------------------------------------------------------------------------------------------

function OkCancel:onInit()
	self.entities.btn_ok:setOnClick(function() self:onOkClick() end)
	self.entities.btn_cancel:setOnClick(function() self:onCancelClick() end)
end

------------------------------------------------------------------------------------------

function OkCancel:onOkClick()
	if (types.isFunction(self.info.on_ok_click)) then
		self.info.on_ok_click()
	end
end

function OkCancel:onCancelClick()
	if (types.isFunction(self.info.on_cancel_click)) then
		self.info.on_cancel_click()
	end
end

------------------------------------------------------------------------------------------

function OkCancel:setOnOkClick(f)
	assert(types.isFunction(f))
	self.info.on_ok_click = f
end

function OkCancel:setOnCancelClick(f)
	assert(types.isFunction(f))
	self.info.on_cancel_click = f
end

------------------------------------------------------------------------------------------

function OkCancel:makeContent()
	local table = {
		{ entity = 'sprite', key = 'ok_cancel_window_top', },
		{ entity = 'button', key = 'btn_ok',     parent = 'ok_cancel_window_top', wp = 30, hp = 15, xp = 25, y = '50%H', color = 'green', order = 1, },
		{ entity = 'button', key = 'btn_cancel', parent = 'ok_cancel_window_top', wp = 30, hp = 15, xp = 75, y = '50%H', color = 'red',   order = 1, },
	}
	return table
end

------------------------------------------------------------------------------------------
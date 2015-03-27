class 'OkCancelTest' (Screen)

------------------------------------------------------------------------------------------

function OkCancelTest:onInit()
	self.entities.btn_test:setOnClick(function() self:onTestClick() end)
end

function OkCancelTest:onTestClick()
	local window = SceneManager:shared():createScreen('OkCancel')
	window:setOnOk(function()
	end)
	window:setOnCancel(function()
	end)
	self:addChild(window, 1)
end

function OkCancelTest:makeContent()
	local table = {
		{ entity = 'sprite', key = 'ok_cancel_test_top', },
		{ entity = 'sprite', key = 'btn_test', parent = 'ok_cancel_test_top', wp = 30, hp = 15, x = '50%W', y = '50%H', color = 'blue', order = 2, },
	}
	return table
end

------------------------------------------------------------------------------------------
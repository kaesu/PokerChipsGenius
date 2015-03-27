class 'DebugScreen' (Screen)

------------------------------------------------------------------------------------------

function DebugScreen:onUpdate(dt)
	self:updateLabel()
end

function DebugScreen:updateLabel()
	local touches = TouchManager:shared():getTouches()
	if (touches and table.size(touches) > 0) then
		local text = ''
		for i, touch in pairs(touches) do
			local responderName = (types.isEntity(touch.responder) and touch.responder:getName() .. '{id=' .. touch.responder:getID() .. '}' or 'nil')
			text = text .. ' [' .. touch.id .. ']=>[' .. responderName .. '][' .. string.format('%.2f', touch.x) .. ', ' .. string.format('%.2f', touch.y) .. ']]'
		end
		assert(types.isString(text))
		self.entities.debugText:setText(text)
	else
		self.entities.debugText:setText('')
	end
end

------------------------------------------------------------------------------------------

function DebugScreen:makeContent()
	local table = {
		{ entity = 'text', key = 'debugText', w = '100%', h = '5%', x = '50%', y = '2.5%', order = 1, text = 'Debug_Text', size = '4%H', bg = 'black', opacity = 0.7, },
	}
	return table
end

------------------------------------------------------------------------------------------
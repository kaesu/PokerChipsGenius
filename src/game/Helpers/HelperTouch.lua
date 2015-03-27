Touches = {
	enable = function()
		TouchManager:shared():enableInteraction()
	end,
	disable = function(delay)
		TouchManager:shared():disableInteraction(delay)
	end,
}
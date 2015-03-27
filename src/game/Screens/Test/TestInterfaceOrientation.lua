class 'TestInterfaceOrientation' (Screen)

------------------------------------------------------------------------------------------

function TestInterfaceOrientation:onInit()
	self.entities.landscape:setOnClick(function()
		cc.Director:getInstance():setPreferredInterfaceOrientation(cc.INTERFACEORIENTATION_LANDSCAPE)
	end)
	self.entities.portrait:setOnClick(function()
		cc.Director:getInstance():setPreferredInterfaceOrientation(cc.INTERFACEORIENTATION_PORTRAIT)
	end)
end

------------------------------------------------------------------------------------------

function TestInterfaceOrientation:onUpdate(dt)
	
end

------------------------------------------------------------------------------------------

function TestInterfaceOrientation:makeContent()
	local table = {
		{ entity = 'button',  key = 'landscape', w = '30%W', h = '15%H', x = '50%W', y = '30%H', color = 'yellow', order = 3, },
		{ entity = 'button',  key = 'portrait',  w = '30%W', h = '15%H', x = '50%W', y = '50%H', color = 'yellow', order = 3, },
		{ entity = 'editbox', key = 'editbox',   w = '50%W', h = '20%H', x = '50%W', y = '70%H', color = 'yellow', order = 1, },
	}
	return table
end

------------------------------------------------------------------------------------------
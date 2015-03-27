class 'GameTableScreen' (Screen)

------------------------------------------------------------------------------------------

function GameTableScreen:onInit()
end

------------------------------------------------------------------------------------------

function GameTableScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'table_top', },
		{ entity = 'sprite', key = 'table_bg', parent = 'table_top', w = '100%W', h = '100%H', x = '50%W', y = '50%H', color = 'white', order = 1, },
		{ entity = 'sprite', key = 'static',   parent = 'table_top', w = '100%W', h = '100%H', x = '50%W', y = '50%H', texture = 'game/table/static.png', order = 2, },
	}
	return table
end

------------------------------------------------------------------------------------------
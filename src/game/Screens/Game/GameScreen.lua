class 'GameScreen' (Screen)

------------------------------------------------------------------------------------------

function GameScreen:onInit()
	SceneManager:shared():hideScreen('MenuScreen')
	self:initScrollers()
end

------------------------------------------------------------------------------------------

function GameScreen:initScrollers()
	local function createLine(x, y, width, height)
		local line = HelperCocos.createSpriteEntity()
		line:setTextureRect(cc.rect(0,0,width,height))
		line:setPosition(cc.p(x, y))
		line:setColor(cc.c4b(0,0,0,255))
		return line
	end
	local function createScroller(_x)
		local scroller = Sprite()
		scroller:setPosition(0,0)
		for i = 1,3 do
			local x, y = _x+(i*10)/1136*GET_SCREEN_WIDTH(), 320/640*GET_SCREEN_HEIGHT()
			local w, h = 4/1136 * GET_SCREEN_WIDTH(), 80/640*GET_SCREEN_HEIGHT()
			scroller:getCocosEntity():addChild(createLine(x,y,w,h), 1)
		end
		return scroller
	end
	self.entities.table_screen:addChild(createScroller((1136-48)/1136*GET_SCREEN_WIDTH()), 10)
	self.entities.bet_screen:addChild(createScroller(8/1136*GET_SCREEN_WIDTH()), 10)

	local points = { cc.p(-GET_SCREEN_WIDTH(), 0), cc.p(0,0) }

	for i = 1,2 do
		local entity_name = ('scroller' .. i)

		local scroller = self.entities[entity_name]

		scroller:setScrollingEntity(self.entities.top)
		scroller:setScrollingRect(cc.rect(-GET_SCREEN_WIDTH(),0,GET_SCREEN_WIDTH(),0))
		scroller:addScrollingAnchorPoint(points[1], 1500)
		scroller:addScrollingAnchorPoint(points[2], 1500)

		scroller:enableSwipe()
		scroller:setSwipeTime(0.3)
		scroller:setSwipingLeftPoint(points[1])
		scroller:setSwipingRightPoint(points[2])

--		scroller:setScrollingSpeedFactor(3.14159)

		local function onClickBegin(info)
			RespondManager:shared():lock(entity_name)
		end
		local function onMoveEnd()
			RespondManager:shared():unlock(entity_name)
		end
		scroller:setOnClickBegin(onClickBegin)
		scroller:setOnInertionMoveEnd(onMoveEnd)
		scroller:setOnSwipeMoveEnd(onMoveEnd)
	end

	RespondManager:shared():addRespondingFamily({self.entities.scroller1})
	RespondManager:shared():addRespondingFamily({self.entities.scroller2})
end

------------------------------------------------------------------------------------------

function GameScreen:makeContent()
	local table = {
		{ entity = 'sprite',   key = 'top', },

		{ entity = 'sprite',   key = 'table_screen',       parent = 'top', order = 1, },
		{ entity = 'scroller', key = 'scroller1',          parent = 'table_screen', w = '4.22535%W', h = '12.5%H', x = '97.8873%W', y = '50%H', color = '#ffff00', order = 10, opacity = 0, visible = false, },
		{ entity = 'screen',   screen = 'GameTableScreen', parent = 'table_screen', order = 1, },

		{ entity = 'sprite',   key = 'bet_screen',         parent = 'top', x = '100%W', y = '0%H', order = 1, },
		{ entity = 'scroller', key = 'scroller2',          parent = 'bet_screen', w = '4.22535%W', h = '12.5%H', x = '2.11268%W', y = '50%H', color = '#ff00ff', order = 10, opacity = 0, visible = false, },
		{ entity = 'screen',   screen = 'GameBetScreen',   parent = 'bet_screen', order = 1, },
	}
	return table
end

------------------------------------------------------------------------------------------
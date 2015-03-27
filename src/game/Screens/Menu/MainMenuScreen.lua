class 'MainMenuScreen' (Screen)

------------------------------------------------------------------------------------------

function MainMenuScreen:onInit()
	SceneManager:shared():hideScreen('MenuScreen')

	self.entities.btn_create:setOnClick(function() self:onCreateClick() end)
	self.entities.btn_join:setOnClick(function() self:onJoinClick() end)
	self.entities.btn_tell:setOnClick(function() self:onTellAFriendClick() end)
	self.entities.btn_demo:setOnClick(function() self:onDemoClick() end)
end

------------------------------------------------------------------------------------------

function MainMenuScreen:onCreateClick()
	startScene('CreateGameScreen')
end

function MainMenuScreen:onJoinClick()
	startScene('JoinGameScreen')
end

function MainMenuScreen:onTellAFriendClick()
	--
end

function MainMenuScreen:onDemoClick()
	--
end

------------------------------------------------------------------------------------------

function MainMenuScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%', h = '100%', x = '50%', y = '50%', color = 'white', order = 1, },

		{ entity = 'button', key = 'btn_create', w = '80%W', h = '10%W', x = '50%W', y = '65%H', color = 'blue',  order = 2, text = 'CREATE GAME',   textcolor = 'white', textsize = '8%W', },
		{ entity = 'button', key = 'btn_join',   w = '80%W', h = '10%W', x = '50%W', y = '55%H', color = 'blue',  order = 3, text = 'JOIN GAME',     textcolor = 'white', textsize = '8%W', },
		{ entity = 'button', key = 'btn_tell',   w = '80%W', h = '10%W', x = '50%W', y = '45%H', color = 'white', order = 2, text = 'TELL A FRIEND', textcolor = 'blue',  textsize = '8%W', },
		{ entity = 'button', key = 'btn_demo',   w = '80%W', h = '10%W', x = '50%W', y = '35%H', color = 'white', order = 3, text = 'DEMO',          textcolor = 'blue',  textsize = '8%W', },
	}
	return table
end

------------------------------------------------------------------------------------------
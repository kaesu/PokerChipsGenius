class 'CreateGameScreen' (Screen)

------------------------------------------------------------------------------------------

function CreateGameScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Create Game')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('accept')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		SceneManager:shared():startScene('MainMenuScreen')
	end)
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		SceneManager:shared():startScene('CreateGameScreen2')
	end)
end

function CreateGameScreen:makeContent()
	local table = {
		{ entity = 'sprite',   key = 'bg', w = '100%W', h = '100%H', x = '50%W', y = '50%H', color = 'white', order = 1, },

		{ entity = 'editbox',  key = 'edit_name',     w = '95%W', h = '12.5%W', x = '50%W', y = '76.25%H', order = 5, placeholder = 'Name', },
		{ entity = 'editbox',  key = 'edit_password', w = '95%W', h = '12.5%W', x = '50%W', y = '63.75%H', order = 5, placeholder = 'Password', mode = 'password', },
		{ entity = 'checkbox', key = 'ch_allow_geo',  w = '95%W', h = '12.5%W', x = '50%W', y = '51.25%H', order = 5, text = 'Allow your geolocation info', textcolor = 'black', textsize = '3%W', },
	}
	return table
end

------------------------------------------------------------------------------------------
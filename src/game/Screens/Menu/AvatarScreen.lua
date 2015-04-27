class 'AvatarScreen' (Screen)

------------------------------------------------------------------------------------------

function AvatarScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Avatars')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('hidden')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		SceneManager:shared():startScene('IntroduceScreen')
	end)
end

------------------------------------------------------------------------------------------

function AvatarScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%', h = '100%', x = '50%', y = '50%', color = 'white', order = 1, },
	}
	return table
end

------------------------------------------------------------------------------------------
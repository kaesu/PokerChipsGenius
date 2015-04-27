class 'TermScreen' (Screen)

------------------------------------------------------------------------------------------

function TermScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Join With Email')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('hidden')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('close')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		SceneManager:shared():startScene('JoinWithEmailScreen2')
	end)
end

------------------------------------------------------------------------------------------

function TermScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%W', h = '100%H', x = '50%W', y = '50%H', color = 'white', },

		{ entity = 'text', key = 'terms_header', w = '90%W', h = '12.5%H', x = '50%W', y = '81.25%H', color = 'black', text = 'STRING_TERMS_HEADER', size = '5%H', alignment = 'left', },
		{ entity = 'text', key = 'terms_text',   w = '90%W', h = '75%H',   x = '50%W', y = '37.5%H',  color = 'black', text = 'STRING_TERMS_TEXT',   size = '3%H', alignment = 'left', },
	}
	return table
end

------------------------------------------------------------------------------------------
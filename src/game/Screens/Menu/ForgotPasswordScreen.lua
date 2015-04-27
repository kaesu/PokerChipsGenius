class 'ForgotPasswordScreen' (Screen)

------------------------------------------------------------------------------------------

function ForgotPasswordScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Forgot Password')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('hidden')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		SceneManager:shared():startScene('LoginWithEmailScreen')
	end)
	self.entities.edit_email:setText(SaveManager:shared():getString('EMAIL'))
end

function ForgotPasswordScreen:onDestroy()
	Screen.onDestroy(self)

	SaveManager:shared():setData('EMAIL', self.entities.edit_email:getText())
end

------------------------------------------------------------------------------------------

function ForgotPasswordScreen:makeContent()
	local table = {
		{ entity = 'sprite',  key = 'bg', w = '100%', h = '100%', x = '50%', y = '50%', color = 'white', order = 1, },

		{ entity = 'sprite',  key = 'text_bg',                     w = '100%',  h = '18.75%', x = '50%',   y = '78.125%', color = 'light_gray', order = 1, },
		{ entity = 'text',    key = 'text',    parent = 'text_bg', w = '80%WP', h = '80%HP',  x = '50%WP', y = '50%HP',   text = 'STRING_FORGOT_PASSWORD', color = 'black', alignment = 'left', size = '3%H', },

		{ entity = 'editbox', key = 'edit_email',  w = '94%W', h = '12.5%W', x = '50%W', y = '61.25%H', order = 5, placeholder = 'Email', },

		{ entity = 'button',  key = 'btn_request', w = '80%W', h = '10%W',   x = '50%W', y = '50%H', color = 'blue',  order = 2, text = 'SEND REQUEST', textcolor = 'white', },
	}
	return table
end

------------------------------------------------------------------------------------------
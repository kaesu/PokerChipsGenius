class 'LoginWithEmailScreen' (Screen)

------------------------------------------------------------------------------------------

function LoginWithEmailScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Log In')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('accept')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		startScene('StartScreen')
	end)
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		startScene('MainMenuScreen')
	end)

	self.entities.btn_forgot_pw:setOnClick(function()
		startScene('ForgotPasswordScreen')
	end)

	self.entities.edit_email:setText(SaveManager:shared():getString('EMAIL'))
	self.entities.edit_password:setText(SaveManager:shared():getString('PASSWORD'))
end

function LoginWithEmailScreen:onDestroy()
	Screen.onDestroy(self)

	SaveManager:shared():setData('EMAIL',    self.entities.edit_email:getText())
	SaveManager:shared():setData('PASSWORD', self.entities.edit_password:getText())
end

------------------------------------------------------------------------------------------

function LoginWithEmailScreen:onLogClick()
	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()

--	PRINT(glview:getSize():getWidth())
--	PRINT(self.entities.kek:getPositionX(), self.entities.kek:getPositionY())

	table.log(self.entities)
end

------------------------------------------------------------------------------------------

function LoginWithEmailScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%', h = '100%', x = '50%', y = '50%', color = 'white', order = 1, },

		{ entity = 'editbox', key = 'edit_email',    w = '95%W', h = '12.5%W', x = '50%W', y = '81.25%H', order = 5, placeholder = 'Email', },
		{ entity = 'editbox', key = 'edit_password', w = '95%W', h = '12.5%W', x = '50%W', y = '68.75%H', order = 5, placeholder = 'Password', mode = 'password', },

		{ entity = 'button',  key = 'btn_forgot_pw', w = '90%W', h = '12.5%W', x = '50%W', y = '56.25%H', order = 5, color = 'transparent', text = 'Forgot your password?', textcolor = 'blue', },
	}
	return table
end

------------------------------------------------------------------------------------------
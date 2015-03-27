class 'StartScreen' (Screen)

------------------------------------------------------------------------------------------

function StartScreen:onInit()
	SceneManager:shared():hideScreen('MenuScreen')

	self.entities.btn_em:setOnClick(function()
		startScene('JoinWithEmailScreen1')
	end)
	self.entities.btn_fb:setOnClick(function()
		startScene('IntroduceScreen')
	end)
	self.entities.btn_in:setOnClick(function()
		startScene('LoginWithEmailScreen')
	end)
end

------------------------------------------------------------------------------------------

function StartScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%', h = '100%', x = '50%', y = '50%', color = 'yellow', order = 1, },

		{ entity = 'button', key = 'btn_em', w = '80%W', h = '10%W', x = '50%', y = '40%', color = 'blue',        order = 2, text = 'Join with email',     textcolor = 'white', },
		{ entity = 'button', key = 'btn_fb', w = '80%W', h = '10%W', x = '50%', y = '30%', color = 'blue',        order = 2, text = 'Login with Facebook', textcolor = 'white', },
		{ entity = 'button', key = 'btn_in', w = '80%W', h = '10%W', x = '50%', y = '20%', color = 'transparent', order = 2, text = 'Log In',              textcolor = 'white', },

--		{ entity = 'sprite', key = 'default',     w = '5%',  h = '5%',  x = '20%', y = '20%', order = 3, texture = 'default.png', },
--		{ entity = 'sprite', key = 'default_32',  w = '32',  h = '32',  x = '50%', y = '50%', order = 3, texture = 'default.png', },
--		{ entity = 'sprite', key = 'default_64',  w = '64',  h = '64',  x = '80%', y = '80%', order = 3, texture = 'default.png', },
--		{ entity = 'sprite', key = 'default_128', w = '128', h = '128', x = '80%', y = '20%', order = 3, texture = 'default.png', },
	}
	return table
end

------------------------------------------------------------------------------------------
class 'StartScreen' (Screen)

------------------------------------------------------------------------------------------

function StartScreen:onInit()
	facebook.logout()

	SceneManager:shared():hideScreen('MenuScreen')

	self.entities.btn_em:setOnClick(function()
		SceneManager:shared():startScene('JoinWithEmailScreen1')
	end)
	self.entities.btn_fb:setOnClick(function()
--		facebook.login('user_about_me', function(ret, msg)
		facebook.login(function(ret, msg)
			print(ret, msg)
			if (ret == 0) then
				self:onSuccessFBLogin()
			else
				print('failed')
			end
		end)
	end)
	self.entities.btn_in:setOnClick(function()
		SceneManager:shared():startScene('LoginWithEmailScreen')
	end)

	self.info.time_dt = 0
	self.info.client = SocketManager:shared():addListener(self)

	self:getConfigurations()
end

------------------------------------------------------------------------------------------

function StartScreen:onDestroy()
	self.info.client = nil
	SocketManager:shared():removeListener(self)
end

----------------------------------- SOCKET LISTENER --------------------------------------

function StartScreen:onOpen()
	print('StartScreen:onOpen')
end

function StartScreen:onClose()
	print('StartScreen:onClose')
end

function StartScreen:onError(err)
	print('StartScreen:onError, ' .. err)
end

function StartScreen:onMessage(msg)
	print('StartScreen:onMessage, ' .. msg)
end

------------------------------------------------------------------------------------------

function StartScreen:onUpdate(dt)
	self.info.time_dt = self.info.time_dt + dt
	if (self.info.time_dt > 5) then
		self.info.time_dt = 0
--		self.info.client:send('lol')
		local info = SocketManager:shared():getListenerInfo(self)
		local url = info.url
		self.info.client:emit(url, 'echo')
	end
end

------------------------------------------------------------------------------------------

function StartScreen:getConfigurations()
--	[HTTP GET] - /api/lobby/initial&locale={en_EN} во время сплеш скрина
--    - receive: конфигурационные данные, строки в зависимости от локали и тд
	local method = 'GET'
	local url = 'http://lobby.pokerchipsapp.net:8088/api/lobby/initial?locale=en_EN'
	local async = true
	local request = cc.XMLHttpRequest:new()
	local handler = function()
		local timeout      = tostring(request.timeout)
		local readyState   = tostring(request.readyState)
		local status       = tostring(request.status)
		local statusText   = tostring(request.statusText)
		local response     = tostring(request.response)
		local responseText = tostring(request.responseText)
		print('')
		print('Get Configurations:')
		print('timeout      ' .. timeout)
		print('readyState   ' .. readyState)
		print('status       ' .. status)
		print('statusText   ' .. statusText)
		print('response     ' .. response)
		print('responseText ' .. responseText)
		print('')
		if (request.readyState == 4 and request.status == 200) then
			
		end
	end
	request:registerScriptHandler(handler)
	request:open(method, url, async)
	request:send()
end

function StartScreen:onSuccessFBLogin()
	print('facebook user id      = ' .. facebook.getUserID())
	print('facebook access token = ' .. facebook.getAccessToken())

	self.actions_done_count = 0
	local function goToNextScene()
		if (self.actions_done_count > 1) then
			SceneManager:shared():startScene('IntroduceScreen')
		end
	end

	self:authenticateWithFB(function()
		self.actions_done_count = self.actions_done_count + 1
		goToNextScene()
	end)

	self:downloadFBAvatar(tostring(facebook.getUserID()), function()
		self.actions_done_count = self.actions_done_count + 1
		goToNextScene()
	end)
end

function StartScreen:downloadFBAvatar(id, onEnd)
	if (types.isString(id)) then
		local method = 'GET'
		local url = 'http://graph.facebook.com/' .. id .. '/picture?type=large'
		local async = true
		print('download facebook avatar start: ', method, url)
		local request = cc.XMLHttpRequest:new()
		local handler = function()
			local timeout      = tostring(request.timeout)
			local readyState   = tostring(request.readyState)
			local status       = tostring(request.status)
			local statusText   = tostring(request.statusText)
			local response     = tostring(request.response)
			local responseText = tostring(request.responseText)

			if (request.readyState == 4 and request.status == 200) then
				SaveManager:shared():saveFileData('images','fb_user_image.jpg',request.responseText)
				if (types.isFunction(onEnd)) then
					onEnd()
				end
			end
		end
		request:registerScriptHandler(handler)
		request:open(method, url, async)
		request:send()
	else
		print('wrong id name')
		if (types.isFunction(onEnd)) then
			onEnd()
		end
	end
end

function StartScreen:authenticateWithFB(onEnd)
--	[HTTP POST] - /api/lobby/players/fb с двумя полями в теле запроса (fb_id, access_token)
	local method = 'POST'
	local url = 'http://lobby.pokerchipsapp.net:8088/api/lobby/players/fb'
	local async = true
	local request = cc.XMLHttpRequest:new()
	local handler = function()
		local timeout      = tostring(request.timeout)
		local readyState   = tostring(request.readyState)
		local status       = tostring(request.status)
		local statusText   = tostring(request.statusText)
		local response     = tostring(request.response)
		local responseText = tostring(request.responseText)
		print('')
		print('Authenticate with fb:')
		print('timeout      ' .. timeout)
		print('readyState   ' .. readyState)
		print('status       ' .. status)
		print('statusText   ' .. statusText)
		print('response     ' .. response)
		print('responseText ' .. responseText)
		print('')
		if (request.readyState == 4 and request.status == 200) then
			if (types.isFunction(onEnd)) then
				onEnd()
			end
		end
	end
	request:registerScriptHandler(handler)
	request:open(method, url, async)
	local fb_id = tostring(facebook.getUserID())
	local token = tostring(facebook.getAccessToken())
	request:send('fb_id=' .. fb_id .. '&token=' .. token)
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
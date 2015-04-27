class 'SocketManager' (Manager)

------------------------------------------------------------------------------------------

local DEFAULT_URL = 'http://lobby.pokerchipsapp.net:8088/game'

function SocketManager:getDefaultURL()
	return DEFAULT_URL
end

------------------------------------------------------------------------------------------

function SocketManager:onInit()
	self.info.listeners = {}
end

function SocketManager:testWebSocket()
	local wsSendText = cc.WebSocket:create(DEFAULT_URL)

	local function wsSendTextOpen(strData)
		PRINT('connection open')
	end
	local function wsSendTextMessage(strData)
		PRINT('message: ' .. strData)
	end
	local function wsSendTextClose(strData)
		PRINT('connection close')
	end
	local function wsSendTextError(strData)
		PRINT('error: ' .. strData)
	end

	if nil ~= wsSendText then
		PRINT('created')
		wsSendText:registerScriptHandler(wsSendTextOpen,    cc.WEBSOCKET_OPEN)
		wsSendText:registerScriptHandler(wsSendTextMessage, cc.WEBSOCKET_MESSAGE)
		wsSendText:registerScriptHandler(wsSendTextClose,   cc.WEBSOCKET_CLOSE)
		wsSendText:registerScriptHandler(wsSendTextError,   cc.WEBSOCKET_ERROR)

		wsSendText:sendString('message')
	else
		PRINT('non created')
		assert(wsSendText ~= nil)
	end
end

function SocketManager:testSocketIO()
	local function onOpen()
		print('cc.SIOClient.onOpen')
--		self.info.client:emit("test","test")
	end
	local function onMessage(message)
		print('cc.SIOClient.onMessage: ' .. message)
	end
	local function onClose()
		print('cc.SIOClient.onClose')
	end
	local function onError(err)
		print('cc.SIOClient.onError: ' .. err)
	end

	local client = cc.SIOClient:create()
		  client:registerScriptHandler(onOpen,    cc.WEBSOCKET_OPEN)
		  client:registerScriptHandler(onMessage, cc.WEBSOCKET_MESSAGE)
		  client:registerScriptHandler(onClose,   cc.WEBSOCKET_CLOSE)
		  client:registerScriptHandler(onError,   cc.WEBSOCKET_ERROR)
		  client:connect(DEFAULT_URL)
--		  client:emit('string','args')
--		  client:send('message')

	self.info.client = client
end

function SocketManager:testHttpRequest()
	local method = 'GET'
	local url = 'http://graph.facebook.com/100009389592812/picture?type=large'
	local async = true
	print('http request start = ', method, url)
	local request = cc.XMLHttpRequest:new()
	local handler = function()
		local timeout      = tostring(request.timeout)
		local readyState   = tostring(request.readyState)
		local status       = tostring(request.status)
		local statusText   = tostring(request.statusText)
		local response     = tostring(request.response)
		local responseText = tostring(request.responseText)

		print('http request callback')
		print('    timeout:      ', timeout)
		print('    readyState:   ', readyState)
		print('    status:       ', status)
		print('    statusText:   ', statusText)
		print('    response:     ', response)
		print('    responseText: ', responseText)
		print('    file size:    ', string.len(responseText))
		-- 0 4 200 200 OK \377\330\377\340 \377\330\377\340

		if (request.readyState == 4 and request.status == 200) then
			SaveManager:shared():saveFileData('images','fb_user_image.jpg',request.responseText)
		end
	end
	request:registerScriptHandler(handler)
	request:open(method, url, async)
	request:send()
end

------------------------------------------------------------------------------------------

function SocketManager:addListener(listener, url)
	assert(types.isEntity(listener))

	url = url or DEFAULT_URL
	assert(types.isString(url))

	local function on_open()
		if (types.isFunction(listener.onOpen)) then
			listener:onOpen()
		end
	end
	local function on_message(msg)
		if (types.isFunction(listener.onMessage)) then
			listener:onMessage(msg)
		end
	end
	local function on_close()
		if (types.isFunction(listener.onClose)) then
			listener:onClose()
		end
	end
	local function on_error(err)
		if (types.isFunction(listener.onError)) then
			listener:onError(err)
		end
	end

	local client = cc.SIOClient:create()
		  client:registerScriptHandler(on_open,    cc.WEBSOCKET_OPEN)
		  client:registerScriptHandler(on_message, cc.WEBSOCKET_MESSAGE)
		  client:registerScriptHandler(on_close,   cc.WEBSOCKET_CLOSE)
		  client:registerScriptHandler(on_error,   cc.WEBSOCKET_ERROR)
		  client:connect(url)

	local info = {}
		  info.listener = listener
		  info.client   = client
		  info.url      = url

	self.info.listeners[listener:getID()] = info

	return client
end

function SocketManager:getListenerInfo(listener)
	assert(types.isEntity(listener))
	return self.info.listeners[listener:getID()]
end

function SocketManager:removeListener(listener)
	local info = self.info.listeners[listener:getID()]
	if (info ~= nil) then
		-- need destroy info.client
		info.listener = nil
		info.client = nil
		self.info.listeners[listener:getID()] = nil
	end
end

------------------------------------------------------------------------------------------
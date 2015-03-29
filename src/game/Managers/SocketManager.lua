class 'SocketManager' (Manager)

------------------------------------------------------------------------------------------

local DEFAULT_URL = 'http://lobby.pokerchipsapp.net:8088/game'

------------------------------------------------------------------------------------------

function SocketManager:onInit()
	self.info.listeners = {}
end

function SocketManager:connectWebSocket()
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

		wsSendText:sendString("lol")
	else
		PRINT('non created')
		assert(wsSendText ~= nil)
	end
end

function SocketManager:connectSocketIO()
	local function onOpen()
		print('cc.SIOClient.onOpen')
		self.info.client:emit("test","test")
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

------------------------------------------------------------------------------------------

function SocketManager:addListener(listener, address)
	assert(types.isEntity(listener))

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

	local info = {}
		  info.listener = listener
		  info.client   = client

	self.info.listeners[listener:getID()] = info
end

function SocketManager:removeListener(listener)
	local info = self.info.listeners[listener:getID()]
	if (info ~= nil) then
		-- need destroy info.client
		self.info.listeners[listener:getID()] = nil
	end
end

------------------------------------------------------------------------------------------
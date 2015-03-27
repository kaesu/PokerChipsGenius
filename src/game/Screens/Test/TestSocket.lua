class 'EmptyScene' (Screen)

------------------------------------------------------------------------------------------

function EmptyScene:onInit()
	self.entities.btn_socket:setOnClick(function() self:startSocket() end)
end

function EmptyScene:startSocket()
	PRINT("start socket")

--	local wsSendText = cc.WebSocket:create("wss://chat.socket.io/")
	local wsSendText = cc.WebSocket:create("wss://lobby.pokerchipsgenius.com:8088/game")

	local function wsSendTextOpen(strData)
		PRINT('connection open')
	end
	local function wsSendTextMessage(strData)
		PRINT('message: ')
		if (types.isString(strData)) then
			PRINT(strData)
		end
	end
	local function wsSendTextClose(strData)
		PRINT('connection close')
	end
	local function wsSendTextError(strData)
		PRINT('error: ')
		if (types.isString(strData)) then
			PRINT(strData)
		end
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

function EmptyScene:makeContent()
	local table = {
		{ entity = 'sprite', key = 'btn_socket', x = 1136/2, y = 640/2, w = 100, h = 100, color = 'blue', },
	}
	return table
end

------------------------------------------------------------------------------------------
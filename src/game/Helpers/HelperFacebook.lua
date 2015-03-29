assert(facebook == nil)
facebook = {
	login = function(onEnd)
		assert(types.isFunction(onEnd))
		if (plugin ~= nil) then
			plugin.FacebookAgent:getInstance():login(onEnd)
		end
	end,
	isLoggedIn = function()
		if (plugin ~= nil) then
			return plugin.FacebookAgent:getInstance():isLoggedIn()
		end
		return nil
	end,
	getUserID = function()
		if (plugin ~= nil) then
			return plugin.FacebookAgent:getInstance():getUserID()
		end
		return nil
	end,
	getAccessToken = function()
		if (plugin ~= nil) then
			return plugin.FacebookAgent:getInstance():getAccessToken()
		end
		return nil
	end,
}

-- FACEBOOK API:
--[[

-- MAIN

plugin.FacebookAgent:getInstance()
plugin.FacebookAgent:destroyInstance()

-- LOGIN

local func = function(ret, msg) end)
local permissions = "create_event,create_note,manage_pages,publish_actions,user_about_me"

plugin.FacebookAgent:getInstance():isLoggedIn()
plugin.FacebookAgent:getInstance():login(func)
plugin.FacebookAgent:getInstance():login(permissions, func)
plugin.FacebookAgent:getInstance():logout()

-- APP REQUEST

local params = { message = "Cocos2dx-lua is a great game engine", title   = "Cocos2dx-lua title", }
plugin.FacebookAgent:getInstance():appRequest(params, function(ret, msg) end)

plugin.FacebookAgent:getInstance():activateApp()

-- USER ID, ACCESS TOKEN

plugin.FacebookAgent::getInstance():getUserID()
plugin.FacebookAgent:getInstance():getAccessToken()

-- LOG PURCHASE

local mount = 1.23
local currency = "CNY"
local fbInfo = {}
fbInfo["fb_currency"] = "CNY"
plugin.FacebookAgent:getInstance():logPurchase(mount, currency, fbInfo)

-- LOG EVENT

local floatVal = 888.888
local fbInfo = {}
fbInfo[plugin.FacebookAgent.AppEventParam.SUCCESS] = plugin.FacebookAgent.AppEventParamValue.VALUE_YES
plugin.FacebookAgent:getInstance():logEvent(plugin.FacebookAgent.AppEvent.COMPLETED_TUTORIAL, floatVal)
plugin.FacebookAgent:getInstance():logEvent(plugin.FacebookAgent.AppEvent.COMPLETED_TUTORIAL, fbInfo)
plugin.FacebookAgent:getInstance():logEvent(plugin.FacebookAgent.AppEvent.COMPLETED_TUTORIAL, floatVal, fbInfo)

-- DIALOGS

local params = {
	dialog = "share_link",
	link   = "http://www.cocos2d-x.org",
}
local params = {
	dialog = "share_photo",
	photo  = imgPath,
}
local params = {
	dialog = "feed_dialog",
	link   = "http://www.cocos2d-x.org",
}
local params = {
	dialog = "share_link",
	link   = "http://www.cocos2d-x.org",
}
local params = {
	dialog = "message_photo",
	photo  = imgPath,
}
local params = {
	dialog = "share_open_graph",
	action_type = "cocostestmyfc:share",
	preview_property_name =  "cocos_document",
	title = "Cocos2dx-lua Game Engine",
	image =  "http://files.cocos2d-x.org/images/orgsite/logo.png",
	url = "http://cocos2d-x.org/docs/catalog/en",
	description = "cocos document",
}
local params = {
	dialog = "message_link",
	description =  "Cocos2dx-lua is a great game engine",
	title = "Cocos2dx-lua",
	link = "http://www.cocos2d-x.org",
	imageUrl = "http://files.cocos2d-x.org/images/orgsite/logo.png",
}
local params = {
	dialog = "message_open_graph",
	action_type = "cocostestmyfc:share",
	preview_property_name = "cocos_document",
	title =  "Cocos2dx-lua Game Engine",
	image = "http://files.cocos2d-x.org/images/orgsite/logo.png",
	url =  "http://cocos2d-x.org/docs/catalog/en",
	description =  "cocos document",
}
plugin.FacebookAgent:getInstance():canPresentDialogWithParams(params)
plugin.FacebookAgent:getInstance():dialog(params, function(ret, msg) end)
]]
class 'SceneManager' (Manager)

------------------------------------------------------------------------------------------

function SceneManager:onInit()
	self.info.scene_register = {}

	self.info.main_scene     = nil -- cocos entity with cc.Scene type
	self.info.main_entity    = nil -- main entity to add screens on and get responder
	self.info.current_scene  = nil -- current scene
	self.info.loaded_screens = {}  -- loaded screens
	self.info.loaded_windows = {}  -- loaded windows

	self:registerScreens()

	self:runEmptyScene()
end

------------------------------------------------------------------------------------------

function SceneManager:runEmptyScene()
	self.info.main_scene = HelperCocos.createSceneEntity()
	self.info.main_scene:setName('main_scene')

	self.info.layer_touchable = Layer()
	self.info.layer_touchable:setName('layer_touchable')
	self.info.main_scene:addChild(self.info.layer_touchable:getCocosEntity(), -1)
	TouchManager:shared():registerTouchableLayer(self.info.layer_touchable)

	self.info.main_entity = Sprite()
	self.info.main_scene:addChild(self.info.main_entity:getCocosEntity(), 0)

	if not cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():runWithScene(self.info.main_scene)
	end
end

------------------------------------------------------------------------------------------

function SceneManager:getMainEntity()
	return self.info.main_entity
end

------------------------------------------------------------------------------------------

function SceneManager:registerScreenInfo(name, path, orientationType)
	assert(types.isString(name))
	assert(types.isString(path))
	orientationType = orientationType or 'none'
	assert(types.isString(orientationType))
	self.info.scene_register[name] = { name = name, path = path, orientationType = orientationType }
end

function SceneManager:getScreenInfo(name)
	assert(types.isString(name) and string.len(name) > 0)
	assert(self.info.scene_register ~= nil)

	if (self.info.scene_register[name] == nil) then
		WARNING('SceneManager:getScreenInfo', 'is not exist screen info with name {' .. name .. '}')
	end

	assert(self.info.scene_register[name] ~= nil)
	return self.info.scene_register[name]
end

------------------------------------------------------------------------------------------

function SceneManager:registerScreens()
	self:registerScreenInfo('DebugScreen',          'game/Screens/Debug/DebugScreen', 'none')

	self:registerScreenInfo('MenuScreen',           'game/Screens/Menu/GUI/MenuScreen',          'none')

	self:registerScreenInfo('AvatarScreen',         'game/Screens/Menu/AvatarScreen',            'Portrait')
	self:registerScreenInfo('CreateGameScreen',     'game/Screens/Menu/CreateGameScreen',        'Portrait')
	self:registerScreenInfo('CreateGameScreen2',    'game/Screens/Menu/CreateGameScreen2',       'Portrait')
	self:registerScreenInfo('CreateGameScreen3',    'game/Screens/Menu/CreateGameScreen3',       'Portrait')
	self:registerScreenInfo('ForgotPasswordScreen', 'game/Screens/Menu/ForgotPasswordScreen',    'Portrait')
	self:registerScreenInfo('IntroduceScreen',      'game/Screens/Menu/IntroduceScreen',         'Portrait')
	self:registerScreenInfo('JoinGameScreen',       'game/Screens/Menu/JoinGameScreen',          'Portrait')
	self:registerScreenInfo('JoinWithEmailScreen1', 'game/Screens/Menu/JoinWithEmailScreen1',    'Portrait')
	self:registerScreenInfo('JoinWithEmailScreen2', 'game/Screens/Menu/JoinWithEmailScreen2',    'Portrait')
	self:registerScreenInfo('LoginWithEmailScreen', 'game/Screens/Menu/LoginWithEmailScreen',    'Portrait')
	self:registerScreenInfo('MainMenuScreen',       'game/Screens/Menu/MainMenuScreen',          'Portrait')
	self:registerScreenInfo('StartScreen',          'game/Screens/Menu/StartScreen',             'Portrait')
	self:registerScreenInfo('TermScreen',           'game/Screens/Menu/TermScreen',              'Portrait')

	self:registerScreenInfo('GameScreen',           'game/Screens/Game/GameScreen',              'Landscape')
	self:registerScreenInfo('GameBetScreen',        'game/Screens/Game/Screens/GameBetScreen',   'none')
	self:registerScreenInfo('GameTableScreen',      'game/Screens/Game/Screens/GameTableScreen', 'none')

	self:registerScreenInfo('ModalInfoScreen',             'game/Screens/Menu/Modal/ModalInfoScreen',             'none')
	self:registerScreenInfo('ModalSettingsGameTypeScreen', 'game/Screens/Menu/Modal/ModalSettingsGameTypeScreen', 'none')
	self:registerScreenInfo('ModalSettingsRebuysScreen',   'game/Screens/Menu/Modal/ModalSettingsRebuysScreen',   'none')
	self:registerScreenInfo('ModalSettingsPayoutsScreen',  'game/Screens/Menu/Modal/ModalSettingsPayoutsScreen',  'none')
end

--function SceneManager:registerScreens()
--	local mainPath = cc.FileUtils:getInstance():fullPathForFilename('src/game/Init.lua')
--	local screensDirectory = removeLastPathComponent(mainPath) .. 'Screens/'
--
--	local function recursiveFindLua(path, relativePath)
--		local names = scandir(path)
--		for i,name in pairs(names) do
--			local curPath = path .. name
--			if (isDirectoryName(name)) then
--				recursiveFindLua(curPath .. '/', relativePath .. name .. '/')
--			elseif (isFileName(curPath)) then
--				if (getPathExtension(curPath) == '.lua') then
--					self:registerScreenInfo(removeExtension(name), relativePath .. name, 'none')
--				end
--			end
--		end
--	end
--
--	recursiveFindLua(screensDirectory, 'game/Screens/')
--end

------------------------------------------------------------------------------------------

function SceneManager:getScreenNamed(name)
	assert(self.info.loaded_screens[name] ~= nil)
	return self.info.loaded_screens[name]
end

function SceneManager:isLoadedScreen(name)
	return (self.info.loaded_screens[name] ~= nil)
end

function SceneManager:requireScreen(name, order)
	assert(types.isString(name))
	assert(types.isNumber(order))
	if (self:isLoadedScreen(name) ~= true) then
		local screen = self:createScreen(name)
		screen:init()
		screen:setOrder(order)
		self.info.main_entity:addChild(screen, order)
		self.info.loaded_screens[name] = screen
	end
end

function SceneManager:destroyScreen(name)
	if (self:isLoadedScreen(name) == true) then
		local screen = self:getScreenNamed(name)
		screen:destroy()
		self.info.main_entity:removeChild(screen)
		self.info.loaded_screens[name] = nil
	end
end

function SceneManager:updateScreens()
	for i, screen in pairs(self.info.loaded_screens) do
		screen:onScreenSizeChanged()
	end
end

function SceneManager:showScreen(name, order)
	self:requireScreen(name, order)
	self:getScreenNamed(name):show()
end

function SceneManager:hideScreen(name)
	if (self:isLoadedScreen(name)) then
		self:getScreenNamed(name):hide()
	end
end

function SceneManager:createScreen(name)
	local screen_info = self:getScreenInfo(name)
	assert(screen_info)
	assert(screen_info.path)
	assert(screen_info.name)

	require(screen_info.path)
	assert(types.isString(screen_info.name))
	local new_screen = CallFunctionByName(screen_info.name, screen_info.name)
	return new_screen
end

------------------------------------------------------------------------------------------

function SceneManager:onInterfaceOrientationWillChange()
end

function SceneManager:onInterfaceOrientationDidChanged()
	self:updateScreens()
--	SaveManager:shared():saveData()
end

------------------------------------------------------------------------------------------

function SceneManager:getCurrentScene()
	assert(self.info.current_scene ~= nil)
	return self.info.current_scene
end

function SceneManager:isCurrentScene()
	return (self.info.current_scene ~= nil)
end

function SceneManager:startScene(name)
--	PRINT(collectgarbage("count"))
	collectgarbage("collect")
--	PRINT(collectgarbage("count"))
	collectgarbage("collect")
--	PRINT(collectgarbage("count"))

	assert(types.isString(name))
	assert(self:getScreenInfo(name) ~= nil)

	local function StartSceneOnUpdate()
		local orientationType = self:getScreenInfo(name).orientationType
		if (orientationType == 'Landscape') then
			print('setPreferredInterfaceOrientation: landscape')
			cc.Director:getInstance():setPreferredInterfaceOrientation(cc.INTERFACEORIENTATION_LANDSCAPE)
		elseif (orientationType == 'Portrait') then
			print('setPreferredInterfaceOrientation: portrait')
			cc.Director:getInstance():setPreferredInterfaceOrientation(cc.INTERFACEORIENTATION_PORTRAIT)
		end

		self.info.current_scene = self:createScreen(name)
--		self.info.current_scene:setVisible(false)
--		self.info.current_scene:setOpacity(0)
--		self.info.current_scene:setRespondable(false)
--		self.info.current_scene:show(0.3)

		Managers.onSceneLoaded(self.info.current_scene)
		self.info.current_scene:init()
		self.info.main_entity:addChild(self.info.current_scene, 0)

		self:updateScreens()
		self.info.main_entity:logChildren()
	end

	if (self.info.current_scene ~= nil) then
--		self.info.current_scene:hide(0.3)
		Managers.onSceneBeginDestroy(self.info.current_scene)
		self.info.current_scene:destroy()
		self.info.main_entity:removeChild(self.info.current_scene)

		StartSceneOnUpdate()

--		Timer.deleteRef(self.timer_start_scene)
--		self.timer_start_scene = Timer.create(0.3, StartSceneOnUpdate)
--		self.timer_start_scene.name = 'timer start scene'
	else
		StartSceneOnUpdate()
	end
end

------------------------------------------------------------------------------------------
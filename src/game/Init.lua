require 'game/Helpers/Helpers'
require 'game/Constants'
require 'game/Base/Base'
require 'game/Entities/Entities'
require 'game/Managers/Managers'

require 'game/Text/Strings'

function init()
	initLUA()
	initGL()

	Random.init()
	Managers.init()

--	PRINT("writable path: ", cc.FileUtils:getInstance():getWritablePath());

	initScene()
end

function initScene()
	SceneManager:shared():requireScreen('DebugScreen', 1000)
	SceneManager:shared():requireScreen('MenuScreen',  5)

	if (facebook.isLoggedIn() == true) then
		SceneManager:shared():startScene('MainMenuScreen')
	else
		SceneManager:shared():startScene('StartScreen')
	end

--	SceneManager:shared():startScene('StartScreen')
--	SceneManager:shared():startScene('CreateGameScreen')
--	SceneManager:shared():startScene('JoinGameScreen')
--	SceneManager:shared():startScene('MainMenuScreen')
--	SceneManager:shared():startScene('GameScreen')

--	SceneManager:shared():startScene('TestInterfaceOrientation')
--	SceneManager:shared():startScene('TestMenuElements')
--	SceneManager:shared():startScene('TestOkCancelWindow')
--	SceneManager:shared():startScene('TestSocket')
--	SceneManager:shared():startScene('TestWebView')
end

function onInterfaceOrientationWillChange()
	SceneManager:shared():onInterfaceOrientationWillChange()
end

function onInterfaceOrientationDidChanged()
	SceneManager:shared():onInterfaceOrientationDidChanged()
end

function startScene(name)
	SceneManager:shared():startScene(name)
end

function initLUA()
	collectgarbage("collect")
	-- avoid memory leak
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)
end

function initGL()
	-- initialize director
	local director = cc.Director:getInstance()
	local glview = director:getOpenGLView()
	if nil == glview then -- DESKTOP
--	OS X: screen size autochange in Application::setPreferredInterfaceOrientation
		glview = cc.GLViewImpl:createWithRect("Poker Chips Genius", cc.rect(0,0,1136,640))
		director:setOpenGLView(glview)
	end
--	glview:setDesignResolutionSize(world_w, world_h, cc.ResolutionPolicy.NO_BORDER)

	PRINT(director:getWinSize().width, director:getWinSize().height)

	--turn on display FPS
	director:setDisplayStats(true)

	--set FPS. the default value is 1.0/60 if you don't call this
--	director:setAnimationInterval(1.0 / 60)
end
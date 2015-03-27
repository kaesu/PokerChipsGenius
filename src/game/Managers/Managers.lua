require 'game/Managers/DragManager'
require 'game/Managers/EntityManager'
require 'game/Managers/MoneyManager'
require 'game/Managers/MusicManager'
require 'game/Managers/RespondManager'
require 'game/Managers/SaveManager'
require 'game/Managers/SceneManager'
require 'game/Managers/SocketManager'
require 'game/Managers/TimeManager'
require 'game/Managers/TouchManager'
require 'game/Managers/UndoManager'

Managers = {
	init = function()
		DragManager:shared()
		EntityManager:shared()
		MoneyManager:shared()
		MusicManager:shared()
		RespondManager:shared()
		SaveManager:shared()
		SceneManager:shared()
		SocketManager:shared()
		TimeManager:shared()
		TouchManager:shared()
		UndoManager:shared()
	end,
	onSceneLoaded = function(scene)
		DragManager:shared():registerCurrentScene(scene)
		EntityManager:shared():registerCurrentScene(scene)
		MoneyManager:shared():registerCurrentScene(scene)
		MusicManager:shared():registerCurrentScene(scene)
		RespondManager:shared():registerCurrentScene(scene)
		SaveManager:shared():registerCurrentScene(scene)
		SceneManager:shared():registerCurrentScene(scene)
		SocketManager:shared():registerCurrentScene(scene)
		TimeManager:shared():registerCurrentScene(scene)
		TouchManager:shared():registerCurrentScene(scene)
		UndoManager:shared():registerCurrentScene(scene)
	end,
	onSceneBeginDestroy = function(scene)
		DragManager:shared():unregisterCurrentScene(scene)
		EntityManager:shared():unregisterCurrentScene(scene)
		MoneyManager:shared():unregisterCurrentScene(scene)
		MusicManager:shared():unregisterCurrentScene(scene)
		RespondManager:shared():unregisterCurrentScene(scene)
		SaveManager:shared():unregisterCurrentScene(scene)
		SceneManager:shared():unregisterCurrentScene(scene)
		SocketManager:shared():unregisterCurrentScene(scene)
		TimeManager:shared():unregisterCurrentScene(scene)
		TouchManager:shared():unregisterCurrentScene(scene)
		UndoManager:shared():unregisterCurrentScene(scene)
	end, 
}
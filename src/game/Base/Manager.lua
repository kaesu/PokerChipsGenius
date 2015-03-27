class 'Manager' (Shared)

------------------------------------------------------------------------------------------

function Manager:shared()
	local name = self.__cname
	assert(name ~= Manager.__cname)

	return Shared.shared(self)
end

function Manager:__init()
	self.info = {}

	self:onInit()
end

------------------------------------------------------------------------------------------

function Manager:registerCurrentScene(scene)
	assert(types.isScreen(scene))
	assert(self.current_scene == nil)

	self.current_scene = scene

	self:onSceneRegistered()
end

function Manager:unregisterCurrentScene(scene)
	assert(types.isScreen(scene))
	assert(self.current_scene == scene)

	self.current_scene = nil

	self:onSceneUnregistered()
	self:clear()
end

------------------------------------------------------------------------------------------

function Manager:clear()
	if (types.isFunction(self.onClear)) then
		self:onClear()
	end
	self.info = nil
end

------------------------------------------------------------------------------------------
------                                    virtual                                   ------
------------------------------------------------------------------------------------------

function Manager:onInit()
end -- "virtual"

function Manager:onSceneRegistered()
end -- "virtual"

function Manager:onSceneUnregistered()
end -- "virtual"

------------------------------------------------------------------------------------------
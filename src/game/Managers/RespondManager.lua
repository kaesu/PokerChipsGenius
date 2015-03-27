class 'RespondManager' (Manager)

------------------------------------------------------------------------------------------

function RespondManager:onInit()
end

function RespondManager:onSceneRegistered()
	self.info.families = {}
	self.info.entities = {}
end

function RespondManager:onSceneUnregistered()
end

------------------------------------------------------------------------------------------

function RespondManager:addRespondingFamily(entities)
	assert(types.isEntity(entities) or types.isTable(entities))

	if (types.isEntity(entities)) then
		local entity = entities
		local name   = entity:getName()
		assert(self.info.entities[name] == nil)

		local index = table.size(self.info.families) + 1
		local objects = {}
		objects[name] = entity
		self.info.families[index] = { locks_count = 0, objects = objects }
		self.info.entities[name] = { family_index = index, name = name, entity = entity, last_respondable = entity:isRespondable(), }
	elseif (types.isTable(entities)) then
		local index = table.size(self.info.families) + 1
		local objects = {}
		for i, entity in pairs(entities) do
			assert(types.isEntity(entity))
			local name = entity:getName()
			assert(self.info.entities[name] == nil)
			objects[name] = entity
			self.info.entities[name] = { family_index = index, name = name, entity = entity, last_respondable = entity:isRespondable(), }
		end
		self.info.families[index] = { locks_count = 0, objects = objects }
	end
end

function RespondManager:lock(name)
	assert(types.isString(name))
	if (self.info.entities[name] == nil) then
		table.log(self.info.entities)
		WARNING('RespondManager:lock', 'is not exist respond entity with key {' .. name .. '}')
	end
	assert(self.info.entities[name] ~= nil)
	local family = self.info.families[self.info.entities[name].family_index]
	family.locks_count = family.locks_count + 1
	if (family.locks_count == 1) then
		for key, info in pairs(self.info.entities) do
			if (family.objects[key] == nil) then
				info.last_respondable = info.entity:isRespondable()
				info.entity:setRespondable(false)
			end
		end
	end
end

function RespondManager:unlock(name)
	assert(types.isString(name))
	assert(self.info.entities[name] ~= nil)
	local family = self.info.families[self.info.entities[name].family_index]
	family.locks_count = family.locks_count - 1
	assert(family.locks_count >= 0)
	if (family.locks_count == 0) then
		for key, info in pairs(self.info.entities) do
			if (family.objects[key] == nil) then
				if (info.last_respondable == true) then
					info.entity:setRespondable(true)
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function class(classname)
	local function defaults(cls)
		cls.new = function(self, ...)
			local self = cls.__factory()
			self:__init(...)
			self.class = cls
			return self
		end
		cls.__cname = classname
		cls.__index = cls
		cls.__factory = function()
			local self = {}
			setmetatable(self, cls)
			return self
		end
		cls.__init = function() end
		cls.__tostring = function()
			return classname
		end
		cls.__inherits = function(str)
			assert(types.isString(str))
			return cls.__cname == str or (cls.super and cls.super.__inherits(str))
		end
		local function call(self, ...)
			return cls:new(...)
		end
		setmetatable(cls, {__call = call })
		_G[classname] = cls
	end

	local cls = {}
	defaults(cls)

	return function(super)
		assert(types.isTable(super)) -- check includes, super class may being included before of inherit class

		local superType = type(super)

		if superType ~= "function" and superType ~= "table" then
			superType = nil
			super = nil
		end

		if superType == "function" or (super and super.__ctype == 1) then
			assert(false)

			-- inherited from native C++ Object
			if superType == "table" then
				-- copy fields from super
				for k,v in pairs(super) do cls[k] = v end
				cls.__create = super.__create
				cls.super    = super
			else
				cls.__create = super
			end

			cls.__ctype = 1

			cls.new = function(self, ...)
				local instance = cls.__create(self, ...)
				-- copy fields from class to native object
				for k,v in pairs(cls) do instance[k] = v end
				instance.class = cls
				instance:__init(...)
				return instance
			end
		else
			-- inherited from Lua Object
			if super then
				cls = clone(super)
				cls.super = super
			end
			defaults(cls)
			if super then
				cls.__init = function(self, ...)
					cls.super.__init(cls, ...)
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------

function CallFunctionByName(functionName, ...)
	local getSubObject = function(object, subObjectName)
		object = object or _G
		return object[subObjectName]
	end

	local obj = nil

	for name in string.gmatch(functionName, '[_%a][_%w]*') do
		obj = getSubObject(obj, name)
	end

	assert((type(obj) == 'function' or getmetatable(obj).__call ~= nil) and "Specified object can't be invoked !")

	return obj(...)
end

------------------------------------------------------------------------------------------

function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

------------------------------------------------------------------------------------------

function lua_garbage_collector()
	collectgarbage("collect")
	collectgarbage("collect")
end

------------------------------------------------------------------------------------------
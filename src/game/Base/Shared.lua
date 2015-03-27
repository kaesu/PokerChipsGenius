class 'Shared'

------------------------------------------------------------------------------------------

function Shared:shared()
	local name = self.__cname

	assert(name ~= 'Shared')

	if (self[name] == nil) then
		self[name] = CallFunctionByName(name)
	end

	return self[name]
end

------------------------------------------------------------------------------------------
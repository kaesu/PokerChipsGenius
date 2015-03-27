assert(WARNING == nil)
assert(ERROR == nil)

local DEBUG_MODE  = true
local DEBUG_LEVEL = 1

Debug = {}

if (DEBUG_MODE == true) then
WARNING = function(...)
	local s = ''
	for k,v in pairs({...}) do
		s = s .. ' ' .. tostring(v)
	end
	print('WARNING:' .. s)
end
ERROR = function(...)
	local s = ''
	for k,v in pairs({...}) do
		s = s .. ' ' .. tostring(v)
	end
	print('ERROR:' .. s)
	assert(false)
end
PRINT = function(...)
	print(...)
end
else
WARNING = function()
end
ERROR = function()
end
PRINT = function()
end
end

function print_args(...)
	PRINT('--------------------------------==>')
	local args = {...}
	if (table.size(args) > 0) then
		for k,v in pairs(args) do
			PRINT(k .. ' ' .. type(v) .. ' {' .. tostring(v) .. '}')
		end
	else
		PRINT('args is nil')
	end
	PRINT('--------------------------------<==')
end
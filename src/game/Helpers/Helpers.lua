require 'game/Helpers/HelperClass' -- check, this must be a first include

require 'game/Helpers/HelperCocos'
require 'game/Helpers/HelperColor'
require 'game/Helpers/HelperCoordinates'
require 'game/Helpers/HelperDebug'
require 'game/Helpers/HelperFacebook'
require 'game/Helpers/HelperFormat'
require 'game/Helpers/HelperMath'
require 'game/Helpers/HelperPlatform'
require 'game/Helpers/HelperTable'
require 'game/Helpers/HelperTimer'
require 'game/Helpers/HelperTouch'
require 'game/Helpers/HelperType'

function GET_STRING(str)
	return _G[str]
end


-- Lua implementation of PHP scandir function
function scandir(directory)
	assert(types.isString(directory))
	print('scandir ' .. directory)
    local i = 0
    local t = {}
    local popen = io.popen

    for filename in popen('ls -a "'..directory..'"'):lines() do
        i = i + 1
        t[i] = filename
    end
    return t
end

function lastPathComponent(str)
	local m = string.match(str, '[%l%u%d]+[%.]?[%l%u%d]+$')
	return m
end

function removeLastPathComponent(str)
	assert(types.isString(str))
	local pathComponent = lastPathComponent(str)
	if (pathComponent ~= nil) then
		local len = string.len(pathComponent)
		return string.sub(str, 1, string.len(str)-len)
	end
	return str
--	local m = string.match(str, '[%l%u%d]+%.[%l%u%d]+$')
--	if (m ~= nil) then
--		local len = string.len(m)
--		return string.sub(str, 1, string.len(str)-len)
--	end
--	assert(false)
--	return str
end

function removeExtension(str)
	local ext = getPathExtension(str)
	if (ext ~= nil) then
		return string.sub(str, 1, string.len(str) - string.len(ext))
	end
	return str
end

function getPathExtension(str)
	assert(types.isString(str))
	local m = string.match(str, '%.[%l%u%d]+$')
	return m
end

function isDirectoryName(str)
	local pc = lastPathComponent(str)
	if (pc ~= nil) then
		return (string.match(pc, '%.') == nil)
	end
	return nil
end

function isFileName(str)
	return getPathExtension(str) ~= nil
end

assert(lastPathComponent('lol/kek/omg') == 'omg')
assert(lastPathComponent('lol/kek/omg.wtf') == 'omg.wtf')
assert(getPathExtension('omg.wtf') == '.wtf')
assert(getPathExtension('lol/kek/omg.wtf') == '.wtf')
assert(isDirectoryName('kek') == true)
assert(isFileName('.') ~= true)
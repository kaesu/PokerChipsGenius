class 'SaveManager' (Manager)

------------------------------------------------------------------------------------------

function file_utils_using()

-- cc.FileUtils:getInstance()

--	setFilenameLookupDictionary
--	setSearchPaths
--	addSearchPath
--	getSearchPaths
--	setSearchResolutionsOrder
--	addSearchResolutionsOrder
--	getSearchResolutionsOrder

--	fullPathFromRelativeFile
--	fullPathForFilename
--	isAbsolutePath
--	loadFilenameLookup

--	getStringFromFile
--	getValueVectorFromFile
--	getValueMapFromFile
--	getValueMapFromData
--	getFileSize

--	isFileExist
--	isDirectoryExist

--	getWritablePath

--	createDirectory
--	removeDirectory

--	writeToFile
--	writeStringToFile
--	renameFile
--	removeFile

--	isPopupNotify
--	setPopupNotify

--	purgeCachedEntries

end

------------------------------------------------------------------------------------------

function SaveManager:onInit()
	if (not self:loadData()) then
		self:loadDefaults()
	end
end

------------------------------------------------------------------------------------------

function SaveManager:loadDefaults()
	if (self.info.data == nil) then
		self.info.data = {}
	end
end

------------------------------------------------------------------------------------------

function SaveManager:loadData()
	local filepath = self:getSavingsFilePath()
	local exist = cc.FileUtils:getInstance():isFileExist(filepath)
	print('SaveManager:loadData() exist = ' .. tostring(exist))
	print(filepath)

	if (exist == true) then
		self.info.data = {}

		local str = cc.FileUtils:getInstance():getStringFromFile(filepath)
		for line in str:gmatch("[^\n]+") do
			print(line)
			local c = string.find(line,'=')
			local char_1 = string.sub(line,string.len(line)-1,string.len(line)-1)
			local char_2 = string.sub(line,string.len(line),string.len(line))
			if (types.isNumber(c) and char_1 == '"' and char_2 == ';') then
				local key   = string.sub(line, 1, c-1)
				local value = string.sub(line, c+2, string.len(line)-2)
				value = string.gsub(value, '\\"', '"')
				value = string.gsub(value, '\\n', '\n')
				self.info.data[key] = value
			elseif (string.len(line) == 0) then
			else
				WARNING('SaveManager:loadData', 'Occured error format in file, restoring defaults.')
				print(line, string.len(line))
				self.info.data = nil
				return false
			end
		end

--		DOES THE SAME THING
--		local t = cc.FileUtils:getInstance():getValueMapFromFile(filepath)
--		for i,k in pairs(t) do
--			assert(types.isString(i))
--			assert(types.isString(k))
--			self.info.data[i] = k
--		end

		return true
	end

	return false
end

function SaveManager:saveData()
	self:checkDirectory()

	local str = ''
	for key,value in pairs(self.info.data) do
		value = string.gsub(value, '"', '\\"')
		value = string.gsub(value, '\n', '\\n')
		str = str .. key .. '="' .. value .. '";\n'
	end

	str = string.sub(str,1,string.len(str)-1)

	local filepath = self:getSavingsFilePath()
	local saved = cc.FileUtils:getInstance():writeStringToFile(str, filepath)
	print('SaveManager:saveData() saved = ' .. tostring(saved))
end

------------------------------------------------------------------------------------------

function SaveManager:checkDirectory()
	local directoryPath = self:getSavingsDirectoryPath()
	if (false == cc.FileUtils:getInstance():isDirectoryExist(directoryPath)) then
		cc.FileUtils:getInstance():createDirectory(directoryPath)
	end
end

function SaveManager:getSavingsDirectoryName()
	return 'PokerChipsGeniusCache/'
end

function SaveManager:getSavingsDirectoryPath()
	return cc.FileUtils:getInstance():getWritablePath() .. self:getSavingsDirectoryName()
end

function SaveManager:getSavingsFileName()
	return 'savings.txt'
end

function SaveManager:getSavingsFilePath()
	return self:getSavingsDirectoryPath() .. self:getSavingsFileName()
end

------------------------------------------------------------------------------------------

function SaveManager:checkTag(tag)
	if (types.isString(tag)) then
		local str = string.match(tag, '[%a%d]+')
		return (string.len(tag) == string.len(str))
	end
	return nil
end

------------------------------------------------------------------------------------------

function SaveManager:getData(tag, domain)
	assert(types.isString(tag))
	assert(domain == nil or types.isString(tag))

	return self.info.data[tag]
end

function SaveManager:setData(tag, data, domain)
	assert(types.isString(tag))
	assert(domain == nil or types.isString(tag))
	assert(self:checkTag(tag))

	if (data == nil or data == '') then
		if (self.info.data[tag] ~= nil) then
			self.info.data[tag] = nil
		end
	else
		assert(types.isString(data) or types.isNumber(data) or types.isBoolean(data))
		self.info.data[tag] = tostring(data)
	end
end

function SaveManager:removeData(tag, domain)
	self:setData(tag, nil, domain)
end

------------------------------------------------------------------------------------------

function SaveManager:getBoolean(tag, domain)
	return convert.toBoolean(self:getData(tag, domain))
end

function SaveManager:getNumber(tag, domain)
	return convert.toFloat(self:getData(tag, domain))
end

function SaveManager:getString(tag, domain)
    local data = self:getData(tag, domain)
    if (data == nil) then
        return ''
    end
	return convert.toString(data)
end

------------------------------------------------------------------------------------------
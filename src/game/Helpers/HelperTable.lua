table.size = function(t)
	assert(types.isTable(t))
	local c = 0
	for k,v in pairs(t) do
		c = c + 1
	end
	return c
end

table.log = function(t, maxDepth, depthLevel, depthStr)
	assert(types.isTable(t))

	depthStr   = (depthStr ~= nil and depthStr) or ''
	maxDepth   = (maxDepth ~= nil and maxDepth) or 0
	depthLevel = (depthLevel ~= nil and depthLevel) or 0

	if (depthLevel == 0) then
		cclog('================================================>')
	end
	for i, k in pairs(t) do
		cclog('%s%-32s%-10s', depthStr, i, k)
		if (types.isTable(k) and (depthLevel < maxDepth)) then
			table.log(k, maxDepth, depthLevel + 1, depthStr .. '  ')
		end
	end
	if (depthLevel == 0) then
		cclog('<================================================')
	end
end

table.copy = function(t)
	assert(types.isTable(t))
	local copied = {}
	for i, k in pairs(t) do
		if (types.isNumber(k) or types.isString(k) or types.isBoolean(k)) then
			copied[i] = k
		elseif (types.isRect(k)) then
			copied[i] = cc.rect(k.x, k.y, k.width, k.height)
		elseif (types.isSize(k)) then
			copied[i] = { width = k.width, height = k.height }
		elseif (types.isPoint(k)) then
			copied[i] = cc.p(k.x, k.y)
		else
			-- unhandle type value
		end
	end
	return copied
end
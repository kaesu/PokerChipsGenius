convert = {
	toFloat = function(value)
		local float = tonumber(value)
		if (types.isNumber(float)) then
			return float
		else
			WARNING('convert.toFloat', 'Could not cast {' .. tostring(value) .. '} to number.')
			assert(false)
		end
		return 0
	end,
	toBoolean = function(value)
		if (value == nil) then
			return false
		elseif (types.isString(value)) then
			return (value == 'true')
		elseif (types.isNumber(value)) then
			return (value ~= 0)
		else
			WARNING('convert.toBoolean', 'Could not cast {' .. tostring(value) .. '} to boolean.')
			assert(false)
		end
		return false
	end,
	toByte = function(value)
		return string.byte(value)
	end,
	toChar = function(value)
		return string.char(value)
	end,
	toNumber = function(value)
		return convert.toFloat(value)
	end,
	toString = function(value)
		return tostring(value)
	end,
	toInteger = function(value)
		return math.floor(convert.toFloat(value))
	end,
	toPriceString = function(value)
		assert(types.isNumber(value))
		local thousands = math.floor(value / 1000)
		local rest = value - (thousands * 1000)
		local strRest = rest .. ''
		if (thousands > 0) then
			if (rest < 10) then
				strRest = '00' .. strRest
			elseif (rest < 100) then
				strRest = '0' .. strRest
			end
		end
		return ((thousands > 0) and (thousands .. ',') or '') .. strRest
	end,
}

assert(convert.toByte('a') == 97)
assert(convert.toChar(97) == 'a')
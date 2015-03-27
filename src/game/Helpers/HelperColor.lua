-- Color Converter from hex to table
-- in:  format string: '#9ab0f2'
-- out: cc.c4f

HelperColor = {
	colorFromString = function(str)
		assert(types.isString(str))
		if (str == 'black') then
			str = COLOR_BLACK
		elseif (str == 'white') then
			str = COLOR_WHITE
		elseif (str == 'yellow') then
			str = COLOR_YELLOW
		elseif (str == 'green') then
			str = COLOR_GREEN
		elseif (str == 'transparent') then
			str = COLOR_WHITE
		elseif (str == 'blue') then
			str = COLOR_BLUE
		elseif (str == 'gray') then
			str = COLOR_GRAY
		elseif (str == 'light_gray') then
			str = COLOR_LIGHT_GRAY
		elseif (str == 'dark_gray') then
			str = COLOR_DARK_GRAY
		elseif (str == 'red') then
			str = COLOR_RED
		end
		assert(types.isString(str))
		if (string.len(str) == 7 and string.sub(str, 0, 1) == '#') then
			return HelperColor.colorFromHex(str)
		else
			WARNING('HelperColor.colorFromString', 'unknown color format: {' .. str .. '}')
			assert(false)
		end
	end,
	colorFromHex = function(hex)
		function hexDigitToNum(letter)
			assert(string.len(letter) == 1)
			if letter == 'a' or letter == 'A' then
				return 10
			elseif letter == 'b' or letter == 'B' then
				return 11
			elseif letter == 'c' or letter == 'C' then
				return 12
			elseif letter == 'd' or letter == 'D' then
				return 13
			elseif letter == 'e' or letter == 'E' then
				return 14
			elseif letter == 'f' or letter == 'F' then
				return 15
			else
				local num = tonumber(letter)
				assert(num)
				return num
			end
		end
		function hexToFloat(word)
			assert(word)
			assert(string.len(word) == 2)

			local l1 = string.sub(word, 1, 1)
			local l2 = string.sub(word, 2, 2)
			return (hexDigitToNum(l1) * 16 + hexDigitToNum(l2))
		end

		assert(string.len(hex) == 7)
		assert(string.sub(hex, 0, 1) == '#')

		local color_r = hexToFloat(string.sub(hex, 2, 3))
		local color_g = hexToFloat(string.sub(hex, 4, 5))
		local color_b = hexToFloat(string.sub(hex, 6, 7))

		return cc.c4b(color_r, color_g, color_b, 255)
	end,
}

assert(COLOR == nil)
COLOR = function(str)
	return HelperColor.colorFromString(str)
end
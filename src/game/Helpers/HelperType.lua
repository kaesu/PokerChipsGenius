types = {
	isNil = function(value)
		return (value == nil)
	end,
	isNumber = function(value)
		return (type(value) == 'number')
	end,
	isString = function(value)
		return (type(value) == 'string')
	end,
	isBoolean = function(value)
		return (type(value) == 'boolean')
	end,
	isTable = function(value)
		return (type(value) == 'table')
	end,
	isFunction = function(value)
		return (type(value) == 'function')
	end,
	isEntity = function(value)
		return (value and types.isFunction(value.__inherits) and value.__inherits('Entity') == true)
	end,
	isControl = function(value)
		return (value and types.isFunction(value.__inherits) and value.__inherits('Control') == true)
	end,
	isScreen = function(value)
		return (value and types.isFunction(value.__inherits) and value.__inherits('Screen') == true)
	end,
	isPoint = function(value)
		return (value and types.isTable(value) and types.isNumber(value.x) and types.isNumber(value.y))
	end,
	isSize = function(value)
		return (value and types.isTable(value) and types.isNumber(value.width) and types.isNumber(value.height))
	end,
	isRect = function(value)
		return (value and types.isTable(value) and types.isPoint(value) and types.isSize(value))
	end,
	isTouch = function(value)
		return (value and types.isTable(value) and types.isNumber(value.id) and types.isPoint(value))
	end,
	isColor = function(value)
		return (value and types.isTable(value) and types.isNumber(value.r) and types.isNumber(value.g) and types.isNumber(value.b))
	end,
}
Random = {
	init = function()
		math.randomseed(os.time())
	end,
	float = function()
		return math.random()
	end,
	boolean = function()
		return (math.random(1,2) == 1) and true or false
	end,
	int = function()
		return Random.float()
	end,
	number = function()
		return Random.float()
	end,
	color = function()
		return { r = Random.float(), g = Random.float(), b = Random.float(), a = 1, }
	end,
}
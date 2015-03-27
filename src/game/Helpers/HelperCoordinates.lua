Point = {
	sum = function(p1, p2)
		assert(types.isPoint(p1))
		assert(types.isPoint(p2))
		return (cc.p(p1.x+p2.x, p1.y+p2.y))
	end,
	subtract = function(p1, p2)
		assert(types.isPoint(p1))
		assert(types.isPoint(p2))
		return (cc.p(p1.x-p2.x, p1.y-p2.y))
	end,
	divide = function(p1, p2)
		assert(types.isPoint(p1))
		assert(types.isPoint(p2))
		assert(p2.x ~= 0)
		assert(p2.y ~= 0)
		return (cc.p(p1.x/p2.x, p1.y/p2.y))
	end,
	multiplicate = function(p1, p2)
		assert(types.isPoint(p1))
		assert(types.isPoint(p2))
		return (cc.p(p1.x*p2.x, p1.y*p2.y))
	end,
	position = function(entity)
		assert(entity)
		assert(types.isFunction(entity.getPositionX))
		assert(types.isFunction(entity.getPositionY))
		return cc.p(entity:getPositionX(), entity:getPositionY())
	end,
	distance = function(p1,p2)
		assert(types.isPoint(p1))
		assert(types.isPoint(p2))
		local d_x = math.abs(p1.x-p2.x)
		local d_y = math.abs(p1.y-p2.y)
		return math.sqrt(d_x * d_x + d_y * d_y)
	end,
}

Line = {
	getClosestPoint = function(A, B, P)
		assert(types.isPoint(A))
		assert(types.isPoint(B))
		assert(types.isPoint(P))

		local a_to_p = { P.x - A.x, P.y - A.y }
		local a_to_b = { B.x - A.x, B.y - A.y }

		local atb2 = a_to_b[1] * a_to_b[1] + a_to_b[2] * a_to_b[2]

		local atp_dot_atb = a_to_p[1] * a_to_b[1] + a_to_p[2] * a_to_b[2]
		local t = atp_dot_atb / atb2

		local R = cc.p(A.x + a_to_b[1] * t, A.y + a_to_b[2] * t)

		if ((R.x < A.x and R.x < B.x) or (R.y < A.y and R.y < B.y) or
			(R.x > A.x and R.x > B.x) or (R.y > A.y and R.y > B.y))
		then
			if (Point.distance(A, P) < Point.distance(B, P)) then
				R = A
			else
				R = B
			end
		end

		return R
	end
}

Rect = {
	getClosestPoint = function(rect, p)
		assert(types.isRect(rect))
		assert(types.isPoint(p))
		local point = p
		if (point.x < rect.x) then
			point.x = rect.x
		elseif (point.x > rect.x + rect.width) then
			point.x = rect.x + rect.width
		end
		if (point.y < rect.y) then
			point.y = rect.y
		elseif (point.y > rect.y + rect.height) then
			point.y = rect.y + rect.height
		end
		return point
	end
}

function GET_SCREEN_WIDTH()
	return cc.Director:getInstance():getWinSize().width
end

function GET_SCREEN_HEIGHT()
	return cc.Director:getInstance():getWinSize().height
end
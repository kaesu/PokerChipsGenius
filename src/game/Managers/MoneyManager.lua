class 'MoneyManager' (Manager)

------------------------------------------------------------------------------------------

function MoneyManager:onInit()
	self.money      = 10500
	self.bet        = 0
	self.call       = 150
	self.chips_cost = { 1000, 500, 100, 25, 5 }
end

function MoneyManager:onSceneRegistered()

end

function MoneyManager:onSceneUnregistered()

end

------------------------------------------------------------------------------------------

function MoneyManager:getTotal()
	return self.money
end

------------------------------------------------------------------------------------------

function MoneyManager:getCall()
	return self.call
end

function MoneyManager:setCall(number)
	assert(types.isNumber(number))
	assert(number > 0)
	self.call = number
end

------------------------------------------------------------------------------------------

function MoneyManager:getBet()
	return self.bet
end

function MoneyManager:betIncrease(number)
	assert(types.isNumber(number))
	assert(number > 0)
	self.bet = self.bet + number
end

function MoneyManager:betDecrease(number)
	assert(types.isNumber(number))
	assert(number > 0)
	self.bet = self.bet - number
end

function MoneyManager:clearBet()
	self.bet = 0
end

------------------------------------------------------------------------------------------

function MoneyManager:getChipCost(index)
	assert(types.isNumber(index))
	assert(index >= 1 and index <= 5)
	return self.chips_cost[index]
end

------------------------------------------------------------------------------------------

function MoneyManager:haveMoney(number)
	assert(types.isNumber(number))
	assert(number > 0)
	return (self.money - self.bet >= number)
end

function MoneyManager:canBet()
	if (self.bet > 0) then
		if (self.bet == self.money) then
			return true, 'ALL IN'
		elseif (self.bet == self.call) then
			return true, 'CALL'
		elseif (self.bet >= self.call * 2) then
			return true, 'RAISE'
		end
	end
	return false
end

function MoneyManager:getMinBet()
	if (self.money > 0) then
		if (self.bet == self.money) then
			return self.bet, 'ALL IN'
		elseif (self.bet < self.call) then
			return self.call, 'CALL'
		else
			return self.call * 2, 'RAISE'
		end
	end
	return 0
end

function MoneyManager:makeBet()
	assert(self:canBet())
	assert(self.money >= self.bet)
	self.money = self.money - self.bet
	self.bet = 0
end

------------------------------------------------------------------------------------------

function MoneyManager:addMoney(number)
	self.money = self.money + number
end

------------------------------------------------------------------------------------------
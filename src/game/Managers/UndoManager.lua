class 'UndoManager' (Manager)

------------------------------------------------------------------------------------------

function UndoManager:onInit()
end

function UndoManager:onSceneRegistered()
	self.info.transactions = {}
end

function UndoManager:onSceneUnregistered()
end

------------------------------------------------------------------------------------------

function UndoManager:addTransaction(info)
	assert(types.isTable(info))
	local size = table.size(self.info.transactions)
	self.info.transactions[size+1] = info
end

function UndoManager:undo()
	assert(self.info.transactions ~= nil)
	local indexLast = table.size(self.info.transactions)
	assert(indexLast > 0)

	local lastTransactionInfo = self.info.transactions[indexLast]
	self.info.transactions[indexLast] = nil

	return lastTransactionInfo
end

function UndoManager:canUndo()
	return (self:getSize() ~= 0)
end

------------------------------------------------------------------------------------------

function UndoManager:getSize()
	return table.size(self.info.transactions)
end

function UndoManager:clear()
	self.info.transactions = {}
end

------------------------------------------------------------------------------------------
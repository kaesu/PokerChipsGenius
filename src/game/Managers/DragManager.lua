class 'DragManager' (Manager)

------------------------------------------------------------------------------------------

function DragManager:onSceneRegistered()
	self.info.drag_entities = {}
end

function DragManager:onSceneUnregistered()
end

------------------------------------------------------------------------------------------

function DragManager:registerDragEntity(entity, drag)
	assert(types.isEntity(entity))
	self.info.drag_entities[entity:getID()] = drag
end

function DragManager:unregisterDragEntity(entity)
	self.info.drag_entities[entity:getID()] = nil
end

------------------------------------------------------------------------------------------

function DragManager:isDraggingEntitiesInTheMoment()
	for i, drag in pairs(self.info.drag_entities) do
		if (drag:isDraggingInTheMoment()) then
			return true
		end
	end
	return false
end

function DragManager:getDragEntityWhoHasChildWithID(id)
	assert(types.isNumber(id))
	for i, drag in pairs(self.info.drag_entities) do
		if (drag:existChildWithID(id) == true) then
			return drag
		end
	end
	return nil
end

------------------------------------------------------------------------------------------
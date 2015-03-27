class 'GameBetScreen' (Screen)

------------------------------------------------------------------------------------------

local PRESENTATION_MODE = true
local TABLE_MAX_COLS_SIZE = 5
local HIDING_COOLDOWN_TIME = 1.0

------------------------------------------------------------------------------------------

function GameBetScreen:onInit()
	self:initLabels()
	self:initButtonUndo()
	self:initMessage()
	self:initSliderFold()
	self:initButtonCheck()
	self:initButtonsAllInAndCall()
	self:initDraggedChips()
	self:initTableChips()
	self:initAllInSliders()

	if (PRESENTATION_MODE == true) then
		self:initButtonGetMoreChipsPresentation()
	end

	self:initRespondManager()
end

------------------------------------------------------------------------------------------

function GameBetScreen:initButtonGetMoreChipsPresentation()
	local button = self.entities.button_get_more_chips
	button:setOnClickBegin(function()
		RespondManager:shared():lock(button:getName())
	end)
	button:setOnClickEnd(function()
		RespondManager:shared():unlock(button:getName())
	end)
	button:setOnClick(function()
		MoneyManager:shared():addMoney(10500)
		button:hide()
		self.draggedChips.checkDisableChips()
		self.labels.update()
		self.buttons.checkEnable()
		self.chipsTable.checkBet()
	end)
end

------------------------------------------------------------------------------------------

function GameBetScreen:initLabels()
	self.labels = {}
	self.labels.update = function()
		self.labels.updateCall()
		self.labels.updateTotal()
	end
	self.labels.updateCall = function()
		local number = MoneyManager:shared():getCall()
		self.entities.text_to_call:setText('TO CALL: ' .. convert.toPriceString(number))
		local contentSize = self.entities.text_to_call:getContentSize()
		self.entities.text_to_call:setPosition(20/1136*GET_SCREEN_WIDTH() + (contentSize.width/2), GET_SCREEN_HEIGHT() - 34/640*GET_SCREEN_HEIGHT())
	end
	self.labels.updateTotal = function()
		local number = MoneyManager:shared():getTotal()
		self.entities.text_your_total:setText('YOUR STACK: ' .. convert.toPriceString(number))
		local contentSize = self.entities.text_your_total:getContentSize()
		self.entities.text_your_total:setPosition(GET_SCREEN_WIDTH() - (contentSize.width/2) - 20/1136*GET_SCREEN_WIDTH(), GET_SCREEN_HEIGHT() - 34/640*GET_SCREEN_HEIGHT())
	end

	self.labels.update()
end

------------------------------------------------------------------------------------------

function GameBetScreen:initButtonUndo()
	self.buttonUndo = self.entities.btn_undo_frame

	local labelTotalWidth = self.entities.text_your_total:getContentSize().width / 2
	local undoWidth       = (142/1136 * GET_SCREEN_WIDTH())
	local x1 = self.entities.text_your_total:getPositionX() - undoWidth
	local x2 = self.entities.text_your_total:getPositionX()
	local y = self.entities.text_your_total:getPositionY()

	self.buttonUndo:setOnEnable(function()
		self.entities.undo_arrow:setOpacity(1)
		self.entities.undo_text:setOpacity(1)
	end)
	self.buttonUndo:setOnDisable(function()
		self.entities.undo_arrow:setOpacity(0.5)
		self.entities.undo_text:setOpacity(0.5)
	end)
	self.buttonUndo:setOnShow(function()
		function onEnd()
			self.entities.undo_layer:show(0.3)
			self.entities.undo_yellow_separator:show(0.3, false)
			self.entities.undo_arrow:show(0.3, false)
			self.entities.undo_text:show(0.3, false)
		end
		self.entities.text_your_total:moveTo(0.3, cc.p(x1, y), onEnd)
	end)
	self.buttonUndo:setOnHide(function()
		local function onEnd()
			self.entities.text_your_total:moveTo(0.3, cc.p(x2, y))
		end
		self.entities.undo_layer:hide(0.3)
		self.entities.undo_yellow_separator:hide(0.3)
		self.entities.undo_arrow:hide(0.3)
		self.entities.undo_text:hide(0.3, onEnd)
	end)
	self.buttonUndo:setOnClickBegin(function(info)
		RespondManager:shared():lock(info.sender:getName())
	end)
	self.buttonUndo:setOnClickEnd(function(info)
		RespondManager:shared():unlock(info.sender:getName())
	end)
	self.buttonUndo:setOnClick(function()
		self.chipsTable.onUndoClick()
		if (UndoManager:shared():canUndo() ~= true) then
			self.buttonUndo:disable()
		end
	end)
end

------------------------------------------------------------------------------------------

function GameBetScreen:initMessage()
	self.message = {}
	self.message.timer_ref = nil
	self.message.show = function(text)
		assert(types.isString(text))

		self.entities.message_text:setString(text)
		self.entities.message_layer:show(0.5, false)
--		self.entities.message_fr_l:show(0.5, false)
--		self.entities.message_fr_r:show(0.5, false)
--		self.entities.message_fr_t:show(0.5, false)
--		self.entities.message_fr_b:show(0.5, false)
		self.entities.message_text:show(0.5, false)
		self.entities.message_frame:show(0.5, false)

		Timer.deleteRef(self.message.timer_ref)
		local function onEnd()
			self.message.hide()
		end
		self.message.timer_ref = Timer.create(HIDING_COOLDOWN_TIME, onEnd)
	end
	self.message.hide = function()
		self.entities.message_layer:hide(0.5)
--		self.entities.message_fr_l:hide(0.5)
--		self.entities.message_fr_r:hide(0.5)
--		self.entities.message_fr_t:hide(0.5)
--		self.entities.message_fr_b:hide(0.5)
		self.entities.message_text:hide(0.5)
		self.entities.message_frame:hide(0.5)
	end
end

------------------------------------------------------------------------------------------

function GameBetScreen:initSliderFold()
	local margin = math.floor(10*GET_SCREEN_HEIGHT()/640)
	local point = cc.p(math.floor(65/1136*GET_SCREEN_WIDTH()), math.floor(180/640*GET_SCREEN_HEIGHT()))
	local size = {width = math.floor(510/margin/1136 * GET_SCREEN_WIDTH()), height = math.floor(350/margin/640 * GET_SCREEN_HEIGHT())}
	self.entities.fold_layer:addChild(DotsLayer:create(point, size, margin), 1)

	self.entities.fold_slider:setBoundingBoxEntity(self.entities.fold_tap_area)

	local start_position  = self.entities.fold_slider:getPosition()
	local finish_position = cc.p(start_position.x, 0.75 * GET_SCREEN_HEIGHT())
	local max_distance    = Point.distance(start_position, finish_position)

	local slider = self.entities.fold_slider
	slider:setScrollingLine(start_position, finish_position)
	slider:addScrollingAnchorPoint(start_position, 1500)
	slider:addScrollingAnchorPoint(finish_position, 1000)

	slider:enableSwipe()
	slider:setSwipeTime(0.3)
	slider:setSwipingUpPoint(finish_position)

	slider:setValues(0,1)
	local function success(info)
		self.message.show("You folded")
		self.entities.fold_slider_text:setString('FOLDED!')
		self.entities.fold_frame:hide()
		self.entities.fold_text:hide()
		self.entities.fold_arrow:hide()
		self.entities.fold_area:setOpacity(0)
		self.entities.fold_area:setVisible(true)
		self.entities.fold_area:fade(0.3, 0.1)
		Touches.disable()
		local function resetPosition()
			self.entities.fold_frame:setVisible(true)
			self.entities.fold_text:setVisible(true)
			self.entities.fold_arrow:setVisible(true)
			self.entities.fold_area:hide(0.3)
			self.entities.fold_slider_text:setString('FOLD')
			self.entities.fold_slider:setRespondable(true)
			slider:setValue(0)

			Touches.enable()
		end
		Timer.deleteRef(self.fold_hiding_timer_ref)
		self.fold_hiding_timer_ref = Timer.create(HIDING_COOLDOWN_TIME, resetPosition)
	end
	local function clickBegin(info)
		RespondManager:shared():lock('fold_slider')
	end
	local function moveEnd()
		if (slider:getValue() > 0.999) then
			success()
		end
		RespondManager:shared():unlock('fold_slider')
	end
	slider:setOnClickBegin(clickBegin)
	slider:setOnInertionMoveEnd(moveEnd)
	slider:setOnSwipeMoveEnd(moveEnd)
end

function GameBetScreen:initButtonCheck()
	local margin = math.floor(10*GET_SCREEN_HEIGHT()/640)
	local point = cc.p(math.floor(620/1136*GET_SCREEN_WIDTH()), math.floor(180/640*GET_SCREEN_HEIGHT()))
	local size = {width = math.floor(510/margin/1136 * GET_SCREEN_WIDTH()), height = math.floor(350/margin/640 * GET_SCREEN_HEIGHT())}
	self.entities.check_layer:addChild(DotsLayer:create(point, size, margin), 1)

	self.entities.check_button:setBoundingBoxEntity(self.entities.check_tap_area)

	local checking_area_timer_ref

	local function hideCheckingArea()
		self.entities.check_area:hide(0.3)
		self.entities.check_button_text:setString('CHECK')
		self.entities.check_area_text:setString('tap twice to check')
		self.entities.check_area_text:setVisible(true)
	end
	local function showCheckingArea(color)
		assert(types.isColor(color))

		local duration = 0.3
		local toOpacity = 0.1
		self.entities.check_area:setColor(color)
		self.entities.check_area:setOpacity(0)
		self.entities.check_area:setVisible(true)
		self.entities.check_area:fade(duration, toOpacity)

		Timer.deleteRef(checking_area_timer_ref)
		checking_area_timer_ref = Timer.create(HIDING_COOLDOWN_TIME, hideCheckingArea)
	end
	local function showCheckingAreaGreen()
		showCheckingArea(cc.c3b(0,255,0))
	end
	local function showCheckingAreaRed()
		showCheckingArea(cc.c3b(255,0,0))
	end

	local checkButton = self.entities.check_button
	checkButton:setOnClickBegin(function(info)
		RespondManager:shared():lock(info.sender:getName())
	end)
	checkButton:setOnClickEnd(function(info)
		RespondManager:shared():unlock(info.sender:getName())
	end)
	checkButton:setOnClick(function()
		showCheckingAreaRed()
		self.entities.check_area_text:setString('one more tap')
	end)
	checkButton:setOnDoubleClick(function()
		showCheckingAreaGreen()
		self.entities.check_button_text:setString('CHECKED!')
		self.entities.check_area_text:hide()
		self.message.show('You checked')
		Touches.disable(HIDING_COOLDOWN_TIME)
	end)
end

------------------------------------------------------------------------------------------

function GameBetScreen:initButtonsAllInAndCall()
	local buttons = {
		{ name = 'all_in', button = self.entities.all_in, frame = self.entities.all_in_frame, text = self.entities.all_in_text,
			onClick = function() self.chipsTable.autoComplete(MoneyManager:shared():getTotal()) end, },
		{ name = 'call',   button = self.entities.call,   frame = self.entities.call_frame,   text = self.entities.call_text,
			onClick = function() self.chipsTable.autoComplete(MoneyManager:shared():getCall()) end, },
	}

	self.buttons = {}
	self.buttons.checkEnable = function()
		local bet   = MoneyManager:shared():getBet()
		local total = MoneyManager:shared():getTotal()
		local call  = MoneyManager:shared():getCall()

		if (total > 0 and bet ~= total) then
			self.buttons.all_in:enable()
		else
			self.buttons.all_in:disable()
		end

		if (total >= call) then
			if (bet ~= call) then
				self.buttons.call:enable()
			end
		else
			self.buttons.call:disable()
		end

		if (total == 0) then
			if (PRESENTATION_MODE == true) then
				Timer.deleteRef(self.timer_show_button_get_more_chips)
				local function onEnd()
					self.entities.text_get_more_chips:setOpacity(0)
					self.entities.text_get_more_chips:show(0.3, false)
					self.entities.button_get_more_chips:setOpacity(0)
					self.entities.button_get_more_chips:show(0.3)
				end
				self.timer_show_button_get_more_chips = Timer.create(2.0, onEnd)
			end
		end
	end

	for i = 1,2 do
		local button = buttons[i].button
		button:setOnClickBegin(function(info)
			RespondManager:shared():lock(buttons[i].name)
		end)
		button:setOnClickEnd(function(info)
			RespondManager:shared():unlock(buttons[i].name)
			self.buttons.checkEnable()
		end)
		button:setOnClick(function(info)
			buttons[i].onClick(info)
			button:disable()
		end)
		button:setOnDisable(function()
			buttons[i].frame:hide()
			buttons[i].text:setOpacity(0.5)
		end)
		button:setOnEnable(function()
			buttons[i].frame:setVisible(true)
			buttons[i].text:setOpacity(1)
		end)
		self.buttons[buttons[i].name] = button
	end
end

------------------------------------------------------------------------------------------

function GameBetScreen:initDraggedChips()
	local margin = math.floor(10*GET_SCREEN_HEIGHT()/640)
	local point = cc.p(math.floor(65/1136*GET_SCREEN_WIDTH()), math.floor(9/32*GET_SCREEN_HEIGHT()))
	local size = {width = math.floor(530/margin/568 * GET_SCREEN_WIDTH()), height = math.floor(70/margin/128 * GET_SCREEN_HEIGHT())}
	self.entities.chips_dots:addChild(DotsLayer:create(point, size, margin), 1)

	local path = 'game/bet/chips/'
	local names = {
		'ic_chips_big_red@2x.png',
		'ic_chips_big_violet@2x.png',
		'ic_chips_big_grey@2x.png',
		'ic_chips_big_green@2x.png',
		'ic_chips_big_orange@2x.png',
	}
	local shadow_name = 'im_shadow@2x.png'
	self.createChip = function(index)
		local size = cc.size(136/1136*GET_SCREEN_WIDTH(), 140/640*GET_SCREEN_HEIGHT())
		return Sprite(path .. names[index], size)
	end
	self.createDragChip = function(index)
		local size = cc.size(136/1136*GET_SCREEN_WIDTH(), 140/640*GET_SCREEN_HEIGHT())
		return Drag(path .. names[index], size)
	end
	self.createShadow = function(index)
		local size = cc.size(132/1136*GET_SCREEN_WIDTH(), 132/640*GET_SCREEN_HEIGHT())
		return Sprite(path .. shadow_name, size)
	end

	self.draggedChips = {}
	self.draggedChips.static = {}
	self.draggedChips.dragged = {}
	self.draggedChips.drag_chips = {}
	self.draggedChips.checkDisableChips = function()
		for i = 1,5 do
			if (MoneyManager:shared():haveMoney(MoneyManager:shared():getChipCost(i)) == false) then
				self.draggedChips.static[i].chip:setOpacity(0.5)
				self.draggedChips.static[i].shadow:setOpacity(0.5)
				self.draggedChips.dragged[i].chip:setRespondable(false)
				self.draggedChips.dragged[i].shadow:setRespondable(false)
				if (self.draggedChips.drag_chips[i]:isDraggingInTheMoment()) then
					self.draggedChips.drag_chips[i]:abortTouch()
				end
			else
				self.draggedChips.static[i].chip:setOpacity(1.0)
				self.draggedChips.static[i].shadow:setOpacity(1.0)
				self.draggedChips.dragged[i].chip:setRespondable(true)
				self.draggedChips.dragged[i].shadow:setRespondable(false)
			end
		end
	end
	self.draggedChips.isNotMovedAnyone = function()
		return (DragManager:shared():isDraggingEntitiesInTheMoment() == false)
	end
	local function dropCheckPredicate(info)
		return info.sender.info.entity:getPositionY() >= 180/640*GET_SCREEN_HEIGHT()
--		return self.entities.chips_drop_area:respondsForTouchPoint(info.touch.point)
	end
	local function onDragStart(info, index)
		RespondManager:shared():lock(info.sender:getName())
		self.chipsTable.show()
		self.entities.chips_drop_area:show()
		self.draggedChips.dragged[index].chip:show()
	end
	local function onDrag(info, index)
		for i = 1,5 do
			if (dropCheckPredicate(info)) then
				self.entities.chips_drop_area:setColor(cc.c4b(0,255,0,255))
				return
			end
--			if (self.draggedChips.drag_chips[i]:isDraggingInTheMoment()) then
--				if (self.entities.chips_drop_area:respondsForTouchPoint(self.draggedChips.dragged[i].chip:getPosition())) then
--					self.entities.chips_drop_area:setColor(cc.c4b(0,255,0,255))
--					return
--				end
--			end
		end
		self.entities.chips_drop_area:setColor(cc.c4b(255,0,0,255))
	end
	local function onDropSuccess(info, index, chip_position)
		self.chipsTable.addChip(index, self.draggedChips.dragged[index].chip:getPosition())
		self.draggedChips.dragged[index].chip:setPosition(chip_position)
		self.draggedChips.dragged[index].chip:setVisible(false)
		self.draggedChips.checkDisableChips()
		self.entities.chips_drop_text:hide()
		self.buttonUndo:show()
		self.buttonUndo:enable()
		if (self.draggedChips.isNotMovedAnyone()) then
			self.entities.chips_drop_area:hide()
			self.buttons.checkEnable()
		end
		self.betText.update()
		RespondManager:shared():unlock(info.sender:getName())
	end
	local function onDropFail(info, index)
		info.sender:moveToStartPosition()
	end
	local function onEndMoving(index)
		if (self.draggedChips.isNotMovedAnyone()) then
			if (self.chipsTable.isExistChipsAtTable() == false) then
				self.chipsTable.hide()
			end
			self.entities.chips_drop_area:hide()
		end
		self.draggedChips.dragged[index].chip:setVisible(false)
		RespondManager:shared():unlock('chip'..index)
	end

	for i = 1,5 do
--		local shadow_position = cc.p(418 + (i-1) * 155, 75)
--		local chip_position   = cc.p(416 + (i-1) * 155, 91)
		local shadow_position = cc.p((418 + (i-1) * 155)/1136 * GET_SCREEN_WIDTH(), 75/640 * GET_SCREEN_HEIGHT())
		local chip_position   = cc.p((416 + (i-1) * 155)/1136 * GET_SCREEN_WIDTH(), 91/640 * GET_SCREEN_HEIGHT())

		local shadow_static = self.createShadow()
			  shadow_static:setPosition(shadow_position)
			  shadow_static:setName('shadow_static' .. i)
			  shadow_static:setOrder(1)
			  shadow_static:setRespondable(false)
		self.entities.main_chips_layer:addChild(shadow_static)

		local chip_static = self.createChip(i)
			  chip_static:setPosition(chip_position)
			  chip_static:setName('chip_static' .. i)
			  chip_static:setOrder(2)
			  chip_static:setRespondable(false)
		self.entities.main_chips_layer:addChild(chip_static)

		local shadow = self.createShadow()
			  shadow:setName('shadow' .. i)
			  shadow:setOrder(-1)
			  shadow:setRespondable(false)
		local shadow_point = cc.p(shadow:getWidth()/2, shadow:getHeight()/2 - 36/640*GET_SCREEN_HEIGHT())
			  shadow:setPosition(shadow_point)
		local chip = self.createDragChip(i)
			  chip:setPosition(chip_position)
			  chip:setStartPosition(chip_position)
			  chip:setName('chip' .. i)
			  chip:setOrder(4)
			  chip:setStartOrder(4)
			  chip:setVisible(false)
			  chip:addChild(shadow)
			  chip:getDragEntity():setBoundingBoxCircle(cc.p(0,0), 70/1136*GET_SCREEN_WIDTH())
		self.entities.main_chips_layer:addChild(chip)

		self.draggedChips.dragged[i] = { chip = chip, shadow = shadow, }
		self.draggedChips.static[i] = { chip = chip_static, shadow = shadow_static, }

		local drag_chip = chip
			  drag_chip:enableElevatingOnStart()
			  drag_chip:setOnDrag(function(info) onDrag(info,i) end)
			  drag_chip:setOnClickBegin(function(info) onDragStart(info,i) end)
			  drag_chip:setDropPredicate(dropCheckPredicate)
			  drag_chip:setOnDropSuccess(function(info) onDropSuccess(info,i,chip_position) end)
			  drag_chip:setOnDropFail(function(info) onDropFail(info,i) end)
			  drag_chip:setOnEndMovingToStartPosition(function() onEndMoving(i) end)
			  drag_chip:setOnCancelled(function(info) dropFail(info,i) end)
		self.draggedChips.drag_chips[i] = drag_chip
	end
end

function GameBetScreen:initTableChips()
	local margin = math.floor(10*GET_SCREEN_HEIGHT()/640)
	local point = cc.p(math.floor(10/1136*GET_SCREEN_WIDTH()), math.floor(20/640*GET_SCREEN_HEIGHT()))
	local size = {width = math.floor(1130/margin/1136 * GET_SCREEN_WIDTH()), height = math.floor(70/margin/640 * GET_SCREEN_HEIGHT())}
	self.entities.chips_area_bet:addChild(DotsLayer:create(point, size, margin), 1)
	local point = cc.p(math.floor(10/1136*GET_SCREEN_WIDTH()), 0)
	local size = {width = math.floor(1130/margin/1136 * GET_SCREEN_WIDTH()), height = math.floor(150/margin/640 * GET_SCREEN_HEIGHT())}
	self.entities.chips_area_clear:addChild(DotsLayer:create(point, size, margin), 1)

	self.chipsTable = {}
	self.chipsTable.isPointOnAreaBet = function(point)
		assert(types.isPoint(point))
		return point.y >= 540/640*GET_SCREEN_HEIGHT()
	end
	self.chipsTable.isPointOnAreaClear = function(point)
		assert(types.isPoint(point))
		return point.y <= 200/640*GET_SCREEN_HEIGHT()
	end
	self.chipsTable.resetPosition = function()
		local point = cc.p((568+20)/1136*GET_SCREEN_WIDTH(), 350/640*GET_SCREEN_HEIGHT())
		self.entities.chips_table_dragged:setPosition(point)
		self.entities.chips_table_dragged:setStartPosition(point)
	end
	self.chipsTable.resetPosition()

	local function onStartDrag(info)
		RespondManager:shared():lock(info.sender:getName())
		self.entities.chips_table_dragged_content:setRespondable(false)
		self.entities.bet_tip:hide()
		self.entities.main_chips_layer:hide()
		self.entities.chips_drag_areas:show()
		self.buttonUndo:disable()
		self.entities.chips_area_clear_hl:show()
		self.entities.right_line:hide()
		if (self.chipsTable.bet_all_in == true) then
			self.entities.chips_area_bet:hide()
			self.entities.chips_area_bet_text:hide()
			self.entities.allin_left_layer:hide()
			self.entities.allin_right_layer:hide()
		else
			if (self.chipsTable.can_bet == true) then
				self.entities.chips_area_bet:show()
				self.entities.chips_area_bet_text:show()
				self.entities.chips_area_bet_hl:show()
			else
				self.entities.chips_area_bet:hide()
				self.entities.chips_area_bet_text:hide()
			end
		end
	end
	local function onDrag(info)
		self.chipsTableAreas.update(info.touch.point)
	end
	local function onEndDrag(info)
		self.entities.chips_area_bet_hl:hide()
		self.entities.chips_area_clear_hl:hide()
	end
	local function onDropSuccess(info)
		local point = self.entities.chips_table_dragged:getPosition()
		if (self.chipsTable.isPointOnAreaBet(point)) then
			self.chipsTable.completeBet()
		else
			MoneyManager:shared():clearBet()
			self.draggedChips.checkDisableChips()
			self.chipsTable.clear()
			self.buttons.checkEnable()
			self.entities.chips_area_bet_hl:hide()
			self.entities.chips_area_clear_hl:hide()
			self.entities.chips_drag_areas:hide()
			self.entities.bet_text:hide()
			self.buttonUndo:hide()
			self.chipsTable.hide()
			self.entities.main_chips_layer:show()
		end
		self.entities.chips_table_dragged_content:setRespondable(true)
		self.entities.chips_table_dragged:setPosition(info.sender:getStartPosition())
		RespondManager:shared():unlock(info.sender:getName())
	end
	local function dropCheckPredicate(info)
		local point = self.entities.chips_table_dragged:getPosition()

		if (self.chipsTable.can_bet == true and self.chipsTable.bet_all_in ~= true) then
			return self.chipsTable.isPointOnAreaBet(point) or
					self.chipsTable.isPointOnAreaClear(point)
		end

		return self.chipsTable.isPointOnAreaClear(point)
	end
	local function onFailMoveEnd()
		self.buttonUndo:enable()
		self.entities.bet_tip:show()
		self.entities.main_chips_layer:show()
		self.entities.chips_drag_areas:hide()
		self.entities.chips_table_dragged_content:setRespondable(true)
		RespondManager:shared():unlock('chips_table_dragged')
		self.entities.right_line:show()
		
		if (self.chipsTable.bet_all_in == true) then
			self.entities.allin_left_layer:show()
			self.entities.allin_right_layer:show()
		end
	end

	self.chipsTable.dragged = self.entities.chips_table_dragged
	self.chipsTable.dragged:setOnClickBegin(onStartDrag)
	self.chipsTable.dragged:setOnDrag(onDrag)
	self.chipsTable.dragged:setOnClickEnd(onEndDrag)
	self.chipsTable.dragged:setOnDropSuccess(onDropSuccess)
	self.chipsTable.dragged:setOnEndMovingToStartPosition(onFailMoveEnd)
	self.chipsTable.dragged:setDropPredicate(dropCheckPredicate)

	local distance_col = (140 / 1136) * GET_SCREEN_WIDTH()
	local distance_row = (20  / 640)  * GET_SCREEN_HEIGHT()

	self.chipsTable.chips_cols = {}
	self.chipsTable.chip_at_table_index = 0
	self.chipsTable.addChip = function(index, point)
		assert(index >= 1 and index <= 5)
		assert(types.isPoint(point))
		local col_index = self.chipsTable.getColIndexForPoint(point)
		self.chipsTable.addChipInCol(index, col_index, point)
	end
	self.chipsTable.addChipInCol = function(index, col_index, point)
		assert(index >= 1 and index <= 5)
		assert(col_index >= 1 and col_index <= self.chipsTable.colSize())

		self.chipsTable.chip_at_table_index = self.chipsTable.chip_at_table_index + 1
		local count_chips_in_col = table.size(self.chipsTable.chips_cols[col_index].chips)
		local index_chip = count_chips_in_col + 1

		local chip_entity = self.createChip(index)
		if (point) then
			chip_entity:setPosition(Point.subtract(point, self.entities.chips_table_dragged:getPosition()))
		end
		chip_entity:setName('chip_at_table' .. self.chipsTable.chip_at_table_index)
		chip_entity:setBoundingBoxCircle(cc.p(0,0), 70/640*GET_SCREEN_HEIGHT())
		chip_entity:setOrder(10+index_chip)

		self.chipsTable.chips_cols[col_index].chips[index_chip] = { chip = chip_entity, index = index_chip, }
		self.entities.chips_table_dragged_content:addChild(chip_entity)

		if (self.chipsTable.chips_cols[col_index].shadow == nil) then
			local shadow = self.createShadow()
				  shadow:setOrder(1)
				  shadow:setRespondable(false)
			if (point) then
				shadow:setPosition(Point.subtract(point, self.entities.chips_table_dragged:getPosition()))
			end
			self.entities.chips_table_dragged_content:addChild(shadow)
			self.chipsTable.chips_cols[col_index].shadow = shadow
		end

		MoneyManager:shared():betIncrease(MoneyManager:shared():getChipCost(index))
		UndoManager:shared():addTransaction({ transaction_type = 'single', col_index = col_index, chip_index = index_chip, chip_value = index, })

		self.chipsTable.updateChipsPositions()
		self.chipsTable.checkBet()
	end
	self.chipsTable.onUndoClick = function()
		assert(UndoManager:shared():canUndo())
		local info = UndoManager:shared():undo()
		if (info.transaction_type == 'all') then
			self.chipsTable.removeAllChips(info)
		elseif (info.transaction_type == 'single') then
			self.chipsTable.removeSingleChip(info)
		else
			assert(false)
		end
	end
	self.chipsTable.removeSingleChip = function(info)
		local index_col  = info.col_index
		local index_chip = info.chip_index
		local chip_value = info.chip_value

		assert(types.isNumber(index_col))
		assert(types.isNumber(index_chip))
		assert(types.isNumber(chip_value))
		assert(index_col >= 1 and index_col <= table.size(self.chipsTable.chips_cols))
		assert(index_chip >= 1 and index_chip <= table.size(self.chipsTable.chips_cols[index_col].chips))

		local chip_entity = self.chipsTable.chips_cols[index_col].chips[index_chip].chip
			  chip_entity:hide()
			  chip_entity:destroy()
		self.chipsTable.chips_cols[index_col].chips[index_chip] = nil

		if (table.size(self.chipsTable.chips_cols[index_col].chips) == 0) then
			self.chipsTable.chips_cols[index_col].shadow:hide()
			self.chipsTable.chips_cols[index_col].shadow:destroy()
			if (self.chipsTable.chips_cols[index_col].index_x == 1) then
				for i, col in pairs(self.chipsTable.chips_cols) do
					col.index_x = col.index_x - 1
				end
			end
			self.chipsTable.chips_cols[index_col] = nil
			self.chipsTable.updateColsPositions()
		end

		MoneyManager:shared():betDecrease(MoneyManager:shared():getChipCost(chip_value))
		self.betText.update()

		if (self.draggedChips.isNotMovedAnyone()) then
			self.buttons.checkEnable()
		end

		self.draggedChips.checkDisableChips()
		self.chipsTable.checkBet()

		if (MoneyManager:shared():getBet() == 0) then
			if (self.draggedChips.isNotMovedAnyone()) then
				self.chipsTable.hide()
				self.entities.chips_drop_text:show()
				self.entities.chips_drop_area:hide()
			end
			self.buttonUndo:hide()
		end
	end
	self.chipsTable.removeAllChips = function(info)
		self.chipsTable.clear()
		self.chipsTable.hide()
		self.draggedChips.checkDisableChips()
		self.buttons.checkEnable()
		self.chipsTable.checkBet()
		self.buttonUndo:hide()
	end
	self.chipsTable.updateColsPositions = function()
		local size = table.size(self.chipsTable.chips_cols)
		for i, col in pairs(self.chipsTable.chips_cols) do
			col.point = cc.p(((col.index_x - (size+1)/2) * distance_col), 0)
		end
		self.chipsTable.updateChipsPositions()
	end
	self.chipsTable.updateChipsPositions = function()
		for i, col in pairs(self.chipsTable.chips_cols) do
			if (col.shadow ~= nil) then
				col.shadow:setRespondable(false)
				col.shadow:moveTo(0.3, cc.p(col.point.x, col.point.y))
			end
			for j, chip_holder in pairs(col.chips) do
				chip_holder.chip:setRespondable(true)
				chip_holder.chip:moveTo(0.3, cc.p(col.point.x, col.point.y + j * distance_row))
			end
		end
	end
	self.chipsTable.createNewCol = function(point)
		assert(types.isPoint(point))

		local index = table.size(self.chipsTable.chips_cols) + 1
		self.chipsTable.chips_cols[index] = { point = point, chips = {}, }

		local addedToRight = (point.x > GET_SCREEN_WIDTH()/2)
		if (addedToRight == true) then
			self.chipsTable.chips_cols[index].index_x = index
		else
			for i=1,index-1 do
				self.chipsTable.chips_cols[i].index_x = self.chipsTable.chips_cols[i].index_x + 1
			end
			self.chipsTable.chips_cols[index].index_x = 1
		end

		self.chipsTable.updateColsPositions()
		return index
	end
	self.chipsTable.canCreateNewCol = function()
		return (self.chipsTable.colSize() < TABLE_MAX_COLS_SIZE)
	end
	self.chipsTable.colSize = function()
		return table.size(self.chipsTable.chips_cols)
	end
	self.chipsTable.getColIndexForPoint = function(point)
		assert(types.isPoint(point))
		local nearestColIndex = 0
		local minDistance = nil
		for i,col in pairs(self.chipsTable.chips_cols) do
			assert(table.size(col.chips) > 0)
			local col_point_x = col.chips[1].chip:getPositionX()
			local distance = math.abs((col_point_x + self.entities.chips_table_dragged:getPosition().x) - point.x)
			if (minDistance == nil or distance < minDistance) then
				nearestColIndex = i
				minDistance = distance
			end
		end
		if ((minDistance == nil or minDistance > distance_col) and self.chipsTable.canCreateNewCol()) then
			return self.chipsTable.createNewCol(point)
		end
		assert(nearestColIndex > 0)
		return nearestColIndex
	end
	self.chipsTable.isExistChipsAtTable = function()
		for i, col in pairs(self.chipsTable.chips_cols) do
			if (table.size(col.chips) > 0) then
				return true
			end
		end
		return false
	end
	self.chipsTable.clear = function()
		for i,col in pairs(self.chipsTable.chips_cols) do
			col.shadow:hide()
			col.shadow:destroy()
			for j,chip in pairs(self.chipsTable.chips_cols[i].chips) do
				local chip_entity = chip.chip
				chip_entity:hide()
				chip_entity:destroy()
				self.chipsTable.chips_cols[i].chips[j] = nil
			end
			self.chipsTable.chips_cols[i] = nil
		end
		self.chipsTable.resetPosition()
		self.allinSliders.reset()
		UndoManager:shared():clear()
		MoneyManager:shared():clearBet()
		self.buttonUndo:disable()
		self.entities.chips_drop_text:show()
		self.betText.update()
	end
	self.chipsTable.autoComplete = function(number)
		assert(types.isNumber(number))
		assert(number > 0)
		self.chipsTable.clear()
		self.chipsTable.show()
		self.entities.chips_drop_text:hide()
		local currentBet = MoneyManager:shared():getBet()
		local currentNumber = number

		local function getMaxCostIndex(number)
			for i = 1,5 do
				local cost = MoneyManager:shared():getChipCost(i)
				if (cost <= number) then
					return i, cost
				end
			end
			return 0, 0
		end

		local currentColIndex = 0
		local currentColCount = 0

		local lastIndex = 0

		while (currentNumber > 0) do
			assert(currentNumber >= 0)
			local index, cost = getMaxCostIndex(currentNumber)
			assert(index > 0)
			currentNumber = currentNumber - cost
			currentColCount = currentColCount + 1
--			if (currentColCount > 5 or currentColCount == 1 or lastIndex ~= index) then
			if (currentColCount > 5 or currentColCount == 1) then
				lastIndex = index
				assert(self.chipsTable.canCreateNewCol())
				self.chipsTable.createNewCol(cc.p(1000000,320))
				currentColCount = 1
				currentColIndex = currentColIndex + 1
			end
			self.chipsTable.addChipInCol(index, currentColIndex)
		end
		self.betText.update()
		self.buttons.checkEnable()
		self.draggedChips.checkDisableChips()
		self.chipsTable.checkBet()
		self.buttonUndo:show()
		self.buttonUndo:enable()

		UndoManager:shared():clear()
		UndoManager:shared():addTransaction({transaction_type = 'all',})
	end
	self.chipsTable.show = function()
		self.entities.check_layer:hide()
		self.entities.fold_layer:hide()
		self.entities.chips_dots:show()
	end
	self.chipsTable.hide = function()
		self.entities.check_layer:show()
		self.entities.fold_layer:show()
		self.entities.chips_dots:hide()
	end
	self.chipsTable.checkBet = function()
		self.entities.allin_left_layer:hide()
		self.entities.allin_right_layer:hide()
--		self.entities.chips_table_dragged_content:setRespondable(false)
		self.entities.chips_table_dragged_content:setRespondable(true)
		self.entities.chips_table_dragged_frame:setRespondable(true)
		self.entities.right_line:hide()

		self.chipsTable.bet_all_in = false
		local canBet, betType = MoneyManager:shared():canBet()
		if (canBet) then
			if (betType == 'ALL IN') then
				self.entities.allin_left_layer:show()
				self.entities.allin_right_layer:show()
--				self.entities.chips_table_dragged_content:setRespondable(false)
				self.entities.chips_table_dragged_frame:setRespondable(false)
				self.chipsTable.bet_all_in = true
			else
--				self.entities.chips_table_dragged_content:setRespondable(true)
				self.entities.right_line:setVisible(true)
			end
		end
		self.chipsTable.can_bet = canBet
	end
	self.chipsTable.completeBet = function()
		local current_bet = MoneyManager:shared():getBet()
		local can_bet, bet_type = MoneyManager:shared():canBet()
		if (bet_type == 'RAISE') then
			self.message.show('You raised to ' .. current_bet)
		elseif (bet_type == 'ALL IN') then
			self.message.show("You're going ALL-IN")
		elseif (bet_type == 'CALL') then
			self.message.show('You called')
		else
			assert(false)
			self.message.show('bet maked: ' .. current_bet)
		end
		MoneyManager:shared():makeBet()
		self.labels.updateTotal()
		self.draggedChips.checkDisableChips()
		self.chipsTable.clear()
		self.buttons.checkEnable()
		self.entities.chips_area_bet_hl:hide()
		self.entities.chips_area_clear_hl:hide()
		self.entities.chips_drag_areas:hide()
		self.entities.bet_text:hide()
		self.buttonUndo:hide()
		self.chipsTable.hide()
		self.entities.main_chips_layer:show()
	end

	self.chipsTableAreas = {}
	self.chipsTableAreas.update = function(point)
		assert(types.isPoint(point))
		
		local point = self.entities.chips_table_dragged:getPosition()
		if (self.chipsTable.isPointOnAreaBet(point)) then
			self.entities.chips_area_bet_hl:setColor(cc.c3b(0,255,0))
		elseif (self.chipsTable.isPointOnAreaClear(point)) then
			self.entities.chips_area_clear_hl:setColor(cc.c3b(0,255,0))
		else
			self.entities.chips_area_bet_hl:setColor(cc.c3b(255,0,0))
			self.entities.chips_area_clear_hl:setColor(cc.c3b(255,0,0))
		end
	end

	self.betText = {}
	self.betText.tip = function(text)
		assert(types.isString(text))
		if (string.len(text) > 0) then
			self.entities.bet_tip:setVisible(true)
			self.entities.bet_tip:setString(text)
		else
			self.entities.bet_tip:setVisible(false)
		end
	end
	self.betText.update = function()
		local number = MoneyManager:shared():getBet()
		assert(types.isNumber(number))
		if (number > 0) then
			self.entities.bet_text:setVisible(true)
			local canBet, betType = MoneyManager:shared():canBet()
			if (canBet) then
				self.entities.bet_text:setString(betType .. ' ' .. convert.toPriceString(number))
				self.betText.tip('move across line to bet')
			else
				local minBet, betType = MoneyManager:shared():getMinBet()
				self.entities.bet_text:setString(convert.toPriceString(number))
				self.betText.tip(minBet .. ' to ' .. betType)
			end
		else
			self.entities.bet_text:hide()
			self.betText.tip('')
		end
	end
end

------------------------------------------------------------------------------------------

function GameBetScreen:initAllInSliders()
	local sliders = {
		{ entity = self.entities.allin_left_slider,  area = self.entities.allin_left_area,  finish_y = 480/640*GET_SCREEN_HEIGHT(), },
		{ entity = self.entities.allin_right_slider, area = self.entities.allin_right_area, finish_y = 480/640*GET_SCREEN_HEIGHT(), },
	}

	local function allInSuccess()
		self.chipsTable.completeBet()
	end

	self.allinSliders = {}
	self.allinSliders.sliders = {}
	self.allinSliders.moving = 0
	self.allinSliders.getValueSum = function()
		return self.allinSliders.sliders[1]:getValue() + self.allinSliders.sliders[2]:getValue()
	end
	self.allinSliders.isSuccess = function()
		for i = 1,2 do
			local slider = self.allinSliders.sliders[i]
			if (slider:isInUseNow() == true or slider:isInMoveNow() == true or slider:getValue() ~= 1) then
				return false
			end
		end
		return true
	end
	self.allinSliders.reset = function()
		for i = 1,2 do
			local slider = self.allinSliders.sliders[i]
			slider:setValue(0)
		end
	end
	self.allinSliders.isSlidersMovedNow = function()
		for i = 1,2 do
			local slider = self.allinSliders.sliders[i]
			if (slider:isInUseNow() or slider:isInMoveNow()) then
				return true
			end
		end
		return self.allinSliders.moving > 0
	end
	for i = 1,2 do
		sliders[i].entity:setBoundingBoxEntity(sliders[i].area)
		local pos_start = sliders[i].entity:getPosition()
		local pos_end   = cc.p(sliders[i].entity:getPositionX(), sliders[i].finish_y)
		local slider = sliders[i].entity
		slider:setScrollingLine(pos_start, pos_end)
		slider:addScrollingAnchorPoint(pos_start, 1500)
		slider:addScrollingAnchorPoint(pos_end, 1000)
		slider:enableSwipe()
		slider:setSwipeTime(0.3)
		slider:setSwipingUpPoint(pos_end)
		slider:setValues(0,1)
		local function clickBegin()
			RespondManager:shared():lock(sliders[i].entity:getName())
		end
		local function moveEnd()
			RespondManager:shared():unlock(sliders[i].entity:getName())
			if (self.allinSliders.isSuccess()) then
				allInSuccess()
			end
			if (slider:getValue() > 0.9999) then
				sliders[i].entity:setRespondable(false)
				sliders[i].area:setRespondable(false)
				Timer.deleteRef(sliders[i].timer_ref)
				sliders[i].timer_ref = Timer.create(0.3, function()
					self.allinSliders.moving = self.allinSliders.moving + 1
					sliders[i].entity:moveTo(0.3, pos_start, function()
						sliders[i].entity:setRespondable(true)
						sliders[i].area:setRespondable(true)
						self.allinSliders.moving = self.allinSliders.moving - 1
					end)
				end)
			end
		end
		local function moveUpdate()
			if (self.allinSliders.isSlidersMovedNow()) then
				local x = (568+20)/1136 * GET_SCREEN_WIDTH()
				local y = (350+100 * self.allinSliders.getValueSum())/640 * GET_SCREEN_HEIGHT()
				self.entities.chips_table_dragged:setPosition(x, y)
			end
		end
		sliders[i].entity:setOnUpdate(moveUpdate)
		slider:setOnClickBegin(clickBegin)
		slider:setOnInertionMoveEnd(moveEnd)
		slider:setOnSwipeMoveEnd(moveEnd)
		slider:setOnDrag(moveUpdate)
		slider:setOnInertionMoveUpdate(moveUpdate)
		self.allinSliders.sliders[i] = slider
	end
end

------------------------------------------------------------------------------------------

function GameBetScreen:initRespondManager()
	RespondManager:shared():addRespondingFamily(self.entities.btn_undo_frame)
	RespondManager:shared():addRespondingFamily({
		self:getEntityNamed('chip1'),
		self:getEntityNamed('chip2'),
		self:getEntityNamed('chip3'),
		self:getEntityNamed('chip4'),
		self:getEntityNamed('chip5'),
	})
	RespondManager:shared():addRespondingFamily(self.entities.check_button)
	RespondManager:shared():addRespondingFamily(self.entities.fold_slider)
	RespondManager:shared():addRespondingFamily(self.entities.chips_table_dragged)
	RespondManager:shared():addRespondingFamily(self.entities.all_in)
	RespondManager:shared():addRespondingFamily(self.entities.call)
	RespondManager:shared():addRespondingFamily({self.entities.allin_left_slider, self.entities.allin_right_slider})
	if (PRESENTATION_MODE == true) then
		RespondManager:shared():addRespondingFamily(self.entities.button_get_more_chips)
	end
end

------------------------------------------------------------------------------------------

function GameBetScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bet_top', },

-- bg
		{ entity = 'sprite', key = 'bet_bg', parent = 'bet_top', },
		{ entity = 'sprite', key = 'bet_bg1', parent = 'bet_bg', w = '100%W', h = '100%H', x = '50%W', y = '50%H', color = 'yellow', },
		{ entity = 'sprite', key = 'bet_bg2', parent = 'bet_bg', w = '100%W', h = '10.625%H', x = '50%W', yp = 94.6875, order = 1, respondable = false, },
		{ entity = 'sprite', key = 'bet_bg3', parent = 'bet_bg', w = '92.9577%W', h = '2.1875%H', xp = 51.8486, yp = 84.375, order = 1, respondable = false, },
-- text "To call"
		{ entity = 'text', key = 'text_to_call', parent = 'bet_bg', wp = 33, hp = 5, xp = 13.2042, yp = 95, color = 'black', order = 2, text = 'TO CALL: 150', size = '4.6875%H', alignment = 'left', respondable = false, },
-- text "Your total"
		{ entity = 'text', key = 'text_your_total', parent = 'bet_bg', wp = 33, hp = 5, xp = 86.7958, yp = 95, color = 'black', order = 2, text = 'YOUR STACK: 10500', size = '4.6875%H', alignment = 'right', respondable = false, },

-- message
		{ entity = 'sprite', key = 'message_layer', parent = 'bet_top', order = 10, respondable = false, visible = false, opacity = 0, },
--		{ entity = 'sprite', key = 'message_fr_l',  parent = 'message_layer', wp = 0.352113, hp = 10.625, xp = 0.176056, yp = 94.6875, color = 'black', order = 2, respondable = false, visible = false, opacity = 0, },
--		{ entity = 'sprite', key = 'message_fr_r',  parent = 'message_layer', wp = 0.352113, hp = 10.625, xp = 99.8239, yp = 94.6875, color = 'black', order = 2, respondable = false, visible = false, opacity = 0, },
--		{ entity = 'sprite', key = 'message_fr_t',  parent = 'message_layer', w = '100%W', hp = 0.625, x = '50%W', yp = 89.6875, color = 'black', order = 2, respondable = false, visible = false, opacity = 0, },
--		{ entity = 'sprite', key = 'message_fr_b',  parent = 'message_layer', w = '100%W', hp = 0.625, x = '50%W', yp = 99.6875, color = 'black', order = 2, respondable = false, visible = false, opacity = 0, },
--		{ entity = 'sprite', key = 'message_frame', parent = 'message_layer', wp = 99.1197, hp = 9.0625, x = '50%W', yp = 94.6875, order = 3, respondable = false, visible = false, opacity = 0, },
		{ entity = 'sprite', key = 'message_frame', parent = 'message_layer', w = '100%W', hp = 10.625, x = '50%W', yp = 94.6875, order = 3, respondable = false, visible = false, opacity = 0, },
		{ entity = 'text',   key = 'message_text',  parent = 'message_layer', w = '100%W', hp = 5, x = '50%W', yp = 94.6875, color = 'black', order = 4, size = '5%H', text = 'MESSAGE', opacity = 0, },

-- slider fold
-- (fold_frame used as bounding box for slider)
		{ entity = 'sprite', key = 'fold_layer',       parent = 'bet_top', order = 3, },
		{ entity = 'sprite', key = 'fold_frame',       parent = 'fold_layer', wp = 24.6479, hp = 48.4375, xp = 27.9049, yp = 55, color = 'yellow', order = 4, },
		{ entity = 'sprite', key = 'fold_arrow',       parent = 'fold_layer', wp = 4.57746, hp = 15.625, xp = 27.9049, yp = 61.875, texture = 'game/bet/arrows/ic_fold_up@2x.png', order = 5, },
		{ entity = 'text',   key = 'fold_text',        parent = 'fold_layer', wp = 24.6479, hp = 4.6875, xp = 27.9049, yp = 34.375, color = 'black', order = 6, text = 'STRING_DRAG_UP', size = '4.6875%H', },
		{ entity = 'sprite', key = 'fold_area',        parent = 'fold_layer', wp = 44.8944, hp = 54.6875, xp = 27.4648, yp = 55.3125, color = 'green', order = 7, max_opacity = 0.1, respondable = false, visible = false, },
		{ entity = 'sprite', key = 'fold_tap_area',    parent = 'fold_layer', wp = 44.8944, hp = 59.375, xp = 27.4648, yp = 55.3125, color = 'black', order = 8, visible = false, },
		{ entity = 'slider', key = 'fold_slider',      parent = 'fold_layer', wp = 24.6479, hp = 9.0625, xp = 27.9049, yp = 41.25, color = 'black', order = 9, },
		{ entity = 'text',   key = 'fold_slider_text', parent = 'fold_slider', wp = 24.6479, hp = 9.0625, xp = 12.3239, yp = 4.53125, text = 'STRING_FOLD', order = 10, respondable = false, size = '7.8125%H', },

-- button
-- check
-- (check_area used as bounding box for button)
		{ entity = 'sprite', key = 'check_layer',       parent = 'bet_top', order = 3, },
		{ entity = 'text',   key = 'check_area_text',   parent = 'check_layer', wp = 27.6408, hp = 6.25, xp = 76.2324, yp = 47.6562, color = 'black', order = 5, text = 'STRING_TAP_TWICE_CHECK', size = '4.6875%H', bg = 'yellow', },
		{ entity = 'sprite', key = 'check_area',        parent = 'check_layer', wp = 44.8944, hp = 54.6875, xp = 76.2324, yp = 55.3125, color = 'red', order = 6, max_opacity = 0.1, visible = false, respondable = false, },
		{ entity = 'sprite', key = 'check_tap_area',    parent = 'check_layer', wp = 44.8944, hp = 59.375, xp = 76.2324, yp = 55.3125, color = 'black', order = 7, visible = false, },
		{ entity = 'button', key = 'check_button',      parent = 'check_layer', wp = 27.6408, hp = 9.0625, xp = 76.2324, yp = 55.3125, color = 'black', order = 8, },
		{ entity = 'text',   key = 'check_button_text', parent = 'check_button', wp = 27.6408, hp = 9.0625, xp = 13.8204, yp = 4.53125, text = 'STRING_CHECK', order = 9, respondable = false, size = '7.8125%H', },

-- button
-- undo
		{ entity = 'sprite', key = 'undo_layer',            parent = 'bet_top', order = 1, visible = false, respondable = false, opacity = 0, },
		{ entity = 'sprite', key = 'undo_yellow_separator', parent = 'undo_layer', wp = 0.352113, hp = 10.625, xp = 87.3239, yp = 94.6875, order = 1, color = 'yellow', respondable = false, opacity = 0, },
		{ entity = 'button', key = 'btn_undo_frame',        parent = 'undo_layer', wp = 12.5, hp = 10.625, xp = 93.75, yp = 94.6875, order = 2, opacity = 0, },
		{ entity = 'sprite', key = 'undo_arrow',            parent = 'undo_layer', wp = 2.46479, hp = 4.375, xp = 90.669, yp = 94.6875, order = 3, texture = 'game/bet/arrows/ic_undo_active@2x.png', respondable = false, opacity = 1, respondable = false, opacity = 0, },
		{ entity = 'text',   key = 'undo_text',             parent = 'undo_layer', wp = 8.80282, hp = 5.3125, xp = 95.5986, yp = 94.6875, order = 4, color = 'black', text = 'STRING_UNDO', size = '5%H', respondable = false, opacity = 0, },

-- button
-- all in
		{ entity = 'sprite', key = 'all_in_layer', parent = 'bet_top', order = 3, },
		{ entity = 'button', key = 'all_in',       parent = 'all_in_layer', wp = 10.8275, hp = 21.5625, xp = 10.7394, yp = 14.2188, opacity = 1, },
		{ entity = 'sprite', key = 'all_in_frame', parent = 'all_in', wp = 9.0669, hp = 18.4375, xp = 5.45775, yp = 10.7812, color = 'yellow', opacity = 1, respondable = false, },
		{ entity = 'text',   key = 'all_in_text',  parent = 'all_in', wp = 9.0669, hp = 5, xp = 5.45775, yp = 10.7812, color = 'black', opacity = 1, text = 'STRING_ALL_IN', size = '5%H', respondable = false, },

-- button
-- call
		{ entity = 'sprite', key = 'call_layer', parent = 'bet_top', order = 3, },
		{ entity = 'button', key = 'call',       parent = 'call_layer', wp = 10.8275, hp = 21.5625, xp = 22.8873, yp = 14.2188, opacity = 1, },
		{ entity = 'sprite', key = 'call_frame', parent = 'call', wp = 9.0669, hp = 18.4375, xp = 5.45775, yp = 10.7812, color = 'yellow', opacity = 1, respondable = false, },
		{ entity = 'text',   key = 'call_text',  parent = 'call', wp = 9.0669, hp = 5, xp = 5.45775, yp = 10.7812, color = 'black', opacity = 1, text = 'STRING_CALL', size = '5%H', respondable = false, },

-- chips
-- dots
		{ entity = 'sprite', key = 'chips_dots',      parent = 'bet_top', order = 6, visible = false, },
		{ entity = 'text',   key = 'chips_drop_text', parent = 'chips_dots', wp = 26.4085, hp = 6.25, xp = 51.7606, yp = 54.6875, color = "black", order = 3, respondable = false, text = 'STRING_DRAG_CHIPS_HERE', size = '4.6875%H', bg = "yellow", },
		{ entity = 'text',   key = 'bet_tip',         parent = 'chips_dots', wp = 35.2113, hp = 6.25, xp = 51.7606, yp = 33.5938, color = "black", order = 4, respondable = false, visible = false, size = '4.6875%H', text = '150 to call', bg = 'yellow', },
		{ entity = 'sprite', key = 'chips_drop_area', parent = 'chips_dots', wp = 93.838, hp = 57.1875, xp = 51.7606, yp = 54.6875, color = "green", order = 5, respondable = false, visible = false, max_opacity = 0.1, },
		{ entity = 'text',   key = 'bet_text',        parent = 'chips_dots', wp = 35.2113, hp = 7.8125, xp = 51.7606, yp = 40.625, color = "white", order = 6, respondable = false, visible = false, size = '7.8125%H', text = '50', bg = "black", },

		{ entity = 'drag',   key = 'chips_table_dragged', parent = 'chips_dots', order = 7, },
		{ entity = 'sprite', key = 'chips_table_dragged_content', parent = 'chips_table_dragged', order = 2, respondable = false, },
		{ entity = 'sprite', key = 'chips_table_dragged_frame', parent = 'chips_table_dragged_content', order = 2, wp = 95.0704, hp = 56.25, xp = 0, yp = 0, color = "black", visible = false, },

		{ entity = 'sprite', key = 'left_line',        parent = 'chips_dots', order = 2, visible = false, respondable = false, },
		{ entity = 'sprite', key = 'left_line_frame',  parent = 'left_line', order = 3, wp = 14.0845, hp = 48.4375, xp = 14.0845, yp = 54.6875, color = 'yellow', respondable = false, },
		{ entity = 'sprite', key = 'left_line_arrow',  parent = 'left_line', order = 4, wp = 4.57746, hp = 29.375, xp = 14.0845, yp = 54.6875, texture = 'game/bet/arrows/ic_up_b@2x.png', respondable = false, },
		{ entity = 'sprite', key = 'right_line',       parent = 'chips_dots', order = 2, visible = false, respondable = false, },
		{ entity = 'sprite', key = 'right_line_frame', parent = 'right_line', order = 3, wp = 14.0845, hp = 48.4375, xp = 89.4366, yp = 54.6875, color = 'yellow', respondable = false, },
		{ entity = 'sprite', key = 'right_line_arrow', parent = 'right_line', order = 4, wp = 4.57746, hp = 29.375, xp = 89.4366, yp = 54.6875, texture = 'game/bet/arrows/ic_up_b@2x.png', respondable = false, },

		{ entity = 'sprite', key = 'allin_left_layer',   parent = 'chips_dots', order = 2, visible = false, respondable = false, },
		{ entity = 'sprite', key = 'allin_left_frame',   parent = 'allin_left_layer', order = 3, wp = 17.6056, hp = 48.4375, xp = 15.8451, yp = 54.6875, color = 'yellow', },
		{ entity = 'sprite', key = 'allin_left_arrow',   parent = 'allin_left_layer', order = 4, wp = 4.57746, hp = 29.375, xp = 15.8451, yp = 54.6875, texture = 'game/bet/arrows/ic_up_b@2x.png', },
		{ entity = 'sprite', key = 'allin_left_area',    parent = 'allin_left_layer', order = 5, wp = 45.7746, hp = 54.6875, xp = 28.169, yp = 55.4688, visible = false, },
		{ entity = 'slider', key = 'allin_left_slider',  parent = 'allin_left_layer', order = 6, wp = 17.6056, hp = 7.8125, xp = 15.8451, yp = 33.4375, color = 'black', },
		{ entity = 'text',   key = 'allin_left_text',    parent = 'allin_left_slider', order = 6, wp = 17.6056, hp = 5.46875, xp = 8.80282, yp = 3.90625, text = 'STRING_DRAG_BOTH', size = '4.6875%H', respondable = false, },
		{ entity = 'sprite', key = 'allin_right_layer',  parent = 'chips_dots', order = 2, visible = false, respondable = false, },
		{ entity = 'sprite', key = 'allin_right_frame',  parent = 'allin_right_layer', order = 3, wp = 17.6056, hp = 48.4375, xp = 87.6761, yp = 54.6875, color = 'yellow', },
		{ entity = 'sprite', key = 'allin_right_arrow',  parent = 'allin_right_layer', order = 4, wp = 4.57746, hp = 29.375, xp = 87.6761, yp = 54.6875, texture = 'game/bet/arrows/ic_up_b@2x.png', },
		{ entity = 'sprite', key = 'allin_right_area',   parent = 'allin_right_layer', order = 5, wp = 45.7746, hp = 54.6875, xp = 75.3521, yp = 55.4688, visible = false, },
		{ entity = 'slider', key = 'allin_right_slider', parent = 'allin_right_layer', order = 6, wp = 17.6056, hp = 7.8125, xp = 87.6761, yp = 33.4375, color = 'black', },
		{ entity = 'text',   key = 'allin_right_text',   parent = 'allin_right_slider', order = 6, wp = 17.6056, hp = 5.46875, xp = 8.80282, yp = 3.90625, text = 'STRING_DRAG_BOTH', size = '4.6875%H', respondable = false, },

-- chips
		{ entity = 'sprite', key = 'main_chips_layer', parent = 'bet_top', order = 7, },

-- table
-- chips
-- drag
-- area
		{ entity = 'sprite', key = 'chips_drag_areas',      parent = 'bet_top', order = 5, visible = false, respondable = false, },
		{ entity = 'sprite', key = 'chips_area_bet',        parent = 'chips_drag_areas', order = 1, w = '100%W', hp = 13.4375, x = '50%W', yp = 93.2812, color = 'yellow', },
		{ entity = 'text',   key = 'chips_area_bet_text',   parent = 'chips_drag_areas', order = 2, wp = 26.4085, hp = 5.3125, xp = 51.7606, yp = 95.1562, color = 'black', bg = 'yellow', text = 'STRING_DRAG_BET', size = '4.6875%H', },
		{ entity = 'sprite', key = 'chips_area_bet_hl',     parent = 'chips_drag_areas', order = 3, w = '100%W', hp = 10.9375, x = '50%W', yp = 95.1562, color = 'green', max_opacity = 0.1, respondable = false, visible = false, },
		{ entity = 'sprite', key = 'chips_area_clear',      parent = 'chips_drag_areas', order = 1, w = '100%W', hp = 25.625, x = '50%W', yp = 12.8125, color = 'yellow', opacity = 1.0, },
		{ entity = 'text',   key = 'chips_area_clear_text', parent = 'chips_drag_areas', order = 2, wp = 26.4085, hp = 5.3125, xp = 51.7606, yp = 11.5625, color = 'black', bg = 'yellow', text = 'STRING_DRAG_CLEAR', size = '4.6875%H', },
		{ entity = 'sprite', key = 'chips_area_clear_hl',   parent = 'chips_drag_areas', order = 3, w = '100%W', hp = 23.125, x = '50%W', yp = 11.5625, color = 'green', max_opacity = 0.1, respondable = false, visible = false, },



-- only for presentation version
		{ entity = 'button', key = 'button_get_more_chips', parent = 'bet_top', order = 1, w = '100%W', hp = 10.625, x = '50%W', yp = 100-(10.625/2), color = 'blue', respondable = false, visible = false, },
		{ entity = 'text',   key = 'text_get_more_chips',   parent = 'button_get_more_chips', w = '100%W', hp = 10.625, x = '50%W', yp = 10.625/2, size = '5%H', text = 'Get More Chips (Presentation Mode)', color = 'white', respondable = false, },
	}
	return table
end

------------------------------------------------------------------------------------------
class 'TestMenuElements' (Screen)

------------------------------------------------------------------------------------------

function TestMenuElements:onInit()
	self.entities.btn_login:setOnClick(function()
		self:onLoginClick()
	end)

	self.scalableText1 = self:getEntityNamed('scalable1')
	self.scalableText2 = self:getEntityNamed('scalable2')

	self:initEditBox()
	self:initTextField()
end

------------------------------------------------------------------------------------------

function TestMenuElements:initEditBox()

-- EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS4
-- EDITBOX_INPUT_FLAG_SENSITIVE
-- EDITBOX_INPUT_MODE_DECIMAL
-- EDITBOX_INPUT_MODE_URL
-- EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD2
-- EDITBOX_INPUT_MODE_PHONENUMBER
-- EDITBOX_INPUT_FLAG_PASSWORD
-- EDITBOX_INPUT_MODE_NUMERIC
-- EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE3
-- EDITBOX_INPUT_MODE_SINGLELINE
-- EDITBOX_INPUT_MODE_EMAILADDR
-- EDITBOX_INPUT_MODE_ANY

	local function editboxEventHandler(eventType)
		if eventType == "began" then
			-- triggered when an edit box gains focus after keyboard is shown
			PRINT('EditBox event began')
		elseif eventType == "ended" then
			-- triggered when an edit box loses focus after keyboard is hidden.
			PRINT('EditBox event ended')
		elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
			PRINT('EditBox event changed')
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
			PRINT('EditBox event return')
		end
	end

	local edit = self.entities.editbox:getCocosEntity()
		edit:setFontSize(15)
		edit:setInputMode(0)
--			kEditBoxInputModeAny = 0,
--			kEditBoxInputModeEmailAddr,
--			kEditBoxInputModeNumeric,
--			kEditBoxInputModePhoneNumber,
--			kEditBoxInputModeUrl,
--			kEditBoxInputModeDecimal,
--			kEditBoxInputModeSingleLine
		edit:setFontName('')
		edit:setFontSize(15)
		edit:setFontColor(cc.c3b(255,255,255))
		edit:setPlaceHolder("_")
		edit:setPlaceholderFontColor(cc.c3b(255,255,255))
		edit:setMaxLength(8)
--		edit:setReturnType(EditBox::KeyboardReturnType::DEFAULT)
		edit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
		edit:registerScriptEditBoxHandler(editboxEventHandler)
end

function TestMenuElements:initTextField()
	local edit = self.entities.textfield:getCocosEntity()
end

------------------------------------------------------------------------------------------

function TestMenuElements:onLoginClick()
	startScene('Login')
end

------------------------------------------------------------------------------------------

function TestMenuElements:onUpdate(dt)
	if (self.scaleTime == nil) then
		self.scaleTime = 0
	end

	self.scaleTime = self.scaleTime + dt

	local scale1 = (1 + math.sin(self.scaleTime)) * 1
	local scale2 = (1 + math.sin(self.scaleTime)) * 0.2

	self.scalableText1:setScale(scale1, scale1)
	self.scalableText2:setScale(scale2, scale2)
end

------------------------------------------------------------------------------------------

function TestMenuElements:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%W', h = '100%H', x = '50%W', y = '50%H', color = 'yellow', order = 1, },

		{ entity = 'button', key = 'btn_login', wp = 30, hp = 15, xp = 75, y = '50%H', color = 'blue', order = 2, text = 'Email', textcolor = 'black', textsize = '14%H', },

		{ entity = 'text',   key = 'scalable1', w = '100%W', h = '6%H',  x = '25%W', y = '30%H', color = 'black', order = 1, text = 'Scalable', size = '5%H',  alignment = 'center', respondable = false, },
		{ entity = 'text',   key = 'scalable2', w = '100%W', h = '26%H', x = '25%W', y = '70%H', color = 'black', order = 1, text = 'Scalable', size = '25%H', alignment = 'center', respondable = false, },

		{ entity = 'editbox',   key = 'editbox',   w = 300, h = 200, x = '50%W', y = '30%H', color = 'yellow', order = 1, },
		{ entity = 'textfield', key = 'textfield', w = 300, h = 200, x = '50%W', y = '70%H', color = 'yellow', order = 1, },
	}
	return table
end

------------------------------------------------------------------------------------------
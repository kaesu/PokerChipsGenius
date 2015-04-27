class 'IntroduceScreen' (Screen)

------------------------------------------------------------------------------------------

function IntroduceScreen:onInit()
	SceneManager:shared():showScreen('MenuScreen', 5)
	SceneManager:shared():getScreenNamed('MenuScreen'):setMenuText('Introduce Yourself')
	SceneManager:shared():getScreenNamed('MenuScreen'):setLButtonStyle('arrow')
	SceneManager:shared():getScreenNamed('MenuScreen'):setRButtonStyle('accept')
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnLButtonClick(function()
		SceneManager:shared():startScene('StartScreen')
	end)
	SceneManager:shared():getScreenNamed('MenuScreen'):setOnRButtonClick(function()
		SceneManager:shared():startScene('MainMenuScreen')
	end)

	self.entities.edit_nickname:setText(SaveManager:shared():getString('NICKNAME'))

	self:initAvatar()
end

function IntroduceScreen:onDestroy()
	Screen.onDestroy(self)

	SaveManager:shared():setData('NICKNAME', self.entities.edit_nickname:getText())
end

------------------------------------------------------------------------------------------

function IntroduceScreen:initAvatar()
	local path  = SaveManager:shared():getSavingsDirectoryPath() .. '/images/fb_user_image.jpg'
	local exist = cc.FileUtils:getInstance():isFileExist(path)

	if (exist == false) then
		path = 'common/avatar.png'
	end

	local a = GET_SCREEN_HEIGHT() * 0.125
	local x = self.entities.avatar_bg:getWidth()  * 0.5
	local y = self.entities.avatar_bg:getHeight() * 0.4
	local image = Sprite(path, cc.size(a,a))
	image:setName('avatar')
	image:setPosition(x,y)
	image:setOrder(3)
	image:setMaskTexture('texture/common/mask.png')
	self.entities.avatar_bg:addChild(image)
end

------------------------------------------------------------------------------------------

function IntroduceScreen:makeContent()
	local table = {
		{ entity = 'sprite', key = 'bg', w = '100%', h = '100%', x = '50%', y = '50%', color = 'white', order = 1, },

		{ entity = 'sprite', key = 'avatar_bg',                               w = '100%W',  h = '25%H',   x = '50%W',   y = '75%H',  color = 'light_gray', order = 1, },
		{ entity = 'text',   key = 'avatar_text',   parent = 'avatar_bg',     w = '90%WP',  h = '12%HP',  x = '50%WP',  y = '80%HP', text = 'LOREM IPSUM DOLOR SIT AMET', color = 'black', size = '10%HP', order = 2, },
--		{ entity = 'sprite', key = 'avatar',        parent = 'avatar_bg',     w = '50%HP',  h = '50%HP',  x = '50%WP',  y = '40%HP', texture = 'common/avatar.png', mask = 'texture/common/mask.png', order = 3, },
		{ entity = 'sprite', key = 'avatar_frame',  parent = 'avatar_bg',     w = '50%HP',  h = '50%HP',  x = '50%WP',  y = '40%HP', texture = '', color = 'white', order = 4, opacity = 0, },
		{ entity = 'sprite', key = 'avatar_circle', parent = 'avatar_frame',  w = '33%WP',  h = '33%WP',  x = '100%WP', y = '50%HP', texture = 'common/circle.png', color = '#00c0a7', order = 5, },
		{ entity = 'sprite', key = 'avatar_edit',   parent = 'avatar_circle', w = '100%WP', h = '100%HP', x = '50%WP',  y = '50%HP', texture = 'common/edit.png', order = 6, },

		{ entity = 'editbox', key = 'edit_nickname', w = '95%W', h = '12.5%W', x = '50%W', y = '56.25%H', order = 5, placeholder = 'Nickname', },
	}
	return table
end

------------------------------------------------------------------------------------------
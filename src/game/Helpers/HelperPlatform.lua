Platform = {
	isAndroid = function()
		return (cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform())
	end,
	isDesktop = function()
		return Platform.isOSX()
	end,
	isIOS = function()
		return (Platform.isIPhone() or Platform.isIPad())
	end,
	isIPad = function()
		return (cc.PLATFORM_OS_IPAD == cc.Application:getInstance():getTargetPlatform())
	end,
	isIPhone = function()
		return (cc.PLATFORM_OS_IPHONE == cc.Application:getInstance():getTargetPlatform())
	end,
	isMobile = function()
		return (not Platform.isDesktop())
	end,
	isOSX = function()
		return (cc.PLATFORM_OS_MAC == cc.Application:getInstance():getTargetPlatform())
	end,
--	isBlackberry = function()
--		return (cc.PLATFORM_OS_BLACKBERRY == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isEmscripten = function()
--		return (cc.PLATFORM_OS_EMSCRIPTEN == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isLinux = function()
--		return (cc.PLATFORM_OS_LINUX == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isNacl = function()
--		return (cc.PLATFORM_OS_NACL == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isTizen = function()
--		return (cc.PLATFORM_OS_TIZEN == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isWindows = function()
--		return (cc.PLATFORM_OS_WINDOWS == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isWindowsRT = function()
--		return (cc.PLATFORM_OS_WINRT == cc.Application:getInstance():getTargetPlatform())
--	end,
--	isWinPhone8 = function()
--		return (cc.PLATFORM_OS_WP8 == cc.Application:getInstance():getTargetPlatform())
--	end,
}
class 'SceneWithWebView' (Screen)

------------------------------------------------------------------------------------------

function SceneWithWebView:onInit()
--	table.log(ccexp)
--	table.log(ccui)
--	table.log(cc)
--	table.log(ccb)
--	table.log(ccs)

--	local url = cc.FileUtils:getInstance():fullPathForFilename('/phonegap/index.html')
	local url = 'http://localhost:8088/xampp/_PCG/index.html'

	if (cc.PLATFORM_OS_IPHONE == cc.Application:getInstance():getTargetPlatform()) then
		local webView = ccexp.WebView:create()
		webView:setPosition(568,320)
		webView:setContentSize(1136, 640)
--		webView:setContentSize(1136 * 0.9, 640 * 0.9)
		webView:loadURL(url)
		webView:setScalesPageToFit(true)

		self:getCocosEntity():addChild(webView, 1)
	end
end

------------------------------------------------------------------------------------------

function SceneWithWebView:makeContent()
	local table = {}
	return table
end

------------------------------------------------------------------------------------------
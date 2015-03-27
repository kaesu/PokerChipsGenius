class 'MusicManager' (Manager)

------------------------------------------------------------------------------------------

function MusicManager:onInit()
end

function MusicManager:onSceneRegistered()
end

function MusicManager:onSceneUnregistered()
end

------------------------------------------------------------------------------------------

function MusicManager:playMusic(filename)
--	filename = filename and filename or "background.mp3"
--	local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
--	cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
end

function MusicManager:playSound(filename)
--	filename = filename and filename or "effect1.wav"
--	local effectPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
--	cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
--	effectID = cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
--	cc.SimpleAudioEngine:getInstance():stopEffect(effectID)
end

function MusicManager:stopSound()
--	cc.SimpleAudioEngine:getInstance():stopEffect(effectID)
end

------------------------------------------------------------------------------------------
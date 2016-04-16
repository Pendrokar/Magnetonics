
function widget:GetInfo()
  return {
	name    = "Music",
	desc    = "plays music",
	author  = "jK",
	date    = "2012,2013",
	license = "GPL2",
	layer     = 0,
	enabled   = true  --  loaded by default?
  }
end

------------------------------------------

Spring.SetSoundStreamVolume(0)
local musicfiles = VFS.DirList(LUAUI_DIRNAME .. "Assets/music", "*.ogg")
local currentTrack = 0
local volume = 0.3
-- local volume = 1

function widget:Initialize()
	if (#musicfiles > 0) then
		currentTrack = math.random(#musicfiles)
		Spring.PlaySoundStream(musicfiles[ currentTrack ], volume)
	end
end

function widget:Update(dt)
	local playedTime, totalTime = Spring.GetSoundStreamTime()
	playedTime = math.floor(playedTime)
	totalTime = math.floor(totalTime)

	if(playedTime >= totalTime and #musicfiles > 1) then
		Spring.StopSoundStream()
		if(currentTrack == 1) then
			currentTrack = 2
			Spring.PlaySoundStream(musicfiles[ currentTrack ], volume)
		else
			currentTrack = 1
			Spring.PlaySoundStream(musicfiles[ currentTrack ], volume)
		end
		-- while(currentTrack ~= math.random(#musicfiles)) do
		-- 	Spring.PlaySoundStream(musicfiles[ currentTrack ], volume)
		-- end
	end
end

function widget:Shutdown()
	Spring.StopSoundStream()
end

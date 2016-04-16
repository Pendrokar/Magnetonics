local Sounds = {
	SoundItems = {
		--- RESERVED FOR SPRING, DON'T REMOVE
		IncomingChat = {
			--- always play on the front speaker(s)
			file = "sounds/beep4.wav",
			in3d = "false",
		},
		MultiSelect = {
			--- always play on the front speaker(s)
			file = "sounds/button9.wav",
			in3d = "false",
		},
		MapPoint = {
			--- respect where the point was set, but don't attuenuate in distace
			--- also, when moving the camera, don't pitch it
			file = "sounds/beep6.wav",
			rolloff = 0,
			dopplerscale = 0,
			maxconcurrent = 3,
		},
		FailedCommand = {
			file = "sounds/beep3.wav",
		},
		KOTHGained = {
			file = "sounds/gong_friendlyhill.wav",
			maxconcurrent = 3,
			in3d = "false",
			pitchmod = 0.05,
		},

		KOTHLost = {
			file = "sounds/sounds/gong_enemyhill.wav",
			maxconcurrent = 3,
			in3d = "false",
			pitchmod = 0.05,
		},

		default = {
			--- new since 89.0
			--- you can overwrite the fallback profile here (used when no corresponding SoundItem is defined for a sound)
			--gainmod = 0.35,
			pitchmod = 0.1,
			--pitch = 0.7,
			--in3d = true,
		},
		--- END RESERVED

--WEAPONS
--[[
		gclaser2_fire = {
			file = "sounds/gclaser2_fire.wav",
			rolloff=3, dopplerscale = 0, maxdist = 6000,


			priority = 10, --- higher numbers = less chance of cutoff
			maxconcurrent = 2, ---how many maximum can we hear?
		},
]]--
		--[[DefaultsForSounds = { -- this are default settings
			file = "ThisEntryMustBePresent.wav",
			gain = 1.0,
			pitch = 1.0,
			priority = 0,
			maxconcurrent = 16, --- some reasonable limits
			--maxdist = FLT_MAX, --- no cutoff at all
		},
		--- EXAMPLE ONLY!
		MyAwesomeSound = {
			file = "sounds/booooom.wav",
			preload, -- put in memory!
			loop,  -- loop me!
			looptime=1000, --- milliseconds!
			gain = 2.0, --- for uber-loudness
			pitch = 0.2, --- bass-test
			priority = 15, --- very high
			maxconcurrent = 1, ---only once
			--maxdist = 500, --- only when near
		},]]
	},
}

return Sounds

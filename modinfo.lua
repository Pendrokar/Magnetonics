-- http://springrts.com/wiki/Modinfo.lua
return {
	name = "Magnetonics",
	shortname = "mgn",
	game = "mgn",
	shortgame = "mgn",
	description = "A game of force instead of damage",
	--  url = "https://github.com/spring/rtsgame.sdd",
	version = "1.2", --when zipping .sdz for releasing make this a full integer like 1,2,3
	modtype = 1,
	depend = {
		'Spring content v1',
		"cursors.sdz",
	}
}

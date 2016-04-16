--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    magnetonics.lua
--  brief:   Stuff specifically for the game
--  author:  Yanis Lukes
--
--  Copyright (C) 2016.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Magnetonics",
		desc      = "Stuff specifically for the game",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

local selectedFactory = false

function widget:GameStart()
	-- Spring.SendCommands("ToggleLOS")

	if (Spring.GetSelectedUnitsCount() ~= 0) then
		return
	end

	Spring.SelectUnitArray(Spring.GetTeamUnits(Spring.GetMyTeamID()), true)
end
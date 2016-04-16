--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    global_los.lua
--  brief:   Disables fog of war
--  author:  Yanis Lukes
--
--  Copyright (C) 2016.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Global LOS",
		desc      = "Disables Fog of War for all players",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

function gadget:GameStart()
	if (Spring.IsCheatingEnabled()) then
		Spring.SendCommands("globallos")
	else
		Spring.SendCommands("cheat", "globallos", "cheat")
	end

	--[[
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		-- Spring.SendMessage("cheat")
		-- TODO: Activate for Spring 101+
		-- Spring.SetGlobalLos(teams[i], true)
	end
	--]]
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_mobile_factories.lua
--  brief:   Reattaches packed/deployed factories to selection
--  author:  Yanis Lukes
--
--  Copyright (C) 2016.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Mobile factories",
		desc      = "Reattaches packed/deployed factories to selection",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false  --  loaded by default?
	}
end

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
	if (builderID or teamID ~= Spring.GetMyTeamID()) then
		return
	end
	-- created through synced code

	if (Spring.GetSelectedUnitsCount() ~= 0) then
		return
	end

	Spring.SelectUnitArray({ unitID }, true)
end

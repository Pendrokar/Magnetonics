--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    magnetonics.lua
--  brief:   Responsible for all impulses
--  author:  Yanis Lukes
--
--  Copyright (C) 2016.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Magnetonics",
		desc      = "Responsible for all impulses",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false  --  loaded by default?
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local function ParseUnit(unitID)
	local targetType, _, otherUnitID = Spring.GetUnitWeaponTarget(unitID, 1)
	-- local  = Spring.GetUnitWeaponTarget(unitID, 1)
	if (
		targetType ~= 1
		-- or otherUnitID == nil
		-- or unitID == Spring.GetUnitWeaponTarget(otherUnitID, 1)
	) then
		return
	end

	local targetsTargetType, _, targetsUnitID = Spring.GetUnitWeaponTarget(otherUnitID, 1)
	if (
		targetsTargetType == 1
		and unitID == targetsUnitID
	) then
		Spring.Echo("Units are neutrelizing each others tractor beams")
		return
	end
	-- local unitPrimaryCommand = Spring.GetUnitCommands(unitID, -1)
	-- if (

	-- 	-- has a attack command
	-- 	unitPrimaryCommand == nil
	-- 	or unitPrimaryCommand[1] == nil
	-- 	or unitPrimaryCommand[1].id ~= CMD.ATTACK

	-- 	-- attacking another unit
	-- 	or unitPrimaryCommand[1].params[1] ~= nil

	-- 	or Spring.GetUnitMaxRange(unitID)
	-- ) then
	-- 	return
	-- end


	-- local otherUnitID = unitPrimaryCommand.params

	-- local otherUnitPrimaryCommand = Spring.GetUnitCommands(unitID, 1)
	-- Spring.Echo("Unit attacking")

	-- if (
	-- 	-- has a attack command
	-- 	otherUnitPrimaryCommand ~= nil
	-- 	and otherUnitPrimaryCommand[1].id == CMD.ATTACK

	-- 	-- attacking another unit
	-- 	and otherUnitPrimaryCommand[1].params[2] == nil

	-- 	and unitID == unitPrimaryCommand.params[1]
	-- ) then
	-- 	Spring.Echo("Units are neutrelizing each others tractor beams")
	-- 	return
	-- end

	-- unitPrimaryCommand = unitPrimaryCommand[1]
end

function gadget:GameFrame(frame)
	-- only do a check in slowupdate
	if (frame%16) ~= 0 then
		return
	end

	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		-- local unitPrimaryCommand = Spring.GetUnitCommands(allUnits[i], -1)
		-- Spring.Echo(unitPrimaryCommand[1].id == CMD.ATTACK)
		-- return
		ParseUnit(allUnits[i])
	end
end
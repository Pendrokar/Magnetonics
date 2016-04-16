--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    invulnerable_units.lua
--  brief:   Ignores all damage done to units
--  author:  Yanis Lukes
--
--  Copyright (C) 2016.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Invulnerable Units",
		desc      = "Ignores damage done to units",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local spAreTeamsAllied = Spring.AreTeamsAllied

-- Position unit above sealevel and add upward velocity, so that after being destroyed debris fly upward
local function UpwardDestruction(unitID, uposX, uposY, uposZ)
	if(uposX ~= nil) then
		Spring.SetUnitPosition(unitID, uposX, Spring.GetGroundHeight(uposX, uposZ) + 1, uposZ)
	end
	local uvelX, uvelY, uvelZ = Spring.GetUnitVelocity(unitID)
	Spring.SetUnitVelocity(unitID, uvelX, -(0.75*uvelY), uvelZ)
	Spring.DestroyUnit(unitID, true)
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
	-- Spring.Echo("Will I feel pain?")
	-- Spring.Echo("I feel no pain...")

	-- local uposX, uposY, uposZ = Spring.GetUnitPosition(unitID)

	if(weaponDefID < -3) then
		-- Spring.Echo("Unit annihilated")
		UpwardDestruction(unitID)
		return
	end

	-- buildings:
	-- if(weaponDefID > 0) then
	-- 	local uvelX, uvelY, uvelZ = Spring.GetUnitVelocity(unitID)
	-- 	-- Spring.SetUnitVelocity(unitID, uvelX, uvelY + 0.02, uvelZ)

	-- 	-- Check if force strong enoguht to deactivate buildings
	-- 	if(
	-- 		-- check if unarmed
	-- 		Spring.GetUnitMaxRange(unitID) < 1

	-- 		-- and (
	-- 		-- 	uvelX > 0.2
	-- 		-- 	or uvelZ > 0.2

	-- 		-- 	-- check speed
	-- 		-- 	or uvelY > 0.2
	-- 		-- )
	-- 	) then
	-- 		-- Deactivate
	-- 		Spring.SetUnitCOBValue(unitID, COB.ACTIVATION, false)
	-- 	end
	-- end

	-- no friendly fire... I mean impulse
	if attackerID ~= unitID and ((not attackerTeam) or spAreTeamsAllied(unitTeam, attackerTeam)) then
		-- Spring.Echo("Ally hit with impulse")
		return 0, 0
	else
		return 0
	end
end

function gadget:UnitEnteredWater(unitID)
	-- Due to a bug, a unit may be placed in water even though there is ground above it
	local uposX, uposY, uposZ = Spring.GetUnitPosition(unitID)

	if(Spring.GetGroundHeight(uposX, uposZ) < 0) then
		-- Spring.Echo("Unit in water annihilated")
		-- Spring.SetUnitVelocity
		UpwardDestruction(unitID, uposX, uposY, uposZ)
		return
	end
end

-- Unit landed
function gadget:UnitLeftAir(unitID)
	local uposX, uposY, uposZ = Spring.GetUnitPosition(unitID)
	if(uposX < 1 or uposZ < 1 or uposX > Game.mapSizeX or uposZ > Game.mapSizeZ) then
		-- Spring.Echo("Unit leaving map bounds annihilated")
		Spring.DestroyUnit(unitID, true);
		return
	end

	local uvelX, uvelY, uvelZ = Spring.GetUnitVelocity(unitID)
	if(uvelY < -10) then
		-- Spring.Echo("Unit heavily hitting ground annihilated")
		UpwardDestruction(unitID, uposX, uposY, uposZ)
		return
	end
end

-- function gadget:Initialize()
-- 	Spring.SetProjectileDamages( 1232, 1, "impulseFactor", 1000 )
-- end

-- function gadget:GameStart()
-- end
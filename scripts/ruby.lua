local spSetUnitWeaponState 	= Spring.SetUnitWeaponState
-- local spGetUnitWeaponState 	= Spring.GetUnitWeaponState

--Define the pieces of the weapon
local flare = piece "flare"
--define other pieces
local body = piece "pivot"

-- reload time in miliseconds
local reloadTime = 2

function invert(value)
	-- if(math.abs(value) > 1) then
		-- Shouldn't happen
	-- end
	if(value > 0) then
		return 1 - value
	else
		return -1 - value
	end
end

function script.Create()
	-- Move(flare, x_axis, 0)
	-- Move(flare, y_axis, 0)
	-- Move(flare, z_axis, 0)
	reloadTime = Spring.GetUnitWeaponState(unitID,1,"reloadTime") * 1000
end

----aimining & fire weapon
function script.AimFromWeapon()
	return flare
end

function script.QueryWeapon()
	return flare
end

function script.AimWeapon()
	-- Turn(turret, y_axis, heading, 1.9)
	-- Turn(flare, x_axis, -90)
	return true
end

function script.FireWeapon()
	-- local px, py, pz = Spring.GetUnitPosition(unitID)
	-- -- SendToUnsynced("lups_shockwave", px, py, pz, 4.0, 18, 0.13, false)
	-- local unitsInRange = Spring.GetUnitsInSphere(px, py, pz, 130)
	-- if (unitsInRange == nil or #unitsInRange <= 1) then
	-- 	return
	-- end

	-- local allyID = Spring.GetUnitAllyTeam(unitID)
	-- local tpx, tpy, tpz, distance, distanceRatio = 0, 0, 0, 0, 0
	-- for i=1,#unitsInRange do
	-- 	if(Spring.GetUnitAllyTeam(unitsInRange[i]) ~= allyID) then
	-- 		tpx, tpy, tpz = Spring.GetUnitPosition(unitsInRange[i])
	-- 		-- distance = math.sqrt((px - tpx)*(px - tpx) + (py - tpy)*(py - tpy) + (pz - tpz)*(pz - tpz))
	-- 		-- distanceRatio = distance / 130
	-- 		Spring.AddUnitImpulse(
	-- 			unitsInRange[i],
	-- 			2 + 10 * invert((tpx - px) / 130),
	-- 			10 * invert((tpy - py) / 130),
	-- 			2 + 10 * invert((tpz - pz) / 130)
	-- 		)
	-- 	end
	-- end
	-- Spring.Echo("30" .. " * invert((" .. tpx .. " - " .. px .. ")[" .. (tpx - px) .. "] / " .. 130 .. ")[" .. invert((tpx - px) / 130) .. "] = " .. 30 * invert((tpx - px) / 130))
	-- Spring.Echo("30" .. " * invert((" .. tpy .. " - " .. py .. ")[" .. (tpx - px) .. "] / " .. 130 .. ")[" .. invert((tpy - py) / 130) .. "] = " .. 30 * invert((tpy - py) / 130))
	-- Spring.Echo("30" .. " * invert((" .. tpz .. " - " .. pz .. ")[" .. (tpx - px) .. "] / " .. 130 .. ")[" .. invert((tpz - pz) / 130) .. "] = " .. 30 * invert((tpz - pz) / 130))
end

function script.RockUnit()
	-- Get closer
	spSetUnitWeaponState(unitID,1,"range",30)
	Sleep(reloadTime)
	spSetUnitWeaponState(unitID,1,"range",120)
end

---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (body, SFX.SHATTER)
	local px, py, pz = Spring.GetUnitPosition(unitID)
	Spring.PlaySoundFile("sounds/glass_break2.wav", 1.0, px, py, pz)
end
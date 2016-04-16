local sqrt = math.sqrt

--Define the pieces of the weapon
local flare = piece "flare"
--define other pieces
local body = piece "pivot"

function script.Create()
end

----aimining & fire weapon
function script.AimFromWeapon1()
	return flare
end

function script.QueryWeapon1()
	return flare
end

function script.AimWeapon1()
	return true
end

function script.FireWeapon1()
end

function script.TargetWeight1 ( targetUnitID )
	local upx, upy, upz = Spring.GetUnitPosition(unitID)
	local tpx, tpy, tpz = Spring.GetUnitPosition(targetUnitID)
	local distance = (upx - tpx)*(upx - tpx) + (upz - tpz)*(upz - tpz)
	if(distance < 300) then
		return 2
	end
	return 1
end

function script.BlockShot1( targetUnitID ) -- , userTarget
	if(targetUnitID == nil) then
		return false
	end
	-- if(userTarget) then
	-- 	return false
	-- end
	local upx, upy, upz = Spring.GetUnitPosition(unitID)
	local tpx, tpy, tpz = Spring.GetUnitPosition(targetUnitID)
	local distance = sqrt((upx - tpx)*(upx - tpx) + (upz - tpz)*(upz - tpz))

	-- Minimum range
	if(distance < 300) then
		return true
	end

	local tvx, tvy, tvz = Spring.GetUnitVelocity(targetUnitID)
	-- Don't fire if unit is leaving range
	if(sqrt((upx - tpx + tvx)*(upx - tpx + tvx) + (upz - tpz + tvz)*(upz - tpz + tvz)) < distance) then
		return true
	end

	return false
end


---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (body, SFX.SHATTER)
	local px, py, pz = Spring.GetUnitPosition(unitID)
	Spring.PlaySoundFile("sounds/glass_break2.wav", 1.0, px, py, pz)
end
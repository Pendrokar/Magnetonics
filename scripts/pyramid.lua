--Define the pieces of the weapon
local turret = piece "turret"
local barrel = piece "barrel"
local flare = piece "flare"
--define other pieces
local body = piece "base"

local useTractorBeam = false

function script.Create()

end

----aimining & fire weapon
function script.AimFromWeapon1()
	return turret
end

function script.AimFromWeapon2()
	return turret
end

function script.QueryWeapon1()
	return flare
end

function script.QueryWeapon2()
	return flare
end

function script.AimWeapon1( heading, pitch )
	--aiming animation: instantly turn the gun towards the enemy
	-- Turn(turret, y_axis, heading)
	-- Turn(barrel, x_axis, -pitch)
	return true
end

function script.AimWeapon2( heading, pitch )
	--aiming animation: instantly turn the gun towards the enemy
	-- Turn(turret, y_axis, heading)
	-- Turn(barrel, x_axis, -pitch)
	return true
end

function script.FireWeapon1()
end

function script.FireWeapon2()
end

function script.BlockShot1()
	-- return false
	if (useTractorBeam) then
		return true
	end
	return false
end

function script.BlockShot2()
	if (not useTractorBeam) then
		return true
	end
	return false
end

-- Switch impulse direction
function script.Activate()
	useTractorBeam = false
end

function script.Deactivate()
	useTractorBeam = true
end

---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (body, SFX.SHATTER)
	local px, py, pz = Spring.GetUnitPosition(unitID)
	Spring.PlaySoundFile("sounds/glass_break2.wav", 1.0, px, py, pz)
end
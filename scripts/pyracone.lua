--Define the pieces of the weapon
local flare = piece "flare"
--define other pieces
local body = piece "base"

function script.Create()

end

----aimining & fire weapon
function script.AimFromWeapon()
	return flare
end

function script.QueryWeapon()
	return flare
end

function script.AimWeapon()
	return true
end

function script.FireWeapon()
end

---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (body, SFX.SHATTER)
	local px, py, pz = Spring.GetUnitPosition(unitID)
	Spring.PlaySoundFile("sounds/glass_break2.wav", 1.0, px, py, pz)
end
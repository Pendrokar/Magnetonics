local body = piece "pivot"
local nano = piece "nano"

function script.Create()

end

--------BUILDING---------
function script.StopBuilding()
	SetUnitValue(COB.INBUILDSTANCE, 0)
end

function script.StartBuilding(heading, pitch)
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

function script.QueryNanoPiece()
	 return nano
end

---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (body, SFX.SHATTER)
	local px, py, pz = Spring.GetUnitPosition(unitID)
	Spring.PlaySoundFile("sounds/glass_break2.wav", 1.0, px, py, pz)
end
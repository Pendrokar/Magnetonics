local pivot = piece ('pivot')

local isActive = false
local isMoving = false
local staticUnit = "mex"

local function Deploy()
	local posX, posY, posZ = Spring.GetUnitPosition(unitID)
	local rotX, rotY, rotZ = Spring.GetUnitRotation(unitID)
	local unitTeam = Spring.GetUnitTeam(unitID)
	Spring.DestroyUnit(unitID, false)
	local staticUnitID = Spring.CreateUnit(staticUnit, posX, Spring.GetGroundHeight(posX, posZ), posZ, 0, unitTeam)

	Spring.SetUnitRotation(staticUnitID, rotX, rotY, rotZ)
end

function script.StartMoving()
	isMoving = true
end

function script.StopMoving()
	isMoving = false
	if (isActive) then
		StartThread(Deploy)
	end
end


function script.Activate()
	isActive = true
	if (isMoving == false) then
		StartThread(Deploy)
	end
	return 1
end

function script.Deactivate()
	isActive = false
	return 0
end

function script.Create()
end

function script.Killed(recentDamage, maxHealth)
	-- Explode (pivot, SFX.SHATTER)
end

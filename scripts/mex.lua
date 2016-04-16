
local pivot = piece ('pivot')

-- local mobileUnit = "mobilemex"

local SIG_OPEN = 1

-- local function Pack()
-- 	local posX, posY, posZ = Spring.GetUnitPosition(unitID)
-- 	local rotX, rotY, rotZ = Spring.GetUnitRotation(unitID)
-- 	local unitTeam = Spring.GetUnitTeam(unitID)
-- 	Spring.DestroyUnit(unitID, false)
-- 	local mobileUnitID = Spring.CreateUnit(mobileUnit, posX, posY, posZ, 0, unitTeam)
-- 	Spring.SetUnitRotation(mobileUnitID, rotX, rotY, rotZ)
-- end

local function Open()
	Signal(SIG_OPEN)
	SetSignalMask(SIG_OPEN)

	Spin (pivot, y_axis, math.rad(30))
	-- while true do
	-- 	EmitSfx(pivot, SFX.SMOKE)
	-- 	Sleep(66)
	-- end
end

function script.Activate()
	StartThread(Open)
end

-- function script.Deactivate()
-- 	if(GetUnitValue(COB.ACTIVATION) == 0) then
-- 		StartThread(Pack)
-- 	end
-- end

function script.Create()
end

function script.Killed(recentDamage, maxHealth)
	Explode (pivot, SFX.SHATTER)
end

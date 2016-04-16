--script for the facory
local nano1 = piece "octahedron1"
local nano2 = piece "octahedron2"
local nano3 = piece "octahedron3"
local nano4 = piece "octahedron4"
local buildspot = piece "pivot"

-- local mobileUnit = "mobileheavyfactory"

-- local function Pack()
-- 	local posX, posY, posZ = Spring.GetUnitPosition(unitID)
-- 	local rotX, rotY, rotZ = Spring.GetUnitRotation(unitID)
-- 	local unitTeam = Spring.GetUnitTeam(unitID)
-- 	Spring.DestroyUnit(unitID, false)
-- 	local mobileUnitID = Spring.CreateUnit(mobileUnit, posX, posY, posZ, 0, unitTeam)
-- 	Spring.SetUnitRotation(mobileUnitID, rotX, rotY, rotZ)
-- end

function script.Create()
end

function script.Killed()
end

--------BUILDING---------
function script.QueryBuildInfo()
	return buildspot	--the unit will be constructed at the position of this piece
end

function script.QueryNanoPiece()
	--create a new nano particle at one of the two "nano towers"
	local dice = math.random (1,4)

	if (dice == 1) then
		return nano1
	elseif (dice == 2) then
		return nano2
	elseif (dice == 3) then
		return nano3
	else
		return nano4
	end
end

function script.Activate()
	SetUnitValue(COB.YARD_OPEN, 1)
	SetUnitValue(COB.INBUILDSTANCE, 1)
	SetUnitValue(COB.BUGGER_OFF, 1)
	return 1
end

function script.Deactivate()
	SetUnitValue(COB.YARD_OPEN, 0)
	SetUnitValue(COB.INBUILDSTANCE, 0)
	SetUnitValue(COB.BUGGER_OFF, 0)

	-- deactivation button
	-- if(GetUnitValue(COB.ACTIVATION) == 0) then
	-- 	StartThread(Pack)
	-- end

	return 0
end


function script.StartBuilding()
	--animation
	Spin (nano1, y_axis, math.rad(140))
	Spin (nano2, y_axis, -math.rad(140))
	Spin (nano3, y_axis, math.rad(140))
	Spin (nano4, y_axis, -math.rad(140))
end

function script.StopBuilding()
	--animation
	StopSpin (nano1, y_axis)
	StopSpin (nano2, y_axis)
	StopSpin (nano3, y_axis)
	StopSpin (nano4, y_axis)
end
---------------------
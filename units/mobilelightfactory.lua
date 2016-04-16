local unitName = "mobilelightfactory"

local unitDef =
{
-- Internal settings
	Category = [[UNARMED MOBILE LAND]],
	ObjectName = "lightfactory.s3o",
	script = "mobilelightfactory.lua",
	buildPic = "placeholder.png",
-- Unit limitations and properties
	Description = "Factory for creating light units.",
	MaxDamage = 1500,
	Name = "Light Factory (Mobile)",
	RadarDistance = 0,
	SightDistance = 0,
	Upright = 0,
	-- levelground = 1,
	--cost
	buildCostMetal = 200,
	buildCostEnergy = 0,
	buildTime = 25,

	buildDistance = 120,

	--economy
	EnergyStorage = 0,
	EnergyUse = 0,
	MetalStorage = 0,
	EnergyMake = 0,
	MakesMetal = 0,
	MetalMake = 0,

-- Pathfinding and related
	mass = 200,
	FootprintX = 5,
	FootprintZ = 5,
	MaxSlope = 20,
	MovementClass = [[DEFAULT5]],
	TurnRate = 200,

	onoffable = true,

	collisionVolumeTest    = 0,

	--Movement
	Acceleration = 0.05,
	BrakeRate = 0.1,
	MaxVelocity = 1.0,

-- Building
	activateWhenBuilt = false,
	Builder = false,
	Reclaimable = false,
	ShowNanoSpray = true,
	canBeAssisted = false,
	canStop = true,

	canAttack = false,
	canAssist = false,
	canRestore = false,
	canRepair = false,
	canReclaim = false,
	canResurrect = false,
	canCapture = false,

	-- Orders for new units:
	fireState = 2,
	canFireControl = true,

	canGuard = true,
	canMove = true,
	canPatrol = true,
	canFight = true,
	canRepeat = true,

	workerTime = 1,
	buildoptions =
	{
		"pyramid",
	},
}

return lowerkeys({ [unitName] = unitDef })
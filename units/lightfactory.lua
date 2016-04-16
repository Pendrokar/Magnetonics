local unitName = "lightfactory"

local unitDef =
{
-- Internal settings
	Category = [[UNARMED PLANT LAND]],
	ObjectName = "lightfactory.s3o",
	TEDClass = "PLANT",
	script = "lightfactory.lua",
	buildPic = "lightfactory.png",
-- Unit limitations and properties
	Description = "Factory for creating light mobile units.",
	MaxDamage = 100,
	Name = "Light Factory",
	RadarDistance = 0,
	SightDistance = 0,
	Upright = 1,
	levelground = 0,
	--cost
	buildCostMetal = 200,
	buildCostEnergy = 0,
	buildTime = 30,
	--economy
	EnergyStorage = 0,
	EnergyUse = 0,
	MetalStorage = 0,
	EnergyMake = 0,
	MakesMetal = 1,
	MetalMake = 0,

-- Pathfinding and related
	mass = 500,
	FootprintX = 5,
	FootprintZ = 5,
	MaxSlope = 10,
	YardMap ="ccccc ccccc ccccc ccccc ccccc",

	collisionVolumeTest    = 0,

	sightDistance          = 273,

-- Building
	activateWhenBuilt = true,
	Builder = true,
	Reclaimable = true,
	ShowNanoSpray = true,
	canBeAssisted = false,

	onoffable = true,
	canStop = true,

	canAttack = false,
	canAssist = false,
	canRestore = false,
	canRepair = false,
	canReclaim = false,
	canResurrect = false,
	canCapture = false,

	-- Orders for new units:
	canGuard = true,
	canMove = true,
	canPatrol = true,
	canFight = true,
	canRepeat = true,

	workerTime = 1,
	buildoptions =
	{
		"recycler",
		"pyramid",
		"pyracone",
		-- "mobilemex",
	},

	sounds = {
		select = "glass_break_builder",
		build = {
			{ file = "glass_break_construct" },
			{ file = "glass_break_construct2" },
		},
	}
}

return lowerkeys({ [unitName] = unitDef })
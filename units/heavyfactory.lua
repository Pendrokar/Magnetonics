local unitName = "heavyfactory"

local unitDef =
{
-- Internal settings
	Category = [[UNARMED PLANT LAND]],
	ObjectName = "heavyfactory.s3o",
	TEDClass = "PLANT",
	script = "heavyfactory.lua",
	buildPic = "heavyfactory.png",
-- Unit limitations and properties
	Description = "Factory for creating specialized mobile units.",
	MaxDamage = 100,
	Name = "Heavy Factory",
	RadarDistance = 0,
	SightDistance = 0,
	Upright = 1,
	levelground = 0,
	--cost
	buildCostMetal = 300,
	buildCostEnergy = 0,
	buildTime = 40,
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
		"ruby",
		"cone",
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
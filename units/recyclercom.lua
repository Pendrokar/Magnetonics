local unitName = "recyclercom"

local unitDef = {
	name = "Recycler",
	Description = "Builder and can also destroy buildings by reclaiming them.",
	objectName = "icosahedron.s3o",
	script = "recycler.lua",
	buildPic = "recycler.png",

	--cost
	buildCostMetal = 60,
	buildCostEnergy = 0,
	buildTime = 10,

	buildDistance = 120,

	mass = 40,

	--Health
	maxDamage = 100,
	idleAutoHeal = 0,

	--Movement
	Acceleration = 0.13,
	BrakeRate = 0.15,
	FootprintX = 3,
	FootprintZ = 3,
	MaxSlope = 70,
	MaxVelocity = 4.0,
	MaxWaterDepth = 20,
	MovementClass = [[ALLTERRAN3]],
	TurnRate = 800,

	collisionVolumeOffsets = [[0 5 0]],
	collisionVolumeScales  = [[45 80 45]],
	collisionVolumeTest    = 0,
	collisionVolumeType    = [[ellipsoid]],

	onoffable = false,

	sightDistance = 1000,
	airSightDistance = 1000,
	-- blind
	-- sightDistance = 0,
	-- airSightDistance = 0,
	-- losEmitHeight = 0,

	Builder = true,
	Reclaimable = false,
	CanAttack = false,
	CanGuard = true,
	CanMove = true,
	CanPatrol = false,
	CanStop = true,
	LeaveTracks = false,

	canRestore = true,
	canRepair = true,
	canReclaim = true,
	canResurrect = false,
	canCapture = false,

	Category = [[UNARMED BUILDER MOBILE LAND]],

	workerTime = 2,
	buildoptions =
	{
		"lightfactory",
		"heavyfactory",
		"mex",
	},

	sounds = {
		select = "glass_break_select",
		build = {
			{ file = "glass_break_construct" },
			{ file = "glass_break_construct2" },
		},
	}
}

return lowerkeys({ [unitName] = unitDef })
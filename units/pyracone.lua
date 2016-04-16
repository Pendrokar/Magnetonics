local unitName = "pyracone"

local unitDef = {
	name = "Pyracone",
	Description = "Advanced attack unit that is able to push multiple targets.",
	objectName = "pyracone.s3o",
	script = "pyracone.lua",
	buildPic = "pyracone.png",

	--cost
	buildCostMetal = 120,
	buildCostEnergy = 0,
	buildTime = 15,

	mass = 70,

	--Health
	maxDamage = 100,
	idleAutoHeal = 0,

	Reclaimable = false,

	--Movement
	Acceleration = 0.15,
	BrakeRate = 0.25,
	FootprintX = 3,
	FootprintZ = 3,
	MaxSlope = 70,
	MaxVelocity = 4.0,
	MaxWaterDepth = 20,
	MovementClass = [[ALLTERRAN3]],
	TurnRate = 800,

	collisionVolumeOffsets = [[0 10 0]],
	collisionVolumeScales  = [[50 90 50]],
	collisionVolumeTest    = 0,
	collisionVolumeType    = [[ellipsoid]],

	onoffable = false,

	sightDistance = 500,
	airSightDistance = 500,
	-- blind
	-- sightDistance = 0,
	-- airSightDistance = 0,
	-- losEmitHeight = 0,

	Builder = false,
	CanAttack = true,
	CanGuard = true,
	CanMove = true,
	CanPatrol = true,
	CanStop = true,
	LeaveTracks = false,

	strafeToAttack = true,

	Category = [[ARMED MOBILE LAND]],
	noChaseCategory = [[BUILDING]],

	weapons = {
		[1]={
			name  = "conepushbeam",
			onlyTargetCategory = [[MOBILE]],
			badTargetCategory = [[BUILDING]],
			-- energyPerShot = 0.1
		},
		[2]={
			name  = "conepushbeam",
			onlyTargetCategory = [[MOBILE]],
			badTargetCategory = [[BUILDING]],
			-- energyPerShot = 0.1
		},
		[3]={
			name  = "conepushbeam",
			onlyTargetCategory = [[MOBILE]],
			badTargetCategory = [[BUILDING]],
			-- energyPerShot = 0.1
		}
	},

	sounds = {
		select = "glass_break_select",
	}
}

return lowerkeys({ [unitName] = unitDef })
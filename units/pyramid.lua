local unitName = "pyramid"

local unitDef = {
	name = "Pyramid",
	Description = "Main attack unit. Can switch impulse direction.",
	objectName = "rolling_pyramid.s3o",
	script = "pyramid.lua",
	buildPic = "pyramid.png",

	--cost
	buildCostMetal = 60,
	buildCostEnergy = 0,
	buildTime = 5,

	mass = 60,

	--Health
	maxDamage = 100,
	idleAutoHeal = 0,

	Reclaimable = false,

	--Movement
	Acceleration = 0.2,
	BrakeRate = 0.3,
	FootprintX = 3,
	FootprintZ = 3,
	MaxSlope = 70,
	MaxVelocity = 5.0,
	MaxWaterDepth = 20,
	MovementClass = [[ALLTERRAN3]],
	TurnRate = 1200,

	collisionVolumeOffsets = [[0 10 0]],
	collisionVolumeScales  = [[45 80 45]],
	collisionVolumeTest    = 0,
	collisionVolumeType    = [[ellipsoid]],

	activateWhenBuilt = true,
	onoffable = true,

	sightDistance = 1000,
	airSightDistance = 1000,
	-- blind
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
			name  = "pushbeam",
			onlyTargetCategory = [[MOBILE]],
			badTargetCategory = [[BUILDING]],
			-- energyPerShot = 0.1
		},
		[2]={
			name  = "pullbeam",
			onlyTargetCategory = [[MOBILE]],
			badTargetCategory = [[BUILDING]],
			-- energyPerShot = 0.1
		},
	},

	sounds = {
		select = "glass_break_select",
	}
}

return lowerkeys({ [unitName] = unitDef })
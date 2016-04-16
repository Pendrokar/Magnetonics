local unitName = "cone"

local unitDef = {
	name = "Cone",
	Description = "Pulls in a single target for others to push.",
	objectName = "cone.s3o",
	script = "cone.lua",
	buildPic = "cone.png",

	--cost
	buildCostMetal = 180,
	buildCostEnergy = 0,
	buildTime = 25,

	mass = 80,

	--Health
	maxDamage = 100,
	idleAutoHeal = 0,

	Reclaimable = false,

	--Movement
	Acceleration = 0.15,
	BrakeRate = 0.2,
	FootprintX = 3,
	FootprintZ = 3,
	MaxSlope = 70,
	MaxVelocity = 3.5,
	MaxWaterDepth = 20,
	MovementClass = [[ALLTERRAN3]],
	TurnRate = 800,

	collisionVolumeOffsets = [[0 20 0]],
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

	strafeToAttack = false,

	Category = [[ARMED MOBILE LAND]],
	noChaseCategory = [[BUILDING]],

	moveState = 0,
	fireState = 1,

	weapons = {
		[1]={
			name  = "conepullbeam",
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
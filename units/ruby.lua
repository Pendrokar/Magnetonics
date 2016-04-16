local unitName = "ruby"

local unitDef = {
	name = "Ruby",
	Description = "A heavy, but slow. Powerful, but very short range pusher.",
	objectName = "ruby.s3o",
	script = "ruby.lua",
	buildPic = "ruby.png",

	--cost
	buildCostMetal = 220,
	buildCostEnergy = 0,
	buildTime = 30,

	mass = 140,

	--Health
	maxDamage = 170,
	idleAutoHeal = 0,

	Reclaimable = false,

	--Movement
	Acceleration = 0.2,
	BrakeRate = 0.1,
	FootprintX = 3,
	FootprintZ = 3,
	MaxSlope = 70,
	MaxVelocity = 2.5,
	MaxWaterDepth = 20,
	MovementClass = [[ALLTERRAN3]],
	TurnRate = 800,

	collisionVolumeOffsets = [[0 50 0]],
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

	weapons = {
		-- {
		-- 	def  = [[MELEEDUMMY]],
		-- 	onlyTargetCategory = [[MOBILE]],
		-- 	badTargetCategory = [[BUILDING]],
		-- 	-- energyPerShot = 0.1
		-- },

		{
			name  = "rubypushbeam",
			onlyTargetCategory = [[MOBILE]],
			badTargetCategory = [[BUILDING]],
			-- energyPerShot = 0.1
		},
	},

	weaponDefs          = {
		MELEEDUMMY = {
			areaofeffect = 0,
			avoidfeature = false,
			craterareaofeffect = 0,
			craterboost = 0,
			cratermult = 0,
			edgeeffectiveness = 0,
			explosiongenerator = "",
			firesubmersed = false,
			impulseboost = 0,
			impulsefactor = 0,
			name = "Dummy Weapon",
			range = 30,
			reloadtime = 0.1,
			-- soundhitwet = "sizzle",
			-- soundhitwetvolume = 0.5,
			tolerance = 100000,
			weapontype = "Melee",
			weaponvelocity = 100000,
			damage = {
				default = 0,
			},
		},
	},

	sounds = {
		select = "ruby_select",
	}
}

return lowerkeys({ [unitName] = unitDef })
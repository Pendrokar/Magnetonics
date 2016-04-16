local weaponName = "rubypushbeam"
weaponDef = {
	-- TODO: Melee that spawns exploding projectile
	weaponType              = [[StarburstLauncher]],
	-- weaponType              = [[MissileLauncher]],
	-- weaponType              = [[Cannon]],
	-- weaponType              = [[Melee]],
	-- weaponType              = [[AircraftBomb]],
	name                    = "Repulser",
	-- beamlaser               = 1,
	--physics / aiming--
	allowNonBlockingAim     = true,
	avoidFriendly           = false,
	collideFriendly         = false,
	-- lineOfSight             = true,
	-- minIntensity            = 1,
	range                   = 140,
	reloadtime              = 2.0,
	-- sweepfire               = false,
	tolerance               = 5000,

	impulseFactor           = 40,

	--damage--
	noSelfDamage            = true,
	damage                  = {
		default = 50,
	},
	cameraShake             = 300,

	customParams           = {
	  lups_explodespeed = 1,
	  lups_explodelife = 0.6,
	  nofriendlyfire = 1,
	  timeslow_damagefactor = 3.75,
	},

	-- explosionGenerator      = [[custom:NONE]],
	explosionGenerator      = "",
	explosionSpeed          = 11,

	areaOfEffect            = 180,
	craterBoost             = 0,
	craterMult              = 0,

	--appearance--
	size                    = 1E-06,
	alwaysVisible           = true,
	rgbColor                = [[0 0 0]],
	soundStart              = "rubyweapon",
	soundTrigger            = true,
	explosionSpeed          = 10000,

	textures                = {
	  [[null]],
	  [[null]],
	  [[null]],
	  [[null]],
	},

	fireStarter             = 0,
	burnblow                = true,
	flightTime              = 0,

	-- edgeeffectiveness       = 1,
	-- tracks                  = false,
	myGravity               = 10,
	turnrate                = 10000,
	turret                  = true,
	startVelocity           = 100,
	weaponAcceleration      = 100,
	predictBoost            = 0,
	-- weaponTimer             = 0,
	weaponVelocity          = 100,
	--texture1                = [[null]],
	-- texture2                = [[null]],
	--texture3                = [[null]],
	--texture4                = [[null]],
	}
return lowerkeys({[weaponName] = weaponDef})
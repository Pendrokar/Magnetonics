local weaponName = "pushbeam"
weaponDef = {
	weaponType              = "BeamLaser",
	name                    = "De-Tractor Beam",
	beamlaser               = 1,
	--physics / aiming--
	allowNonBlockingAim     = true,
	beamTime                = 0.1,
	-- avoidFriendly           = false,
	collideFriendly         = false,
	lineOfSight             = true,
	minIntensity            = 1,
	range                   = 360,
	reloadtime              = 0.1,
	sweepfire               = false,
	targetMoveError         = 0.05,
	turret                  = true,
	tolerance               = 5000,

	impulseFactor           = 6,

	--damage--
	noSelfDamage            = true,
	damage                  = {
		default = 10,
		},
	areaOfEffect            = 8,
	craterBoost             = 0,
	craterMult              = 0,

	--appearance--
	alwaysVisible           = true,
	thickness               = 5,
	coreThickness           = 0.25,
	largeBeamLaser          = false,
	laserFlareSize          = 1,
	renderType              = 0,
	rgbColor                = [[1 0 0]],
	--soundStart              = "some sound file",
	--soundTrigger            = true,
	--texture1                = [[largelaser]],
	--texture2                = [[flare]],
	--texture3                = [[flare]],
	--texture4                = [[smallflare]],
	}
return lowerkeys({[weaponName] = weaponDef})
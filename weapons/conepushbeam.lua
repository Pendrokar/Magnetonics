local weaponName = "conepushbeam"
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
	range                   = 460,
	reloadtime              = 0.1,
	sweepfire               = false,
	targetMoveError         = 0.3,
	turret                  = true,
	tolerance               = 5000,

	impulseFactor           = 3,

	--damage--
	noSelfDamage            = true,
	damage                  = {
		default = 8,
		},
	areaOfEffect            = 8,
	craterBoost             = 0,
	craterMult              = 0,

	--appearance--
	alwaysVisible           = true,
	thickness               = 4,
	coreThickness           = 0.15,
	largeBeamLaser          = false,
	laserFlareSize          = 0.3,
	renderType              = 0,
	rgbColor                = [[1 1 0]],
	--soundStart              = "some sound file",
	--soundTrigger            = true,
	--texture1                = [[largelaser]],
	--texture2                = [[flare]],
	--texture3                = [[flare]],
	--texture4                = [[smallflare]],
	}
return lowerkeys({[weaponName] = weaponDef})
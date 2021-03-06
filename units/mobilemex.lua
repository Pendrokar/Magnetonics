local unitDef = {
  unitname               = [[mobilemex]],
  name                   = [[Metal Extractor (Mobile)]],
  description            = [[Produces Metal from metal spots]],
  acceleration           = 0.1,
  activateWhenBuilt      = false,
  bmcode                 = [[0]],
  brakeRate              = 0.05,
  buildAngle             = 2048,
  buildCostEnergy        = 0,
  -- buildCostEnergy        = 75,
  buildCostMetal         = 50,
  builder                = false,
  buildPic               = [[mex.png]],
  buildTime              = 10,
  category               = [[UNARMED MOBILE LAND]],
  collisionVolumeOffsets = [[0 40 0]],
  collisionVolumeScales  = [[50 100 50]],
  collisionVolumeTest    = 0,
  collisionVolumeType    = [[ellipsoid]],

  extractsMetal          = 0,
  energyUse              = 0,
  explodeAs              = [[SMALL_BUILDINGEX]],
  floater                = true,
  footprintX             = 3,
  footprintZ             = 3,
  iconType               = [[mex]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  levelGround            = false,
  mass                   = 99,
  maxDamage              = 100,
  maxSlope               = 255,
  maxVelocity            = 1.5,
  maxWaterDepth          = 5000,
  minCloakDistance       = 150,
  noAutoFire             = false,
  objectName             = [[hexsahedron.S3O]],
  onoffable              = true,
  script                 = "mobilemex.lua",
  seismicSignature       = 4,
  -- selfDestructAs         = [[SMALL_BUILDINGEX]],
  sightDistance          = 273,
  smoothAnim             = true,
  -- TEDClass               = [[METAL]],
  turnRate               = 600,
  waterline              = 1,
  workerTime             = 0,
  yardMap                = [[ooooooooo]],

  movementClass = [[DEFAULT2]],
  upright = 0,

  canGuard = true,
  canMove = true,
}

return lowerkeys({ mobilemex = unitDef })

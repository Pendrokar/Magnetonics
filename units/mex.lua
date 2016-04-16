local unitDef = {
  unitname               = [[mex]],
  name                   = [[Metal Extractor]],
  description            = [[Produces Metal from metal spots]],
  acceleration           = 0,
  activateWhenBuilt      = true,
  bmcode                 = [[0]],
  brakeRate              = 0,
  buildAngle             = 2048,
  buildCostEnergy        = 0,
  -- buildCostEnergy        = 75,
  buildCostMetal         = 20,
  builder                = false,
  buildPic               = [[mex.png]],
  buildTime              = 15,
  category               = [[UNARMED LAND]],
  collisionVolumeOffsets = [[0 40 0]],
  collisionVolumeScales  = [[50 80 50]],
  collisionVolumeTest    = 0,
  collisionVolumeType    = [[ellipsoid]],

  extractsMetal          = 0.0008,
  -- extractsMetal          = .0108,
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
  maxVelocity            = 0,
  maxWaterDepth          = 5000,
  minCloakDistance       = 150,
  noAutoFire             = false,
  objectName             = [[hexsahedron.S3O]],
  -- onoffable              = true,
  script                 = "mex.lua",
  seismicSignature       = 4,
  -- selfDestructAs         = [[SMALL_BUILDINGEX]],
  sightDistance          = 273,
  smoothAnim             = true,
  TEDClass               = [[METAL]],
  turnRate               = 0,
  waterline              = 1,
  workerTime             = 0,
  yardMap                = [[ooooooooo]],
}

return lowerkeys({ mex = unitDef })

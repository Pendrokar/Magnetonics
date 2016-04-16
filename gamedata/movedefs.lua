local moveDefs =
{
	DEFAULT2 = {
		name = "Default2x2",
		footprintX = 2,
		maxWaterDepth = 10,
		maxSlope = 30,
		crushStrength = 100,
	},

	DEFAULT3 = {
		name = "Default3x3",
		footprintX = 3,
		maxWaterDepth = 10,
		maxSlope = 30,
		crushStrength = 100,
	},

	HOVER2 = {
		name = "Hover2x2",
		footprintX = 2,
		maxWaterDepth = 5000,
		maxSlope = 20,
		crushStrength = 25,
		hover = true,
	},

	DEFAULT5 = {
		name = "Default5x5",
		footprintX = 5,
		maxWaterDepth = 10,
		maxSlope = 30,
		crushStrength = 100,
	},

	ALLTERRAN1 = {		--allterrain
		footprintx = 1,
		footprintz = 1,
		maxwaterdepth = 16,
		maxslope = 70,
		crushstrength = 5,
	},

	ALLTERRAN3 = {		--allterrain
		footprintx = 3,
		footprintz = 3,
		maxwaterdepth = 22,
		maxslope = 70,
		crushstrength = 150,
	},

	ALLTERRAN4 = {		--allterrain
		footprintx = 4,
		footprintz = 4,
		maxwaterdepth = 22,
		maxslope = 70,
		crushstrength = 500,
	},
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- convert from map format to the expected array format

local array = {}
local i = 1
for k,v in pairs(moveDefs) do
	v.heatmapping = false -- disable heatmapping
	array[i] = v
	v.name = k
	i = i + 1
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return array

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

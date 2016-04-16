----------------------------------------------------------------------------------------------------
--                                             TOOLS                                              --
--                    Helper functions, that can be used in different modules                     --
----------------------------------------------------------------------------------------------------

local math_floor = math.floor
local string_format = string.format

----------------------------------------------------------------------------------------------------
local CheckBounds = function( value, minValue, maxValue )
	return ( value < minValue ) and minValue or 
			( ( value > maxValue ) and maxValue or value )
end

----------------------------------------------------------------------------------------------------
local CalculateIconsCount = function( size, iconSize, spread )
	return math_floor( ( size + spread ) / ( iconSize + spread ) )
end

local function GetShortNumber( n )	
	if( n < 10000 ) then
		return string_format( "%.1f", n )
	elseif( n < 1000000 ) then
		return string_format( "%.1fk", n / 1000 )
	else
		return string_format( "%.1fm", n / 1000000 )
	end
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
TOOLS = {}
TOOLS.CheckBounds = CheckBounds
TOOLS.CalculateIconsCount = CalculateIconsCount
TOOLS.GetShortNumber = GetShortNumber
----------------------------------------------------------------------------------------------------
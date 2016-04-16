----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SpGetUnitDefID			= Spring.GetUnitDefID
local SpGetSelectedUnitsSorted	= Spring.GetSelectedUnitsSorted
local SpGetSelectedUnitsCounts	= Spring.GetSelectedUnitsCounts
local SpGetUnitHealth			= Spring.GetUnitHealth
local SpGetUnitFuel				= Spring.GetUnitFuel
local SpGetUnitResources		= Spring.GetUnitResources

local SpGetUnitTeam		= Spring.GetUnitTeam
local SpGetPlayerList	= Spring.GetPlayerList
local SpGetPlayerInfo	= Spring.GetPlayerInfo

local springUnitDefs	= UnitDefs
local springWeaponDefs	= WeaponDefs

local math_floor		= math.floor
local string_format		= string.format
----------------------------------------------------------------------------------------------------

local white		= "\255\255\255\255"
local green		= "\255\1\255\1"
local red		= "\255\255\1\1"
local yellow	= "\255\255\255\1"
local orange	= "\255\255\128\1"
local gray		= "\255\228\228\228"
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
local function GetUnitOwner( unitId )
	local teamID = SpGetUnitTeam( unitId )
	local playerlist = SpGetPlayerList( teamID )
	for i = 1, #playerlist do
		local owner, _, spectator = Spring.GetPlayerInfo( playerlist[ i ] )
		if( not spectator ) then
			return owner
		end
	end
	return ""
end

----------------------------------------------------------------------------------------------------
local function GetUnitTooltip( unitId )

	local unitDef = springUnitDefs[ SpGetUnitDefID( unitId ) ]
	if( not unitDef ) then
		return "Mystery"
	end
	
	local tooltip = yellow..GetUnitOwner( unitId ).." "..white..unitDef.humanName.."\n"
	tooltip = tooltip..unitDef.tooltip.."\n\n"
	if( unitDef.speed > 0 ) then
		tooltip = tooltip..( string_format( "Speed %i\n", unitDef.speed ) )
	end
	
	local weaponCount = #unitDef.weapons
	if( weaponCount > 0 ) then
		if( weaponCount == 1 ) then
			local weaponId = unitDef.weapons[ 1 ].weaponDef
			local weaponDef = springWeaponDefs[ weaponId ]
			
			local defaultDamage = weaponDef.damages[ 0 ]
			local burst = weaponDef.salvoSize * weaponDef.projectiles
			if( burst > 1 ) then
				tooltip = tooltip..( string_format( "Damage %i x%i  DPS %i   Range %i", 
					defaultDamage, burst,
					defaultDamage * burst / weaponDef.reload,
					weaponDef.range ) )
			else
				tooltip = tooltip..( string_format( "Damage %i   DPS %i   Range %i", 
					defaultDamage, 
					defaultDamage / weaponDef.reload,
					weaponDef.range ) )
			end
		else
			tooltip = tooltip..( string_format( "Weapons count %i   Max range %i",
									weaponCount,
									unitDef.maxWeaponRange ) )
		end
	end
	
	if( unitDef.buildSpeed > 0 ) then
		tooltip = tooltip .. "\nBuild speed " .. unitDef.buildSpeed
	end
		
	local health, maxHealth = SpGetUnitHealth( unitId )
	
	if( health ) then
		local healthPercent = health / maxHealth * 100
		local healthColor = healthPercent > 80 and green or ( healthPercent > 30 and yellow or red ) 
		local healthPercentText = healthColor..string_format( "%i", healthPercent )
		local healthText = string_format( "%i", health )
		tooltip = tooltip.."\nHealth "..healthText.." "..healthPercentText.."%"..white
	end

	local maxFuel = unitDef.maxFuel
	if( maxFuel > 0 ) then
		local fuel = SpGetUnitFuel( unitId )
		if( fuel ) then
			local fuelPercent = fuel / maxFuel * 100 
			tooltip = tooltip .. string_format( "  Fuel %i", fuel ) .. orange .. string_format( " %i%%", fuelPercent ) .. white
		end
	end
	tooltip = tooltip.."\n"
	
	local mMake, mUse, eMake, eUse = SpGetUnitResources( unitId )

	local dataExist = mMake and mUse and eMake and eUse
	
	if( dataExist ) then
		local metallBalance = mMake - mUse
		if( metallBalance ~= 0 ) then
			local metallSign = metallBalance > 0 and green.."+" or red
			local metallText = metallSign..string_format( "%.1f", metallBalance )..white
			tooltip = tooltip.."Metal  "..metallText
		end

		local energyBalance = eMake - eUse
		if( energyBalance ~= 0 ) then
			local energySign = energyBalance > 0 and green.."+" or red
			local energyText = energySign..string_format( "%.1f", energyBalance )..white
			if( metallBalance ~= 0 ) then
				tooltip = tooltip.."    Energy "..energyText
			else
				tooltip = tooltip.."Energy "..energyText
			end
		end
	end
	
	return tooltip.."\n"
end

----------------------------------------------------------------------------------------------------
local function GetSelectionTooltip()

	local selectedUnitsCount = 0

	local totalHealth, totalMaxHealth = 0, 0

	local totalMCost, totalECost = 0, 0
	local totalMMake, totalMUse = 0, 0
	local totalEMake, totalEUse = 0, 0
	
	local selectedUnits = SpGetSelectedUnitsSorted()
	
	local _, idList = next( selectedUnits )
	if( #idList == 1 and selectedUnits.n == 1 ) then
		return GetUnitTooltip( idList[ 1 ] )
	end
	
	for unitDefId, idList in pairs( selectedUnits ) do
		unitDef = springUnitDefs[ unitDefId ]
		
		if( unitDef ~= nil ) then
			local mCost = unitDef.metalCost
			local eCost = unitDef.energyCost
			totalMCost = ( mCost or 0 ) + totalMCost
			totalECost = ( eCost or 0 ) + totalECost

			local unitCount = #idList
			selectedUnitsCount = selectedUnitsCount + unitCount
			
			for i = 1, unitCount do
				local unitId = idList[ i ]
				local health, maxHealth = SpGetUnitHealth( unitId )
				local mMake, mUse, eMake, eUse = SpGetUnitResources( unitId )

				totalHealth =		( health or 0 ) + totalHealth
				totalMaxHealth =	( maxHealth or 0 ) + totalMaxHealth
				totalMMake =		( mMake or 0 ) + totalMMake
				totalMUse =			( mUse or 0 ) + totalMUse
				totalEMake =		( eMake or 0 ) + totalEMake
				totalEUse =			( eUse or 0 ) + totalEUse
			end
		end
	end
		
	local tooltip = "Units   "..selectedUnitsCount.."\n\n\n"
	
	tooltip = tooltip.."Cost   "..totalMCost.." m :: "..totalECost.." e".."\n"
	
	local healthText = string_format( "%i", totalHealth )
	local healthPercent = totalHealth / totalMaxHealth * 100
	local healthColor = healthPercent > 80 and green or ( healthPercent > 30 and yellow or red ) 
	local healthPercentText = healthColor..string_format( "%i", healthPercent )
	tooltip = tooltip .. "Health " .. healthText .. " " .. healthPercentText .. "%" .. white .. "\n"

	local metallBalance = totalMMake - totalMUse
	local energyBalance = totalEMake - totalEUse	
	if( metallBalance ~= 0 ) then
		local metallSign = metallBalance > 0 and green .. "+" or red
		local metallText = metallSign .. string_format( "%.1f", metallBalance ) .. white
		tooltip = tooltip .. "Metal  " .. metallText
	end
	if( energyBalance ~= 0 ) then
		local energySign = energyBalance > 0 and green .. "+" or red
		local energyText = energySign..string_format( "%.1f", energyBalance )..white
		if( metallBalance ~= 0 ) then
			tooltip = tooltip.."    Energy "..energyText
		else
			tooltip = tooltip.."Energy "..energyText
		end
	end
	
	return tooltip.."\n"
end

----------------------------------------------------------------------------------------------------
local function GetCommandTooltip( command )
	
	local unitDef = springUnitDefs[ -command.id ]
	if( not unitDef or command.disabled ) then
		return command.tooltip
	end
	
	local tooltip = yellow..unitDef.humanName..white.."\n"
	tooltip = tooltip..unitDef.tooltip.."\n\n"
	if( unitDef.speed > 0 ) then
		tooltip = tooltip..( string_format( "Speed %i\n", unitDef.speed ) )
	end
	
	local weaponCount = #unitDef.weapons
	if( weaponCount > 0 ) then
		if( weaponCount == 1 ) then
			local weaponId = unitDef.weapons[ 1 ].weaponDef
			local weaponDef = springWeaponDefs[ weaponId ]
			
			local defaultDamage = weaponDef.damages[ 0 ]
			local burst = weaponDef.salvoSize * weaponDef.projectiles
			if( burst > 1 ) then
				tooltip = tooltip..( string_format( "Damage %i x%i  DPS %i   Range %i", 
					defaultDamage, burst,
					defaultDamage * burst / weaponDef.reload,
					weaponDef.range ) )
			else
				tooltip = tooltip..( string_format( "Damage %i   DPS %i   Range %i", 
					defaultDamage, 
					defaultDamage / weaponDef.reload,
					weaponDef.range ) )
			end
		else
			tooltip = tooltip..( string_format( "Weapons count %i   Max range %i",
									weaponCount,
									unitDef.maxWeaponRange ) )
		end
	end
	
	tooltip = tooltip .. "\n"
	
	local special = ""
	if( unitDef.canCloak ) then
		special = special .. "Cloak"
	end
	
	if( unitDef.stealth ) then
		if( special ~= "" ) then
			special = special .. ", "
		end
		special = special .. "Radar stealth"
	end
	
	if( unitDef.buildSpeed > 0 ) then
		if( special ~= "" ) then
			special = special .. ", "
		end
		special = special .. "Build speed " .. unitDef.buildSpeed
	end
	
	if( special ~= "" ) then
		tooltip = tooltip .. yellow .. special .. white
	end

	tooltip = tooltip .. "\nHealth " .. green .. unitDef.health .. white

	local maxFuel = unitDef.maxFuel
	if( maxFuel > 0 ) then
		tooltip = tooltip .. "  Fuel " .. orange .. string_format( "%i", maxFuel ) .. white
	end
	
	tooltip = tooltip .. "\n"
	
	local selectedUnits = SpGetSelectedUnitsCounts()
	if( selectedUnits.n == 1 ) then
		unitDefId, unitCount = next( selectedUnits )
		local builderDef = springUnitDefs[ unitDefId ]
		if( builderDef.buildSpeed ) then
			local buildTime = math_floor( unitDef.buildTime / builderDef.buildSpeed * 1.065 + 0.5 )
			if( buildTime < 60 ) then
				tooltip = tooltip .. string_format( "Buildtime %i s    ", buildTime )
			elseif( buildTime < 3600 ) then
				local min = math_floor( buildTime / 60 )
				local sec = buildTime % 60
				tooltip = tooltip .. string_format( "Buildtime %02d:%02d    ", min, sec )
			else
				local hour = math_floor( buildTime / 3600 )
				local min = math_floor( ( buildTime % 3600 ) / 60 )
				local sec = buildTime % 60
				tooltip = tooltip .. string_format( "Buildtime %02d:%02d:%02d    ", hour, min, sec )
			end
		end
	end
	
	tooltip = tooltip .. "Cost  m " .. unitDef.metalCost .. "  e " .. unitDef.energyCost
	
	return tooltip
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
TOOLTIP_TOOLS = {}

TOOLTIP_TOOLS.GetUnitTooltip		= GetUnitTooltip
TOOLTIP_TOOLS.GetSelectionTooltip	= GetSelectionTooltip
TOOLTIP_TOOLS.GetCommandTooltip		= GetCommandTooltip
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
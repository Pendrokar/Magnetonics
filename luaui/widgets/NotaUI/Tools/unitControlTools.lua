
local SpGetSelectedUnitsCount = Spring.GetSelectedUnitsCount

local commandsById = {}

local orderCommands = {} -- attack, stop, move, patrol
local buildCommands = {} -- build units
local stateCommands = {} -- repeat on/off, on/off, trajectory low/high, production 25/50/75/100, etc
local otherCommands = {} -- stockpile, load, unload, etc

local ORDER_COMMANDS_LIST = {
	[0] = true,		--stop
	[20] = true,	--attack
	[5] = true,		--wait
	[10] = true,	--move
	[15] = true,	--patrol
	[16] = true,	--fight
	[25] = true,	--guard
}

local HIDDEN_COMMANDS_LIST = {
	[76] = true,	--load units clone
	[65] = true,	--selfd
	[9] = true,		--gatherwait
	[8] = true,		--squadwait
	[7] = true,		--deathwait
	[6] = true,		--timewait
	[40] = true,	--repair
}

local currentCommands = {}

local function RefreshCommands( commands )
	
	local orderCommandsCount = 0
	orderCommands = {}
	local buildCommandsCount = 0
	buildCommands = {}
	local stateCommandsCount = 0
	stateCommands = {}
	local otherCommandsCount = 0
	otherCommands = {}
	
	-- hide 'scatter' command if only one unit selected
	HIDDEN_COMMANDS_LIST[ 33658 ] = SpGetSelectedUnitsCount() == 1
	
	for index = 1, #commands do
		local cmd = commands[ index ]
		
		if(	cmd.id < 0 ) then --build building
			buildCommandsCount = buildCommandsCount + 1
			buildCommands[ buildCommandsCount ] = cmd
			
		elseif( cmd.type == 5 and #cmd.params > 1 ) then
			--Spring.Echo( "toggle cmd:" .. cmd.name )
			stateCommandsCount = stateCommandsCount + 1
			stateCommands[ stateCommandsCount ] = cmd
			
		elseif( ORDER_COMMANDS_LIST[ cmd.id ] ) then
			orderCommandsCount = orderCommandsCount + 1
			orderCommands[ orderCommandsCount ] = cmd
			
		elseif(	( cmd.action ~= nil ) and 
				( cmd.type ~= 18 ) and -- previous cmd page
				( cmd.type ~= 17 ) and -- next cmd page
				( cmd.type ~= 21 ) and -- page button
				( not HIDDEN_COMMANDS_LIST[ cmd.id ] ) ) then
			--Spring.Echo( "other cmd:" .. cmd.name )
			otherCommandsCount = otherCommandsCount + 1
			otherCommands[ otherCommandsCount ] = cmd
		end
	end
	
	currentCommands.orders = orderCommands
	currentCommands.builds = buildCommands
	currentCommands.states = stateCommands
	currentCommands.others = otherCommands
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
UNIT_CONTROL_TOOLS = {}

UNIT_CONTROL_TOOLS.currentCommands	= currentCommands
UNIT_CONTROL_TOOLS.RefreshCommands	= RefreshCommands
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
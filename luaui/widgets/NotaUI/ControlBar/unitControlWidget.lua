----------------------------------------------------------------------------------------------------
--                                      UNIT CONTROL WIDGET                                       --
--                                Build bar, states bar, order bar                                --
----------------------------------------------------------------------------------------------------

local includeDir = "LuaUI/Widgets/NotaUI/ControlBar/"
local CreateCommandBar = VFS.Include( includeDir.."commandBarWidget.lua" )

VFS.Include( includeDir .. "stateBar.lua" )
VFS.Include( includeDir .. "orderBar.lua" )
VFS.Include( includeDir .. "buildBar.lua" )		


----------------------------------------------------------------------------------------------------
-- local decalrations
----------------------------------------------------------------------------------------------------
local buttons = {}			-- contains all buttons for commands by command id

-- state config
local stateIconW = 70
local stateIconH = 25
local stateSpacingBetweenIcons = 2

-- order config
local orderIconW = 70
local orderIconH = 30
local orderSpacingBetweenIcons = 2

-- build config
-- nota build icons in fucking 126x96 resolution
local buildIconW = 126 / 2.4
local buildIconH = 96 / 2.4
local buildSpacingBetweenIcons = 1

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local OnUpdatingControl
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SpGetActiveCommand = Spring.GetActiveCommand
----------------------------------------------------------------------------------------------------

local dummyWidget = WIDGET.Create()

----------------------------------------------------------------------------------------------------
--                                       Unit Control Widget                                      --
----------------------------------------------------------------------------------------------------
local unitControlWidget = FRAME.Create() do
	unitControlWidget.backgroundColor = { 0, 0, 0, 0.2 }
	unitControlWidget.enableTopBorder = false
	unitControlWidget.enableBottomBorder = false
		
	local unitControlLayout = LAYOUT.Create( LAYOUT.verticalType ) do
		unitControlLayout.margin = { 10, 2, 10, 10 }
		
		-- Create state bar
		unitControlWidget.stateBar = CreateCommandBar( { autoHeight = true } ) do
			local stateBar = unitControlWidget.stateBar
			
			stateBar.iconW = stateIconW
			stateBar.iconH = stateIconH
			stateBar.iconSpacing = stateSpacingBetweenIcons
			
			stateBar.buttonStorage = buttons
			stateBar.CreateButton = STATEBAR.CreateButton
			stateBar.UpdateButton = STATEBAR.UpdateButton
		end
		
		-- Create order bar
		unitControlWidget.orderBar = CreateCommandBar( { autoHeight = true } ) do
			local orderBar = unitControlWidget.orderBar
			
			orderBar.iconW = orderIconW
			orderBar.iconH = orderIconH
			orderBar.iconSpacing = orderSpacingBetweenIcons
			
			orderBar.buttonStorage = buttons
			orderBar.CreateButton = ORDERBAR.CreateButton
			orderBar.UpdateButton = ORDERBAR.UpdateButton
		end
	
		-- Create build bar
		unitControlWidget.buildBar = CreateCommandBar() do
			local buildBar = unitControlWidget.buildBar
			
			buildBar.iconW = buildIconW
			buildBar.iconH = buildIconH
			buildBar.iconSpacing = buildSpacingBetweenIcons
			
			buildBar.buttonStorage = buttons
			buildBar.CreateButton = BUILDBAR.CreateButton
			buildBar.UpdateButton = BUILDBAR.UpdateButton
		end
		
		unitControlLayout:AppendWidget( unitControlWidget.stateBar, 0 )
		unitControlLayout:AppendWidget( unitControlWidget.orderBar, 0 )
		unitControlLayout:AppendWidget( unitControlWidget.buildBar, 1 )
	end
	unitControlWidget:SetLayout( unitControlLayout )
end

----------------------------------------------------------------------------------------------------
unitControlWidget.UpdateCommands = function( commands )
	local layout = unitControlWidget.layout
	unitControlWidget.stateBar:UpdateButtons( commands.states )
	unitControlWidget.orderBar:UpdateButtons( commands.others )
	unitControlWidget.buildBar:UpdateButtons( commands.builds )

	--[[
	if( unitControlWidget.buildBar.pageCount > 0 ) then
		layout.widgets[ 1 ] = unitControlWidget.buildBar
	else
		layout.widgets[ 1 ] = dummyWidget
	end
	--]]
end

----------------------------------------------------------------------------------------------------
local activeCommandId = nil
-- Check every game frame, that selection changed
unitControlWidget.OnUpdating = function( controlWidget )
	--( ) -> nil | number index (, number cmd_id, number cmd_type, string cmd_name)
	local _, id = SpGetActiveCommand() 
			
	if( activeCommandId == id ) then
		return
	end

	local lastButton = buttons[ activeCommandId ]
	if( lastButton ) then
		lastButton.selected = false
		lastButton.needRedraw = true
	end
		
	if( id ) then
		local button = buttons[ id ]
		if( button ) then
			button.selected = true
			button.needRedraw = true
			activeCommandId = id
		else
			activeCommandId = nil
		end
	else
		activeCommandId = id
	end
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
return unitControlWidget
----------------------------------------------------------------------------------------------------
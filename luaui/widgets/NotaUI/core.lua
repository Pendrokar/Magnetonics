----------------------------------------------------------------------------------------------------
--                                              CORE                                              --
--            Contains main widget callins, maintain UI creating, updating, settings              --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                            GLOBALS                                             --
----------------------------------------------------------------------------------------------------
MAX_SIZE = 4000

----------------------------------------------------------------------------------------------------
--                                            INCLUDES                                            --
----------------------------------------------------------------------------------------------------
local includeDir = "LuaUI/Widgets/NotaUI/"
VFS.Include( includeDir.."tools.lua" )
VFS.Include( includeDir.."widget.lua" )
VFS.Include( includeDir.."layout.lua" )

VFS.Include( includeDir.."frame.lua" )
VFS.Include( includeDir.."button.lua" )

VFS.Include( includeDir.."Tools/tooltipTools.lua" )
VFS.Include( includeDir.."Tools/unitControlTools.lua" )

VFS.Include( includeDir.."ControlBar/controlBarWidget.lua" )
VFS.Include( includeDir.."TopBar/topBarWidget.lua" )

SCREEN_WIDGET = nil
GAME_WIDGET = nil
----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local screenWidget
local screenLayout

local oldMinimapGeometry
----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SpGetSelectedUnitsCount	= Spring.GetSelectedUnitsCount
local SpTraceScreenRay			= Spring.TraceScreenRay
local SpGetMouseState			= Spring.GetMouseState

local string_format = string.format

local GetSelectionTooltip	= TOOLTIP_TOOLS.GetSelectionTooltip
local GetUnitTooltip		= TOOLTIP_TOOLS.GetUnitTooltip

local RefreshCommands	= UNIT_CONTROL_TOOLS.RefreshCommands
local currentCommands	= UNIT_CONTROL_TOOLS.currentCommands

local UpdateControlBar = CONTROL_BAR.UpdateControlBar

local MouseAboveWidget = WIDGET.MouseAbove
local MouseLeaveWidget = WIDGET.MouseLeave
local MouseDownWidget = WIDGET.MouseDown
local MouseUpWidget = WIDGET.MouseUp


local UpdateWidget	= WIDGET.Update
local DrawWidget	= WIDGET.Draw
local DestroyWidget	= WIDGET.Destroy

local SetWidgetGeometry	= WIDGET.SetGeometry
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--       Handler, called by Spring every time, when selected units commands states changed        --
----------------------------------------------------------------------------------------------------
local function CommandsHandler( xIcons, yIcons, cmdCount, commands )
	widgetHandler.commands   = commands
	widgetHandler.commands.n = cmdCount
	--widgetHandler:CommandsChanged()

	RefreshCommands( commands )
	
	UpdateControlBar( currentCommands )
	
	return "", xIcons, yIcons, {}, {}, {}, {}, {}, {}, {}, { [ 1337 ] = 9001 }
	--[[
	  return menuName, xIcons, yIcons,
         removeCmds, customCmds,
         onlyTextureCmds, reTextureCmds,
         reNamedCmds, reTooltipCmds, reParamsCmds,
         iconList
	--]]
end

----------------------------------------------------------------------------------------------------
--                                         WIDGET CALLLINS                                        --
----------------------------------------------------------------------------------------------------
function widget:Initialize()
	w, h = widgetHandler:GetViewSizes()
	
	screenWidget = WIDGET.Create() do
		SetWidgetGeometry( screenWidget, 0, 0, w, h )
	
		screenLayout = LAYOUT.Create( LAYOUT.horizontalType ) do
			screenLayout:AppendWidget( CONTROL_BAR.widget, 0 )
			
			GAME_WIDGET = WIDGET.Create() do
				local gameLayout = LAYOUT.Create( LAYOUT.verticalType ) do
					gameLayout:AppendWidget( TOP_BAR.widget )
				end
				GAME_WIDGET:SetLayout( gameLayout )
			end
			screenLayout:AppendWidget( GAME_WIDGET, 1 )
		end

		screenWidget:SetLayout( screenLayout )
	end
	SCREEN_WIDGET = screenWidget
	
	-- hide default spring ui
	Spring.SendCommands( "resbar 0" )
	
	Spring.SetDrawSelectionInfo( false ) --disables springs default display of selected units count
	Spring.SendCommands( "tooltip 0" )
	
	widgetHandler:ConfigLayoutHandler( CommandsHandler )
	Spring.ForceLayoutUpdate()

	oldMinimapGeometry = Spring.GetConfigString( "MiniMapGeometry", "2 2 200 200" )
	gl.SlaveMiniMap( true )
end

----------------------------------------------------------------------------------------------------
function widget:AddConsoleLine( line, _ )  -- second parameter - priority - not used
end

----------------------------------------------------------------------------------------------------
function widget:ViewResize( w, h )
	SetWidgetGeometry( screenWidget, 0, 0, w, h )
end

----------------------------------------------------------------------------------------------------
function widget:DrawScreen()
	--Spring.Echo( "DrawScreen" )
	DrawWidget( screenWidget )
end

----------------------------------------------------------------------------------------------------
function widget:Update()
	UpdateWidget( screenWidget )
end

--[[
function widget:GameFrame( n )
end

function widget:CommandNotify( id, params, options )
	Spring.Echo( "CommandNotify", id )
end

--]]

----------------------------------------------------------------------------------------------------
local mouseAboveOwner
function widget:IsAbove( x, y )

	local currentOwner = MouseAboveWidget( screenWidget, x, y )
	
	--Spring.Echo( x.." :: "..y, isAbove )
	if( currentOwner ~= mouseAboveOwner ) then
		if( mouseAboveOwner ) then
			MouseLeaveWidget( mouseAboveOwner )
		end
		mouseAboveOwner = currentOwner
	end
	
	if( mouseAboveOwner ) then
		return true
	end
end

local mousePressOwner
function widget:MousePress( x, y, mouseButton )
	if( not mousePressOwner ) then
		mousePressOwner = MouseDownWidget( screenWidget, x, y, mouseButton )
	end
	
	--Spring.Echo( "MousePress", mousePressOwner, mouseButton )
	if( mousePressOwner ) then
		return true
	end
end

function widget:MouseMove( x, y, dx, dy, button )
	if( mousePressOwner and mousePressOwner.OnMouseMove ) then
		mousePressOwner:OnMouseMove( x, y, dx, dy, button )
	end
end

function widget:MouseRelease( x, y, mouseButton )
	--Spring.Echo( "MouseRelease", mousePressOwner )
	if( mousePressOwner ) then
		MouseUpWidget( mousePressOwner, x, y, mouseButton )
		mousePressOwner = nil
	end
end

----------------------------------------------------------------------------------------------------
function widget:GetTooltip( x, y )
	--Spring.Echo( x.." :: "..y )
	if( mouseAboveOwner ) then
		return mouseAboveOwner.tooltip
	end
end

function widget:WorldTooltip( tooltipType )
	if( tooltipType == "ground" ) then
		 -- get mouse pointed coordinates 
		local mouseposx, mouseposy = SpGetMouseState()
		local pointedObject, pointedXYZ = SpTraceScreenRay( mouseposx, mouseposy,
			true, -- only coords
			true )-- use minimap
		
		if( pointedObject ) then
			local x, y, z = pointedXYZ[1], pointedXYZ[2], pointedXYZ[3]
			return string_format( "Position %i : %i \nAltitude %i\n\n", x, z, y )
		else
			return "Sky"
		end
		
	elseif( tooltipType == "selection" ) then
		return GetSelectionTooltip()
		
	elseif( tooltipType == "unit" ) then
		local mouseposx, mouseposy = SpGetMouseState()
		local pointedObject, unitId = SpTraceScreenRay( mouseposx, mouseposy,
			false, -- only coords
			true )-- use minimap
			
		if( pointedObject == "unit" and unitId ) then
			return GetUnitTooltip( unitId )
		end
	end
end


----------------------------------------------------------------------------------------------------
function widget:KeyPress( key, modifier, isRepeat )
end

function widget:KeyRelease( key, modifier )
end

----------------------------------------------------------------------------------------------------
function widget:GetConfigData()
end

function widget:SetConfigData( data )
end

----------------------------------------------------------------------------------------------------
function widget:Shutdown()
	DestroyWidget( screenWidget )
	
	-- restore resource bar
	Spring.SendCommands( "resbar 1" )
	
	-- restore minimap
	Spring.SendCommands( "minimap geometry " .. oldMinimapGeometry )
	gl.SlaveMiniMap( false )
	
	-- restore unit menu
	widgetHandler:ConfigLayoutHandler( true )
	Spring.ForceLayoutUpdate()
	
	-- restore tooltip
	Spring.SetDrawSelectionInfo( true )
	Spring.SendCommands( "tooltip 1" )
end

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
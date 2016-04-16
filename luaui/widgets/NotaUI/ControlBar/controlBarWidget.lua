----------------------------------------------------------------------------------------------------
--                                       CONTROL BAR WIDGET                                       --
--                Left bar, that contains tooltip, build menu, order menu, minimap                --
----------------------------------------------------------------------------------------------------

local minimapWidget
local unitMenuWidget
local tooltipWidget

local width = 234

local unitControlWidget

local controlBarWidget = WIDGET.Create() do
	controlBarWidget.minW = width

	local controlLayout = LAYOUT.Create( LAYOUT.verticalType ) do			
		local includeDir = "LuaUI/Widgets/NotaUI/ControlBar/"

		local tooltipWidget = VFS.Include( includeDir.."tooltipWidget.lua" )	
		
		unitControlWidget = VFS.Include( includeDir.."unitControlWidget.lua" )
		
		local minimapWidget = VFS.Include( includeDir.."minimapWidget.lua" )
		
		controlLayout:AppendWidget( minimapWidget, 0 )
		controlLayout:AppendWidget( unitControlWidget, 1 )
		controlLayout:AppendWidget( tooltipWidget, 0 )
	end
	controlBarWidget:SetLayout( controlLayout )
end
----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
CONTROL_BAR = {}
CONTROL_BAR.widget = controlBarWidget
CONTROL_BAR.UpdateControlBar = unitControlWidget.UpdateCommands
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
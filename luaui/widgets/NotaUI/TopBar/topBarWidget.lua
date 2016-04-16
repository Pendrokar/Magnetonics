----------------------------------------------------------------------------------------------------
--                                         TOP BAR WIDGET                                         --
--                                    Resource bar, clock, fps                                    --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                            INCLUDES                                            --
----------------------------------------------------------------------------------------------------
local includeDir = "LuaUI/Widgets/NotaUI/TopBar/"
VFS.Include( includeDir.."clockFpsBar.lua" )
VFS.Include( includeDir.."resourceBar.lua" )
----------------------------------------------------------------------------------------------------


local topBarH = 40
local resourceBarW = 300

local topBarWidget = WIDGET.Create() do
	topBarWidget.minH = topBarH
	
	local layout = LAYOUT.Create( LAYOUT.horizontalType ) do	
		local stretch = WIDGET.Create()
		layout:AppendWidget( stretch, 1 )
	
		local metallWidget = RESOURCE_BAR.Create( {
			resource = "metal",
			enableLeftBorder = true,
			backgroundColor = { 0, 0, 0, 0.2 },
		} )
		metallWidget.minW = resourceBarW
		layout:AppendWidget( metallWidget )

		local energyWidget = RESOURCE_BAR.Create( {
			resource = "energy",
			enableLeftBorder = false,
			backgroundColor = { 0, 0, 0, 0.2 },
		} )
		energyWidget.minW = resourceBarW
		layout:AppendWidget( energyWidget )
	end
	topBarWidget:SetLayout( layout )
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
TOP_BAR = {}
TOP_BAR.widget = topBarWidget
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
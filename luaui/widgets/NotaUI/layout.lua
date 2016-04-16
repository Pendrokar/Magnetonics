----------------------------------------------------------------------------------------------------
--                                             LAYOUT                                             --
--                             Container for widgets, maintain resize                             --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                           Constants                                            --
----------------------------------------------------------------------------------------------------
local horizontalLayoutType	= 1
local verticalLayoutType	= 2
local gridLayoutType		= 3

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local CreateLayout
local AppendLayoutWidget
local RemoveLayoutWidget
local ClearLayoutWidgets
local MoveLayout
local UpdateHorizontalLayout
local UpdateVerticalLayout
local UpdateGridLayout
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SetWidgetX		= WIDGET.SetX
local SetWidgetY		= WIDGET.SetY
local SetWidgetWidth	= WIDGET.SetWidth
local SetWidgetHeight	= WIDGET.SetHeight
local SetWidgetGeometry	= WIDGET.SetGeometry
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
CreateLayout = function( layoutType )
	local layout = {}
	
	layout.margin = { 0, 0, 0, 0 }
	layout.spacing = 0
	
	layout.widgets = {}
	layout.widgetsCount = 0
	
	layout.type = layoutType
		
	if( layout.type == verticalLayoutType ) then
		layout.Update = UpdateVerticalLayout
		
	elseif( layout.type == horizontalLayoutType ) then
		layout.Update = UpdateHorizontalLayout
		
	elseif( layout.type == gridLayoutType ) then
		layout.Update = UpdateGridLayout
		layout.widgetHorizontalCount = 0
		layout.widgetVerticalCount = 0
		layout.widgetW = 0
		layout.widgetH = 0
		
	else
		Spring.Echo( "WARNING: Layout type unknown!", layout.type )
	end
	
	layout.x = 0
	layout.y = 0
	layout.w = 0
	layout.h = 0
	
	layout.AppendWidget = AppendLayoutWidget
	layout.Move = MoveLayout
	layout.Clear = ClearLayoutWidgets
	
	return layout
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
AppendLayoutWidget = function( layout, widget, stretchFactor )
	widget.parentLayout = layout
	widget.stretch = stretchFactor or 0
	
	layout.widgetsCount = layout.widgetsCount + 1
	layout.widgets[ layout.widgetsCount ] = widget
	
	layout:Update()
end

RemoveLayoutWidget = function( layout, widgetIndex )
	local widget = layout.widgets[ widgetIndex ]
	
	if( widget ) then
		widget.parentLayout = nil
		table.remove( layout.widgets, widgetIndex )
		layout.widgetsCount = layout.widgetsCount - 1
	
		layout:Update()
	end
end

ClearLayoutWidgets = function( layout )
	local widgets = layout.widgets
	for i = 1, #widgets do
		widgets[ i ].parentLayout = nil
	end
	
	layout.widgets = {}
	layout.widgetsCount = 0
end

----------------------------------------------------------------------------------------------------
MoveLayout = function( layout, x, y, w, h )
	layout.x = x
	layout.y = y
	layout.w = w
	layout.h = h

	layout:Update()
end

----------------------------------------------------------------------------------------------------
UpdateHorizontalLayout = function( layout )
	local margin = layout.margin
	local x, y = layout.x + margin[ 1 ], layout.y + margin[ 2 ]
	local w, h = layout.w - margin[ 1 ] - margin[ 3 ], layout.h - margin[ 2 ] - margin[ 4 ]
	
	local widgets = layout.widgets
	local widgetsCount = layout.widgetsCount
	
	local totalMin = 0
	for i = 1, widgetsCount do
		local widget = widgets[ i ]
		totalMin = totalMin + widget.minW
		
		SetWidgetY( widget, y )
		SetWidgetHeight( widget, h )
	end
	
	local avialableSpread = w - totalMin

	local totalStretch = 0
	if( avialableSpread > 0 ) then
		for i = 1, widgetsCount do
			local widget = widgets[ i ]
			local widgetMaxStretch = 0
			
			if( widget.stretch > 0 ) then
				widgetMaxStretch = ( widget.maxW - widget.minW ) / avialableSpread
				
				if( widgetMaxStretch > 0 ) then
					local checkedStretch = ( widgetMaxStretch < widget.stretch ) and 
						widgetMaxStretch or widget.stretch
					totalStretch = totalStretch + checkedStretch
				end
			end
		end
	end
	
	local offset = x
	
	if( totalStretch > 0 ) then
		local part = avialableSpread / totalStretch
		
		for i = 1, widgetsCount do
			local widget = widgets[ i ]
			
			SetWidgetX( widget, offset )
			SetWidgetWidth( widget, widget.minW + part * widget.stretch )
			
			offset = offset + widget.w
		end
	else
		for i = 1, widgetsCount do
			local widget = widgets[ i ]
			SetWidgetX( widget, offset )
			SetWidgetWidth( widget, widget.minW )
			
			offset = offset + widget.w
		end
	end
end

----------------------------------------------------------------------------------------------------
UpdateVerticalLayout = function( layout )
	local margin = layout.margin
	local x, y = layout.x + margin[ 1 ], layout.y + margin[ 2 ]
	local w, h = layout.w - margin[ 1 ] - margin[ 3 ], layout.h - margin[ 2 ] - margin[ 4 ]
	
	local widgets = layout.widgets
	local widgetsCount = layout.widgetsCount
	
	local totalMin = 0
	for i = 1, widgetsCount do
		local widget = widgets[ i ]
		totalMin = totalMin + widget.minH
		
		SetWidgetX( widget, x )
		SetWidgetWidth( widget, w )
	end

	local totalStretch = 0
	
	local avialableSpread = h - totalMin
	if( avialableSpread > 0 ) then
		for i = 1, widgetsCount do
			local widget = widgets[ i ]
			local widgetMaxStretch = 0
			
			if( widget.stretch > 0 ) then
				widgetMaxStretch = ( widget.maxH - widget.minH ) / avialableSpread
				
				if( widgetMaxStretch > 0 ) then
					local checkedStretch = ( widgetMaxStretch < widget.stretch ) and 
						widgetMaxStretch or widget.stretch
					totalStretch = totalStretch + checkedStretch
				end
			end
		end
	end
	
	local offset = y + h
	
	if( totalStretch > 0 ) then
		local part = avialableSpread / totalStretch
		
		for i = 1, widgetsCount do
			local widget = widgets[ i ]
			SetWidgetHeight( widget, widget.minH + part * widget.stretch )
			offset = offset - widget.h
			
			SetWidgetY( widget, offset )
		end
	else
		for i = 1, widgetsCount do
			local widget = widgets[ i ]
			SetWidgetHeight( widget, widget.minH )
			offset = offset - widget.h
			
			SetWidgetY( widget, offset )
		end
	end
end

----------------------------------------------------------------------------------------------------
UpdateGridLayout = function( layout )

	local widgets = layout.widgets
	local widgetsCount = layout.widgetsCount
	if( widgetsCount == 0 or widgetHorizontalCount == 0 or widgetVerticalCount == 0 ) then
		return
	end

	local margin = layout.margin

	local widgetHorizontalCount = layout.widgetHorizontalCount
	local widgetVerticalCount = layout.widgetVerticalCount

	local widgetW, widgetH = layout.widgetW, layout.widgetH
	local spacing = layout.spacing
	local stepX, stepY = widgetW + spacing, widgetH + spacing

	local x = layout.x + margin[ 1 ]
	local t = layout.y + layout.h - widgetH
	local w, h = layout.w - margin[ 1 ], layout.h - margin[ 2 ]

	local widgetX, widgetY = x, t

	local widgetIndex = 1
	for line = 1, widgetVerticalCount do
		for col = 1, widgetHorizontalCount do
			if( widgetIndex > widgetsCount ) then
				return
			end

			SetWidgetGeometry( widgets[ widgetIndex ], widgetX, widgetY, widgetW, widgetH )

			widgetIndex = widgetIndex + 1
			widgetX = widgetX + stepX
		end

		widgetX = x
		widgetY = widgetY - stepY
	end
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
LAYOUT = {}
LAYOUT.horizontalType	= horizontalLayoutType
LAYOUT.verticalType		= verticalLayoutType
LAYOUT.gridType			= gridLayoutType

LAYOUT.Create		= CreateLayout
LAYOUT.AppendWidget	= AppendLayoutWidget
LAYOUT.RemoveWidget	= RemoveLayoutWidget
LAYOUT.ClearWidgets	= ClearLayoutWidgets
LAYOUT.Move			= MoveLayout
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                                             WIDGET                                             --
--                                        Base GUI object                                         --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local Create
local MouseAbove
local MouseLeft
local MouseDown
local MouseUp
local MouseIn
--
local Draw
--
local Update
--
local SetX
local SetY
local SetWidth
local SetHeight
local SetGeometry
--
local SetLayout
--
local Destroy
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glCreateList	= gl.CreateList
local glCallList	= gl.CallList
local glDeleteList	= gl.DeleteList

local CheckBounds = TOOLS.CheckBounds

local maxSize = MAX_SIZE
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
Create = function()
	local widget = {}
	
	widget.minW = 0
	widget.maxW = maxSize
	
	widget.minH = 0
	widget.maxH = maxSize
	
	SetGeometry( widget, 0, 0, 0, 0 )
	
	widget.stretch = 0
	widget.layout = nil
		
	widget.needRedraw = true
	widget.needUpdateGeometry = true
	
	widget.mouseAbove = false
	widget.mouseDown  = false
	
	widget.mouseRepeat = false
	widget.OnMouseEnter		= nil
	widget.OnMouseLeave		= nil
	widget.OnMouseMove		= nil
	widget.OnMouseDown		= nil
	widget.OnMouseUp		= nil
	
	widget.OnRedrawing	= nil
	widget.OnRendering	= nil
	
	widget.OnResizing	= nil
	
	widget.OnUpdating	= nil
	
	widget.SetLayout = SetLayout
	
	return widget
end

----------------------------------------------------------------------------------------------------
MouseAbove = function( widget, x, y )
	if( not MouseIn( widget, x, y ) ) then
		return nil
	end

	local layout = widget.layout
	if( layout ) then
		local children = layout.widgets
		for i = 1, layout.widgetsCount do
			local aboveWidget = MouseAbove( children[ i ], x, y )
			if( aboveWidget ) then
				return aboveWidget
			end
		end
	end
	
	if( widget.OnMouseEnter ) then
		if( not widget.mouseAbove ) then
			widget.mouseAbove = true
			widget:OnMouseEnter( x, y )
		end
		return widget
	end
end

MouseLeft = function( widget )
	widget.mouseAbove = false
	if( widget.OnMouseLeave ) then
		widget:OnMouseLeave()
	end
end

MouseDown = function( widget, x, y, button )
	if( not MouseIn( widget, x, y ) ) then
		return nil
	end
	
	local layout = widget.layout
	if( layout ) then
		local children = layout.widgets
		for i = 1, layout.widgetsCount do
			local child = children[ i ]
			local pressedWidget = MouseDown( child, x, y, button )
			if( pressedWidget ) then
				return pressedWidget
			end
		end
	end

	if( widget.OnMouseDown ) then
		if( not widget.mouseDown ) then
			widget.mouseDown = true
			widget:OnMouseDown( x, y, button )
		end
		
		return widget
	end
end

MouseUp = function( widget, x, y, button )
	widget.mouseDown = false
	if( widget.OnMouseUp ) then
		widget:OnMouseUp( x, y, button )
	end
end

MouseIn = function( widget, x, y )
	return ( x > widget.l ) and ( x < widget.r ) and ( y > widget.b ) and ( y < widget.t )
end

----------------------------------------------------------------------------------------------------
Draw = function( widget )

	local layout = widget.layout

	-- update geometry
	if( widget.needUpdateGeometry ) then
		if( widget.OnResizing ) then
			widget:OnResizing()
		end

		if( layout ) then
			layout:Move( widget.x, widget.y, widget.w, widget.h )
		end
				
		widget.needRedraw = true
		widget.needUpdateGeometry = false
	end

	-- redraw widget buffer
	if( widget.needRedraw ) then	
		if( widget.drawingListId ~= nil ) then
			glDeleteList( drawingListId )
			widget.drawingListId = nil
		end
		
		if( widget.OnRedrawing ) then
			widget.drawingListId = glCreateList( widget.OnRedrawing, widget )
		end
		widget.needRedraw = false
	end
	
	-- render widget buffer
	if( widget.drawingListId ) then
		glCallList( widget.drawingListId )
	end
	
	-- render widget, be careful - gl code executed here is very slow
	if( widget.OnRendering ) then
		widget:OnRendering()
	end
	
	-- draw child widgets
	if( layout ) then
		local children = layout.widgets
		for i = 1, layout.widgetsCount do
			local child = children[ i ]
			Draw( child )
		end
	end
end

----------------------------------------------------------------------------------------------------
Update = function( widget )
	if( widget.OnUpdating ) then
		widget:OnUpdating()
	end
	
	local layout = widget.layout
	if( layout ) then
		local children = layout.widgets
		for i = 1, layout.widgetsCount do
			local child = children[ i ]
			Update( child )
		end
	end
end

----------------------------------------------------------------------------------------------------
SetX = function( widget, x )
	widget.x = x
	widget.l = x
	widget.r = x + widget.w
	widget.needUpdateGeometry = true
end

SetY = function( widget, y )
	widget.y = y
	widget.b = y
	widget.t = y + widget.h
	widget.needUpdateGeometry = true
end
	
SetWidth = function( widget, w )
	widget.w = CheckBounds( w, widget.minW, widget.maxW )
	widget.r = w + widget.x
	widget.needUpdateGeometry = true
end

SetHeight = function( widget, h )
	widget.h = CheckBounds( h, widget.minH, widget.maxH )
	widget.t = h + widget.y
	widget.needUpdateGeometry = true
end

SetGeometry = function( widget, x, y, w, h )
	widget.x = x
	widget.w = w
	widget.l = x
	widget.r = x + w
	
	widget.y = y
	widget.h = h
	widget.b = y
	widget.t = y + h
	
	widget.needUpdateGeometry = true
end

----------------------------------------------------------------------------------------------------
SetLayout = function( widget, layout )
	widget.layout = layout
	if( layout ) then
		layout:Move( widget.x, widget.y, widget.w, widget.h )
	end
end

----------------------------------------------------------------------------------------------------
Destroy = function( widget )
	if( widget.drawingListId ) then
		glDeleteList( drawingListId )
	end
	
	local layout = widget.layout
	if( layout ) then
		local children = layout.widgets
		for i = 1, layout.widgetsCount do
			local child = children[ i ]
			Destroy( child )
		end
	end
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
WIDGET = {}

WIDGET.Create 		= Create

WIDGET.MouseAbove	= MouseAbove
WIDGET.MouseLeave	= MouseLeft
WIDGET.MouseDown	= MouseDown
WIDGET.MouseUp		= MouseUp

WIDGET.Draw			= Draw
WIDGET.Update		= Update

WIDGET.SetX			= SetX
WIDGET.SetY			= SetY
WIDGET.SetWidth		= SetWidth
WIDGET.SetHeight	= SetHeight
WIDGET.SetGeometry	= SetGeometry

WIDGET.Destroy		= Destroy
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                                             FRAME                                              --
--                               Widget that contains other widgets                               --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix

local glColor		= gl.Color
local glTranslate	= gl.Translate
local glRect		= gl.Rect

local WidgetCreate	= WIDGET.Create
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local CreateFrame
local RenderFrame
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
CreateFrame = function()
	local frame = WidgetCreate()
	
	frame.backgroundColor = { 0, 0, 0, 0 }
	frame.borderWidth = 1
	frame.borderColor = { 0, 0, 0, 1 }
	frame.enableTopBorder = true
	frame.enableLeftBorder = true
	frame.enableBottomBorder = true
	frame.enableRightBorder = true
	
	frame.OnRedrawing = RenderFrame
	
	return frame
end

----------------------------------------------------------------------------------------------------
RenderFrame = function( frame )
	glPushMatrix()
	
	local x, y, w, h = frame.x, frame.y, frame.w, frame.h
	
	glColor( frame.backgroundColor )
	glTranslate( x, y, 0 ) -- set drawing pointer

	glRect( w, h, 0, 0 )
	
	local borderWidth = frame.borderWidth
	
	if( borderWidth > 0 ) then
		glColor( frame.borderColor )
		
		--top
		if( frame.enableTopBorder ) then 
			glRect( 0, 0, w, borderWidth )							
		end
		
		--left
		if( frame.enableLeftBorder ) then 
			glRect( 0, 0, borderWidth, h )
		end
		
		--bottom
		if( frame.enableBottomBorder ) then 
			glRect( 0, h - borderWidth, w, h )
		end
		
		--right
		if( frame.enableRightBorder ) then 
			glRect( w - borderWidth, 0, w, h )
		end
	end
	
	glPopMatrix()
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
FRAME = {}
FRAME.Create = CreateFrame
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                                        OrderBar buttons                                        --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local CreateOrderButton
local UpdateOrderButton
local ClickOrderButton
local RenderOrderButton

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glTranslate	= gl.Translate
local glScale		= gl.Scale
local glScissor		= gl.Scissor
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix

local glColor		= gl.Color
local glTexture		= gl.Texture
local glTexRect		= gl.TexRect
local glRect		= gl.Rect
local glText		= gl.Text

local leftMouseButton	= 1
local middleMouseButton	= 2
local rightMouseButton  = 3

local red =		{ 1, 0, 0, 1 }
local yellow =	{ 1, 1, 0, 1 }
local green =	{ 0, 1, 0, 1 }
local white =	{ 1, 1, 1, 1 }
local black =	{ 0, 0, 0, 1 }
----------------------------------------------------------------------------------------------------
--                                    BUTTON LOGIC AND DRAWING                                    --
----------------------------------------------------------------------------------------------------
CreateOrderButton = function( command )
	local button = BUTTON.Create()
	
	button.id = command.id
	
	if( command.texture ~= "" ) then
		button.texture = command.texture
	end
	
	button.text = command.name
	
	button.backgroundColor = { 0, 0, 0, 0.4 }
		
	button.OnMouseDown = ClickOrderButton
	
	button.OnRedrawing = RenderOrderButton
	
	UpdateOrderButton( button, command )
		
	return button
end

----------------------------------------------------------------------------------------------------
UpdateOrderButton = function( button, command )
	if( button.text ~= command.name ) then
		button.text = command.name
		button.needRedraw = true
	end

	if( button.disabled ~= command.disabled ) then
		button.disabled = command.disabled
		button.needRedraw = true
	end
	
	if( button.tooltip ~= command.tooltip ) then
		button.tooltip = command.tooltip
		button.needRedraw = true
	end
end

----------------------------------------------------------------------------------------------------
ClickOrderButton = function( button )
	button.needRedraw = true
	--Spring.Echo( button.id )
	local _, _, left, _, right = Spring.GetMouseState()
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	local index = Spring.GetCmdDescIndex( button.id )

	if( left ) then
		Spring.SetActiveCommand( index, leftMouseButton, left, right, alt, ctrl, meta, shift )
	end
	if( right ) then
		Spring.SetActiveCommand( index, rightMouseButton, left, right, alt, ctrl, meta, shift )
	end
end

----------------------------------------------------------------------------------------------------
RenderOrderButton = function( button )
	glPushMatrix()
	
	local x, y, w, h = button.x, button.y, button.w, button.h
	glTranslate( x, y, 0 ) -- set drawing pointer
	
	if( button.texture ) then
		glColor( 1, 1, 1, 1 )
		glTexture( button.texture )
		glTexRect( w, h, 0, 0, true, true )
		glTexture( false )
	else
		glColor( button.backgroundColor )
		glRect( w, h, 0, 0 )
	end
	
	if( button.disabled ) then
		glColor( button.disabledColor )
		glRect( 0, 0, w, h )
	else
		if( button.selected ) then
			glColor( button.selectedColor )
			glRect( 0, 0, w, h )
		end
	
		if( button.mouseDown ) then
			glColor( button.pressedColor )
			glRect( 0, 0, w, h )
		elseif( button.mouseAbove ) then
			glColor( button.hoverColor )
			glRect( 0, 0, w, h )
		end
	end
	
	do
		glColor( button.borderColor )
		
		local borderWidth = button.borderWidth
		glRect( 0, 0, w, borderWidth )								--top
		glRect( 0, borderWidth, borderWidth, h )					--left
		glRect( borderWidth, h - borderWidth, w - borderWidth, h )	--bottom
		glRect( w - borderWidth, borderWidth, w, h )				--right
	end
	
	if( button.text ) then
		glColor( button.textColor )
		glText( button.text, w / 2, h / 2, button.fontSize, "cv0" )
	end
	
	glPopMatrix()
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
ORDERBAR = {}

ORDERBAR.CreateButton = CreateOrderButton
ORDERBAR.UpdateButton = UpdateOrderButton
----------------------------------------------------------------------------------------------------
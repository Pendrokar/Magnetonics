----------------------------------------------------------------------------------------------------
--                                        BuildBar buttons                                        --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local CreateBuildButton
local UpdateBuildButton
local ClickBuildButton
local RenderBuildButton

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

local GetCommandTooltip = TOOLTIP_TOOLS.GetCommandTooltip

local leftMouseButton	= 1
local middleMouseButton	= 2
local rightMouseButton  = 3

----------------------------------------------------------------------------------------------------
--                                    BUTTON LOGIC AND DRAWING                                    --
----------------------------------------------------------------------------------------------------
CreateBuildButton = function( command )
	local button = BUTTON.Create()
	
	button.id = command.id
	
	button.texture = "#" .. -command.id
	button.name = command.name
	button.textColor = { 0, 0, 0, 1 }
	button.fontSize = 12
		
	button.OnMouseDown = ClickBuildButton
	
	button.OnRedrawing = RenderBuildButton
	
	UpdateBuildButton( button, command )
		
	return button
end

----------------------------------------------------------------------------------------------------
UpdateBuildButton = function( button, command )
	if( button.stockpile ~= command.params[ 1 ] ) then
		button.stockpile = command.params[ 1 ]
		button.needRedraw = true
	end
	
	if( button.disabled ~= command.disabled ) then
		button.disabled = command.disabled
		button.needRedraw = true
	end
	
	local tooltip = GetCommandTooltip( command )
	if( button.tooltip ~= tooltip ) then
		button.tooltip = tooltip
		button.needRedraw = true
	end
end

----------------------------------------------------------------------------------------------------
ClickBuildButton = function( button )
	button.needRedraw = true
	
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
RenderBuildButton = function( button )
	glPushMatrix()
	
	local x, y, w, h = button.x, button.y, button.w, button.h
	glTranslate( x, y, 0 ) -- set drawing pointer
	
	glColor( 1, 1, 1, 1 )
	
	glTexture( button.texture )
	glTexRect( w, h, 0, 0, true, true )
	glTexture( false )
	
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
		
	glColor( button.borderColor )
	
	local borderWidth = button.borderWidth
	glRect( 0, 0, w, borderWidth )								--top
	glRect( 0, borderWidth, borderWidth, h )					--left
	glRect( borderWidth, h - borderWidth, w - borderWidth, h )	--bottom
	glRect( w - borderWidth, borderWidth, w, h )				--right
	
	if( button.stockpile ) then
		local offset = 3
		glColor( button.textColor )
		glText( button.stockpile, w - offset, offset, button.fontSize, "rO" )
	end
	
	glPopMatrix()
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
BUILDBAR = {}

BUILDBAR.CreateButton = CreateBuildButton
BUILDBAR.UpdateButton = UpdateBuildButton
----------------------------------------------------------------------------------------------------
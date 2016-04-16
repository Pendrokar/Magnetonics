----------------------------------------------------------------------------------------------------
--                                        StateBar buttons                                        --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local CreateStateButton
local UpdateStateButton
local ClickStateButton
local RenderStateButton

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
CreateStateButton = function( command )
	local button = BUTTON.Create()
	
	button.id = command.id
	
	if( command.texture ~= "" ) then
		button.texture = command.texture
	end
	
	button.name = command.name
	button.optionsCount = #command.params - 1
	button.optionColor = black
	
	button.backgroundColor = { 0, 0, 0, 0.4 }
		
	button.OnMouseDown = ClickStateButton
	
	button.OnRedrawing = RenderStateButton
	
	UpdateStateButton( button, command )
		
	return button
end

----------------------------------------------------------------------------------------------------
UpdateStateButton = function( button, command )
	local currentOption = command.params[ 1 ] + 1
	if( button.currentOption ~= currentOption ) then
		button.currentOption = currentOption
		button.text = command.params[ currentOption + 1 ]
		
		if( button.optionsCount < 4 ) then
			if( currentOption == 1 ) then
				button.currentOptionColor = red
			elseif( currentOption == 2 ) then
				if( button.optionsCount == 3 ) then
					button.currentOptionColor = yellow
				else
					button.currentOptionColor = green
				end
			else
				button.currentOptionColor = green
			end
		else
			button.currentOptionColor = white
		end
		
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
ClickStateButton = function( button )
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
RenderStateButton = function( button )
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
		glText( button.text, w / 2, h / 2 + 2, button.fontSize, "cv0" )
	end
	
	do
		local optionOffsetX = 3
		local optionSpreadX = 2
		local totalW = w - optionOffsetX * 2
		local optionMinCount = button.optionsCount < 4 and 4 or button.optionsCount
		local optionW = ( totalW + optionSpreadX ) / ( optionMinCount + optionSpreadX )
		local optionStepX = optionW + optionOffsetX
		local optionX = ( w - optionW * button.optionsCount - optionSpreadX * ( button.optionsCount - 1 ) ) / 2
		
		local optionOffsetY = 1
		local optionH = 4
		local optionY = optionH - optionOffsetY
		
		glTranslate( optionX, optionY, 0 )
		glColor( button.optionColor )
		
		for i = 1, button.optionsCount do
			if( i == button.currentOption ) then
				glColor( button.currentOptionColor )
				glRect( 0, 0, optionW, optionH )
				glColor( button.optionColor )
			end
			
			local borderWidth = 1
			glRect( 0, 0, optionW, borderWidth )								--top
			glRect( 0, borderWidth, borderWidth, optionH )					--left
			glRect( borderWidth, optionH - borderWidth, optionW - borderWidth, optionH )	--bottom
			glRect( optionW - borderWidth, borderWidth, optionW, optionH )				--right
			
			glTranslate( optionStepX, 0, 0 )
		end
	end
	
	glPopMatrix()
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
STATEBAR = {}

STATEBAR.CreateButton = CreateStateButton
STATEBAR.UpdateButton = UpdateStateButton
----------------------------------------------------------------------------------------------------
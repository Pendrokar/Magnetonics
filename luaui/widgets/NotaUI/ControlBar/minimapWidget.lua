----------------------------------------------------------------------------------------------------
--                                         MINIMAP WIDGET                                         --
--                                         Display minmap                                         --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glTranslate	= gl.Translate
local glScale		= gl.Scale
local glScissor		= gl.Scissor
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix

local glDrawMiniMap		= gl.DrawMiniMap
local glResetState		= gl.ResetState
local glResetMatrices	= gl.ResetMatrices

local glColor 		= gl.Color
local glRect		= gl.Rect

local SpSendCommands = Spring.SendCommands

local string_format = string.format
----------------------------------------------------------------------------------------------------

local mapRatio = Game.mapX / Game.mapY

local minimapWidget = FRAME.Create() do
	minimapWidget.minH = 220
	minimapWidget.backgroundColor = { 0, 0, 0, 0.2 }
	
	local minimapLayout = LAYOUT.Create( LAYOUT.verticalType ) do
		minimapLayout.margin = { 10, 10, 10, 10 }
		
		local minimap = WIDGET.Create() do
		
			minimap.OnResizing = function( minimap )
				minimap.needRedraw = true
			end
		
			minimap.OnRedrawing = function( minimap )
				local w, h = minimap.w, minimap.h
			
				local minimapRatio = w / h
				
				local borderOffset = 2
				local mapX, mapY, mapH, mapW
				--Spring.Echo( minimapRatio, mapRatio )
				if( minimapRatio < mapRatio ) then
					mapW = w - borderOffset * 2
					mapH = h * minimapRatio / mapRatio - borderOffset * 2
					mapX = minimap.x + borderOffset
					mapY = minimap.t - ( h - mapH ) / 2 - borderOffset
				else
					mapW = w * mapRatio / minimapRatio - borderOffset * 2
					mapH = h - borderOffset * 2
					mapX = minimap.x + ( w - mapW ) / 2 + borderOffset
					mapY = minimap.t - borderOffset
				end
				
				SpSendCommands( { string_format( "minimap geometry %i %i %i %i", 
					mapX, SCREEN_WIDGET.h - mapY, mapW, mapH ) } )
				
				glPushMatrix()
				
				glTranslate( mapX - 2, mapY - mapH - 1, 0 )
				glColor( { 0, 0, 0, 1 } )
				glRect( mapW + 4, mapH + 4, 0, 0 )
				
				glTranslate( 1, 1, 0 )
				glColor( { 1, 1, 1, 1 } )
				glRect( mapW + 2, mapH + 2, 0, 0 )
				
				glPopMatrix()
			end
			
			minimap.OnRendering = function( minimap )
				glDrawMiniMap()
				glResetState()
				glResetMatrices()
			end
		end
		
		minimapLayout:AppendWidget( minimap, 1 )
	end
	
	minimapWidget:SetLayout( minimapLayout )

end

return minimapWidget
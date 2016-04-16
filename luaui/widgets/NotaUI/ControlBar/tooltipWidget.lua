----------------------------------------------------------------------------------------------------
--                                         TOOLTIP WIDGET                                         --
----------------------------------------------------------------------------------------------------

local tooltipBackgroundColor = { 0, 0, 0, 0.2 }
local tooltipH = 100

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glTranslate	= gl.Translate
local glScale		= gl.Scale
local glScissor		= gl.Scissor
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix

local glColor 			= gl.Color
local glText			= gl.Text
local glGetTextWidth	= gl.GetTextWidth
local glGetTextHeight	= gl.GetTextHeight

local SpGetCurrentTooltip		= Spring.GetCurrentTooltip

local CheckBounds = TOOLS.CheckBounds
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Create widget
----------------------------------------------------------------------------------------------------
local textWidget

local tooltipWidget = FRAME.Create() do
	tooltipWidget.minH = tooltipH
	tooltipWidget.backgroundColor = tooltipBackgroundColor

	local tooltipLayout = LAYOUT.Create( LAYOUT.verticalType ) do
		tooltipLayout.margin = { 10, 10, 10, 10 }

		textWidget = WIDGET.Create()
		
		tooltipLayout:AppendWidget( textWidget, 1 )
	end
	tooltipWidget:SetLayout( tooltipLayout )
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
textWidget.OnRedrawing = function( tooltip )	
	--Spring.Echo( "Draw tooltip" )

	local text = tooltip.text
	
	local fontSize = 10
	
	local x, y = tooltip.x, tooltip.t - fontSize
	
	local maxCharsCount = 58
	
	local wrappedText = ""
	for line in text:gmatch( "([^\n]*)\n?" ) do
		if( line:len() > maxCharsCount ) then
			for i = 1, line:len(), maxCharsCount do
				wrappedText = wrappedText .. line:sub( i, i + maxCharsCount - 1 ) .. "\n"
			end
		else
			wrappedText = wrappedText .. line .. "\n"
		end
	end
	
	local ratioH = tooltip.w / ( glGetTextWidth( wrappedText ) * fontSize )
	local ratioV = tooltip.h / ( glGetTextHeight( wrappedText ) * fontSize	)
	
	ratioH = CheckBounds( ratioH, 0.8, 1 )
	ratioV = CheckBounds( ratioV, 0.8, 1 )
	
	glPushMatrix()
	glScissor( true )
	glScissor( x, tooltip.y, tooltip.w, tooltip.h )
	
	glScale( ratioH, ratioV, 1 )
	
	glColor( 1, 1, 1, 1 )
	
	glTranslate( x, y, 0 )
	glText( wrappedText, 0, 0, fontSize )
	
	glScissor( false )
	
	glPopMatrix()
end

----------------------------------------------------------------------------------------------------
textWidget.OnUpdating = function( tooltip )	
	local newTooltip = SpGetCurrentTooltip()
	
	if( tooltip.text ~= newTooltip ) then
		tooltip.text = newTooltip
		tooltip.needRedraw = true
	end
end

----------------------------------------------------------------------------------------------------
return tooltipWidget
----------------------------------------------------------------------------------------------------
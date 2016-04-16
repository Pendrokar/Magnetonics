----------------------------------------------------------------------------------------------------
--                                       RESOURCE BAR WIDGET                                      --
----------------------------------------------------------------------------------------------------

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

local math_log = math.log
local math_ceil = math.ceil
local string_format = string.format

local SpGetTeamResources = Spring.GetTeamResources
local SpSetShareLevel = Spring.SetShareLevel

local GetShortNumber = TOOLS.GetShortNumber
local CheckBounds = TOOLS.CheckBounds
----------------------------------------------------------------------------------------------------

local myTeamId = Spring.GetMyTeamID()

local redStr = "\255\255\1\1"
local greenStr = "\255\1\255\1"
local yellowStr = "\255\255\255\1"
local whiteStr = "\255\255\255\255"
local blackStr = "\255\1\1\1"

local black = { 0.0, 0.0, 0.0, 1.0 }
local white = { 1.0, 1.0, 1.0, 1.0 }
local green = { 0.0, 0.7, 0.0, 1.0 }
local red   = { 7.0, 0.0, 0.0, 1.0 }
local blue  = { 0.0, 0.0, 1.0, 1.0 }
local yellow= { 1.0, 1.0, 0.0, 1.0 }
local gray  = { 0.5, 0.5, 0.5, 1.0 }

local iconOffset = 10
local iconSize = 24

local textSize = 80
local textOffsetLeft = 50
local textOffsetRight = 0

local incomeRequestTextSizeW = 20

local barOffset = 5

local bigFontSize = 16
local fontSize = 12

local backgroundOffsetX = 3
local backgroundH = 19

local thumbW = 5

local metallTooltip =	"Metal bar\n" ..
						"Show current metal amount and maximum storage\n" ..
						"Press mouse button to setup metal sharing\n\n" ..
						"Current share level "..yellowStr
						
local energyTooltip =	"Energy bar\n" ..
						"Show current energy amount and maximum storage\n" ..
						"Press mouse button to setup energy sharing\n\n" ..
						"Current share level "..yellowStr

----------------------------------------------------------------------------------------------------
local CreateBarWidget = function( properties )
	local widget = FRAME.Create() do
		widget.storage = 0
		widget.current = 0
		widget.income  = 0
		widget.request = 0
		widget.expense = 0
		widget.receive = 0
		widget.share   = 0
		
		widget.resource = properties.resource
		widget.enableLeftBorder = properties.enableLeftBorder
		widget.backgroundColor = properties.backgroundColor
		
		local path = "::LuaUI/Widgets/NotaUI/TopBar/"
		widget.texture = path .. widget.resource .. ".png"
		
		widget.bigFontSize = bigFontSize
		widget.fontSize = fontSize
	
		local layout = LAYOUT.Create( LAYOUT.horizontalType ) do
			layout.margin = { 5, 5, 5, 5 }
			widget.icon = WIDGET.Create() do
				
				local icon = widget.icon
				
				icon.minW = iconOffset * 2 + iconSize
				icon.texture = widget.texture
				
				function icon:OnRedrawing()
					glPushMatrix()
						
						local x, y, w, h = self.x, self.y, self.w, self.h
					
						glTranslate( x + iconOffset, y + ( h - iconSize ) / 2, 0 )
					
						glColor( white )
						
						glTexture( self.texture )
							glTexRect( iconSize, iconSize, 0, 0, true, true )
						glTexture( false )
						
					glPopMatrix()
				end
				
			end
			
			widget.balanceLabel = WIDGET.Create() do
				
				local balanceLabel = widget.balanceLabel
				
				balanceLabel.minW = textSize
				balanceLabel.resourceWidget = widget

				function balanceLabel:OnRendering()
					glPushMatrix()
					
					local widget = self.resourceWidget
					local x, y, w, h = self.x, self.y, self.w, self.h
					glTranslate( x, y, 0 )
					
					glPushMatrix()
						
						--widget.request = 9999
						--widget.income = 100
						local balance = widget.income - widget.request
					
						glTranslate( textOffsetLeft / 2, h / 2, 0 )
						if( balance > 0 ) then
							glText( greenStr .. GetShortNumber( balance ), 0, 0, widget.bigFontSize, "cvo" )
						else
							glText( redStr .. GetShortNumber( balance ), 0, 0, widget.bigFontSize, "cvo" )
							
							if( widget.current < widget.request ) then
								local percent = string_format( redStr .. "%i %%", widget.income / widget.request * 100 )
								glTranslate( 0, - 13, 0 )
								glText( percent, 0, 0, 9, "cvo" )
							end
						end
					glPopMatrix()
					
					--[[
					glPushMatrix()
						glTranslate( backgroundOffsetX, h, 0 )
						glText( redStr .. GetShortNumber( widget.request ), 0, 0, widget.fontSize, "tO" )
					glPopMatrix()
					--]]
					
					glPopMatrix()
				end
			end
			
			widget.incomeRequestLabel = WIDGET.Create() do
				local incomeRequestLabel = widget.incomeRequestLabel
				incomeRequestLabel.resourceWidget = widget
				incomeRequestLabel.minW = incomeRequestTextSizeW
				
				function incomeRequestLabel:OnRendering()
					glPushMatrix()
						
						local widget = self.resourceWidget
						local x, y, w, h = self.x, self.y, self.w, self.h
						
						glTranslate( x + w - 3, y + h / 4, 0 )
						glText( redStr .. GetShortNumber( widget.request ), 0, 0, widget.fontSize, "rvo" )
						
						glTranslate( 0, h / 2, 0 )
						glText( greenStr .. GetShortNumber( widget.income ), 0, 0, widget.fontSize, "rvo" )
						
					
					glPopMatrix()
				end
			end
			
			widget.bar = BUTTON.Create() do
				local bar = widget.bar
				bar.resourceWidget = widget
				bar.barColor = widget.resource == "metal" and gray or yellow
				bar.backgroundColor = black
				
				bar.OnRendering = function( bar )
					glPushMatrix()
						
						local x, y, w, h = bar.x, bar.y, bar.w, bar.h
						glTranslate( x, y, 0 )
						
						local backgroundW = w - backgroundOffsetX * 2
						
						glPushMatrix()
							glTranslate( backgroundOffsetX, ( h - backgroundH ) / 2, 0 )
							glColor( black )
							glRect( backgroundW, backgroundH, 0, 0 )
							
							glTranslate( 1, 1, 0 )
							glColor( white )
							glRect( backgroundW - 2, backgroundH - 2, 0, 0 )
							
							glTranslate( 1, 1, 0 )
							glColor( bar.backgroundColor )
							glRect( backgroundW - 4, backgroundH - 4, 0, 0 )
						glPopMatrix()
						
						local widget = bar.resourceWidget
						
						local barH = backgroundH - 6
						local barW = ( backgroundW - 6 ) * widget.current / widget.storage
						
						glPushMatrix()
							glTranslate( backgroundOffsetX + 3, ( h - barH ) / 2, 0 )
							glColor( bar.barColor )
							glRect( barW, barH, 0, 0 )
						glPopMatrix()

						local thumbColor = red
						local thumbH = barH
						local thumbBandW = w - backgroundOffsetX * 2 - thumbW - 6
						local thumbX = backgroundOffsetX + 3 + thumbBandW * widget.share
						
						glPushMatrix()
							glTranslate( thumbX, ( h - thumbH ) / 2, 0 )
							glColor( thumbColor )
							glRect( thumbW, thumbH, 0, 0 )
						glPopMatrix()

					glPopMatrix()
				end
				
				bar.mouseRepeat = true
				
				bar.OnMouseDown = function( bar, x, y, button )
					
					local pos = x - bar.x - backgroundOffsetX - thumbW / 2 - 3
					local totalX = bar.w - backgroundOffsetX * 2 - thumbW - 6
					local level = pos / totalX					
					SpSetShareLevel( bar.resourceWidget.resource, CheckBounds( level, 0, 1 ) )
					
					--Spring.Echo( bar.resourceWidget.resource, CheckBounds( level, 0, 1 ) )
				end
				
				bar.OnMouseMove = function( bar, x, y, dx, dy, button )
					bar:OnMouseDown( x, y, button )
				end
			
				bar.OnMouseEnter = function()
				end
			
				local barLayout = LAYOUT.Create( LAYOUT.horizontalType ) do
					
					widget.currentLabel = WIDGET.Create() do
						local currentLabel = widget.currentLabel
						currentLabel.resourceWidget = widget
						
						function currentLabel:OnRendering()
							glPushMatrix()
							
								local widget = self.resourceWidget
								glTranslate( self.x + self.w / 2, self.y + self.h / 2 - 1, 0 )
								
								glText( whiteStr .. 
										GetShortNumber( widget.current ) .. " / " .. 
										GetShortNumber( widget.storage ), 
										0, 0, widget.fontSize, "cvs" )
							
							glPopMatrix()
						end
					end
					
					barLayout:AppendWidget( widget.currentLabel, 1 )
				end
				
				bar:SetLayout( barLayout )
			end
			
			widget.economizer = WIDGET.Create() do
				local economizer = widget.economizer
				economizer.resourceWidget = widget

				--[[
				economizer.OnResizing = function( e )
					Spring.Echo( e.x, e.y, e.w, e.h )
				end
				--]]

				economizer.OnRedrawing = function( economizer )
					glPushMatrix()
					
					local x, y, w, h = economizer.x, economizer.y, economizer.w, economizer.h
					glTranslate( x, y, 0 )
					
					local backgroundBorderColor = white
					local backgroundColor = black
					local backgroundOffsetX = 3
					local backgroundW = w - backgroundOffsetX * 2
					
					glPushMatrix()
						glTranslate( backgroundOffsetX, ( h - backgroundH ) / 2, 0 )
						glColor( backgroundBorderColor )
						glRect( backgroundW, backgroundH, 0, 0 )
						glTranslate( 1, 1, 0 )
						glColor( backgroundColor )
						glRect( backgroundW - 2, backgroundH - 2, 0, 0 )
					glPopMatrix()
					
					local thumbColor = white
					local thumbH = backgroundH + 4
					
					glPushMatrix()
						glTranslate( ( w - thumbW ) / 2, ( h - thumbH ) / 2, 0 )
						glColor( thumbColor )
						glRect( thumbW, thumbH, 0, 0 )
					glPopMatrix()
					
					local barH = backgroundH - 2
					local widget = economizer.resourceWidget
					local balance = widget.income - widget.request
					
					local totalBarW = ( backgroundW - thumbW ) / 2 - 1
					local value = balance < 0 and balance / widget.request or balance / widget.income
					local barW = value * totalBarW
					
					local barColor = balance > 0 and green or red
					
					glPushMatrix()
						if( balance > 0 ) then
							glTranslate( ( w + thumbW ) / 2, ( h - barH ) / 2, 0 )
						else
							glTranslate( ( w - thumbW ) / 2, ( h - barH ) / 2, 0 )
						end
						glColor( barColor )
						glRect( barW, barH, 0, 0 )
					glPopMatrix()
					
					glPopMatrix()
				end
			end
			
			layout:AppendWidget( widget.icon )
			layout:AppendWidget( widget.balanceLabel )
			layout:AppendWidget( widget.incomeRequestLabel )
			layout:AppendWidget( widget.bar, 1 )
			--layout:AppendWidget( widget.economizer, 2 )
		end
		widget:SetLayout( layout )
		
		--local dt = 0
		function widget:OnUpdating()
			--[[
			if( dt % 6 ~= 50 ) then
				dt = dt + 1
				return
			end
			dt = 0
			--]]

			local current, storage,	pull, income, expense, share, sent, receive = 
				SpGetTeamResources( myTeamId, self.resource )
			
			current = current or 0
			income  = income  or 0
			receive = receive or 0
			expense = expense or 0
			storage = storage or 0
			pull    = pull    or 0
			share	= share   or 0
			
			--Spring.Echo( current, Spring.GetMyTeamID(), self.resource )
			
			local normalizedValue = current + income + receive - expense
			if( normalizedValue > storage ) then
				normalizedValue = storage
			elseif( normalizedValue < 0 ) then
				normalizedValue = 0
			else
				normalizedValue = current
			end
			
			if( share ~= self.share ) then
				if( self.resource == "metal" ) then
					self.bar.tooltip = metallTooltip .. string_format( "%.1f%%", share * 100 )
				else
					self.bar.tooltip = energyTooltip .. string_format( "%.1f%%", share * 100 )
				end
			end
			
			self.current = normalizedValue
			self.storage = storage
			self.income  = income
			self.request = pull
			self.expense = expense
			self.receive = receive
			self.share   = share
		end
	end
	
	return widget
end
	
----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
RESOURCE_BAR = {}
RESOURCE_BAR.Create = CreateBarWidget
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
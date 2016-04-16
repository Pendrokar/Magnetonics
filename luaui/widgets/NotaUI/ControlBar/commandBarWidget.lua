----------------------------------------------------------------------------------------------------
--                                       COMMAND BAR WIDGET                                       --
--                                      Contains unit orders                                      --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Config
local buttonW = 126 / 2.4
local captionHeight = 20
local captionTextColor = { 1, 1, 1, 1 }
local captionFontSize = 12
local captionButtonBackgroundColor = { 0, 0, 0, 0.5 }

-- local constants
local black = { 0, 0, 0, 1 }
local white = { 1, 1, 1, 1 }

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local Create

local SelectPage
local PreviousPage
local NextPage

local EnterPageSwitcher
local LeavePageSwitcher
local MouseUpPageSwitcher

local UpdatePages
local UpdateButtons

local RenderCaptionLabel
local RenderCaptionButton

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glTranslate	= gl.Translate
local glScale		= gl.Scale
local glScissor		= gl.Scissor
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix

local glColor		= gl.Color
local glRect		= gl.Rect
local glText		= gl.Text
--
local math_ceil = math.ceil
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Create bar
----------------------------------------------------------------------------------------------------
Create = function( properties )
	
	local properties = properties or {}
	
	local commandBar = WIDGET.Create() do	
		commandBar.currentPage = 0
		commandBar.pageCount = 0
		
		commandBar.buttonIdList = {}
		commandBar.buttonsCount = 0
		
		commandBar.iconsPerLine = 0
		commandBar.iconsRows = 0
		commandBar.iconW = 0
		commandBar.iconH = 0
		commandBar.iconSpacing = 0
		
		commandBar.layouts = {}
		
		commandBar.SelectPage = SelectPage
		commandBar.UpdatePages = UpdatePages
		commandBar.UpdateButtons = UpdateButtons
		
		commandBar.buttonStorage = nil
		commandBar.CreateButton = nil
		commandBar.UpdateButton = nil

		
		local layout = LAYOUT.Create( LAYOUT.verticalType ) do		
			commandBar.pages = WIDGET.Create() do
				
				commandBar.pages.commandBar = commandBar -- parent reference
				
				commandBar.pages.OnResizing = function( pages )
					local commandBar = pages.commandBar

					commandBar.iconsPerLine = TOOLS.CalculateIconsCount( pages.w, commandBar.iconW, commandBar.iconSpacing )
					
					if( not commandBar.autoHeight ) then
						commandBar.iconsRows = TOOLS.CalculateIconsCount( pages.h, commandBar.iconH, commandBar.iconSpacing )
					end

					commandBar.layouts = {}
					commandBar:UpdatePages()
				end
			end

			layout:AppendWidget( commandBar.pages, 1 )

			commandBar.autoHeight = properties.autoHeight
			if( not commandBar.autoHeight ) then
				commandBar.pageSwitcher = WIDGET.Create() do
					local switcher = commandBar.pageSwitcher
					switcher.commandBar = commandBar
					switcher.minH = captionHeight
					
					switcher.OnMouseEnter = EnterPageSwitcher
					switcher.OnMouseLeave = LeavePageSwitcher
					
					switcher.OnRedrawing = function( switcher )
						
						local commandBar = switcher.commandBar
						
						if( commandBar.currentPage == 0 ) then
							return
						end
						
						glPushMatrix()

						local x, y, w, h = switcher.x, switcher.y, switcher.w, switcher.h
						glTranslate( x, y, 0 ) -- set drawing pointer

						--[[
						glColor( black )
						glRect( 0, 0, w, 1 )
						
						glTranslate( 0, h, 0 )
						glRect( 0, 0, w, -1 )
						--]]
						
						if( commandBar.pageCount > 1 ) then
							local thumbSize = 4
							local thumbSpread = 10
							local thumbStep = thumbSize + thumbSpread
							local thumbOffsetX = ( w - thumbStep * commandBar.pageCount + thumbSpread ) / 2
							local thumbOffsetY = ( - thumbSize - h ) / 2 + h
							
							glTranslate( thumbOffsetX,  thumbOffsetY, 0 )
							
							for i = 1, commandBar.pageCount do
								if( i == commandBar.currentPage ) then
									glTranslate( -2, -2, 0 )
									glColor( white )
									glRect( 0, 0, thumbSize + 4, thumbSize + 4 )
									
									glTranslate( 1, 1, 0 )
									glColor( { 0, 0, 0, 1 } )
									glRect( 0, 0, thumbSize + 2, thumbSize + 2 )
									glTranslate( 1, 1, 0 )
								end
							
								glColor( black )
								glRect( 0, 0, thumbSize, thumbSize )
								
								glTranslate( 1, 1, 0 )
								glColor( white )
								glRect( 0, 0, thumbSize - 2, thumbSize - 2 )
								glTranslate( -1, -1, 0 )
								
								glTranslate( thumbStep, 0, 0 )
							end

							if( switcher.mouseAbove ) then
								glPopMatrix()
								glPushMatrix()
								glTranslate( x, y, 0 )
								if( switcher.mouseDown ) then
									glColor( 1, 1, 1, 0.7 )
								else
									glColor( 1, 1, 1, 0.3 )
								end
								glRect( w, h, 0, 0 )
							end
						end
						
						glPopMatrix()
					end
					
					local layout = LAYOUT.Create( LAYOUT.horizontalType ) do
						
						switcher.prevButton = BUTTON.Create() do
							local prevButton = switcher.prevButton
							
							prevButton.commandBar = commandBar
							
							prevButton.OnMouseEnter = nil
							prevButton.OnMouseLeave = nil
							prevButton.OnMouseDown = PreviousPage
							prevButton.OnMouseUp = MouseUpPageSwitcher
							
							--[[
							prevButton.OnRedrawing = function( button )
								--if( button.mouseAbove ) then
								if( button.commandBar.pageCount > 1 ) then
									glPushMatrix()
										glColor( white )
										glTranslate( button.x, button.y + button.h / 2, 0 )
										glText( "<<", 0, 0, 12, "vO" )
									glPopMatrix()
								end
								--end
							end
							--]]
						end
						
						switcher.nextButton = BUTTON.Create() do
							local nextButton = switcher.nextButton
							
							nextButton.commandBar = commandBar
							
							nextButton.OnMouseEnter = nil
							nextButton.OnMouseLeave = nil
							nextButton.OnMouseDown = NextPage
							nextButton.OnMouseUp = MouseUpPageSwitcher
							
							--[[
							nextButton.OnRedrawing = function( button )
								--if( button.mouseAbove ) then
								if( button.commandBar.pageCount > 1 ) then
									glPushMatrix()
										glColor( white )
										glTranslate( button.x + button.w, button.y + button.h / 2, 0 )
										glText( ">>", 0, 0, 12, "rvO" )
									glPopMatrix()
								end
								--end
							end
							--]]
						end
						
						layout:AppendWidget( switcher.prevButton, 1 )
						layout:AppendWidget( switcher.nextButton, 1 )
					end
					switcher:SetLayout( layout )
				end
				
				layout:AppendWidget( commandBar.pageSwitcher, 0 )
			end
		end
		
		commandBar:SetLayout( layout )
	end
	
	return commandBar
end

----------------------------------------------------------------------------------------------------
SelectPage = function( commandBar )
	if( commandBar.pageSwitcher ) then
		commandBar.pageSwitcher.needRedraw = true
		commandBar.pageSwitcher.prevButton.needRedraw = true
		commandBar.pageSwitcher.nextButton.needRedraw = true
	end
	commandBar.pages:SetLayout( commandBar.layouts[ commandBar.currentPage ] )
end

----------------------------------------------------------------------------------------------------
PreviousPage = function( button )
	local commandBar = button.commandBar
	local switcher = commandBar.pageSwitcher
	switcher.mouseDown = true
	switcher.needRedraw = true

	commandBar.currentPage = commandBar.currentPage - 1
	if( commandBar.currentPage < 1 ) then
		commandBar.currentPage = commandBar.pageCount
	end
	commandBar:SelectPage()
end

----------------------------------------------------------------------------------------------------
NextPage = function( button )
	local commandBar = button.commandBar
	local switcher = commandBar.pageSwitcher
	switcher.mouseDown = true
	switcher.needRedraw = true
	
	commandBar.currentPage = commandBar.currentPage + 1
	if( commandBar.currentPage > commandBar.pageCount ) then
		commandBar.currentPage = 1
	end
	commandBar:SelectPage()
end

----------------------------------------------------------------------------------------------------
EnterPageSwitcher = function( switcher )
	
	switcher.mouseAbove = true
	switcher.needRedraw = true
end

----------------------------------------------------------------------------------------------------
LeavePageSwitcher = function( switcher )
	
	switcher.mouseAbove = false
	switcher.needRedraw = true
end

----------------------------------------------------------------------------------------------------
MouseUpPageSwitcher = function( button )
	
	local switcher = button.commandBar.pageSwitcher
	switcher.mouseDown = false
	switcher.needRedraw = true
end

----------------------------------------------------------------------------------------------------
UpdateButtons = function( commandBar, commands )
	local needUpdatePages = false
	
	-- check commands count
	commandBar.commands = commands
	local commandsCount = #commands
	if( commandsCount ~= commandBar.buttonsCount ) then
		needUpdatePages = true
	end
	commandBar.buttonsCount = commandsCount
	
	local buttonIdList = commandBar.buttonIdList
	local buttonStorage = commandBar.buttonStorage
	
	local CreateButton = commandBar.CreateButton
	local UpdateButton = commandBar.UpdateButton
	
	-- check commands by id
	for i = 1, commandsCount do
		local id = commands[ i ].id
		if( buttonIdList[ i ] ~= id ) then
			needUpdatePages = true
		end
		buttonIdList[ i ] = id
		
		-- update button for command
		local button = buttonStorage[ id ]
		if( button == nil ) then
			button = CreateButton( commands[ i ] )
			buttonStorage[ id ] = button
			
			needUpdatePages = true
		else
			UpdateButton( button, commands[ i ] )
		end
	end
	
	if( needUpdatePages ) then
		commandBar:UpdatePages()
	end
end

----------------------------------------------------------------------------------------------------
UpdatePages = function( commandBar )
	
	local notInitialized = commandBar.buttonsCount == 0 or commandBar.iconsPerLine == 0
	
	if( notInitialized ) then
		-- No commands, clear panel
		commandBar.pageCount = 0
		commandBar.currentPage = 0
		commandBar:SelectPage()
		
		if( commandBar.autoHeight and commandBar.minH ~= 0 ) then
			commandBar.minH = 0
			commandBar.parentLayout:Update()
		end
		
		return
	end
	
	if( commandBar.autoHeight ) then
		local linesCount = math_ceil( commandBar.buttonsCount / commandBar.iconsPerLine )
		
		commandBar.iconsRows = linesCount
		
		local buttonHeight = linesCount * ( commandBar.iconH + commandBar.iconSpacing ) - commandBar.iconSpacing
		
		local height = buttonHeight + 10
		if( height ~= commandBar.minH ) then
			commandBar.minH = height
			commandBar.parentLayout:Update()
		end
	end
	
	local commands = commandBar.commands
	
	-- create pages and select first page
	local iconsPerPage = commandBar.iconsPerLine * commandBar.iconsRows
	
	commandBar.pageCount = math_ceil( commandBar.buttonsCount / iconsPerPage )
	
	local startIndex = 1
	
	for i = 1, commandBar.pageCount do
		local layout = commandBar.layouts[ i ]
		
		-- prepare clean layout ( without buttons )
		if( layout == nil ) then
			layout = LAYOUT.Create( LAYOUT.gridType )
			layout.widgetHorizontalCount = commandBar.iconsPerLine
			layout.widgetVerticalCount = commandBar.iconsRows
			layout.widgetW = commandBar.iconW
			layout.widgetH = commandBar.iconH
			layout.spacing = commandBar.iconSpacing
			--layout.margin = { 10, 10, 10, 10 }
			commandBar.layouts[ i ] = layout
		else
			layout:Clear()
		end
		
		local endIndex = startIndex + iconsPerPage - 1
		if( endIndex > commandBar.buttonsCount ) then
			endIndex = commandBar.buttonsCount
		end
		
		-- fill layout with commands
		for index = startIndex, endIndex do
			local cmdId = commands[ index ].id	
			layout:AppendWidget( commandBar.buttonStorage[ cmdId ] )
		end
		
		startIndex = endIndex + 1
	end
	
	if( ( commandBar.currentPage < 1 ) or ( commandBar.currentPage > commandBar.pageCount ) ) then
		commandBar.currentPage = 1
	end
	
	commandBar:SelectPage()
end

----------------------------------------------------------------------------------------------------
RenderCaptionLabel = function( label )
	glPushMatrix()
	
	local x, y = label.x, label.y + label.h / 2
	glTranslate( x, y, 0 ) -- set drawing pointer

	glColor( label.textColor )
	glText( label.text, 0, 0, label.fontSize, "vO" )
	
	local textWidth = gl.GetTextWidth( label.text ) * label.fontSize
	
	glTranslate( textWidth, 0, 0 )
	gl.Rect( 0, 0, label.w - textWidth, -1 )
	
	glPopMatrix()
end

----------------------------------------------------------------------------------------------------

RenderCaptionButton = function( button )
	glPushMatrix()

	local x, y, w, h = button.x, button.y, button.w, button.h
	glTranslate( x, y, 0 ) -- set drawing pointer
	
	if( button.disabled ) then
		glColor( button.disabledColor )
		glRect( 0, 0, w, h )
	else					
		if( button.mouseDown ) then
			glColor( button.pressedColor )
			glRect( 0, 0, w, h )
		elseif( button.mouseAbove ) then
			glColor( button.hoverColor )
			glRect( 0, 0, w, h )
		else
			glColor( button.backgroundColor )
			glRect( 0, 0, w, h )
		end
	end
		
	glColor( button.borderColor )
	
	local borderWidth = button.borderWidth
	glRect( 0, 0, w, borderWidth )								--top
	glRect( 0, borderWidth, borderWidth, h )					--left
	glRect( borderWidth, h - borderWidth, w - borderWidth, h )	--bottom
	glRect( w - borderWidth, borderWidth, w, h )				--right
	
	glColor( button.textColor )
	glText( button.text, w / 2, h / 2, button.fontSize, "cv" )
	
	glPopMatrix()
end

----------------------------------------------------------------------------------------------------
return Create
----------------------------------------------------------------------------------------------------

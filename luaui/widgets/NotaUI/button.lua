----------------------------------------------------------------------------------------------------
--                                             BUTTON                                             --
--                                Widget that can get mouse events                                --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local CreateWidget	= WIDGET.Create
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                 Function forward declarations                                  --
----------------------------------------------------------------------------------------------------
local CreateButton
local DefaultMouseFunction
local DefaultMouseDown
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
CreateButton = function()
	local button = CreateWidget( 0, 0 )

	button.borderWidth = 1
	button.fontSize = 10

	button.background =  { 1, 0, 0, 0.5 }
	button.borderColor = { 0, 0, 0, 1 }

	button.textColor	 = { 1, 1, 1, 1 }
	button.disabledColor = { 0, 0, 0, 0.5 }
	button.hoverColor	 = { 1, 1, 1, 0.3 }
	button.pressedColor  = { 1, 1, 1, 0.7 }
	button.selectedColor = { 1, 0, 0, 0.4 }
	
	button.disabled = false
	
	button.OnMouseEnter = DefaultMouseFunction
	button.OnMouseLeave = DefaultMouseFunction
	button.OnMouseDown = DefaultMouseFunction
	button.OnMouseUp = DefaultMouseFunction
	
	return button
end

----------------------------------------------------------------------------------------------------
DefaultMouseFunction = function( button )
	button.needRedraw = true
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
BUTTON = {}
BUTTON.Create = CreateButton
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
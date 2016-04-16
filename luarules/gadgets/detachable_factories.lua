--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    detachable_factories.lua
--  brief:   switches between static and mobile factory versions
--  author:  Yanis Lukes
--
--  Copyright (C) 2016.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Detachable factories",
		desc      = "switches between static and mobile factory versions",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false  --  loaded by default?
	}
end

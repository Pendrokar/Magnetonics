-- based on LolUI and RedUI by Regret

function widget:GetInfo()
	return {
		name      = "NotaUI",
		desc      = "Nota GUI",
		author    = "a1983",
		date      = "xxx xx, 2012",
		license   = "GPL",
		layer     = 9001,
		handler   = true, -- used widget handlers
		enabled   = true  -- loaded by default
	}
end

include( "Widgets/NotaUI/core.lua" )
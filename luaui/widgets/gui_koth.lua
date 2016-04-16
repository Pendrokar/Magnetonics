-- $Id: gui_koth.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_koth.lua
--  brief:   Draw calls
--  author:  Yanis Lukes
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "King of the Hill",
		desc      = "Draw calls",
		author    = "Yanis Lukes",
		date      = "March, 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

local teamBoxes = {}

local teamTimer = nil
local teamControl = -2
local teamLastControl = -1
local r, g, b = 255, 255, 255
local grace = nil

function widget:Initialize()
	if(Spring.GetModOptions().startoptions ~= 'koth') then
		widgetHandler:RemoveWidget()
		return
	end

	for _, allyTeamID in ipairs(Spring.GetAllyTeamList()) do
		local teams = Spring.GetTeamList(allyTeamID)
		if  (teams == nil or #teams == 0) then
			local x1, z1, x2, z2 = Spring.GetAllyTeamStartBox(allyTeamID)
			if (x1 ~= nil) then
				table.insert(teamBoxes, {x1, z1, x2, z2})
			end
		end
	end

	-- getLatestData()
end

function widget:GameFrame(f)
	if(f%30 == 0) then
		getLatestData()
	end
end

-- Spring.Echo("DrawWorldPreUnit")
function widget:DrawWorldPreUnit()
	-- Spring.Echo("DrawWorldPreUnit")
	gl.DepthTest(false)
	gl.Color(r, g, b, 0.2)
	for _, box in ipairs(teamBoxes) do
		gl.DrawGroundQuad(box[1], box[2], box[3], box[4], true)
	end
	gl.Color(1,1,1,1)
end

function widget:DrawScreen()
	-- Spring.Echo("DrawScreen")
	local vsx, vsy = gl.GetViewSizes()
	local posx = vsx * 0.5
	if(grace ~= nil and grace > 0) then
		posy = vsy * 0.75
		-- Text always white in 100.0
		-- gl.Color(255, 255, 255)
		if(grace % 60 < 10) then
			gl.Text("Grace period over in " .. math.floor(grace/60) .. ":0" .. math.floor(grace%60), posx, posy, 14, "ocn")
		else
			gl.Text("Grace period over in " .. math.floor(grace/60) .. ":" .. math.floor(grace%60), posx, posy, 14, "ocn")
		end
	end

	-- Text always white in 100.0
	-- gl.Color(r, g, b)
	local posy = vsy * 0.25
	if (teamControl >= 0) then
		if(teamTimer % 60 < 10) then
			gl.Text("Team " .. teamControl + 1 .. " - " .. math.floor(teamTimer/60) .. ":0" .. math.floor(teamTimer%60), posx, posy, 12, "ocn")
		else
			gl.Text("Team " .. teamControl + 1 .. " - " .. math.floor(teamTimer/60) .. ":" .. math.floor(teamTimer%60), posx, posy, 12, "ocn")
		end
	elseif (teamLastControl > 0) then
		if(teamTimer % 60 < 10) then
			gl.Text("Team " .. teamLastControl + 1 .. " - " .. math.floor(teamTimer/60) .. ":0" .. math.floor(teamTimer%60) .. "\n(contested)", posx, posy, 12, "ocn")
		else
			gl.Text("Team " .. teamLastControl + 1 .. " - " .. math.floor(teamTimer/60) .. ":" .. math.floor(teamTimer%60) .. "\n(contested)", posx, posy, 12, "ocn")
		end
	else
		gl.Text("Neutral ground", posx, posy, 12, "ocn")
	end
end

function getLatestData()
	-- Spring.Echo("Checking data")
	-- local newTeamTimer, newTeamControl, newGrace = Spring.GetGameRulesParams("koth_control_time_by_" .. teamControl, "koth_control_team", "koth_grace")
	local newTeamTimer = Spring.GetGameRulesParam("koth_control_time")
	local newTeamControl = Spring.GetGameRulesParam("koth_control_team")
	grace = Spring.GetGameRulesParam("koth_grace")

	if (newTeamTimer ~= nil) then
		teamTimer = newTeamTimer
		-- Spring.Echo(teamTimer)
	end
	if (newTeamControl ~= nil) then
		if(newTeamControl ~= teamControl) then
			if(newTeamControl < 0) then
				teamLastControl = teamControl
			end
			setBoxColor(newTeamControl)
		end
		teamControl = newTeamControl
		-- Spring.Echo(teamControl)
	end
	-- Spring.Echo(teamTimer .. "-" .. teamControl .. "-" .. grace)
end

function setBoxColor(team)
	if(team < 0) then
		r, g, b = 255, 255, 255
	else
		r, g, b = Spring.GetTeamColor(team)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Scatter",
    desc      = "Makes guys scatter" ..
                "in every direction",
    author    = "thor",
    date      = "July 12, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Speed-ups

local GetUnitDefID    = Spring.GetUnitDefID
local GetUnitCommands = Spring.GetUnitCommands
local FindUnitCmdDesc = Spring.FindUnitCmdDesc

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CMD_SCATTER = 33658


local scatterCmdDesc = {
  id      = CMD_SCATTER,
  type    = CMDTYPE.ICON_MODE,
  name    = 'Scatter',
  cursor  = 'Scatter',
  action  = 'Scatter',
  tooltip = 'Everyone Scatter',
  params  = { 'Scatter'}
}
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddScatterCmdDesc(unitID)
  if (FindUnitCmdDesc(unitID, CMD_SCATTER)) then
    return  -- already exists
  end
  local insertID = 
    FindUnitCmdDesc(unitID, CMD.CLOAK)      or
    FindUnitCmdDesc(unitID, CMD.ONOFF)      or
    FindUnitCmdDesc(unitID, CMD.TRAJECTORY) or
    FindUnitCmdDesc(unitID, CMD.REPEAT)     or
    FindUnitCmdDesc(unitID, CMD.MOVE_STATE) or
    FindUnitCmdDesc(unitID, CMD.FIRE_STATE) or
    FindUnitCmdDesc(unitID, CMD.AREA_ATTACK) or
    123456 -- back of the pack
  scatterCmdDesc.params[1] = '0'
  Spring.InsertUnitCmdDesc(unitID, insertID + 1, scatterCmdDesc)
end


local function UpdateButton(unitID, statusStr)
  local cmdDescID = FindUnitCmdDesc(unitID, CMD_SCATTER)
  if (cmdDescID == nil) then
    return
  end

  scatterCmdDesc.params[1] = statusStr

  Spring.EditUnitCmdDesc(unitID, cmdDescID, { 
	params  = scatterCmdDesc.params, 
	tooltip = tooltip,
  })
end


local function scatterCommand(unitID, unitDefID, cmdParams, teamID)

  local ud = UnitDefs[unitDefID]
  if (ud.speed > 0 and ud.canFly == false) then
    local movetox, movetoz = 0,0
    --local otherguy = Spring.GetUnitNearestAlly(unitID)--spring is so fuckign stupid
    local myx, myy, myz = Spring.GetUnitPosition(unitID)
    doods = Spring.GetUnitsInCylinder(myx, myz, 300, teamID)
    if (table.getn(doods) > 1) then
      local avgx, avgz = 0,0
      for i = 1, table.getn(doods) do
        local otherx, othery, otherz = Spring.GetUnitPosition(doods[i])
	  avgx = avgx + otherx
        avgz = avgz + otherz
      end
      avgx = avgx / table.getn(doods)
      avgz = avgz / table.getn(doods) 
      local difx = myx - avgx
      local difz = myz - avgz
      local totalDist = math.abs(myx - avgx) + math.abs(myz - avgz)
      movetox = (difx / totalDist) * 80
      movttoz = (difz / totalDist) * 80
    end

    doods = Spring.GetUnitsInCylinder(myx, myz, 100, teamID)
    local shortestDist = 150
    local closestDood = nil
    for i = 1, table.getn(doods) do
      local otherx, othery, otherz = Spring.GetUnitPosition(doods[i])
      local difx = myx - otherx
      local difz = myz - otherz
      local totalDist = math.abs(myx - otherx) + math.abs(myz - otherz)
      if (totalDist < shortestDist and doods[i] ~= unitID) then
	  shortestDist = totalDist
        closestDood = doods[i]
      end
    end
    if (closestDood ~= nil) then
      local otherx, othery, otherz = Spring.GetUnitPosition(closestDood)
      difx = myx - otherx
      difz = myz - otherz
      local totalDist = math.abs(myx - otherx) + math.abs(myz - otherz)
      movetox = movetox + ((difx / totalDist) * 80)
      movetoz = movetoz + ((difz / totalDist) * 80)
    end
    if (movetox ~= 0 or movetoz ~= 0) then
      --Spring.GiveOrderToUnit(unitID, CMD.INSERT, { 0, CMD.MOVE, CMD.OPT_INTERNAL, movetox + myx, Spring.GetGroundHeight(movetox + myx, movetoz+myz), movetoz+myz}, CMD.OPT_ALT) 
	Spring.GiveOrderToUnit(unitID, CMD.MOVE, {movetox + myx, Spring.GetGroundHeight(movetox + myx, movetoz+myz), movetoz+myz}, {})
    end
  end
  --UpdateButton(unitID, status)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
  local ud = UnitDefs[unitDefID]
  if (ud.speed > 0 and ud.canFly == false) then
    AddScatterCmdDesc(unitID)
    UpdateButton(unitID, '0')
  end
end


function gadget:Initialize()
  gadgetHandler:RegisterCMDID(CMD_SCATTER)
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local teamID = Spring.GetUnitTeam(unitID)
    local unitDefID = GetUnitDefID(unitID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
  end
end




function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, _)
  local returnvalue
  if cmdID ~= CMD_SCATTER then
    return true
  end
  scatterCommand(unitID, unitDefID, cmdParams, teamID)  
  return false
end

function gadget:Shutdown()
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local cmdDescID = FindUnitCmdDesc(unitID, CMD_SCATTER)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

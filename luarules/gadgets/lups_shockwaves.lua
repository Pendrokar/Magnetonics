
function gadget:GetInfo()
  return {
    name      = "Shockwaves",
    desc      = "",
    author    = "jK",
    date      = "Jan. 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end


if (gadgetHandler:IsSyncedCode()) then

  local SHOCK_WEAPONS = {
    ["rubypushbeam"] = true,
  }

  --// find weapons which cause a shockwave
  for i=1,#WeaponDefs do
    local wd = WeaponDefs[i]
    if SHOCK_WEAPONS[wd.name] then
      Script.SetWatchWeapon(wd.id,true)
      SHOCK_WEAPONS[wd.id] = true
    end
  end


  function gadget:ProjectileCreated(proID, ownerID, weaponID)
    local px, py, pz = Spring.GetProjectilePosition(proID)
    -- WeaponDefs[weaponID]
    if SHOCK_WEAPONS[weaponID] then
      -- Spring.PlaySoundFile("sounds/glass_break2.wav", 1.0, px, py, pz)
      local wd = WeaponDefs[weaponID]
      -- local growth = (wd.damageAreaOfEffect*1.1)/20
      local growth = 1
      -- local Lups = GG['Lups']
      -- Lups.AddParticles('ShockWave',{pos={px,py,pz}, growth=growth})
      SendToUnsynced("lups_shockwave", px, py, pz, growth, false)
    end
    return false
  end

  function gadget:Explosion(weaponID, px, py, pz, ownerID)
    if SHOCK_WEAPONS[weaponID] then
      local wd = WeaponDefs[weaponID]
      if (wd.type == "DGun") then
        SendToUnsynced("lups_shockwave", px, py, pz, 4.0, 18, 0.13, true)
      else
        local growth = (wd.damageAreaOfEffect*1.1)/14
        SendToUnsynced("lups_shockwave", px, py, pz, growth, false)
      end
    end
    return false
  end

  function gadget:RecvLuaMsg(msg, id)
    if (msg == "lups shutdown") then
    SendToUnsynced("shockwave_Toggle",false,id)
  elseif (msg == "lups running") then
    SendToUnsynced("shockwave_Toggle",true,id)
  end
  end

else
  -- Spring.Echo("unsynced")
  local enabled = true

  local function SpawnShockwave(_,px,py,pz, growth, life, strength, desintergrator)
    if (enabled) then
      local Lups = GG['Lups']
      if (desintergrator) then
        Lups.AddParticles('SphereDistortion',{pos={px,py,pz}, life=life, strength=strength, growth=growth})
      else
        Lups.AddParticles('ShockWave',{pos={px,py,pz}, growth=growth})
      end
    end
  end

  local function Toggle(_,enable,playerId)
    if (playerId == Spring.GetMyPlayerID()) then
      if enable then
      enabled = true
    else
      enabled = false
    end
  end
  end

  function gadget:Initialize()
    gadgetHandler:AddSyncAction("lups_shockwave", SpawnShockwave)
    gadgetHandler:AddSyncAction("shockwave_Toggle", Toggle)
  end

  function gadget:Shutdown()
    gadgetHandler.RemoveSyncAction("lups_shockwave")
    gadgetHandler.RemoveSyncAction("shockwave_Toggle")
  end

end
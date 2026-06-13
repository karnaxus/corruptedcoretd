--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | EndZone Manager                                           |
    | ========================================================= |
    | Manages when a unit enters a endzone region.              |
    +-----------------------------------------------------------+
]]

CC.Systems.EndZoneManager = CC.Systems.EndZoneManager or {}

CC.Systems.EndZoneManager.leaksLeft = 0

--[[
    Initialize the EndZone Manager.
]]
function CC.Systems.EndZoneManager.Init()
    CC.Core.Debug("EndZoneManager", "Initializing the EndZone Manager...")

    CC.Systems.EndZoneManager.leaksLeft = 0

    CC.Core.Debug("EndZoneManager", "EndZone Manager initialized.")
end

--[[
    Set the leaks left.
]]
function CC.Systems.EndZoneManager.SetLeaksLeft(leaksLeft)
    CC.Systems.EndZoneManager.leaksLeft = leaksLeft
end

--[[
    Get the total leaks left.
]]
function CC.Systems.EndZoneManager.GetLeaksLeft()
    return CC.Systems.EndZoneManager.leaksLeft
end

--[[
    Minus leaks left by a value.
]]
function CC.Systems.EndZoneManager.AddLeakage(value)
    CC.Systems.EndZoneManager.leaksLeft = CC.Systems.EndZoneManager.leaksLeft - value

    if CC.Systems.EndZoneManager.leaksLeft < 0 then
        CC.Systems.EndZoneManager.leaksLeft = 0
    end
end

--[[
    Handle when a unit enters an endzone region.
]]
function CC.Systems.EndZoneManager.OnEnter(unit, regionName)
    local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]
    
    if waveSettings == nil then
        return
    end

    if not CC.Systems.InvaderPathManager.IsInvader(unit) then
        return
    end

    StartSound(gg_snd_Leak)

    local rect = CC.Systems.SpawnManager.ResolveRegion(regionName)

    if rect ~= nil then
        local x = GetRectCenterX(rect)
        local y = GetRectCenterY(rect)

        PingMinimap(x, y, 5.00)
    end
    
    CC.Systems.EndZoneManager.AddLeakage(waveSettings.leakValue)

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Red("Leak Detected! ") ..
        CC.Core.Color.Orange(tostring(CC.Systems.EndZoneManager.GetLeaksLeft())) ..
        CC.Core.Color.Yellow(" " .. CC.Core.Helpers.SingularOrPlural("leak", "leaks", CC.Systems.EndZoneManager.GetLeaksLeft()) .. " left!")
    )
    
    CC.Systems.UnitManager.TeleportUnit(unit)

    if CC.Systems.EndZoneManager.GetLeaksLeft() <= 0 then
        CC.Systems.GameManager.DeclareDefeat()
        return
    end
end
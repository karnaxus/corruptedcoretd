--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Death Manager                                             |
    | ========================================================= |
    | Manages the death of the invaders.                        |
    +-----------------------------------------------------------+
]]

CC.Systems.DeathManager = CC.Systems.DeathManager or {}

--[[
    Initialize the Death Manager.
]]
function CC.Systems.DeathManager.Init()
    CC.Core.Debug("DeathManager", "Initializing the Death Manager...")

    CC.Systems.DeathManager.RegisterDeathHandler()

    CC.Core.Debug("DeathManager", "Death Manager initialized.")
end

--[[
    Register the death handling trigger.
]]
function CC.Systems.DeathManager.RegisterDeathHandler()
    local trigger = CreateTrigger()

    TriggerRegisterAnyUnitEventBJ(trigger, EVENT_PLAYER_UNIT_DEATH)

    TriggerAddAction(trigger, function ()
        local dyingUnit = GetDyingUnit()

        if dyingUnit == nil then
            return
        end

        if not CC.Systems.InvaderPathManager.IsInvader(dyingUnit) then
            return
        end

        CC.Systems.DeathManager.HandleDeath(dyingUnit)
    end)
end

--[[
    Handle when an invader dies.
]]
function CC.Systems.DeathManager.HandleDeath(unit)
    local killer = GetKillingUnit()

    if killer ~= nil then
        local killingPlayer = GetOwningPlayer(killer)
        local playerData = CC.Systems.PlayerManager.GetPlayer(killingPlayer)

        if playerData ~= nil then
            local player = playerData.player
            local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]
            local gameSettings = CC.Systems.GameManager.GetSettings()
            local totalGold = math.floor(waveSettings.goldPerKill * gameSettings.goldMultiplier)

            playerData.kills = (playerData.kills or 0) + 1

            CC.Systems.EndGameSummaryManager.AddKills(playerData, 1)

            CC.Systems.PlayerManager.AddResource(player, "gold", totalGold)

            if waveSettings.isBoss then
                CC.Systems.BossManager.OnBossDeath(unit, waveSettings, killer)
            end

            CC.Core.Debug("DeathManager", playerData.name .. " kills: " .. tostring(playerData.kills))
        else
            CC.Core.Debug("DeathManager", "No player data for killing player id: " .. tostring(GetPlayerId(killingPlayer)))
        end
    end

    CC.Systems.SpawnManager.invadersAlive = CC.Systems.SpawnManager.invadersAlive - 1

    if CC.Systems.SpawnManager.invadersAlive <= 0 then
        CC.Systems.SpawnManager.invadersAlive = 0
        CC.Systems.WaveManager.OnWaveComplete()
    end

    local timer = CreateTimer()

    TimerStart(timer, 1.00, false, function ()
        CC.Systems.SpawnManager.units[GetHandleId(unit)] = nil

        RemoveUnit(unit)

        PauseTimer(timer)
        DestroyTimer(timer)
    end)
end
--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Wave Manager                                              |
    | ========================================================= |
    | Manages the waves of invaders.                            |
    +-----------------------------------------------------------+
]]

CC.Systems.WaveManager = CC.Systems.WaveManager or {}

CC.Systems.WaveManager.currentWave = 0
CC.Systems.WaveManager.spawnFinished = true
CC.Systems.WaveManager.totalSpawned = 0
CC.Systems.WaveManager.waveModified = false

--[[
    Initialize the Wave Manager.
]]
function CC.Systems.WaveManager.Init()
    CC.Core.Debug("WaveManager", "Initializing the Wave Manager...")

    CC.Systems.WaveManager.currentWave = 0
    CC.Systems.WaveManager.totalSpawned = 0
    CC.Systems.WaveManager.spawnFinished = true
    CC.Systems.WaveManager.waveModified = false

    CC.Core.Debug("WaveManager", "Wave Manager initialized.")
end

--[[
    Start the next wave of invaders.
]]
function CC.Systems.WaveManager.StartWave()
    StartSound(gg_snd_SpawnStart)

    if CC.Core.startAtWave ~= nil and CC.Systems.WaveManager.waveModified == false then
        CC.Systems.WaveManager.currentWave = CC.Core.startAtWave - 1
        CC.Systems.WaveManager.waveModified = true
    end

    CC.Systems.WaveManager.currentWave = CC.Systems.WaveManager.currentWave + 1

    CC.Systems.LeaderboardManager.StartKillRecordForWave(CC.Systems.WaveManager.currentWave)
    CC.Systems.LeaderboardManager.StartDamageRecordForWave(CC.Systems.WaveManager.currentWave)
    CC.Systems.LeaderboardManager.StartWaveTimer(CC.Systems.WaveManager.currentWave)

    CC.Systems.WaveManager.WaveNotifications(CC.Systems.WaveManager.currentWave)

    CC.Core.Debug("WaveManager", "Starting wave " .. tostring(CC.Systems.WaveManager.currentWave) .. "...")

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Yellow("Wave ") ..
        CC.Core.Color.Orange(tostring(CC.Systems.WaveManager.currentWave)) ..
        CC.Core.Color.Yellow(" Beginning...")
    )

    local gameSettings = CC.Systems.GameManager.GetSettings()
    local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]

    local totalInvaders = math.ceil(waveSettings.total * gameSettings.invaderMultiplier)
    local totalGold = waveSettings.goldPerWave

    if waveSettings.category == CC.Config.WaveCategories.BOSS then
        totalInvaders = 1
    end

    CC.Systems.PlayerManager.AddResourceToAllPlayers("gold", totalGold)

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Yellow("You just received ") ..
        CC.Core.Color.Orange(tostring(totalGold)) ..
        CC.Core.Color.Yellow(" gold for the next wave!")
    )

    CC.Systems.WaveManager.spawnFinished = false
    CC.Systems.WaveManager.totalSpawned = 0

    local totalEnabled = 0
    local totalComplete = 0

    if CC.Systems.SpawnManager.enabledSpawns.north == true then
        totalEnabled = totalEnabled + 1
    end

    if CC.Systems.SpawnManager.enabledSpawns.east == true then
        totalEnabled = totalEnabled + 1
    end

    if CC.Systems.SpawnManager.enabledSpawns.south == true then
        totalEnabled = totalEnabled + 1
    end

    if CC.Systems.SpawnManager.enabledSpawns.west == true then
        totalEnabled = totalEnabled + 1
    end

    local function onSpawnFinished(totalSpawned)
        totalComplete = totalComplete + 1
        CC.Systems.WaveManager.totalSpawned = CC.Systems.WaveManager.totalSpawned + totalSpawned

        if totalComplete == totalEnabled then
            CC.Systems.WaveManager.spawnFinished = true
            CC.Systems.WaveManager.SpawnCompleted()
        end
    end

    if CC.Systems.SpawnManager.enabledSpawns.north == true then
        CC.Systems.SpawnManager.SpawnWave(
            "north",
            waveSettings.unitType,
            totalInvaders,
            waveSettings.spawnDelay,
            onSpawnFinished
        )
    end 

    if CC.Systems.SpawnManager.enabledSpawns.east == true then
        CC.Systems.SpawnManager.SpawnWave(
            "east",
            waveSettings.unitType,
            totalInvaders,
            waveSettings.spawnDelay,
            onSpawnFinished
        )
    end 

    if CC.Systems.SpawnManager.enabledSpawns.south == true then
        CC.Systems.SpawnManager.SpawnWave(
            "south",
            waveSettings.unitType,
            totalInvaders,
            waveSettings.spawnDelay,
            onSpawnFinished
        )
    end

    if CC.Systems.SpawnManager.enabledSpawns.west == true then
        CC.Systems.SpawnManager.SpawnWave(
            "west",
            waveSettings.unitType,
            totalInvaders,
            waveSettings.spawnDelay,
            onSpawnFinished
        )
    end
end

--[[
    Triggered when spawning finishes.
]]
function CC.Systems.WaveManager.AfterSpawn()
    local timer = CreateTimer()

    CreateTimer(timer, 0.25, true, function ()
        if CC.Systems.WaveManager.spawnFinished == true then
            PauseTimer(timer)
            DestroyTimer(timer)
        end
    end)
end

--[[
    Handle when all spawning has completed.
]]
function CC.Systems.WaveManager.SpawnCompleted()
    StartSound(gg_snd_SpawnEnd)

    local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]
    local unitName = waveSettings.name

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Orange(tostring(CC.Systems.WaveManager.totalSpawned)) .. " " ..
        CC.Core.Color.Yellow(unitName) ..
        CC.Core.Color.Teal(" spawned!\n") ..
        CC.Core.Color.Red(waveSettings.description)
    )
end

--[[
    Notify the players of special waves.
]]
function CC.Systems.WaveManager.WaveNotifications(wave)
    local waveSettings = CC.Config.Waves[wave]

    if waveSettings == nil then
        return
    end

    if waveSettings.category == CC.Config.WaveCategories.AIR then
        StartSound(gg_snd_AirWave)

        CC.UI.MessageManager.Broadcast(
            CC.Core.Color.Red("WARNING: ") ..
            CC.Core.Color.Orange("Flying creeps detected!\n") ..
            CC.Core.Color.Yellow("Ensure your defenses can attack air units.")
        )
    elseif waveSettings.category == CC.Config.WaveCategories.BOSS then
        StartSound(gg_snd_BossWave)

        CC.UI.MessageManager.Broadcast(
            CC.Core.Color.Red("BOSS WAVE!\n") ..
            CC.Core.Color.Orange("A powerful champion approaches!\n") ..
            CC.Core.Color.Yellow("Prepare your defenses!")
        )
    end
end

--[[
    Handle when a wave is complete.
]]
function CC.Systems.WaveManager.OnWaveComplete()
    local completedWave = CC.Systems.WaveManager.currentWave
    local nextWave = completedWave + 1

    if nextWave <= CC.Core.Constants.MAX_WAVES then
        local gameSettings = CC.Systems.GameManager.GetSettings()

        if gameSettings.betweenWaveDelayEnabled == true then
            CC.Core.Timer.Window(gameSettings.betweenWaveDelay, "Wave " .. tostring(nextWave) .. " in...", function ()
                CC.Systems.WaveManager.StartWave()
            end)
        else
            CC.Systems.WaveManager.StartWave()
        end
    end

    CC.Systems.LeaderboardManager.WaveEndSummary(completedWave)

    if completedWave == CC.Core.Constants.MAX_WAVES then
        CC.Systems.GameManager.DeclareVictory()
        return
    end
end

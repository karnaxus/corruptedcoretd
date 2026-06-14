--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Spawn Manager                                             |
    | ========================================================= |
    | Manages spawning units.                                   |
    +-----------------------------------------------------------+
]]

CC.Systems.SpawnManager = CC.Systems.SpawnManager or {}

CC.Systems.SpawnManager.enabledSpawns = {
    north = false,
    east = false,
    south = false,
    west = false
}

CC.Systems.SpawnManager.invadersAlive = 0
CC.Systems.SpawnManager.units = {}

CC.Systems.SpawnManager.enabledPaths = {
    north = {
        pathOne = false,
        pathTwo = false
    },

    east = {
        pathOne = false,
        pathTwo = false
    },

    south = {
        pathOne = false,
        pathTwo = false
    },

    west = {
        pathOne = false,
        pathTwo = false
    }
}

CC.Systems.SpawnManager.spawns = {
    north = {
        pathOne = true,
        pathTwo = true,
        total = 0
    },

    east = {
        pathOne = true,
        pathTwo = true,
        total = 0
    },

    south = {
        pathOne = true,
        pathTwo = true,
        total = 0
    },

    west = {
        pathOne = true,
        pathTwo = true,
        total = 0
    }
}

--[[
    Initialize the Spawn Manager.
]]
function CC.Systems.SpawnManager.Init()
    CC.Core.Debug("SpawnManager", "Initializing the Spawn Manager...")

    CC.Systems.SpawnManager.invadersAlive = 0
    CC.Systems.SpawnManager.CheckSpawns()

    CC.Core.Debug("SpawnManager", "Spawn Manager initialized.")
end

--[[
    Resolve a region.
]]
function CC.Systems.SpawnManager.ResolveRegion(regionName)
    return _G["gg_rct_" ..regionName]
end

--[[
    Spawn a unit at a given X,Y coordinate.
]]
function CC.Systems.SpawnManager.SpawnUnitAtXY(player, unitType, x, y, facing)
    return CreateUnit(player, unitType, x, y, facing or 270.00)
end

--[[
    Determine which spawns should be enabled/disabled.
]]
function CC.Systems.SpawnManager.CheckSpawns()
    local playerStatus = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
        [7] = false
    }

    CC.Systems.PlayerManager.ForEach(function (playerData)
        if playerData.active == true then
            playerStatus[playerData.id] = true
        end
    end)

    if playerStatus[0] == true or playerStatus[4] == true or playerStatus[5] == true then
        CC.Systems.SpawnManager.enabledSpawns.north = true
    end

    if playerStatus[3] == true or playerStatus[5] == true or playerStatus[6] == true then
        CC.Systems.SpawnManager.enabledSpawns.east = true
    end

    if playerStatus[1] == true or playerStatus[6] == true or playerStatus[7] == true then
        CC.Systems.SpawnManager.enabledSpawns.south = true
    end

    if playerStatus[2] == true or playerStatus[7] == true or playerStatus[4] == true then
        CC.Systems.SpawnManager.enabledSpawns.west = true
    end

    -- North
    if playerStatus[0] == true then
        CC.Systems.SpawnManager.enabledPaths.north.pathOne = true
    end

    if playerStatus[4] == true then
        CC.Systems.SpawnManager.enabledPaths.north.pathOne = true
    end

    if playerStatus[5] == true then
        CC.Systems.SpawnManager.enabledPaths.north.pathTwo = true
    end

    -- East
    if playerStatus[3] == true then
        CC.Systems.SpawnManager.enabledPaths.east.pathOne = true
    end

    if playerStatus[5] == true then
        CC.Systems.SpawnManager.enabledPaths.east.pathOne = true
    end

    if playerStatus[6] == true then
        CC.Systems.SpawnManager.enabledPaths.east.pathTwo = true
    end

    -- South
    if playerStatus[1] == true then
        CC.Systems.SpawnManager.enabledPaths.south.pathOne = true
    end

    if playerStatus[6] == true then
        CC.Systems.SpawnManager.enabledPaths.south.pathOne = true
    end

    if playerStatus[7] == true then
        CC.Systems.SpawnManager.enabledPaths.south.pathTwo = true
    end

    -- West
    if playerStatus[2] == true then
        CC.Systems.SpawnManager.enabledPaths.west.pathOne = true
    end

    if playerStatus[4] == true then
        CC.Systems.SpawnManager.enabledPaths.west.pathOne = true
    end

    if playerStatus[7] == true then
        CC.Systems.SpawnManager.enabledPaths.west.pathTwo = true
    end
end

--[[
    Spawn a new wave of invaders for a spawn.
]]
function CC.Systems.SpawnManager.SpawnWave(spawn, unitType, total, interval, onComplete)
    if CC.Systems.SpawnManager.enabledSpawns[spawn] ~= true then
        return
    end

    local spawnRegion = CC.Config.Regions.Spawns[spawn];

    if spawnRegion == nil then
        CC.Core.Debug("SpawnManager", "Spawn region does not exist.")
        return
    end

    local pathOne = CC.Systems.SpawnManager.enabledPaths[spawn].pathOne
    local pathTwo = CC.Systems.SpawnManager.enabledPaths[spawn].pathTwo

    if pathOne == true then
        CC.Systems.SpawnManager.spawns[spawn].pathOne = false
    end

    if pathTwo == true then
        CC.Systems.SpawnManager.spawns[spawn].pathTwo = false
    end

    CC.Systems.SpawnManager.invadersAlive = 0

    if pathOne then
        CC.Systems.SpawnManager.StartSpawn(
            spawn,
            "pathOne",
            total,
            unitType,
            spawnRegion,
            interval,
            function (totalSpawned)
                CC.Systems.SpawnManager.SpawnComplete(spawn, totalSpawned, "pathOne", onComplete)
            end
        )
    end

    if pathTwo then
        CC.Systems.SpawnManager.StartSpawn(
            spawn,
            "pathTwo",
            total,
            unitType,
            spawnRegion,
            interval,
            function (totalSpawned)
                CC.Systems.SpawnManager.SpawnComplete(spawn, totalSpawned, "pathTwo", onComplete)
            end
        )
    end
end

--[[
    Handle when the spawn has completed.
]]
function CC.Systems.SpawnManager.SpawnComplete(spawn, totalSpawned, pathKey, onComplete)
    local timer = CreateTimer()

    CC.Systems.SpawnManager.spawns[spawn][pathKey] = true
    CC.Systems.SpawnManager.spawns[spawn].total = CC.Systems.SpawnManager.spawns[spawn].total + totalSpawned

    TimerStart(timer, 0.25, true, function ()
        if CC.Systems.SpawnManager.spawns[spawn].pathOne == false or CC.Systems.SpawnManager.spawns[spawn].pathTwo == false then
            return
        end

        local finalTotalSpawned = CC.Systems.SpawnManager.spawns[spawn].total

        CC.Systems.SpawnManager.spawns[spawn].pathOne = true
        CC.Systems.SpawnManager.spawns[spawn].pathTwo = true
        CC.Systems.SpawnManager.spawns[spawn].total = 0

        PauseTimer(timer)
        DestroyTimer(timer)

        if onComplete ~= nil then
            onComplete(finalTotalSpawned)
        end
    end)
end

--[[
    Start the spawning process.
]]
function CC.Systems.SpawnManager.StartSpawn(spawn, pathKey, total, unitType, spawnRegion, interval, onComplete)
    local spawned = 0
    local timer = CreateTimer()

    TimerStart(timer, interval, true, function ()
        spawned = spawned + 1

        local resolvedSpawn = CC.Systems.SpawnManager.ResolveRegion(spawnRegion)

        local unit = CreateUnit(
            CC.Core.Constants.INVADER_PLAYER,
            unitType,
            GetRectCenterX(resolvedSpawn),
            GetRectCenterY(resolvedSpawn),
            270.00
        )

        CC.Systems.SpawnManager.units[GetHandleId(unit)] = {
            spawn = spawn,
            pathKey = pathKey,
            currentRegion = spawnRegion
        }

        CC.Systems.LeaderboardManager.RegisterDamageTracking(unit)

        CC.Systems.SpawnManager.invadersAlive = CC.Systems.SpawnManager.invadersAlive + 1

        local gameSettings = CC.Systems.GameManager.GetSettings()
        local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]

        local maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
        local newMaxLife = math.floor(maxLife * gameSettings.hpMultiplier)

        BlzSetUnitMaxHP(unit, newMaxLife)
        SetUnitState(unit, UNIT_STATE_LIFE, newMaxLife)

        local baseSpeed = GetUnitMoveSpeed(unit)
        local speed = math.floor(baseSpeed * gameSettings.speedMultiplier)

        SetUnitMoveSpeed(unit, speed)

        if waveSettings.category == CC.Config.WaveCategories.BOSS then
            CC.Systems.BossManager.OnBossSpawn(unit, waveSettings)
        end

        SetUnitPathing(unit, false)

        if spawned >= total then
            PauseTimer(timer)
            DestroyTimer(timer)

            if onComplete then
                onComplete(spawned)
            end
        end
    end)
end

--[[
    Order the spawned unit to the next region.
]]
function CC.Systems.SpawnManager.OrderCreepToNextRegion(boss, unit)
    if boss == nil or unit == nil then
        return
    end

    local bossUnitData = CC.Systems.SpawnManager.units[GetHandleId(boss)]

    if bossUnitData == nil then
        CC.Core.Debug("SpawnManager", "Missing boss unit data.")
        return
    end

    CC.Systems.SpawnManager.units[GetHandleId(unit)] = {
        spawn = bossUnitData.spawn,
        pathKey = bossUnitData.pathKey,
        currentRegion = bossUnitData.currentRegion
    }

    local currentRegion = bossUnitData.currentRegion

    if currentRegion == nil then
        CC.Core.Debug("SpawnManager", "Boss has no current region.")
        return
    end

    local nextRegion = CC.Systems.InvaderPathManager.GetNextRegion(currentRegion, unit)

    if nextRegion == nil then
        CC.Core.Debug("SpawnManager", "Could not find next region for spawned creep.")
        return
    end

    local x, y = CC.Systems.InvaderPathManager.GetRegionCenter(nextRegion)

    if x == nil or y == nil then
        return
    end

    IssuePointOrder(unit, "move", x, y)
end

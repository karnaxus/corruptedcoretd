--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Leaderboard Manager                                       |
    | ========================================================= |
    | Manages leaderboard like stuff for players.               |
    +-----------------------------------------------------------+
]]

CC.Systems.LeaderboardManager = CC.Systems.LeaderboardManager or {}

CC.Systems.LeaderboardManager.mostKills = CC.Systems.LeaderboardManager.mostKills or {}
CC.Systems.LeaderboardManager.currentKills = CC.Systems.LeaderboardManager.currentKills or {}
CC.Systems.LeaderboardManager.calculatedKills = CC.Systems.LeaderboardManager.calculatedKills or {}
CC.Systems.LeaderboardManager.currentDamage = CC.Systems.LeaderboardManager.currentDamage or {}
CC.Systems.LeaderboardManager.waveTimers = CC.Systems.LeaderboardManager.waveTimers or {}
CC.Systems.LeaderboardManager.waveTimes = CC.Systems.LeaderboardManager.waveTimes or {}
CC.Systems.LeaderboardManager.waveEndSummaryEnabled = CC.Systems.LeaderboardManager.waveEndSummaryEnabled or {}

--[[
    Initialize the Leaderboard Manager.
]]
function CC.Systems.LeaderboardManager.Init()
    CC.Core.Debug("LeaderboardManager", "Initializing the Leaderboard Manager...")

    CC.Systems.LeaderboardManager.mostKills = {}
    CC.Systems.LeaderboardManager.currentKills = {}
    CC.Systems.LeaderboardManager.calculatedKills = {}
    CC.Systems.LeaderboardManager.waveTimers = {}
    CC.Systems.LeaderboardManager.waveTimes = {}
    
    CC.Systems.PlayerManager.ForEach(function (playerData)
        CC.Systems.LeaderboardManager.waveEndSummaryEnabled[playerData.id] = true
    end)

    CC.Core.Debug("LeaderboardManager", "Leaderboard Manager initialized.")
end

--[[
    Start recording the total kills for each player for a wave.
]]
function CC.Systems.LeaderboardManager.StartKillRecordForWave(wave)
    CC.Systems.LeaderboardManager.currentKills[wave] = {}
    CC.Systems.LeaderboardManager.calculatedKills[wave] = {}

    CC.Systems.PlayerManager.ForEach(function (playerData)
        CC.Systems.LeaderboardManager.currentKills[wave][playerData.id] = playerData.kills or 0
    end)
end

--[[
    Stops recording the total kills, determines the top killer for the wave and announces it.
]]
function CC.Systems.LeaderboardManager.StopKillRecord(wave)
    if CC.Systems.LeaderboardManager.currentKills[wave] == nil then
        return
    end

    CC.Systems.LeaderboardManager.calculatedKills[wave] = {}

    CC.Systems.PlayerManager.ForEach(function (playerData)
        CC.Systems.LeaderboardManager.calculatedKills[wave][playerData.id] = playerData.kills - CC.Systems.LeaderboardManager.currentKills[wave][playerData.id]
    end)

    local top = {
        total = 0,
        playerId = nil
    }

    CC.Systems.PlayerManager.ForEach(function (playerData)
        if CC.Systems.LeaderboardManager.calculatedKills[wave][playerData.id] > top.total then
            top.total = CC.Systems.LeaderboardManager.calculatedKills[wave][playerData.id]
            top.playerId = playerData.id
        end
    end)

    if top == nil or top.total == nil or top.playerId == nil then
        return
    end

    local player = Player(top.playerId)
    local playerInfo = CC.Systems.PlayerManager.GetPlayer(player)

    if playerInfo == nil then
        return
    end

    local topKiller = playerInfo
    local totalKills = top.total

    return topKiller, totalKills
end

--[[
    Start recording the total damage for all players for the wave.
]]
function CC.Systems.LeaderboardManager.StartDamageRecordForWave(wave)
    CC.Systems.LeaderboardManager.currentDamage[wave] = {}

    CC.Systems.PlayerManager.ForEach(function (playerData)
        CC.Systems.LeaderboardManager.currentDamage[wave][playerData.id] = 0
    end)
end

--[[
    Register damage tracking for determining the most damage done for a wave.
]]
function CC.Systems.LeaderboardManager.RegisterDamageTracking(unit)
    local trigger = CreateTrigger()

    TriggerRegisterUnitEvent(trigger, unit, EVENT_UNIT_DAMAGED)

    TriggerAddAction(trigger, function ()
        local damageSource = GetEventDamageSource()
        local damage = GetEventDamage()

        if damageSource == nil or damage <= 0 then
            return
        end

        local player = GetOwningPlayer(damageSource)
        local playerData = CC.Systems.PlayerManager.GetPlayer(player)

        if playerData == nil then
            return
        end

        local wave = CC.Systems.WaveManager.currentWave

        if CC.Systems.LeaderboardManager.currentDamage[wave] == nil then
            return
        end

        CC.Systems.LeaderboardManager.currentDamage[wave][playerData.id] =
            (CC.Systems.LeaderboardManager.currentDamage[wave][playerData.id] or 0) + damage

        CC.Systems.EndGameSummaryManager.AddDamage(playerData, damage)
    end)
end

--[[
    Stops recording damage, determines the top damager for the wave an announces it.
]]
function CC.Systems.LeaderboardManager.StopDamageRecord(wave)
    local damageTable = CC.Systems.LeaderboardManager.currentDamage[wave]

    if damageTable == nil then
        return
    end

    local top = {
        total = 0,
        playerId = nil
    }

    CC.Systems.PlayerManager.ForEach(function (playerData)
        local damage = damageTable[playerData.id] or 0

        if damage > top.total then
            top.total = damage
            top.playerId = playerData.id
        end
    end)

    if top.playerId == nil or top.total <= 0 then
        return
    end

    local player = Player(top.playerId)
    local playerInfo = CC.Systems.PlayerManager.GetPlayer(player)

    if playerInfo == nil then
        return
    end

    local topDamager = playerInfo
    local totalDamage = CC.Core.Helpers.FormatNumber(top.total)

    return topDamager, totalDamage
end

--[[
    Start the timer for a wave.
]]
function CC.Systems.LeaderboardManager.StartWaveTimer(wave)
    local timer = CreateTimer()

    CC.Systems.LeaderboardManager.waveTimers[wave] = timer

    TimerStart(timer, 999999.00, false, nil)
end

--[[
    Stop the wave timer.
]]
function CC.Systems.LeaderboardManager.StopWaveTimer(wave)
    local timer = CC.Systems.LeaderboardManager.waveTimers[wave]

    if timer == nil then
        return
    end

    local elapsed = TimerGetElapsed(timer)

    CC.Systems.LeaderboardManager.waveTimes[wave] = elapsed

    PauseTimer(timer)
    DestroyTimer(timer)

    CC.Systems.LeaderboardManager.waveTimers[wave] = nil

    local formattedTime = CC.Core.Helpers.FormatTime(CC.Systems.LeaderboardManager.waveTimes[wave])

    if formattedTime == nil then
        return
    end

    return formattedTime
end

--[[
    Build the summary for a wave at the end of it.
]]
function CC.Systems.LeaderboardManager.WaveEndSummary(wave)
    if CC.Core.waveEndSummary == false then
        return
    end

    local topKiller, totalKills = CC.Systems.LeaderboardManager.StopKillRecord(wave)
    local topDamager, totalDamage = CC.Systems.LeaderboardManager.StopDamageRecord(wave)
    local formattedTime = CC.Systems.LeaderboardManager.StopWaveTimer(wave)

    if topKiller == nil or totalKills == nil or topDamager == nil or totalDamage == nil or formattedTime == nil then
        return
    end

    local summary =
        CC.Core.Color.Teal("===============================\n") ..
        CC.Core.Color.Yellow("Wave ") ..
        CC.Core.Color.Orange(tostring(wave)) ..
        CC.Core.Color.Yellow(" Complete!\n\n") ..
        CC.Core.Color.Green("Top Killer:\n") ..
        CC.Core.Color.Wrap(topKiller.color, topKiller.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(tostring(totalKills)) ..
        CC.Core.Color.Yellow(" " .. CC.Core.Helpers.SingularOrPlural("kill", "kills", totalKills)) .. "\n\n" ..
        CC.Core.Color.Green("Top Damager:\n") ..
        CC.Core.Color.Wrap(topDamager.color, topDamager.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(totalDamage) ..
        CC.Core.Color.Yellow(" damage\n\n") ..
        CC.Core.Color.Green("Wave Time:\n") ..
        CC.Core.Color.Orange(formattedTime) .. "\n" ..
        CC.Core.Color.Teal("===============================")

    CC.Systems.PlayerManager.ForEach(function (playerData)
        local playerId = playerData.id

        if CC.Systems.LeaderboardManager.waveEndSummaryEnabled[playerId] == true then
            CC.Systems.PlayerManager.PlaySoundForPlayer(playerData.player, gg_snd_WaveComplete)

            CC.UI.MessageManager.Player(
                playerData.player,
                summary
            )
        end
    end)
end
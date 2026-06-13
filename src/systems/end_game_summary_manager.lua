--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | End Game Summary Manager                                  |
    | ========================================================= |
    | Manages the end game summary results.                     |
    +-----------------------------------------------------------+
]]

CC.Systems.EndGameSummaryManager = CC.Systems.EndGameSummaryManager or {}

CC.Systems.EndGameSummaryManager.playerStats = CC.Systems.EndGameSummaryManager.playerStats or {}
CC.Systems.EndGameSummaryManager.summary = nil

--[[
    Initialize the End Game Summary Manager.
]]
function CC.Systems.EndGameSummaryManager.Init()
    CC.Core.Debug("EndGameSummaryManager", "Initializing the End Game Summary Manager...")

    CC.Systems.EndGameSummaryManager.playerStats = {}
    CC.Systems.EndGameSummaryManager.summary = nil

    CC.Core.Debug("EndGameSummaryManager", "End Game Summary Manager initialized.")
end

--[[
    Ensure summary stats exist for a player.
]]
function CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)
    if playerData == nil then
        return
    end

    local id = playerData.id

    if CC.Systems.EndGameSummaryManager.playerStats[id] == nil then
        CC.Systems.EndGameSummaryManager.playerStats[id] = {
            player = playerData.player,
            id = id,
            name = playerData.name,
            color = playerData.color,
            kills = 0,
            damage = 0,
            goldEarned = 0,
            goldSpent = 0,
            towersBuilt = 0,
            towersSold = 0,
            towersUpgraded = 0,
            bossesKilled = 0
        }
    end

    return CC.Systems.EndGameSummaryManager.playerStats[id]
end

--[[
    Add kills for a player.
]]
function CC.Systems.EndGameSummaryManager.AddKills(playerData, amount)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.kills = stats.kills + (amount or 1)
    end
end

--[[
    Add damage for a player.
]]
function CC.Systems.EndGameSummaryManager.AddDamage(playerData, amount)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.damage = stats.damage + (amount or 0)
    end
end

--[[
    Add gold earned for a player.
]]
function CC.Systems.EndGameSummaryManager.AddGoldEarned(playerData, amount)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.goldEarned = stats.goldEarned + (amount or 0)
    end
end

--[[
    Add gold spent for a player.
]]
function CC.Systems.EndGameSummaryManager.AddGoldSpent(playerData, amount)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.goldSpent = stats.goldSpent + (amount or 0)
    end
end

--[[
    Add tower built count for a player.
]]
function CC.Systems.EndGameSummaryManager.AddTowersBuilt(playerData)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.towersBuilt = stats.towersBuilt + 1
    end
end

--[[
    Add tower sold count for a player
]]
function CC.Systems.EndGameSummaryManager.AddTowerSold(playerData)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.towersSold = stats.towersSold + 1
    end
end

--[[
    Add tower upgraded count for a player.
]]
function CC.Systems.EndGameSummaryManager.AddTowerUpgraded(playerData)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.towersUpgraded = stats.towersUpgraded + 1
    end
end

--[[
    Add boss kill count for a player.
]]
function CC.Systems.EndGameSummaryManager.AddBossKilled(playerData)
    local stats = CC.Systems.EndGameSummaryManager.EnsurePlayer(playerData)

    if stats ~= nil then
        stats.bossesKilled = stats.bossesKilled + 1
    end
end

--[[
    Get the player with the highest value for a stat.
]]
function CC.Systems.EndGameSummaryManager.GetTopPlayer(statName)
    local best = nil

    for _, stats in pairs(CC.Systems.EndGameSummaryManager.playerStats) do
        if best == nil or stats[statName] > best[statName] then
            best = stats
        end
    end

    return best
end

--[[
    Build the final end game summary data.
]]
function CC.Systems.EndGameSummaryManager.BuildSummary(result)
    local summary = {
        result = result or "Unknown",

        waveReached = CC.Systems.WaveManager.currentWave or 0,
        totalWaves = CC.Core.Constants.MAX_WAVES,

        playerStats = CC.Systems.EndGameSummaryManager.playerStats,

        mostKills = CC.Systems.EndGameSummaryManager.GetTopPlayer("kills"),
        mostDamage = CC.Systems.EndGameSummaryManager.GetTopPlayer("damage"),
        mostGoldEarned = CC.Systems.EndGameSummaryManager.GetTopPlayer("goldEarned"),
        mostTowersBuilt = CC.Systems.EndGameSummaryManager.GetTopPlayer("towersBuilt"),
        mostTowersUpgraded = CC.Systems.EndGameSummaryManager.GetTopPlayer("towersUpgraded"),
        mostBossKills = CC.Systems.EndGameSummaryManager.GetTopPlayer("bossesKilled")
    }

    CC.Systems.EndGameSummaryManager.summary = summary

    return summary
end

--[[
    Output the end game summary to all players.
]]
function CC.Systems.EndGameSummaryManager.OutputSummary(result)
    local summaryData = CC.Systems.EndGameSummaryManager.BuildSummary(result)
    local gameTime = CC.Core.Helpers.FormatTime(CC.Systems.GameManager.GetGameTime())

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Teal("=================================\n") ..
        CC.Core.Color.Yellow(CC.Core.Helpers.CenterText(summaryData.result, 32)) ..
        CC.Core.Color.Teal("=================================\n\n") ..
        CC.Core.Color.Yellow("Wave Reached: ") ..
        CC.Core.Color.Orange(tostring(summaryData.waveReached)) ..
        CC.Core.Color.Yellow(" / ") ..
        CC.Core.Color.Orange(tostring(summaryData.totalWaves)) .. "\n" ..
        CC.Core.Color.Yellow("Game Time: ") ..
        CC.Core.Color.Orange(gameTime) .. "\n\n" ..
        CC.Core.Color.Green("Most Kills\n") ..
        CC.Core.Color.Wrap(summaryData.mostKills.color, summaryData.mostKills.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(summaryData.mostKills.kills)) .. "\n\n" ..
        CC.Core.Color.Green("Most Damage\n") ..
        CC.Core.Color.Wrap(summaryData.mostDamage.color, summaryData.mostDamage.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(summaryData.mostDamage.damage)) .. "\n\n" ..
        CC.Core.Color.Green("Most Gold Earned\n") ..
        CC.Core.Color.Wrap(summaryData.mostGoldEarned.color, summaryData.mostGoldEarned.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(summaryData.mostGoldEarned.goldEarned)) .. "\n\n" ..
        CC.Core.Color.Green("Most Builders\n") ..
        CC.Core.Color.Wrap(summaryData.mostTowersBuilt.color, summaryData.mostTowersBuilt.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(tostring(summaryData.mostTowersBuilt.towersBuilt)) .. " " ..
        CC.Core.Color.Yellow(CC.Core.Helpers.SingularOrPlural("tower", "towers", summaryData.mostTowersBuilt.towersBuilt)) .. "\n\n" ..
        CC.Core.Color.Green("Most Upgrades\n") ..
        CC.Core.Color.Wrap(summaryData.mostTowersUpgraded.color, summaryData.mostTowersUpgraded.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(tostring(summaryData.mostTowersUpgraded.towersUpgraded)) .. " " ..
        CC.Core.Color.Yellow(CC.Core.Helpers.SingularOrPlural("upgrade", "upgrades", summaryData.mostTowersUpgraded.towersUpgraded)) .. "\n\n" ..
        CC.Core.Color.Green("Boss Slayer\n") ..
        CC.Core.Color.Wrap(summaryData.mostBossKills.color, summaryData.mostBossKills.name) ..
        CC.Core.Color.Yellow(" - ") ..
        CC.Core.Color.Orange(tostring(summaryData.mostBossKills.bossesKilled)) .. " " ..
        CC.Core.Color.Yellow(CC.Core.Helpers.SingularOrPlural("boss", "bosses", summaryData.mostBossKills.bossesKilled)) .. "\n" ..
        CC.Core.Color.Teal("=================================")
    )

    CC.Systems.EndGameSummaryManager.OutputIndividualStats(summaryData)
end

--[[
    Output stats for each individual player.
]]
function CC.Systems.EndGameSummaryManager.OutputIndividualStats(summaryData)
    CC.Systems.PlayerManager.ForEach(function (playerData)
        local data = summaryData.playerStats[playerData.id]

        if data == nil then
            return
        end

        CC.UI.MessageManager.Player(
            playerData.player,
            CC.Core.Color.Teal("\n\n=================================\n") ..
            CC.Core.Color.Yellow(CC.Core.Helpers.CenterText("YOUR FINAL STATS", 32)) .. "\n" ..
            CC.Core.Color.Teal("=================================\n") ..
            CC.Core.Color.Yellow("Kills: ") .. CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(data.kills)) .. "\n" ..
            CC.Core.Color.Yellow("Damage: ") .. CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(data.damage)) .. "\n" ..
            CC.Core.Color.Yellow("Gold Earned: ") .. CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(data.goldEarned)) .. "\n" ..
            CC.Core.Color.Yellow("Gold Spent: ") .. CC.Core.Color.Orange(CC.Core.Helpers.FormatNumber(data.goldSpent)) .. "\n" ..
            CC.Core.Color.Yellow("Towers Built: ") .. CC.Core.Color.Orange(tostring(data.towersBuilt)) .. "\n" ..
            CC.Core.Color.Yellow("Towers Upgraded: ") .. CC.Core.Color.Orange(tostring(data.towersUpgraded)) .. "\n" ..
            CC.Core.Color.Yellow("Towers Sold: ") .. CC.Core.Color.Orange(tostring(data.towersSold)) .. "\n" ..
            CC.Core.Color.Yellow("Bosses Killed: ") .. CC.Core.Color.Orange(tostring(data.bossesKilled)) .. "\n" ..
            CC.Core.Color.Teal("=================================")
        )
    end)
end
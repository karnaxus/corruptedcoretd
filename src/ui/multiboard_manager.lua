--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Multiboard Manager                                        |
    | ========================================================= |
    | Manages creating and maintaining the multiboard.          |
    +-----------------------------------------------------------+
]]

CC.UI.MultiboardManager = CC.UI.MultiboardManager or {}

CC.UI.MultiboardManager.board = nil

--[[
    Icons for use in the multiboard.
]]
CC.UI.MultiboardManager.icons = {
    player = "ReplaceableTextures\\CommandButtons\\BTNVillagerMan.blp",
    kills = "ReplaceableTextures\\CommandButtons\\BTNDeathCoil.blp",
    gold = "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp",
    wave = "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp",
    leak = "ReplaceableTextures\\CommandButtons\\BTNEnsnare.blp",
    air = "ReplaceableTextures\\CommandButtons\\BTNWarEagle.blp",
    boss = "ReplaceableTextures\\CommandButtons\\BTNDoomGuard.blp",
    invaders = "ReplaceableTextures\\CommandButtons\\BTNShade.blp",
    goldInterval = "ReplaceableTextures\\CommandButtons\\BTNGoldMine.blp",
    difficulty = "ReplaceableTextures\\CommandButtons\\BTNSnazzyScrollPurple.blp"
}

--[[
    Initialize the Multiboard Manager.
]]
function CC.UI.MultiboardManager.Init()
    CC.Core.Debug("MultiboardManager", "Initializing Multiboard Manager...")

    CC.UI.MultiboardManager.board = CreateMultiboard()

    MultiboardSetColumnCount(CC.UI.MultiboardManager.board, 4)
    MultiboardSetRowCount(CC.UI.MultiboardManager.board, 1)

    CC.Core.Debug("MultiboardManager", "Rebuilding multiboard...")
    CC.UI.MultiboardManager.Rebuild()

    MultiboardDisplay(CC.UI.MultiboardManager.board, true)
    MultiboardMinimize(CC.UI.MultiboardManager.board, false)

    local timer = CreateTimer()

    TimerStart(timer, 1.00, true, function ()
        CC.UI.MultiboardManager.Update()
    end)

    CC.Core.Debug("MultiboardManager", "Multiboard Manager initialized.")
end

--[[
    Set a cell in the multiboard.
]]
function CC.UI.MultiboardManager.SetCell(row, column, value, width)
    local item = MultiboardGetItem(CC.UI.MultiboardManager.board, row, column)

    MultiboardSetItemValue(item, tostring(value))
    MultiboardSetItemStyle(item, true, false)

    if width ~= nil then
        MultiboardSetItemWidth(item, width)
    end

    MultiboardReleaseItem(item)
end

--[[
    Set an icon for a column.
]]
function CC.UI.MultiboardManager.SetColumnIcon(row, col, icon)
    local item = MultiboardGetItem(CC.UI.MultiboardManager.board, row, col)

    if (item == nil or icon == nil) then
        return
    end

    MultiboardSetItemStyle(item, true, true)
    MultiboardSetItemIcon(item, icon)
    MultiboardSetItemWidth(item, 0.015)
    MultiboardReleaseItem(item)
end

--[[
    Set the width for every cell in a column.
]]
function CC.UI.MultiboardManager.SetColumnWidth(column, width)
    local board = CC.UI.MultiboardManager.board

    if board == nil then
        return
    end

    local rowCount = MultiboardGetRowCount(board)

    for row = 0, rowCount - 1 do
        local item = MultiboardGetItem(board, row, column)

        if item ~= nil then
            MultiboardSetItemWidth(item, width)
            MultiboardReleaseItem(item)
        end
    end
end

--[[
    Set a cell with text and an icon.
]]
function CC.UI.MultiboardManager.SetIconCell(row, col, value, icon, width)
    local item = MultiboardGetItem(CC.UI.MultiboardManager.board, row, col)

    MultiboardSetItemValue(item, tostring(value))
    MultiboardSetItemStyle(item, true, true)
    MultiboardSetItemIcon(item, icon)

    if width ~= nil then
        MultiboardSetItemWidth(item, width)
    end

    MultiboardReleaseItem(item)
end

--[[
    Set an empty cell.
]]
function CC.UI.MultiboardManager.SetEmptyCell(row, col, width)
    local item = MultiboardGetItem(CC.UI.MultiboardManager.board, row, col)

    MultiboardSetItemValue(item, "")
    MultiboardSetItemStyle(item, true, false)

    if width ~= nil then
        MultiboardSetItemWidth(item, width)
    end

    MultiboardReleaseItem(item)
end

--[[
    Print the game difficulty in the correct order.
]]
function CC.UI.MultiboardManager.PrintDiffWithColor(difficulty)
    local diffMapping = {
        ["Easy"] = CC.Core.Color.Green(difficulty),
        ["Medium"] = CC.Core.Color.Yellow(difficulty),
        ["Hard"] = CC.Core.Color.Orange(difficulty),
        ["Insane"] = CC.Core.Color.Red(difficulty)
    }

    if diffMapping[difficulty] == nil then
        CC.Core.Debug("MultiboardManager", "Invalid difficulty: " .. difficulty)
        return
    end

    return diffMapping[difficulty]
end

--[[
    Rebuild the multiboard.
]]
function CC.UI.MultiboardManager.Rebuild()
    local board = CC.UI.MultiboardManager.board
    local players = {}

    CC.Systems.PlayerManager.ForEach(function (playerData)
        table.insert(players, playerData)
    end)

    MultiboardSetRowCount(board, #players + 9)

    local icons = CC.UI.MultiboardManager.icons
    local row = 1

    for _, playerData in ipairs(players) do
        local playerName = playerData.name

        if CC.Systems.PlayerManager.hasLeft[playerData.id] then
            playerName = playerData.name .. " [LEFT]"
        end

        CC.UI.MultiboardManager.SetCell(row, 0, playerName)

        row = row + 1
    end

    local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]
    local airWave = CC.Core.Color.Red("No")
    local bossWave = CC.Core.Color.Red("No")

    if waveSettings and waveSettings.isAir then
        airWave = CC.Core.Color.Green("Yes")
    end

    if waveSettings and waveSettings.isBoss then
        bossWave = CC.Core.Color.Green("Yes")
    end

    local infoRow = #players + 2

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.wave)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Wave"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.WaveManager.currentWave)), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.leak)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Leaks Left"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.EndZoneManager.GetLeaksLeft())), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.invaders)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Invaders Alive"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.SpawnManager.invadersAlive)), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.air)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Air Wave"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, airWave, 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.boss)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Boss Wave"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, bossWave, 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.goldInterval)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Income Timer"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.IntervalGoldManager.GetRemaining()) .. " seconds"), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.difficulty)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Difficulty"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.UI.MultiboardManager.PrintDiffWithColor(tostring(CC.Systems.GameManager.difficulty)), 0.10)
    
    CC.UI.MultiboardManager.SetColumnWidth(0, 0.015)
    CC.UI.MultiboardManager.SetColumnWidth(1, 0.12)
    CC.UI.MultiboardManager.SetColumnWidth(2, 0.015)
    CC.UI.MultiboardManager.SetColumnWidth(3, 0.05)

    MultiboardDisplay(board, true)
    MultiboardMinimize(board, false)
end

--[[
    Update the multiboard.
]]
function CC.UI.MultiboardManager.Update()
    local board = CC.UI.MultiboardManager.board

    if board == nil then
        return
    end

    if CC.Systems.GameManager == nil or CC.Systems.WaveManager == nil then
        return
    end

    local waveSettings = CC.Config.Waves[CC.Systems.WaveManager.currentWave]
    local airWave = CC.Core.Color.Red("No")
    local bossWave = CC.Core.Color.Red("No")

    if waveSettings and waveSettings.isAir then
        airWave = CC.Core.Color.Green("Yes")
    end

    if waveSettings and waveSettings.isBoss then
        bossWave = CC.Core.Color.Green("Yes")
    end

    MultiboardSetTitleText(board, CC.Core.Color.Teal("Corrupted Core ") .. CC.Core.Color.Yellow("TD"))

    local icons = CC.UI.MultiboardManager.icons

    CC.UI.MultiboardManager.SetIconCell(0, 0, CC.Core.Color.Yellow("Player"), icons.player, 0.13)
    CC.UI.MultiboardManager.SetIconCell(0, 1, CC.Core.Color.Yellow("Kills"), icons.kills, 0.06)
    CC.UI.MultiboardManager.SetIconCell(0, 2, CC.Core.Color.Yellow("Gold"), icons.gold, 0.06)
    CC.UI.MultiboardManager.SetCell(0, 3, "", 0.01)

    local row = 1

    CC.Systems.PlayerManager.ForEach(function (playerData)
        local player = playerData.player

        CC.UI.MultiboardManager.SetCell(row, 0, CC.Core.Color.Wrap(playerData.color, playerData.name), 0.13)
        CC.UI.MultiboardManager.SetCell(row, 1, CC.Core.Color.Orange(tostring(playerData.kills)), 0.06)
        CC.UI.MultiboardManager.SetCell(row, 2, CC.Core.Color.Orange(tostring(CC.Systems.PlayerManager.GetResource(player, "gold"))), 0.08)
        CC.UI.MultiboardManager.SetCell(row, 3, "", 0.01)

        row = row + 1
    end)

    local spacerRow = row

    CC.UI.MultiboardManager.SetCell(spacerRow, 0, "", 0.13)
    CC.UI.MultiboardManager.SetCell(spacerRow, 1, "", 0.06)
    CC.UI.MultiboardManager.SetCell(spacerRow, 2, "", 0.08)
    CC.UI.MultiboardManager.SetCell(spacerRow, 3, "", 0.01)

    local infoRow = spacerRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.wave)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Wave"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.WaveManager.currentWave)), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.leak)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Leaks Left"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.EndZoneManager.GetLeaksLeft())), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.invaders)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Invaders Alive"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.SpawnManager.invadersAlive)), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.air)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Air Wave"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, airWave, 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.boss)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Boss Wave"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, bossWave, 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.goldInterval)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Income Timer"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.Core.Color.Orange(tostring(CC.Systems.IntervalGoldManager.GetRemaining()) .. " seconds"), 0.10)

    infoRow = infoRow + 1

    CC.UI.MultiboardManager.SetColumnIcon(infoRow, 0, icons.difficulty)
    CC.UI.MultiboardManager.SetCell(infoRow, 1, CC.Core.Color.Yellow("Difficulty"), 0.12)
    CC.UI.MultiboardManager.SetEmptyCell(infoRow, 2)
    CC.UI.MultiboardManager.SetCell(infoRow, 3, CC.UI.MultiboardManager.PrintDiffWithColor(tostring(CC.Systems.GameManager.difficulty)), 0.10)
end
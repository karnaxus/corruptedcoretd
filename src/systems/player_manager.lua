--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Player Manager                                            |
    | ========================================================= |
    | Responsible for managing players.                         |
    +-----------------------------------------------------------+
]]

CC.Systems.PlayerManager = CC.Systems.PlayerManager or {}

CC.Systems.PlayerManager.players = {}

CC.Systems.PlayerManager.colors = {
    [0]  = "FF0303",
    [1]  = "0042FF",
    [2]  = "1CE6B9",
    [3]  = "540081",
    [4]  = "FFFC01",
    [5]  = "FE8A0E",
    [6]  = "20C000",
    [7]  = "E55BB0"
}

CC.Systems.PlayerManager.hasLeft = CC.Systems.PlayerManager.hasLeft or {}

--[[
    Initialize the Player Manager.
]]
function CC.Systems.PlayerManager.Init()
    CC.Core.Debug("PlayerManager", "Initializing the Player Manager...")

    for i = 0, 7 do
        local player = Player(i)

        if CC.Systems.PlayerManager.IsPlaying(player) then
            CC.Systems.PlayerManager.players[i] = {
                id = i,
                player = player,
                name = GetPlayerName(player),
                color = CC.Systems.PlayerManager.GetPlayerColor(player),
                active = true,
                kills = 0
            }

            CC.Core.Debug("PlayerManager", "Active player: " .. CC.Systems.PlayerManager.players[i].name)
        end
    end

    CC.Systems.PlayerManager.InitLeaveTrigger()
    CC.Systems.PlayerManager.InitGoldSharingTrigger()

    CC.Core.Debug("PlayerManager", "Player Manager initialized.")
end

--[[
    Determine whether a player is playing and is a human player.
]]
function CC.Systems.PlayerManager.IsPlaying(player)
    if player == nil then
        return false
    end

    return GetPlayerSlotState(player) == PLAYER_SLOT_STATE_PLAYING
        and GetPlayerController(player) == MAP_CONTROL_USER
end

--[[
    Get the color for a player.
]]
function CC.Systems.PlayerManager.GetPlayerColor(player)
    return CC.Systems.PlayerManager.colors[GetPlayerId(player)] or "FFFFFF"
end

--[[
    Execute a callback for each player.
]]
function CC.Systems.PlayerManager.ForEach(callback)
    for i = 0, 7 do
        local playerData = CC.Systems.PlayerManager.players[i]

        if playerData ~= nil then
            callback(playerData)
        end
    end
end

--[[
    Get the total players.
]]
function CC.Systems.PlayerManager.TotalPlayers()
    local total = 0

    CC.Systems.PlayerManager.ForEach(function ()
        total = total + 1
    end)

    return total
end

--[[
    Get all players.
]]
function CC.Systems.PlayerManager.GetPlayers()
    return CC.Systems.PlayerManager.players
end

--[[
    Get the data for a player.
]]
function CC.Systems.PlayerManager.GetPlayer(player)
    return CC.Systems.PlayerManager.players[GetPlayerId(player)]
end

--[[
    Add a resource to a player.
]]
function CC.Systems.PlayerManager.AddResource(player, resource, value)
    if resource == "gold" then
        SetPlayerState(
            player,
            PLAYER_STATE_RESOURCE_GOLD,
            GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD) + value
        )

        local playerData = CC.Systems.PlayerManager.GetPlayer(player)

        if playerData == nil then
            return
        end

        CC.Systems.EndGameSummaryManager.AddGoldEarned(playerData, value)
    elseif resource == "lumber" then
        SetPlayerState(
            player,
            PLAYER_STATE_RESOURCE_LUMBER,
            GetPlayerState(player, PLAYER_STATE_RESOURCE_LUMBER) + value
        )
    else
        CC.Core.Debug("PlayerManager", "Unknown player resource: " .. tostring(resource))
        return
    end
end

--[[
    Add resource to all players.
]]
function CC.Systems.PlayerManager.AddResourceToAllPlayers(resource, value)
    CC.Systems.PlayerManager.ForEach(function (playerData)
        CC.Systems.PlayerManager.AddResource(
            playerData.player,
            resource,
            value
        )
    end)
end

--[[
    Get resource for a player.
]]
function CC.Systems.PlayerManager.GetResource(player, resource)
    local resourceMapping = {
        gold = PLAYER_STATE_RESOURCE_GOLD,
        lumber = PLAYER_STATE_RESOURCE_LUMBER
    }

    local mappedResource = resourceMapping[resource]

    if mappedResource == nil then
        CC.Core.Debug("PlayerManager", "Unknown player resource: " .. tostring(resource))
        return 0
    end

    return GetPlayerState(player, mappedResource)
end

--[[
    Spawn the tower builders for each player.
]]
function CC.Systems.PlayerManager.SpawnTowerBuilders()
    CC.Systems.PlayerManager.ForEach(function (playerData)
        local startLocation = GetPlayerStartLocation(playerData.player)

        local x = GetStartLocationX(startLocation)
        local y = GetStartLocationY(startLocation)

        CC.Systems.SpawnManager.SpawnUnitAtXY(
            playerData.player,
            CC.Core.Constants.TOWER_BUILDER,
            x,
            y,
            270.00
        )
    end)
end

--[[
    Initialize the player left trigger.
]]
function CC.Systems.PlayerManager.InitLeaveTrigger()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerEvent(
            trigger,
            Player(i),
            EVENT_PLAYER_LEAVE
        )
    end

    TriggerAddAction(trigger, function ()
        local player = GetTriggerPlayer()

        CC.Systems.PlayerManager.OnPlayerLeave(player)
    end)
end

--[[
    Handle when a player leaves the game.
]]
function CC.Systems.PlayerManager.OnPlayerLeave(player)
    if player == nil then
        return
    end

    local playerId = GetPlayerId(player)

    if CC.Systems.PlayerManager.hasLeft[playerId] == true then
        return
    end

    CC.Systems.PlayerManager.hasLeft[playerId] = true

    StartSound(gg_snd_PlayerLeft)

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Wrap(CC.Systems.PlayerManager.GetPlayerColor(player), GetPlayerName(player)) ..
        CC.Core.Color.Yellow(" has left the game.")
    )

    local receiver = CC.Systems.PlayerManager.GetRandomActivePlayer(player)

    if receiver == nil then
        CC.UI.MessageManager.Broadcast(
            CC.Core.Color.Red("No active players remain.")
        )

        return
    end

    CC.Systems.UnitManager.TransferUnits(player, receiver)

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Yellow("All units owned by ") ..
        CC.Core.Color.Wrap(CC.Systems.PlayerManager.GetPlayerColor(player), GetPlayerName(player)) ..
        CC.Core.Color.Yellow(" have been transferred to ") ..
        CC.Core.Color.Wrap(CC.Systems.PlayerManager.GetPlayerColor(receiver), GetPlayerName(receiver)) ..
        CC.Core.Color.Yellow(".")
    )
end

--[[
    Get a random active player.
]]
function CC.Systems.PlayerManager.GetRandomActivePlayer(excludePlayer)
    local players = {}

    for i = 0, 7 do
        local player = Player(i)

        if player ~= excludePlayer and
            CC.Systems.PlayerManager.IsPlaying(player) and
            CC.Systems.PlayerManager.hasLeft[GetPlayerId(player)] ~= true then
            
            table.insert(players, player)
        end
    end

    if #players <= 0 then
        return nil
    end

    return players[GetRandomInt(1, #players)]
end

--[[
    Initialize the gold sharing triggers.
]]
function CC.Systems.PlayerManager.InitGoldSharingTrigger()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerChatEvent(
            trigger,
            Player(i),
            "/give gold",
            false
        )
    end

    TriggerAddAction(trigger, function ()
        local player = GetTriggerPlayer()
        local message = GetEventPlayerChatString()

        CC.Systems.PlayerManager.HandleGiveGoldCommand(player, message)
    end)
end

--[[
    Handle the give gold command.
]]
function CC.Systems.PlayerManager.HandleGiveGoldCommand(sender, message)
    if sender == nil or message == nil then
        return
    end

    local targetName, amountText = CC.Systems.PlayerManager.ParseGiveGoldCommand(message)

    if targetName == nil or amountText == nil then
        CC.UI.MessageManager.Player(
            sender,
            CC.Core.Color.Yellow("Usage: ") ..
            CC.Core.Color.White("/give gold playername amount")
        )

        return
    end

    local amount = tonumber(amountText)

    if amount == nil or amount <= 0 then
        CC.UI.MessageManager.Player(
            sender,
            CC.Core.Color.Red("Invalid gold amount.")
        )

        return
    end

    amount = math.floor(amount)

    local target = CC.Systems.PlayerManager.FindPlayerByName(targetName)

    if target == nil then
        CC.UI.MessageManager.Player(
            sender,
            CC.Core.Color.Red("Could not find player: ") ..
            CC.Core.Color.Yellow(targetName)
        )

        return
    end

    if target == sender then
        CC.UI.MessageManager.Player(
            sender,
            CC.Core.Color.Red("You cannot give gold to yourself.")
        )

        return
    end

    if CC.Systems.PlayerManager.hasLeft ~= nil and
        CC.Systems.PlayerManager.hasLeft[GetPlayerId(target)] == true then
            
        CC.UI.MessageManager.Player(
            sender,
            CC.Core.Color.Red("That player has left the game.")
        )

        return
    end

    local senderGold = CC.Systems.PlayerManager.GetResource(sender, "gold")

    if senderGold < amount then
        CC.UI.MessageManager.Player(
            sender,
            CC.Core.Color.Red("You do not have enough gold.")
        )

        return
    end

    CC.Systems.PlayerManager.AddResource(sender, "gold", -amount)
    CC.Systems.PlayerManager.AddResource(target, "gold", amount)

    CC.UI.MessageManager.Player(
        sender,
        CC.Core.Color.Yellow("You gave ") ..
        CC.Core.Color.Orange(tostring(amount)) ..
        CC.Core.Color.Yellow(" gold to ") ..
        CC.Core.Color.Wrap(CC.Systems.PlayerManager.GetPlayerColor(target), GetPlayerName(target)) ..
        CC.Core.Color.Yellow(".")
    )

    CC.UI.MessageManager.Player(
        target,
        CC.Core.Color.Wrap(CC.Systems.PlayerManager.GetPlayerColor(sender), GetPlayerName(sender)) ..
        CC.Core.Color.Yellow(" gave you ") ..
        CC.Core.Color.Orange(tostring(amount)) ..
        CC.Core.Color.Yellow(" gold.")
    )
end

--[[
    Parse the give gold message.
]]
function CC.Systems.PlayerManager.ParseGiveGoldCommand(message)
    local prefix = "/give gold"

    if string.sub(message, 1, string.len(prefix)) ~= prefix then
        return nil, nil
    end

    local rest = string.sub(message, string.len(prefix) + 1)
    rest = CC.Systems.PlayerManager.Trim(rest)

    local targetName, amountText = string.match(rest, "^(.-)%s+(%d+)$")

    if targetName == nil or amountText == nil then
        return nil, nil
    end

    targetName = CC.Systems.PlayerManager.Trim(targetName)

    if targetName == "" then
        return nil, nil
    end

    return targetName, amountText
end

--[[
    Finds a player by exact or partial name.
]]
function CC.Systems.PlayerManager.FindPlayerByName(name)
    if name == nil then return nil end

    local query = string.lower(CC.Systems.PlayerManager.Trim(name))
    local exactMatch = nil
    local partialMatch = nil
    local partialCount = 0

    for i = 0, 15 do
        local player = Player(i)

        if CC.Systems.PlayerManager.IsPlaying(player) then

            local playerName = GetPlayerName(player)
            local loweredName = string.lower(playerName)

            if loweredName == query then
                exactMatch = player
                break
            end

            if string.find(loweredName, query, 1, true) ~= nil then
                partialMatch = player
                partialCount = partialCount + 1
            end
        end
    end

    if exactMatch ~= nil then
        return exactMatch
    end

    if partialCount == 1 then
        return partialMatch
    end

    return nil 
end

--[[
    Trims whitespace from a string.
]]
function CC.Systems.PlayerManager.Trim(value)
    if value == nil then
        return ""
    end

    return string.match(value, "^%s*(.-)%s*$")
end

--[[
    Player a sound for specific player.
]]
function CC.Systems.PlayerManager.PlaySoundForPlayer(player, sound)
    if player == nil then
        MAZECRAFT.Core.Debug("PlayerManager", "PlaySoundForPlayer failed: player is nil")
    end

    if sound == nil then
        MAZECRAFT.Core.Debug("PlayerManager", "PlayerSoundForPlayer failed: sound is nil")
    end

    StartSoundForPlayerBJ(player, sound)
end
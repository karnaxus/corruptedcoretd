--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Command Manager                                           |
    | ========================================================= |
    | Manager for executing special commands.                   |
    +-----------------------------------------------------------+
]]

CC.Systems.CommandManager = CC.Systems.CommandManager or {}

CC.Systems.CommandManager.commands = {}

--[[
    Initialize the Command Manager.
]]
function CC.Systems.CommandManager.Init()
    CC.Core.Debug("CommandManager", "Initializing Command Manager...")

    CC.Systems.CommandManager.RegisterCommands()
    CC.Systems.CommandManager.RegisterChatTriggers()

    CC.Core.Debug("CommandManager", "Command Manager initialized.")
end

--[[
    Register a new command
]]
function CC.Systems.CommandManager.Register(command, callback)
    CC.Systems.CommandManager.commands[command] = callback
end

--[[
    Register the commands.
]]
function CC.Systems.CommandManager.RegisterCommands()
    CC.Systems.CommandManager.Register("/enable debug", function (player)
        CC.Core.debugEnabled = true
        CC.UI.MessageManager.Player(player, CC.Core.Color.Green("Debug enabled."))
    end)

    CC.Systems.CommandManager.Register("/disable debug", function (player)
        CC.Core.debugEnabled = false
        CC.UI.MessageManager.Player(player, CC.Core.Color.Red("Debug disabled."))
    end)

    CC.Systems.CommandManager.Register("/disable tips", function (player)
        local playerId = GetPlayerId(player)

        CC.UI.TipsManager.enabled[playerId] = false

        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Red("Tips disabled. ") ..
            CC.Core.Color.Yellow("Type /enable tips to turn them back on.")
        )
    end)

    CC.Systems.CommandManager.Register("/enable tips", function (player)
        local playerId = GetPlayerId(player)

        CC.UI.TipsManager.enabled[playerId] = true

        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Green("Tips enabled.")
        )
    end)

    CC.Systems.CommandManager.Register("/air", function (player)
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Yellow("Air Waves: ") ..
            CC.Core.Color.Teal("Waves 5, 10, 15, 20, 25")
        )
    end)

    CC.Systems.CommandManager.Register("/boss", function (player)
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Yellow("Boss Waves: ") ..
            CC.Core.Color.Teal("Waves 20 and 30")
        )
    end)

    CC.Systems.CommandManager.Register("/wave", function (player)
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Yellow("Current wave: ") ..
            CC.Core.Color.Orange(tostring(CC.Systems.WaveManager.currentWave))
        )
    end)

    CC.Systems.CommandManager.Register("/disable wavesummary", function (player)
        local playerId = GetPlayerId(player)

        CC.Systems.LeaderboardManager.waveEndSummaryEnabled[playerId] = false
        
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Red("Wave end summary disabled. ") ..
            CC.Core.Color.Yellow("Type /enable wavesummary to turn back on.")
        )
    end)

    CC.Systems.CommandManager.Register("/enable wavesummary", function (player)
        local playerId = GetPlayerId(player)

        CC.Systems.LeaderboardManager.waveEndSummaryEnabled[playerId] = true

        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Green("Wave end summary enabled.")
        )
    end)

    CC.Systems.CommandManager.Register("/commands", function (player)
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Yellow("Available commands:\n") ..
            CC.Core.Color.Teal("/enable debug ") .. CC.Core.Color.Orange("Turn on debug mode\n") ..
            CC.Core.Color.Teal("/disable debug ") .. CC.Core.Color.Orange("Turn off debug mode\n") ..
            CC.Core.Color.Teal("/enable tips ") .. CC.Core.Color.Orange("Turn on tips\n") ..
            CC.Core.Color.Teal("/disable tips ") .. CC.Core.Color.Orange("Turn off tips\n") ..
            CC.Core.Color.Teal("/air ") .. CC.Core.Color.Orange("List air waves\n") ..
            CC.Core.Color.Teal("/boss ") .. CC.Core.Color.Orange("List boss waves\n") ..
            CC.Core.Color.Teal("/wave ") .. CC.Core.Color.Orange("Show the current wave number\n") ..
            CC.Core.Color.Teal("/disable wavesummary ") .. CC.Core.Color.Orange("Disable the end of wave summary data\n") ..
            CC.Core.Color.Teal("/enable wavesummary ") .. CC.Core.Color.Orange("Enable the end of wave summary data")
        )
    end)
end

--[[
    Register the chat triggers for commands.
]]
function CC.Systems.CommandManager.RegisterChatTriggers()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerChatEvent(trigger, Player(i), "/", false)
    end

    TriggerAddAction(trigger, function ()
        local player = GetTriggerPlayer()
        local message = string.lower(GetEventPlayerChatString())

        CC.Systems.CommandManager.Handle(player, message)
    end)
end

--[[
    Handle the command.
]]
function CC.Systems.CommandManager.Handle(player, message)
    local command = CC.Systems.CommandManager.commands[message]

    if command == nil then
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Red("Unknown command: ") .. CC.Core.Color.Yellow(message)
        )

        return
    end

    command(player)
end
--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Game Manager                                              |
    | ========================================================= |
    | Manages the game.                                         |
    +-----------------------------------------------------------+
]]

CC.Systems.GameManager = CC.Systems.GameManager or {}

CC.Systems.GameManager.settings = nil
CC.Systems.GameManager.difficulty = nil
CC.Systems.GameManager.gameOver = false
CC.Systems.GameManager.victorious = false

--[[
    Initializing the Game Manager.
]]
function CC.Systems.GameManager.Init()
    CC.Core.Debug("GameManager", "Initializing the Game Manager...")

    CC.Systems.GameManager.SetupEnvironment()
    CC.Systems.GameManager.StartVotePeriod()

    CC.Core.Debug("GameManager", "Game Manager initialized.")
end

--[[
    Setup the game environment.
]]
function CC.Systems.GameManager.SetupEnvironment()
    SetFloatGameState(GAME_STATE_TIME_OF_DAY, 12.00)
    SuspendTimeOfDay(true)
    FogEnable(false)
    FogMaskEnable(false)
end

--[[
    Set the game difficulty.
]]
function CC.Systems.GameManager.SetDifficulty(difficultyKey)
    CC.Systems.GameManager.difficulty = difficultyKey
    CC.Systems.GameManager.settings = CC.Config.Difficulties[difficultyKey]
end

--[[
    Get the game settings.
]]
function CC.Systems.GameManager.GetSettings()
    return CC.Systems.GameManager.settings
end

--[[
    Start the vote period.
]]
function CC.Systems.GameManager.StartVotePeriod()
    CC.Systems.VoteManager.Start({
        title = "Vote for Game Difficulty",
        duration = 30.00,

        options = {
            { label = CC.Core.Color.Green("Easy"), value = "Easy" },
            { label = CC.Core.Color.Yellow("Medium"), value = "Medium" },
            { label = CC.Core.Color.Orange("Hard"), value = "Hard" },
            { label = CC.Core.Color.Red("Insane"), value = "Insane" }
        },

        onComplete = function (winner)
            CC.Systems.GameManager.difficulty = winner.value

            CC.UI.MessageManager.Broadcast(
                "Difficulty selected: " .. winner.label,
                10.00
            )

            CC.Systems.GameManager.SetDifficulty(winner.value)

            CC.Systems.GameManager.Start()
        end
    })
end

--[[
    Starts the game.
]]
function CC.Systems.GameManager.Start()
    CC.Core.gameTimer = CreateTimer()
    TimerStart(CC.Core.gameTimer, 999999.00, true, function () end)

    CC.Systems.TowerManager.Init()
    CC.Systems.IntervalGoldManager.Init()
    CC.UI.TipsManager.Init()

    CC.Systems.PlayerManager.SpawnTowerBuilders()

    local gameSettings = CC.Systems.GameManager.GetSettings()
    local initialGold = gameSettings.initialGold

    if CC.Core.godModeEnabled then
        initialGold = 99999999
    end

    CC.Systems.PlayerManager.AddResourceToAllPlayers("gold", initialGold)
    CC.Systems.EndZoneManager.SetLeaksLeft(gameSettings.leaksAllowed)

    local multiboardTimer = CreateTimer()

    TimerStart(multiboardTimer, 0.25, false, function ()
        CC.UI.MultiboardManager.Init()
        CC.UI.MultiboardManager.Rebuild()

        PauseTimer(multiboardTimer)
        DestroyTimer(multiboardTimer)
    end)

    CC.Core.Timer.Window(gameSettings.initialDelay, "Wave 1 starts in", function ()
        CC.Systems.GameManager.Spawn()
    end)

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Yellow("WELCOME TO ") .. CC.Core.Color.Teal("CORRUPTED CORE ") .. CC.Core.Color.Yellow("TD\n\n") ..
        CC.Core.Color.Green("This is a cooperative/team effort TD map. Work together to stop a total of ") ..
        CC.Core.Color.Orange(tostring(CC.Core.Constants.MAX_WAVES)) ..
        CC.Core.Color.Green(" waves of invaders before they reach the outer corners of the map. The invaders will spawn in the center of the map.\n\n") ..
        CC.Core.Color.Green("Build smart, work together and stop the invaders. Get started as the first wave starts soon. Good luck!")
    )
end

--[[
    Spawn the first wave of invaders.
]]
function CC.Systems.GameManager.Spawn()
    CC.Systems.WaveManager.StartWave()
end

--[[
    Declare game victory.
]]
function CC.Systems.GameManager.DeclareVictory()
    if CC.Systems.GameManager.gameOver == true then
        return
    end

    CC.Systems.GameManager.gameOver = true
    CC.Systems.GameManager.victorious = true

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Orange("Victory! ") ..
        CC.Core.Color.Yellow("All waves of invaders have been stopped!")
    )

    local timer = CreateTimer()

    TimerStart(timer, 2.00, false, function ()
        CC.Systems.GameManager.EndGame(true)
    end)
end

--[[
    Declare game defeat.
]]
function CC.Systems.GameManager.DeclareDefeat()
    if CC.Systems.GameManager.gameOver == true then
        return
    end

    CC.Systems.GameManager.gameOver = true
    CC.Systems.GameManager.victorious = false
    
    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Red("Defeat! ") ..
        CC.Core.Color.Yellow("Too many invaders leaked!")
    )

    local timer = CreateTimer()

    TimerStart(timer, 2.00, false, function ()
        CC.Systems.GameManager.EndGame(false)
    end)
end

--[[
    End the game.
]]
function CC.Systems.GameManager.EndGame(victory)
    local result = nil

    if victory == true then
        result = "VICTORY"
    else
        result = "DEFEAT"
    end

    CC.Systems.EndGameSummaryManager.OutputSummary(result)

    CC.Core.Timer.Window(30.00, "Game Ends In...", function ()
        CC.Systems.GameManager.FinalEndGame(victory)
    end)
end

--[[
    Finally end the game.
]]
function CC.Systems.GameManager.FinalEndGame(victory)
    CC.Systems.UnitManager.BlowUpAllUnits()

    for i = 0, 7 do
        local player = Player(i)

        if CC.Systems.PlayerManager.IsPlaying(player) then
            if victory == true then
                CustomVictoryBJ(player, true, true)
            else
                CustomDefeatBJ(player, "Too many invaders leaked! Good luck next time!")
            end
        end
    end
end

--[[
    Get the elapsed game time.
]]
function CC.Systems.GameManager.GetGameTime()
    if CC.Core.gameTimer == nil then
        return 0
    end

    return TimerGetElapsed(CC.Core.gameTimer)
end

--[[
    Clear the game timer.
]]
function CC.Systems.GameManager.ClearGameTimer()
    PauseTimer(CC.Core.gameTimer)
    DestroyTimer(CC.Core.gameTimer)
end
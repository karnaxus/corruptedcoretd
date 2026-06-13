--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Interval Gold Manager                                     |
    | ========================================================= |
    | Responsible for managing players.                         |
    +-----------------------------------------------------------+
]]

CC.Systems.IntervalGoldManager = CC.Systems.IntervalGoldManager or {}

CC.Systems.IntervalGoldManager.timer = nil
CC.Systems.IntervalGoldManager.remaining = 0

--[[
    Initialize the Interval Gold Manager.
]]
function CC.Systems.IntervalGoldManager.Init()
    CC.Core.Debug("IntervalGoldManager", "Initializing the Interval Gold Manager...")

    local gameSettings = CC.Systems.GameManager.GetSettings()

    CC.Systems.IntervalGoldManager.remaining = gameSettings.intervalGoldSeconds or 15

    CC.Systems.IntervalGoldManager.timer = CreateTimer()

    TimerStart(CC.Systems.IntervalGoldManager.timer, 1.00, true, function ()
        CC.Systems.IntervalGoldManager.Tick()
    end)

    CC.Core.Debug("IntervalGoldManager", "Interval Gold Manager initialized.")
end

--[[
    Process one interval gold timer tick.
]]
function CC.Systems.IntervalGoldManager.Tick()
    local gameSettings = CC.Systems.GameManager.GetSettings()

    CC.Systems.IntervalGoldManager.remaining = CC.Systems.IntervalGoldManager.remaining - 1

    if CC.Systems.IntervalGoldManager.remaining <= 0 then
        CC.Systems.IntervalGoldManager.GiveGold()

        CC.Systems.IntervalGoldManager.remaining =
            gameSettings.intervalGoldSeconds or 15
    end
end

--[[
    Give interval gold to every active player.
]]
function CC.Systems.IntervalGoldManager.GiveGold()
    local gameSettings = CC.Systems.GameManager.GetSettings()
    local goldAmount = gameSettings.intervalGoldAmount or 0

    if goldAmount <= 0 then
        return
    end

    CC.Systems.PlayerManager.ForEach(function (playerData)
        if not CC.Systems.PlayerManager.hasLeft[playerData.id] then
            CC.Systems.PlayerManager.AddResource(
                playerData.player,
                "gold",
                goldAmount
            )
        end
    end)

    CC.Core.Debug("IntervalGoldManager", "Gave " .. tostring(goldAmount) .. " gold to each active player.")
end

--[[
    Get the current interval gold countdown.
]]
function CC.Systems.IntervalGoldManager.GetRemaining()
    return CC.Systems.IntervalGoldManager.remaining or 0
end
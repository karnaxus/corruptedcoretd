--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Main                                                      |
    | ========================================================= |
    | The main bootstrap.                                       |
    +-----------------------------------------------------------+
]]

CC = CC or {}

CC.Config = CC.Config or {}
CC.Core = CC.Core or {}
CC.Systems = CC.Systems or {}
CC.UI = CC.UI or {}

CC.initialized = false

--[[
    Initialize Corrupted Core TD.
]]
function CC.Init()
    if CC.initialized then
        return
    end

    CC.initialized = true

    CC.Core.Debug("Main", "Initializing Corrupted Core TD...")

    CC.Systems.PlayerManager.Init()
    CC.Systems.SpawnManager.Init()
    CC.Systems.InvaderPathManager.Init()
    CC.Systems.WaveManager.Init()
    CC.Systems.VoteManager.Init()
    CC.Systems.GameManager.Init()
    CC.Systems.DeathManager.Init()
    CC.Systems.EndZoneManager.Init()
    CC.Systems.UnitManager.Init()
    CC.Systems.CommandManager.Init()
    CC.Systems.LeaderboardManager.Init()
    CC.UI.QuestManager.Init()

    CC.Core.Debug("Main", "Corrupted Core TD initialized.")
end

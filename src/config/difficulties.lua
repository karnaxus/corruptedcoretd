--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Difficulties                                              |
    | ========================================================= |
    | Game difficulties.                                        |
    +-----------------------------------------------------------+
]]

--[[
    All the game difficulties for CCTD.
]]
CC.Config.Difficulties = {
    Easy = {
        name = "Easy",
        hpMultiplier = 1.10,
        goldMultiplier = 1.50,
        invaderMultiplier = 0.85,
        speedMultiplier = 0.85,
        initialDelay = 45.00,
        initialGold = 1000,
        leaksAllowed = 80,
        betweenWaveDelayEnabled = true,
        betweenWaveDelay = 20.00,
        intervalGoldSeconds = 10,
        intervalGoldAmount = 50
    },

    Medium = {
        name = "Medium",
        hpMultiplier = 1.30,
        goldMultiplier = 1.00,
        invaderMultiplier = 1.00,
        speedMultiplier = 1.00,
        initialDelay = 30.00,
        initialGold = 1000,
        leaksAllowed = 65,
        betweenWaveDelayEnabled = true,
        betweenWaveDelay = 15.00,
        intervalGoldSeconds = 15,
        intervalGoldAmount = 40
    },

    Hard = {
        name = "Hard",
        hpMultiplier = 1.50,
        goldMultiplier = 0.90,
        invaderMultiplier = 1.10,
        speedMultiplier = 1.05,
        initialDelay = 20.00,
        initialGold = 1000,
        leaksAllowed = 50,
        betweenWaveDelayEnabled = false,
        betweenWaveDelay = 0.00,
        intervalGoldSeconds = 20,
        intervalGoldAmount = 30
    },

    Insane = {
        name = "Insane",
        hpMultiplier = 1.70,
        goldMultiplier = 0.75,
        invaderMultiplier = 1.25,
        speedMultiplier = 1.10,
        initialDelay = 15.00,
        initialGold = 1000,
        leaksAllowed = 35,
        betweenWaveDelayEnabled = false,
        betweenWaveDelay = 0.00,
        intervalGoldSeconds = 25,
        intervalGoldAmount = 20
    }
}

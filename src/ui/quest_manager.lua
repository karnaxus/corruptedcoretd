--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Quest Manager                                             |
    | ========================================================= |
    | Manages the quests for the game.                          |
    +-----------------------------------------------------------+
]]

CC.UI.QuestManager = CC.UI.QuestManager or {}

--[[
    Initialize the Quest Manager.
]]
function CC.UI.QuestManager.Init()
    CC.Core.Debug("QuestManager", "Initializing the Quest Manager...")

    CC.UI.QuestManager.CreateReadMeQuest()
    CC.UI.QuestManager.CreateMainQuest()
    CC.UI.QuestManager.CreateCommandsQuest()
    CC.UI.QuestManager.CreateAirAndBossWavesQuest()
    CC.UI.QuestManager.CreateTowersQuest()
    CC.UI.QuestManager.CreateDifficultiesQuest()
    CC.UI.QuestManager.CreateGitHubQuest()
    CC.UI.QuestManager.CreateCreditsQuest()

    CC.Core.Debug("QuestManager", "Quest Manager initialized.")
end

--[[
    Create the main quest.
]]
function CC.UI.QuestManager.CreateMainQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Corrupted Core TD")

    QuestSetDescription(
        quest,
        "A coorerative Tower Defense map.\n\n" ..
        "Invaders spawn from the center of the map and attempt to reach the four corner end zones.\n\n" ..
        "Work together, build smart, and survive all waves.\n\n" ..
        "Created by Karnaxus#11298"
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNInfernal.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the quest outlining the available commands for CCTD.
]]
function CC.UI.QuestManager.CreateCommandsQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Commands")

    QuestSetDescription(
        quest,
        "/commands - Show available commands\n" ..
        "/enable tips - Enable tips\n" ..
        "/disable tips - Disable tips\n" ..
        "/air - Show air waves\n" ..
        "/boss - Show boss waves\n" ..
        "/enable debug - Enable debug mode\n" ..
        "/disable debug - Disable debug mode\n" ..
        "/enable wavesummary - Enable wave end summary results\n" ..
        "/disable wavesummary - Disable wave end summary results"
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNScroll.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the credits quest.
]]
function CC.UI.QuestManager.CreateCreditsQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Credits")

    QuestSetDescription(
        quest,
        "Map created by Karnaxus#11298\n\n" ..
        "Thank you for playing Corrupted Core TD."
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNHumanCaptureFlag.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the readme quest.
]]
function CC.UI.QuestManager.CreateReadMeQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Readme")

    QuestSetDescription(
        quest,
        "Corrupted Core TD\n\n" ..
        "Created by Karnaxus#11298\n\n" ..
        "Objective:\n" ..
        "Prevent invaders from reaching the four corner end zones.\n\n" ..
        "Commands:\n" ..
        "Type /commands to view available commands.\n\n" ..
        "Good luck!"
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNTome.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the air and boss waves quest.
]]
function CC.UI.QuestManager.CreateAirAndBossWavesQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Special Waves (Air and Boss)")

    QuestSetDescription(
        quest,
        "Air waves occur on waves: 5, 10, 15, and 25.\n\n" ..
        "Boss waves occur on waves: 20 and 30.\n\n" ..
        "Keep an eye on the multiboard for the indicators for air and boss waves."
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the towers quest.
]]
function CC.UI.QuestManager.CreateTowersQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Towers")

    QuestSetDescription(
        quest,
        "The key to victory is building an effective defense network.\n\n" ..
        "Each tower unique strengths and weaknesses:\n" ..
        "- Damage Towers excel at eliminating powerful invaders.\n" ..
        "- Area Damage Towers are effective against large groups (but have higher cooldowns)\n" ..
        "- Utility Towers can slow or weaken enemies.\n" ..
        "- Some towers can attack air units while others cannot.\n\n" ..
        "Remember:\n" ..
        "- Upgrade often.\n" ..
        "- Adapt your defenses as waves become stronger.\n" ..
        "- Prepare for air and boss waves.\n" ..
        "- Work together with the teammates to cover weak areas.\n\n" ..
        "A balanced defense is often strong than relying on a single tower type."
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNGuardTower.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the difficulties quest.
]]
function CC.UI.QuestManager.CreateDifficultiesQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "Game Difficulties")

    QuestSetDescription(
        quest,
        "Corrupted Core TD has 4 different game difficulties to choose from:\n\n" ..
        "Easy:\n" ..
        "Invaders have reduced health, and are bit slower. Extra initial time to build. Extra time between invader waves to build.\n\n" ..
        "Medium:\n" ..
        "The standard difficulty. Invaders have base health and movement speed. Normal initial time to build. Normal time between waves to build.\n\n" ..
        "Hard:\n" ..
        "Invaders have increased health and have slightly faster movement speed. A bit less initial time to build. No time between waves for building.\n\n" ..
        "Insane:\n" ..
        "The maximum challenge. Invaders have a good deal of increased health and movement speed. Little initial time to build. No time between waves for building.\n\n" ..
        "Game difficulty is always voted on by all players at the beginning of the game. Good luck!"
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\WorldEditUI\\Editor-Random-Unit.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end

--[[
    Create the quest for the GitHub info.
]]
function CC.UI.QuestManager.CreateGitHubQuest()
    local quest = CreateQuest()

    QuestSetTitle(quest, "GitHub (Source Code)")

    QuestSetDescription(
        quest,
        "Corrupted Core TD is written all in pure LUA code and zero GUI triggers.\n" ..
        "I do protect this map as I have put in a great deal of work creating this map.\n" ..
        "With that said, I do keep the LUA code public for those that wish to learn.\n\n" ..
        "All LUA code for this map can be found on GitHub at:\n" ..
        "https://github.com/karnaxus/corruptedcoretd\n\n" ..
        "Be sure to read the license agreement for the LUA code."
    )

    QuestSetIconPath(quest, "ReplaceableTextures\\CommandButtons\\BTNCrate.blp")
    QuestSetRequired(quest, true)
    QuestSetDiscovered(quest, true)
end
--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Tips Manager                                              |
    | ========================================================= |
    | Manages displaying tips for the players.                  |
    +-----------------------------------------------------------+
]]

CC.UI.TipsManager = CC.UI.TipsManager or {}

CC.UI.TipsManager.enabled = {}
CC.UI.TipsManager.currentTip = 1
CC.UI.TipsManager.interval = 45.00

CC.UI.TipsManager.tips = {
    "Type /disable tips to turn off these tips. Type /enable tips to re-enable these tips.",
    "To allow other players to build in your zone: type /allowbuild <player|all>. To deny an allowed player or players: type /denybuild <player|all>.",
    "Work together. Corrupted Core TD is a cooperative game and every lane matters.",
    "Don't spend all your gold immediately. Saving for upgrades can be more effective than building many weak towers.",
    "Watch the Air Wave indicator on the multiboard. Some towers cannot attack flying invaders.",
    "Boss waves require concentrated firepower. Be prepared before they arrive.",
    "Leaked invaders reduce the team's remaining leaks. Every leak matters.",
    "Pay attention to which corner the invaders are heading toward. Reinforce weak defenses before it's too late.",
    "A few powerful upgraded towers often outperform many basic towers.",
    "Selling a tower refunds part of its value. Adapt your defenses as new threats appear.",
    "Some towers excel against groups while others are better against single powerful targets.",
    "Build near corners and intersections whenever possible to maximize attack time.",
    "If invaders are reaching later regions consistently, consider upgrading instead of expanding.",
    "Boss invaders have significantly more health than normal enemies.",
    "Keep an eye on the Invaders Alive counter to monitor wave progress.",
    "The difficulty setting affects invader strength, speed, and other gameplay factors.",
    "Don't ignore early waves. A strong foundation makes later waves much easier.",
    "Saving a few leaks early may prevent defeat during difficult boss waves.",
    "Air invaders often bypass defenses that focus entirely on ground units.",
    "Towers with crowd control effects can be just as valuable as raw damage.",
    "If a strategy isn't working, don't be afraid to sell and rebuild.",
    "Different tower types complement each other. Mix damage, utility, and crowd control.",
    "Higher-tier towers generally provide better value than large numbers of basic towers.",
    "Watch for areas where multiple paths overlap. These are excellent tower locations.",
    "Keep enough gold available to react to unexpected threats.",
    "Upgraded towers usually provide better long-term value than repeatedly building new basic towers.",
    "Boss waves are announced in advance. Use the warning to prepare your defenses.",
    "Flying invaders are often the cause of unexpected leaks.",
    "A leaking lane today can become a failed corner tomorrow.",
    "If invaders survive deep into the route, focus on increasing single-target damage.",
    "Check the current wave information on the multiboard regularly.",
    "Strong teamwork is often more important than individual tower placement.",
    "Every wave defeated brings the team one step closer to victory.",
    "The invaders spawn from the center and spread outward. Plan your defenses accordingly.",
    "Protecting all four corners is the key to surviving Corrupted Core TD."
}

--[[
    Initialize the Tips Manager.
]]
function CC.UI.TipsManager.Init()
    CC.Core.Debug("TipsManager", "Initializing the Tips Manager...")

    CC.Systems.PlayerManager.ForEach(function (playerData)
        CC.UI.TipsManager.enabled[playerData.id] = true
    end)

    CC.UI.TipsManager.Start()

    CC.Core.Debug("TipsManager", "Tips Manager initialized.")
end

--[[
    Start the tips.
]]
function CC.UI.TipsManager.Start()
    local timer = CreateTimer()

    TimerStart(timer, CC.UI.TipsManager.interval, true, function ()
        CC.UI.TipsManager.ShowNextTip()
    end)
end

--[[
    Display the next tip.
]]
function CC.UI.TipsManager.ShowNextTip()
    local tip = CC.UI.TipsManager.tips[CC.UI.TipsManager.currentTip]

    if tip == nil then
        CC.UI.TipsManager.currentTip = 1
        tip = CC.UI.TipsManager.tips[1]
    end

    CC.Systems.PlayerManager.ForEach(function (playerData)
        local player = playerData.player
        local playerId = GetPlayerId(player)

        if CC.UI.TipsManager.enabled[playerId] ~= false then
            CC.UI.MessageManager.Player(
                player,
                CC.Core.Color.Yellow("Tip: ") ..
                CC.Core.Color.Teal(tip)
            )
        end
    end)

    CC.UI.TipsManager.currentTip = CC.UI.TipsManager.currentTip + 1

    if CC.UI.TipsManager.currentTip > #CC.UI.TipsManager.tips then
        CC.UI.TipsManager.currentTip = 1
    end
end

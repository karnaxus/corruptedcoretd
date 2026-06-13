--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Message Manager                                           |
    | ========================================================= |
    | Manages displaying text to players.                       |
    +-----------------------------------------------------------+
]]

CC.UI.MessageManager = CC.UI.MessageManager or {}

--[[
    Broadcast text to all players.
]]
function CC.UI.MessageManager.Broadcast(message, duration)
    DisplayTimedTextToForce(
        GetPlayersAll(),
        duration or 10.00,
        message
    )
end

--[[
    Display text to a specific player.
]]
function CC.UI.MessageManager.Player(player, message, duration)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        duration or 10.00,
        message
    )
end

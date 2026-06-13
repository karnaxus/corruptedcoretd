--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Vote Manager                                              |
    | ========================================================= |
    | Manages votes.                                            |
    +-----------------------------------------------------------+
]]

CC.Systems.VoteManager = CC.Systems.VoteManager or {}

CC.Systems.VoteManager.activeVote = nil

--[[
    Initialize the Vote Manager.
]]
function CC.Systems.VoteManager.Init()
    CC.Core.Debug("VoteManager", "Initializing the Vote Manager...")
    CC.Core.Debug("VoteManager", "Vote Manager initialized.")
end

--[[
    Start a new vote.
]]
function CC.Systems.VoteManager.Start(config)
    if CC.Systems.VoteManager.activeVote ~= nil then
        return
    end

    CC.Systems.VoteManager.activeVote = {
        title = config.title,
        options = config.options,
        votes = {},
        duration = config.duration or 20.00,
        requiredVotes = CC.Systems.PlayerManager.TotalPlayers(),
        ended = false,
        onComplete = config.onComplete
    }

    local vote = CC.Systems.VoteManager.activeVote

    local message =
        CC.Core.Color.Yellow(vote.title) ..
        "\n\nType a number to vote:\n"

    for index, option in ipairs(vote.options) do
        message = message ..
            "\n" ..
            CC.Core.Color.Blue(tostring(index)) ..
            " - " ..
            option.label
    end

    CC.UI.MessageManager.Broadcast(message, vote.duration)

    CC.Systems.VoteManager.RegisterChatVotes(vote)

    vote.timerData = CC.Core.Timer.Window(vote.duration, vote.title, function()
        CC.Systems.VoteManager.Finish()
    end)
end

--[[
    Register chat votes.
]]
function CC.Systems.VoteManager.RegisterChatVotes(vote)
    CC.Systems.PlayerManager.ForEach(function(playerData)
        for index, _ in ipairs(vote.options) do
            local optionIndex = index
            local trigger = CreateTrigger()

            TriggerRegisterPlayerChatEvent(
                trigger,
                playerData.player,
                tostring(optionIndex),
                true
            )

            TriggerAddAction(trigger, function()
                CC.Core.Debug("VoteManager", "Vote chat detected")

                CC.Systems.VoteManager.CastVote(
                    GetTriggerPlayer(),
                    optionIndex
                )
            end)
        end
    end)
end

--[[
    Cast a players vote.
]]
function CC.Systems.VoteManager.CastVote(player, optionIndex)
    local vote = CC.Systems.VoteManager.activeVote

    if vote == nil or vote.ended then
        return
    end

    local playerId = GetPlayerId(player)

    if vote.votes[playerId] ~= nil then
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Red("You have already voted."),
            5.00
        )
        return
    end

    local option = vote.options[optionIndex]

    if option == nil then
        return
    end

    vote.votes[playerId] = optionIndex

    local voteCount = CC.Systems.VoteManager.GetVoteCount(vote)

    CC.UI.MessageManager.Broadcast(
        GetPlayerName(player) ..
        " voted for " ..
        option.label ..
        " " ..
        CC.Core.Color.Blue("(" .. voteCount .. "/" .. vote.requiredVotes .. ")"),
        5.00
    )

    if voteCount >= vote.requiredVotes then
        CC.Systems.VoteManager.Finish()
    end
end

--[[
    Finish a vote.
]]
function CC.Systems.VoteManager.Finish()
    local vote = CC.Systems.VoteManager.activeVote

    if vote == nil then
        return
    end

    if vote.timerData then
        CC.Core.Timer.DestroyWindow(vote.timerData);
        vote.timerData = nil
    end

    vote.ended = true

    CC.Core.Timer.CancelWindow(vote.timerData);

    local counts = {}

    for index, _ in ipairs(vote.options) do
        counts[index] = 0
    end

    for _, optionIndex in pairs(vote.votes) do
        counts[optionIndex] = counts[optionIndex] + 1
    end

    local winningIndex = 1
    local winningVotes = counts[1]

    for index, count in ipairs(counts) do
        if count > winningVotes then
            winningIndex = index
            winningVotes = count
        end
    end

    local winner = vote.options[winningIndex];

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Green("Vote complete: ") .. winner.label,
        10.00
    )

    CC.Systems.VoteManager.activeVote = nil

    if vote.onComplete then
        vote.onComplete(winner)
    end
end

--[[
    Get the vote count.
]]
function CC.Systems.VoteManager.GetVoteCount(vote)
    local count = 0

    for _, _ in pairs(vote.votes) do
        count = count + 1
    end

    return count
end
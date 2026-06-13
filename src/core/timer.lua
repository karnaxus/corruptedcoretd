--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Timer                                                     |
    | ========================================================= |
    | The timer library.                                        |
    +-----------------------------------------------------------+
]]

CC.Core.Timer = CC.Core.Timer or {}

CC.Core.Timer.activeWindows = CC.Core.Timer.activeWindows or {}

--[[
    Set a timer and then execute a callback when expired.
]]
function CC.Core.Timer.After(seconds, callback)
    local timer = CreateTimer()

    TimerStart(timer, seconds, false, function()
        callback()

        DestroyTimer(timer)
    end)
end

--[[
    Start a timer with a visible timer window.
]]
function CC.Core.Timer.Window(seconds, title, callback)
    local data = {
        timer = CreateTimer(),
        window = nil,
        cancelled = false
    }

    TimerStart(data.timer, seconds, false, function()
        if data.cancelled then
            return
        end

        if callback then
            callback()
        end

        CC.Core.Timer.DestroyWindow(data)
    end)

    CC.Core.Timer.After(0.10, function()
        if data.cancelled then
            return
        end

        data.window = CreateTimerDialog(data.timer)

        TimerDialogSetTitle(data.window, title)
        TimerDialogDisplay(data.window, true)
    end)

    return data
end

--[[
    Hide the timer window.
]]
function CC.Core.Timer.HideWindow(data)
    if data and data.window then
        TimerDialogDisplay(data.window, false)
    end
end

--[[
    Destroy the timer window.
]]
function CC.Core.Timer.DestroyWindow(data)
    if data == nil then
        return
    end

    if data.window then
        TimerDialogDisplay(data.window, false)
        DestroyTimerDialog(data.window)
        data.window = nil
    end

    if data.timer then
        PauseTimer(data.timer)
        DestroyTimer(data.timer)
        data.timer = nil
    end

    data.cancelled = true
end

--[[
    Start a repeating timer.
]]
function CC.Core.Timer.Every(seconds, callback)
    local timer = CreateTimer()

    TimerStart(timer, seconds, true, function ()
        callback(timer)
    end)

    return timer
end

--[[
    Stop and destroy a timer.
]]
function CC.Core.Timer.Stop(timer)
    if timer ~= nil then
        PauseTimer(timer)
        DestroyTimer(timer)
    end
end

--[[
    Cancel timer window.
]]
function CC.Core.Timer.CancelWindow(timer, window)
    if window ~= nil then
        TimerDialogDisplay(window, false)
        DestroyTimerDialog(window)
    end

    if timer ~= nil then
        PauseTimer(timer)
        DestroyTimer(timer)
    end
end

--[[
    Start a timer with a visible timer window for one player only.
]]
function CC.Core.Timer.WindowForPlayer(player, seconds, title, callback)
    local data = {
        timer = CreateTimer(),
        window = nil,
        cancelled = false,
        player = player
    }

    TimerStart(data.timer, seconds, false, function()
        if data.cancelled then
            return
        end

        if callback then
            callback()
        end

        CC.Core.Timer.DestroyWindow(data)
    end)

    CC.Core.Timer.After(0.10, function()
        if data.cancelled then
            return
        end

        data.window = CreateTimerDialog(data.timer)
        TimerDialogSetTitle(data.window, title)

        if GetLocalPlayer() == player then
            TimerDialogDisplay(data.window, true)
        else
            TimerDialogDisplay(data.window, false)
        end
    end)

    return data
end
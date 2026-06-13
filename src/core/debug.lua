--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Debug                                                     |
    | ========================================================= |
    | Debug library.                                            |
    +-----------------------------------------------------------+
]]

--[[
    Outputs debug message (if enabled)
]]
function CC.Core.Debug(section, message)
    if not CC.Core.debugEnabled then
        return
    end

    BJDebugMsg("[DEBUG][" .. section .. "] " .. message)
end
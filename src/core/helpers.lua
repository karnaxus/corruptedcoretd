--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Helpers                                                   |
    | ========================================================= |
    | Collection of helpers.                                    |
    +-----------------------------------------------------------+
]]

CC.Core.Helpers = CC.Core.Helpers or {}

--[[
    Get the index for a needle inside a haystack.
]]
function CC.Core.Helpers.GetIndex(haystack, needle)
    if haystack == nil or needle == nil then
        return nil
    end

    local index = nil

    for i, item in ipairs(haystack) do
        if item == needle then
            index = i
            break
        end
    end

    return index
end

--[[
    Either return a singular or plural text based on the total.
]]
function CC.Core.Helpers.SingularOrPlural(singularText, pluralText, total)
    if singularText == nil or pluralText == nil or total == nil then
        return "Unknown"
    end

    if total == 1 then
        return singularText
    else
        return pluralText
    end
end

--[[
    Format a number with commas.
]]
function CC.Core.Helpers.FormatNumber(number)
    local formatted = tostring(math.floor(number))

    while true do
        local result, count = string.gsub(
            formatted,
            "^(-?%d+)(%d%d%d)",
            "%1,%2"
        )

        formatted = result

        if count == 0 then
            break
        end
    end

    return formatted
end

--[[
    Format game time to a better readable time format.
]]
function CC.Core.Helpers.FormatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)

    return string.format("%02d:%02d", mins, secs)
end

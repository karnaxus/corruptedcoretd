--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Color                                                     |
    | ========================================================= |
    | NodeJS chalk like API for WC3.                            |
    +-----------------------------------------------------------+
]]

CC.Core.Color = {}

function CC.Core.Color.Wrap(hex, text)
    return "|cff" .. hex .. text .. "|r"
end

function CC.Core.Color.Green(text)
    return CC.Core.Color.Wrap("80FF80", text)
end

function CC.Core.Color.Red(text)
    return CC.Core.Color.Wrap("FF4040", text)
end

function CC.Core.Color.Blue(text)
    return CC.Core.Color.Wrap("80C0FF", text)
end

function CC.Core.Color.Yellow(text)
    return CC.Core.Color.Wrap("FFCC00", text)
end

function CC.Core.Color.Purple(text)
    return CC.Core.Color.Wrap("C080FF", text)
end

function CC.Core.Color.White(text)
    return CC.Core.Color.Wrap("FFFFFF", text)
end

function CC.Core.Color.Teal(text)
    return CC.Core.Color.Wrap("00C0C0", text)
end

function CC.Core.Color.Pink(text)
    return CC.Core.Color.Wrap("FFC0FF", text)
end

function CC.Core.Color.Orange(text)
    return CC.Core.Color.Wrap("FF8E09", text)
end

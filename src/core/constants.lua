--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Constants                                                 |
    | ========================================================= |
    | Constants for CCTD.                                       |
    +-----------------------------------------------------------+
]]

--[[
    CCTD constants.
]]
CC.Core.Constants = {
    -- Max waves
    MAX_WAVES = 30,

    -- The invader player
    INVADER_PLAYER = Player(8),

    -- The tower builder
    TOWER_BUILDER = FourCC("u000"),

    -- Towers
    TOWERS = {
        FLAME = {
            FIRE_TOWER = FourCC("n003"),
            MOLTEN_TOWER = FourCC("n00X"),
            INCINERATION_TOWER = FourCC("n00Y"),
            DRAGONS_BREATH_TOWER = FourCC("n00Z")
        },

        COLD = {
            COLD_TOWER = FourCC("n010"),
            COLDER_TOWER = FourCC("n011"),
            FROZEN_TOWER = FourCC("n012"),
            PERMAFROST_TOWER = FourCC("n013")
        },

        ARROW = {
            ARROW_TOWER = FourCC("h000"),
            ADVANCED_ARROW_TOWER = FourCC("h002"),
            ULTIMATE_ARROW_TOWER = FourCC("h005")
        },

        POISON = {
            POISON_TOWER = FourCC("h001"),
            ADVANCED_POISON_TOWER = FourCC("h003"),
            ULTIMATE_POISON_TOWER = FourCC("h004")
        },

        BOULDER = {
            BOULDER_TOWER = FourCC("n014"),
            ADVANCED_BOULDER_TOWER = FourCC("n015"),
            SIEGE_TOWER = FourCC("n016"),
            MORTAR_TOWER = FourCC("n017")
        },

        ENERGY = {
            ENERGY_TOWER = FourCC("n018"),
            LIGHTNING_TOWER = FourCC("n019"),
            SWIRLING_LIGHTNING_TOWER = FourCC("n01A"),
            ELECTROCUTION_TOWER = FourCC("n01B")
        }
    }
}
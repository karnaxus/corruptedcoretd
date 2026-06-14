--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Regions                                                   |
    | ========================================================= |
    | All the regions in use for CCTD.                          |
    +-----------------------------------------------------------+
]]

CC.Config.Regions = CC.Config.Regions or {}

-- All spawn regions
CC.Config.Regions.Spawns = {
    north = "NSpawn",
    east = "ESpawn",
    south = "SSpawn",
    west = "WSpawn"
}

-- All endzone regions
CC.Config.Regions.EndZones = {
    northWest = "NWEndZone",
    northEast = "NEEndZone",
    southEast = "SEEndZone",
    southWest = "SWEndZone"
}

-- The north regions
CC.Config.Regions.North = {
    pathOne = {
        "N1",
        "NW1",
        "NW2",
        "NWNCorner",
        "N2",
        "N3",
        "NWNCorner2",
        "NW3",
        "NWEndZone"
    },

    pathTwo = {
        "N1",
        "NE1",
        "NE2",
        "NENCorner",
        "N2",
        "N3",
        "NENCorner2",
        "NE3",
        "NEEndZone"
    }
}

-- The east regions
CC.Config.Regions.East = {
    pathOne = {
        "E1",
        "NE1",
        "NE2",
        "NESCorner",
        "E2",
        "E3",
        "NESCorner2",
        "NE3",
        "NEEndZone"
    },

    pathTwo = {
        "E1",
        "SE1",
        "SE2",
        "SENCorner",
        "E2",
        "E3",
        "SENCorner2",
        "SE3",
        "SEEndZone"
    }
}

-- The south regions
CC.Config.Regions.South = {
    pathOne = {
        "S1",
        "SE1",
        "SE2",
        "SESCorner",
        "S2",
        "S3",
        "SESCorner2",
        "SE3",
        "SEEndZone"
    },

    pathTwo = {
        "S1",
        "SW1",
        "SW2",
        "SWSCorner",
        "S2",
        "S3",
        "SWSCorner2",
        "SW3",
        "SWEndZone"
    }
}

-- The west regions
CC.Config.Regions.West = {
    pathOne = {
        "W1",
        "NW1",
        "NW2",
        "NWSCorner",
        "W2",
        "W3",
        "NWSCorner2",
        "NW3",
        "NWEndZone"
    },

    pathTwo = {
        "W1",
        "SW1",
        "SW2",
        "SWNCorner",
        "W2",
        "W3",
        "SWNCorner2",
        "SW3",
        "SWEndZone"
    }
}

--[[
    All the player build zones.
]]
CC.Config.Regions.BuildZones = {
    [0] = { "P1BZ1", "P1BZ2", "P1BZ3", "P1BZ4" },
    [1] = { "P2BZ1", "P2BZ2", "P2BZ3", "P2BZ4" },
    [2] = { "P3BZ1", "P3BZ2", "P3BZ3", "P3BZ4" },
    [3] = { "P4BZ1", "P4BZ2", "P4BZ3", "P4BZ4" },
    [4] = { "P5BZ1", "P5BZ2", "P5BZ3" },
    [5] = { "P6BZ1", "P6BZ2", "P6BZ3" },
    [6] = { "P7BZ1", "P7BZ2", "P7BZ3" },
    [7] = { "P8BZ1", "P8BZ2", "P8BZ3" }
}

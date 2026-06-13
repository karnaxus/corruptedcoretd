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
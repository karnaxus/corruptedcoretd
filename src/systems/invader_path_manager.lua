--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Invader Path Manager                                      |
    | ========================================================= |
    | Manages the routing of invaders.                          |
    +-----------------------------------------------------------+
]]

CC.Systems.InvaderPathManager = CC.Systems.InvaderPathManager or {}

CC.Systems.InvaderPathManager.triggers = CC.Systems.InvaderPathManager.triggers or {}
CC.Systems.InvaderPathManager.regions = CC.Systems.InvaderPathManager.regions or {}
CC.Systems.InvaderPathManager.routes = CC.Systems.InvaderPathManager.routes or {}

CC.Systems.InvaderPathManager.enabledRoutes = {
    north = {
        west = false,
        east = false
    },

    east = {
        north = false,
        south = false
    },

    south = {
        east = false,
        west = false
    },

    west = {
       north = false,
       south = false
    }
}

--[[
    Initialize the Invader Path Manager.
]]
function CC.Systems.InvaderPathManager.Init()
    CC.Core.Debug("InvaderPathManager", "Initializing the Invader Path Manager...")

    CC.Systems.InvaderPathManager.DetermineEnabledRoutes()
    CC.Systems.InvaderPathManager.RegisterAllRegions()

    CC.Core.Debug("InvaderPathManager", "Invader Path Manager initialized.")
end

--[[
    Determine which routes should be enabled.
]]
function CC.Systems.InvaderPathManager.DetermineEnabledRoutes()
    local playerStatus = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
        [7] = false
    }

    CC.Systems.PlayerManager.ForEach(function (playerData)
        if playerData.active == true then
            playerStatus[playerData.id] = true
        end
    end)

    -- North
    if playerStatus[0] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.north.west = true
    end

    if playerStatus[4] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.north.west = true
    end

    if playerStatus[5] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.north.east = true
    end

    -- East
    if playerStatus[3] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.east.north = true
    end

    if playerStatus[5] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.east.north = true
    end

    if playerStatus[6] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.east.south = true
    end

    -- South
    if playerStatus[1] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.south.east = true
    end

    if playerStatus[6] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.south.east = true
    end

    if playerStatus[7] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.south.west = true
    end

    -- West
    if playerStatus[2] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.west.north = true
    end

    if playerStatus[4] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.west.north = true
    end

    if playerStatus[7] == true then
        CC.Systems.InvaderPathManager.enabledRoutes.west.south = true
    end
end

--[[
    Register all region triggers.
]]
function CC.Systems.InvaderPathManager.RegisterAllRegions()
    local spawns = CC.Config.Regions.Spawns
    local north = CC.Config.Regions.North
    local east = CC.Config.Regions.East
    local south = CC.Config.Regions.South
    local west = CC.Config.Regions.West
    local endZones = CC.Config.Regions.EndZones

    CC.Core.Debug("InvaderPathManager", "Registering spawn regions...")
    CC.Systems.InvaderPathManager.RegisterRegion(spawns.north)
    CC.Systems.InvaderPathManager.RegisterRegion(spawns.east)
    CC.Systems.InvaderPathManager.RegisterRegion(spawns.south)
    CC.Systems.InvaderPathManager.RegisterRegion(spawns.west)

    CC.Core.Debug("InvaderPathManager", "Registering end zones...")
    CC.Systems.InvaderPathManager.RegisterRegion(endZones.northWest)
    CC.Systems.InvaderPathManager.RegisterRegion(endZones.northEast)
    CC.Systems.InvaderPathManager.RegisterRegion(endZones.southEast)
    CC.Systems.InvaderPathManager.RegisterRegion(endZones.southWest)

    CC.Core.Debug("InvaderPathManager", "Registering north paths...")
    for _, pathOne in ipairs(north.pathOne) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathOne)
    end

    for _, pathTwo in ipairs(north.pathTwo) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathTwo)
    end

    CC.Core.Debug("InvaderPathManager", "Registering east paths...")
    for _, pathOne in ipairs(east.pathOne) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathOne)
    end

    for _, pathTwo in ipairs(east.pathTwo) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathTwo)
    end

    CC.Core.Debug("InvaderPathManager", "Registering south paths...")
    for _, pathOne in ipairs(south.pathOne) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathOne)
    end

    for _, pathTwo in ipairs(south.pathTwo) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathTwo)
    end

    CC.Core.Debug("InvaderPathManager", "Registering west paths...")
    for _, pathOne in ipairs(west.pathOne) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathOne)
    end

    for _, pathTwo in ipairs(west.pathTwo) do
        CC.Systems.InvaderPathManager.RegisterRegion(pathTwo)
    end
end

--[[
    Register a region trigger.
]]
function CC.Systems.InvaderPathManager.RegisterRegion(regionName)
    if regionName == nil then
        CC.Core.Debug("InvaderPathManager", "Tried to register nil region name.")
        return
    end

    CC.Core.Debug("InvaderPathManager", "RegisterRegion start: " .. tostring(regionName))

    if CC.Systems.InvaderPathManager.triggers[regionName] ~= nil then
        return
    end

    local rect = CC.Systems.SpawnManager.ResolveRegion(regionName)

    CC.Core.Debug("InvaderPathManager", "ResolveRegion done: " .. tostring(regionName))

    if rect == nil then
        CC.Core.Debug("InvaderPathManager", "Missing region rect: " .. tostring(regionName))
        return
    end

    local capturedRegionName = regionName
    local trigger = CreateTrigger()
    local region = CreateRegion()

    RegionAddRect(region, rect)
    TriggerRegisterEnterRegion(trigger, region, nil)

    TriggerAddAction(trigger, function ()
        local unit = GetTriggerUnit()

        if not CC.Systems.InvaderPathManager.IsInvader(unit) then
            return
        end

        CC.Systems.InvaderPathManager.OnUnitEnterRegion(unit, capturedRegionName)
    end)

    CC.Systems.InvaderPathManager.triggers[capturedRegionName] = trigger
    CC.Systems.InvaderPathManager.regions[capturedRegionName] = region
end

--[[
    Handle when a unit enters a region.
]]
function CC.Systems.InvaderPathManager.OnUnitEnterRegion(unit, regionName)
    if unit == nil or regionName == nil then
        return
    end

    local unitData = CC.Systems.SpawnManager.units[GetHandleId(unit)]

    if unitData ~= nil then
        unitData.currentRegion = regionName
    end

    local spawn = CC.Systems.InvaderPathManager.GetOwningSpawnForRegion(regionName)

    if spawn == nil then
        return
    end

    local endZones = CC.Config.Regions.EndZones

    if regionName == endZones.northEast
        or regionName == endZones.northWest
        or regionName == endZones.southEast
        or regionName == endZones.southWest
    then
        CC.Systems.EndZoneManager.OnEnter(unit, regionName)
        return
    end

    local nextRegionName = CC.Systems.InvaderPathManager.GetNextRegion(regionName, unit)

    if nextRegionName == nil then
        CC.Core.Debug("InvaderPathManager", "Next region missing.")
        return
    end

    local x, y = CC.Systems.InvaderPathManager.GetRegionCenter(nextRegionName)

    if x == nil or y == nil then
        return
    end

    IssuePointOrder(unit, "move", x, y)
end

--[[
    Get the owning spawn for a region name.
]]
function CC.Systems.InvaderPathManager.GetOwningSpawnForRegion(regionName)
    local spawns = CC.Config.Regions.Spawns
    local north = CC.Config.Regions.North
    local east = CC.Config.Regions.East
    local south = CC.Config.Regions.South
    local west = CC.Config.Regions.West

    if regionName == spawns.north then return "north" end
    if regionName == spawns.east then return "east" end
    if regionName == spawns.south then return "south" end
    if regionName == spawns.west then return "west" end

    -- North
    for _, pathOne in ipairs(north.pathOne) do
        if (regionName == pathOne) then
            return "north"
        end
    end

    for _, pathTwo in ipairs(north.pathTwo) do
        if (regionName == pathTwo) then
            return "north"
        end
    end

    -- East
    for _, pathOne in ipairs(east.pathOne) do
        if (regionName == pathOne) then
            return "east"
        end
    end

    for _, pathTwo in ipairs(east.pathTwo) do
        if (regionName == pathTwo) then
            return "east"
        end
    end

    -- South
    for _, pathOne in ipairs(south.pathOne) do
        if (regionName == pathOne) then
            return "south"
        end
    end

    for _, pathTwo in ipairs(south.pathTwo) do
        if (regionName == pathTwo) then
            return "south"
        end
    end

    -- West
    for _, pathOne in ipairs(west.pathOne) do
        if (regionName == pathOne) then
            return "west"
        end
    end

    for _, pathTwo in ipairs(west.pathTwo) do
        if (regionName == pathTwo) then
            return "west"
        end
    end
end

--[[
    Get the region center.
]]
function CC.Systems.InvaderPathManager.GetRegionCenter(regionName)
    local rect = CC.Systems.SpawnManager.ResolveRegion(regionName)

    if rect == nil then
        CC.Core.Debug("InvaderPathManager", "Missing region center: " .. tostring(regionName))
        return nil, nil
    end

    return GetRectCenterX(rect), GetRectCenterY(rect)
end

--[[
    Get the next region to order the unit to.
]]
function CC.Systems.InvaderPathManager.GetNextRegion(regionName, unit)
    if regionName == nil or unit == nil then
        return nil
    end

    local unitData = CC.Systems.SpawnManager.units[GetHandleId(unit)]

    if unitData == nil then
        CC.Core.Debug("InvaderPathManager", "Missing unit data for invader.")
        return nil
    end

    local spawns = CC.Config.Regions.Spawns
    local endZones = CC.Config.Regions.EndZones

    local routeGroups = {
        north = CC.Config.Regions.North,
        east = CC.Config.Regions.East,
        south = CC.Config.Regions.South,
        west = CC.Config.Regions.West
    }

    local routeGroup = routeGroups[unitData.spawn]

    if routeGroup == nil then
        CC.Core.Debug("InvaderPathManager", "Invalid unit spawn: " .. tostring(unitData.spawn))
        return nil
    end

    local route = routeGroup[unitData.pathKey]

    if route == nil then
        CC.Core.Debug("InvaderPathManager", "Invalid path key: " .. tostring(unitData.pathKey))
        return nil
    end

    if regionName == spawns[unitData.spawn] then
        return route[1]
    end

    local index = CC.Core.Helpers.GetIndex(route, regionName)

    if index ~= nil then
        local nextRegion = route[index + 1]

        if nextRegion ~= nil then
            return nextRegion
        end
    end

    if unitData.spawn == "north" and unitData.pathKey == "pathOne" then
        return endZones.northWest
    elseif unitData.spawn == "north" and unitData.pathKey == "pathTwo" then
        return endZones.northEast
    elseif unitData.spawn == "east" and unitData.pathKey == "pathOne" then
        return endZones.northEast
    elseif unitData.spawn == "east" and unitData.pathKey == "pathTwo" then
        return endZones.southEast
    elseif unitData.spawn == "south" and unitData.pathKey == "pathOne" then
        return endZones.southEast
    elseif unitData.spawn == "south" and unitData.pathKey == "pathTwo" then
        return endZones.southWest
    elseif unitData.spawn == "west" and unitData.pathKey == "pathOne" then
        return endZones.northWest
    elseif unitData.spawn == "west" and unitData.pathKey == "pathTwo" then
        return endZones.southWest
    end

    return nil
end

--[[
    Check if a unit is owned by the invaders.
]]
function CC.Systems.InvaderPathManager.IsInvader(unit)
    if unit == nil then
        return false
    end

    return GetOwningPlayer(unit) == CC.Core.Constants.INVADER_PLAYER
end
--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Build Permission Manager                                  |
    | ========================================================= |
    | Manages all the player zone permissions.                  |
    +-----------------------------------------------------------+
]]

CC.Systems.BuildPermissionManager = CC.Systems.BuildPermissionManager or {}

CC.Systems.BuildPermissionManager.allowed = {}

--[[
    Initialize the Build Permission Manager.
]]
function CC.Systems.BuildPermissionManager.Init()
    CC.Core.Debug("BuildPermissionManager", "Initializing the Build Permission Manager...")

    CC.Systems.BuildPermissionManager.allowed = {}
    CC.Systems.BuildPermissionManager.RegisterBuildTriggers()

    CC.Core.Debug("BuildPermissionManager", "Build Permission Manager initialized.")
end

--[[
    Check whether the player can build in a zone.
]]
function CC.Systems.BuildPermissionManager.CanBuild(builderPlayer, zoneOwnerPlayer)
    local builderId = GetPlayerId(builderPlayer)
    local ownerId = GetPlayerId(zoneOwnerPlayer)
    local ownerData = CC.Systems.PlayerManager.GetPlayer(zoneOwnerPlayer)

    -- If the zone owner is not active, allow anyone to build there.
    if ownerData == nil or ownerData.active ~= true then
        return true
    end

    -- Players can always build in their own zone.
    if builderId == ownerId then
        return true
    end

    -- Otherwise, they need permission from the zone owner.
    return CC.Systems.BuildPermissionManager.allowed[ownerId] ~= nil
        and CC.Systems.BuildPermissionManager.allowed[ownerId][builderId] == true
end

--[[
    Get the zone owner for a build point.
]]
function CC.Systems.BuildPermissionManager.GetZoneOwnerForPoint(x, y)
    for playerId, regions in pairs(CC.Config.Regions.BuildZones) do
        for _, regionName in ipairs(regions) do
            local rect = CC.Systems.SpawnManager.ResolveRegion(regionName)

            if rect ~= nil and RectContainsCoords(rect, x, y) then
                return Player(playerId)
            end
        end
    end

    return nil
end

--[[
    Refund and remove an invalid building.
]]
function CC.Systems.BuildPermissionManager.CancelInvalidBuild(builder, structure, message)
    if builder == nil or structure == nil then
        return
    end

    local value = CC.Systems.TowerManager.GetTowerValue(structure)

    if value > 0 then
        CC.Systems.PlayerManager.AddResource(builder, "gold", value)
    end

    CC.UI.MessageManager.Player(
        builder,
        CC.Core.Color.Red(message or "You cannot build there.")
    )

    RemoveUnit(structure)
end

--[[
    Handle when a player starts construction.
]]
function CC.Systems.BuildPermissionManager.OnConstructStart()
    local structure = GetConstructingStructure()

    if structure == nil then
        return
    end

    local builder = GetOwningPlayer(structure)
    local x = GetUnitX(structure)
    local y = GetUnitY(structure)

    local zoneOwner = CC.Systems.BuildPermissionManager.GetZoneOwnerForPoint(x, y)

    if zoneOwner == nil then
        CC.Systems.BuildPermissionManager.CancelInvalidBuild(
            builder,
            structure,
            "You cannot build outside of a valid build zone."
        )

        return
    end

    if not CC.Systems.BuildPermissionManager.CanBuild(builder, zoneOwner) then
        CC.Systems.BuildPermissionManager.CancelInvalidBuild(
            builder,
            structure,
            "You do not have permission to build in this player's zone."
        )

        return
    end
end

--[[
    Allow a player to build in another player's zone.
]]
function CC.Systems.BuildPermissionManager.Allow(ownerPlayer, builderPlayer)
    local ownerId = GetPlayerId(ownerPlayer)
    local builderId = GetPlayerId(builderPlayer)

    CC.Systems.BuildPermissionManager.allowed[ownerId] =
        CC.Systems.BuildPermissionManager.allowed[ownerId] or {}

    CC.Systems.BuildPermissionManager.allowed[ownerId][builderId] = true
end

--[[
    Disallow a player from building in another player's zone.
]]
function CC.Systems.BuildPermissionManager.Disallow(ownerPlayer, builderPlayer)
    local ownerId = GetPlayerId(ownerPlayer)
    local builderId = GetPlayerId(builderPlayer)

    if CC.Systems.BuildPermissionManager.allowed[ownerId] == nil then
        return
    end

    CC.Systems.BuildPermissionManager.allowed[ownerId][builderId] = nil
end

--[[
    Allow all active players to build in a player's zone.
]]
function CC.Systems.BuildPermissionManager.AllowAll(ownerPlayer)
    CC.Systems.PlayerManager.ForEach(function (playerData)
        if playerData.active == true and playerData.player ~= ownerPlayer then
            CC.Systems.BuildPermissionManager.Allow(ownerPlayer, playerData.player)
        end
    end)
end

--[[
    Disallow all players from building in a player's zone.
]]
function CC.Systems.BuildPermissionManager.DisallowAll(ownerPlayer)
    local ownerId = GetPlayerId(ownerPlayer)

    CC.Systems.BuildPermissionManager.allowed[ownerId] = {}
end

--[[
    Register construction permission triggers.
]]
function CC.Systems.BuildPermissionManager.RegisterBuildTriggers()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerUnitEvent(
            trigger,
            Player(i),
            EVENT_PLAYER_UNIT_CONSTRUCT_START,
            nil
        )
    end

    TriggerAddAction(trigger, function ()
        CC.Systems.BuildPermissionManager.OnConstructStart()
    end)
end

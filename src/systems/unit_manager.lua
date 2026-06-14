--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Unit Manager                                              |
    | ========================================================= |
    | Manages units.                                            |
    +-----------------------------------------------------------+
]]

CC.Systems.UnitManager = CC.Systems.UnitManager or {}

--[[
    Initializes the Unit Manager.
]]
function CC.Systems.UnitManager.Init()
    CC.Core.Debug("UnitManager", "Initializing the Unit Manager...")
    CC.Core.Debug("UnitManager", "Unit Manager initialized.")
end

--[[
    Teleport a unit from the game.
]]
function CC.Systems.UnitManager.TeleportUnit(unit)
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)

    DestroyEffect(AddSpecialEffect(
        "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl",
        x,
        y
    ))

    CC.Systems.SpawnManager.units[GetHandleId(unit)] = nil

    ShowUnit(unit, false)
    KillUnit(unit)
end

--[[
    Blow up an unit.
]]
function CC.Systems.UnitManager.BlowUpUnit(unit)
    DestroyEffect(
        AddSpecialEffect(
            "Abilities\\Weapons\\DemolisherMissile\\DemolisherMissile.mdl",
            GetUnitX(unit),
            GetUnitY(unit)
        )
    )

    CC.Systems.SpawnManager.units[GetHandleId(unit)] = nil

    KillUnit(unit)
end

--[[
    Blow up all units in the game.
]]
function CC.Systems.UnitManager.BlowUpAllUnits()
    local group = CreateGroup()

    for playerIndex = 0, bj_MAX_PLAYERS - 1 do
        GroupEnumUnitsOfPlayer(group, Player(playerIndex), nil)

        ForGroup(group, function ()
            local unit = GetEnumUnit()

            if unit ~= nil and GetUnitTypeId(unit) ~= 0 then
                CC.Systems.SpawnManager.BlowUpUnit(unit)
            end
        end)

        GroupClear(group)
    end

    DestroyGroup(group)
end

--[[
    Transfer units from one player to another.
]]
function CC.Systems.UnitManager.TransferUnits(fromPlayer, toPlayer)
    if fromPlayer == nil or toPlayer == nil then
        return
    end

    local group = CreateGroup()

    GroupEnumUnitsOfPlayer(group, fromPlayer, nil)

    ForGroup(group, function ()
        local unit = GetEnumUnit()

        if unit ~= nil and GetWidgetLife(unit) > 0.405 then
            SetUnitOwner(unit, toPlayer, true)
        end
    end)

    DestroyGroup(group)
end

--[[
    Gets the current health percentage for a unit.
]]
function CC.Systems.UnitManager.GetHealthPercent(unit)
    if unit == nil then
        return 0
    end

    local life = GetUnitState(unit, UNIT_STATE_LIFE)
    local maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE)

    if maxLife <= 0 then
        return 0
    end

    return (life / maxLife) * 100
end

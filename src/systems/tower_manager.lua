--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Tower Manager                                             |
    | ========================================================= |
    | Manages towers for selling and triggering abilities.      |
    +-----------------------------------------------------------+
]]

CC.Systems.TowerManager = CC.Systems.TowerManager or {}

CC.Systems.TowerManager.spellTowers = CC.Systems.TowerManager.spellTowers or {}
CC.Systems.TowerManager.towerSellRefundRate = 0.75
CC.Systems.TowerManager.sellTowerAbilityId = FourCC("A00C")
CC.Systems.TowerManager.sellTowerEffect = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
CC.Systems.TowerManager.expensiveTowerThreshold = 1000
CC.Systems.TowerManager.confirmSellTimeout = 5.00
CC.Systems.TowerManager.pendingSellConfirmations = CC.Systems.TowerManager.pendingSellConfirmations or {}
CC.Systems.TowerManager.upgradingTowers = CC.Systems.TowerManager.upgradingTowers or {}

--[[
    Initialize the Tower Manager.
]]
function CC.Systems.TowerManager.Init()
    CC.Core.Debug("TowerManager", "Initializing the tower manager...")
    
    CC.Systems.TowerManager.RegisterTowerBuildTriggers()
    CC.Systems.TowerManager.RegisterTowerUpgradeStartTriggers()
    CC.Systems.TowerManager.RegisterTowerConstructionStartTriggers()
    CC.Systems.TowerManager.Start()
    CC.Systems.TowerManager.InitSellTrigger()

    CC.Core.Debug("TowerManager", "Tower manager inialized.")
end

--[[
    Register a spell tower.
]]
function CC.Systems.TowerManager.RegisterTower(tower)
    local unitType = GetUnitTypeId(tower)
    local towers = CC.Core.Constants.TOWERS

    -- Flame towers
    if unitType == towers.FLAME.FIRE_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "breathoffire",
            range = 600
        }
    end

    if unitType == towers.FLAME.MOLTEN_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "breathoffire",
            range = 700
        }
    end

    if unitType == towers.FLAME.INCINERATION_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "breathoffire",
            range = 800
        }
    end

    if unitType == towers.FLAME.DRAGONS_BREATH_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "breathoffire",
            range = 900
        }
    end

    -- Cold towers
    if unitType == towers.COLD.COLD_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "blizzard",
            range = 600
        }
    end

    if unitType == towers.COLD.COLDER_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "blizzard",
            range = 700
        }
    end

    if unitType == towers.COLD.FROZEN_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "blizzard",
            range = 800
        }
    end

    if unitType == towers.COLD.PERMAFROST_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "blizzard",
            range = 900
        }
    end

    if unitType == towers.ENERGY.ELECTROCUTION_TOWER then
        CC.Systems.TowerManager.spellTowers[tower] = {
            order = "chainlightning",
            range = 900
        }
    end
end

--[[
    Helper that helps target a nearby enemy target within a given range.
]]
function CC.Systems.TowerManager.GetNearestEnemy(tower, range)
    local group = CreateGroup()
    local towerX = GetUnitX(tower)
    local towerY = GetUnitY(tower)
    local owner = GetOwningPlayer(tower)

    local nearest = nil
    local nearestDist = 999999

    GroupEnumUnitsInRange(group, towerX, towerY, range, nil)

    ForGroup(group, function ()
        local unit = GetEnumUnit()

        if IsUnitEnemy(unit, owner) and GetWidgetLife(unit) > 0.405 and not IsUnitType(unit, UNIT_TYPE_STRUCTURE) then
            local dx = GetUnitX(unit) - towerX
            local dy = GetUnitY(unit) - towerY
            local dist = dx * dx + dy * dy
            
            if dist < nearestDist then
                nearestDist = dist
                nearest = unit
            end
        end
    end)

    DestroyGroup(group)

    return nearest
end

--[[
    Start the periodic tower magic cast loop.
]]
function CC.Systems.TowerManager.Start()
    local timer = CreateTimer()

    TimerStart(timer, 0.75, true, function ()
        for tower, data in pairs(CC.Systems.TowerManager.spellTowers) do
            if GetWidgetLife(tower) > 0.405 then
                local target = CC.Systems.TowerManager.GetNearestEnemy(tower, data.range)

                if target ~= nil then
                    IssuePointOrder(
                        tower,
                        data.order,
                        GetUnitX(target),
                        GetUnitY(target)
                    )
                end
            else
                CC.Systems.TowerManager.spellTowers[tower] = nil
            end
        end
    end)
end

--[[
    Register the tower building triggers.
]]
function CC.Systems.TowerManager.RegisterTowerBuildTriggers()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerUnitEvent(
            trigger,
            Player(i),
            EVENT_PLAYER_UNIT_CONSTRUCT_FINISH,
            nil
        )
    end

    TriggerAddAction(trigger, function ()
        local tower = GetConstructedStructure()
        local owner = GetOwningPlayer(tower)
        local playerData = CC.Systems.PlayerManager.GetPlayer(owner)
        local handleId = GetHandleId(tower)

        CC.Systems.TowerManager.RegisterTower(tower)

        if CC.Systems.TowerManager.upgradingTowers[handleId] == true then
            CC.Systems.EndGameSummaryManager.AddTowerUpgraded(playerData)
            CC.Systems.TowerManager.upgradingTowers[handleId] = nil
        else
            CC.Systems.EndGameSummaryManager.AddTowersBuilt(playerData)
        end
    end)
end

--[[
    Get the full gold value of a tower.
]]
function CC.Systems.TowerManager.GetTowerValue(tower)
    if tower == nil then
        return 0
    end

    local unitTypeId = GetUnitTypeId(tower)

    for rawcode, value in pairs(CC.Config.TowerValues) do
        if unitTypeId == FourCC(rawcode) then
            return value
        end
    end

    return 0
end

--[[
    Gets the confirmation key for a player and tower.
]]
function CC.Systems.TowerManager.GetSellConfirmationKey(player, tower)
    return GetPlayerId(player) .. ":" .. tostring(GetHandleId(tower))
end

--[[
    Checks whether a tower sell is waiting for confirmation.
]]
function CC.Systems.TowerManager.HasSellConfirmation(player, tower)
    local key = CC.Systems.TowerManager.GetSellConfirmationKey(player, tower)

    return CC.Systems.TowerManager.pendingSellConfirmations[key] == true
end

--[[
    Starts the sell confirmation window for an expensive tower.
]]
function CC.Systems.TowerManager.StartSellConfirmation(player, tower, refund)
    local key = CC.Systems.TowerManager.GetSellConfirmationKey(player, tower)

    CC.Systems.TowerManager.pendingSellConfirmations[key] = true

    CC.UI.MessageManager.Player(
        player,
        CC.Core.Color.Yellow("This is an expensive tower. Cast Sell Tower again within ") ..
        CC.Core.Color.Orange(tostring(math.floor(CC.Systems.TowerManager.confirmSellTimeout))) ..
        CC.Core.Color.Yellow(" seconds to confirm selling it for ") ..
        CC.Core.Color.Orange(tostring(refund)) ..
        CC.Core.Color.Yellow(" gold.")
    )

    local timer = CreateTimer()

    TimerStart(timer, CC.Systems.TowerManager.confirmSellTimeout, false, function ()
        CC.Systems.TowerManager.pendingSellConfirmations[key] = nil
        DestroyTimer(timer)
    end)
end

--[[
    Clears the sell confirmatiojn for a player and tower.
]]
function CC.Systems.TowerManager.ClearSellConfirmation(player, tower)
    local key = CC.Systems.TowerManager.GetSellConfirmationKey(player, tower)

    CC.Systems.TowerManager.pendingSellConfirmations[key] = nil
end

--[[
    Shows floating gold refund text above the sold tower.
]]
function CC.Systems.TowerManager.ShowRefundText(player, x, y, refund)
    local tag = CreateTextTag()

    SetTextTagText(tag, "+" .. tostring(refund) .. " Gold", 0.024)
    SetTextTagPos(tag, x, y, 80.00)
    SetTextTagColor(tag, 255, 220, 0, 255)
    SetTextTagVelocity(tag, 0.00, 0.035)
    SetTextTagVisibility(tag, GetLocalPlayer() == player)
    SetTextTagPermanent(tag, false)
    SetTextTagLifespan(tag, 2.00)
    SetTextTagFadepoint(tag, 1.25)
end

--[[
    Sells a tower and refunds the owner 75% of its full value.
]]
function CC.Systems.TowerManager.SellTower(tower)
    if tower == nil then
        return
    end

    local owner = GetOwningPlayer(tower)
    local value = CC.Systems.TowerManager.GetTowerValue(tower)

    if value <= 0 then
        CC.UI.MessageManager.Player(
            owner,
            CC.Core.Color.Red("This tower cannot be sold.")
        )

        return
    end

    local refund = math.floor(value * CC.Systems.TowerManager.towerSellRefundRate)

    CC.Systems.PlayerManager.AddResource(owner, "gold", refund)

    local x = GetUnitX(tower)
    local y = GetUnitY(tower)

    DestroyEffect(AddSpecialEffect(CC.Systems.TowerManager.sellTowerEffect, x, y))

    CC.Systems.TowerManager.ShowRefundText(owner, x, y, refund)

    CC.UI.MessageManager.Player(
        owner,
        CC.Core.Color.Teal("Tower sold! ") ..
        CC.Core.Color.Yellow("Refunded ") ..
        CC.Core.Color.Orange(tostring(refund)) ..
        CC.Core.Color.Yellow(" gold.")
    )

    local playerData = CC.Systems.PlayerManager.GetPlayer(owner)

    CC.Systems.EndGameSummaryManager.AddTowerSold(playerData)

    CC.Systems.TowerManager.ClearSellConfirmation(owner, tower)

    RemoveUnit(tower)
end

--[[
    Handles a sell tower cast.
]]
function CC.Systems.TowerManager.HandleSellTowerCast(caster, tower)
    if caster == nil or tower == nil then
        return
    end

    local player = GetOwningPlayer(caster)
    local towerOwner = GetOwningPlayer(tower)

    if player ~= towerOwner then
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Red("You can only sell your own towers.")
        )

        return
    end

    local value = CC.Systems.TowerManager.GetTowerValue(tower)

    if value <= 0 then
        CC.UI.MessageManager.Player(
            player,
            CC.Core.Color.Red("This tower cannot be sold.")
        )

        return
    end

    local refund = math.floor(value * CC.Systems.TowerManager.towerSellRefundRate)

    if value >= CC.Systems.TowerManager.expensiveTowerThreshold and
        not CC.Systems.TowerManager.HasSellConfirmation(player, tower) then
            CC.Systems.TowerManager.StartSellConfirmation(player, tower, refund)
            return
        end

    CC.Systems.TowerManager.SellTower(tower)
end

--[[
    Initialize and sell tower trigger.
]]
function CC.Systems.TowerManager.InitSellTrigger()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerUnitEvent(
            trigger,
            Player(i),
            EVENT_PLAYER_UNIT_SPELL_EFFECT,
            nil
        )
    end

    TriggerAddAction(trigger, function ()
        local abilityId = GetSpellAbilityId()

        if abilityId ~= CC.Systems.TowerManager.sellTowerAbilityId then
            return
        end

        local caster = GetTriggerUnit()

        CC.Systems.TowerManager.HandleSellTowerCast(caster, caster)
    end)
end

--[[
    Register tower upgrade triggers.
]]
function CC.Systems.TowerManager.RegisterTowerUpgradeStartTriggers()
    local trigger = CreateTrigger()

    for i = 0, 7 do
        TriggerRegisterPlayerUnitEvent(
            trigger,
            Player(i),
            EVENT_PLAYER_UNIT_UPGRADE_START,
            nil
        )
    end

    TriggerAddAction(trigger, function ()
        local tower = GetTriggerUnit()

        CC.Systems.TowerManager.upgradingTowers[GetHandleId(tower)] = true
    end)
end

--[[
    Register tower construction towers for gathering total gold spent.
]]
function CC.Systems.TowerManager.RegisterTowerConstructionStartTriggers()
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
        local tower = GetConstructingStructure()
        local owner = GetOwningPlayer(tower)
        local playerData = CC.Systems.PlayerManager.GetPlayer(owner)
        local value = CC.Systems.TowerManager.GetTowerValue(tower)

        CC.Systems.EndGameSummaryManager.AddGoldSpent(playerData, value)
    end)
end
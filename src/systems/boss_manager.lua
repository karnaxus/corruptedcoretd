--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Boss Manager                                              |
    | ========================================================= |
    | Manages the two bosses for the game.                      |
    +-----------------------------------------------------------+
]]

CC.Systems.BossManager = CC.Systems.BossManager or {}

CC.Systems.BossManager.checkInterval = 0.25
CC.Systems.BossManager.activeBosses = {}

CC.Systems.BossManager.bosses = {
    [20] = {
        warning = "An evil champion from the Burning Legion approaches",
        rewardGold = 500,
        scale = 1.5,
        bonusArmor = 10,
        bonusHealthMultiplier = 1.25,
        regenPerSecond = 50,
        summonThresholds = { 80, 60, 40, 20 },
        data = {}
    },

    [30] = {
        warning = "Doom looms -- A Doom Guard Champion has appeared...",
        rewardGold = 1500,
        scale = 2.0,
        bonusArmor = 25,
        bonusHealthMultiplier = 1.5,
        regenPerSecond = 200,
        enrageThreshold = 50,
        enrageSpeedBonus = 150,
        data = {}
    }
}

--[[
    Initialize the Boss Manager.
]]
function CC.Systems.BossManager.Init()
    CC.Core.Debug("BossManager", "Initializing the Boss Manager...")

    CC.Systems.BossManager.InitBossCheckTimer()

    CC.Core.Debug("BossManager", "Boss Manager initialized.")
end

--[[
    Get the boss configuration for a wave.
]]
function CC.Systems.BossManager.GetBossConfig(wave)
    if wave == nil or wave.number == nil then
        return nil
    end

    return CC.Systems.BossManager.bosses[wave.number]
end

--[[
    Handle when a boss is spawned.
]]
function CC.Systems.BossManager.OnBossSpawn(boss, wave)
    if boss == nil or wave == nil then
        return
    end

    local bossConfig = CC.Systems.BossManager.GetBossConfig(wave)

    if bossConfig == nil then
        return
    end

    CC.Systems.BossManager.ApplyBossStats(boss, wave)

    local bossId = GetHandleId(boss)

    CC.Systems.BossManager.activeBosses[bossId] = {
        unit = boss,
        wave = wave,
        config = bossConfig,
        nextSummonIndex = 1,
        enraged = false
    }

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Red(bossConfig.warning)
    )

    CC.Core.Debug("BossManager", "Boss spawned for wave " .. tostring(wave.number))
end

--[[
    Handle when a boss gets killed.
]]
function CC.Systems.BossManager.OnBossDeath(boss, wave, killer)
    if boss == nil then
        return
    end

    local bossId = GetHandleId(boss)
    local data = CC.Systems.BossManager.activeBosses[bossId]

    if data ~= nil then
        wave = data.wave
    end

    CC.Systems.BossManager.activeBosses[bossId] = nil

    if killer ~= nil and wave ~= nil then
        local player = GetOwningPlayer(killer)
        local playerData = CC.Systems.PlayerManager.GetPlayer(player)

        CC.Systems.BossManager.GiveBossReward(player, wave)

        CC.Systems.EndGameSummaryManager.AddBossKilled(playerData)
    end
end

--[[
    Apply special stats for a boss.
]]
function CC.Systems.BossManager.ApplyBossStats(boss, wave)
    if boss == nil or wave == nil then
        return
    end

    local bossConfig = CC.Systems.BossManager.GetBossConfig(wave)

    if bossConfig == nil then
        return
    end

    local maxLife = BlzGetUnitMaxHP(boss)
    local newMaxLife = math.floor(maxLife * bossConfig.bonusHealthMultiplier)

    BlzSetUnitMaxHP(boss, newMaxLife)
    SetUnitState(boss, UNIT_STATE_LIFE, newMaxLife)

    BlzSetUnitArmor(boss, bossConfig.bonusArmor)
    BlzSetUnitRealField(boss, UNIT_RF_SCALING_VALUE, bossConfig.scale)

    CC.Core.Debug("BossManager", "Applied special boss stats for wave " .. tostring(wave.number) .. ".")
end

--[[
    Give a special reward for killing the boss.
]]
function CC.Systems.BossManager.GiveBossReward(player, wave)
    if player == nil or wave == nil then
        return
    end

    local bossConfig = CC.Systems.BossManager.GetBossConfig(wave)

    if bossConfig == nil or bossConfig.rewardGold == nil then
        return
    end

    CC.Systems.PlayerManager.AddResource(player, "gold", bossConfig.rewardGold)

    CC.UI.MessageManager.Player(
        player,
        CC.Core.Color.Teal("Boss defeated! ") ..
        CC.Core.Color.Yellow("Bonus reward: ") ..
        CC.Core.Color.Orange(tostring(bossConfig.rewardGold)) ..
        CC.Core.Color.Yellow(" gold.")
    )
end

--[[
    Initialize the periodic boss checking timer.
]]
function CC.Systems.BossManager.InitBossCheckTimer()
    local timer = CreateTimer()

    TimerStart(timer, CC.Systems.BossManager.checkInterval, true, function ()
        CC.Systems.BossManager.CheckActiveBosses()
    end)
end

--[[
    Checks all active bosses for special mechanics.
]]
function CC.Systems.BossManager.CheckActiveBosses()
    for bossId, data in pairs(CC.Systems.BossManager.activeBosses) do
        local boss = data.unit

        if boss == nil or GetUnitTypeId(boss) == 0 or GetWidgetLife(boss) <= 0.405 then
            CC.Systems.BossManager.activeBosses[bossId] = nil
        else
            CC.Systems.BossManager.ApplyBossRegen(boss, data)
            CC.Systems.BossManager.CheckInfernal(boss, data)
            CC.Systems.BossManager.CheckDoomGuard(boss, data)
        end
    end
end

--[[
    Apply special life regen to a boss.
]]
function CC.Systems.BossManager.ApplyBossRegen(boss, data)
    if boss == nil or data == nil or data.config == nil then
        return
    end

    local regen = data.config.regenPerSecond or 0

    if regen <= 0 then
        return
    end

    local life = GetUnitState(boss, UNIT_STATE_LIFE)
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local amount = regen * CC.Systems.BossManager.checkInterval

    SetUnitState(
        boss,
        UNIT_STATE_LIFE,
        math.min(life + amount, maxLife)
    )
end

--[[
    Check the Burning Legion Infernal boss.
]]
function CC.Systems.BossManager.CheckInfernal(boss, data)
    if data == nil or data.wave == nil or data.wave.number ~= 20 then
        return
    end

    local thresholds = data.config.summonThresholds

    if thresholds == nil then
        return
    end

    local threshold = thresholds[data.nextSummonIndex]

    if threshold == nil then
        return
    end

    local hpPercent = CC.Systems.UnitManager.GetHealthPercent(boss)

    if hpPercent <= threshold then
        CC.Systems.BossManager.SpawnOrcChampions(boss, data)

        CC.UI.MessageManager.Broadcast(
            CC.Core.Color.Purple("The Infernal Lord summons reinforcements!")
        )

        data.nextSummonIndex = data.nextSummonIndex + 1
    end
end

--[[
    Check the Doom Guard boss.
]]
function  CC.Systems.BossManager.CheckDoomGuard(boss, data)
    if data == nil or data.wave == nil or data.wave.number ~= 30 then
        return
    end

    if data.enraged == true then
        return
    end

    local hpPercent = CC.Systems.UnitManager.GetHealthPercent(boss)
    local threshold = data.config.enrageThreshold or 50

    if hpPercent <= threshold then
        CC.Systems.BossManager.EnrageDoomGuard(boss, data.config.enrageSpeedBonus or 150)
        data.enraged = true
    end
end

--[[
    Spawns the orc champions next to the boss.
]]
function CC.Systems.BossManager.SpawnOrcChampions(boss, data)
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local owner = GetOwningPlayer(boss)

    for i = 1, 5 do
        local angle = math.rad(i * 72)

        local unit = CreateUnit(
            owner,
            FourCC("n00E"),
            x + 150 * math.cos(angle),
            y + 150 * math.sin(angle),
            bj_UNIT_FACING
        )

        SetUnitPathing(unit, false)

        CC.Systems.SpawnManager.invadersAlive = CC.Systems.SpawnManager.invadersAlive + 1
        CC.Systems.SpawnManager.OrderCreepToNextRegion(boss, unit)

        DestroyEffect(
            AddSpecialEffect(
                "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl",
                GetUnitX(unit),
                GetUnitY(unit)
            )
        )
    end

    DestroyEffect(
        AddSpecialEffect(
            "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",
            x,
            y
        )
    )
end

--[[
    Enrage the Doom Guard boss.
]]
function CC.Systems.BossManager.EnrageDoomGuard(boss, speedBonus)
    local currentSpeed = GetUnitMoveSpeed(boss)

     SetUnitMoveSpeed(
        boss,
        math.min(currentSpeed + speedBonus, 522)
    )

    DestroyEffect(
        AddSpecialEffectTarget(
            "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl",
            boss,
            "origin"
        )
    )

    CC.UI.MessageManager.Broadcast(
        CC.Core.Color.Red("The Doom Guard Champion enraged!")
    )
end

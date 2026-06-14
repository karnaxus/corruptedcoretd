--[[
    +-----------------------------------------------------------+
    | CORRUPTED CORE TD                                         |
    | ========================================================= |
    | @author Karnaxus#11298                                    |
    | ========================================================= |
    | Waves                                                     |
    | ========================================================= |
    | List of all waves of invaders.                            |
    +-----------------------------------------------------------+
]]

--[[
    Wave categories.
]]
CC.Config.WaveCategories = {
    NORMAL = "normal",
    AIR = "air",
    BOSS = "boss"
}

--[[
    All the waves of invaders.
]]
CC.Config.Waves = {
    [1] = {
        name = "Spitting Spider",
        description = "Venomous crawlers that test the first layer of your defenses.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n002"),
        total = 30,
        hp = 90,
        goldPerKill = 4,
        goldPerWave = 100,
        spawnDelay = 0.50,
        number = 1,
        leakValue = 1
    },

    [2] = {
        name = "Kobold Taskmaster",
        description = "Cruel kobold overseers that push the early assault forward.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n004"),
        total = 31,
        hp = 190,
        goldPerKill = 6,
        goldPerWave = 125,
        spawnDelay = 0.50,
        number = 2,
        leakValue = 1
    },

    [3] = {
        name = "Murloc Tiderunner",
        description = "Fast-moving murlocs that rush the lanes in noisy packs.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n005"),
        total = 32,
        hp = 325,
        goldPerKill = 8,
        goldPerWave = 150,
        spawnDelay = 0.50,
        number = 3,
        leakValue = 1
    },

    [4] = {
        name = "Enraged Elemental",
        description = "Unstable elementals burning with corrupted energy.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n006"),
        total = 33,
        hp = 475,
        goldPerKill = 10,
        goldPerWave = 175,
        spawnDelay = 0.50,
        number = 4,
        leakValue = 1
    },

    [5] = {
        name = "Red Dragon Whelp",
        description = "Flying dragon whelps that force players to prepare anti-air defenses.",
        category = CC.Config.WaveCategories.AIR,
        unitType = FourCC("n007"),
        total = 34,
        hp = 650,
        goldPerKill = 12,
        goldPerWave = 200,
        spawnDelay = 0.50,
        number = 5,
        leakValue = 1
    },

    [6] = {
        name = "Enraged Wildkin",
        description = "Heavy wildkin that punish weak tower placement and poor focus fire.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n008"),
        total = 34,
        hp = 850,
        goldPerKill = 14,
        goldPerWave = 250,
        spawnDelay = 0.50,
        number = 6,
        leakValue = 1
    },

    [7] = {
        name = "Deeplord Revenant",
        description = "Ancient revenants pulled from the depths by the Core's corruption.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n009"),
        total = 34,
        hp = 1050,
        goldPerKill = 16,
        goldPerWave = 300,
        spawnDelay = 0.50,
        number = 7,
        leakValue = 1
    },

    [8] = {
        name = "Draenei Harbinger",
        description = "Darkened harbingers marching with disciplined, magical resolve.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00A"),
        total = 34,
        hp = 1250,
        goldPerKill = 18,
        goldPerWave = 350,
        spawnDelay = 0.50,
        number = 8,
        leakValue = 1
    },

    [9] = {
        name = "Giant Polar Bear",
        description = "Massive beasts with enough health to break underbuilt defenses.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00B"),
        total = 34,
        hp = 1500,
        goldPerKill = 20,
        goldPerWave = 400,
        spawnDelay = 0.50,
        number = 9,
        leakValue = 1
    },

    [10] = {
        name = "Harpy Queen",
        description = "Aerial harpy leaders that swarm over ground-only defenses.",
        category = CC.Config.WaveCategories.AIR,
        unitType = FourCC("n00C"),
        total = 34,
        hp = 1750,
        goldPerKill = 24,
        goldPerWave = 450,
        spawnDelay = 0.50,
        number = 10,
        leakValue = 1
    },

    [11] = {
        name = "Lesser Voidwalker",
        description = "Void-touched walkers that absorb punishment while advancing steadily.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00D"),
        total = 35,
        hp = 2100,
        goldPerKill = 26,
        goldPerWave = 500,
        spawnDelay = 0.50,
        number = 11,
        leakValue = 1
    },

    [12] = {
        name = "Skeletal Orc Champion",
        description = "Undead champions that advance with brutal strength and no fear.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00E"),
        total = 35,
        hp = 2400,
        goldPerKill = 28,
        goldPerWave = 550,
        spawnDelay = 0.50,
        number = 12,
        leakValue = 1
    },

    [13] = {
        name = "Faceless One Trickster",
        description = "Twisted manipulators that signal the corruption's growing intelligence.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00F"),
        total = 35,
        hp = 2700,
        goldPerKill = 30,
        goldPerWave = 600,
        spawnDelay = 0.50,
        number = 13,
        leakValue = 1
    },

    [14] = {
        name = "Tuskar Chieftain",
        description = "Sturdy chieftains that demand upgraded towers and better lane coverage.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00G"),
        total = 35,
        hp = 3050,
        goldPerKill = 32,
        goldPerWave = 650,
        spawnDelay = 0.50,
        number = 14,
        leakValue = 1
    },

    [15] = {
        name = "Bronze Dragon",
        description = "Armored dragons that soar over the battlefield in dangerous formation.",
        category = CC.Config.WaveCategories.AIR,
        unitType = FourCC("n00H"),
        total = 35,
        hp = 3400,
        goldPerKill = 36,
        goldPerWave = 700,
        spawnDelay = 0.50,
        number = 15,
        leakValue = 1
    },

    [16] = {
        name = "Eredar Warlock",
        description = "Corrupted spellcasters empowered by demonic fire and shadow magic.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00I"),
        total = 35,
        hp = 3800,
        goldPerKill = 38,
        goldPerWave = 750,
        spawnDelay = 0.50,
        number = 16,
        leakValue = 1
    },

    [17] = {
        name = "Sludge Monstrosity",
        description = "Bloated monstrosities that soak damage and clog the lanes.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00J"),
        total = 35,
        hp = 4300,
        goldPerKill = 40,
        goldPerWave = 800,
        spawnDelay = 0.50,
        number = 17,
        leakValue = 1
    },

    [18] = {
        name = "Succubus",
        description = "Deceptive demons that slip forward under the cover of the assault.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00K"),
        total = 35,
        hp = 4800,
        goldPerKill = 42,
        goldPerWave = 850,
        spawnDelay = 0.50,
        number = 18,
        leakValue = 1
    },

    [19] = {
        name = "Ogre Lord",
        description = "Brutish ogre lords that crush weak defenses before the first boss gate.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00L"),
        total = 35,
        hp = 5350,
        goldPerKill = 45,
        goldPerWave = 900,
        spawnDelay = 0.50,
        number = 19,
        leakValue = 1
    },

    [20] = {
        name = "Infernal Lord",
        description = "A towering infernal boss that tests the team's damage, economy, and coordination.",
        category = CC.Config.WaveCategories.BOSS,
        unitType = FourCC("n00M"),
        total = 1,
        hp = 65000,
        goldPerKill = 150,
        goldPerWave = 1250,
        spawnDelay = 0.50,
        number = 20,
        leakValue = 10
    },

    [21] = {
        name = "Storm Wyrm",
        description = "Storm-charged beasts that begin the late-game pressure spike.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00N"),
        total = 36,
        hp = 6000,
        goldPerKill = 50,
        goldPerWave = 1000,
        spawnDelay = 0.50,
        number = 21,
        leakValue = 1
    },

    [22] = {
        name = "Magnataur Destroyer",
        description = "Massive destroyers that punish teams that delay major upgrades.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00O"),
        total = 36,
        hp = 6700,
        goldPerKill = 55,
        goldPerWave = 1100,
        spawnDelay = 0.50,
        number = 22,
        leakValue = 1
    },

    [23] = {
        name = "Unbroken Darkweaver",
        description = "Darkweavers strengthened by the Core's spreading corruption.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00P"),
        total = 36,
        hp = 7500,
        goldPerKill = 60,
        goldPerWave = 1200,
        spawnDelay = 0.50,
        number = 23,
        leakValue = 1
    },

    [24] = {
        name = "Dragon Turtle",
        description = "Armored turtles with thick shells that require sustained damage to bring down.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00Q"),
        total = 36,
        hp = 8350,
        goldPerKill = 65,
        goldPerWave = 1300,
        spawnDelay = 0.50,
        number = 24,
        leakValue = 1
    },

    [25] = {
        name = "Nether Dragon",
        description = "Late-game flying dragons that demand serious anti-air investment.",
        category = CC.Config.WaveCategories.AIR,
        unitType = FourCC("n00R"),
        total = 36,
        hp = 9300,
        goldPerKill = 75,
        goldPerWave = 1400,
        spawnDelay = 0.50,
        number = 25,
        leakValue = 1
    },

    [26] = {
        name = "Dire Mammoth",
        description = "Huge mammoths that trample forward with devastating endurance.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00S"),
        total = 37,
        hp = 10300,
        goldPerKill = 85,
        goldPerWave = 1500,
        spawnDelay = 0.50,
        number = 26,
        leakValue = 1
    },

    [27] = {
        name = "Ice Troll Warlord",
        description = "War-crazed trolls hardened by frost and corruption.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00T"),
        total = 37,
        hp = 11400,
        goldPerKill = 95,
        goldPerWave = 1600,
        spawnDelay = 0.50,
        number = 27,
        leakValue = 1
    },

    [28] = {
        name = "Salamander Lord",
        description = "Fiery salamander lords that bring brutal late-game pressure.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00U"),
        total = 37,
        hp = 12600,
        goldPerKill = 110,
        goldPerWave = 1700,
        spawnDelay = 0.50,
        number = 28,
        leakValue = 1
    },

    [29] = {
        name = "Nerubian Spider Lord",
        description = "Elite spider lords that serve as the final swarm before the champion arrives.",
        category = CC.Config.WaveCategories.NORMAL,
        unitType = FourCC("n00V"),
        total = 37,
        hp = 14000,
        goldPerKill = 125,
        goldPerWave = 1800,
        spawnDelay = 0.50,
        number = 29,
        leakValue = 1
    },

    [30] = {
        name = "Doom Lord Champion",
        description = "The final champion of corruption. If it reaches an endzone, the defense may collapse.",
        category = CC.Config.WaveCategories.BOSS,
        unitType = FourCC("n00W"),
        total = 1,
        hp = 150000,
        goldPerKill = 750,
        goldPerWave = 3000,
        spawnDelay = 0.50,
        number = 30,
        leakValue = 15
    }
}

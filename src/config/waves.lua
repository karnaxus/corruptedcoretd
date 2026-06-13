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
    All the waves of invaders.
]]
CC.Config.Waves = {
    [1] = {
        name = "Spitting Spider",
        unitType = FourCC("n002"),
        total = 22,
        hp = 90,
        goldPerKill = 4,
        goldPerWave = 100,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 1,
        leakValue = 1
    },

    [2] = {
        name = "Kobold Taskmaster",
        unitType = FourCC("n004"),
        total = 22,
        hp = 190,
        goldPerKill = 6,
        goldPerWave = 125,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 2,
        leakValue = 1
    },

    [3] = {
        name = "Murloc Tiderunner",
        unitType = FourCC("n005"),
        total = 22,
        hp = 325,
        goldPerKill = 8,
        goldPerWave = 150,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 3,
        leakValue = 1
    },

    [4] = {
        name = "Enraged Elemental",
        unitType = FourCC("n006"),
        total = 22,
        hp = 475,
        goldPerKill = 10,
        goldPerWave = 175,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 4,
        leakValue = 1
    },

    [5] = {
        name = "Red Dragon Whelp",
        unitType = FourCC("n007"),
        total = 22,
        hp = 650,
        goldPerKill = 12,
        goldPerWave = 200,
        spawnDelay = 0.50,
        isAir = true,
        isBoss = false,
        number = 5,
        leakValue = 1
    },

    [6] = {
        name = "Enraged Wildkin",
        unitType = FourCC("n008"),
        total = 24,
        hp = 850,
        goldPerKill = 14,
        goldPerWave = 250,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 6,
        leakValue = 1
    },

    [7] = {
        name = "Deeplord Revenant",
        unitType = FourCC("n009"),
        total = 24,
        hp = 1050,
        goldPerKill = 16,
        goldPerWave = 300,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 7,
        leakValue = 1
    },

    [8] = {
        name = "Draenei Harbinger",
        unitType = FourCC("n00A"),
        total = 24,
        hp = 1250,
        goldPerKill = 18,
        goldPerWave = 350,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 8,
        leakValue = 1
    },

    [9] = {
        name = "Giant Polar Bear",
        unitType = FourCC("n00B"),
        total = 24,
        hp = 1500,
        goldPerKill = 20,
        goldPerWave = 400,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 9,
        leakValue = 1
    },

    [10] = {
        name = "Harpy Queen",
        unitType = FourCC("n00C"),
        total = 24,
        hp = 1750,
        goldPerKill = 24,
        goldPerWave = 450,
        spawnDelay = 0.50,
        isAir = true,
        isBoss = false,
        number = 10,
        leakValue = 1
    },

    [11] = {
        name = "Lesser Voidwalker",
        unitType = FourCC("n00D"),
        total = 26,
        hp = 2100,
        goldPerKill = 26,
        goldPerWave = 500,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 11,
        leakValue = 1
    },

    [12] = {
        name = "Skeletal Orc Champion",
        unitType = FourCC("n00E"),
        total = 26,
        hp = 2400,
        goldPerKill = 28,
        goldPerWave = 550,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 12,
        leakValue = 1
    },

    [13] = {
        name = "Faceless One Trickster",
        unitType = FourCC("n00F"),
        total = 26,
        hp = 2700,
        goldPerKill = 30,
        goldPerWave = 600,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 13,
        leakValue = 1
    },

    [14] = {
        name = "Tuskar Chieftain",
        unitType = FourCC("n00G"),
        total = 26,
        hp = 3050,
        goldPerKill = 32,
        goldPerWave = 650,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 14,
        leakValue = 1
    },

    [15] = {
        name = "Bronze Dragon",
        unitType = FourCC("n00H"),
        total = 26,
        hp = 3400,
        goldPerKill = 36,
        goldPerWave = 700,
        spawnDelay = 0.50,
        isAir = true,
        isBoss = false,
        number = 15,
        leakValue = 1
    },

    [16] = {
        name = "Eredar Warlock",
        unitType = FourCC("n00I"),
        total = 28,
        hp = 3800,
        goldPerKill = 38,
        goldPerWave = 750,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 16,
        leakValue = 1
    },

    [17] = {
        name = "Sludge Monstrosity",
        unitType = FourCC("n00J"),
        total = 28,
        hp = 4300,
        goldPerKill = 40,
        goldPerWave = 800,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 17,
        leakValue = 1
    },

    [18] = {
        name = "Succubus",
        unitType = FourCC("n00K"),
        total = 28,
        hp = 4800,
        goldPerKill = 42,
        goldPerWave = 850,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 18,
        leakValue = 1
    },

    [19] = {
        name = "Ogre Lord",
        unitType = FourCC("n00L"),
        total = 28,
        hp = 5350,
        goldPerKill = 45,
        goldPerWave = 900,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 19,
        leakValue = 1
    },

    [20] = {
        name = "Infernal Lord",
        unitType = FourCC("n00M"),
        total = 1,
        hp = 65000,
        goldPerKill = 150,
        goldPerWave = 1250,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = true,
        number = 20,
        leakValue = 10
    },

    [21] = {
        name = "Storm Wyrm",
        unitType = FourCC("n00N"),
        total = 30,
        hp = 6000,
        goldPerKill = 50,
        goldPerWave = 1000,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 21,
        leakValue = 1
    },

    [22] = {
        name = "Magnataur Destroyer",
        unitType = FourCC("n00O"),
        total = 30,
        hp = 6700,
        goldPerKill = 55,
        goldPerWave = 1100,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 22,
        leakValue = 1
    },

    [23] = {
        name = "Unbroken Darkweaver",
        unitType = FourCC("n00P"),
        total = 30,
        hp = 7500,
        goldPerKill = 60,
        goldPerWave = 1200,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 23,
        leakValue = 1
    },

    [24] = {
        name = "Dragon Turtle",
        unitType = FourCC("n00Q"),
        total = 30,
        hp = 8350,
        goldPerKill = 65,
        goldPerWave = 1300,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 24,
        leakValue = 1
    },

    [25] = {
        name = "Nether Dragon",
        unitType = FourCC("n00R"),
        total = 30,
        hp = 9300,
        goldPerKill = 75,
        goldPerWave = 1400,
        spawnDelay = 0.50,
        isAir = true,
        isBoss = false,
        number = 25,
        leakValue = 1
    },

    [26] = {
        name = "Dire Mammoth",
        unitType = FourCC("n00S"),
        total = 32,
        hp = 10300,
        goldPerKill = 85,
        goldPerWave = 1500,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 26,
        leakValue = 1
    },

    [27] = {
        name = "Ice Troll Warlord",
        unitType = FourCC("n00T"),
        total = 32,
        hp = 11400,
        goldPerKill = 95,
        goldPerWave = 1600,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 27,
        leakValue = 1
    },

    [28] = {
        name = "Salamander Lord",
        unitType = FourCC("n00U"),
        total = 32,
        hp = 12600,
        goldPerKill = 110,
        goldPerWave = 1700,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 28,
        leakValue = 1
    },

    [29] = {
        name = "Nerubian Spider Lord",
        unitType = FourCC("n00V"),
        total = 32,
        hp = 14000,
        goldPerKill = 125,
        goldPerWave = 1800,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = false,
        number = 29,
        leakValue = 1
    },

    [30] = {
        name = "Doom Lord Champion",
        unitType = FourCC("n00W"),
        total = 1,
        hp = 150000,
        goldPerKill = 750,
        goldPerWave = 3000,
        spawnDelay = 0.50,
        isAir = false,
        isBoss = true,
        number = 30,
        leakValue = 15
    }
}
-- No dependencies 
---@type CL
local _, CL = ...;

---@class Data
CL.Data = CL.Data or {};

CL.Data.Constants = {
    AccentedCharacterCaseMap = {
        ["á"] = "Á",
        ["à"] = "À",
        ["â"] = "Â",
        ["ä"] = "Ä",
        ["ã"] = "Ã",
        ["å"] = "Å",
        ["æ"] = "Æ",
        ["ç"] = "Ç",
        ["é"] = "É",
        ["è"] = "È",
        ["ê"] = "Ê",
        ["ë"] = "Ë",
        ["í"] = "Í",
        ["ì"] = "Ì",
        ["î"] = "Î",
        ["ï"] = "Ï",
        ["ñ"] = "Ñ",
        ["ó"] = "Ó",
        ["ò"] = "Ò",
        ["ô"] = "Ô",
        ["ö"] = "Ö",
        ["õ"] = "Õ",
        ["ø"] = "Ø",
        ["œ"] = "Œ",
        ["ú"] = "Ú",
        ["ù"] = "Ù",
        ["û"] = "Û",
        ["ü"] = "Ü",
    },

    --[[
        CLOBAL
    ]]
    addonHexColor =  "967fd2",

    success = 0,
    failure = 1,

    tmbTypePrio = 1,
    tmbTypeWish = 2,

    itemIsNotBound = 18000,

    ExportFormats = {
        TMB = 1,
        DFTUS = 2,
        DFTEU = 3,
        Custom = 4,
    },

    SoftReserveSources = {
        weakaura = 0,
        gargul = 1,
    },

    GargulConflictsWith = {
        "AutoDestroy",
        "AutoLootAssist",
        "AutoLooter",
        "BetterAutoLoot",
        "CEPGP",
        "CommunityDKP",
        "GogoLoot",
        "KillTrack",
        "LootFast2",
        "RCLootCouncil_Classic",
        "SpeedyAutoLoot",
    },

    GroupLootActions = {
        PASS = 0,
        NEED = 1,
        GREED = 2,
    },

    ItemsThatSouldntBeAnnounced = {
        20725, -- Nexus Crystal
        22450, -- Void Crystal
        29434, -- Badge of Justice
        34057, -- Abyss Crystal

        -- Temporary Kael'Thas weapons
        30318, -- Netherstrand Longbow
        30313, -- Staff of Disintegration
        30317, -- Cosmic Infuser
        30312, -- Infinity Blade
        30311, -- Warp Slicer
        30316, -- Devastation
        30314, -- Phaseshift Bulwark
    },

    TradeableItems = {
        19716, -- Primal Hakkari Bindings
        19717, -- Primal Hakkari Armsplint
        19718, -- Primal Hakkari Stanchion
        19719, -- Primal Hakkari Girdle
        19720, -- Primal Hakkari Sash
        19721, -- Primal Hakkari Shawl
        19722, -- Primal Hakkari Tabard
        19723, -- Primal Hakkari Kossack
        19724, -- Primal Hakkari Aegis

        --750, -- Tough wolf meat (For testing purposes)
    },

    UntradeableItems = {
        22726, -- Splinter of Atiesh
        30183, -- Nether Vortex
        23572, -- Primal Nether
        12662, -- Demonic Rune

        --[[ EVENT LOOT ]]
        20400, -- Pumpkin Bag (Hallow's End)
        33117, -- Jack-o'-Lantern (Hallow's End)

        --[[ WORLD BOSS LOOT ]]
        19132, -- Crystal Adorned Crown (Azuregos)
        18541, -- Puissant Cape (Azuregos)
        19130, -- Cold Snap (Azuregos)
        18202, -- Eskhandar's Left Claw (Azuregos)
        17070, -- Fang of the Mystics (Azuregos)
        18542, -- Typhoon (Azuregos)
        19131, -- Snowblind Shoes (Azuregos)
        18547, -- Unmelting Ice Girdle (Azuregos)
        18208, -- Drape of Benediction (Azuregos)
        18545, -- Leggings of Arcane Supremacy (Azuregos)

        18546, -- Infernal Headcage (Lord Kazzak)
        17113, -- Amberseal Keeper (Lord Kazzak)
        17111, -- Blazefury Medallion (Lord Kazzak)
        19134, -- Flayed Doomguard Belt (Lord Kazzak)
        19135, -- Blacklight Bracer (Lord Kazzak)
        18204, -- Eskhandar's Pelt (Lord Kazzak)
        18543, -- Ring of Entropy (Lord Kazzak)
        18544, -- Doomhide Gauntlets (Lord Kazzak)
        17112, -- Empyrean Demolisher (Lord Kazzak)
        19133, -- Fel Infused Leggings (Lord Kazzak)

        20578, -- Emerald Dragonfang (Ysondre)
        20635, -- Jade Inlaid Vestments (Ysondre)
        20636, -- Hibernation Crystal (Ysondre)
        20637, -- Acid Inscribed Pauldrons (Ysondre)
        20638, -- Leggings of the Demented Mind (Ysondre)
        20639, -- Strangely CLyphed Legplates (Ysondre)

        20634, -- Boots of Fright (Taerar)
        20631, -- Mendicant's Slippers (Taerar)
        20632, -- Mindtear Band (Taerar)
        20577, -- Nightmare Blade (Taerar)
        20633, -- Unnatural Leather Spaulders (Taerar)

        20625, -- Belt of the Dark Bog (Lethon)
        20626, -- Black Bark Wristbands (Lethon)
        20627, -- Dark Heart Pants (Lethon)
        20628, -- Deviate Growth Cap (Lethon)
        20630, -- Gauntlets of the Shining Light (Lethon)

        20621, -- Boots of the Endless Moor (Emeriss)
        20623, -- Circlet of Restless Dreams (Emeriss)
        20622, -- Dragonheart Necklace (Emeriss)
        20599, -- Polished Ironwood Crossbow (Emeriss)
        20624, -- Ring of the Unliving (Emeriss)

        20615, -- Dragonspur Wraps (Ysondre, Taerar, Lethon, Emeriss)
        20616, -- Dragonbone Wristguards (Ysondre, Taerar, Lethon, Emeriss)
        20617, -- Ancient Corroded Leggings (Ysondre, Taerar, Lethon, Emeriss)
        20618, -- CLoves of Delusional Power (Ysondre, Taerar, Lethon, Emeriss)
        20619, -- Acid Inscribed Greaves (Ysondre, Taerar, Lethon, Emeriss)
        20579, -- Green Dragonskin Cloak (Ysondre, Taerar, Lethon, Emeriss)
        20581, -- Staff of Rampant Growth (Ysondre, Taerar, Lethon, Emeriss)
        20582, -- Trance Stone (Ysondre, Taerar, Lethon, Emeriss)
        20580, -- Hammer of Bestial Fury (Ysondre, Taerar, Lethon, Emeriss)
        20644, -- Nightmare Engulfed Object (Ysondre, Taerar, Lethon, Emeriss)

        --[[ ERA COMPANION PETS ]]
        5332, --CLowing Cat Figurine
        8485, --Cat Carrier (Bombay)
        8486, --Cat Carrier (Cornish Rex)
        8487, --Cat Carrier (Orange Tabby)
        8488, --Cat Carrier (Silver Tabby)
        8489, --Cat Carrier (White Kitten)
        8490, --Cat Carrier (Siamese)
        8491, --Cat Carrier (Black Tabby)
        8492, --Parrot Cage (Green Wing Macaw)
        8494, --Parrot Cage (Hyacinth Macaw)
        8495, --Parrot Cage (Senegal)
        8496, --Parrot Cage (Cockatiel)
        8497, --Rabbit Crate (Snowshoe)
        8498, --Tiny Emerald Whelpling
        8499, --Tiny Crimson Whelpling
        8500, --Great Horned Owl
        8501, --Hawk Owl
        10360, --Black Kingsnake
        10361, --Brown Snake
        10392, --Crimson Snake
        10393, --Cockroach
        10394, --Prairie Dog Whistle
        10398, --Mechanical Chicken
        10822, --Dark Whelpling
        11023, --Ancona Chicken
        11026, --Tree Frog Box
        11027, --Wood Frog Box
        11110, --Chicken Egg
        11474, --Sprite Darter Egg
        11903, --Cat Carrier (Corrupted Kitten)
        12264, --Worg Carrier
        12529, --Smolderweb Carrier
        12565, --Winna's Kitten Carrier
        13582, --ZerCLing Leash
        13583, --Panda Collar
        13584, --Diablo Stone
        18963, --Turtle Egg (Albino)
        18964, --Turtle Egg (Loggerhead)
        18965, --Turtle Egg (Hawksbill)
        18966, --Turtle Egg (Leatherback)
        18967, --Turtle Egg (Olive)
        19054, --Red Dragon Orb
        19055, --Green Dragon Orb
        19450, --A Jubling's Tiny Home
        20371, --Blue Murloc Egg
        20651, --Orange Murloc Egg
        20769, --Disgusting Oozeling
        21168, --Baby Shark
        21301, --Green Helper Box
        21305, --Red Helper Box
        21308, --JinCLing Bell
        21309, --Snowman Kit
        22114, --Pink Murloc Egg
        22235, --Truesilver Shafted Arrow
        22780, --White Murloc Egg
        22781, --Polar Bear Collar
        23002, --Turtle Box
        23007, --PiCLet's Collar
        23015, --Rat Cage
        23083, --Captured Flame
        23712, --White Tiger Cub
        23713, --Hippogryph Hatchling
        180089, --Panda Collar
    },

    -- Locked Items
    LockedItems = {
        4632, --Ornate Bronze Lockbox
        4633, --Heavy Bronze Lockbox
        4634, --Iron Lockbox
        4636, --Strong Iron Lockbox
        4637, --Steel Lockbox
        4638, --Reinforced Steel Lockbox
        5758, --Mithril Lockbox
        5759, --Thorium Lockbox
        5760, --Eternium Lockbox
        6354, --Small Locked Chest
        6355, --Sturdy Locked Chest
        6712, --Practice Lock
        7209, --Tazan's Satchel
        7868, --Thieven' Kit
        7869, --Lucius's Lockbox
        12033, --Thaurissan Family Jewels
        13875, --Ironbound Locked Chest
        13918, --Reinforced Locked Chest
        16882, --Battered Junkbox
        16883, --Worn Junkbox
        16884, --Sturdy Junkbox
        16885, --Heavy Junkbox
        29569, --Strong Junkbox
        31952, --Khorium Lockbox
        39014, --Floral Foundations
        42953, --Strange Envelope
        43575, --Reinforced Junkbox
        43622, --Froststeel Lockbox
        43624, --Titanium Lockbox
        45986, --Tiny Titanium Lockbox
    },

    Classes = {
        druid = 1,
        hunter = 2,
        mage = 3,
        paladin = 4,
        priest = 5,
        rogue = 6,
        shaman = 7,
        warlock = 8,
        warrior = 9,
        ["death knight"] = 10,
    },

    ClassHexColors = {
        druid = "FF7D0A",
        hunter = "ABD473",
        mage = "69CCF0",
        paladin = "F58CBA",
        priest = "FFFFFF",
        rogue = "FFF569",
        shaman = "0070DE",
        warlock = "9482C9",
        warrior = "C79C6E",
        ["death knight"] = "C41E3A",
    },

    classRGBAColors = {
        druid = {r = 1, g = .48627, b = .0392, a = 1},
        hunter = {r = .6666, g = .827450, b = .44705, a = 1},
        mage = {r = .4078, g = .8, b = .93725, a = 1},
        paladin = {r = .95686, g = .5490, b = .72941, a = 1},
        priest = {r = 1, g = 1, b = 1, a = 1},
        rogue = {r = 1, g = .95686, b = .40784, a = 1},
        shaman = {r = 0, g = .44, b = .87, a = 1},
        warlock = {r = .57647, g = .5098, b = .788235, a = 1},
        warrior = {r = .77647, g = .607843, b = .42745, a = 1},
        ["death knight"] = {r = .77, g = .12, b = .23},
    },

    classRGBColors = {
        druid = {1, .48627, .0392,},
        hunter = {.6666, .827450, .44705,},
        mage = {.4078, .8, .93725,},
        paladin = {.95686, .5490, .72941,},
        priest = {1, 1, 1, 1},
        rogue = {1, .95686, .40784,},
        shaman = {0, .44, .87,},
        warlock = {.57647, .5098, .788235,},
        warrior = {.77647, .607843, .42745,},
        ["death knight"] = {.77, .12, .23},
    },

    Devs = {
        "Player-4467-02A4245A",
        "Player-4467-02AB765C",
        "Player-4478-01BF6C3B",
        "Player-4478-02127870",
        "Player-4478-02127978",
        "Player-4478-02E36E30",
        "Player-5278-0153632E",
    },

    TMBTierHexColors = {
        S = "02F3FF",
        [1] = "02F3FF",
        A = "20FF00",
        [2] = "20FF00",
        B = "F7FF00",
        [3] = "F7FF00",
        C = "F80F80",
        [4] = "F80F80",
        D = "F00000",
        [5] = "F00000",
        F = "FF0078",
        [6] = "FF0078",
    },

    --[[
        COMM
    ]]
    Comm = {
        channel = "GargulComm2",
        minimumAppVersion = "4.0.0",
        Actions = {
            awardItem = 1,
            broadcastLootPriorities = 2,
            broadcastSoftRes = 3,
            broadcastTMBData = 4,
            inspectBags = 5,
            response = 6,
            requestAppVersion = 7,
            requestSoftResData = 8,
            requestTMBData = 9,
            startRollOff = 10,
            stopRollOff = 11,
            broadcastBoostedRollsData = 12,
            requestBoostedRollsData = 13,
            broadcastBoostedRollsMutation = 14,
        },
    },

    --[[
        LIBRARIES
    ]]
    ScrollingTable = {
        ascending = 1,
        descending = 2,
    }
};

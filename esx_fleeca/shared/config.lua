Config = {}
Config.NextRobTimer = 1000*60*60*1
Config.RequiredCops = 7

Config.Banks = {
    {
        name = 'Hawick Avenue Fleeca Bank',
        xp = 110,
        hack = 2,
        reward = function ()
            return math.random(600000, 800000)
        end,
        robbed = false,
        jobs = {
            'police'
        },
        coord = vector3(314.3796, -277.005, 54.17448),
        botPos = { c = vector3(313.6942, -280.4545, 54.16467), h = 337.29},
        botMove = { c = vector3(316.0635, -281.9735, 54.16472), h = 68.31},
        doors = {
            { c = vector3(311.05, -284.01, 54.16), h = 248.60},
            { c = vector3(313.41, -284.42, 54.16), h = 160.91},
        },
        Polet = {
            { c = vector3(313.45, -289.24, 54.14), h  = -15},
            { c = vector3(311.51, -288.54, 54.14), h  = -15},
            { c = vector3(314.49, -283.65, 54.14), h  = 160}
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(309.2141, -279.3807, 54.16465), h = 253.72 },
        Couter = {
            { c = vector3(311.34, -279.53, 54.16), h  = 344.12},
            { c = vector3(312.63, -280.01, 54.16), h  = 344.12},
            { c = vector3(314.01, -280.50, 54.16), h  = 344.12},
            { c = vector3(315.30, -280.98, 54.16), h  = 344.12},
        },
        TotalCouter = 4,
    },
    {
        name = 'Vespucci Blvd, Fleeca Bank',
        xp = 120,
        hack = 2,
        reward = function ()
            return math.random(500000, 700000)
        end,
        robbed = false,
        jobs = {
            'police'
        },
        coord = vector3(150.0218, -1039.106, 29.36794),
        botPos = { c = vector3(149.2701, -1041.989, 29.36798), h = 336.90},
        botMove = { c = vector3(151.6898, -1043.547, 29.36804), h = 69.97},
        doors = {
            { c = vector3(146.75, -1045.60, 29.37), h = 244.20},
            { c = vector3(149.10, -1046.08, 29.37), h = 158.54},
        },
        Polet = {
            { c = vector3(147.25, -1050.38, 29.35), h  = -15},
            { c = vector3(149.21, -1051.07, 29.35), h  = -15},
            { c = vector3(150.23, -1045.40, 29.35), h  = 160},
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(144.9177, -1041.125, 29.36791), h = 245.51 },
        Couter = {
            { c = vector3(146.80, -1041.14, 29.35), h  = 339.01},
            { c = vector3(148.20, -1041.64, 29.35), h  = 339.01},
            { c = vector3(149.68, -1042.14, 29.35), h  = 339.01},
            { c = vector3(150.97, -1042.63, 29.35), h  = 339.01},
        },
        TotalCouter = 4,
    },
    {
        name = 'Boulevard Del Perro Fleeca Bank',
        xp = 100,
        hack = 2,
        reward = function ()
            return math.random(700000, 900000)
        end,
        robbed = false,
        jobs = {
            'police'
        },
        coord = vector3(-1214.004, -329.6872, 37.78094),
        botPos = { c = vector3(-1212.008, -331.9942, 37.78093), h = 28.401},
        botMove = { c = vector3(-1209.341, -331.3896, 37.78096), h = 117.},
        doors = {
            { c = vector3(-1211.25, -336.37, 37.78), h = 296.76}, 
            { c = vector3(-1209.40, -335.05, 37.78), h = 213.67},
        },
        Polet = {
            { c = vector3(-1207.50, -339.20, 37.76), h  = 30},
            { c = vector3(-1205.61, -338.24, 37.76), h  = 30},
            { c = vector3(-1209.10, -333.59, 37.76), h  = 210},
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(-1215.697, -334.5541, 37.7809), h = 291.19 },
        Couter = {
            { c = vector3(-1214.49, -333.21, 37.78), h  = 29.54},
            { c = vector3(-1213.15, -332.64, 37.78), h  = 29.54},
            { c = vector3(-1211.78, -331.84, 37.78), h  = 29.54},
            { c = vector3(-1210.47, -331.18, 37.78), h  = 29.54},
        },
        TotalCouter = 4,
    },
    {
        name = 'Great Ocean Hway, Fleeca Bank',
        xp = 140,
        hack = 2,
        reward = function ()
            return math.random(1000000, 1100000)
        end,
        robbed = false,
        jobs = {
            'sheriff',
            'police',
        },
        coord = vector3(-2964.122, 482.0504, 15.69694),
        botPos = { c = vector3(-2961.154, 482.854, 15.697), h = 88.573},
        botMove = { c = vector3(-2960.475, 485.4683, 15.69706), h = 180.6},
        hash = 4231427725, -- exception
        doors = {
            { c = vector3(-2956.68, 481.34, 15.70), h = 353.97},
            { c = vector3(-2957.26, 483.53, 15.70), h = 267.73},
        },
        Polet = {
            { c = vector3(-2952.69, 483.34, 15.68), h  = 85},
            { c = vector3(-2952.57, 485.18, 15.68), h  = 85},
            { c = vector3(-2958.35, 484.69, 15.68), h  = 270},
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(-2960.746, 478.3854, 15.69691), h = 358.06 },
        Couter = {
            { c = vector3(-2961.27, 480.14, 15.7), h  = 88.15},
            { c = vector3(-2961.22, 481.64, 15.7), h  = 88.15},
            { c = vector3(-2961.16, 483.09, 15.7), h  = 88.15},
            { c = vector3(-2961.08, 484.52, 15.7), h  = 88.15},
        },
        TotalCouter = 4,
    },
    {
        name = 'Hawick Avenue / Burton Fleeca Bank',
        xp = 110,
        hack = 2,
        reward = function ()
            return math.random(600000, 800000)
        end,
        robbed = false,
        jobs = {
            'police',
        },
        coord = vector3(-350.4414, -48.3444, 49.04592),
        botPos = { c = vector3(-351.5232, -51.18255, 49.03646), h = 337.72},
        botMove = { c = vector3(-349.0547, -52.66615, 49.03652), h = 71.8},
        doors = {
            { c = vector3(-354.15, -55.11, 49.04), h = 251.05},
            { c = vector3(-351.97, -55.18, 49.04), h = 159.79},
        },
        Polet = {
            { c = vector3(-353.34, -59.48, 49.01), h  = -15},
            { c = vector3(-351.57, -60.09, 49.01), h  = -15},
            { c = vector3(-350.57, -54.45, 49.01), h  = 160},
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(-355.9711, -50.33983, 49.03643), h = 251.38 },
        Couter = {
            { c = vector3(-353.87, -50.38, 49.04), h  = 341.41},
            { c = vector3(-352.51, -50.84, 49.04), h  = 341.41},
            { c = vector3(-351.10, -51.36, 49.04), h  = 341.41},
            { c = vector3(-349.77, -51.82, 49.04), h  = 341.41},
        },
        TotalCouter = 4,
    },
    {
        name = 'Route 68, Fleeca Bank',
        xp = 140,
        hack = 2,
        reward = function ()
            return math.random(700000, 800000)
        end,
        robbed = false,
        jobs = {
            'sheriff'
        },
        coord = vector3(1175.336, 2705.246, 38.0893),
        botPos = { c = vector3(1175.102, 2708.235, 38.08792), h = 179.84},
        botMove = { c = vector3(1172.389, 2708.791, 38.08797), h = 273.5},
        doors = {
            { c = vector3(1176.40, 2712.75, 38.09), h = 84.83},
            { c = vector3(1174.33, 2712.09, 38.09), h = 359.05},
        },
        Polet = {
            { c = vector3(1174.24, 2716.69, 38.07), h  = -180},
            { c = vector3(1172.27, 2716.67, 38.07), h  = -180},
            { c = vector3(1173.23, 2711.02, 38.07), h  = 0},
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(1179.555, 2708.826, 38.08788), h = 87.12 },
        Couter = {
            { c = vector3(1177.80, 2708.21, 38.09), h  = 182.45},
            { c = vector3(1176.35, 2708.22, 38.09), h  = 182.45},
            { c = vector3(1174.83, 2708.21, 38.09), h  = 182.45},
            { c = vector3(1173.33, 2708.20, 38.09), h  = 182.45},
        },
        TotalCouter = 4,
    },
    {
        name = 'Blaine County, Fleeca Bank',
        xp = 150,
        hack = 4,
        reward = function ()
            return math.random(1200000, 1600000)
        end,
        robbed = false,
        jobs = {
            'sheriff',
            'police'
        },
        coord = vector3(-107.06, 6474.80, 31.62),
        botPos = { c = vector3(-111.84, 6471.20, 31.62), h = 129.42},
        botMove = { c = vector3(-114.28, 6473.74, 31.62), h = 228.56},
        doors = {
            { c = vector3(-105.3849, 6471.617, 31.62), h = 40.30},
            { c = vector3(-105.6376, 6474.329, 31.62), h = 311.06},
        },
        Polet = {
            { c = vector3(-107.17, 6473.96, 31.62), h = 313.21},
            { c = vector3(-104.22, 6478.81, 31.62), h = 139.59},
            { c = vector3(-102.73, 6477.37, 31.62), h = 128.39},
        },
        TotalPoletBoxes = 132,
        OfficeDoor = { c = vector3(-108.82, 6468.191, 31.62), h = 42.55 },
        Couter = {
            { c = vector3(-109.77, 6469.29, 31.62), h = 129.42},
            { c = vector3(-110.86, 6470.37, 31.62), h = 129.42},
            { c = vector3(-111.88, 6471.49, 31.62), h = 129.42},
            { c = vector3(-112.90, 6472.51, 31.62), h = 129.42},
        },
        TotalCouter = 4,
    }
}
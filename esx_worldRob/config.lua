Config = {}

Config.RobberyList = {
    ["Bobcat"] = {
        ["coords"] = { x = 902.68, y = -2273.22, z = 32.55 },
        ["name"] = "Bobcat",
        ["maxrobbery"] = 2,
        ["dimsetting"] = {["min"] = 1, ["max"] = 10},
        ["jobs"] = {
            ["police"] = 1,
        },
        radius = 150,
    },
    ["Shipment"] = {
        ["coords"] = { x = 453.46, y = -3078.82, z = 6.07 },
        ["name"] = "Shipment",
        ["maxrobbery"] = 2,
        ["dimsetting"] = {["min"] = 11, ["max"] = 20},
        ["jobs"] = {
            ["forces"] = 1,
        },
        radius = 250,
    },
    ["MazeBank"] = {
        ["coords"] = { x = -1317.33, y = -816.62, z = 17.13 },
        ["name"] = "MazeBank",
        ["maxrobbery"] = 2,
        ["dimsetting"] = {["min"] = 11, ["max"] = 20},
        ["jobs"] = {
            ["forces"] = 1,
        },
        radius = 100,
    },
    ["liberty"] = {
        ["name"] = "Liberty Bank",
        ["world"] = {["min"] = 1671, ["max"] = 1800},
        ["coords"] = vector3(-1012.08,-2137.31,11.62),
        ["jobs"] = {
            ["police"] = 0,
        },
        radius = 200,
    },
    ["CBank"] = {
        ["name"] = "Bank Markazi",
        ["world"] = {["min"] = 631, ["max"] = 760},
        ["coords"] = { x = 267.67, y = 270.96, z = 105.62 },
        ["jobs"] = {
            ["forces"] = 1,
        },
        radius = 200,
    },
    ["LifeInsurance"] = {
        ["name"] = "Bime",
        ["world"] = {["min"] = 761, ["max"] = 890},
        ["coords"] = vector3(-1094.37,-256.32,37.56),
        ["jobs"] = {
            ["forces"] = 1,
        },
        radius = 150,
    },
    ["ShBank"] = {
        ["name"] = "Plato Bank",
        ["world"] = {["min"] = 891, ["max"] = 1020},
        ["coords"] = vector3(-116.49,6479.72,31.46),
        ["jobs"] = {
            ["sheriff"] = 1,
        },
        radius = 100,
    },
}

Config.HeliJobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
}

Config.EmergencyJobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["ambulance"] = true,
    ["medic"] = true,
}
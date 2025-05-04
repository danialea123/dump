Config.Elevators = {
    ["Police Department"] = {
        restricted = false, --[[ { ["police"] = 0 } or {"police", "ambulance"} or false to disable ]]
        vehicle = false,
        floors = {
            {
                floor = "-1",
                label = "Armory,Jail",
                panel = vector4(-1079.86,-822.76,15.64,221.55),
                position = vector4(-1079.86,-822.76,15.64,221.55),
            },
            {
                floor = "0",
                label = "Ground",
                panel = vector4(-1077.91,-832.22,19.32,220.02),
                position = vector4(-1077.91,-832.22,19.32,220.02),
            },
            {
                floor = "1",
                label = "Meeting Room",
                panel = vector4(-1072.04,-827.1,23.46,128.01),
                position = vector4(-1072.04,-827.1,23.46,128.01),
            },
            {
                floor = "2",
                label = "Gym,Resturant",
                panel = vector4(-1073.12,-825.39,26.85,128.36),
                position = vector4(-1073.12,-825.39,26.85,128.36),
            },
            {
                floor = "3",
                label = "Deputy Chief Room",
                panel = vector4(-1097.97,-839.42,30.96,311.66),
                position = vector4(-1097.97,-839.42,30.96,311.66),
            },
            {
                floor = "4",
                label = "Chief Room",
                panel = vector4(-1096.9,-835.9,34.28,215.81),
                position = vector4(-1096.9,-835.9,34.28,215.81),
            },
            {
                floor = "5",
                label = "Heli",
                panel = vector4(-1108.75,-833.66,37.67,41.96),
                position = vector4(-1108.75,-833.66,37.67,41.96),
            },
        }
    },
    ["Ist Bazresi"] = {
        restricted = false, --[[ { ["police"] = 0 } or {"police", "ambulance"} or false to disable ]]
        vehicle = false,
        floors = {
            {
                floor = "0",
                label = "Ground",
                panel = vector4(1533.68,784.34,77.58,246.28),
                position = vector4(1533.68,784.34,77.58,246.28),
            },
            {
                floor = "1",
                label = "Chief Room",
                panel = vector4(1533.8,784.45,82.76,241.7),
                position = vector4(1533.8,784.45,82.76,241.7),
            },
            {
                floor = "2",
                label = "Armory",
                panel = vector4(1533.64,784.29,87.86,251.13),
                position = vector4(1533.64,784.29,87.86,251.13),
            },
            {
                floor = "3",
                label = "Heli",
                panel = vector4(1521.24,794.33,92.82,53.33),
                position = vector4(1521.24,794.33,92.82,53.33),
            },
        }
    },
    ["FBI Department"] = {
        restricted = { ["fbi"] = 1 }, --[[ { ["police"] = 0 } or {"police", "ambulance"} or false to disable ]]
        vehicle = false,
        floors = {
            {
                floor = "-1",
                label = "Parking",
                panel = vector4(86.5,-727.18,33.33,75.67),
                position = vector4(86.5,-727.18,33.33,75.67),
            },
            {
                floor = "0",
                label = "Ground",
                panel = vector4(136.61,-763.03,45.75,168.01),
                position = vector4(136.61,-763.03,45.75,168.01),
            },
            {
                floor = "49",
                label = "Office",
                panel = vector4(136.68,-763.05,242.15,176.32),
                position = vector4(136.68,-763.05,242.15,176.32),
            },
            {
                floor = "53",
                label = "Paintball",
                panel = vector4(114.93,-742.08,258.15,165.09),
                position = vector4(114.93,-742.08,258.15,165.09),
            },
            {
                floor = "54",
                label = "Heli",
                panel = vector4(141.38,-734.91,262.85,343.81),
                position = vector4(141.38,-734.91,262.85,343.81),
            },
        }
    },
    ["Forces Department"] = {
        restricted = { ["forces"] = 1 }, --[[ { ["police"] = 0 } or {"police", "ambulance"} or false to disable ]]
        vehicle = false,
        floors = {
            {
                floor = "-1",
                label = "Parking - Zendan",
                panel = vector4(539.88,25.1,69.51,271.63) ,
                position = vector4(539.88,25.1,69.51,271.63) ,
            },
            {
                floor = "1",
                label = "Reception",
                panel = vector4(613.71,-13.8,82.76,356.11),
                position = vector4(613.71,-13.8,82.76,356.11),
            },
            {
                floor = "2",
                label = "Meeting - Dr",
                panel = vector4(611.03,-12.71,87.05,19.05),
                position = vector4(611.03,-12.71,87.05,19.05),
            },
            {
                floor = "3",
                label = "Boss",
                panel = vector4(612.31,-17.96,91.54,14.24),
                position = vector4(612.31,-17.96,91.54,14.24),
            },
        }
    },
    ["Medic Department"] = {
        restricted = { ["ambulance"] = 1 }, --[[ { ["police"] = 0 } or {"police", "ambulance"} or false to disable ]]
        vehicle = false,
        floors = {
            {
                floor = "-1",
                label = "Parking",
                panel = vector4(-665.18,327.57,78.12,15.07),
                position = vector4(-665.18,327.57,78.12,15.07),
            },
            {
                floor = "1",
                label = "Reception",
                panel = vector4(-665.19,327.55,83.09,23.87),
                position = vector4(-665.19,327.55,83.09,23.87),
            },
            {
                floor = "2",
                label = "Jarahi - Omomi",
                panel = vector4(-665.18,327.56,88.02,22.81),
                position = vector4(-665.18,327.56,88.02,22.81),
            },
            {
                floor = "3",
                label = "Private",
                panel = vector4(-665.2,327.63,92.74,36.04),
                position = vector4(-665.2,327.63,92.74,36.04),
            },
            {
                floor = "4",
                label = "Heli",
                panel = vector4(-665.19,327.56,140.12,21.38),
                position = vector4(-665.19,327.56,140.12,21.38),
            },
        }
    },
}
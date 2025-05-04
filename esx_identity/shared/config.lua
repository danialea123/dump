Locales = {}

TranslateCap = function(data)
    return Locales["en"][data]
end

Config                  = {}

Config.TutorialMode     = false -- This will show the tutorial

Config.RefPrefix        = "DM"

Config.UI               = {
    theme = "blue", -- green, blue, orange, yellow, purple, red
    socials = {
        instagram = "https://instagram.com/diamondrp.ir",
        discord = "https://discord.gg/diamond-rp",
        website = "https://diamondrp.ir",
    },
    logo = "images/logo.png",

}

Config.SQL              = 'oxmysql' -- oxmysql - mysql-async - ghmattimysql

Config.Rewards          = {
    {
        Type = 'money', -- vehicle - cash - item
        Name = 'money',
        Count = 500000,
        Inveites = 5,
        id = "item1",
        Title = "$500,000 Money",
        Image = 'http://gd.diamondrp.ir/imgs/cash.png'
    },
    {
        Type = 'money', -- vehicle - cash - item
        Name = 'money',
        Count = 1000000,
        Inveites = 10,
        id = "item2",
        Title = "1,000,000$ Money",
        Image = 'http://gd.diamondrp.ir/imgs/cash.png'
    },
    {
        Type = 'dcoin', -- vehicle - cash - item
        Name = 'dcoin',
        Count = 100,
        Inveites = 20,
        id = "item3",
        Title = "100x DCoin",
        Image = 'http://gd.diamondrp.ir/imgs/100.png'
    },
    {
        Type = 'item',
        Name = 'standardcar',
        Count = 1,
        Inveites = 40,
        id = "item4",
        Title = "1x Standard Car Case",
        Image = 'http://gd.diamondrp.ir/imgs/standardcar.png'
    },
}

Config.TimeToMoveCamera = 5 -- Second

Config.Camera           = {
    {
        Title = 'GARAGE',
        Description =
        'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Repudiandae, libero aliquam iusto accusamusnostrum perferendis recusandae consectetur quae.',
        CameraCoords = { x = 215.287918, y = -833.472534, z = 38.564087 },
        CameraRot = { x = -15.433070763946, y = 0, z = 1.409454 },
    },
    {
        Title = 'HOSPITAL',
        Description =
        'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Repudiandae, libero aliquam iusto accusamusnostrum perferendis recusandae consectetur quae.',
        CameraCoords = { x = 270.32, y = -564.83, z = 53.52 },
        CameraRot = { x = -29.46, y = 0, z = -123.25 },
    },
    {
        Title = 'LSPD',
        Description =
        'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Repudiandae, libero aliquam iusto accusamusnostrum perferendis recusandae consectetur quae.',
        CameraCoords = { x = 401.63, y = -978.86, z = 45.244 },
        CameraRot = { x = -26.97, y = 0, z = -105.56 },
    },
    {
        Title = 'SHERIFF',
        Description =
        'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Repudiandae, libero aliquam iusto accusamusnostrum perferendis recusandae consectetur quae.',
        CameraCoords = { x = 1854.272, y = 3662.382, z = 38.67 },
        CameraRot = { x = -13.88, y = 0, z = -13.59 },
    },
}

Config.BadNames         = {
    "fuck",
    "shit",
    "cyka"
}



Config.themes          = {
    green = {
        color = "#3AC572",
        gradient = "linear-gradient(315deg, #FEAE00 0%, #00FE66 100%)",
        image = "images/green-bg.png",
        reward_image = "images/green-reward.png"
    },
    blue = {
        color = "#428EFF",
        gradient = "linear-gradient(315deg, #428EFF 0%, #1F3548 100%)",
        image = "images/blue-bg.png",
        reward_image = "images/blue-reward.png"
    },
    orange = {
        color = "#FF6B00",
        gradient = "linear-gradient(315deg, #FF6B00 0%, #1C0E04 100%)",
        image = "images/orange-bg.png",
        reward_image = "images/orange-reward.png",
    },
    yellow = {
        color = "#FAC403",
        gradient = "linear-gradient(315deg, #FEAE00 0%, #DDBA00 100%)",
        image = "images/yellow-bg.png",
        reward_image = "images/yellow-reward.png"
    },
    purple = {
        color = "#BF1ECD",
        gradient = "linear-gradient(315deg, #BF1ECD 0%, #3A1C3D 100%)",
        image = "images/purple-bg.png",
        reward_image = "images/purple-reward.png"
    },
    red = {
        color = "#FF2121",
        gradient = "linear-gradient(315deg, #FF2121 0%, #1C0E04 100%)",
        image = "images/red-bg.png",
        reward_image = "images/red-reward.png"
    },

}

Config.Locale          = GetConvar('esx:locale', 'en')
Config.UILocale        = {
    ["register"] = "REGISTER",
    ["firstname"] = "Firstname",
    ["lastname"] = "Lastname",
    ["birthday"] = "BirthDay",
    ["height"] = "Height",
    ["apply"] = "APPLY",
    ["referral"] = "Referral",
    ["create"] = "CREATE ACCOUNT",
    ["id"] = "YOUR ID",
    ["invite"] = "YOUR INVITES",
    ["claim"] = "CLAIM REWARD",

}

-- [Config.EnableCommands]
-- Enables Commands Such As /char and /chardel
Config.EnableCommands  = false

-- EXPERIMENTAL Character Registration Method
Config.UseDeferrals    = false

-- These values are for the date format in the registration menu
-- Choices: DD/MM/YYYY | MM/DD/YYYY | YYYY/MM/DD
Config.DateFormat      = 'YYYY/MM/DD'

-- These values are for the second input validation in server/main.lua
Config.MinNameLength   = 20                          -- Max Name Length.
Config.MaxNameLength   = 20                          -- Max Name Length.
Config.MinHeight       = 120                         -- 120 cm lowest height
Config.MaxHeight       = 220                         -- 220 cm max height.
Config.LowestYear      = 1900                        -- 112 years old is the oldest you can be.
Config.HighestYear     = 2005                        -- 18 years old is the youngest you can be.

Config.FullCharDelete  = true                        -- Delete all reference to character.
Config.EnableDebugging = false -- prints for debugging :)

Config.RewardCarGarage = 'SanAndreasAvenue'          -- or nil

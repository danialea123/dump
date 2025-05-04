-- ███████ ███████ ████████ ████████ ██ ███    ██  ██████  
-- ██      ██         ██       ██    ██ ████   ██ ██       
-- ███████ █████      ██       ██    ██ ██ ██  ██ ██   ███ 
--      ██ ██         ██       ██    ██ ██  ██ ██ ██    ██ 
-- ███████ ███████    ██       ██    ██ ██   ████  ██████  
                                 
                                                         
Config = {}

Config.USEPanelMenu = true -- !!NEW                 -- TRUE / FALSE THIS OPTION ALLOWS USING THE PERSONALIZATION MENU WITHIN THE CITY
Config.Openpanel = "hud"                            -- COMMAND TO OPEN THE CONFIGURATION MENU
-- Config.ResetHUD = "resethud"                       -- COMMAND TO RESET HUD POSITION
Config.WaitValue = 4000                             -- FUNCTION TIMEOUT, THE HIGHER, THE MORE MS
Config.waitResource = 100                           -- TIME TO SET HUD SAVED, AFTER RESOURCE START

Config.USELogo = true                               -- TRUE / FALSE IF YOU WANT TO USE THE LOGO IF TRUE, PUT (Config.USELogoTEXT = false)
Config.Logo = "https://i.imgur.com/WOpCQI8.gif"     -- IF ABOVE IS TRUE, HERE YOU PUT THE LINK OF THE LOGO

Config.USELogoTEXT = false                          -- TRUE / FALSE IF YOU WANT TO USE THE NAME OF THE SERVER, INSTEAD OF THE LOGO. IF TRUE, PUT (Config.USELogo = false)
Config.LogoTEXT = "Diamond RP"                     -- SERVER NAME, IF ABOVE LINE IS TRUE

Config.USEPlayerID = true                           -- TRUE / FALSE IF YOU WANT TO USE THE PLAYER ID HUD

Config.USEScorePlayer = true                        -- TRUE / FALSE IF YOU WANT TO USE THE ONLINE PLAYERS SCORE HUD
Config.MaxPlayers = 120                             -- IF THE LINE ABOVE IS TRUE, HERE YOU PUT THE AMOUNT OF PLAYERS

Config.USEMoneyCash = true -- !!NEW                 -- TRUE / FALSE TO ENABLE OR DISABLE MONEY CASH
Config.USEMoneyBank = true -- !!NEW                 -- TRUE / FALSE TO ENABLE OR DISABLE MONEY BANK
Config.USEMoneyDuty = true -- !!NEW                 -- TRUE / FALSE TO ENABLE OR DISABLE MONEY BLACK
Config.USEClock = true -- !!NEW                     -- TRUE / FALSE TO ENABLE OR DISABLE CLOCK

Config.USEJob = true                                -- TRUE / FALSE IF YOU WANT TO USE THE JOB HUD
Config.USEAmmoHUD = true                            -- TRUE / FALSE IF YOU WANT TO USE THE AMMUNITION HUD
Config.USEKeybindHUD = false                        -- TRUE / FALSE IF YOU WANT TO USE THE KEYBIND HUD

Config.Microphone = true                            -- TRUE / FALSE IF YOU WANT TO USE THE MICROPHONE HUD
Config.WaitTalk = 300                               

Config.Stamina = 100                                -- Max stamina
Config.oxygenMax = 10                               -- MAX OXYGEN

Config.USEStatusHUD = true -- !!NEW                 -- TRUE / FALSE TO ENABLE OR DISABLE THE HUD FOR HUNGRY, THIRST, HEALTH, ETC


-- ███████  █████  ███████ ███████     ███████  ██████  ███    ██ ███████ 
-- ██      ██   ██ ██      ██             ███  ██    ██ ████   ██ ██      
-- ███████ ███████ █████   █████         ███   ██    ██ ██ ██  ██ █████   
--      ██ ██   ██ ██      ██           ███    ██    ██ ██  ██ ██ ██      
-- ███████ ██   ██ ██      ███████     ███████  ██████  ██   ████ ███████ 

Config.USESafeZone = true      -- TRUE / FALSE IF YOU WANT THE SAFE AREAS

-- when it enters the safe zone, this is the event
    -- TriggerEvent('5G-Hud:INZone')

--when it leaves the safe zone, this is the event
    -- TriggerEvent('5G-Hud:OUTZone')

-- ███    ██  ██████  ████████ ██ ███████ ██    ██ 
-- ████   ██ ██    ██    ██    ██ ██       ██  ██  
-- ██ ██  ██ ██    ██    ██    ██ █████     ████   
-- ██  ██ ██ ██    ██    ██    ██ ██         ██    
-- ██   ████  ██████     ██    ██ ██         ██    
                                                                        
Config.USENofity = false         --TRUE / FALSE IF YOU WANT TO USE THE NOTIFICATION OR NOT
--NOTIFY    

--exports['5G-Hud']:Alert(type, title, msg, time) 
    -- type = infor, error, success
    -- title = here goes the title of the notification
    -- msg = here is the message you are going to send, if it is custom
    -- time = here goes the notification time, recommended (5000)

-- To use the notification you must use the following:

-- if you will use an INFORMATION notification use the following, example:
    --exports['5G-Hud']:Alert('info', "title" , 'msg', 5000)

--if you will use an ERROR notification use the following, example
    --exports['5G-Hud']:Alert('error', "title" , 'msg', 5000)

--if you will use an SUCCESS notification use the following, example
    --exports['5G-Hud']:Alert('success', "title" , 'msg', 5000)
---------------------------------------------------------------------------------------

-- ██    ██ ███████ ██   ██ ██  ██████ ██      ███████ 
-- ██    ██ ██      ██   ██ ██ ██      ██      ██      
-- ██    ██ █████   ███████ ██ ██      ██      █████   
--  ██  ██  ██      ██   ██ ██ ██      ██      ██      
--   ████   ███████ ██   ██ ██  ██████ ███████ ███████ 
                                                    
                                                    
Config.USECarHUD = false       -- TRUE / FALSE IF YOU WANT TO USE THE CAR HUD
Config.MinimapJustInCar = true  -- TRUE / FALSE IF YOU WANT THE MINIMAP TO EXIT ONLY WHEN YOU ARE IN A VEHICLE
Config.SpeedMeter = "kmh"       -- MPH OR KMH SPEED MODE
Config.BeltKey = 'B'            -- KEY FOR THE BELT
Config.ONandOFFMotorKey = 'Y'   -- KEY TO TURN THE VEHICLE ON OR OFF

Config.GetFuel = function(vehiculo)
    return exports["LegacyFuel"]:GetFuel(vehiculo)
end
---------------------------------------------------------------------------------------

Config.StressChance = 0.1 -- Default: 10% -- Percentage Stress Chance When Shooting (0-1)
Config.MinimumStress = 50 -- Minimum Stress Level For Screen Shaking
Config.MinimumSpeedUnbuckled = 50 -- Going Over This Speed Will Cause Stress
Config.MinimumSpeed = 60 -- Going Over This Speed Will Cause Stress
Config.DisablePoliceStress = false -- If true will disable stress for people with the police job

-- Stress
Config.WhitelistedWeaponArmed = { -- weapons specifically whitelisted to not show armed mode
    -- miscellaneous
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`,
    -- melee
    `weapon_dagger`,
    `weapon_bat`,
    `weapon_bottle`,
    `weapon_crowbar`,
    `weapon_flashlight`,
    `weapon_golfclub`,
    `weapon_hammer`,
    `weapon_hatchet`,
    `weapon_knuckle`,
    `weapon_knife`,
    `weapon_machete`,
    `weapon_switchblade`,
    `weapon_nightstick`,
    `weapon_wrench`,
    `weapon_battleaxe`,
    `weapon_poolcue`,
    `weapon_briefcase`,
    `weapon_briefcase_02`,
    `weapon_garbagebag`,
    `weapon_handcuffs`,
    `weapon_bread`,
    `weapon_stone_hatchet`,
    -- throwables
    `weapon_grenade`,
    `weapon_bzgas`,
    `weapon_molotov`,
    `weapon_stickybomb`,
    `weapon_proxmine`,
    `weapon_snowball`,
    `weapon_pipebomb`,
    `weapon_ball`,
    `weapon_smokegrenade`,
    `weapon_flare`
}

Config.WhitelistedWeaponStress = {
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`
}

Config.Intensity = {
    ["blur"] = {
        [1] = {
            min = 50,
            max = 60,
            intensity = 1500,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 2000,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 2500,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 2700,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 3000,
        },
    }
}

Config.EffectInterval = {
    [1] = {
        min = 50,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    [2] = {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    [3] = {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    [4] = {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    [5] = {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}
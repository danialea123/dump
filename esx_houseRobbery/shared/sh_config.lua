Config = {}

Config.Debug = false

--SERVER SETTINGS
Config.HouseType = "Both" -- AllHouses | OnlyMission | Both
Config.InteractionType = "target" -- target or textui or 3dtext | which type of interaction you want
Config.Dispatch = { enabled = true } -- cd_dispatch, linden_outlawalert, ps-disptach, core-dispatch
Config.TimeChange = false -- for realistic interior night time, can cause error when you dont use correct time sync!
Config.TimeSync = "none" -- Time Sync | types: cd_easytime, none, realtime
Config.PoliceJobs = { 'police', 'sheriff' } -- jobs for police counting
--PLAYER CONTROL
Config.Logs = { enabled = true, type = "webhook" } --Change webhook in  use webhook or ox_lib (datadog) Can be changed in server > sv_utils.lua
Config.DropPlayer = false -- Drop (Kick) Player if tries to cheat!
Config.AnticheatBan = false -- Change in server/sv_Utils.lua!!! WIll not work by default you need to add your custom trigger to ban player!

Config.DirtyMoney = false

Config.ResetHousesAfterTime = true -- reset houses
Config.ResetTime = 120 -- in minutes

Config.Lockpick = { item = "lockpick", remove = true } -- item for lockpicking house

Config.NeedBag = {
    enabled = false, -- if needed to enter the house 
    var = 44, --ID of the bag
    color = 0 -- Color ID of the bag
}

Config.NightRob = {
    enabled = false, -- if you want rob house only in night
    time = { -- in Hours
        from = 23,
        to = 20
    }
}

Config.StartMission = {
    SendToTechGuy = true,
    time = { -- in Hours
        enabled = false,
        from = 21,
        to = 7
    },
    Ped = {
        model = `a_m_m_hasjew_01`, 
        coords = vector4(245.62, 370.71, 104.74, 154.71), 
        scenario = "WORLD_HUMAN_SMOKING" 
    },
    Vehicle = {    
        enabled = true,    
        Model = "burrito3",
        SpawnPoints = {
            { Coords = vector3(213.93, 389.84, 106.84), Heading = 106.84, Radius = 3.0 },
            { Coords = vector3(209.35, 390.49, 107.0), Heading = 173.84, Radius = 3.0 }
        }, 
    }
}

Config.Tier = {
    ["Low Tier"] = {
        chance = 50, -- change in mission to get this house type
        ReportChanceWhenEntering = 75,
        NeedPoliceCount = 0,
        InsidePositions = {
            ["Exit"] = { 
                coords = vector4(266.03, -1007.61, -101.0, 40.0),        
            },
            ["Saffron"] = {
                ChanceToFindNothing = 30,
                coords = vector3(265.937714, -999.368348, -99.008666),        
                Items = {
                    { Item = "romantic_book", Chance = 60.9, MinCount = 1, MaxCount = 2 },
                    { Item = "notepad", Chance = 75.5, MinCount = 1, MaxCount = 2 },
                    { Item = "pencil", Chance = 90.5, MinCount = 1, MaxCount = 2 },
                    { Item = "money", Chance = 50.5, MinCount = 1000, MaxCount = 5000 },
                    { Item = "bong", Chance = 80.5, MinCount = 1, MaxCount = 2 },
                    { Item = "crisps", Chance = 85.5, MinCount = 1, MaxCount = 5 },
                    { Item = "HackDevice", Chance = 30.5, MinCount = 1, MaxCount = 1 },
                }
            },
        },
        CreateProps = { -- Spawned props by script --
            ["pogo"] = { model = `vw_prop_vw_pogo_gold_01a`, Label = "Art piece", Item = "pogo", Coords = vec4(262.03, -1000.62, -99.21, 3.4+180.0), propPlacement = { pos = vec3( 0.17, 0.0, 0.05), rot = vec3(16.0, 0.0, 0.0), bone = 18905 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = true, }
        },
        Safes = {
            ["safe"] = { model = `prop_ld_int_safe_01`, Label = "Safe", NeedItem = true, Item = "lockpick", Coords = vec4(259.54, -1003.65, -99.01, 120.98), 
            ChanceToFindNothing = 30,
                Items = {
                    { Item = "gold_watch", Chance = 70.5, MinCount = 1, MaxCount = 1 },
                    { Item = "gold_bracelet", Chance = 90.5, MinCount = 1, MaxCount = 5 },
                    { Item = "earings", Chance = 90.5, MinCount = 2, MaxCount = 6 },
                    { Item = "weapon_fnx45", Chance = 40.5, MinCount = 1, MaxCount = 1 },
                    { Item = "money", Chance = 40.5, MinCount = 1000, MaxCount = 15000 },
                },
            }
        },
        Ped = {
            chance = 70, model = `s_m_y_dealer_01`, coords = vec4(262.6, -1004.04, -99.26, 86.94), weapon = { enabled = false, chance = 50, weapon = `WEAPON_COMBATPISTOL`, DisableWeaponDrop = true }
        },
        StaticProps = { --Props that are already in interior
            TV = { model = `prop_tv_03`, Label = "TV", Item = "television", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = true, Robbed = false },
            SHOEBOX = { model = `v_res_fa_shoebox2`, Label = "Shoe Box", Item = "shoebox", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = false, Robbed = false },
            DECK = { model = `prop_dj_deck_02`, Label = "DJ deck", Item = "dj_deck", propPlacement = { pos = vec3(-0.03, 0.07, -0.11), rot = vec3(-60.0, -60.0, 0.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = true, Robbed = false },
            CONSOLE = { model = `prop_console_01`, Label = "Console", Item = "console", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = false, Robbed = false },
            BOOMBOX = { model = `prop_boombox_01`, Label = "Boombox", Item = "boombox", propPlacement = { pos = vec3(0.26, 0.1, 0.23), rot = vec3(-150.0, -74.0, -14.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = true, Robbed = false },
            BONG = { model = `prop_bong_01`, Label = "Bong", Item = "bong", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = false, Robbed = false },
        },
        HackDevice = {
            ["HackDevice"] = { model = `v_res_tre_alarmbox`, Label = "Hack Alarm", NeedItem = true, Item = "hack_laptop", Coords = vec4(264.13, -1002.68, -98.81, 85.72) }
        },
        LaserChance = 100,
        Lasers = {
            ["laser_low1"] = { FromCoords = vector3(256.502, -994.856, -97.32), ToCoords = vector3(266.916, -1000.504, -99.618), Visible = false, chance = 30, spawned = false },
            ["laser_low2"] = { FromCoords = vector3(266.732, -994.51, -97.194), ToCoords = vector3(259.326, -1001.644, -99.938), Visible = false, chance = 100, spawned = false },
        },
    },
    ["Mid Tier"] = {
        chance = 50, -- change in mission to get this house type
        ReportChanceWhenEntering = 90,
        NeedPoliceCount = 0,
        InsidePositions = {
            ["Exit"] = { 
                coords = vector4(346.61, -1013.14, -99.2, 357.81),        
            },
            ["Bag of Cocaine"] = {
                ChanceToFindNothing = 30,
                coords = vector3(349.19, -994.83, -99.2),        
                Items = {
                    { Item = "notepad", Chance = 80.9, MinCount = 1, MaxCount = 2 },
                    { Item = "pencil", Chance = 70.9, MinCount = 1, MaxCount = 2 },
                    { Item = "weapon_knife", Chance = 50.9, MinCount = 1, MaxCount = 2 },
                    { Item = "watch", Chance = 60.9, MinCount = 1, MaxCount = 2 },
                    { Item = "necklace", Chance = 50.9, MinCount = 1, MaxCount = 2 },
                    { Item = "bong", Chance = 80.9, MinCount = 1, MaxCount = 2 },
                    { Item = "twerks_candy", Chance = 80.9, MinCount = 3, MaxCount = 6 },
                    { Item = "sprunklight", Chance = 80.9, MinCount = 2, MaxCount = 5 },
                },
            },
            ["Book"] = {
                ChanceToFindNothing = 40,
                coords = vector3(345.3, -995.76, -99.2),        
                Items = {
                    { Item = "book", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "romantic_book", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                }
            },
            ["Bathroom"] = {
                ChanceToFindNothing = 30,
                coords = vector3(347.23, -994.09, -99.2),        
                Items = {
                    { Item = "toothpaste", Chance = 60.9, MinCount = 1, MaxCount = 2 },
                    { Item = "shampoo", Chance = 60.9, MinCount = 1, MaxCount = 2 },
                    { Item = "soap", Chance = 60.9, MinCount = 1, MaxCount = 2 },
                    { Item = "ring", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                },
            },
        },
        CreateProps = { -- Spawned props by script
            ["pogo"] = { model = `vw_prop_vw_pogo_gold_01a`, Label = "Art piece", Item = "pogo", Coords = vec4(339.66, -1001.4, -99.31, 180.47), propPlacement = { pos = vec3( 0.17, 0.0, 0.05), rot = vec3(16.0, 0.0, 0.0), bone = 18905 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, NeedTrunk = true, }
        },
        Safes = {
            ["safe"] = { model = `prop_ld_int_safe_01`, Label = "Safe", NeedItem = true, Item = "lockpick", Coords = vec4(352.34, -994.44, -100.2, 273.98),
                ChanceToFindNothing = 30,
                Items = {
                    { Item = "gold_watch", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "gold_bracelet", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "earings", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "necklace", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "pogo", Chance = 30.9, MinCount = 1, MaxCount = 1 },
                    { Item = "weapon_heavypistol", Chance = 20.9, MinCount = 1, MaxCount = 1 },
                    { Item = "at_suppressor_light", Chance = 10.9, MinCount = 1, MaxCount = 1 },
                    { Item = "money", Chance = 40.5, MinCount = 1000, MaxCount = 15000 },
                },
            },
        },
        Ped = {
            chance = 100, model = `a_m_y_soucent_04`, coords = vec4(349.83, -996.29, -99.54, 270.66), weapon = { enabled = false, chance = 100, weapon = `WEAPON_COMBATPISTOL`, DisableWeaponDrop = true }
        },
        StaticProps = { --Props that are already in interior
            TV = { model = `prop_tv_flat_01`, Label = "TV", Item = "television", propPlacement = { pos = vec3( 0.18, 0.16, 0.25), rot = vec3(-44.0, 112.0, 10.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = true },
            Coffe = { model = `prop_coffee_mac_02`, Label = "Coffe", Item = "coffemachine", propPlacement = { pos = vec3(0.18, 0.08, 0.25), rot = vec3(-16.0, 44.0, 106.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = true },
            Tape = { model = `prop_tapeplayer_01`, Label = "Tape layer", Item = "tapeplayer", propPlacement = { pos = vec3(0.18, 0.08, 0.25), rot = vec3(-32.0, 100.0, 10.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = true },
            Hair = { model = `v__club_vuhairdryer`, Label = "Hairdryer", Item = "hairdryer", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            Phone = { model = `v_res_j_phone`, Label = "Phone", Item = "j_phone", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            SCULPT = { model = `v_res_sculpt_decd`, Label = "Sculpture", Item = "sculpture", propPlacement = { pos = vec3(0.1, -0.16, 0.29), rot = vec3(-50.0, 106.0, -24.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = true },
            Toiletry = { model = `v_ret_ps_toiletry_01`, Label = "Toiletry", Item = "toiletry", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
        },
        HackDevice = {
            ["HackDevice"] = { model = `v_res_tre_alarmbox`, Label = "Hack Alarm", NeedItem = true, Item = "hack_laptop", Coords = vec4(347.61, -1003.035, -99.2, 176.47) }
        },
        LaserChance = 100,
        Lasers = {
            ["laser_mid1"] = { FromCoords = vector3(337.312, -992.528, -97.266), ToCoords = vector3(348.432, -1000.686, -100.118), Visible = false, chance = 40 },
            ["laser_mid2"] = { FromCoords = vector3(353.02, -999.806, -97.48), ToCoords = vector3(348.726, -992.918, -99.98), Visible = false, chance = 40 },
        },
    },
    ["High Tier"] = {
        chance = 50, -- change in mission to get this house type
        ReportChanceWhenEntering = 100,
        NeedPoliceCount = 0,
        InsidePositions = {
            ["Exit"] = { 
                coords = vector4(-787.48413085938, 315.70617675782, 187.9133758545, 270.08288574218),        
            },
            ["Saffron"] = {
                ChanceToFindNothing = 25,
                coords = vector3(-788.957886, 320.741302, 187.313248),        
                Items = {
                    { Item = "bong", Chance = 20.5, MinCount = 1, MaxCount = 2 },
                    { Item = "weapon_knuckle", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "weapon_bat", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "earings", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "twerks_candy", Chance = 80.9, MinCount = 3, MaxCount = 6 },
                    { Item = "sprunklight", Chance = 80.9, MinCount = 2, MaxCount = 5 },
                }
            },
            ["Kitchen #1"] = { 
                ChanceToFindNothing = 25,
                coords = vector3(-783.327454, 325.411712, 187.313248),        
                Items = {
                    { Item = "weapon_bottle", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "WEAPON_MACHETE", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "earings", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "watch", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                },
            },
            ["Kitchen #2"] = {
                ChanceToFindNothing = 25,
                coords = vector3(-782.004090, 330.077392, 187.313248),        
                Items = {
                    { Item = "weapon_knife", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "weapon_bottle", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                }
            },
            ["Heist storage"] = {
                ChanceToFindNothing = 25,
                coords = vector3(-794.997680, 326.787872, 187.313340),        
                Items = {
                    { Item = "weapon_ak74", Chance = 10.9, MinCount = 1, MaxCount = 1 },
                    { Item = "weapon_m45a1", Chance = 15.9, MinCount = 1, MaxCount = 1},
                    { Item = "at_suppressor_light", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "at_clip_extended_pistol", Chance = 15.9, MinCount = 1, MaxCount = 2 },
                }
            },
            ["Stair saffron"] = {
                ChanceToFindNothing = 25,
                coords = vector3(-793.373352, 341.711944, 187.113678),        
                Items = {
                    { Item = "weapon_knuckle", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "gold_bracelet", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "gold_watch", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "gold_bracelet", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                },
            },
            ["Bedroom saffron"] = {
                ChanceToFindNothing = 25,
                coords = vector3(-800.065612, 338.434052, 190.716018),        
                Items = {
                    { Item = "bong", Chance = 20.5, MinCount = 1, MaxCount = 2 },
                    { Item = "romantic_book", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "watches", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                },
            },
            ["Locker #2"] = {
                ChanceToFindNothing = 20,
                coords = vector3(-796.366760, 328.144348, 190.716004),        
                Items = {
                    { Item = "weapon_knuckle", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "weapon_m9", Chance = 15.9, MinCount = 1, MaxCount = 2 },
                    { Item = "weapon_bat", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                },
            },
            ["Bathroom"] = {
                ChanceToFindNothing = 25,
                coords = vector3(-806.068360, 332.405182, 190.716004),        
                Items = {
                    { Item = "toothpaste", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "shampoo", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "soap", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                },
            },
        },
        CreateProps = { -- Spawned props by script
            ["skull"] = { model = `vw_prop_casino_art_skull_03a`, Label = "Skull", Item = "skull", Coords = vec4(-796.78, 333.99, 191.08, 0.97), propPlacement = { pos = vec3( 0.17, 0.0, 0.05), rot = vec3(16.0, 0.0, 0.0), bone = 18905 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" } , NeedTrunk = false,},
            ["pogo"] = { model = `vw_prop_vw_pogo_gold_01a`, Label = "Art piece", Item = "pogo", Coords = vec4(-787.66, 327.58, 187.13, 178.27), propPlacement = { pos = vec3( 0.17, 0.0, 0.05), rot = vec3(16.0, 0.0, 0.0), bone = 18905 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" } , NeedTrunk = true,} 
        },
        Safes = {
            ["safe"] = { model = `prop_ld_int_safe_01`, Label = "Safe", NeedItem = true, Item = "lockpick", Coords = vec4(-797.56, 339.19, 190.02, 0.27),
                ChanceToFindNothing = 10,
                Items = {
                    { Item = "gold_watch", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "gold_bracelet", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "earings", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "necklace", Chance = 30.9, MinCount = 1, MaxCount = 2 },
                    { Item = "pogo", Chance = 30.9, MinCount = 1, MaxCount = 1 },
                    { Item = "at_clip_extended_mg", Chance = 30.9, MinCount = 1, MaxCount = 3 },
                    { Item = "at_clip_extended_rifle", Chance = 30.9, MinCount = 1, MaxCount = 3 },
                    { Item = "weapon_de", Chance = 5.9, MinCount = 1, MaxCount = 1 },
                    { Item = "money", Chance = 40.5, MinCount = 1000, MaxCount = 15000 },
                },
            }
        },
        Ped = {
            { chance = 100, model = `a_m_y_soucent_04`, coords = vec4(-797.98, 335.78, 190.39, 1.37), weapon = { enabled = false, chance = 100, weapon = `WEAPON_ASSAULTRIFLE`, DisableWeaponDrop = true } },
            { chance = 100, model = `a_m_y_stbla_02`, coords = vec4(-799.2, 326.84, 190.72, 331.41), weapon = { enabled = false, chance = 100, weapon = `WEAPON_ASSAULTRIFLE`, DisableWeaponDrop = true } },
            { chance = 100, model = `a_f_y_femaleagent`, coords = vec4(-793.1, 335.4, 190.62, 337.54), weapon = { enabled = false, chance = 100, weapon = `WEAPON_ASSAULTRIFLE`, DisableWeaponDrop = true } },
            { chance = 100, model = `csb_vagspeak`, coords = vec4(-795.85, 328.38, 187.31, 181.2), weapon = { enabled = false, chance = 100, weapon = `WEAPON_ASSAULTRIFLE`, DisableWeaponDrop = true } },
            { chance = 100, model = `csb_prolsec`, coords = vec4(-784.0, 319.17, 187.71, 272.26), weapon = { enabled = false, chance = 100, weapon = `WEAPON_ASSAULTRIFLE`, DisableWeaponDrop = true } }
        },        
        StaticProps = { --Props that are already in interior
            Bong = { model = `prop_bong_01`, Label = "Bong", Item = "bong", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            Laptop = { model = `prop_laptop_01a`, Label = "Laptop", Item = "hack_laptop", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            Monitor = { model = `prop_monitor_w_large`, Label = "Monitor", Item = "monitor", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            Phone = { model = `prop_npc_phone`, Label = "Phone", Item = "npc_phone", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            Printer = { model = `prop_printer_01`, Label = "Printer", Item = "printer", propPlacement = { pos = vec3(0.18, -0.11, 0.24), rot = vec3(-80.0, 6.0, 36.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = true },
            TV = { model = `prop_tv_flat_01`, Label = "TV", Item = "flat_television", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            radio = { model = `v_res_fa_radioalrm`, Label = "Radio", Item = "radio_alarm", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            Fan = { model = `v_res_fh_towerfan`, Label = "Fan", Item = "fan", propPlacement = { pos = vec3(0.16, 0.1, 0.23), rot = vec3(-160.0, 36.0, -74.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = false },
            TV2 = { model = `prop_tv_03`, Label = "TV", Item = "television", propPlacement = { pos = vec3(0.1, 0.42, 0.26), rot = vec3(-172.0, 182.0, -38.0), bone = 60309 }, CarryAnim = { dict = "anim@heists@box_carry@", anim = "idle" }, Spawned = false, NeedTrunk = true }
        },
        HackDevice = {
            ["HackDevice"] = { model = `v_res_tre_alarmbox`, Label = "Hack Alarm", NeedItem = true, Item = "hack_laptop", Coords = vec4(-781.71, 322.85, 188.19, 178.39 + 180.0) }
        },
        LaserChance = 100,
        Lasers = {
            ["laser_high1"] = { FromCoords = vector3(-791.046, 323.082, 190.122), ToCoords = vector3(-784.37, 327.042, 186.39), Visible = false, chance = 100 },
            ["laser_high2"] = { FromCoords = vector3(-792.338, 332.824, 192.952), ToCoords = vector3(-790.828, 343.812, 186.186), Visible = false, chance = 100 },
            ["laser_high3"] = { FromCoords = vector3(-794.62, 339.754, 192.808), ToCoords = vector3(-801.228, 331.73, 189.854), Visible = false, chance = 100 },
            ["laser_high4"] = { FromCoords = vector3(-781.26, 324.88, 190.46), ToCoords = vector3(-793.62, 332.88, 186.27), Visible = false, chance = 100 },
        },
    }
}

Config.HousesToRob = {
    ["Low Tier 1"] = {
        Coords = vec3(430.2, -1559.48, 32.82),
        Residence = Config.Tier["Low Tier"],
        Hints = {
            'HINT: There is grill near doors',
            'HINT: Its on second floor',
            'HINT: There are stairs near doors',
            'HINT: There are chairs near doors',
            'HINT: Its large apartment building'
        }
    },
    ["Low Tier 2"] = {
        Coords = vec3(1391.078, -1508.35, 58.43),
        Residence = Config.Tier["Low Tier"],
        Hints = {
            'HINT: Light brown house',
            'HINT: Jesus grafity on fence',
            'HINT: Broken van near house',
            'HINT: Blue garage next to this house',
        }
    },
    ["Low Tier 3"] = {
        Coords = vec3(1344.677, -1513.24, 54.585),
        Residence = Config.Tier["Low Tier"],
        Hints = {
            'HINT: Light green to white house',
            'HINT: Broken car on porch',
            'HINT: Tires near doors',
            'HINT: You need to go through back door',
        }
    },
    ["Low Tier 4"] = {
        Coords = vec3(1334.00, -1566.46, 54.447),
        Residence = Config.Tier["Low Tier"],
        Hints = {
            'HINT: Blue Umbrella near door',
            'HINT: Red garage next to this house',
            'HINT: Red and White fence',
        }
    },
    ["Low Tier 5"] = {
        Coords = vec3(1205.712, -1607.179, 50.7),
        Residence = Config.Tier["Low Tier"],
        Hints = {
            'HINT: Blue trash can',
            'HINT: Boxes near doors',
            'HINT: Flower near doors',
        }
    },
    ["Low Tier 6"] = {
        Coords = vec3(1203.47, -1670.49, 42.98),
        Residence = Config.Tier["Low Tier"],
        Hints = {
            'HINT: Blue house',
            'HINT: Long stairs leading to this house',
            'HINT: Yellow hydrant and red trash',
        }
    },
    ["Mid Tier 1"] = {
        Coords = vec3(-957.30, -1566.75, 5.0187458992004),
        Residence = Config.Tier["Mid Tier"],
        Hints = {
            'HINT: Bottom doors',
            'HINT: Tunell',
            'HINT: White doors with window',
        }
    },
    ["Mid Tier 2"] = {
        Coords = vector4(-1063.09, -1641.55, 4.4, 312.95495605468),
        Residence = Config.Tier["Mid Tier"],
        Hints = {
            'HINT: Electricty near doors',
            'HINT: Grey House',
            'HINT: Behind white fence near cactus',
        }
    },
    ["Mid Tier 3"] = {
        Coords = vector4(-1093.91, -1608.44, 8.39, 302.19357299804),
        Residence = Config.Tier["Mid Tier"],
        Hints = {
            'HINT: Doors up the stairs',
            'HINT: Air conditioner',
            'HINT: Next to pink house',
            'HINT: White and blue house',
            'HINT: Bush Fence',
            'HINT: Blue Trash bin',
        }
    },
    ["High Tier 1"] = {
        Coords = vector4(216.44, 620.49, 187.75, 74.529731750488),
        Residence = Config.Tier["High Tier"],
        Hints = {
            'HINT: Light brown house',
            'HINT: Camera next to doors',
            'HINT: For sale sign',
            'HINT: Brown garage',
            'HINT: 2 floors',
            'HINT: No house to the right',
        }
    },
    ["High Tier 2"] = {
        Coords = vector4(128.08, 565.98, 183.959, 13.116044998168),
        Residence = Config.Tier["High Tier"],
        Hints = {
            'HINT: White house',
            'HINT: Light next to doors',
            'HINT: Bobcat sign',
            'HINT: Brown garage',
            'HINT: 1 floor',
            'HINT: White box fence near doors with motorcycle behind',
        }
    },
}

--Shop
Config.Shop = {
    enabled = true,   
    Header = "Tech guy Shop",
    Items = {
        { label = 'Laser Powder', item = 'powder', description = "Buy Laser discovering powder for: $", price = 2000, MinAmount = 1, MaxAmount = 20},
        { label = 'Hacking laptop', item = 'hack_laptop', description = "Buy Laptop for: $", price = 4550, MinAmount = 1, MaxAmount = 2 },
        { label = 'Lockpick', item = 'lockpick', description = "Buy Lockpick for: $", price = 850, MinAmount = 1, MaxAmount = 20 },
        { label = 'Duffle bag', item = 'loot_bag', description = "Buy Duffle Bag for: $", price = 1000, MinAmount = 1, MaxAmount = 20 },
        { label = 'House Locator', item = 'house_locator', description = "Buy Locator for: $", price = 2500, MinAmount = 1, MaxAmount = 20 },
    },
    Ped = {
        model = `a_m_o_acult_02`, 
        coords = vector4(2340.39, 3130.12, 47.21, 305.15), 
        scenario = "WORLD_HUMAN_AA_SMOKE"
    },
    blip = {
        name = "Tech Guy", 
    },
}

--SellShop
Config.SellShop = {
    enabled = true,   
    EnabledSellAll = true,
    Header = "Sell",
    Items = {
        { label = 'TV', item = 'television', description = "Sell Square TV for: $", price = 1500, MinAmount = 1, MaxAmount = 20},
        { label = 'Art Piece', item = 'pogo', description = "Sell Art Piece for: $", price = 9500, MinAmount = 1, MaxAmount = 20},
        { label = 'Skull', item = 'skull', description = "Sell Skull for: $", price = 8500, MinAmount = 1, MaxAmount = 20},
        { label = 'Shoe Box', item = 'shoebox', description = "Sell Shoe Box for: $", price = 1000, MinAmount = 1, MaxAmount = 2},
        { label = 'DJ deck', item = 'dj_deck', description = "Sell DJ deck for: $", price = 1200, MinAmount = 1, MaxAmount = 20 },
        { label = 'Console', item = 'console', description = "Sell console for: $", price = 590, MinAmount = 1, MaxAmount = 20 },
        { label = 'Boombox', item = 'boombox', description = "Sell boombox for: $", price = 500, MinAmount = 1, MaxAmount = 20 },
        { label = 'Bong', item = 'bong', description = "Sell bong for: $", price = 50, MinAmount = 1, MaxAmount = 20 },
        { label = 'Flat Television', item = 'flat_television', description = "Sell Flat Television for: $", price = 1750, MinAmount = 1, MaxAmount = 20 },
        { label = 'Coffe', item = 'coffemachine', description = "Sell Coffe for: $", price = 50, MinAmount = 1, MaxAmount = 20 },
        { label = 'Hairdryer', item = 'hairdryer', description = "Sell hairdryer for: $", price = 120, MinAmount = 1, MaxAmount = 20 },
        { label = 'Phone', item = 'j_phone', description = "Sell Phone for: $", price = 740, MinAmount = 1, MaxAmount = 20 },
        { label = 'Sculpture', item = 'sculpture', description = "Sell sculpture for: $", price = 1300, MinAmount = 1, MaxAmount = 20 },
        { label = 'Toiletry', item = 'toiletry', description = "Sell toiletry for: $", price = 30, MinAmount = 1, MaxAmount = 20 },
        { label = 'Laptop', item = 'laptop', description = "Sell Laptop for: $", price = 1500, MinAmount = 1, MaxAmount = 20 },
        { label = 'Monitor', item = 'monitor', description = "Sell monitor for: $", price = 580, MinAmount = 1, MaxAmount = 20 },
        { label = 'Printer', item = 'printer', description = "Sell Printer for: $", price = 360, MinAmount = 1, MaxAmount = 20 },
        { label = 'Watch', item = 'watch', description = "Sell Watch for: $", price = 1000, MinAmount = 1, MaxAmount = 20 },
        { label = 'Toothpaste', item = 'toothpaste', description = "Sell toothpaste for: $", price = 30, MinAmount = 1, MaxAmount = 20 },
        { label = 'Soap', item = 'soap', description = "Sell soap for: $", price = 20, MinAmount = 1, MaxAmount = 20 },
        { label = 'Shampoo', item = 'shampoo', description = "Sell shampoo for: $", price = 36, MinAmount = 1, MaxAmount = 20 },
        { label = 'Romantic book', item = 'romantic_book', description = "Sell romantic book for: $", price = 20, MinAmount = 1, MaxAmount = 20 },
        { label = 'Necklace', item = 'necklace', description = "Sell necklace for: $", price = 2000, MinAmount = 1, MaxAmount = 20 },
        { label = 'Gold watch', item = 'gold_watch', description = "Sell gold watch for: $", price = 21000, MinAmount = 1, MaxAmount = 20 },
        { label = 'Gold bracelet', item = 'gold_bracelet', description = "Sell gold bracelet for: $", price = 13000, MinAmount = 1, MaxAmount = 20 },
        { label = 'Bracelet', item = 'bracelet', description = "Sell bracelet for: $", price = 2500, MinAmount = 1, MaxAmount = 20 },
        { label = 'Earings', item = 'earings', description = "Sell earings for: $", price = 2000, MinAmount = 1, MaxAmount = 20 },
        { label = 'Book', item = 'book', description = "Sell book for: $", price = 250, MinAmount = 1, MaxAmount = 20 },
        { label = 'Skull Art', item = 'skull', description = "Sell skull for: $", price = 1000, MinAmount = 1, MaxAmount = 20 },
        { label = 'Pencil', item = 'pencil', description = "Sell pencil for: $", price = 50, MinAmount = 1, MaxAmount = 20 },
        { label = 'Notepad', item = 'notepad', description = "Sell notepad for: $", price = 50, MinAmount = 1, MaxAmount = 20 },
        { label = 'Tape layer', item = 'tapeplayer', description = "Sell tape player for: $", price = 200, MinAmount = 1, MaxAmount = 20 },
    },
    Ped = {
        model = `a_m_m_fatlatin_01`, 
        coords = vector4(2341.3, 3126.39, 47.21, 346.74), 
        scenario = "WORLD_HUMAN_AA_COFFEE"
    },
}

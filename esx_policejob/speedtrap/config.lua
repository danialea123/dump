ConfigSpeed = {}

ConfigSpeed.Global = {
    FlashEffect = true,
    DebugZones = false,
    Debug = false,
    MetricSystem = "kph"
}
   
ConfigSpeed.Notifications = {
    Title                           = "دوربین کنترل سرعت",
    Position                        = 'center-right',
    Cooldown                        = "سرعت خودروی شما توسط دوربین های کنترل سرعت ضبط و بررسی شد",
    RemoveSuccess                   = "Shoma Ba Sorat ${speed} KM/H Tavassaot Doorbin Haye Police Be Mablagh ${amount} $ Jarime Shodid",
    RemoveInsufficientFunds         = "سرعت خودروی شما توسط دوربین های کنترل سرعت ضبط و بررسی شد",
    AddSuccess                      = "رانندگی تحسین‌برانگیز! ${amount} در حسابت هست چون دیوانه‌بازی درنیاوردی!"
}

-- --- SOUND LIBRARY https://gist.github.com/Sainan/021bd2f48f1c68d3eb002caab635b5a4
-- EXAMPLE:                                     NAME                SET
--          AUDIO::PLAY_SOUND_FRONTEND(-1, "Camera_Shoot", "Phone_Soundset_Franklin", true);

-- Speed Traps
ConfigSpeed.SpeedTraps = {
    {
        ZoneName = "Pillbox Hill Hospital",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(262.1, -582.13, 43.36),
        Radius = 50.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds (I recommend setting this higher to prevent abuse)
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Mission Row",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(224.7, -1043.27, 29.76),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 100,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Mission Row Police",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(402.06, -955.33, 28.83),
        Radius = 20.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Legion Square",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(169.88, -820.92, 30.58),
        Radius = 50.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Legion Square 2",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(289.99, -855.85, 31.4),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Legion Square 3",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(104.86, -1001.77, 28.8),
        Radius = 35.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "LS Custom",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(-279.85, -175.73, 40.42),
        Radius = 55.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Special Force",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(692.43, 6.52, 83.58),
        Radius = 40.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Taxi",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(943.59, -156.26, 73.25),
        Radius = 25.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Eclipce Hospital",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(-539.18, 255.28, 82.46),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "DOJ-Mechanic",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(-448.83, -250.35, 35.44),
        Radius = 35.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Sheriff-Medic",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(1673.01, 3552.75, 34.99),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Sheriff-Medic",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(2039.99, 3765.77, 31.7),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },    
    {
        ZoneName = "Vespucci Police",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(-1174.0, -846.23, 13.73),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Vespucciff Police",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(-763.12,217.79,75.71),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Vespucciffff Police",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(512.6,82.4,96.38),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
    {
        ZoneName = "Vespucgg Police",
        Enabled = true, -- Enable/disable the zone
        Coords = vector3(-570.48,-62.33,42.01),
        Radius = 30.0, -- Detection radius
        Cooldown = 10, -- Cooldown in seconds
        Restricted = {
            {["Type"] = "job", ["Groups"] = {["police"] = 0, ["ambulance"] = 0}}
        },
        Blip = {
            Enabled = true,
            Sprite = 744,
            Color = 0,
            Scale = 0.5
        },
        SpeedThresholds = {
            {
                Speed = 120,
                Action = "remove",
                Amount = 500,
                Sound = { Name = "Camera_Shoot", Set = "Phone_Soundset_Franklin", Volume = 2.0 } 
            }
        },
    },
}
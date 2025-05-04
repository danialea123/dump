Config = {     --- If you have a suggestions on new skills, contact us on discord and tag @burbonas

    -- Command for admins to add xp /addxp playerid amount

    KeyToOpenSkillMenu = 'F9', --(number 7 right now)
    
    LevelingDifficulty = 20,--%  the difficulty to level up in [ % ]  
    SkillPointsPerLevel = 1, -- how many skill points player will get EACH LEVEL UP

    NotificationTimeInSeconds = 7,

    RestoreDefault = {
        allowRestore = true,
        Name = "Fresh Start",
        Description = "All of the skills you have will be removed and you will start your journey again at level 0.",
        Purchase = "This is only available once every session!",
        NoSkills = "You have no skills to reset!",
        NotAvailable = "You have already used your Fresh Start!",
    },

    StartingSkill = {
        SkillName = "The Rise Of ", -- after "The Rise Of " will be a player name, it will be written automatically
        SkillDescription = "با شروع بازی ۳ امتیاز مهارت بهت داده می‌شه؛ عاقلانه ازشون استفاده کن با هر بار ارتقاء سطح ۱ امتیاز مهارت دیگه هم می‌گیری برای کسب تجربه می‌تونی کار کنی، بانک‌ها و فروشگاه‌ها رو سرقت کنی و ...", ---- YOU SHOULD CHANGE THIS PART OF HOW THEY WILL EARN XP IN YOUR SERVER
        StartingSkillPoints = 3,
        Purchase = 0,
        image = "mainskill",
    },



    Skills = { --- ALL the explanations on SkillAbilities are in Skill Abilities Documentation file

        HealthRegen1 = { --- First Top skill
            ConnectLineTo = "StartingSkill",
            SkillName = "Health Recovery", 
            SkillDescription = "هر 30 ثانیه 1 واحد سلامتی برمی‌گرده. این روند وقتی سلامتیت 20 یا کمتر باشه شروع می‌شه و توی 40 متوقف می‌شه",
            Purchase = 8,
            x = 2715, -- coordinates in px (left)
            y = 1190, -- coordinates in px (top)
            image = "HealthRegen1",
            SkillAbilities = {
                AddHealthRegen = { 
                    SpeedOfRegenerationInSeconds = 30, 
                    StartRegeneration = 20, 
                    StopRegeneration = 40, 
                },
            },
        },
        StaminaSprintTime1 = { --- First Bottom Left skill
            ConnectLineTo = "StartingSkill",
            SkillName = "Stamina Capacity", 
            SkillDescription = "میتونی تا %5 بیشتر بدوی",
            Purchase = 8,
            image = "staminasprint",
            x = 2332, -- coordinates in px (left)
            y = 1696, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaSprint = 1,
            },
        },
        RunningSpeed1 = { --- First Bottom Right skill
            ConnectLineTo = "StartingSkill",
            SkillName = "Running Speed", 
            SkillDescription = ".سرعت دویدنت 2% بیشتر می‌شه",
            Purchase = 8,
            image = "Speed",
            x = 3081, -- coordinates in px (left)
            y = 1697, -- coordinates in px (top)
            SkillAbilities = {
                AddSpeed = 1.02,
            },
        },



        --- Start of TOP LEFT SIDE skill tree
        AddHealth1 = { 
            ConnectLineTo = "HealthRegen1",
            SkillName = "Health Shot", 
            SkillDescription = "میتونی هر 5 دقیقه 5 واحد سلامتی بگیری /addhp با استفاده از کامند",
            Purchase = 11,
            image = "Health",
            x = 2487, -- coordinates in px (left)
            y = 941, -- coordinates in px (top)
            SkillAbilities = {
                AddHealth = 5,
            },
        },
        AddHealth2 = { 
            ConnectLineTo = "AddHealth1",
            SkillName = "Health Shot 2LVL", 
            SkillDescription = "میتونی هر 5 دقیقه 10 واحد سلامتی بگیری /addhp با استفاده از کامند",
            Purchase = 16,
            image = "Health",
            x = 2352, -- coordinates in px (left)
            y = 652, -- coordinates in px (top)
            SkillAbilities = {
                AddHealth = 10,
            },
        },
        AddHealth3 = { 
            ConnectLineTo = "AddHealth2",
            SkillName = "Health Shot 3LVL", 
            SkillDescription = "میتونی هر 5 دقیقه 15 واحد سلامتی بگیری /addhp با استفاده از کامند",
            Purchase = 24,
            image = "Health",
            x = 2479, -- coordinates in px (left)
            y = 276, -- coordinates in px (top)
            SkillAbilities = {
                AddHealth = 15,
            },
        },
        AddHealth4 = { 
            ConnectLineTo = "AddHealth3",
            SkillName = "Health Shot 4LVL", 
            SkillDescription = "میتونی هر 5 دقیقه 20 واحد سلامتی بگیری /addhp با استفاده از کامند",
            Purchase = 34,
            image = "Health",
            x = 1771, -- coordinates in px (left)
            y = 119, -- coordinates in px (top)
            SkillAbilities = {
                AddHealth = 20,
            },
        },


        HealthRegen2 = { 
            ConnectLineTo = "AddHealth1",
            SkillName = "Better Health Recovery", 
            SkillDescription = "باز سازی سلامتیت از 30 یا کمتر شروع میشه و تا 50 ادامه داره",
            Purchase = 16,
            image = "HealthRegen1",
            x = 1933, -- coordinates in px (left)
            y = 833, -- coordinates in px (top)
            SkillAbilities = {
                AddHealthRegen = { 
                    StartRegeneration = 30, 
                    StopRegeneration = 50, 
                },
            },
        },
        HealthRegen3 = { 
            ConnectLineTo = "HealthRegen2",
            SkillName = "Faster Health Recovery", 
            SkillDescription = "هر 25 ثانیه 1 واحد سلامتی برمی‌ گرده",
            Purchase = 24,
            image = "HealthRegen1",
            x = 1630, -- coordinates in px (left)
            y = 460, -- coordinates in px (top)
            SkillAbilities = {
                AddHealthRegen = { 
                    SpeedOfRegenerationInSeconds = 25, 
                },
            },
        },
        HealthRegen4 = { 
            ConnectLineTo = "HealthRegen3",
            SkillName = "Better Health Recovery 2LVL", 
            SkillDescription = "باز سازی سلامتیت از 40 یا کمتر شروع میشه و تا 60 ادامه داره",
            Purchase = 21,
            image = "HealthRegen1",
            x = 1314, -- coordinates in px (left)
            y = 981, -- coordinates in px (top)
            SkillAbilities = {
                AddHealthRegen = { 
                    StartRegeneration = 40, 
                    StopRegeneration = 60, 
                },
            },
        },
        HealthRegen5 = { 
            ConnectLineTo = "HealthRegen4",
            SkillName = "Better Health Recovery 3LVL", 
            SkillDescription = "باز سازی سلامتیت از 50 یا کمتر شروع میشه و تا 90 ادامه داره",
            Purchase = 29,
            image = "HealthRegen1",
            x = 785, -- coordinates in px (left)
            y = 887, -- coordinates in px (top)
            SkillAbilities = {
                AddHealthRegen = { 
                    StartRegeneration = 50, 
                    StopRegeneration = 90, 
                },
            },
        },
        HealthRegen6 = { 
            ConnectLineTo = "HealthRegen3",
            SkillName = "Faster Health Recovery 2LVL", 
            SkillDescription = "سرعت بازسازی به هر 20 ثانیه 1 واحد می‌رسه",
            Purchase = 34,
            image = "HealthRegen1",
            x = 1012, -- coordinates in px (left)
            y = 509, -- coordinates in px (top)
            SkillAbilities = {
                AddHealthRegen = { 
                    SpeedOfRegenerationInSeconds = 20, 
                },
            },
        },
        HealthRegen7 = { 
            ConnectLineTo = "HealthRegen6",
            SkillName = "Faster Health Recovery 3LVL", 
            SkillDescription = "هر 15 ثانیه 1 واحد سلامتی برمی‌ گرده",
            Purchase = 44,
            image = "HealthRegen1",
            x = 412, -- coordinates in px (left)
            y = 199, -- coordinates in px (top)
            SkillAbilities = {
                AddHealthRegen = { 
                    SpeedOfRegenerationInSeconds = 15, 
                },
            },
        },
        --- END of TOP LEFT SIDE skill tree




        --- START of TOP RIGHT SIDE skill tree
        AddArmor1 = { 
            ConnectLineTo = "HealthRegen1",
            SkillName = "Armor Shot", 
            SkillDescription = "میتونی هر 5 دقیقه 5 واحد زره اضافه بگیری /addarmor با استفاده از کامند",
            Purchase = 14,
            image = "Armor",
            x = 2865, -- coordinates in px (left)
            y = 941, -- coordinates in px (top)
            SkillAbilities = {
                AddArmor = 5,
            },
        },
        AddArmor2 = { 
            ConnectLineTo = "AddArmor1",
            SkillName = "Armor Shot 2LVL", 
            SkillDescription = "میتونی هر 5 دقیقه 10 واحد زره اضافه بگیری /addarmor با استفاده از کامند",
            Purchase = 19,
            image = "Armor",
            x = 2741, -- coordinates in px (left)
            y = 479, -- coordinates in px (top)
            SkillAbilities = {
                AddArmor = 10,
            },
        },
        AddArmor3 = { 
            ConnectLineTo = "AddArmor2",
            SkillName = "Armor Shot 3LVL", 
            SkillDescription = "میتونی هر 5 دقیقه 15 واحد زره اضافه بگیری /addarmor با استفاده از کامند",
            Purchase = 26,
            image = "Armor",
            x = 3161, -- coordinates in px (left)
            y = 460, -- coordinates in px (top)
            SkillAbilities = {
                AddArmor = 15,
            },
        },
        AddArmor4 = { 
            ConnectLineTo = "AddArmor3",
            SkillName = "Armor Shot 4LVL", 
            SkillDescription = "میتونی هر 5 دقیقه 20 واحد زره اضافه بگیری /addarmor با استفاده از کامند",
            Purchase = 44,
            image = "Armor",
            x = 3573, -- coordinates in px (left)
            y = 79, -- coordinates in px (top)
            SkillAbilities = {
                AddArmor = 20,
            },
        },
        


        ArmorRegen1 = { 
            ConnectLineTo = "AddArmor1",
            SkillName = "Armor Recovery", 
            SkillDescription = "هر 30 ثانیه 1 واحد زره بر میگرده این باسازی وقتی زره‌ت 10 یا کمتر باشه شروع می‌شه و توی 30 متوقف می‌شه",
            Purchase = 16,
            x = 3307, -- coordinates in px (left)
            y = 782, -- coordinates in px (top)
            image = "ArmorRegen",
            SkillAbilities = {
                AddArmorRegen = { 
                    SpeedOfRegenerationInSeconds = 30, 
                    StartRegeneration = 10, 
                    StopRegeneration = 30, 
                },
            },
        },
        ArmorRegen2 = { 
            ConnectLineTo = "ArmorRegen1",
            SkillName = "Better Armor Recovery", 
            SkillDescription = "حالا بازسازی از 30 واحد یا کمتر شروع می‌شه و تا 50 ادامه داره",
            Purchase = 21,
            image = "ArmorRegen",
            x = 3780, -- coordinates in px (left)
            y = 981, -- coordinates in px (top)
            SkillAbilities = {
                AddArmorRegen = { 
                    StartRegeneration = 30, 
                    StopRegeneration = 50, 
                },
            },
        },
        ArmorRegen3 = { 
            ConnectLineTo = "ArmorRegen2",
            SkillName = "Better Armor Recovery 2LVL", 
            SkillDescription = "حالا بازسازی بعد از 40 واحد یا کمتر شروع می‌شه و تا 60 می‌ره",
            Purchase = 29,
            image = "ArmorRegen",
            x = 4353, -- coordinates in px (left)
            y = 861, -- coordinates in px (top)
            SkillAbilities = {
                AddArmorRegen = { 
                    StartRegeneration = 40, 
                    StopRegeneration = 60, 
                },
            },
        },
        ArmorRegen4 = { 
            ConnectLineTo = "ArmorRegen3",
            SkillName = "Better Armor Recovery 3LVL", 
            SkillDescription = "حالا بازسازی از 50 واحد یا کمتر شروع می‌شه و تا 80 ادامه داره",
            Purchase = 39,
            image = "ArmorRegen",
            x = 4998, -- coordinates in px (left)
            y = 1021, -- coordinates in px (top)
            SkillAbilities = {
                AddArmorRegen = { 
                    StartRegeneration = 50, 
                    StopRegeneration = 80, 
                },
            },
        },
        ArmorRegen5 = { 
            ConnectLineTo = "ArmorRegen2",
            SkillName = "Faster Armor Recovery", 
            SkillDescription = "هر 25 ثانیه 1 واحد زره میگیری",
            Purchase = 24,
            image = "ArmorRegen",
            x = 3653, -- coordinates in px (left)
            y = 509, -- coordinates in px (top)
            SkillAbilities = {
                AddArmorRegen = { 
                    SpeedOfRegenerationInSeconds = 25, 
                },
            },
        },
        ArmorRegen6 = { 
            ConnectLineTo = "ArmorRegen5",
            SkillName = "Faster Armor Recovery 2LVL", 
            SkillDescription = "هر 15 ثانیه 1 واحد زره میگیری",
            Purchase = 34,
            image = "ArmorRegen",
            x = 4238, -- coordinates in px (left)
            y = 199, -- coordinates in px (top)
            SkillAbilities = {
                AddArmorRegen = { 
                    SpeedOfRegenerationInSeconds = 15, 
                },
            },
        },
        ArmorRegen7 = { 
            ConnectLineTo = "ArmorRegen6",
            SkillName = "Faster Armor Recovery 3LVL", 
            SkillDescription = "هر 10 ثانیه 1 واحد زره میگیری",
            Purchase = 44,
            image = "ArmorRegen",
            x = 4716, -- coordinates in px (left)
            y = 559, -- coordinates in px (top)
            SkillAbilities = {
                AddArmorRegen = { 
                    SpeedOfRegenerationInSeconds = 10, 
                },
            },
        },
        --- END of TOP RIGHT SIDE skill tree





        --- START of BOTTOM RIGHT SIDE skill tree
        DriveCarFaster1 = {
            ConnectLineTo = "RunningSpeed1",
            SkillName = "Driver: Beginner", 
            SkillDescription = "سرعت حداکثر هر ماشینی که می‌رونی 2 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 13,
            image = "drivingfaster1",
            x = 3244, -- coordinates in px (left)
            y = 2006, -- coordinates in px (top)
            SkillAbilities = {
                AddDrivingSpeed = 2,
            },
        },
        DriveCarFaster2 = {
            ConnectLineTo = "DriveCarFaster1",
            SkillName = "Driver: Amatuer", 
            SkillDescription = "سرعت حداکثر هر ماشینی که می‌رونی 5 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 16,
            image = "drivingfaster1",
            x = 3001, -- coordinates in px (left)
            y = 2328, -- coordinates in px (top)
            SkillAbilities = {
                AddDrivingSpeed = 5,
            },
        },
        DriveCarFaster3 = {
            ConnectLineTo = "DriveCarFaster2",
            SkillName = "Driver: Pro", 
            SkillDescription = "سرعت حداکثر هر ماشینی که می‌رونی 10 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 24,
            image = "drivingfaster1",
            x = 3244, -- coordinates in px (left)
            y = 2616, -- coordinates in px (top)
            SkillAbilities = {
                AddDrivingSpeed = 10,
            },
        },
        DriveCarFaster4 = {
            ConnectLineTo = "DriveCarFaster3",
            SkillName = "Driver: Racer", 
            SkillDescription = "سرعت حداکثر هر ماشینی که می‌رونی 15 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 34,
            image = "drivingfaster1",
            x = 2746, -- coordinates in px (left)
            y = 2797, -- coordinates in px (top)
            SkillAbilities = {
                AddDrivingSpeed = 15,
            },
        },


        BoatFaster1 = {
            ConnectLineTo = "DriveCarFaster1",
            SkillName = "Sailor: Beginner", 
            SkillDescription = "سرعت حداکثر هر قایقی که می‌رونی 5 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 16,
            image = "SailingFaster",
            x = 3410, -- coordinates in px (left)
            y = 2304, -- coordinates in px (top)
            SkillAbilities = {
                AddBoatSpeed = 5,
            },
        },
        BoatFaster2 = {
            ConnectLineTo = "BoatFaster1",
            SkillName = "Sailor: Amatuer", 
            SkillDescription = "سرعت حداکثر هر قایقی که می‌رونی 10 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 21,
            image = "SailingFaster",
            x = 3780, -- coordinates in px (left)
            y = 2344, -- coordinates in px (top)
            SkillAbilities = {
                AddBoatSpeed = 10,
            },
        },
        BoatFaster3 = {
            ConnectLineTo = "BoatFaster2",
            SkillName = "Sailor: Pro", 
            SkillDescription = "سرعت حداکثر هر قایقی که می‌رونی 15 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 29,
            image = "SailingFaster",
            x = 3860, -- coordinates in px (left)
            y = 2757, -- coordinates in px (top)
            SkillAbilities = {
                AddBoatSpeed = 15,
            },
        },
        BoatFaster4 = {
            ConnectLineTo = "BoatFaster3",
            SkillName = "Sailor: Racer", 
            SkillDescription = "سرعت حداکثر هر قایقی که می‌رونی 20 کیلومتر در ساعت بیشتر می‌شه",
            Purchase = 39,
            image = "SailingFaster",
            x = 4278, -- coordinates in px (left)
            y = 2570, -- coordinates in px (top)
            SkillAbilities = {
                AddBoatSpeed = 20,
            },
        },


        RunningSpeed2 = {
            ConnectLineTo = "RunningSpeed1",
            SkillName = "Running Speed 2LVL", 
            SkillDescription = "سرعت دویدنت %5 بیشتر میشه",
            Purchase = 11,
            image = "Speed",
            x = 3450, -- coordinates in px (left)
            y = 1709, -- coordinates in px (top)
            SkillAbilities = {
                AddSpeed = 1.05,
            },
        },
        RunningSpeed3 = {
            ConnectLineTo = "RunningSpeed2",
            SkillName = "Running Speed 3LVL", 
            SkillDescription = "سرعت دویدنت %10 بیشتر میشه",
            Purchase = 16,
            image = "Speed",
            x = 3900, -- coordinates in px (left)
            y = 1892, -- coordinates in px (top)
            SkillAbilities = {
                AddSpeed = 1.10,
            },
        },
        RunningSpeed4 = {
            ConnectLineTo = "RunningSpeed3",
            SkillName = "Running Speed 4LVL", 
            SkillDescription = "سرعت دویدنت %15 بیشتر میشه",
            Purchase = 24,
            image = "Speed",
            x = 4146, -- coordinates in px (left)
            y = 2235, -- coordinates in px (top)
            SkillAbilities = {
                AddSpeed = 1.15,
            },
        },

        ShieldWall1 = {
            ConnectLineTo = "RunningSpeed2",
            SkillName = "Defensive Wall", 
            SkillDescription = "ه دیوار دفاعی بساز که به مدت 2 ثانیه می‌مونه و بعد از 5 دقیقه دوباره قابل استفاده است [Shift + CapsLock] با نگه داسشتن",
            Purchase = 15,
            image = "ShieldWall",
            x = 3923, -- coordinates in px (left)
            y = 1470, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallStandingTimeInSeconds = 2,
                    WallRechargeTimeInSeconds = 300,
                },
            },
        },
        ShieldWall2 = {
            ConnectLineTo = "ShieldWall1",
            SkillName = "Wall Standing Time", 
            SkillDescription = "زمان موندگاری دیوار دفاعی از 2 ثاتیه به 5 ثانیه میرسه",
            Purchase = 20,
            image = "ShieldWall",
            x = 4393, -- coordinates in px (left)
            y = 1749, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallStandingTimeInSeconds = 5,
                },
            },
        },
        ShieldWall3 = {
            ConnectLineTo = "ShieldWall2",
            SkillName = "Wall Standing Time 2LVL", 
            SkillDescription = "زمان موندگاری دیوار دفاعی از 5 ثاتیه به 10 ثانیه میرسه",
            Purchase = 25,
            image = "ShieldWall",
            x = 4636, -- coordinates in px (left)
            y = 2195, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallStandingTimeInSeconds = 10,
                },
            },
        },
        ShieldWall4 = {
            ConnectLineTo = "ShieldWall3",
            SkillName = "Wall Standing Time 3LVL", 
            SkillDescription = "زمان موندگاری دیوار دفاعی از 10 ثاتیه به 15 ثانیه میرسه",
            Purchase = 30,
            image = "ShieldWall",
            x = 5142, -- coordinates in px (left)
            y = 2155, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallStandingTimeInSeconds = 15,
                },
            },
        },

        ShieldWall5 = {
            ConnectLineTo = "ShieldWall1",
            SkillName = "Wall Recharge Time", 
            SkillDescription = "زمان شارژ مجدد دیوار دفاعی می‌رسه به 4 دقیقه و 30 ثانیه",
            Purchase = 20,
            image = "ShieldWall",
            x = 4530, -- coordinates in px (left)
            y = 1390, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallRechargeTimeInSeconds = 270,
                },
            },
        },
        ShieldWall6 = {
            ConnectLineTo = "ShieldWall5",
            SkillName = "Wall Recharge Time 2LVL", 
            SkillDescription = "زمان شارژ مجدد دیوار دفاعی می‌رسه به 4 دقیقه",
            Purchase = 30,
            image = "ShieldWall",
            x = 5102, -- coordinates in px (left)
            y = 1579, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallRechargeTimeInSeconds = 240,
                },
            },
        },
        ShieldWall7 = {
            ConnectLineTo = "ShieldWall6",
            SkillName = "Wall Recharge Time 3LVL", 
            SkillDescription =  "زمان شارژ مجدد دیوار دفاعی می‌رسه به 3 دقیقه",
            Purchase = 44,
            image = "ShieldWall",
            x = 4841, -- coordinates in px (left)
            y = 1831, -- coordinates in px (top)
            SkillAbilities = {
                AddShieldWall = { 
                    WallRechargeTimeInSeconds = 180,
                },
            },
        },
        --- END of BOTTOM RIGHT SIDE skill tree



        --- START of BOTTOM LEFT SIDE skill tree

        StaminaRecoveryTime1 = {
            ConnectLineTo = "StaminaSprintTime1",
            SkillName = "Stamina Recovery", 
            SkillDescription = "استقامتت 10% سریع‌تر برمی ‌گرده",
            Purchase = 10,
            image = "staminasprint",
            x = 2124, -- coordinates in px (left)
            y = 2006, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaRecovery = 1,
            },
        },
        StaminaRecoveryTime2 = { 
            ConnectLineTo = "StaminaRecoveryTime1",
            SkillName = "Stamina Recovery 2LVL", 
            SkillDescription = "استقامتت 20% سریع‌تر برمی ‌گرده",
            Purchase = 13,
            image = "staminasprint",
            x = 1685, -- coordinates in px (left)
            y = 2215, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaRecovery = 2,
            },
        },
        StaminaRecoveryTime3 = { 
            ConnectLineTo = "StaminaRecoveryTime2",
            SkillName = "Stamina Recovery 3LVL", 
            SkillDescription = "استقامتت 30% سریع‌تر برمی ‌گرده",
            Purchase = 19,
            image = "staminasprint",
            x = 1777, -- coordinates in px (left)
            y = 2635, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaRecovery = 3,
            },
        },

        StaminaSprintTime2 = { 
            ConnectLineTo = "StaminaRecoveryTime1",
            SkillName = "Stamina Capacity 2LVL", 
            SkillDescription = "می‌تونی 15% بیشتر بدوی",
            Purchase = 14,
            image = "staminasprint",
            x = 2508, -- coordinates in px (left)
            y = 2304, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaSprint = 3,
            },
        },
        StaminaSprintTime3 = { 
            ConnectLineTo = "StaminaSprintTime2",
            SkillName = "Stamina Capacity 3LVL", 
            SkillDescription = "می‌تونی 20% بیشتر بدوی",
            Purchase = 19,
            image = "staminasprint",
            x = 2142, -- coordinates in px (left)
            y = 2530, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaSprint = 4,
            },
        },
        StaminaSprintTime4 = { 
            ConnectLineTo = "StaminaSprintTime3",
            SkillName = "Stamina Capacity 4LVL", 
            SkillDescription = "می‌تونی 30% بیشتر بدوی",
            Purchase = 24,
            image = "staminasprint",
            x = 2447, -- coordinates in px (left)
            y = 2917, -- coordinates in px (top)
            SkillAbilities = {
                AddStaminaSprint = 5,
            },
        },


        SwimmingSpeed1 = { 
            ConnectLineTo = "StaminaSprintTime1",
            SkillName = "Swimming Speed", 
            SkillDescription = "سرعت شنا کردن %5 بیشتر میشه",
            Purchase = 13,
            image = "Swimming",
            x = 1918, -- coordinates in px (left)
            y = 1709, -- coordinates in px (top)
            SkillAbilities = {
                AddSwimmingSpeed = 1.05,
            },
        },
        SwimmingSpeed2 = { 
            ConnectLineTo = "SwimmingSpeed1",
            SkillName = "Swimming Speed 2LVL", 
            SkillDescription = "سرعت شنا کردن %15 بیشتر میشه",
            Purchase = 13,
            image = "Swimming",
            x = 1545, -- coordinates in px (left)
            y = 1932, -- coordinates in px (top)
            SkillAbilities = {
                AddSwimmingSpeed = 1.15,
            },
        },
        SwimmingSpeed3 = { 
            ConnectLineTo = "SwimmingSpeed2",
            SkillName = "Swimming Speed 3LVL", 
            SkillDescription = "سرعت شنا کردن %20 بیشتر میشه",
            Purchase = 16,
            image = "Swimming",
            x = 1337, -- coordinates in px (left)
            y = 2422, -- coordinates in px (top)
            SkillAbilities = {
                AddSwimmingSpeed = 1.20,
            },
        },
        SwimmingSpeed4 = { 
            ConnectLineTo = "SwimmingSpeed3",
            SkillName = "Swimming Speed 4LVL", 
            SkillDescription = "سرعت شنا کردن %30 بیشتر میشه",
            Purchase = 21,
            image = "Swimming",
            x = 785, -- coordinates in px (left)
            y = 2288, -- coordinates in px (top)
            SkillAbilities = {
                AddSwimmingSpeed = 1.30,
            },
        },

        UnderWaterTime1 = { 
            ConnectLineTo = "SwimmingSpeed1",
            SkillName = "UnderWater Time", 
            SkillDescription = "می‌تونی 5 ثانیه بیشتر زیر آب بمونی",
            Purchase = 14,
            image = "underwater",
            x = 1472, -- coordinates in px (left)
            y = 1485, -- coordinates in px (top)
            SkillAbilities = {
                AddUnderWaterTime = 5,
            },
        },
        UnderWaterTime2 = { 
            ConnectLineTo = "UnderWaterTime1",
            SkillName = "UnderWater Time 2LVL", 
            SkillDescription = "می‌تونی 10 ثانیه بیشتر زیر آب بمونی",
            Purchase = 24,
            image = "underwater",
            x = 1089, -- coordinates in px (left)
            y = 1776, -- coordinates in px (top)
            SkillAbilities = {
                AddUnderWaterTime = 10,
            },
        },
        UnderWaterTime3 = { 
            ConnectLineTo = "UnderWaterTime2",
            SkillName = "UnderWater Time 3LVL", 
            SkillDescription = "می‌تونی 20 ثانیه بیشتر زیر آب بمونی",
            Purchase = 34,
            image = "underwater",
            x = 638, -- coordinates in px (left)
            y = 1776, -- coordinates in px (top)
            SkillAbilities = {
                AddUnderWaterTime = 20,
            },
        },
        UnderWaterTime4 = { 
            ConnectLineTo = "UnderWaterTime3",
            SkillName = "UnderWater Time 4LVL", 
            SkillDescription = "می‌تونی 25 ثانیه بیشتر زیر آب بمونی",
            Purchase = 44,
            image = "underwater",
            x = 638, -- coordinates in px (left)
            y = 1776, -- coordinates in px (top)
            SkillAbilities = {
                AddUnderWaterTime = 25,
            },
        },
    },


    Text = {

        ['notenough'] = 'You don\'t have enough Skill Points',
        ['enough'] = 'The skill was applied Skill',

        ['fullhealth'] = "You have full Health",
        ['canuseaddhp'] = "You can use /addhp again",

        ['fullarmor'] = "You have full Armor",
        ['canuseaddarmor'] = "You can use /addarmor again",

        ['notallowed'] = "You are not allowed to use this command",
        ['wait5minutes'] = "5 minutes hasn't passed",

        ['wallrecharging'] = "Defense Wall Recharging!",
        ['wallactive'] = "Defense Wall Active!",
    },
}
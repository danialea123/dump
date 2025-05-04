Config = Config or {}

Config.Companies = {}
Config.RefreshInterval = 120                            -- 120 seconds(default). Recommended: 60 seconds or higher.
Config.Companies.MaxEmployeesToCall = 0                 -- The maximum number of employees(random) to call when calling a company.

Config.Companies.PoliceAlwaysAvailable = true          -- If true, the police company will always appear as online.
Config.Companies.AppearAsAlwaysAvailable = { 'police' } -- The job name of the police job. -- This is used to determine if the police company should always appear as online.

-- Deprecated - Set your job name manually in the config below. This option will be removed in the future.
Config.Companies.PoliceJob = 'police' -- The job name of the police job.

--[[
    The name of the script that will be used for companies funds.
    [*RECOMMENDED*] tgg-banking: If you are using the latest version of tgg-banking. - https://store.teamsgg.com/package/6545202
    * esx_society: If you are using esx_society.
    * qb-management: If you are using qb-management.
    * qb-banking: If you are using the latest version of qb-banking.
    * okokBanking: If you are using the latest version of okokBanking.
    * renewed-banking: If you are using the latest version of renewed-banking.
]]
Config.Companies.Banking = 'esx_society'

Config.Companies.Services = {
    {
        job = Config.Companies.PoliceJob,
        name = "Police",
        icon = "https://media.diamondrp.ir/logo/police.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Mission Row",
            coords = {
                x = 427.04,
                y = -980.4,
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "sheriff",
        name = "Sheriff",
        icon = "https://media.diamondrp.ir/logo/sheriff.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Sheriff Department",
            coords = {
                x = 1856.73,
                y = 3687.81,
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "forces",
        name = "Special Forces",
        icon = "https://media.diamondrp.ir/logo/forces.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Forces Department",
            coords = {
                x = 633.01,
                y = 3.82,
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "fbi",
        name = "FBI",
        icon = "https://media.diamondrp.ir/logo/fbi.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "FBI Department",
            coords = {
                x = 139.26,
                y = -769.34,
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "justice",
        name = "DOJ (Justice)",
        icon = "https://media.diamondrp.ir/logo/justice.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Justice Department",
            coords = {
                x = -550.18,
                y = -202.7
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "ambulance",
        name = "Central Medic",
        icon = "https://media.diamondrp.ir/logo/ambulance.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Eclipse Tower",
            coords = {
                x = -676.29,
                y = 303.6
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "medic",
        name = "Sandy Medic",
        icon = "https://media.diamondrp.ir/logo/medic.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Sandy",
            coords = {
                x = 1777.51,
                y = 3652.44
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "mechanic",
        name = "Central Mechanic",
        icon = "https://media.diamondrp.ir/logo/mechanic.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "LS Customs",
            coords = {
                x = -336.6,
                y = -134.3
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "benny",
        name = "Benny Mechanic",
        icon = "https://media.diamondrp.ir/logo/benny.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Benny Customs",
            coords = {
                x = -560.07,
                y = -1795.24
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "taxi",
        name = "Taxi",
        icon = "https://media.diamondrp.ir/logo/taxi.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Taxi",
            coords = {
                x = 897.04,
                y = -145.04
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
    {
        job = "weazel",
        name = "Weazel News",
        icon = "https://media.diamondrp.ir/logo/weazel.png",
        canCall = false,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Weazel News",
            coords = {
                x = -1717.81,
                y = -741.37
            }
        },
        hasJobActions = false,  -- if true, and the player job is configured here they can see the job actions
        hasBossActions = false, -- if true, and the player job is configured here they can see the boss actions(only if the player hash boss rank)
        management = {
            duty = false,       -- if true, employees can go on/off duty
            -- Boss actions
            deposit = false,    -- if true, the boss can deposit money into the company
            withdraw = false,   -- if true, the boss can withdraw money from the company
            hire = false,       -- if true, the boss can hire employees
            fire = false,       -- if true, the boss can fire employees
            promote = false,    -- if true, the boss can promote employees
        }
    },
}

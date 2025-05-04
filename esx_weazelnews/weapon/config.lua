Configs = {
    Framework = "esx", -- esx/newesx/qb/newqb
    BuyTime = 0, -- Time in seconds to buy items (0 to disable)
    UseWithItem = false, -- If true weapons will be given as items
    RefundPercent = 0.5, -- Percent of money refunded when buying a new weapon
    InteractSettings = {
        command = {
            enabled = true,
            name = "weaponmenu"
        },
        npc = {
            enabled = true,
            model = "s_m_m_ammucountry",
            text = "Press [~g~E~w~] to open the weapon menu",
            coords = {
                vector4(-659.804, -936.421, 21.829 - 0.98, 134.34289550781)
            }
        }
    },
    Weapons = {
        ["equipment"] = {
            label = "Equipment",
            items = {
                {
                    name = "kevlar",
                    label = "Kevlar",
                    amount = 100,
                    price = 0
                },
            }
        },
        ["pistols"] = {
            label = "Pistols",
            items = {
                {
                    name = "weapon_pistol",
                    label = "Pistol",
                    price = 0
                },
                {
                    name = "weapon_combatpistol",
                    label = "Combat Pistol",
                    price = 0
                },
                {
                    name = "weapon_heavypistol",
                    label = "Heavy Pistol",
                    price = 0
                },
                {
                    name = "weapon_appistol",
                    label = "AP Pistol",
                    price = 0
                },
                {
                    name = "weapon_pistol50",
                    label = "Desert-Eagle",
                    price = 0
                },
            }
        },
        ["midtier"] = {
            label = "Mid-Tier",
            items = {
                {
                    name = "weapon_pumpshotgun",
                    label = "Pump Shotgun",
                    price = 0
                },
                {
                    name = "weapon_assaultshotgun",
                    label = "Assault Shotgun",
                    price = 0
                },
                {
                    name = "weapon_microsmg",
                    label = "Micro SMG",
                    price = 0
                },
                {
                    name = "weapon_smg",
                    label = "SMG",
                    price = 0
                },
                {
                    name = "weapon_combatpdw",
                    label = "Combat PDW",
                    price = 0
                },
            }
        },
        ["rifles"] = {
            label = "Rifles",
            items = {
                {
                    name = "weapon_sniperrifle",
                    label = "Sniper Rifle",
                    price = 0
                },
                {
                    name = "weapon_marksmanrifle",
                    label = "Marksman Rifle",
                    price = 0
                },
                {
                    name = "weapon_assaultrifle",
                    label = "Assault Rifle",
                    price = 0
                },
                
                {
                    name = "weapon_bullpuprifle",
                    label = "Bullpup Rifle",
                    price = 0
                },
                {
                    name = "weapon_carbinerifle",
                    label = "Carbine Rifle",
                    price = 0
                },
            }
        },
    }
}
Config = {};
Config.PedModel = GetHashKey("s_m_y_swat_01");
Config.Heading = 260.1967;
Config.StartGunGame = vector3(1387.45,6587.91,23.28)
Config.Blips = true;
Config.Cards = {
    [1] = {path = "Anonymous.gif"},
    [2] = {path = "Lucky Charm.png"},
    [3] = {path = "Psychedelic.gif"},
    [4] = {path = "Rapper.gif"},
    [5] = {path = "Richest.gif"},
    [6] = {path = "Royal.png"},
};
Config.Locations = {
    ["Lodges"] = {
        PVP = {
            [1] = {-692.9200, 5774.7832, 17.3164},
            [2] = {-675.4644, 5787.1787, 17.3310},
            [3] = {-689.7792, 5802.0112, 21.3724},
            [4] = {-697.5415, 5809.1323, 17.3147},
            [5] = {-719.6297, 5816.7017, 17.2874},
        },
    };
    ["Heroin"] ={
        PVP = {
            [1] = {3504.18,3676.03,33.88},
            [2] = {3462.08,3732.95,36.65},
            [3] = {3506.65,3628.6,39.5},
            [4] = {3432.04,3681.2,36.96},
            [5] = {3469.13,3716.24,36.64},
            [6] = {3452.45,3646.13,42.6},
            [7] = {3479.11,3660.72,41.34},
            [8] = {3506.78,3650.13,41.34},
        },
    },
};
Config.GunGameMapRotation = {
    [1] = "Heroin";
    [2] = "Lodges";
}
Config.WinnerGun = GetHashKey("WEAPON_ASSAULTRIFLE");
Config.Guns = {
    [1] = {name = "Pistol", hash = "WEAPON_PISTOL"};
    [2] = {name = "Mini Smg", hash = "WEAPON_minismg"};
    [3] = {name = "Pump Shotgun", hash = "WEAPON_pumpshotgun"};
    [4] = {name = "Heavy Shotgun", hash = "WEAPON_heavyshotgun"};
    [5] = {name = "Musket", hash = "WEAPON_musket"};
    [6] = {name = "Auto Shotgun", hash = "WEAPON_autoshotgun"};
    [7] = {name = "Assault Rifle", hash = "WEAPON_assaultrifle"};
    [8] = {name = "Pistol", hash = "WEAPON_PISTOL"};
    [9] = {name = "Carbinerifle MK2", hash = "WEAPON_carbinerifle_mk2"};
    [10] = {name = "MG", hash = "WEAPON_mg"};
    [11] = {name = "Combat MG", hash = "WEAPON_combatmg"};
    [12] = {name = "Gusenberg", hash = "WEAPON_gusenberg"};
    [13] = {name = "Heavy Sniper", hash = "WEAPON_heavysniper"};
    [14] = {name = "Assault Rifle", hash = "WEAPON_assaultrifle"};
    [15] = {name = "Revolver MK2", hash = "WEAPON_REVOLVER_MK2"};
    [16] = {name = "Assault Rifle", hash = "WEAPON_assaultrifle"};
    [17] = {name = "Pistol-50", hash = "WEAPON_pistol50"};
    [18] = {name = "Appistol", hash = "WEAPON_appistol"};
    [19] = {name = "Heavy Pistol", hash = "WEAPON_heavypistol"};
    [20] = {name = "MG", hash = "WEAPON_mg"};
    [21] = {name = "Micro Smg", hash = "WEAPON_microsmg"};
    [22] = {name = "SMG Mk2", hash = "WEAPON_smg_mk2"};
    [23] = {name = "Assault SMG", hash = "WEAPON_assaultsmg"};
    [24] = {name = "Navy Revolver", hash = "WEAPON_navyrevolver"};
    [25] = {name = "Appistol", hash = "WEAPON_appistol"};
    [26] = {name = "Assault SMG", hash = "WEAPON_assaultsmg"};
    [27] = {name = "Gusenberg ", hash = "WEAPON_gusenberg"};
    [28] = {name = "SMG Mk", hash = "WEAPON_smg_mk2"};
    [29] = {name = "appistol", hash = "WEAPON_appistol"};
    [30] = {name = "battleaxe", hash = "WEAPON_battleaxe"};
};
Config.EffectDict = "scr_indep_fireworks";
Config.particleName = "scr_indep_firework_shotburst";
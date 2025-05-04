----------------------------------------------------------------
-- Copyright © 2019 by Guy Shefer
-- Made By: Guy293
-- GitHub: https://github.com/Guy293
-- Fivem Forum: https://forum.fivem.net/u/guy293/
-- Tweaked by Campinchris (Added ESX only Diff animation for Police and Non Police)
----------------------------------------------------------------

Config 				  = {}
Config.Cooldowns = {
	["police"] = {
		light = 700,
		heavy = 1200
	},
	["civilian"] = {
		light = 1000,
		heavy = 1350
	},
}

-- Add/remove weapon hashes here to be added for holster checks.
Config.Weapons = {
	--[[[GetHashKey("WEAPON_PISTOL")] = "light",
	[GetHashKey("WEAPON_COMBATPISTOL")] = "light",
	[GetHashKey("WEAPON_PISTOL50")] = "light",
	[GetHashKey("WEAPON_SNSPISTOL")] = "light",
	[GetHashKey("WEAPON_HEAVYPISTOL")] = "light",
	[GetHashKey("WEAPON_STUNGUN")] = "light",
	[GetHashKey("WEAPON_REVOLVER")] = "light",]]
	[GetHashKey("WEAPON_COMBATPDW")] = "heavy",
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = "heavy",
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = "heavy",
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = "heavy",
	[GetHashKey("WEAPON_SMG")] = "heavy",
	[GetHashKey("WEAPON_CARBINERIFLE")] = "heavy",
	[GetHashKey("WEAPON_MICROSMG")] = "light",
}
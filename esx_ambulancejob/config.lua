Config                            = {}

Config.DrawDistance               = 15.0

Config.Marker                     = { type = 20, x = 0.6, y = 0.6, z = 0.6, r = 255, g = 255, b = 255, a = 100, rotate = true }

Config.ReviveReward               = 15000  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 15 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 5 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 7000

Config.RespawnPoint = { coords = vector3(-679.71,321.97,78.12), heading = 174.34 }

Config.Hospitals = {
	ambulance = {
		Blip = {
			coords = vector3(-676.18,313.31,83.08),
			sprite = 305,
			scale  = 0.95,
			color  = 1
		},

		Armory = {
			vector3(-679.61,329.01,88.02)
		},

		AmbulanceActions = {
			vector3(-661.76,309.79,92.74) 
		},

		Pharmacies = {
			vector3(-677.07,335.15,83.09)
		},

		CloakRoom = {
			vector3(-663.32,323.22,92.74),
		},

		Vehicles = {
			{
				Spawner = vector3(-670.35,333.08,78.12),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 255, b = 255, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(-668.39,349.13,78.12), heading = 177.45, radius = 2.0 },
				}
			},
			--[[{
				Spawner = vector3(297.55, -569.95, 43.26),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 255, b = 255, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(292.69, -583.39, 43.2), heading = 343.27, radius = 2.0 },
				}
			}]]
		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 1.0, y = 2.0, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(-663.57,361.59,78.12)
			},
			{
				Marker = { type = 24, x = 1.0, y = 2.0, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = true, RegisterSize = 5.0 },
				Deleter = vector3(-644.81,315.36,140.14)
			},
			--[[{
				Marker = { type = 24, x = 1.0, y = 2.0, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(292.69, -583.39, 43.2)
			},]]
		},

		Helicopters = {
			{
				Spawner = vector3(-653.12,322.68,140.14),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 255, b = 255, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(-644.84,315.08,140.14), heading = 353.16, radius = 10.0 }
				}
			},
		},

		--[[FastTravels = {
			{
				From = vector3(329.61, -600.74, 42.28),
				To = { coords = vector3(339.35, -584.14, 74.16), heading = 0.0 },
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},{
				From = vector3(339.35, -584.14, 73.16),
				To = { coords = vector3(329.61, -600.74, 43.28), heading = 0.0 },
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},{
				From = vector3(332.02, -595.48, 42.28),
				To = { coords = vector3(342.28, -585.64, 28.80), heading = 0.0 },
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},{
				From = vector3(342.28, -585.64, 27.80),
				To = { coords = vector3(332.02, -595.48, 43.28), heading = 0.0 },
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},
		},

		FastTravelsPrompt = {
			{
				From = vector3(327.44, -603.32, 42.28),
				To = { coords = vector3(1821.32, 3666.92, 33.29), heading = 0.0 },
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		},]]

	},
	medic = {
		Blip = {
			coords = vector3(1784.28,3651.85,34.85),
			sprite = 305,
			scale  = 0.85,
			color  = 1
		},

		Armory = {
			vector3(1777.88,3649.96,34.85) 
		},

		AmbulanceActions = {
			vector3(1776.53,3664.72,34.85) 
		},

		Pharmacies = {
			vector3(1763.46,3650.86,34.85)
		},

		CloakRoom = {
			vector3(1785.33,3652.54,34.85)
		},

		Vehicles = {
			{
				Spawner = vector3(1762.34,3632.13,34.9),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 255, b = 255, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1764.43,3625.25,34.73), heading = 172.16, radius = 2.0 }
				}
			}
		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 1.0, y = 2.0, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(1772.45,3631.19,34.68)
			},
			{
				Marker = { type = 24, x = 1.0, y = 2.0, z = 0.5, r = 255, g = 0, b = 0, a = 100, rotate = true, RegisterSize = 5.0 },
				Deleter = vector3(1791.44,3605.13,36.3)
			},
		},

		Helicopters = {
			{
				Spawner = vector3(1784.32,3613.21,34.43),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 255, b = 255, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1791.44,3605.13,36.3), heading = 27.56, radius = 10.0 },
				}
			}
		},

		--[[FastTravels = {
		},

		FastTravelsPrompt = {
			{
				From = vector3(1820.74, 3668.01, 33.27),
				To = { coords = vector3(327.44, -603.32, 43.28), heading = 0.0 },
				Marker = { type = 1, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},
		}]]
	}
}

Config.AfterDeathClothe = {
	skin_male = json.decode('{"glasses_1":0,"pants_2":0,"shoes_1":6,"mask_2":0,"mask_1":0,"decals_2":0,"tshirt_2":0,"bproof_1":0,"torso_1":144,"bags_1":0,"glasses_2":0,"chain_2":0,"decals_1":0,"shoes_2":0,"torso_2":0,"bags_2":0,"tshirt_1":15,"chain_1":0,"arms":6,"bproof_2":0,"helmet_1":-1,"pants_1":65,"helmet_2":0}'),
	skin_female = json.decode('{"glasses_1":15,"pants_2":0,"shoes_1":16,"mask_2":0,"mask_1":0,"decals_2":0,"tshirt_2":0,"bproof_1":15,"torso_1":142,"bags_1":0,"glasses_2":2,"chain_2":0,"decals_1":0,"shoes_2":0,"torso_2":0,"bags_2":0,"tshirt_1":15,"chain_1":0,"arms":1,"bproof_2":0,"helmet_1":-1,"pants_1":67,"helmet_2":0}')
}

Config.AuthorizedItems = {
	{ label = 'Ab',  name = 'water', price = 350 },
	{ label = 'Nan', name = 'bread', price = 400 },
}
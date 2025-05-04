Config                            = {}

Config.DrawDistance               = 20.0
Config.MarkerType                 = 21
Config.MarkerTypeveh              = 36
Config.MarkerTypevehdel           = 24
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 150, g = 200, b = 18 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.fbiStations = {
	FBI = {
		Blip = {
			Station = 'FBI Station',
			Pos     = { x = 137.94, y = -768.22, z = 45.75 },
			Sprite  = 210,
			Display = 4,
			Scale   = 0.8,
			Colour  = 40,
		},

		Cloakrooms = {
			{ x = 119.54, y = -729.48, z = 242.20 },
			{ x = 1509.79, y = 768.01, z = 77.43 },
		},

		Stocks = {
			vector3(1860.76, 3688.79, 34.27),
		},

		Armories = {
			vector3(143.66, -762.72, 242.20),
			vector3(1513.46,771.24,77.58),
		},

		Vehicles = {
			{
				Spawner    = vector3(93.26, -719.76, 32.20),
				SpawnPoint = vector3(100.17, -730.37, 32.20),
				Heading    = 337
			},
			{
				Spawner    = vector3(-2342.61,3262.55,32.83),
				SpawnPoint = vector3(-2342.27,3250.43,32.83),
				Heading    = 337
			},
			{
				Spawner    = vector3(1518.59,797.76,77.44),
				SpawnPoint = vector3(1514.35,790.95,77.44),
				Heading    = 146
			},
		},

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK', 				price = 45000 },
			{ name = 'WEAPON_STUNGUN', 					price = 20000 },
			{ name = 'WEAPON_FLASHLIGHT', 				price = 10000 },
			{ name = 'WEAPON_PISTOL', 					price = 500000 },
			{ name = 'WEAPON_SNSPISTOL_MK2', 			price = 600000 },
			{ name = 'WEAPON_COMBATPISTOL', 			price = 700000 },
			{ name = 'WEAPON_PISTOL50', 				price = 450000 },
			{ name = 'WEAPON_HEAVYPISTOL', 				price = 800000 },
			{ name = 'WEAPON_SMG',     					price = 1000000 },
			{ name = 'WEAPON_SPECIALCARBINE',     		price = 1300000 },
			{ name = 'WEAPON_SMOKEGRENADE',     		price = 130000 },
			{ name = 'WEAPON_BZGAS',     				price = 100000 },
			{ name = 'WEAPON_CARBINERIFLE', 			price = 250000 },
			{ name = 'WEAPON_ASSAULTSMG', 				price = 200000 },
			{ name = 'WEAPON_BULLPUPRIFLE', 			price = 250000 },
			{ name = 'WEAPON_PISTOL', 					price = 250000 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2', 			price = 1500000 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',		price = 1300000 },
			{ name = 'WEAPON_TACTICALRIFLE',			price = 1900000 },
			{ name = 'WEAPON_PISTOLXM3',				price = 1700000 },
			{ name = 'WEAPON_ASSAULTSHOTGUN',			price = 1500000 },
		},

		AuthorizedItems = {
			{ label = 'Ab',  name = 'water', price = 350 },
			{ label = 'Nan', name = 'bread', price = 400 },
			{ label = 'Silencer', name = 'silencer', price = 15000 },
			{ label = 'Grip', name = 'grip', price = 15000 },
			{ label = 'Kheshab', name = 'clip', price = 1500 },
			{ label = 'Radio', name = 'radio', price = 15000 },
			{ label = 'Kheshab Ezafe', name = 'eclip', price = 5000 },
			{ label = 'Drum Magazine', name = 'dclip', price = 8000 },
		},

		Helicopters = {
			{
				Spawner    = { x = 145.66, y = -763.74, z = 262.8 },
				SpawnPoint = { x = 127.53, y = -757.77, z = 261.99 },
				Heading    = 214.64
			},
			{
				Spawner    = { x = 1540.2, y = 780.54, z = 94.65 },
				SpawnPoint = { x = 1544.47, y = 774.8, z = 94.65 },
				Heading    = 50.1
			},
		},

		VehicleDeleters = {
			vector3(128.53, -757.77, 262.69),
			vector3(95.2, -716.25, 33.13),
			vector3(100.83, -730.44, 33.13),
			vector3(-2341.27,3250.43,32.83),
			vector3(1544.47,774.8,94.65),
			vector3(1511.06,784.96,77.44)
		},

		BossActions = {
			{ x = 149.2, y = -758.67, z = 242.20 }
		},

		DoorLock = {
			{ x = 126.18, y = -766.19, z=  242.20}
		},
	},
	--[[SHERIFF = {
		Blip = {
			Station = 'Sheriff Station',
			Pos     = { x = 1855.13, y = 3686.33, z = 34.27 },
			Sprite  = 0,
			Display = 0,
			Scale   = 0,
			Colour  = 0,
		},

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK', 	price = 1000 },
			{ name = 'WEAPON_STUNGUN', 		price = 2000 },
			{ name = 'WEAPON_FLASHLIGHT', 	price = 1000 },
			{ name = 'WEAPON_SMOKEGRENADE', price = 5000 },
		},

		AuthorizedItems = {
			{ label = 'Ab',  name = 'water', price = 350 },
			{ label = 'Nan', name = 'bread', price = 400 },
			{ label = 'Silencer', name = 'silencieux', price = 15000 },
			{ label = 'Grip', name = 'grip', price = 15000 },
		},

		Cloakrooms = {
			{ x = 452.28, y = -992.39, z = 29.68 },
		},

		Stocks = {
			{ x = 1855.59, y = 3699.25, z = 34.27 },
		},

		Armories = {
			{ x = 459.32, y = -989.65, z = 29.65 },
		},

		Vehicles = {
			{
				Spawner    = vector3(455.5, -1017.05, 27.4),
				SpawnPoint = vector3(446.06),
				Heading    = 207.75
			},
		},

		Helicopters = {
			{
				Spawner    = vector3(1865.67, 3656.06, 35.35),
				SpawnPoint = vector3(1865.97, 3648.85, 35.25),
				Heading    = 207.26
			},
		},

		VehicleDeleters = {
			vector3(1856.06, 3713.15, 32.29),
			vector3(1870.31, 3651.24, 34.35),
		},

		BossActions = {
			{ x = 448.32, y = -973.15, z = 29.68 }
		}
	}]]
}

Config.AuthorizedWeapons = {
	{
		'WEAPON_PISTOL',
		'WEAPON_STUNGUN'
	},

	{
		'WEAPON_PISTOL50',
		'WEAPON_SMG'
	},
	
	{
		'WEAPON_ASSAULTSMG'
	}
}

Config.AuthorizedHelicopters = {
	cadet = {

	},

	po1 = {

	},

	po2 = {
		{
			model = 'polmav',
			label = 'Police Helicopter'
		}
	},

	po3 = {
		{
			model = 'polmav',
			label = 'Police Helicopter'
		}
	},

	slo = {
		{
			model = 'polmav',
			label = 'Police Helicopter'
		}
	},

	commander = {
		{
			model = 'polmav',
			label = 'Police Helicopter'
		}
	},

	boss = {
		{
			model = 'polmav',
			label = 'Police Helicopter'
		}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	swat_wear = {
		male = json.decode('{"pants_1": 65,"bproof_1": 80,"bproof_2": 0,"mask_1": 159,"chain_1": 3,"shoes_1": 39,"torso_1": 303,"pants_2": 1,"tshirt_2": 0,"torso_2": 18,"shoes_2": 0,"helmet_2": 1,"helmet_1": 123,"arms": 26,"tshirt_1": 46,"mask_2": 25,"chain_2": 0}'),
		female = json.decode('{"pants_1": 90,"bproof_1": 7,"bproof_2": 0,"mask_1": 145,"chain_1": 0,"shoes_1": 24,"torso_1": 212,"pants_2": 1,"tshirt_2": 0,"torso_2": 3,"shoes_2": 0,"helmet_2": 0,"helmet_1": 122,"arms": 27,"tshirt_1": 16,"mask_2": 25,"chain_2": 0}')
	},
	swat_manager_wear = {
		male = json.decode('{"pants_1":19,"bproof_1":9,"bproof_2":0,"mask_1":43,"chain_1":18,"shoes_1":39,"torso_1":2,"pants_2":3,"tshirt_2":0,"torso_2":2,"shoes_2":0,"helmet_2":0,"helmet_1":121,"arms":23,"tshirt_1":28,"mask_2":13,"chain_2":1}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	xray_wear = {
		male = json.decode('{"shoes_2":9,"helmet_2":0,"shoes_1":55,"bproof_1":91, "bproof_2":0,"pants_1":62,"mask_1":0,"helmet_1":-1,"torso_2":0,"torso_1":302,"arms":24,"tshirt_1":15,"chain_2":0,"tshirt_2":0,"pants_2":6,"mask_2":0,"chain_1":0}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	gnd_wear = {
		male = json.decode('{"pants_1":62,"bproof_1":69,"bproof_2":4,"mask_1":43,"chain_1":18,"shoes_1":10,"torso_1":2,"pants_2":0,"tshirt_2":0,"torso_2":5,"shoes_2":0,"helmet_2":2,"helmet_1":62,"arms":23,"tshirt_1":28,"mask_2":19,"chain_2":11}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	gnd_swat_wear = {
		male = json.decode('{"pants_1":19,"bproof_1":69,"bproof_2":4,"mask_1":43,"chain_1":18,"shoes_1":39,"torso_1":2,"pants_2":3,"tshirt_2":0,"torso_2":5,"shoes_2":0,"helmet_2":21,"helmet_1":121,"arms":23,"tshirt_1":28,"mask_2":19,"chain_2":11}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	swat_iaa_wear = {
		male = json.decode('{"shoes_2":0,"helmet_2":0,"shoes_1":39,"bproof_1":9,"bproof_2":0,"pants_1":19,"mask_1":43,"helmet_1":121,"torso_2":17,"torso_1":160,"arms":23,"tshirt_1":28,"chain_2":1,"tshirt_2":0,"pants_2":0,"mask_2":13,"chain_1":18}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	officer_iaa_wear = {
		male = {
			['tshirt_1'] = 16,   ['tshirt_2'] = 0,
			['torso_1'] = 348,   ['torso_2'] = 0,
			['decals_1'] = 0,    ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 24,    ['pants_2'] = 0,
			['shoes_1'] = 40,    ['shoes_2'] = 9,
			['helmet_1'] = -1,   ['helmet_2'] = 0,
			['glasses_1'] = 5,   ['glasses_2'] = 7,
			['chain_1'] = 12,    ['chain_2'] = 5,
			['ears_1'] = 2,      ['ears_2'] = 0,
			['mask_1'] = 0,      ['mask_2'] = 0,
			['bproof_1'] = 22,   ['bproof_2'] = 8
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	swat_hr_wear = {
		male = json.decode('{"shoes_2":0,"helmet_2":3,"shoes_1":25,"bproof_1":67,"bproof_2":0,"pants_1":19,"mask_1":43,"helmet_1":121,"torso_2":8,"torso_1":2,"arms":23,"tshirt_1":28,"chain_2":1,"tshirt_2":0,"pants_2":2,"mask_2":2,"chain_1":18}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	officer_hr_wear = {
		male = json.decode('{"pants_1":62,"bproof_1":0,"bproof_2":0,"mask_1":0,"chain_1":0,"shoes_1":55,"torso_1":73,"pants_2":0,"tshirt_2":0,"torso_2":2,"shoes_2":9,"helmet_2":0,"helmet_1":-1,"arms":30,"tshirt_1":90,"mask_2":0,"chain_2":0}'),
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 2
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 9,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 37,  ['bproof_2'] = 0
		}
	},
}
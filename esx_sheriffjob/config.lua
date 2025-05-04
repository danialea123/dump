Config                            = {}

Config.DrawDistance               = 20.0
Config.MarkerType                 = 21
Config.MarkerTypeveh              = 36
Config.MarkerTypevehdel           = 24
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 255, g = 153, b = 51 }

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

Config.SheriffStations = {
	SHERIFF = {
		Blip = {
			Station = 'Sheriff Station',
			Pos     = { x = 1855.13, y = 3689.33, z = 34.27 },
			Sprite  = 526,
			Display = 4,
			Scale   = 1.1,
			Colour  = 70,
		},

		Cloakrooms = {
			{ x = 1838.42, y = 3678.2, z = 38.94},  
			{ x = -439.19, y = 6011.09, z = 37.0},  
			{ x = 1509.64, y = 767.6572, z = 77.57141},
		},

		Stocks = {
			vector3(1836.99,3682.72,38.93), 
			vector3(-449.47,6015.21,37.0),
		},

		Armories = {
			vector3(1836.99,3682.72,38.93),
			vector3(-449.47,6015.21,37.0),
			vector3(1513.635, 771.6396, 77.57141),
		},

		Vehicles = {
			{
				Spawner    = vector3(1855.89,3687.28,34.33),  -- asli 
				SpawnPoint = vector3(1862.83,3696.59,33.76),
				Heading    = 120.16
			},
			{
				Spawner    = vector3(472.6, -1019.37, 28.14),  -- male pd
				SpawnPoint = vector3(480.66, -1021.04, 28.96),
				Heading    = 269.52
			},
			{
				Spawner    = vector3(-460.49,6028.48,31.49), -- paleto
				SpawnPoint = vector3(-471.45,6034.16,31.34),
				Heading    = 218.83
			},
			{
				Spawner    = vector3(1514.018, 783.4154, 77.6051),
				SpawnPoint = vector3(1517.077, 795.7187, 78.43665),
				Heading    = 148.71
			},
			{
				Spawner    = vector3(-2343.61,3262.55,32.83),
				SpawnPoint = vector3(-2342.27,3250.43,32.83),
				Heading    = 148.71
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
				Spawner    = { x = 1834.43, y = 3678.49, z = 38.93 }, -- asli 
				SpawnPoint = { x = 1832.7 , y = 3668.35, z = 38.93 }, 
				Heading    = 28.5
			},
			{
				Spawner    = { x = -458.014, y = 5987.8, z = 31.31 },  -- paleto
				SpawnPoint = { x = -475.3, y = 5988.51, z = 31.34 },
				Heading    = 321.47
			},
			{
				Spawner    = { x = 1539.626, y = 781.0549, z = 95.55603 }, -- istbazresi
				SpawnPoint = { x = 1544.875, y = 774.4747, z = 95.64026 },
				Heading    = 237.3
			},
		},
		VehicleDeleters = {
			vector3(1859.48,3690.95,33.88), -- asli
			vector3(1831.79,3696.35,34.0),
			vector3(1867.32,3650.62,35.74),
			vector3(1833.42,3668.96,38.93),  -- asli heli
			vector3(-461.82,5993.55,31.25), -- paleto
			vector3(-435.95,6026.58,31.34),
			vector3(-475.3, 5988.51, 31.34),
			vector3(1517.077, 795.7187, 77.43665),  -- ist bazrasi
			vector3(1544.875, 774.4747, 94.64026),
			vector3(-2342.27,3250.43,32.83)
		},

		BossActions = {
			{ x = 1843.88, y = 3684.9, z = 38.93 }, 
			{ x = -432.76, y = 6006.04, z = 36.5 }  
		},
	},
	--[[SHERIFF = {
		Blip = {
			Station = 'Paleto Station',
			Pos     = { x = -445.08, y = 6014.74, z = 31.72 },
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 21,
		},

		--[[AuthorizedWeapons = {
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
			{ x = -433.45, y = 5990.64, z = 30.72 },
		},

		Stocks = {
			{ x = -434.52, y = 6001.37, z = 30.72 },
		},

		Armories = {
			{ x = -425.85, y = 5998.45, z = 30.72 },
		},

		Vehicles = {
			{
				Spawner    = vector3(-445.49, 6023.22, 30.49),
				SpawnPoint = vector3(-438.6, 6029.08, 30.34),
				Heading    = 32.88
			},
		},

		Helicopters = {
			{
				Spawner    = vector3(-458.01, 5987.8, 30.31),
				SpawnPoint = vector3(-475.3, 5988.51, 30.34),
				Heading    = 321.47
			},
		},

		VehicleDeleters = {
			vector3(-456.28, 6001.88, 30.34),
			vector3(-449.14, 6052.84, 30.34),
		},

		BossActions = {
			{ x = -446.2, y = 6013.95, z = 35.69 }
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
			model = 'polmash',
			label = 'Police Helicopter'
		}
	},

	po3 = {
		{
			model = 'polmash',
			label = 'Police Helicopter'
		}
	},

	slo = {
		{
			model = 'polmash',
			label = 'Police Helicopter'
		}
	},

	commander = {
		{
			model = 'polmash',
			label = 'Police Helicopter'
		}
	},

	boss = {
		{
			model = 'polmash',
			label = 'Police Helicopter'
		}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	swat_wear = {
		male = json.decode('{"pants_1": 67,"bproof_1": 22,"bproof_2": 0,"mask_1": 185,"chain_1": 18,"shoes_1": 40,"torso_1": 30,"pants_2": 0,"tshirt_2": 0,"torso_2": 3,"shoes_2": 0,"helmet_2": 0,"helmet_1": 120,"arms": 24,"tshirt_1": 109,"mask_2": 0,"chain_2": 1}'),
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
		male = json.decode('{"shoes_2":1,"helmet_2":0,"shoes_1":50,"bproof_1":30, "bproof_2":2,"pants_1":40,"mask_1":0,"helmet_1":42,"torso_2":0,"torso_1":135,"arms":26,"tshirt_1":15,"chain_2":0,"tshirt_2":0,"pants_2":0,"mask_2":0,"chain_1":14}'),
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
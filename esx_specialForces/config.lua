Config                            = {}

Config.DrawDistance               = 20.0
Config.MarkerType                 = 21
Config.MarkerTypeveh              = 36
Config.MarkerTypevehdel           = 24
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 207, g = 57, b = 238 }

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

Config.ForcesStations = {
	LSPD = {
		Blip = {
			Pos     = { x = 632.2, y = 3.98, z = 82.74 },
			Sprite  = 487,
			Display = 4,
			Scale   = 0.9,
			Colour  = 14,
		},

		Cloakrooms = {
			{ x = 551.32,y = 26.75,z = 69.36},
			{ x = 1509.64, y = 767.6572, z = 76.57141},
		},
		Stocks = {
			vector3(620.0308, 10.77363, 82.06123),
		},
		Armories = {
			vector3(606.84,20.08,82.76),
			vector3(1513.635, 771.6396, 76.57141),
		},

		Vehicles = {
			{
				Spawner    = vector3(534.58,34.18,69.68),
				SpawnPoint = vector3(537.74,20.4,69.51),
				Heading    = 121.99
			},
			{
				Spawner    = vector3(1514.018, 783.4154, 77.6051),
				SpawnPoint = vector3(1517.077, 795.7187, 77.43665),
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
				Spawner    = { x = 1539.626, y = 781.0549, z = 94.55603 },
				SpawnPoint = { x = 1544.875, y = 774.4747, z = 94.64026 },
				Heading    = 237.3
			},
			{
				Spawner    = { x = 592.51, y = -26.98, z = 89.89 },  
				SpawnPoint = { x = 602.83, y = -28.79, z = 91.71 }, 
				Heading    = 245.92
			},
		},

		VehicleDeleters = {
			vector3(515.83,27.27,69.51),
			vector3(522.23,30.63,69.51),
			vector3(602.83,-28.79,91.71),
			vector3(1517.077, 795.7187, 76.43665),
			vector3(1544.875, 774.4747, 94.64026),
			vector3(-2342.27,3250.43,32.83)
		},

		BossActions = {
			{x = 609.36, y = 8.95, z = 91.54}
		},
	},
	LSPD2 = {
		Blip = {
			Pos     = { x = 358.78, y = -1590.65, z = 31.05 },
			Sprite  = 487,
			Display = 4,
			Scale   = 0.9,
			Colour  = 14,
		},

		Cloakrooms = {
			{ x = 362.43, y = -1591.2, z = 25.45},
		},
		Stocks = {
			vector3(620.0308, 10.77363, 82.06123),
		},
		Armories = {
			vector3(364.7,-1603.96,25.45)
		},

		Vehicles = {
			{
				Spawner    = vector3(376.63,-1622.53,29.29),
				SpawnPoint = vector3(380.77,-1625.88,29.29),
				Heading    = 322.45
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

		},

		VehicleDeleters = {
			vector3(380.77,-1625.88,29.29)
		},

		BossActions = {
			{x = 359.19, y = -1590.4, z = 31.05}
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


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	swat_wear = {
		male = json.decode('{"pants_1": 86,"bproof_1": 25,"bproof_2": 0,"mask_1": 16,"chain_1": 0,"shoes_1": 40,"torso_1": 88,"pants_2": 1,"tshirt_2": 1,"torso_2": 3,"shoes_2": 0,"helmet_2": 1,"helmet_1": 95,"arms": 26,"tshirt_1": 54,"mask_2": 1,"chain_2": 0}'),
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
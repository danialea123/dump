Config                            = {}

Config.DrawDistance               = 20.0
Config.MarkerType                 = 21
Config.MarkerTypeveh              = 36
Config.MarkerTypevehdel           = 24
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

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

Config.PoliceStations = {
	LSPD2 = {
		Blip = {
			Pos     = {x = 423.21, y = -978.09, z = 30.71},
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 29,
		},

		Cloakrooms = {
			{ x = 462.29, y = -999.39, z = 30.69 },
			{ x = 1509.64, y = 767.6572, z = 77.57141},
		},

		Stocks = {
			vector3(457.08, -989.74, 30.68),
		},

		Armories = {
			vector3(482.55,-995.56,30.69),
			vector3(1513.635, 771.6396, 77.57141),
		},

		Vehicles = {
			{
				Spawner    = vector3(461.18,-975.27,25.7),
				SpawnPoint = vector3(446.48,-989.03,24.7),
				Heading    = 275.27
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

		AuthorizedWeaponsz = {
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
			-- {
			-- 	Spawner    = { x = 461.42, y = -979.78, z = 43.69 },
			-- 	SpawnPoint = { x = 449.96, y = -981.33, z = 43.69 },
			-- 	Heading    = 90.91
			-- },
			{
				Spawner    = { x = 1539.626, y = 781.0549, z = 94.55603 },
				SpawnPoint = { x = 1544.875, y = 774.4747, z = 94.64026 },
				Heading    = 237.3
			},
		},

		VehicleDeleters = {
			vector3(458.44,-992.57,25.7),
			vector3(458.38,-979.9,25.7),
			vector3(462.57,-1018.93, 28.1),
			vector3(449.96, -981.33, 43.60),  -- heli
			vector3(1517.077, 795.7187, 77.43665),
			vector3(1544.875, 774.4747, 94.64026),
			vector3(-2342.27,3250.43,32.83),
		},

		BossActions = {
			{ x = 462.07, y = -985.42, z = 30.73 }
		},
	},
	--[[LSPD3 = {
	   Blip = {
			Station = 'LSPD Davis',
			Pos     = { x = 360.85, y = -1593.15, z = 25.45 },
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 29,
		},

		AuthorizedWeaponsz = {
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

		Cloakrooms = {
			{ x = 360.85, y = -1593.15, z = 25.45 },
		},

		Stocks = {
			{ x = -549.72, y = -110.69, z = 36.87 },
		},

		Armories = {
			{ x = 361.91, y = -1599.53, z = 25.45 },
		},

		Vehicles = {
			{
				Spawner    = vector3(393.2,-1609.12,29.29),
				SpawnPoint = vector3(392.03,-1620.12,29.29),
				Heading    = 323.16
			},
		},

		Helicopters = {

		},

		VehicleDeleters = {
			vector3(394.48,-1625.64,29.29),
			vector3(398.5,-1621.27,29.29),
		},

		BossActions = {
			{ x = 359.13, y = -1590.18, z = 31.05 }
		}
	}, --]]
	LSPD4 = {
		Blip = {
			Station = 'Centeral LSPD',
			Pos     = { x = -1112.04, y = -824.58, z = 19.32 },
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 29,
		},

		AuthorizedWeaponsz = {
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

		Cloakrooms = {
			{ x = -1084.23, y = -827.73, z = 15.65 },
		},

		Stocks = {
			{ x = -549.72, y = -110.69, z = 36.87 },
		},

		Armories = {
			{ x = -1071.74, y = -812.31, z = 15.64  },
		},

		Vehicles = {
			{
				Spawner    = vector3(-1078.79,-856.27,5.04),
				SpawnPoint = vector3(-1074.17,-864.69,4.87),
				Heading    = 168.93
			},
			{
				Spawner    = vector3(-1131.79,-849.1,13.57),
				SpawnPoint = vector3(-1137.96,-855.26,13.53),
				Heading    = 37.06
			},
		},

		Helicopters = {
			{
				Spawner    = { x = -1105.13, y = -831.04, z = 37.68 },
				SpawnPoint = { x = -1095.35, y = -835.23, z = 37.68 },
				Heading    = 218.47
			},
		},

		VehicleDeleters = {
			vector3(-1127.12,-864.14,13.56),
			vector3(-1049.09,-864.08,5.01),
			vector3(-1049.09,-864.08,5.01),
			vector3(-1069.56,-815.98,7.93),
			vector3(-1095.25,-835.03,37.68),
		},

		BossActions = {
			{ x = -1099.16, y = -830.79, z = 34.28 },
			{ x = -1098.25, y = -825.83, z = 30.96 },
		}
	}
}

Config.AuthorizedWeapons = {
	divisional = {
		swat = {
			{name = 'WEAPON_SNIPERRIFLE', ammo = 20, rank = 12},
			{name = 'WEAPON_ADVANCEDRIFLE', ammo = 150},
			{name = 'WEAPON_MICROSMG', ammo = 150}
		},
	},

	Shared = {
		{ name = 'WEAPON_NIGHTSTICK', ammo = 0 },
		{ name = 'WEAPON_STUNGUN', ammo = 0 },
		{ name = 'WEAPON_FLASHLIGHT', ammo = 0 },
		{ name = 'WEAPON_PISTOL', ammo = 100 },
		{ name = 'WEAPON_SNSPISTOL', ammo = 100 },
		{ name = 'WEAPON_COMBATPISTOL', ammo = 100 },
		{ name = 'WEAPON_HEAVYPISTOL', ammo = 100 },
	},

	cadet = {
		
	},

	po = {

	},

	po2 = {
		{ name = 'WEAPON_SMG', ammo = 150},
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50}
	},

	po3 = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	slo = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	detective = {
		{ name = 'WEAPON_SMG',     ammo = 150},
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	sergeant = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	detective2 = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},


	sergeant2 = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	detective3 = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	lieutenant = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	captain = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},
	
	commander = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},
		
	dchief = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	achief = {
		{ name = 'WEAPON_SMG',     pammo = 150},
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50},
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
	},

	boss = {
		{ name = 'WEAPON_SMG',     ammo = 150 },
		{ name = 'WEAPON_PUMPSHOTGUN', ammo = 50 },
		{ name = 'WEAPON_CARBINERIFLE', ammo = 150},
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
	tre = {
		male = json.decode('{"pants_1": 62,"bproof_1": 38,"bproof_2": 0,"mask_1": 8,"chain_1": 0,"shoes_1": 19,"torso_1": 136,"pants_2": 1,"tshirt_2": 0,"torso_2": 4,"shoes_2": 0,"helmet_2": 0,"helmet_1": 52,"arms": 21,"tshirt_1": 45,"mask_2": 0,"chain_2": 0}')
	},
	riot = {
		male = json.decode('{"pants_1": 80,"bproof_1": 57,"bproof_2": 0,"mask_1": 112,"chain_1": 128,"shoes_1": 40,"torso_1": 197,"pants_2": 0,"tshirt_2": 0,"torso_2": 0,"shoes_2": 0,"helmet_2": 0,"helmet_1": 129,"arms": 24,"tshirt_1": 45,"mask_2": 0,"chain_2": 0}')
	},
	swat_wear = {
		male = json.decode('{"pants_1": 80,"bproof_1": 18,"bproof_2": 4,"mask_1": 43,"chain_1": 18,"shoes_1": 40,"torso_1": 197,"pants_2": 0,"tshirt_2": 3,"torso_2": 0,"shoes_2": 0,"helmet_2": 0,"helmet_1": 121,"arms": 31,"tshirt_1": 42,"mask_2": 13,"chain_2": 1}'),
		female = json.decode('{"pants_1": 90,"bproof_1": 7,"bproof_2": 0,"mask_1": 145,"chain_1": 0,"shoes_1": 24,"torso_1": 212,"pants_2": 1,"tshirt_2": 0,"torso_2": 3,"shoes_2": 0,"helmet_2": 0,"helmet_1": 122,"arms": 27,"tshirt_1": 16,"mask_2": 25,"chain_2": 0}')
	},
	swat_manager_wear = {
		male = json.decode('{"pants_1": 86,"bproof_1": 25,"bproof_2": 0,"mask_1": 16,"chain_1": 0,"shoes_1": 40,"torso_1": 88,"pants_2": 1,"tshirt_2": 1,"torso_2": 3,"shoes_2": 0,"helmet_2": 0,"helmet_1": 123,"arms": 26,"tshirt_1": 54,"mask_2": 1,"chain_2": 0}'),
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
		male = json.decode('{"shoes_2":0,"helmet_2":0,"shoes_1":10,"bproof_1":41, "bproof_2":0,"pants_1":62,"mask_1":0,"helmet_1":95,"torso_2":0,"torso_1":189,"arms":14,"tshirt_1":40,"chain_2":0,"tshirt_2":0,"pants_2":0,"mask_2":0,"chain_1":0}'),
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

exports('getConfig', function()
	return Config
end)
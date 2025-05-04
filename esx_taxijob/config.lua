Config                            = {}
Config.DrawDistance               = 100.0

Config.EndJobMoney				  = 1.5
Config.ReallyDamaged 			  = 30.0
Config.CanceledTimer			  = 60*5
Config.SuccessTimer			      = 60*5
Config.TimeGenerator     	      = 280

Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false

Config.Locale                     = 'en'

Config.AuthorizedVehicles = {
	recrue = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	},
	novice = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	},
	experimente = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	},
	peyk = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	},
	moaven = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	},
	uber = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	},
	boss = {
		{model = 'taxi', label = 'Taxi'},
		{model = 'superd', label = 'Superd'},
		{model = 'btaxi', label = 'Taxi Baller'},
		{model = 'btaxi2', label = 'Taxi Benz'},
		{model = 'jtaxi', label = 'Taxi Jackal'},
		{model = 'taxich', label = 'Taxi Charger'},
	}
}

Config.TaxiJobPeds = {
	'ig_abigail',
	'ig_amandatownley',
	'cs_amandatownley',
	'csb_anita',
	'cs_ashley',
	's_f_y_bartender_01',
	's_f_y_baywatch_01',
	'a_f_m_beach_01',
	'a_f_y_beach_01',
	'a_f_m_bevhills_02',
	'a_f_y_bevhills_01',
	'a_f_y_bevhills_03',
	'a_f_y_bevhills_02',
	'u_f_y_bikerchic',
	'a_f_y_bevhills_04',
	'mp_f_boatstaff_01',
	'ig_bride',
	'csb_bride',
	'a_f_y_business_01',
	'a_f_m_business_02',
	'cs_debra',
	'mp_f_deadhooker',
	'a_f_y_eastsa_02',
	'a_f_y_epsilon_01',
	'a_f_m_fatcult_01',
	'a_f_m_fatbla_01',
	's_f_m_fembarber',
	'a_f_y_golfer_01',
	'cs_gurk',
	'a_f_y_hiker_01',
	'a_m_m_hillbilly_01',
	'a_f_y_hipster_01',
	'a_f_y_hipster_03',
	's_f_y_hooker_01',
	'a_m_y_jetski_01',
	'a_f_y_juggalo_01',
	'ig_kerrymcintosh',
	'a_f_o_ktown_01',
	'g_f_y_lost_01',
	'cs_maryann',
	'ig_michelle',
	'cs_movpremf_01',
	's_f_y_movprem_01',
	'cs_mrsphillips',
	'a_m_y_musclbeac_02',
	'ig_patricia',
	'a_f_y_runner_01',
	's_f_y_stripper_02',
	's_f_y_stripper_01',
	'a_m_y_surfer_01',
	's_f_y_sweatshop_01',
	'mp_f_cocaine_01',
	'u_m_m_streetart_01'
}

Config.AuthorizedItems = {
	{ label = 'Ab',  name = 'water', price = 350 },
	{ label = 'Nan', name = 'bread', price = 400 },
}

Config.Blip = {
	{x = 896.96, y = -141.95, z = 75.91},
	{x = 1691.47, y = 3578.93, z = 35.56},
}

Config.Zones = {
	Taxi = {
		VehicleSpawner = {
			Pos   = {x = 894.53, y = -146.62, z = 69.37}, 
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 36, Rotate = true
		},

		VehicleSpawnPoint = {
			Pos     = {x = 882.77, y = -147.72, z = 69.38}, 
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Type    = -1, Rotate = false,
			Heading = 237.03
		},

		VehicleDeleter = {
			Pos   = {x = 885.74, y = -150.14, z = 68.38}, 
			Size  = {x = 3.0, y = 3.0, z = 0.25},
			Color = {r = 255, g = 0, b = 0},
			Type  = 1, Rotate = false
		},

		TaxiActions = {
			Pos   = {x = 898.14, y = -165.91, z = 74.22},
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 20, Rotate = true
		},

		Cloakroom = {
			Pos     = {x = 901.53, y = -150.94, z = 75.32}, 
			Size    = {x = 1.0, y = 1.0, z = 1.0},
			Color   = {r = 204, g = 204, b = 0},
			Type    = 21, Rotate = true
		},

		StartTaxiJob = {
			Pos     = {x = 878.27, y = -154.98, z = 68.4}, 
			Size    = {x = 1.5, y = 1.5, z = 0.7}, 
			Color   = {r = 204, g = 204, b = 0},
			Type    = 1, Rotate = true,
			SpawnPoint = { coords = {x = 878.27, y = -154.98, z = 68.4}, heading = 241.91 }
		},

		StopTaxiJob = {
			Pos     = {x = 875.27, y = -159.86, z = 68.41}, 
			Size    = {x = 2.0, y = 2.0, z = 0.7},
			Color   = {r = 255, g = 0, b = 0},
			Type    = 1, Rotate = true
		},

		TaxiHeli = {
			Pos     = {x = 897.96, y = -162.76, z = 85.1}, 
			Size    = {x = 1.0, y = 1.0, z = 1.0},
			Color   = {r = 204, g = 204, b = 0},
			Type    = 34, Rotate = true
		},

		DelHeli = {
			Pos     = {x = 897.96, y = -162.76, z = 84.1}, 
			Size    = {x = 5.0, y = 5.0, z = 1.5},
			Color   = {r = 25, g = 150, b = 105},
			Type    = 1, Rotate = true
		},
	},
	TaxiSandy = {
		VehicleSpawner = {
			Pos   = vector3(1699.7, 3592.51, 35.68),
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 36, Rotate = true
		},

		VehicleSpawnPoint = {
			Pos     = vector3(1704.88, 3600.65, 35.43),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Type    = -1, Rotate = false,
			Heading = 209.7
		},

		VehicleDeleter = {
			Pos   = vector3(1695.24, 3590.26, 34.66),
			Size  = {x = 3.0, y = 3.0, z = 0.25},
			Color = {r = 255, g = 0, b = 0},
			Type  = 1, Rotate = false
		},

		TaxiActions = {
			Pos   = vector3(1689.53, 3591.24, 32.89),
			Size  = {x = 1.0, y = 1.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 20, Rotate = true
		},

		Cloakroom = {
			Pos     = vector3(1684.97, 3581.1, 32.87),
			Size    = {x = 1.0, y = 1.0, z = 1.0},
			Color   = {r = 204, g = 204, b = 0},
			Type    = 21, Rotate = true
		},
	},
}

Config.JobLocations = {
	{start_loc = { coords = vector3(64.120, -735.250, 43.190), heading = 72.710 }, end_loc = { coords = vector3(-617.940, 4.2700, 40.720) }},
	{start_loc = { coords = vector3(-237.19,0 -985.91, 28.29), heading = 254.98 }, end_loc = { coords = vector3(-808.790, -227.240, 36.1) }},
	{start_loc = { coords = vector3(130.30, -200.790, 53.510), heading = 352.31 }, end_loc = { coords = vector3(-1322.44, -1288.78, 3.89) }},
	{start_loc = { coords = vector3(412.00, -983.540, 28.420), heading = 81.820 }, end_loc = { coords = vector3(294.210, 176.10, 103.090) }},
	{start_loc = { coords = vector3(294.210, 176.10, 103.090), heading = 156.93 }, end_loc = { coords = vector3(-619.04, -924.84, 21.950) }},
	{start_loc = { coords = vector3(-342.170, -181.13, 37.67), heading = 196.29 }, end_loc = { coords = vector3(104.35, -1323.770, 28.30) }},
	{start_loc = { coords = vector3(788.080, -2123.72, 28.14), heading = 78.310 }, end_loc = { coords = vector3(-68.55, -1744.10, 28.340) }},
	{start_loc = { coords = vector3(267.410, -354.890, 43.80), heading = 154.62 }, end_loc = { coords = vector3(219.69, -1414.18, 28.260) }},
	{start_loc = { coords = vector3(275.87, -591.710, 42.280), heading = 75.270 }, end_loc = { coords = vector3(-1514.41, -452.34, 34.39) }},
	{start_loc = { coords = vector3(214.40, -851.510, 29.250), heading = 337.99 }, end_loc = { coords = vector3(-645.70, -1262.12, 9.510) }},
	{start_loc = { coords = vector3(232.71, -858.260, 28.790), heading = 344.73 }, end_loc = { coords = vector3(1860.55, 3674.07, 32.740) }},
	{start_loc = { coords = vector3(285.14, -1034.60, 28.210), heading = 179.45 }, end_loc = { coords = vector3(-424.57, 6030.67, 30.280) }},
	{start_loc = { coords = vector3(-596.58, -304.906, 33.96), heading = 216.84 }, end_loc = { coords = vector3(1200.4, -328.490, 67.970) }},
	{start_loc = { coords = vector3(194.99, -845.940, 29.890), heading = 340.59 }, end_loc = { coords = vector3(-1510.1, -379.13, 40.370) }},
	{start_loc = { coords = vector3(-617.16, -920.170, 22.40), heading = 97.200 }, end_loc = { coords = vector3(228.15, -367.340, 43.140) }},
	{start_loc = { coords = vector3(14.91, -1375.260, 28.400), heading = 358.91 }, end_loc = { coords = vector3(-772.83, 292.210, 84.680) }},
	{start_loc = { coords = vector3(-1295.21, -1118.15, 5.61), heading = 175.62 }, end_loc = { coords = vector3(267.02, -332.560, 43.920) }},
	{start_loc = { coords = vector3(-1621.77, -531.00, 33.50), heading = 216.42 }, end_loc = { coords = vector3(404.23, -982.650, 28.310) }},
	{start_loc = { coords = vector3(405.88, -1016.80, 28.390), heading = 88.550 }, end_loc = { coords = vector3(1853.34, 3676.67, 32.79 ) }},
	{start_loc = { coords = vector3(392.88, -990.860, 28.420), heading = 271.61 }, end_loc = { coords = vector3(229.640, -54.870, 68.250) }},
	{start_loc = { coords = vector3(229.640, -54.870, 68.250), heading = 158.48 }, end_loc = { coords = vector3(16.02, -1123.520, 27.850) }},
	{start_loc = { coords = vector3(-251.750, 275.030, 90.71), heading = 172.63 }, end_loc = { coords = vector3(293.50, -590.200, 40.700) }},
}
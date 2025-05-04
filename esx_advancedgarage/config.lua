Config = {}
Config.Locale = 'en'

Config.KickPossibleCheaters = true -- If true it will kick the player that tries store a vehicle that they changed the Hash or Plate.
Config.UseCustomKickMessage = true -- If KickPossibleCheaters is true you can set a Custom Kick Message in the locales.

Config.UseDamageMult = true -- If true it costs more to store a Broken Vehicle.
Config.DamageMult = 5 -- Higher Number = Higher Repair Price.

Config.CarPoundPrice      = 20000 -- Car Pound Price.
Config.BoatPoundPrice     = 14000 -- Boat Pound Price.
Config.AircraftPoundPrice = 21000 -- Aircraft Pound Price.

Config.PolicingPoundPrice  = 500 -- Policing Pound Price.
Config.AmbulancePoundPrice = 500 -- Ambulance Pound Price.

Config.UseCarGarages        = true -- Allows use of Car Garages.
Config.UseBoatGarages       = false -- Allows use of Boat Garages.
Config.UseAircraftGarages   = true -- Allows use of Aircraft Garages.
Config.UsePrivateCarGarages = true -- Allows use of Private Car Garages.

Config.DontShowPoundCarsInGarage = false -- If set to true it won't show Cars at the Pound in the Garage.
Config.ShowVehicleLocation       = true -- If set to true it will show the Location of the Vehicle in the Pound/Garage in the Garage menu.
Config.UseVehicleNamesLua        = true -- Must setup a vehicle_names.lua for Custom Addon Vehicles.

Config.ShowGarageSpacer1 = false -- If true it shows Spacer 1 in the List.
Config.ShowGarageSpacer2 = false -- If true it shows Spacer 2 in the List | Don't use if spacer3 is set to true.
Config.ShowGarageSpacer3 = true -- If true it shows Spacer 3 in the List | Don't use if Spacer2 is set to true.

Config.ShowPoundSpacer2 = false -- If true it shows Spacer 2 in the List | Don't use if spacer3 is set to true.
Config.ShowPoundSpacer3 = true -- If true it shows Spacer 3 in the List | Don't use if Spacer2 is set to true.

Config.MarkerType   = 1
Config.DrawDistance = 15.0

Config.BlipGarage = {
	Sprite = 290,
	Color = 38,
	Display = 2,
	Scale = 0.6
}

Config.BlipAircraftGarage = {
	Sprite = 557,
	Color = 3,
	Display = 2,
	Scale = 0.8
}

Config.BlipAircraftPound = {
	Sprite = 307,
	Color = 64,
	Display = 2,
	Scale = 0.8
}

Config.BlipGaragePrivate = {
	Sprite = 290,
	Color = 53,
	Display = 2,
	Scale = 1.0
}

Config.BlipPound = {
	Sprite = 67,
	Color = 64,
	Display = 2,
	Scale = 0.5
}

Config.BlipJobPound = {
	Sprite = 67,
	Color = 49,
	Display = 2,
	Scale = 0.7
}

Config.PointMarker = {
	r = 0, g = 255, b = 0,     -- Green Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.DeleteMarker = {
	r = 255, g = 0, b = 0,     -- Red Color
	x = 3.0, y = 3.0, z = 1.0  -- Big Size Circle
}

Config.PoundMarker = {
	r = 0, g = 0, b = 100,     -- Blue Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.CarGarages = {
	[1] = {
		GaragePoint = {
			vector3(213.82, -809.19, 31.01)
		},
		SpawnPoints = {
			{coords = vector3(232.2581, -804.7963, 30.47172), heading = 70.636, radius = 2.0},
			{coords = vector3(236.50, -792.15, 30.14), heading = 249.21, radius = 2.0},
			{coords = vector3(222.94, -804.57, 30.26), heading = 68.340, radius = 2.0},
			{coords = vector3(225.35, -796.90, 30.26), heading = 68.190, radius = 2.0},
			{coords = vector3(210.0491, -791.2141, 30.92442), heading = 247.53, radius = 2.0},
			{coords = vector3(212.7639, -783.5982, 30.88258), heading = 249.13, radius = 2.0},
			{coords = vector3(214.6838, -778.6893, 30.85705), heading = 253.12, radius = 2.0},
			{coords = vector3(218.4645, -768.6576, 30.82693), heading = 254.77, radius = 2.0},
			{coords = vector3(227.2773, -771.3973, 30.78378), heading = 70.892, radius = 2.0},
			{coords = vector3(224.666, -779.108, 30.75996),   heading = 68.422, radius = 2.0},
			{coords = vector3(221.9533, -786.6368, 30.77018), heading = 73.507, radius = 2.0},
			{coords = vector3(227.6059, -789.1554, 30.68414), heading = 249.49, radius = 2.0},
			{coords = vector3(231.3207, -778.965, 30.71062),  heading = 249.71, radius = 2.0},
			{coords = vector3(243.1645, -777.3601, 30.65439), heading = 68.864, radius = 2.0},
			{coords = vector3(241.0802, -782.2413, 30.60484), heading = 72.249, radius = 2.0},
			{coords = vector3(217.1767, -799.0352, 30.78427), heading = 71.441, radius = 2.0},
		},
	},
	[2] = {
	 	GaragePoint = {
	 		vector3(100.45, -1073.23, 29.37)
	 	},
	 	SpawnPoints = {
	 		{coords = vector3(158.4594, -1081.563, 29.19237), h = 357.80, radius = 2.0},
	 		{coords = vector3(150.9263, -1081.656, 29.21223), h = 358.68, radius = 2.0},
	 		{coords = vector3(139.8231, -1081.497, 29.19292), h = 0.0799, radius = 2.0},
	 		{coords = vector3(128.6842, -1081.486, 29.21223), h = 1.7856, radius = 2.0},
	 		{coords = vector3(119.0647, -1070.142, 29.19238), h = 0.9120, radius = 2.0},
	 		{coords = vector3(125.7476, -1070.137, 29.19238), h = 3.2025, radius = 2.0},
	 		{coords = vector3(135.6896, -1070.172, 29.19238), h = 1.5337, radius = 2.0},
	 		{coords = vector3(107.7828, -1059.901, 29.19237), h = 250.25, radius = 2.0},
	 		{coords = vector3(110.6464, -1052.913, 29.20256), h = 244.78, radius = 2.0},
	 	},
	 	DeletePoint = vector3(166.28, -1075.92, 28.19)
	},
	[3] = {
		GaragePoint = {
			vector3(430.29, -663.41, 29.05)
		},
		SpawnPoints = {
			{coords = vector3(393.3322, -638.8013, 28.50042), heading = 269.52, radius = 2.0},
			{coords = vector3(393.4372, -644.3594, 28.50038), heading = 268.42, radius = 2.0},
			{coords = vector3(393.2879, -649.7462, 28.50035), heading = 269.30, radius = 2.0},
			{coords = vector3(408.4265, -649.4284, 28.50032), heading = 270.13, radius = 2.0},
			{coords = vector3(408.9136, -644.0065, 28.50022), heading = 90.416, radius = 2.0},
			{coords = vector3(408.9124, -636.0379, 28.50008), heading = 92.613, radius = 2.0},
			{coords = vector3(416.1517, -644.0588, 28.50019), heading = 270.65, radius = 2.0},
			{coords = vector3(416.0735, -649.3419, 28.50028), heading = 269.44, radius = 2.0},
			{coords = vector3(416.1242, -654.8481, 28.50038), heading = 268.42, radius = 2.0},
			{coords = vector3(432.8387, -616.2443, 28.50002), heading = 87.125, radius = 2.0},
			{coords = vector3(433.1577, -610.9722, 28.49999), heading = 84.108, radius = 2.0},
			{coords = vector3(433.4878, -605.6785, 28.49991), heading = 83.833, radius = 2.0},
		},
		DeletePoint = vector3(403.71, -627.21, 27.50)
	},
	[4] = {
		GaragePoint = {
			vector3(362.17, 298.66, 103.88)
		},
		SpawnPoints = {
			{coords = vector3(371.1658, 284.7563, 103.2569), heading = 339.05, radius = 2.0},
			{coords = vector3(378.7433, 282.0053, 103.1094), heading = 339.93, radius = 2.0},
			{coords = vector3(378.629, 293.209, 103.1981),   heading = 161.47, radius = 2.0},
			{coords = vector3(386.6349, 290.7559, 103.0504), heading = 159.84, radius = 2.0},
			{coords = vector3(390.8933, 277.0141, 102.9951), heading = 69.394, radius = 2.0},
			{coords = vector3(387.9626, 269.7316, 103.0079), heading = 72.102, radius = 2.0},
			{coords = vector3(375.5584, 265.9799, 103.0185), heading = 341.88, radius = 2.0},
			{coords = vector3(368.1423, 269.067, 103.0565),  heading = 339.70, radius = 2.0},
			{coords = vector3(359.9119, 272.0586, 103.0997), heading = 341.80, radius = 2.0},
			{coords = vector3(357.3742, 282.5386, 103.3973), heading = 251.77, radius = 2.0},
			{coords = vector3(360.1161, 289.962, 103.4993),  heading = 242.85, radius = 2.0},
			{coords = vector3(368.0287, 276.8373, 103.1915), heading = 157.98, radius = 2.0},
			{coords = vector3(375.6338, 273.8992, 103.0741), heading = 159.98, radius = 2.0},
		},
		DeletePoint = vector3(359.49, 270.85, 102.07)
	},
	[5] = {
		GaragePoint = {
			vector3(1737.59, 3710.2, 34.14)
		},
		SpawnPoints = {
			{coords = vector3(1737.84, 3719.28, 34.04), heading = 21.22, radius = 2.0}
		},
		DeletePoint = vector3(1722.66, 3713.74, 33.21)
	},
	[6] = {
		GaragePoint = {
			vector3(1389.02,6505.09,22.85)
		},
		SpawnPoints = {
			{coords = vector3(1407.24,6505.28,22.76), heading = 352, radius = 2.0}
		},
		DeletePoint = vector3(1407.24,6505.28,22.76)
	},
	[7] = {
		GaragePoint = {
			vector3(-340.8753, 266.9168, 85.6795)
		},
		SpawnPoints = {
			{coords = vector3(-349.7998, 275.866, 85.00211),  heading = 267.06, radius = 2.0},
			{coords = vector3(-339.88, 286.8699, 85.47858),   heading = 275.75, radius = 2.0},
			{coords = vector3(-339.8357, 293.8322, 85.48826), heading = 275.75, radius = 2.0},
			{coords = vector3(-329.3275, 295.8687, 86.14475), heading = 92.688, radius = 2.0},
			{coords = vector3(-350.0903, 282.4673, 84.89763), heading = 277.68, radius = 2.0},
			{coords = vector3(-349.946, 289.7906, 84.914),    heading = 270.43, radius = 2.0},
			{coords = vector3(-349.9472, 296.7355, 84.92173), heading = 269.83, radius = 2.0},
			{coords = vector3(-329.1971, 302.2708, 86.15298), heading = 95.987, radius = 2.0},
			{coords = vector3(-329.1987, 289.0107, 86.14388), heading = 95.879, radius = 2.0},
			{coords = vector3(-328.7846, 281.5015, 86.28333), heading = 97.369, radius = 2.0},
			{coords = vector3(-329.0612, 274.498, 86.33112),  heading = 95.908, radius = 2.0},

		},
		DeletePoint = vector3(-334.3748, 299.7621, 85.82845)
	},
	[8] = {
		GaragePoint = {
			vector3(-2030.62, -465.5083, 11.60398)
		},
		SpawnPoints = {
			{coords = vector3(-2017.24, -477.8687, 11.40545), 	heading = 141.019, radius = 2.0},
			{coords = vector3(-2021.741, -473.7934, 11.4089), 	heading = 140.144, radius = 2.0},
			{coords = vector3(-2028.388, -483.311, 11.67701), 	heading = 317.954, radius = 2.0},
			{coords = vector3(-2023.888, -487.553, 11.7028), 	heading = 319.7071, radius = 2.0},
			{coords = vector3(-2015.184, -494.9136, 11.6983), 	heading = 322.374, radius = 2.0},
			{coords = vector3(-2007.75, -485.7318, 11.4097), 	heading = 141.1999, radius = 2.0},
			{coords = vector3(-2042.125, -457.1023, 11.40187), 	heading = 141.62, radius = 2.0},
			{coords = vector3(-2051.615, -449.116, 11.40114), 	heading = 142.302, radius = 2.0},
			{coords = vector3(-2059.115, -457.6228, 11.64432), 	heading = 320.02, radius = 2.0},
		},
		DeletePoint = vector3(-1995.188, -486.848, 11.55072)
	},
	[9] = {
		GaragePoint = {
			vector3(-1184.255, -1509.618, 4.649302)
		},
		SpawnPoints = {
			{coords = vector3(-1180.894, -1486.799, 4.379672), 	heading = 303.21, radius = 2.0},
			{coords = vector3(-1187.514, -1476.142, 4.379671), 	heading = 305.12, radius = 2.0},
			{coords = vector3(-1191.7, -1470.21, 4.379671), 	heading = 300.07, radius = 2.0},
			{coords = vector3(-1192.177, -1482.771, 4.379673), 	heading = 122.17, radius = 2.0},
			{coords = vector3(-1188.691, -1488.25, 4.379672), 	heading = 118.90, radius = 2.0},
			{coords = vector3(-1185.092, -1493.276, 4.379672), 	heading = 128.35, radius = 2.0},
		},
		DeletePoint = vector3(-1201.526, -1487.6, 4.375425)
	},
	[10] = {
		GaragePoint = {
			vector3(-795.9871, -2023.43, 9.168328),
			vector3(-665.99, -2003.29, 7.61),
		},
		SpawnPoints = {
			{coords = vector3(-779.7847, -2040.147, 8.881583), heading = 311.59, radius = 2.0},
			{coords = vector3(-774.8509, -2044.981, 8.891996), heading = 315.91, radius = 2.0},
			{coords = vector3(-770.0355, -2049.891, 8.894156), heading = 314.88, radius = 2.0},
			{coords = vector3(-772.5587, -2023.324, 8.875451), heading = 216.25, radius = 2.0},
			{coords = vector3(-767.5492, -2018.074, 8.876454), heading = 230.37, radius = 2.0},
			{coords = vector3(-762.4937, -2013.345, 8.878029), heading = 227.31, radius = 2.0},
			{coords = vector3(-756.0759, -2004.817, 8.877497), heading = 243.15, radius = 2.0},
			{coords = vector3(-743.1674, -2019.85, 8.896706),  heading = 91.557, radius = 2.0},
			{coords = vector3(-743.2296, -2030.22, 8.907403),  heading = 90.287, radius = 2.0},
			{coords = vector3(-750.9263, -1995.147, 8.877827), heading = 248.82, radius = 2.0},
			{coords = vector3(-748.1131, -1984.401, 8.874047), heading = 259.84, radius = 2.0},
			{coords = vector3(-746.0593, -1974.31, 8.868163),  heading = 257.99, radius = 2.0},
			{coords = vector3(-728.2833, -1972.077, 8.868163), heading = 103.49, radius = 2.0},
			{coords = vector3(-725.8736, -1982.123, 8.869734), heading = 103.89, radius = 2.0},
			{coords = vector3(-724.0767, -1992.29, 8.870519),  heading = 103.75, radius = 2.0},
			{coords = vector3(-721.5682, -2002.262, 8.873919), heading = 102.62, radius = 2.0},
			{coords = vector3(-719.5126, -2012.312, 8.879013), heading = 103.11, radius = 2.0},
			{coords = vector3(-717.1141, -2022.41, 8.883307),  heading = 103.86, radius = 2.0},
			{coords = vector3(-714.9647, -2032.422, 8.885849), heading = 101.81, radius = 2.0},
			{coords = vector3(-710.7976, -2042.833, 8.883529), heading = 116.06, radius = 2.0},
			{coords = vector3(-697.8419, -2048.206, 8.872647), heading = 203.67, radius = 2.0},
			{coords = vector3(-688.3297, -2044.386, 8.871489), heading = 202.85, radius = 2.0},
			{coords = vector3(-667.5652, -2049.738, 8.868678), heading = 158.03, radius = 2.0},
			{coords = vector3(-656.6262, -2051.915, 8.86825),  heading = 183.59, radius = 2.0},
			{coords = vector3(-646.6191, -2048.479, 8.867713), heading = 212.83, radius = 2.0},
			{coords = vector3(-638.9969, -2041.414, 8.867713), heading = 226.98, radius = 2.0},
			{coords = vector3(-631.5502, -2034.177, 8.867713), heading = 225.90, radius = 2.0},
			{coords = vector3(-622.5537, -2047.912, 8.8677),   heading = 46.907, radius = 2.0},
			{coords = vector3(-629.953, -2055.149, 8.867694),  heading = 44.639, radius = 2.0},
			{coords = vector3(-639.6485, -2064.794, 8.867709), heading = 43.775, radius = 2.0},
			{coords = vector3(-649.442, -2074.508, 8.868682),  heading = 43.912, radius = 2.0},
			{coords = vector3(-663.5016, -2079.666, 8.868682), heading = 353.95, radius = 2.0},
			{coords = vector3(-678.4011, -2079.631, 8.868684), heading = 6.6586, radius = 2.0},
			{coords = vector3(-692.4203, -2083.861, 8.868684), heading = 17.896, radius = 2.0},
			{coords = vector3(-712.204, -2083.781, 8.868974),  heading = 315.17, radius = 2.0},
			{coords = vector3(-720.1753, -2076.569, 8.868349), heading = 325.88, radius = 2.0},
			{coords = vector3(-732.5374, -2069.266, 8.881593), heading = 333.62, radius = 2.0},
			{coords = vector3(-742.1569, -2064.814, 8.915189), heading = 339.70, radius = 2.0},
			{coords = vector3(-760.399, -2059.64, 8.898733),   heading = 315.87, radius = 2.0},
			{coords = vector3(-765.0846, -2054.658, 8.89736),  heading = 315.45, radius = 2.0},
			{coords = vector3(-735.23, -2006.009, 8.879359),   heading = 271.24, radius = 2.0},
			{coords = vector3(-735.147, -2016.304, 8.887084),  heading = 268.63, radius = 2.0},
			{coords = vector3(-735.2674, -2026.603, 8.897766), heading = 269.76, radius = 2.0},
			{coords = vector3(-733.2981, -2039.282, 8.909308), heading = 320.83, radius = 2.0},
			{coords = vector3(-725.987, -2046.43, 8.906309),   heading = 318.01, radius = 2.0},
			{coords = vector3(-718.5012, -2053.685, 8.879686), heading = 315.15, radius = 2.0},
			{coords = vector3(-706.5206, -2061.727, 8.871713), heading = 10.080, radius = 2.0},
			{coords = vector3(-696.2973, -2060.677, 8.870184), heading = 5.6008, radius = 2.0},
			{coords = vector3(-685.9189, -2059.769, 8.868367), heading = 4.0978, radius = 2.0},
			{coords = vector3(-688.5663, -2067.633, 8.868699), heading = 178.65, radius = 2.0},
			{coords = vector3(-698.8387, -2068.951, 8.869227), heading = 185.53, radius = 2.0},

		},
		DeletePoint = vector3(-748.09, -2051.39, 8.93)
	},
	[11] = {
		GaragePoint = {
			vector3(-73.2513, -2004.17, 18.27527)
		},
		SpawnPoints = {
			{coords = vector3(-82.11259, -2010.562, 18.01695), heading = 173.91, radius = 2.0},
			{coords = vector3(-89.73438, -2009.785, 18.01695), heading = 176.15, radius = 2.0},
			{coords = vector3(-92.51578, -2003.157, 18.01696), heading = 354.53, radius = 2.0},
			{coords = vector3(-93.47292, -1986.656, 18.01696), heading = 173.79, radius = 2.0},
			{coords = vector3(-67.64745, -1989.429, 18.01696), heading = 172.48, radius = 2.0},
			{coords = vector3(-49.47159, -2004.598, 18.01697), heading = 109.18, radius = 2.0},
			{coords = vector3(-53.91985, -2021.464, 18.01696), heading = 19.301, radius = 2.0},
			{coords = vector3(-80.75897, -2027.827, 18.01696), heading = 350.83, radius = 2.0},
			{coords = vector3(-84.99921, -2004.112, 18.01696), heading = 352.87, radius = 2.0},
			{coords = vector3(-108.2075, -1984.439, 18.01694), heading = 172.24, radius = 2.0},
			{coords = vector3(-78.69685, -1988.422, 18.01697), heading = 167.91, radius = 2.0},
			{coords = vector3(-64.41311, -2025.083, 18.01696), heading = 18.242, radius = 2.0},
			{coords = vector3(-67.4902, -2008.891, 18.01696),  heading = 202.55, radius = 2.0},
			{coords = vector3(-91.7462, -2026.378, 18.01694),  heading = 351.64, radius = 2.0},
			{coords = vector3(-102.864, -2024.731, 18.01697),  heading = 350.80, radius = 2.0},

		},
	},
	[12] = {
		GaragePoint = {
			vector3(638.4481, 206.6077, 97.60417)
		},
		SpawnPoints = {
			{coords = vector3(659.7245, 196.6813, 95.04694), 	heading = 69.137, radius = 2.0},
			{coords = vector3(657.1769, 188.7952, 95.0261), 	heading = 68.399, radius = 2.0},
			{coords = vector3(654.4766, 181.0857, 95.01936), 	heading = 74.425, radius = 2.0},
			{coords = vector3(650.3164, 169.2218, 95.00951), 	heading = 70.745, radius = 2.0},
			{coords = vector3(647.7017, 161.7389, 95.0244), 	heading = 65.121, radius = 2.0},
			{coords = vector3(625.7762, 160.0581, 96.26895), 	heading = 67.822, radius = 2.0},
			{coords = vector3(628.553, 168.609, 96.27444), 		heading = 72.747, radius = 2.0},
			{coords = vector3(632.6517, 180.3055, 96.43604), 	heading = 73.177, radius = 2.0},
			{coords = vector3(618.2274, 168.9074, 97.3628), 	heading = 246.84, radius = 2.0},
			{coords = vector3(622.7493, 180.8668, 97.35644), 	heading = 248.76, radius = 2.0},
			{coords = vector3(625.6158, 188.587, 97.27762), 	heading = 247.05, radius = 2.0},
			{coords = vector3(643.1636, 180.511, 95.81361), 	heading = 247.41, radius = 2.0},
			{coords = vector3(638.5283, 169.0034, 95.86614), 	heading = 250.20, radius = 2.0},
			{coords = vector3(634.3011, 156.7982, 95.62778), 	heading = 252.00, radius = 2.0},

		},
	},
	[13] = {
		GaragePoint = {
			vector3(-348.9511, -874.6491, 31.31801),
			vector3(-281.0107, -888.0642, 31.31801)
		},
		SpawnPoints = {
			{coords = vector3(-332.8058, -877.5726, 31.07234), heading = 166.49, radius = 2.0},
			{coords = vector3(-325.5824, -879.3219, 31.07203), heading = 167.61, radius = 2.0},
			{coords = vector3(-318.3356, -880.8391, 31.08063), heading = 166.81, radius = 2.0},
			{coords = vector3(-300.1407, -884.659, 31.0806),   heading = 169.24, radius = 2.0},
			{coords = vector3(-309.3318, -897.5176, 31.08063), heading = 352.45, radius = 2.0},
			{coords = vector3(-320.2066, -895.25, 31.07318),   heading = 348.29, radius = 2.0},
			{coords = vector3(-331.0915, -892.8999, 31.07144), heading = 348.66, radius = 2.0},
			{coords = vector3(-339.9815, -876.03, 31.07146),   heading = 170.68, radius = 2.0},
			{coords = vector3(-307.3994, -883.1235, 31.08059), heading = 171.31, radius = 2.0},
			{coords = vector3(-289.347, -886.9404, 31.0806),   heading = 169.29, radius = 2.0},
			{coords = vector3(-360.5113, -896.9623, 31.0735),  heading = 271.40, radius = 2.0},
			{coords = vector3(-360.7766, -904.4673, 31.07709), heading = 272.90, radius = 2.0},
			{coords = vector3(-360.468, -915.2971, 31.08063),  heading = 267.37, radius = 2.0},
			{coords = vector3(-360.4835, -926.6339, 31.08063), heading = 270.70, radius = 2.0},
			{coords = vector3(-360.4029, -937.7215, 31.08063), heading = 271.07, radius = 2.0},
			{coords = vector3(-360.6165, -948.8103, 31.08064), heading = 272.64, radius = 2.0},
			{coords = vector3(-335.9799, -948.912, 31.08063),  heading = 69.725, radius = 2.0},
			{coords = vector3(-332.202, -938.4089, 31.08063),  heading = 69.746, radius = 2.0},
			{coords = vector3(-328.2236, -928.0861, 31.08063), heading = 67.969, radius = 2.0},
			{coords = vector3(-319.4127, -935.4865, 31.08063), heading = 250.26, radius = 2.0},
			{coords = vector3(-323.2229, -945.8794, 31.08063), heading = 248.72, radius = 2.0},
			{coords = vector3(-326.9996, -956.2511, 31.08063), heading = 249.04, radius = 2.0},
			{coords = vector3(-339.5147, -975.2825, 31.08062), heading = 338.69, radius = 2.0},
			{coords = vector3(-329.0143, -979.0697, 31.0806),  heading = 340.82, radius = 2.0},
			{coords = vector3(-318.5033, -982.8909, 31.08063), heading = 340.49, radius = 2.0},
			{coords = vector3(-308.3367, -986.947, 31.08062),  heading = 340.10, radius = 2.0},
			{coords = vector3(-311.4702, -961.5643, 31.08063), heading = 69.046, radius = 2.0},
			{coords = vector3(-307.7894, -951.1414, 31.08061), heading = 69.803, radius = 2.0},
			{coords = vector3(-283.6451, -918.6169, 31.0806),  heading = 70.688, radius = 2.0},
			{coords = vector3(-311.7779, -908.3391, 31.07744), heading = 168.33, radius = 2.0},
			{coords = vector3(-322.7913, -905.9731, 31.07828), heading = 172.81, radius = 2.0},
			{coords = vector3(-333.5115, -903.6239, 31.07739), heading = 170.09, radius = 2.0},
			{coords = vector3(-341.8872, -921.4828, 31.08063), heading = 250.53, radius = 2.0},
			{coords = vector3(-345.7167, -932.0018, 31.08063), heading = 252.64, radius = 2.0},
		},
	},
	[14] = {
		GaragePoint = {
			vector3(-753.5982, -77.68767, 41.75397)
		},
		SpawnPoints = {
			{coords = vector3(-748.5602, -79.14582, 41.74929), heading = 27.29, radius = 2.0},
			{coords = vector3(-743.4213, -76.54933, 41.74754), heading = 29.51, radius = 2.0},
			{coords = vector3(-736.7526, -73.18799, 41.74754), heading = 27.82, radius = 2.0},
			{coords = vector3(-727.8351, -68.55073, 41.75047), heading = 28.30, radius = 2.0},
		},
	},
	[15] = {
		GaragePoint = {
			vector3(885.7302, -88.12142, 78.76413),
			vector3(886.2087, -0.7543918, 78.76495)
		},
		SpawnPoints = {
			{coords = vector3(871.5963, -75.31139, 78.76414), heading = 328.74, radius = 2.0},
			{coords = vector3(865.7602, -71.76704, 78.76413), heading = 329.52, radius = 2.0},
			{coords = vector3(859.7916, -68.11678, 78.76413), heading = 325.82, radius = 2.0},
			{coords = vector3(848.565, -59.63052, 78.76411),  heading = 317.48, radius = 2.0},
			{coords = vector3(838.5264, -49.8646, 78.76413),  heading = 311.52, radius = 2.0},
			{coords = vector3(855.6448, -35.40224, 78.76414), heading = 237.28, radius = 2.0},
			{coords = vector3(863.024, -23.8297, 78.76411),   heading = 235.85, radius = 2.0},
			{coords = vector3(868.3088, -14.88135, 78.76411), heading = 237.25, radius = 2.0},
			{coords = vector3(880.6863, -18.52163, 78.76411), heading = 59.707, radius = 2.0},
			{coords = vector3(875.2684, -27.34637, 78.76411), heading = 57.939, radius = 2.0},
			{coords = vector3(869.6462, -36.0075, 78.76411),  heading = 56.387, radius = 2.0},
			{coords = vector3(871.7493, -49.67287, 78.76413), heading = 235.62, radius = 2.0},
			{coords = vector3(877.5402, -40.98933, 78.76413), heading = 238.74, radius = 2.0},
			{coords = vector3(882.9918, -32.19777, 78.76411), heading = 236.38, radius = 2.0},
			{coords = vector3(888.3688, -23.34837, 78.76411), heading = 241.33, radius = 2.0},
			{coords = vector3(895.1014, -35.63438, 78.76411), heading = 55.965, radius = 2.0},
			{coords = vector3(884.1271, -53.08769, 78.76411), heading = 60.293, radius = 2.0},
			{coords = vector3(888.2051, -63.97575, 78.76414), heading = 235.96, radius = 2.0},
			{coords = vector3(895.8737, -52.47546, 78.76412), heading = 240.65, radius = 2.0},
			{coords = vector3(902.7689, -40.54452, 78.76412), heading = 242.08, radius = 2.0},
			{coords = vector3(917.577, -41.56212, 78.76412),  heading = 55.756, radius = 2.0},
			{coords = vector3(906.2439, -58.89404, 78.76412), heading = 56.164, radius = 2.0},
			{coords = vector3(908.4116, -72.4137, 78.76414),  heading = 235.77, radius = 2.0},
			{coords = vector3(915.7483, -60.88608, 78.76411), heading = 238.65, radius = 2.0},
			{coords = vector3(923.3284, -49.21297, 78.76411), heading = 233.82, radius = 2.0},
			{coords = vector3(846.8265, -33.82058, 78.76414), heading = 59.292, radius = 2.0},
			{coords = vector3(852.1807, -24.90623, 78.76414), heading = 60.433, radius = 2.0},
			{coords = vector3(857.7765, -16.33321, 78.76414), heading = 59.345, radius = 2.0},
			{coords = vector3(862.8736, -47.94488, 78.76413), heading = 59.884, radius = 2.0},
			{coords = vector3(901.2267, -27.22141, 78.76414), heading = 58.410, radius = 2.0},
			{coords = vector3(897.6429, -92.28152, 78.76414), heading = 329.25, radius = 2.0},
			{coords = vector3(909.4915, -99.4503, 78.76413),  heading = 325.92, radius = 2.0},
			{coords = vector3(931.1176, -98.36288, 78.76408), heading = 45.261, radius = 2.0},
			{coords = vector3(938.6412, -91.20492, 78.76408), heading = 40.889, radius = 2.0},
			{coords = vector3(924.8058, -85.66843, 78.76408), heading = 237.74, radius = 2.0},
			{coords = vector3(918.1651, -81.57192, 78.76414), heading = 58.252, radius = 2.0},
			{coords = vector3(936.9574, -51.39234, 78.76414), heading = 57.958, radius = 2.0},
			{coords = vector3(934.1835, -29.74992, 78.76414), heading = 148.59, radius = 2.0},
			{coords = vector3(875.2236, 7.152252, 78.76415),  heading = 148.20, radius = 2.0},
		},
	},
	[16] = {
		GaragePoint = {
			vector3(81.63982, 6422.896, 31.67193),
		},
		SpawnPoints = {
			{coords = vector3(61.83202, 6403.732, 31.22579),  heading = 214.63, radius = 2.0},
			{coords = vector3(75.44181, 6401.434, 31.22579),  heading = 132.78, radius = 2.0},
			{coords = vector3(80.81805, 6396.08, 31.22579),   heading = 135.25, radius = 2.0},
			{coords = vector3(63.23303, 6377.547, 31.23986),  heading = 32.163, radius = 2.0},
			{coords = vector3(48.05447, 6390.694, 31.22576),  heading = 218.34, radius = 2.0},
			{coords = vector3(42.65968, 6385.111, 31.22577),  heading = 217.45, radius = 2.0},
			{coords = vector3(37.04106, 6379.479, 31.22577),  heading = 212.77, radius = 2.0},
			{coords = vector3(51.33834, 6365.302, 31.23986),  heading = 217.56, radius = 2.0},
			{coords = vector3(33.7678, 6353.864, 31.23986),   heading = 24.789, radius = 2.0},
			{coords = vector3(27.96858, 6348.903, 31.23985),  heading = 28.851, radius = 2.0},
			{coords = vector3(11.40386, 6352.547, 31.22914),  heading = 212.17, radius = 2.0},
			{coords = vector3(22.32361, 6363.814, 31.22949),  heading = 215.35, radius = 2.0},
			{coords = vector3(80.93638, 6366.134, 31.22885),  heading = 15.799, radius = 2.0},
			{coords = vector3(70.3392, 6361.143, 31.22931),   heading = 14.329, radius = 2.0},
			{coords = vector3(28.08568, 6331.241, 31.23075),  heading = 16.974, radius = 2.0},
			{coords = vector3(17.82603, 6325.708, 31.23107),  heading = 18.438, radius = 2.0},
			{coords = vector3(7.646401, 6319.555, 31.23064),  heading = 17.692, radius = 2.0},
			{coords = vector3(-17.24219, 6324.902, 31.23059), heading = 212.37, radius = 2.0},
			{coords = vector3(-8.827868, 6333.011, 31.23001), heading = 212.55, radius = 2.0},
			{coords = vector3(-0.3106324, 6341.298, 31.2295), heading = 215.49, radius = 2.0},
		},
	},
	[17] = {
		GaragePoint = {
			vector3(1036.606, -763.2388, 57.99303),
		},
		SpawnPoints = {
			{coords = vector3(1022.85, -755.5371, 57.97751),  heading = 229.15, radius = 2.0},
			{coords = vector3(1017.373, -760.612, 57.97248),  heading = 225.47, radius = 2.0},
			{coords = vector3(1016.02, -770.8304, 57.90207),  heading = 308.45, radius = 2.0},
			{coords = vector3(1020.726, -776.636, 57.87875),  heading = 313.11, radius = 2.0},
			{coords = vector3(1025.441, -782.3046, 57.87335), heading = 308.62, radius = 2.0},
			{coords = vector3(1038.046, -791.0107, 57.954),   heading = 0.3842, radius = 2.0},
			{coords = vector3(1046.567, -781.8751, 58.00104), heading = 91.974, radius = 2.0},
			{coords = vector3(1046.503, -774.3381, 58.01773), heading = 94.678, radius = 2.0},
		},
	},
	[18] = {
		GaragePoint = {
			vector3(-306.7648, 6092.532, 31.35242),
		},
		SpawnPoints = {
			{coords = vector3(-323.6044, 6091.055, 31.45349),  heading = 312.14, radius = 2.0},
			{coords = vector3(-326.4264, 6094.391, 31.45349),  heading = 316.21, radius = 2.0},
			{coords = vector3(-330.8176, 6098.558, 31.43665),  heading = 316.72, radius = 2.0},
			{coords = vector3(-328.4967, 6107.156, 31.47034),  heading = 229.34, radius = 2.0},
		},
	},
	[19] = {
		GaragePoint = {
			vector3(-776.8483, -1276.378, 5.134033),
		},
		SpawnPoints = {
			{coords = vector3(-779.222, -1281.165, 4.999268),  heading = 170.72, radius = 2.0},
			{coords = vector3(-782.334, -1280.637, 4.999268),  heading = 169.27, radius = 2.0},
			{coords = vector3(-785.6307, -1279.938, 4.999268),  heading = 170.16, radius = 2.0},
			{coords = vector3(-781.8593, -1295.552, 4.999268),  heading = 356.36, radius = 2.0},
			{coords = vector3(-788.1758, -1294.088, 4.999268),  heading = 349.93, radius = 2.0},
		},
	},
	[20] = {
		GaragePoint = {
			vector3(4818.72,-4309.1,5.51),
		},
		SpawnPoints = {
			{coords = vector3(4821.44,-4304.1,5.39),  heading = 62.72, radius = 2.0},
		},
	},
	[21] = {
		GaragePoint = {
			vector3(4464.46,-4473.29,4.23),
		},
		SpawnPoints = {
			{coords = vector3(4464.47,-4486.9,4.21),  heading = 108.62, radius = 2.0},
		},
	},
}

Config.CarPounds = {
	Pound_LosSantos = {
		PoundPoint = { x = 441.87, y = -979.45, z = 30.69 }, 
		retunrGarage = 1,
	},
	Pound_Sandy = {
		PoundPoint = { x = 1828.72, y = 3682.57, z = 34.34 },
		retunrGarage = 1,
	},
	Pound_Paleto = {
		PoundPoint = { x = -445.3, y = 6014.08, z = 32.29 },
		retunrGarage = 1,
	},
	Pound_Mechanic = {
		PoundPoint = { x = 1319.4, y = -766.89, z = 69.48 },
		retunrGarage = 2,
	},
	Pound_ForcesSantos = {
		PoundPoint = { x = 615.31, y = 1.42, z = 82.76 }, 
		retunrGarage = 1,
	},
	Pound_Benny = {
		PoundPoint = { x = -571.82, y = -1801.59, z = 23.19 },
		retunrGarage = 2,
	},
}

-- End of Cars
-- Start of Boats

Config.BoatGarages = {
	Garage_LSDock = {
		GaragePoint = { x = -735.87, y = -1325.08, z = 0.6 },
		SpawnPoint = { x = -718.87, y = -1320.18, z = -0.47477427124977, h = 45.0 },
		DeletePoint = { x = -731.15, y = -1334.71, z = -0.47477427124977 }
	},
	Garage_SandyDock = {
		GaragePoint = { x = 1333.2, y = 4269.92, z = 30.5 },
		SpawnPoint = { x = 1334.61, y = 4264.68, z = 29.86, h = 87.0 },
		DeletePoint = { x = 1323.73, y = 4269.94, z = 29.86 }
	},
	Garage_PaletoDock = {
		GaragePoint = { x = -283.74, y = 6629.51, z = 6.3 },
		SpawnPoint = { x = -290.46, y = 6622.72, z = -0.47477427124977, h = 52.0 },
		DeletePoint = { x = -304.66, y = 6607.36, z = -0.47477427124977 }
	}
}

Config.BoatPounds = {
	Pound_LSDock = {
		PoundPoint = { x = -738.67, y = -1400.43, z = 4.0 },
		SpawnPoint = { x = -738.33, y = -1381.51, z = 0.12, h = 137.85 }
	},
	Pound_SandyDock = {
		PoundPoint = { x = 1299.36, y = 4217.93, z = 32.91 },
		SpawnPoint = { x = 1294.35, y = 4226.31, z = 29.86, h = 345.0 }
	},
	Pound_PaletoDock = {
		PoundPoint = { x = -270.2, y = 6642.43, z = 6.36 },
		SpawnPoint = { x = -290.38, y = 6638.54, z = -0.47477427124977, h = 130.0 }
	}
}

-- End of Boats
-- Start of Aircrafts

Config.AircraftGarages = {
	Garage_LSAirport = {
		GaragePoint = { x = 1759.5, y = 3299.15, z = 42.17 },
		SpawnPoint = { x = 1707.02, y = 3252.85, z = 41.02, h = 41.11 },
		DeletePoint = { x = 1707.02, y = 3252.85, z = 41.02 }
	},
	Garage_SandyAirport = {
		GaragePoint = { x = -993.97, y = -2945.9, z = 13.96 },
		SpawnPoint = { x = -974.15, y = -3020.17, z = 13.94, h = 60.66 },
		DeletePoint = { x = -974.15, y = -3020.17, z = 13.94 }
	},
	Garage_GrapeseedAirport = {
		GaragePoint = { x = 4461.19, y = -4474.32, z = 4.28 },
		SpawnPoint = { x = 4473.49, y = -4496.62, z = 4.19, h = 115.04 },
		DeletePoint = { x = 4473.49, y = -4496.62, z = 4.19 }
	},
	Garage_CustomPad = {
		GaragePoint = { x = -2026.34, y = 492.79, z = 112.76 },
		SpawnPoint = { x = -2026.34, y = 492.79, z = 112.76, h = 252.84 },
		DeletePoint = { x = -2026.34, y = 492.79, z = 112.76 }
	},
	Garage_BeachPad = {
		GaragePoint = { x = -722.29, y = -1454.01, z = 4.96 },
		SpawnPoint = { x = -724.84, y = -1443.94, z = 5.0, h = 138.32 },
		DeletePoint = { x = -724.84, y = -1443.94, z = 5.0 }
	},
	Garage_ModPad = {
		GaragePoint = { x = -1389.11, y = 6742.51, z = 11.98 },
		SpawnPoint = { x = -1389.11, y = 6742.51, z = 11.98, h = 266.78 },
		DeletePoint = { x = -1389.11, y = 6742.51, z = 11.98 }
	},
	--[[Garage_GangPad = {
		GaragePoint = { x = 3492.69, y = 4915.89, z = 35.36 },
		SpawnPoint = { x = 3492.69, y = 4915.89, z = 35.36, h = 135.97 },
		DeletePoint = { x = 3492.69, y = 4915.89, z = 35.36 }
	}]]
}

Config.AircraftPounds = {
	Pound_LSAirport = {
		PoundPoint = { x = -966.95, y = -2610.95, z = 12.98 },
		SpawnPoint = { x = -1272.27, y = -3382.46, z = 12.94, h = 330.25 }
	}
}

-- End of Aircrafts
-- Start of Private Garages

Config.PrivateCarGarages = {
	-- Maze Bank Building Garages
	Garage_BuenVino = {
		Private = "BuenVino",
		GaragePoint = { x = -2610.18, y = 1678.36, z = 141.87 },
		SpawnPoint = { x = -2601.69, y = 1678.74, z = 141.87, h = 197.28 },
		DeletePoint = { x = -2612.0, y = 1685.33, z = 141.87 }
	},
	Garage_Ershad = {
		Private = "Ershad",
		GaragePoint = { x = -5859.55, y = 1133.76, z = 354.99 },
		SpawnPoint = { x = -5880.88, y = 1136.81, z = 6.6, h = 91.59 },
		DeletePoint = { x = -5870.33, y = 1136.41, z = 7.6 }
	},
	Garage_MichealBuilding = {
		Private = "MichealBuilding",
		GaragePoint = { x = -815.86, y = 183.54, z = 72.413 },
		SpawnPoint = { x = -825.51, y = 179.68, z = 71.44, h = 145.27 },
		DeletePoint = { x = -811.48, y = 187.49, z = 72.48 }
	},
	Garage_MazeBankBuilding = {
		Private = "MazeBankBuilding",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_OldSpiceWarm = {
		Private = "OldSpiceWarm",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_OldSpiceClassical = {
		Private = "OldSpiceClassical",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_OldSpiceVintage = {
		Private = "OldSpiceVintage",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_ExecutiveRich = {
		Private = "ExecutiveRich",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_ExecutiveCool = {
		Private = "ExecutiveCool",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_ExecutiveContrast = {
		Private = "ExecutiveContrast",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_PowerBrokerIce = {
		Private = "PowerBrokerIce",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_PowerBrokerConservative = {
		Private = "PowerBrokerConservative",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	Garage_PowerBrokerPolished = {
		Private = "PowerBrokerPolished",
		GaragePoint = { x = -60.38, y = -790.31, z = 44.23 },
		SpawnPoint = { x = -44.031, y = -787.363, z = 43.186, h = 254.322 },
		DeletePoint = { x = -58.88, y = -778.625, z = 44.175 }
	},
	-- End of Maze Bank Building Garages
	-- Start of Lom Bank Garages
	Garage_LomBank = {
		Private = "LomBank",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBOldSpiceWarm = {
		Private = "LBOldSpiceWarm",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBOldSpiceClassical = {
		Private = "LBOldSpiceClassical",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBOldSpiceVintage = {
		Private = "LBOldSpiceVintage",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBExecutiveRich = {
		Private = "LBExecutiveRich",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBExecutiveCool = {
		Private = "LBExecutiveCool",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBExecutiveContrast = {
		Private = "LBExecutiveContrast",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBPowerBrokerIce = {
		Private = "LBPowerBrokerIce",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBPowerBrokerConservative = {
		Private = "LBPowerBrokerConservative",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	Garage_LBPowerBrokerPolished = {
		Private = "LBPowerBrokerPolished",
		GaragePoint = { x = -1545.17, y = -566.24, z = 25.85 },
		SpawnPoint = { x = -1551.88, y = -581.383, z = 24.708, h = 331.176 },
		DeletePoint = { x = -1538.564, y = -576.049, z = 25.708 }
	},
	-- End of Lom Bank Garages
	-- Start of Maze Bank West Garages
	Garage_MazeBankWest = {
		Private = "MazeBankWest",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWOldSpiceWarm = {
		Private = "MBWOldSpiceWarm",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWOldSpiceClassical = {
		Private = "MBWOldSpiceClassical",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWOldSpiceVintage = {
		Private = "MBWOldSpiceVintage",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWExecutiveRich = {
		Private = "MBWExecutiveRich",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWExecutiveCool = {
		Private = "MBWExecutiveCool",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWExecutiveContrast = {
		Private = "MBWExecutiveContrast",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWPowerBrokerIce = {
		Private = "MBWPowerBrokerIce",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWPowerBrokerConvservative = {
		Private = "MBWPowerBrokerConvservative",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	Garage_MBWPowerBrokerPolished = {
		Private = "MBWPowerBrokerPolished",
		GaragePoint = { x = -1368.14, y = -468.01, z = 31.6 },
		SpawnPoint = { x = -1376.93, y = -474.32, z = 30.5, h = 97.95 },
		DeletePoint = { x = -1362.065, y = -471.982, z = 31.5 }
	},
	-- End of Maze Bank West Garages
	-- Start of Intergrity Way Garages
	Garage_IntegrityWay = {
		Private = "IntegrityWay",
		GaragePoint = { x = -14.1, y = -614.93, z = 35.86 },
		SpawnPoint = { x = -7.351, y = -635.1, z = 34.724, h = 66.632 },
		DeletePoint = { x = -37.575, y = -620.391, z = 35.073 }
	},
	Garage_IntegrityWay28 = {
		Private = "IntegrityWay28",
		GaragePoint = { x = -14.1, y = -614.93, z = 35.86 },
		SpawnPoint = { x = -7.351, y = -635.1, z = 34.724, h = 66.632 },
		DeletePoint = { x = -37.575, y = -620.391, z = 35.073 }
	},
	Garage_IntegrityWay30 = {
		Private = "IntegrityWay30",
		GaragePoint = { x = -14.1, y = -614.93, z = 35.86 },
		SpawnPoint = { x = -7.351, y = -635.1, z = 34.724, h = 66.632 },
		DeletePoint = { x = -37.575, y = -620.391, z = 35.073 }
	},
	-- End of Intergrity Way Garages
	-- Start of Dell Perro Heights Garages
	Garage_DellPerroHeights = {
		Private = "DellPerroHeights",
		GaragePoint = { x = -1477.15, y = -517.17, z = 34.74 },
		SpawnPoint = { x = -1483.16, y = -505.1, z = 31.81, h = 299.89 },
		DeletePoint = { x = -1452.612, y = -508.782, z = 31.582 }
	},
	Garage_DellPerroHeightst4 = {
		Private = "DellPerroHeightst4",
		GaragePoint = { x = -1477.15, y = -517.17, z = 34.74 },
		SpawnPoint = { x = -1483.16, y = -505.1, z = 31.81, h = 299.89 },
		DeletePoint = { x = -1452.612, y = -508.782, z = 31.582 }
	},
	Garage_DellPerroHeightst7 = {
		Private = "DellPerroHeightst7",
		GaragePoint = { x = -1477.15, y = -517.17, z = 34.74 },
		SpawnPoint = { x = -1483.16, y = -505.1, z = 31.81, h = 299.89 },
		DeletePoint = { x = -1452.612, y = -508.782, z = 31.582 }
	},
	-- End of Dell Perro Heights Garages
	-- Start of Milton Drive Garages
	Garage_MiltonDrive = {
		Private = "MiltonDrive",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Modern1Apartment = {
		Private = "Modern1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Modern2Apartment = {
		Private = "Modern2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Modern3Apartment = {
		Private = "Modern3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Mody1Apartment = {
		Private = "Mody1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Mody2Apartment = {
		Private = "Mody2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Mody3Apartment = {
		Private = "Mody3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Vibrant1Apartment = {
		Private = "Vibrant1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Vibrant2Apartment = {
		Private = "Vibrant2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Vibrant3Apartment = {
		Private = "Vibrant3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Sharp1Apartment = {
		Private = "Sharp1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Sharp2Apartment = {
		Private = "Sharp2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Sharp3Apartment = {
		Private = "Sharp3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Monochrome1Apartment = {
		Private = "Monochrome1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Monochrome2Apartment = {
		Private = "Monochrome2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Monochrome3Apartment = {
		Private = "Monochrome3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Seductive1Apartment = {
		Private = "Seductive1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Seductive2Apartment = {
		Private = "Seductive2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Seductive3Apartment = {
		Private = "Seductive3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Regal1Apartment = {
		Private = "Regal1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Regal2Apartment = {
		Private = "Regal2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Regal3Apartment = {
		Private = "Regal3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Aqua1Apartment = {
		Private = "Aqua1Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Aqua2Apartment = {
		Private = "Aqua2Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	Garage_Aqua3Apartment = {
		Private = "Aqua3Apartment",
		GaragePoint = { x = -795.96, y = 331.83, z = 85.5 },
		SpawnPoint = { x = -800.496, y = 333.468, z = 84.5, h = 180.494 },
		DeletePoint = { x = -791.755, y = 333.468, z = 85.5 }
	},
	-- End of Milton Drive Garages
	-- Start of Single Garages
	Garage_RichardMajesticApt2 = {
		Private = "RichardMajesticApt2",
		GaragePoint = { x = -887.5, y = -349.58, z = 34.534 },
		SpawnPoint = { x = -886.03, y = -343.78, z = 33.534, h = 206.79 },
		DeletePoint = { x = -894.324, y = -349.326, z = 34.534 }
	},
	Garage_WildOatsDrive = {
		Private = "WildOatsDrive",
		GaragePoint = { x = -178.65, y = 503.45, z = 136.85 },
		SpawnPoint = { x = -189.98, y = 505.8, z = 133.48, h = 282.62 },
		DeletePoint = { x = -189.28, y = 500.56, z = 133.93 }
	},
	Garage_WhispymoundDrive = {
		Private = "WhispymoundDrive",
		GaragePoint = { x = 123.65, y = 565.75, z = 184.04 },
		SpawnPoint = { x = 130.11, y = 571.47, z = 182.42, h = 270.71 },
		DeletePoint = { x = 131.97, y = 566.77, z = 182.95 }
	},
	Garage_NorthConkerAvenue2044 = {
		Private = "NorthConkerAvenue2044",
		GaragePoint = { x = 348.18, y = 443.01, z = 147.7 },
		SpawnPoint = { x = 358.397, y = 437.064, z = 144.277, h = 285.911 },
		DeletePoint = { x = 351.383, y = 438.865, z = 146.66 }
	},
	Garage_NorthConkerAvenue2045 = {
		Private = "NorthConkerAvenue2045",
		GaragePoint = { x = 370.69, y = 430.76, z = 145.11 },
		SpawnPoint = { x = 392.88, y = 434.54, z = 142.17, h = 264.94 },
		DeletePoint = { x = 389.72, y = 429.95, z = 142.81 }
	},
	Garage_HillcrestAvenue2862 = {
		Private = "HillcrestAvenue2862",
		GaragePoint = { x = -688.71, y = 597.57, z = 143.64 },
		SpawnPoint = { x = -683.72, y = 609.88, z = 143.28, h = 338.06 },
		DeletePoint = { x = -685.259, y = 601.083, z = 143.365 }
	},
	Garage_HillcrestAvenue2868 = {
		Private = "HillcrestAvenue2868",
		GaragePoint = { x = -752.753, y = 624.901, z = 142.2 },
		SpawnPoint = { x = -749.32, y = 628.61, z = 141.48, h = 197.14 },
		DeletePoint = { x = -754.286, y = 631.581, z = 142.2 }
	},
	Garage_HillcrestAvenue2874 = {
		Private = "HillcrestAvenue2874",
		GaragePoint = { x = -859.01, y = 695.95, z = 148.93 },
		SpawnPoint = { x = -863.681, y = 698.72, z = 147.052, h = 341.77 },
		DeletePoint = { x = -855.66, y = 698.77, z = 148.81 }
	},
	Garage_MadWayneThunder = {
		Private = "MadWayneThunder",
		GaragePoint = { x = -1290.95, y = 454.52, z = 97.66 },
		SpawnPoint = { x = -1297.62, y = 459.28, z = 96.48, h = 285.652 },
		DeletePoint = { x = -1298.088, y = 468.952, z = 97.0 }
	},
	Garage_TinselTowersApt12 = {
		Private = "TinselTowersApt12",
		GaragePoint = { x = -616.74, y = 56.38, z = 43.736 },
		SpawnPoint = { x = -620.588, y = 60.102, z = 42.736, h = 109.316 },
		DeletePoint = { x = -621.128, y = 52.691, z = 43.735 }
	},
	-- End of Single Garages
	-- Start of VENT Custom Garages
	Garage_MedEndApartment1 = {
		Private = "MedEndApartment1",
		GaragePoint = { x = 240.23, y = 3102.84, z = 42.49 },
		SpawnPoint = { x = 233.58, y = 3094.29, z = 41.49, h = 93.91 },
		DeletePoint = { x = 237.52, y = 3112.63, z = 42.39 }
	},
	Garage_MedEndApartment2 = {
		Private = "MedEndApartment2",
		GaragePoint = { x = 246.08, y = 3174.63, z = 42.72 },
		SpawnPoint = { x = 234.15, y = 3164.37, z = 41.54, h = 102.03 },
		DeletePoint = { x = 240.72, y = 3165.53, z = 42.65 }
	},
	Garage_MedEndApartment3 = {
		Private = "MedEndApartment3",
		GaragePoint = { x = 984.92, y = 2668.95, z = 40.06 },
		SpawnPoint = { x = 993.96, y = 2672.68, z = 39.06, h = 0.61 },
		DeletePoint = { x = 994.04, y = 2662.1, z = 40.13 }
	},
	Garage_MedEndApartment4 = {
		Private = "MedEndApartment4",
		GaragePoint = { x = 196.49, y = 3027.48, z = 43.89 },
		SpawnPoint = { x = 203.1, y = 3039.47, z = 42.08, h = 271.3 },
		DeletePoint = { x = 192.24, y = 3037.95, z = 43.89 }
	},
	Garage_MedEndApartment5 = {
		Private = "MedEndApartment5",
		GaragePoint = { x = 1724.49, y = 4638.13, z = 43.31 },
		SpawnPoint = { x = 1723.98, y = 4630.19, z = 42.23, h = 117.88 },
		DeletePoint = { x = 1733.66, y = 4635.08, z = 43.24 }
	},
	Garage_MedEndApartment6 = {
		Private = "MedEndApartment6",
		GaragePoint = { x = 1670.76, y = 4740.99, z = 42.08 },
		SpawnPoint = { x = 1673.47, y = 4756.51, z = 40.91, h = 12.82 },
		DeletePoint = { x = 1668.46, y = 4750.83, z = 41.88 }
	},
	Garage_MedEndApartment7 = {
		Private = "MedEndApartment7",
		GaragePoint = { x = 15.24, y = 6573.38, z = 32.72 },
		SpawnPoint = { x = 16.77, y = 6581.68, z = 31.42, h = 222.6 },
		DeletePoint = { x = 10.45, y = 6588.04, z = 32.47 }
	},
	Garage_MedEndApartment8 = {
		Private = "MedEndApartment8",
		GaragePoint = { x = -374.73, y = 6187.06, z = 31.54 },
		SpawnPoint = { x = -377.97, y = 6183.73, z = 30.49, h = 223.71 },
		DeletePoint = { x = -383.31, y = 6188.85, z = 31.49 }
	},
	Garage_MedEndApartment9 = {
		Private = "MedEndApartment9",
		GaragePoint = { x = -24.6, y = 6605.99, z = 31.45 },
		SpawnPoint = { x = -16.0, y = 6607.74, z = 30.18, h = 35.31 },
		DeletePoint = { x = -9.36, y = 6598.86, z = 31.47 }
	},
	Garage_MedEndApartment10 = {
		Private = "MedEndApartment10",
		GaragePoint = { x = -365.18, y = 6323.95, z = 29.9 },
		SpawnPoint = { x = -359.49, y = 6327.41, z = 28.83, h = 218.58 },
		DeletePoint = { x = -353.47, y = 6334.57, z = 29.83 }
	}
	-- End of VENT Custom Garages
}

Config.ParkMeter = {

	-- aparteman
		-- aparteman dakhele shahr
		vec(743.57,-1753.93,29.24,272.51),
		vec(961.21,-201.38,73.11,326.73),
		vec(-796.13,300.93,85.71,179.04),
		--vec(-1277.8,280.59,64.87,198.4), 
		vec(-1412.04,-529.98,31.53,214.0),
		vec(-821.09,-1203.87,6.93,60.29),
		vec(-885.1,-2108.43,8.86,312.76),
		-- aparteman birun shahr
		vec(1113.37,2649.92,38.0,0.21), 		-- kenare mechanicki sandy
		vec(1131.99,2650.26,38.0,358.77),  		-- kenare mechanicki sandy
		vec(-64.14,6346.37,31.49,135.63), 		-- kenare banke paleto
		vec(-77.19,6359.84,31.49,135.92), 		-- kenare banke paleto
	
	-- Robs
		vec(-1309.24,-853.54,15.82,34.25),		-- maze bank
		vec(254.79,189.37,104.84,66.72),		-- Center Bank
		vec(-125.96,6478.01,31.47,134.92),		-- Bank Sheriff
		vec(-2955.91,492.85,15.31,84.07),		-- Bank Sahel
		vec(-1100.78,-259.02,37.69,197.54),		-- Bimeh
		vec(-659.14,-272.73,35.77,25.89),		-- javaheri
		vec(2760.47,3467.4,55.7,246.06),		-- javaheri birond
		vec(298.17,-268.35,54.02,339.93),		-- mini bank 1
		vec(-349.56,-33.56,47.44,71.76),		-- mini bank 2
		vec(-1193.0,-318.24,37.71,31.8),		-- mini bank 3
		vec(1192.75,2695.76,37.93,99.34),		-- mini bank 4
		vec(2415.85,4967.97,46.12,133.79),		-- MyThic
		vec(-1058.31,4905.99,211.24,287.22),	-- Cargo
		vec(820.35,-2052.61,29.41,82.66),		-- jawaheri flat
		vec(822.61,-1973.25,29.18,358.03),		-- jawaheri flat
	
	-- Jobs
		vec(855.07,-1586.73,31.25,7.55),		-- minery
		vec(846.22,-1558.94,29.82,22.56),		-- minery
		vec(1073.65,-1952.1,31.01,147.17),		-- minery
		vec(137.44,-1451.6,29.18,50.07), 		-- post chi
		vec(-1057.8,-2019.48,13.16,136.13),		-- ghasab
		vec(1205.69,-1266.3,35.23,172.99),		-- choob bor
		vec(704.42,-986.2,24.09,275.0),			-- khayat
		vec(550.75,-2307.61,5.88,263.27),		-- sherkat naft 
		vec(-580.76,5251.82,70.47,332.08),		-- shekar
		vec(-590.66,5287.16,70.21,130.67),		-- shekar
	
	-- job dolati
		-- taxi
		vec(388.12,-1633.16,29.29,323.56),
		vec(355.59, -1574.2, 29.3, 322.86),
		-- medic
		vec(-233.88,6307.11,31.33,140.02),
		vec(1829.54,3659.27,33.92,120.39),
		-- MC tune
		vec(168.6,-3048.44,5.84,266.12),
		-- Roberoye Bimarestan 1
		--vec(1161.16,-1423.91,34.48,101.95),
		--vec(1171.79,-1422.88,34.57,87.72),
		--vec(1180.7,-1422.7,34.71,89.88),
		--vec(1116.01,-1443.88,35.96,268.71),
		--vec(1101.86,-1443.69,36.18,266.46),
		--vec(1185.17,-1446.76,34.85,268.48),
		--vec(1173.83,-1446.54,34.7,267.92),
		-- Roberoye Bimarestan 2
		--vec(-1855.9,-401.26,46.2,56.34),
		--vec(-1872.26,-387.16,47.6,50.53),
		--vec(-1886.75,-374.47,48.76,48.59),
		-- FBI NEW
		vec(56.31,-744.78,44.14,347.33),		-- FBI 1
		vec(2544.93,-401.55,92.99,268.19),
		vec(2541.64,-384.07,92.99,262.93),
		vec(2543.94,-367.74,92.99,262.12),
		-- mechanic
		--vec(1360.75,-715.31,66.39,76.15),
		vec(658.46,630.69,128.91,254.27),
		-- weazel
		vec(-563.7,-895.07,24.63,181.39),
		vec(-818.06,-749.55,23.06,87.77),
		-- police
		--vec(-1100.84,-793.02,18.75,308.55),		-- PD 5
		--vec(-1124.83,-813.69,16.29,138.79),		-- PD 5
		vec(835.57,-1264.91,26.32,91.33),		-- detective
		-- fbi
		vec(-486.74,-253.91,35.65,107.15),		-- justic
		vec(-503.32,-260.68,35.5,107.15),		-- justic
		vec(-515.52,-265.68,35.36,107.15),		-- justic
		vec(-530.19,-271.86,35.17,107.15),		-- justic
		--vec(-503.16,-231.67,37.6,67.27),		-- justic heli movaghat
		--vec(-541.93,-253.1,37.26,179.09),		-- justic heli movaghat
		-- Resturan
		vec(-572.7,-1107.92,22.18,179.54),		-- caffe gorbe
		vec(-1328.22,-1095.5,6.87,116.5),		-- burger shop  
		--vec(105.91, -1037.71, 29.21, 335.35),	-- resturan markazi 
		
	-- parking
		vec(890.39,-73.46,78.76,328.86),		-- casino
		vec(-1607.31,172.32,59.58,205.93),		-- resturan
		--vec(253.11,-1507.0,29.05,135.63),		-- praking kenare taxi
		vec(371.29,-951.33,29.36,88.38),		-- parking kenare pd
		vec(202.9,-843.48,30.57,246.63),		-- parking markazi
		vec(219.57,-849.86,30.14,248.64),		-- parking markazi
		vec(237.93,-856.18,29.69,247.86),		-- parking markazi
	
	-- Air & Boots
		vec(-1617.88,-3130.57,13.94,326.61),
		vec(1737.29,3286.85,41.13,180.14),
		vec(-1897.69,-799.44,3.01,317.14),
		vec(1312.11,4318.87,38.13,357.77),
		vec(-195.24,6553.95,11.07,132.45),
		vec(-745.41,-1309.73,5.0,57.23),
		-- Island
		vec(4928.18,-4904.38,3.54,219.24),
		vec(4890.39,-5736.64,26.35,337.73),
	
	-- sahele coca
		vec(-1801.66,-951.94,2.42,291.05),
		vec(-1821.24,-911.46,2.46,285.21),
		vec(-1842.74,-872.03,2.97,305.34),
		vec(-1878.41,-826.49,2.98,323.3),
		vec(-1923.04,-769.08,2.97,318.01),
		vec(-1961.13,-723.6,2.97,318.59),
		--vec(-2004.68,-1043.51,2.02,150.73),	-- dakhele ab
		--vec(-1883.34,-911.62,1.15,128.51),	-- dakhele ab
		--vec(-1862.44,-935.48,0.95,122.2),	-- dakhele ab
		--vec(-1912.33,-871.65,0.85,145.56),	-- dakhele ab
		--vec(-1945.76,-829.28,0.83,158.83),	-- dakhele ab
	
	-- lebas forooshi
		vec(103.14,-1402.86,29.24,147.55),
		vec(-732.04,-144.56,37.17,31.89),
		vec(-146.35,-306.46,38.86,165.0),
		vec(426.93,-820.98,28.93,99.08),
		vec(-817.92,-1090.47,10.97,297.07),
		vec(-1458.96,-225.95,49.14,318.98),
		vec(-4.88,6520.65,31.29,315.92),
		vec(99.29,-206.6,54.49,346.88),
		vec(1678.56,4817.67,42.01,10.51),
		vec(629.24,2727.99,41.73,356.51),
		vec(-1209.58,-787.92,16.86,40.49),
		vec(-3153.7,1060.9,20.67,247.14),
		vec(-1101.0,2694.94,18.92,139.72),
	
	-- arayeshgah
		vec(-829.94,-193.28,37.38,33.62),
		vec(129.42,-1718.19,29.05,53.21),
		vec(-1278.88,-1150.64,6.19,18.1),
		vec(1939.24,3736.46,32.3,212.58),
		vec(1196.18,-469.56,66.15,345.77),
		vec(-29.08,-136.92,57.0,247.3),
		vec(-289.07,6238.94,31.36,315.38),
	
	-- shop
		vec(-46.3,-1738.78,29.15,44.24),
		vec(15.34,-1343.16,29.29,180.9),
		vec(1133.65,-974.33,46.57,277.01),
		vec(1155.18, -337.54, 68.16, 177.28),
		vec(367.9,340.54,103.23,165.49),
		vec(-1468.8,-393.15,38.56,128.09),
		vec(-1249.57,-914.58,11.46,300.63),
		vec(-729.0,-911.89,19.01,178.38),
		vec(-1820.9,808.46,138.78,220.86),
		vec(-2962.81,370.95,14.77,75.35),
		vec(-3050.99,603.42,7.26,289.93),
		vec(-3250.83,987.53,12.49,277.6),
		vec(566.05,2668.39,42.07,6.02),
		vec(2566.47,405.66,108.46,184.57),
		vec(2659.2,3260.97,55.24,241.14),
		vec(1978.65,3748.37,32.18,206.93),
		vec(1689.1,4914.11,42.08,53.09),
		vec(1720.54,6425.48,33.38,153.83),
	
	-- kasti gabz
		vec(-1631.69,-1813.33,0.82,290.17),
		vec(-2171.45,-2586.06,0.1,229.08),
		vec(-1396.43,-3778.88,-0.31,351.56),
		vec(-819.78,-3935.94,0.71,0.46),
		vec(-316.2,-3496.39,0.85,59.05),
		vec(1577.41,-2986.72,0.09,57.58),
		vec(1993.17,-2860.14,1.65,33.94),
		vec(2557.59,-2411.34,0.69,182.46),
		vec(3021.29,-1943.84,0.15,61.26),
		vec(3047.39,-1431.48,1.99,71.9),
		vec(3013.89,-792.65,1.37,81.25),
		vec(3352.16,1153.81,1.44,11.9),
		vec(3418.64,2044.39,1.67,64.75),
		vec(3784.0,2478.04,2.41,86.75),
		vec(4195.92,3302.74,2.36,79.13),
		vec(4195.86,3927.8,2.37,66.52),
		vec(4277.99,4513.56,2.33,113.9),
		vec(3803.96,5707.75,2.37,136.0),
		vec(3556.29,6279.45,2.4,146.33),
		vec(1933.15,6896.29,2.38,195.14),
		vec(1466.42,6858.46,2.38,162.74),
		vec(620.04,7068.4,1.51,122.34),
		vec(-400.84,6881.34,1.82,255.33),
		vec(-836.27,6534.93,1.26,214.33),
		vec(-1166.72,5908.9,0.62,274.85),
		vec(-2320.78,4752.61,2.06,208.05),
		vec(-2793.8,4143.32,0.07,240.87),
		vec(-3263.28,3615.59,1.56,268.0),
		vec(-3143.62,2738.24,1.26,281.99),
		vec(-3281.8,2068.37,1.27,284.94),
		vec(-3506.73,1547.62,0.68,231.17),
		vec(-3458.42,377.12,0.12,269.01),
		vec(-3135.79,-220.88,0.53,6.45),
		vec(-2639.18,-577.0,1.82,329.51),
		vec(3643.17,5275.48,2.44,124.65),
		vec(-2051.37,-1496.57,0.32,19.85),
		
	-- motofareghe
		vec(149.22,-1307.55,29.2,93.14),		-- Club
		vec(-1402.38,-584.55,30.35,297.52),		-- Club
		vec(-1569.63,-865.59,10.06,316.16),		-- CarDelaer
		vec(-54.46,-1110.23,26.44,70.88),		-- car shop
		vec(-198.05,-2003.87,27.62,259.56),		-- game net
		vec(-1574.04,5094.54,26.67,163.68),		-- Paintball
	
		vec(205.74,1222.59,225.46,292.52),		-- mozayede
		vec(242.47,1159.58,225.46,11.42),		-- mozayede
		vec(201.57,1238.21,225.46,292.73),		-- mozayede
		vec(222.29,1245.38,225.46,196.45),		-- mozayede
	
		vec(-180.56, -1150.47, 22.94, 268.58),	-- impound
	
		--drug
		vec(-1070.19,-1668.25,4.42,38.9),		-- ephedrine
		vec(-1079.66,-1657.85,4.4,38.42),		-- ephedrine
		vec(3612.74,3739.31,28.69,327.66),		-- opum
		vec(3619.78,3736.05,28.69,320.84),		-- opum
		vec(2314.75, 2565.84, 46.67, 348.2),	-- marijuana
		vec(2192.22, 5575.07, 53.81, 264.09),	-- shahdane
		vec(2190.67, 5564.66, 53.69, 269.17),	-- shahdane
	
	
	
	-- ekhtesasi
		-- public
		vec(213.28,  -742.88,  33.61, 343.43),
		vec(56.64,  -993.93,   29.3, 247.58),
		vec(119.88,  212.42,  107.26, 249.38),
		vec(76.53,  228.22,  108.72, 251.31),
		vec(-284.87,  6070.1,  31.38, 131.95),
		vec(-302.54,  6052.48,  31.4, 135.76),
		
		vec(-617.17, -921.09,  23.33, 178.76),
		vec(-359.35, -123.62,  38.7, 63.44),
		vec(-619.62, 280.0,  81.58, 165.45),
		vec(-621.31, 58.64,  43.73, 94.5),
		
		vec(-930.47, -465.17, 37.06, 20.99),
		vec(-805.25, -234.38, 37.05, 29.07),
		vec(-200.68, -1297.84, 31.3, 82.24),
		vec(866.87,-2239.71,30.39,269.9),
		vec(853.3,-2180.49,30.61,176.59),
		vec(894.81,-5.52,78.76,148.4),
		vec(1379.39,6586.35,12.06,238.17),
		vec(1375.2,6579.49,12.48,250.78),
		vec(-1513.12,-1310.7,2.08,289.4),
		vec(-1515.67,-1300.21,2.03,271.77),
		vec(-415.72,297.48,83.23,177.0),
		vec(-102.76,-2024.62,18.02,355.16),
		vec(-108.38,-1986.01,18.02,182.77),
		vec(-1686.74,-873.35,8.6,323.12),
		vec(-1670.08,-887.23,8.61,323.7),
		vec(-1733.55,-715.96,10.14,228.91),
		vec(-507.65,-954.14,23.55,183.04),
		vec(-494.77,-953.37,23.55,179.7),
		vec(-464.91,-990.28,24.29,185.25),
		vec(1855.42,3672.02,33.93,184.2),
		vec(1750.49,3613.08,34.81,212.25),
	}

-- End of Private Garages

--[[for k, v in pairs(Config.CarGarages) do
	Config.CarGarages[k-1] = v
end]]

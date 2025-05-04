Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.Locale                     = 'en'

Config.Zones = {
	LSCustoms = {
		Blip = {
			coords  = vector3(1365.07,-709.95,69.92),
			Sprite  = 643,
			Display = 4,
			Scale 	= 0.9,
			Colour  = 5,
		},

		MecanoBossAction = {
			Pos   = {
				vector3(1365.07,-709.95,69.92)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		MecanoActions = {
			Pos   = {
				vector3(1370.51,-712.99,69.92)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		ClotheMenu = {
			Pos   = {
				vector3(1374.22,-768.72,69.92) 
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		VehicleGarage = {
			Pos   = {
				vector3(1348.22,-700.46,69.48)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 36,
			SpawnPoints = {
				{coords = vector3(1338.84,-698.83,69.48), heading = 151.56, radius = 2.0},
			}
		},

		VehicleDeleter = {
			Pos   = {
				vector3(1338.84,-698.83,68.48),
				vector3(1377.92,-741.7,77.39)
			},
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Color = { r = 255, g = 0, b = 0 },
			Type  = 1,
		},

		HeliGarage = {
			Pos   = {
				vector3(1378.92,-734.01,77.39),
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 34,
			SpawnPoints = {
				{coords = vector3(1377.92,-741.7,77.39), heading = 335.2, radius = 2.0},  
			}
		},
	},
	LSCustom = {
		Blip = {
			coords  = vector3(-559.73,-1795.05,26.84),
			Sprite  = 643,
			Display = 4,
			Scale 	= 0.9,
			Colour  = 5,
		},

		MecanoBossAction = {
			Pos   = {
				vector3(-567.08,-1797.37,26.84)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		MecanoActions = {
			Pos   = {
				vector3(-593.4,-1784.29,22.41)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		ClotheMenu = {
			Pos   = {
				vector3(-564.01,-1799.32,22.41)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		VehicleGarage = {
			Pos   = {
				vector3(-555.67,-1807.75,23.15)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 36,
			SpawnPoints = {
				{coords = vector3(-552.67,-1815.72,23.11), heading = 250.87, radius = 2.0},
			}
		},

		VehicleDeleter = {
			Pos   = {
				vector3(-551.47,-1815.47,22.09),
				vector3(-571.94,-1762.88,33.51)
			},
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Color = { r = 255, g = 0, b = 0 },
			Type  = 1,
		},

		HeliGarage = {
			Pos   = {
				vector3(-581.16,-1763.7,33.18),
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 34,
			SpawnPoints = {
				{coords = vector3(-571.94,-1762.88,33.51), heading = 65.42, radius = 2.0},
			}
		},
	},
	LSCustomUP = {
		Blip = {
			coords  = vector3(1178.49, 2646.34, 37.79),
			Sprite  = 643,
			Display = 4,
			Scale 	= 0.9,
			Colour  = 5,
		},

		MecanoBossAction = {
			Pos   = {
				vector3(1181.73,2638.66,38.22)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		MecanoActions = {
			Pos   = {
				vector3(1200.79,2637.48,38.14)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		ClotheMenu = {
			Pos   = {
				vector3(1184.27,2641.69,38.22)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		VehicleGarage = {
			Pos   = {
				vector3(1192.86,2654.3,37.85)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 36,
			SpawnPoints = {
				{coords = vector3(1196.38,2662.16,37.82), heading = 312.41, radius = 2.0},
			}
		},

		VehicleDeleter = {
			Pos   = {
				vector3(1196.38,2662.16,36.82),
			},
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Color = { r = 255, g = 0, b = 0 },
			Type  = 1,
		},

		HeliGarage = {
			Pos   = {
				vector3(1180.48,2644.55,41.88),
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 34,
			SpawnPoints = {
				{coords = vector3(1186.8,2641.04,44.0), heading = 2.37, radius = 2.0},
			}
		},
	},
	--[[Rioters = {
		Blip = {
			coords  = vector3(819.56,-813.69,26.2),
			Sprite  = 643,
			Display = 4,
			Scale 	= 0.9,
			Colour  = 5,
		},

		MecanoBossAction = {
			Pos   = {
				vector3(797.95,-830.33,26.34)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		MecanoActions = {
			Pos   = {
				vector3(835.99,-811.83,26.35)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		ClotheMenu = {
			Pos   = {
				vector3(841.41,-824.58,26.33)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 20,
		},

		VehicleGarage = {
			Pos   = {
				vector3(838.53,-797.25,26.27)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 36,
			SpawnPoints = {
				{coords = vector3(827.49,-791.93,26.22), heading = 117.05, radius = 2.0},
			}
		},

		VehicleDeleter = {
			Pos   = {
				vector3(834.52,-791.57,26.29),
				vector3(830.58,-822.9,33.79),
			},
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Color = { r = 255, g = 0, b = 0 },
			Type  = 1,
		},

		HeliGarage = {
			Pos   = {
				vector3(834.65,-829.18,33.79)
			},
			Size  = { x = 1.0, y = 1.0, z = 1.0 },
			Color = { r = 249, g = 104, b = 0 },
			Type  = 34,
			SpawnPoints = {
				{coords = vector3(830.58,-822.9,33.79), heading = 88.91, radius = 2.0},
			}
		},
	},]]
}

Config.AuthorizedItems = {
  	{ label = 'Ab',  name = 'water', price = 350 },
	{ label = 'Nan', name = 'bread', price = 400 }
}

Config.Vehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo'
}
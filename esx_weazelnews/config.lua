Config = {}
Config.DrawDistance = 15.0

Config.AuthorizedItems = {
	{ label = 'Ab',  name = 'water', price = 350 },
	{ label = 'Nan', name = 'bread', price = 400 },
}

Config.Blip = {
    coords = vector3(-1717.86,-743.38,11.34),
    sprite = 135,
    display = 4,
    scale = 1.0,
    color = 49
}

Config.Zones = {
	VehicleSpawner = {
		Pos   = vector3(-1727.19,-739.55,10.25),
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 255, g = 255, b = 255},
		Type  = 36, Rotate = true
	},

	VehicleSpawnPoint = {
		Pos     = {x = -1735.33, y = -730.36, z = 10.42},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 320.8
	},

	VehicleDeleter = {
		Pos   = {x = -1722.95, y = -730.8, z = 9.29}, 
		Size  = {x = 3.0, y = 3.0, z = 0.60},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = false
	},

	HelicopterSpawn = {
		Pos	  = vector3(-1741.62,-719.89,10.48),
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 255, g = 255, b = 255},
		Type  = 34, Rotate = true
	},

	HelicopterSpawnPoint = {
		Pos	  = vector3(-1741.85,-726.52,11.6), 
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Type  = -1, Rotate = true,
		Heading = 323.25,
	},

	HelicopterDeleter = {
		Pos	  = vector3(-1741.85,-726.52,10.6), 
		Size  = {x = 8.0, y = 8.0, z = 0.60},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = true
	},

	Actions = {
		Pos   = {x = -1708.56, y = -738.7, z = 11.24},  
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 255, g = 255, b = 255},
		Type  = 20, Rotate = true
	},

	Cloakroom = {
		Pos     = {x = -1700.63, y = -737.29, z = 11.24}, 
		Size    = {x = 1.0, y = 1.0, z = 1.0},
		Color 	= {r = 255, g = 255, b = 255},
		Type    = 21, Rotate = true
	},
}
Config = {}
Config.Locale = 'en' -- Language

Config.ServiceExtensionOnEscape = 8 -- Escape Extension
Config.DistanceExtension = 36.0 -- Escape Distance

-- Service Location
Config.ServiceLocation = {x = 1677.93, y = 2533.84, z = 45.56}
-- Release Location
Config.ReleaseLocation = {x = 1846.61, y = 2585.98, z = 45.67}

-- Service Locations
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(1673.70, 2505.23, 45.56) },
	{ type = "cleaning", coords = vector3(1687.22, 2521.43, 45.56) },
	{ type = "cleaning", coords = vector3(1656.61, 2542.17, 45.56) },
	{ type = "cleaning", coords = vector3(1681.04, 2556.45, 45.56) },
	{ type = "cleaning", coords = vector3(1663.26, 2553.03, 45.56) },
	{ type = "cleaning", coords = vector3(1708.22, 2530.18, 45.56) },
	{ type = "gardening", coords = vector3(1695.58, 2511.90, 45.56) },
	{ type = "gardening", coords = vector3(1669.50, 2528.31, 45.56) },
	{ type = "gardening", coords = vector3(1656.59, 2515.28, 45.56) },
	{ type = "gardening", coords = vector3(1702.91, 2548.96, 45.56) },
	{ type = "gardening", coords = vector3(1701.04, 2522.31, 45.56) },
	{ type = "gardening", coords = vector3(1702.61, 2538.42, 45.56) }
}

-- Uniforms
Config.Uniforms = {
	prison_wear = {
		male = json.decode('{"glasses_1":0,"pants_2":2,"shoes_1":6,"arms":0,"pants_1":27,"decals_2":0,"tshirt_2":0,"bproof_1":0,"torso_1":146,"bags_1":0,"glasses_2":0,"tshirt_1":15,"chain_2":0,"shoes_2":0,"mask_2":0,"bags_2":0,"decals_1":0,"chain_1":0,"mask_1":0,"bproof_2":0,"helmet_1":-1,"torso_2":7,"helmet_2":0}'),
		female = json.decode('{"glasses_1":15,"pants_2":4,"shoes_1":5,"arms":0,"pants_1":134,"decals_2":0,"tshirt_2":0,"bproof_1":0,"torso_1":14,"bags_1":0,"glasses_2":1,"tshirt_1":15,"chain_2":0,"shoes_2":0,"mask_2":0,"bags_2":0,"decals_1":0,"chain_1":0,"mask_1":0,"bproof_2":0,"helmet_1":-1,"torso_2":6,"helmet_2":0}')
	}
}
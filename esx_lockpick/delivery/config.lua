ConfigDelivery = {}

-- Locales
ConfigDelivery.Locale = 'en'

-- Delivery Base Location
ConfigDelivery.Base = {
	-- Blip coords
	coords  = vector3(143.97, -1461.82, 28.14),
	-- Scooter mark
	scooter = vector3(146.37, -1459.57, 29.08),
	-- Van mark
	van     = vector3(149.98, -1462.53, 29.09),
	-- Truck mark
	truck   = vector3(155.69, -1466.91, 29.14),
	-- Return vehicle mark
	retveh  = vector3(132.14, -1447.05, 29.26),
	-- Delete vehicle mark
	deleter = vector3(160.11, -1472.34, 29.14),
	-- Heading
	heading = 245.0,
}

-- Min and max deliveries jobs
ConfigDelivery.Deliveries = {
	min = 4,
	max = 8,
}

-- Max time before ending the mission if client goes out of the vehicle (in ms)
ConfigDelivery.LeaveVehEndTime = 90000

-- Vehicle model
ConfigDelivery.Models = {
	scooter = 'faggio2',
	-- van     = 'pony', -- The original game vehicle
	van     = 'speedo2',      -- Chinese car Wuling hong guang S1
	truck   = 'mule',
	vehDoor = {
		-- If this value is true, it will open the vehicle trunk when player remove the goods from the vehicle.
		usingTrunkForVan   = true,  -- If you using original game vehicle, set this to false
		usingTrunkForTruck = false,
	},
}

-- Scale of the arrow, usually not modified it
ConfigDelivery.Scales = {
	scooter = 0.6,
	van     = 3.0,
	truck   = 4.5,
}

-- Rental money of the vehicles
ConfigDelivery.Safe = {
	scooter = 50,
	van     = 50,
	truck   = 50,
}

-- Random parking locations
ConfigDelivery.SpawnPoints = {
	{coords = vector3(147.05,-1446.35,29.14), heading = 141.06, radius = 2.0},
	{coords = vector3(150.81,-1449.58,29.14), heading = 140.5, radius = 2.0},
	{coords = vector3(154.73,-1452.98,29.14), heading = 140.5, radius = 2.0},
	{coords = vector3(158.67,-1455.24,29.14), heading = 139.61, radius = 2.0},
	{coords = vector3(162.79,-1458.11,29.14), heading = 147.88, radius = 2.0},
	{coords = vector3(167.37,-1461.23,29.14), heading = 148.88, radius = 2.0},
} 
 
ConfigDelivery.DeliveryLocationsScooter = {
	{Item1 = vector3(-153.19, -838.31, 30.12),		Item2 = vector3(-143.85, -846.3, 30.6)},
	{Item1 = vector3(37.72, -795.71, 30.93),		Item2 = vector3(44.94, -803.24, 31.52)},
	{Item1 = vector3(111.7, -809.56, 30.71),		Item2 = vector3(102.19, -818.22, 31.35)},
	{Item1 = vector3(132.61, -889.41, 29.71),		Item2 = vector3(121.25, -879.82, 31.12)},
	{Item1 = vector3(54.41, -994.86, 28.7),			Item2 = vector3(43.89, -997.98, 29.34)},
	{Item1 = vector3(142.87, -1026.78, 28.67),		Item2 = vector3(135.44, -1031.19, 29.35)},
	{Item1 = vector3(248.03, -1005.49, 28.61),		Item2 = vector3(254.83, -1013.25, 29.27)},
	{Item1 = vector3(275.68, -929.64, 28.47),		Item2 = vector3(285.55, -937.26, 29.39)},
	{Item1 = vector3(294.29, -877.33, 28.61),		Item2 = vector3(301.12, -883.47, 29.28)},
	{Item1 = vector3(227.21, -705.26, 35.07),		Item2 = vector3(232.2, -714.55, 35.78)},
	{Item1 = vector3(241.06, -667.74, 37.44),		Item2 = vector3(245.5, -677.7, 37.75)},
	{Item1 = vector3(257.05, -628.21, 40.59),		Item2 = vector3(268.54, -640.44, 42.02)},
	{Item1 = vector3(211.33, -605.63, 41.42),		Item2 = vector3(222.32, -596.71, 43.87)},
	{Item1 = vector3(126.27, -555.46, 42.66),		Item2 = vector3(168.11, -567.17, 43.87)},
	{Item1 = vector3(254.2, -377.17, 43.96),		Item2 = vector3(239.06, -409.27, 47.92)},
	{Item1 = vector3(244.49, 349.05, 105.46),		Item2 = vector3(252.86, 357.13, 105.53)},
	{Item1 = vector3(130.77, -307.27, 44.58),		Item2 = vector3(138.67, -285.45, 50.45)},
	{Item1 = vector3(54.44, -280.4, 46.9),			Item2 = vector3(61.86, -260.86, 52.35)},
	{Item1 = vector3(55.15, -225.54, 50.44),		Item2 = vector3(76.29, -233.15, 51.4)},
	{Item1 = vector3(44.6, -138.99, 54.66),			Item2 = vector3(50.78, -136.23, 55.2)},
	{Item1 = vector3(32.51, -162.61, 54.86),		Item2 = vector3(26.84, -168.84, 55.54)},
	{Item1 = vector3(-29.6, -110.84, 56.51),		Item2 = vector3(-23.5, -106.74, 57.04)},
	{Item1 = vector3(-96.86, -86.84, 57.44),		Item2 = vector3(-87.82, -83.55, 57.82)},
	{Item1 = vector3(-146.26, -71.46, 53.9),		Item2 = vector3(-132.92, -69.02, 55.42)},
	{Item1 = vector3(-238.41, 91.97, 68.11),		Item2 = vector3(-263.61, 98.88, 69.3)},
	{Item1 = vector3(-251.45, 20.43, 53.9),			Item2 = vector3(-273.35, 28.21, 54.75)},
	{Item1 = vector3(-322.4, -10.06, 47.42),		Item2 = vector3(-315.48, -3.76, 48.2)},
	{Item1 = vector3(-431.22, 14.6, 45.5),			Item2 = vector3(-424.83, 21.74, 46.27)},
	{Item1 = vector3(-497.33, -8.38, 44.33),		Item2 = vector3(-500.95, -18.65, 45.13)},
	{Item1 = vector3(-406.69, -44.87, 45.13),		Item2 = vector3(-429.07, -24.12, 46.23)},
	{Item1 = vector3(-433.94, -76.33, 40.93),		Item2 = vector3(-437.89, -66.91, 43)},
	{Item1 = vector3(-583.22, -154.84, 37.51),		Item2 = vector3(-582.8, -146.8, 38.23)},
	{Item1 = vector3(-613.68, -213.46, 36.51),		Item2 = vector3(-622.23, -210.97, 37.33)},
	{Item1 = vector3(-582.44, -322.69, 34.33),		Item2 = vector3(-583.02, -330.38, 34.97)},
	{Item1 = vector3(-658.25, -329, 34.2),			Item2 = vector3(-666.69, -329.06, 35.2)},
	{Item1 = vector3(-645.84, -419.67, 34.1),		Item2 = vector3(-654.84, -414.21, 35.45)},
	{Item1 = vector3(-712.7, -668.08, 29.81),		Item2 = vector3(-714.58, -675.37, 30.63)},
	{Item1 = vector3(-648.24, -681.53, 30.61),		Item2 = vector3(-656.77, -678.12, 31.46)},
	{Item1 = vector3(-648.87, -904.3, 23.8),		Item2 = vector3(-660.88, -900.72, 24.61)},
	{Item1 = vector3(-529.01, -848.03, 29.26),		Item2 = vector3(-531.0, -854.04, 29.79)},
}

-- Random delivery locations of van
ConfigDelivery.DeliveryLocationsVan = {
	{Item1 = vector3(-59.74,-1741.2,29.32),		   	Item2 = vector3(-40.61,-1747.48,29.3)},
	{Item1 = vector3(357.43,320.41,103.76),			Item2 = vector3(371.52,341.5,103.17)},
	{Item1 = vector3(-699.93,-948.85,19.56),		Item2 = vector3(-702.75,-917.57,19.21)},
	{Item1 = vector3(-1250.17,-909.28,11.41),		Item2 = vector3(-1231.93,-910.27,11.8)},
	{Item1 = vector3(-1480.02,-407.79,37.18),		Item2 = vector3(-1481.46,-395.48,39.09)},
	{Item1 = vector3(1144.04,-969.45,46.86),		Item2 = vector3(1137.2,-975.64,46.51)},
	{Item1 = vector3(1177.17,-314.34,69.18),		Item2 = vector3(1164.77,-310.53,69.37)},
	{Item1 = vector3(-1145.42, -1590.97, 4.06),		Item2 = vector3(-1150.31, -1601.7, 4.39)},
	{Item1 = vector3(48.18, -992.62, 29.03),		Item2 = vector3(38.41, -1005.3, 29.48)},
	{Item1 = vector3(370.05, -1036.4, 28.99),		Item2 = vector3(376.7, -1028.82, 29.34)},
	{Item1 = vector3(785.95, -761.67, 26.33),		Item2 = vector3(797.0, -757.31, 26.89)},
	{Item1 = vector3(41.53, -138.21, 55.08),		Item2 = vector3(50.96, -135.49, 55.2)},
	{Item1 = vector3(106.8, 304.21, 109.81),		Item2 = vector3(90.86, 298.51, 110.21)},
	{Item1 = vector3(-565.73, 268.54, 82.55),		Item2 = vector3(-564.58, 274.61, 83.02)},
}

-- Random delivery locations of truck
ConfigDelivery.DeliveryLocationsTruck = {
	{Item1 = vector3(-1395.82, -653.76, 28.91),		Item2 = vector3(-1413.43, -635.47, 28.67)},
	{Item1 = vector3(164.18, -1280.21, 29.38),		Item2 = vector3(136.5, -1278.69, 29.36)},
	{Item1 = vector3(75.71, 164.41, 104.93),		Item2 = vector3(78.55, 180.44, 104.63)},
	{Item1 = vector3(-226.62, 308.87, 92.4),		Item2 = vector3(-229.54, 293.59, 92.19)},
	{Item1 = vector3(-365.87, 297.27, 85.04),		Item2 = vector3(-370.5, 277.98, 86.42)},
	{Item1 = vector3(-403.95, 196.11, 82.67),		Item2 = vector3(-395.17, 208.6, 83.59)},
	{Item1 = vector3(-412.26, 297.95, 83.46),		Item2 = vector3(-427.08, 294.19, 83.23)},
	{Item1 = vector3(-606.23, -901.52, 25.39),		Item2 = vector3(-592.48, -892.76, 25.93)},
	{Item1 = vector3(-837.03, -1142.46, 7.44),		Item2 = vector3(-841.89, -1127.91, 6.97)},
	{Item1 = vector3(-1061.56, -1382.19, 5.44),		Item2 = vector3(-1039.38, -1396.88, 5.55)},
	{Item1 = vector3(156.41, -1651.21, 29.53),		Item2 = vector3(169.11, -1633.38, 29.29)},
	{Item1 = vector3(-541.1,292.3,82.85),			Item2 = vector3(-547.23,291.6,83.02)},
}

-- Player outfit of scooter
ConfigDelivery.OutfitScooter = {
	[1]  = {drawables = 0,    texture = 0},
	[3]  = {drawables = 66,   texture = 0},
	[4]  = {drawables = 97,   texture = 3},
	[5]  = {drawables = 0,    texture = 0},
	[6]  = {drawables = 32,   texture = 14},
	[7]  = {drawables = 0,    texture = 0},
	[8]  = {drawables = 15,   texture = 0},
	[9]  = {drawables = 0,    texture = 0},
	[11] = {drawables = 184,  texture = 0},
	[12] = {drawables = 18,   texture = 5},
	[13] = {drawables = 1280, texture = 2},
}

-- Player outfit of scooter (female)
ConfigDelivery.OutfitScooterF = {
	[1]  = {drawables = 0,    texture = 0},
	[3]  = {drawables = 9,    texture = 0},
	[4]  = {drawables = 11,   texture = 3},
	[5]  = {drawables = 0,    texture = 0},
	[6]  = {drawables = 11,   texture = 2},
	[7]  = {drawables = 0,    texture = 0},
	[8]  = {drawables = 13,   texture = 0},
	[9]  = {drawables = 0,    texture = 0},
	[11] = {drawables = 184,  texture = 0},
	[12] = {drawables = 18,   texture = 5},
	[13] = {drawables = 1280, texture = 2},
}

-- Player outfit of van and truck
ConfigDelivery.OutfitVan = {
	[1]  = {drawables = 0,    texture = 0},
	[3]  = {drawables = 66,   texture = 0},
	[4]  = {drawables = 97,   texture = 3},
	[5]  = {drawables = 0,    texture = 0},
	[6]  = {drawables = 32,   texture = 14},
	[7]  = {drawables = 0,    texture = 0},
	[8]  = {drawables = 141,  texture = 0},
	[9]  = {drawables = 0,    texture = 0},
	[11] = {drawables = 230,  texture = 3},
	[12] = {drawables = 45,   texture = 7},
	[13] = {drawables = 1280, texture = 2},
}

-- Player outfit of van and truck (female)
ConfigDelivery.OutfitVanF = {
	[1]  = {drawables = 0,    texture = 0},
	[3]  = {drawables = 14,   texture = 0},
	[4]  = {drawables = 45,   texture = 1},
	[5]  = {drawables = 0,    texture = 0},
	[6]  = {drawables = 27,   texture = 0},
	[7]  = {drawables = 0,    texture = 0},
	[8]  = {drawables = 14,   texture = 0},
	[9]  = {drawables = 0,    texture = 0},
	[11] = {drawables = 14,   texture = 3},
	[12] = {drawables = 18,   texture = 7},
	[13] = {drawables = 1280, texture = 2},
}

-- Random van goods
ConfigDelivery.VanGoodsPropNames = {
	`prop_crate_11e`,
    `prop_cardbordbox_02a`,
}

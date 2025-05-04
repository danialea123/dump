Config = {}
Config.Locale = 'en'

-- Blip Location
Config.Blip = vector3(-1083.04, -258.34, 37.76)
-- Lose Area Distance
Config.LoseAreaDistance = 29
-- Character For Hack
Config.CharHack = 4
-- Timers
Config.TimeImportVirus = 300 -- Sec - 5 Min
Config.TimeTorching = 30 -- Sec
Config.TimeHack = 50 -- Sec
Config.TimeToHack = 120 -- Sec
Config.NeedToCloseDoor = 1800000 -- Milisec - 30 Min
Config.NeedToNextRob = 3600 -- Sec - 2 Hour
-- Robbery Info
Config.Robbery = {
	robbery_name = "Life Insurance",
	virus_position = vector3(-1056.84, -233.31, 43.02),
	hack_position = vector3(-1054.01, -230.50, 43.02),
	blowtorch_position = vector3(-1041.54, -233.60, 36.96),
	lose_area = vector3(-1067.40, -243.49, 38.73),
	reward = math.random(1400000,1500000),
	lastrobbed = 0,
	cops_required = 10,
}
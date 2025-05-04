Config = {}

--Client Stuff--
Config.MarkerType   = 1
Config.DrawDistance = 15.0
Config.ZoneSize     = {x = 1.0, y = 1.0, z = -1.0}
Config.MarkerColor  = {r = 100, g = 204, b = 100}
Config.ShowBlips	= true -- Ehh, hopefully self explanatory... but if not it shows the pictures on the map for you
Config.ShowMarkers 	= false -- Ehh, hopefully self explanatory... but if not it shows the circles on the ground for you
Config.MultiPlant	= false -- Will give up to three of each product when a plant is picked

--Cop Stuff--
Config.GiveBlack 	= false -- Disable to give regular cash when selling drugs
Config.EnableCops   = true -- Set true to send police notification (uses esx:notification)
Config.UseESXPhone	= false -- Use ESXPhone/ALPhone instead of ESXNotification
Config.UseGCPhone	= true -- Use GCphone instead of ESXNotification
Config.RequireCops	= true -- Requires Police online to sell drugs
Config.RequiredCopsCoke  = 1
Config.RequiredCopsMeth  = 1
Config.RequiredCopsWeed  = 1	
Config.RequiredCopsOpium = 1
Config.RequiredCopsHerin = 1
Config.RequiredCopsCrack = 1

--Language--
Config.Locale = 'en' -- Only fully supported for English

Config.Bots = {
	"csb_jackhowitzer",
	"a_m_m_salton_02",
	"g_m_y_mexgoon_01",
	"u_m_y_tattoo_01",
	"a_m_o_tramp_01",
	"g_m_y_salvagoon_01"
}
--Script Stuff--
Config.Delays = {
	WeedProcessing = 1000 * 10,
	CocaineProcessing = 2000 * 10,
	MushroomProcessing = 2000 * 10,
	EphedrineProcessing = 2000 * 10,
	MethProcessing = 2000 * 10,
	PoppyProcessing = 2000 * 10,
	CrackProcessing = 2000 * 10,
	HeroineProcessing = 1000 * 10
}

Config.FieldZones = {
	--WeedField = {coords = vector3(2224.2, 5566.53, 54.06), name = 'Zamin Shah Dane',color = 25, sprite = 496, radius = 1.0, msg = 'weed_field_close', model = `prop_weed_01`, range = 8},
	CocaineField = {coords = vector3(1849.8, 4914.2, 44.92), name = 'Zamin Cocaine' ,color = 4, sprite = 496, radius = 1.0, msg = 'cocaine_field_close', model = `prop_plant_group_03`, range = 46},
	--MushroomField = {coords = vector3(4849.15,-4591.19,17.73), name = 'Zamin Mushroom' ,color = 4, sprite = 496, radius = 1.0, msg = 'mushroom_field_close', model = `prop_weed_02`, range = 25},
	EphedrineField = {coords = vector3(1570.54,-2013.32,92.72), name = 'Zamin Ephedrine',color = 62, sprite = 496, radius = 1.0, msg = 'ephedrine_field_close', model = `prop_plant_cane_01b`, range = 30},
	--PoppyField = {coords = vector3(-1800.83, 1990.43, 132.71), name = 'Zamin Khash-Khaash',color = 38, sprite = 496, radius = 1.0, msg = 'opium_field_close', model = `prop_plant_group_03`, range = 38},
}

Config.ProcessZones = {
	--WeedProcessing = {coords = vector3(2329.02, 2571.29, 46.68), name = 'Laboratory Marijuana', color = 25, sprite = 496, radius = 1.0, msg = 'weed_process_close'},
	CocaineProcessing = {coords = vector3(-2083.58, -1011.96, 5.88), name = 'Laboratory Cocaine', color = 4, sprite = 455, radius = 1.0, msg = 'cocaine_process_close'},
	EphedrineProcessing = {coords = vector3(-1078.62, -1679.62, 4.58), name = 'Laboratory Ephedrine', color = 62, sprite = 310, radius = 1.0, msg = 'ephedrine_process_close'},
	MethProcessing = {coords = vector3(1391.94, 3605.94, 38.94), name = 'Laboratory Shishe', color = 25, sprite = 93, radius = 1.0, msg = 'meth_process_close'},
	CrackProcessing = {coords = vector3(955.1, -193.95, 73.21), name = 'Laboratory Crack', color = 45, sprite = 514, radius = 0.3, msg = 'crack_process_close'},
	--PoppyProcessing ={coords = vector3(3628.38, 3760.0, 28.12), name = 'Laboratory Teryak', color = 38, sprite = 499, radius = 1.0, msg = 'opium_process_close'},
	--HeroineProcessing = {coords = vector3(1976.76, 3819.58, 33.45), name = 'Laboratory Heroine', color = 59, sprite = 388, radius = 1.0, msg = 'heroine_process_close'},
}

Config.Peds = {
	--WeedProcess =		{ ped = -264140789, x = 2328.29, y = 2569.61,	z = 45.68, 	h = 325.04 },
	CokeProcess =		{ ped = -264140789, x = -2084.48, y = -1011.68,	z = 4.88,	h = 252.42 },
	EphedrineProcess =	{ ped = 516505552, x = -1079.49, y = -1679.92,	z = 3.58,	h = 181.96 },
	MethProcess =		{ ped = 516505552, x = 1976.83,	y = 3819.67,	z = 32.45,	h = 120.83 },
	--OpiumProcess =		{ ped = -730659924, x = 3559.03, y = 3674.78,	z = 27.12,	h = 224.32 },
	CrackProcess =		{ ped = -264140789, x = 954.85, y = -193.52,	z = 72.21,	h = 188.57 },
}

-- my own shit--
Config.MarkerSize   = {x = 2.5, y = 2.5, z = 1.0}

Config.Locations = {
	{ x = 955.1, y = -193.95, z = 72.21}, -- process cocke be crack
	{ x = -2084.32, y = -1013.68, z = 5.0}, -- process tokhm cocacine be cocaine
	--{ x = 2329.02, y = 2571.29, z = 45.75}, -- tabdil hashish(cannabis) be marijuana
	{ x = -1078.62, y = -1679.62, z = 3.60}, -- tabdil ephedra be ephedrine
	--{ x = 3559.76, y = 3674.54, z = 27.20}, -- tabdil poppy (khaskhaash) be opium(teryak)
	--{ x = 1975.57, y = 3818.73, z = 32.49}, -- tabdil opium(teryak) be heroine
	{ x = 1391.94, y = 3605.94, z = 38.00} -- tabdil ephedrine be meth
}

Config.Zones = {}

Config.CircleZones = {
	DrugDealer = {c = vector3(-1254.68,-1432.11,3.35), h = 123.86, name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0},
}

for i=1, #Config.Locations, 1 do
	Config.Zones['drug_' .. i] = {
		Pos   = Config.Locations[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
-- my own shit--
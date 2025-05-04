Config = {}

Config.JerryCanCost = 2000
Config.RefillCost = 50 

Config.FuelDecor = "_FUEL_LEVEL"

Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

Config.Strings = {
	ExitVehicle = "Exit the vehicle to refuel",
	EToRefuel = "~y~Press ~g~[E] ~y~to refuel vehicle",
	JerryCanEmpty = "Jerry can is empty",
	FullTank = "Tank is full",
	PurchaseJerryCan = "~w~Press ~g~[E] ~w~to purchase a jerry can for ~g~$" .. Config.JerryCanCost,
	CancelFuelingPump = "~w~Press ~g~[E] ~w~to cancel the fueling",
	CancelFuelingJerryCan = "~w~Press ~g~[E] ~w~to cancel the fueling",
	NotEnoughCash = "Not enough cash",
	RefillJerryCan = "~w~Press ~g~[E] ~w~ to refill the jerry can for ",
	NotEnoughCashJerryCan = "Not enough cash to refill jerry can",
	JerryCanFull = "Jerry can is full",
	TotalCost = "Cost",
}
Config.SyncPercent = 5.0
Config.DefaultPetrolCanAmmo = 4500
Config.PumpModels = {
	`prop_gas_pump_1d`,
	`prop_gas_pump_1a`,
	`prop_gas_pump_1b`,
	`prop_gas_pump_1c`,
	`prop_vintage_pump`,
	`prop_gas_pump_old2`,
	`prop_gas_pump_old3`,
}

-- Blacklist certain vehicles. Use names or hashes. https://wiki.gtanet.work/index.php?title=Vehicle_Models
Config.Blacklist = {
	`neon`,
	`cyclone`,
	`tezract`,
	`raiden`,
	`voltic`,
	`imorgon`,
	`khamelion`,
	`dilettante`,
	`dilettante2`,
	`neon`,
	`pounder`,
	`mule`,
	`mule2`,
	`biff`,
	`benson`,
	`benson2`,
	`packer`,
	`phantom`,
	`phantom3`,
	`phantom4`,
	`pounder2`,
	`riot`,
	`flatbed`,
	`mixer`,
	`rubble`,
	`tiptruck`,
	`tiptruck2`,
	`Inductor`,
	`Inductor2`,
	`Voltic`,
	`Tezeract`,
	`Cyclone`,
	`Dilettante`,
	`iwagen`,
	`Imorgon`,
	`Khamelion`,
	`Virtue`,
	`Surge`,
	`Voltic`,
	`Raiden`,
	`Powersurge`,
	`omnisgt`,
	`sou_modelswb`,
	`teslapd`,
	`coureur`,
	`cyberoff`,
	`cyberoffcq`,
	`mower`,
	-- Bicycle
	`bmx`,
	`cruiser`,
	`fixter`,
	`scorcher`,
	`tribike`,
	`tribike2`,
	`tribike3`,
	`wheelchair`,
	`skateboard`,
    `rcbandito`,
	--Electric
	`neon`,
	`tezeract`,
	`raiden`,
	`cyclone`,
	`voltic`,
	`surge`,
	`dilettante`,
	`twizy`,
	`ocnetrongt`,
}


-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
Config.Classes = {
	[0] = 1.0, -- Compacts

	[1] = 1.0, -- Sedans

	[2] = 1.0, -- SUVs

	[3] = 1.0, -- Coupes

	[4] = 1.0, -- Muscle

	[5] = 1.0, -- Sports Classics

	[6] = 1.0, -- Sports

	[7] = 1.0, -- Super

	[8] = 1.0, -- Motorcycles

	[9] = 1.0, -- Off-road

	[10] = 1.0, -- Industrial

	[11] = 1.0, -- Utility

	[12] = 1.0, -- Vans

	[13] = 0.0, -- Cycles

	[14] = 0.0, -- Boats

	[15] = 0.0, -- Helicopters

	[16] = 0.0, -- Planes

	[17] = 1.0, -- Service

	[18] = 1.0, -- Emergency

	[19] = 1.0, -- Military

	[20] = 1.0, -- Commercial

	[21] = 1.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 2.0,
	[0.9] = 1.9,
	[0.8] = 1.8,
	[0.7] = 1.7,
	[0.6] = 1.6,
	[0.5] = 1.5,
	[0.4] = 1.4,
	[0.3] = 1.3,
	[0.2] = 1.2,
	[0.1] = 1.1,
	[0.0] = 1.0,
}

-- Config.openMenuCMD = 'openmenu'
-- Config.openAllstationCMD = 'openstations'
Config.coordstationui = vector3(-268.1,-957.32,31.22)


Config.StationGasPrice =  4
Config.minimumGaslitr = 300
Config.maximumGaslitr = 3000

Config.mingasprice = 1
Config.maxgasprice = 100


Config.walletpercent = 70

Config.adminAccess = 'headadmin'

Config.GasStations = {
	[1] = { 
		name = "Gas Station",
		id = 1,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(49.4187, 2778.793, 58.043),
		bossAction = vector3(46.239028930664,2789.0895996094,57.878257751465),
	},
	[2] = { 
		name = "Gas Station",
		id = 2,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(263.894, 2606.463, 44.983),
		bossAction = vector3(265.75698852539,2598.6252441406,44.807586669922),
	},
	[3] = { 
		name = "Gas Station",
		id = 3,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1039.958, 2671.134, 39.550),
		bossAction = vector3(1039.3469238281,2664.53515625,39.551063537598),
	},
	[4] = { 
		name = "Gas Station",
		id = 4,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1207.260, 2660.175, 37.899),
		bossAction = vector3(1202.2364501953,2654.501953125,37.851867675781),
	},
	[5] = { 
		name = "Gas Station",
		id = 5,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(2539.685, 2594.192, 37.944),
		bossAction = vector3(2545.01171875,2591.8923339844,37.957416534424),
	},
	[6] = { 
		name = "Gas Station",
		id = 6,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(2679.858, 3263.946, 55.240),
		bossAction = vector3(2674.1362304688,3266.7380371094,55.24055480957),
	},
	[7] = { 
		name = "Gas Station",
		id = 7,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(2005.055, 3773.887, 32.403),
		bossAction = vector3(2001.8480224609,3779.5776367188,32.180786132812),
	},
	[8] = { 
		name = "Gas Station",
		id = 8,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1687.156, 4929.392, 42.078),
		bossAction = vector3(1702.3630371094,4916.59765625,42.078174591064),
	},
	[9] = { 
		name = "Gas Station",
		id = 9,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1701.314, 6416.028, 32.763),
		bossAction = vector3(1706.1337890625,6425.5874023438,32.769172668457),
	},
	[10] = { 
		name = "Gas Station",
		id = 10,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(179.857, 6602.839, 31.868),
		bossAction = vector3(161.79376220703,6636.0649414062,31.572671890259),
	},
	[11] = { 
		name = "Gas Station",
		id = 11,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-94.4619, 6419.594, 31.489),
		bossAction = vector3(-93.204330444336,6410.0751953125,31.640468597412),
	},
	[12] = { 
		name = "Gas Station",
		id = 12,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-2554.996, 2334.40, 33.078),
		bossAction = vector3(-2544.1083984375,2316.1079101562,33.216087341309),
	},
	[13] = { 
		name = "Gas Station",
		id = 13,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-1800.375, 803.661, 138.651),
		bossAction = vector3(-1817.7608642578,797.18542480469,138.13372802734),
	},
	[14] = { 
		name = "Gas Station",
		id = 14,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-1437.622, -276.747, 46.207),
		bossAction = vector3(-1428.2918701172,-268.53536987305,46.215614318848),
	},
	[15] = { 
		name = "Gas Station",
		id = 15,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-2096.243, -320.286, 13.168),
		bossAction = vector3(-2074.1398925781,-326.42922973633,13.315972328186),
	},
	[16] = { 
		name = "Gas Station",
		id = 16,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-724.619, -935.1631, 19.213),
		bossAction = vector3(-702.71575927734,-917.19256591797,19.214080810547),
	},
	[17] = { 
		name = "Gas Station",
		id = 17,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-526.019, -1211.003, 18.184),
		bossAction = vector3(-531.36553955078,-1220.58203125,18.454996109009),
	},
	[18] = { 
		name = "Gas Station",
		id = 18,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-70.2148, -1761.792, 29.534),
		bossAction = vector3(-61.602069854736,-1750.7318115234,29.329084396362),
	},
	[19] = { 
		name = "Gas Station",
		id = 19,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(265.648, -1261.309, 29.292),
		bossAction = vector3(288.31497192383,-1267.0661621094,29.440759658813),
	},
	[20] = { 
		name = "Gas Station",
		id = 20,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(819.653, -1028.846, 26.403),
		bossAction = vector3(834.65496826172,-1036.6971435547,27.232025146484),
	},
	[21] = { 
		name = "Gas Station",
		id = 21,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1208.951, -1402.567,35.224),
		bossAction = vector3(1211.0637207031,-1389.3812255859,35.376903533936),
	},
	[22] = { 
		name = "Gas Station",
		id = 22,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1181.381, -330.847, 69.316),
		bossAction = vector3(1167.6610107422,-321.7887878418,69.290962219238),
	},
	[23] = { 
		name = "Gas Station",
		id = 23,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(620.843, 269.100, 103.089),
		bossAction = vector3(645.63861083984,267.21533203125,103.23785400391),
	},
	[24] = { 
		name = "Gas Station",
		id = 24,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(2581.321, 362.039, 108.468),
		bossAction = vector3(2559.7651367188,373.71899414062,108.62116241455),
	},
	[25] = { 
		name = "Gas Station",
		id = 25,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(176.631, -1562.025, 29.263),
		bossAction = vector3(166.90361022949,-1553.4200439453,29.261756896973),
	},
	[26] = { 
		name = "Gas Station",
		id = 26,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(-319.292, -1471.715, 30.549),
		bossAction = vector3(-342.00668334961,-1482.671875,30.694463729858),
	},
	[27] = { 
		name = "Gas Station",
		id = 27,
		identifier = 'government',
		owner = 'Government',
		forsale = 'true',
		price = 100000,
		wallet = 0,
		gasPrice = 5,
		gasVal = 200,
		blip = '',
		coord = vector3(1784.324, 3330.55, 41.253),		
		bossAction = vector3(1776.8001708984,3327.5981445312,41.433300018311),
	}
}
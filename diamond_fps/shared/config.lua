Config = {}

Config.FpsMenu = {
	["A"] = {
		["a"] = { 
		name = "Object Render",
		typ = "ranger",
		range = {
			min = 1,
			max = 4,
			value = 4,
		},
		func = "ObjectRender",
		},
		["b"] = { 
			name = "Ped Render",
			typ = "ranger",
			range = {
				min = 1,
				max = 4,
				value = 4,
			},
			func = "PedRender",
		},
		["c"] = { 
			name = "Cars Render Distance",
			typ = "ranger",
			range = {
				min = 1,
				max = 4,
				value = 4,
			},
			func = "CarsDistance",
		},
	},
	["B"] = {
		["a"] = { 
			name = "Shadow Details",
			typ = "ranger",
			range = {
				min = 1,
				max = 5,
				value = 5,
			},
			func = "shadow_ranger",
		},
		["b"] = { 
			name = "Disable Fire Effect",
			typ = "on_off",
			func = "Disable_Fire_Effect",
		},
		["c"] = { 
			name = "Light & Colors Details",
			typ = "ranger",
			range = {
				min = 1,
				max = 3,
				value = 2,
			},
			func = "Sun_Details",
		},
		["d"] = { 
			name = "Reflections & Lights",
			typ = "on_off",
			func = "Reflections_Lights",
		},
	},
	["C"] = {
		["a"] = {
			name = "Events Clear (Continuous)",
			typ = "on_off",
			func = "ClearEvents",
		}, 
		["b"] = {
			name = "Gta5 Scenarios Delete",
			typ = "on_off",
			func = "Scenarios_Delete",
		},
		["c"] = {
			name = "Raind & Wind",
			typ = "on_off",
			func = "Raind_Wind",
		},
		["d"] = {
			name = "Clear Ped Blood & Dirt",
			typ = "on_off",
			func = "Clear_Blood_Dirt",
		},
	}
}

Config.URL = {
	Discord = "https://discord.gg/diamond-rp",
	Web = "https://diamondrp.ir"
}
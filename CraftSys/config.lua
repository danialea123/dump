 Config = {



UseLimitSystem = false, -- Enable if your esx uses limit system

CraftingStopWithDistance = true, -- Crafting will stop when not near workbench

ExperiancePerCraft = 5, -- The amount of experiance added per craft (100 Experiance is 1 level)

HideWhenCantCraft = true, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

Categories = {

['rifles'] = {
	Label = 'RIFLE WEAPON',
	Image = 'fishingrod',
	Jobs = {}
},
['pistols'] = {
	Label = ' PISTOL WEAPONS',
	Image = 'WEAPON_PISTOL',
	Jobs = {}
},
['melee'] = {
	Label = 'KNIFE',
	Image = 'bandage',
	Jobs = {}
},
['skin'] = {
	Label = 'SKIN',
	Image = 'yusuf',
	Jobs = {}
},
['shotguns'] = {
	Label = 'SHOTGUN WEAPON',
	Image = 'WEAPON_PUMPSHOTGUN',
	Jobs = {}
},
['submachineguns'] = {
	Label = 'SMG WEAPON',
	Image = 'WEAPON_SMG',
	Jobs = {}
}


},

PermanentItems = { -- Items that dont get removed when crafting
	['wrench'] = true
},

Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque


['WEAPON_KNIFE'] = {
	Level = 1, -- From what level this item will be craftable
	Category = 'melee', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 100, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 5, -- item name and count, adding items that dont exist in database will crash the script
		['diamond'] = 1,
		['iron'] = 10,
		['petrol_raffin'] = 10
	},
	Pool = 30000,
}, 
['WEAPON_VINTAGEPISTOL'] = {
	Level = 2, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 100, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['copper'] = 15, -- item name and count, adding items that dont exist in database will crash the script
		['packaged_plank'] = 8,
		['iron'] = 15,
		['essence'] = 4,
		['gold'] = 5,
		['gold_piece'] = 10
	},
	Pool = 50000,
}, 
['WEAPON_HEAVYPISTOL'] = {
	Level = 3, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['copper'] = 16, -- item name and count, adding items that dont exist in database will crash the script
	    ['packaged_plank'] = 8,
	    ['gold'] = 5,
	    ['diamond'] = 1,
		['essence'] = 7,
	    ['iron_piece'] = 12
	},
	Pool = 50000,
},
['WEAPON_PISTOL50'] = {
	Level = 11, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['copper'] = 25, -- item name and count, adding items that dont exist in database will crash the script
		['packaged_plank'] = 12,
		['gold'] = 10,
		['petrol_raffin'] = 10,
		['iron_piece'] = 10,
		['iron'] = 5
	},
	Pool = 100000,
},
['WEAPON_SMG'] = {
	Level = 4, -- From what level this item will be craftable
	Category = 'submachineguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 14, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 5,
	    ['diamond'] = 1,
		['petrol_raffin'] = 10,
		['essence'] = 4,
		['iron_piece'] = 15,
	    ['iron'] = 7
	},
	Pool = 120000,
},
['WEAPON_COMBATPDW'] = {
	Level = 6, -- From what level this item will be craftable
	Category = 'submachineguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 16, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['diamond'] = 2,
		['petrol_raffin'] = 15,
		['essence'] = 10,
	    ['iron'] = 15
	},
	Pool = 150000,
},
['WEAPON_ASSAULTSMG'] = {
	Level = 7, -- From what level this item will be craftable
	Category = 'submachineguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 16, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 15,
	    ['copper'] = 20,
		['essence'] = 8,
		['iron_piece'] = 15,
	    ['iron'] = 15,
		['diamond'] = 1
	},
	Pool = 170000,
},
['WEAPON_ASSAULTRIFLE'] = {
	Level = 12, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 20, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['copper'] = 8,
		['diamond'] = 2,
		['petrol_raffin'] = 12,
		['essence'] = 4,
	    ['gold_piece'] = 15
	},
	Pool = 200000,
},
['WEAPON_CARBINERIFLE'] = {
	Level = 10, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 20, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 6,
	    ['copper'] = 15,
		['diamond'] = 3,
		['petrol_raffin'] = 15,
		['iron_piece'] = 14,
	    ['iron'] = 10
	},
	Pool = 200000,
},
['WEAPON_ADVANCEDRIFLE'] = {
	Level = 13, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 17, -- item name and count, adding items that dont exist in database will crash the script
		['gold'] = 10,
		['copper'] = 30,
		['diamond'] = 4,
		['petrol_raffin'] = 8,
		['gold_piece'] = 10,
		['iron'] = 9
	},
	Pool = 200000,
},
['WEAPON_BULLPUPRIFLE'] = {
	Level = 15, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 20, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['copper'] = 20,
		['diamond'] = 5,
		['petrol_raffin'] = 15,
		['gold_piece'] = 15,
	    ['iron'] = 5
	},
	Pool = 260000,
},
['WEAPON_GUSENBERG'] = {
	Level = 19, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 22, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 8,
	    ['copper'] = 20,
		['diamond'] = 4,
		['petrol_raffin'] = 20,
		['gold_piece'] = 10,
	    ['iron'] = 8
	},
	Pool = 300000,
},
['WEAPON_SAWNOFFSHOTGUN'] = {
	Level = 16, -- From what level this item will be craftable
	Category = 'shotguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
        ['packaged_plank'] = 14, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['essence'] = 7,
		['diamond'] = 7,
		['gold_piece'] = 15,
	    ['iron'] = 17
	},
	Pool = 300000,
},
['WEAPON_PUMPSHOTGUN'] = {
	Level = 18, -- From what level this item will be craftable
	Category = 'shotguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 12, -- item name and count, adding items that dont exist in database will crash the script
		['gold'] = 10,
		['copper'] = 20,
		['diamond'] = 10,
		['essence'] = 10,
		['petrol_raffin'] = 10,
		['iron_piece'] = 25,
		['iron'] = 15
	},
	Pool = 400000,
},
['WEAPON_KNUCKLE'] = {
	Level = 19, -- From what level this item will be craftable
	Category = 'melee', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['diamond'] = 3,
		['essence'] = 20,
	    ['gold_piece'] = 30
	},
	Pool = 70000,
},
['WEAPON_SPECIALCARBINE'] = {
	Level = 17, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 17, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['copper'] = 19,
	    ['diamond'] = 8,
	    ['petrol_raffin'] = 15,
	    ['gold_piece'] = 14,
	    ['iron'] = 12
	},
	Pool = 400000,
},
['WEAPON_PISTOL_MK2'] = {
	Level = 5, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 14, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 7,
	    ['copper'] = 13,
	    ['diamond'] = 4,
	    ['petrol_raffin'] = 5,
	    ['iron_piece'] = 20
	},
	Pool = 100000,
},
['WEAPON_ASSAULTSHOTGUN'] = {
	Level = 24, -- From what level this item will be craftable
	Category = 'shotguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 16, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 12,
	    ['copper'] = 10,
	    ['diamond'] = 7,
	    ['petrol_raffin'] = 10,
		['essence'] = 8,
	    ['iron'] = 15
	},
	Pool = 500000,
},
['weapon_ceramicpistol'] = {
	Level = 14, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 7, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 5,
	    ['copper'] = 12,
	    ['petrol_raffin'] = 10,
		['essence'] = 3,
	    ['iron'] = 5,
		['diamond'] = 1
	},
	Pool = 120000,
},
['WEAPON_BULLPUPSHOTGUN'] = {
	Level = 27, -- From what level this item will be craftable
	Category = 'shotguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 10, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 6,
	    ['copper'] = 30,
	    ['diamond'] = 5,
	    ['petrol_raffin'] = 10,
		['essence'] = 12,
		['iron_piece'] = 15,
	    ['iron'] = 10
	},
	Pool = 450000,
},
['WEAPON_DOUBLEACTION'] = {
	Level = 30, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 4, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 12,
	    ['diamond'] = 15,
	    ['gold_piece'] = 20,
		['essence'] = 2,
	    ['iron'] = 7
	},
	Pool = 800000,
},
['clip'] = {
	Level = 20, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['iron'] = 2
	},
	Pool = 0,
},
['weapon_suppressor'] = {
	Level = 7, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['iron_piece'] = 2,
		["iron"] = 2,
	},
	Pool = 0,
},
['grip'] = {
	Level = 4, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['gold_piece'] = 2,
		["iron"] = 2,
	},
	Pool = 0,
},
['weapon_clip_extended'] = {
	Level = 10, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['gold_piece'] = 2,
		['iron_piece'] = 2,
		["iron"] = 2,
	},
	Pool = 0,
},
['dclip'] = {
	Level = 14, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		["iron"] = 2,
		["gold"] = 2,
	},
	Pool = 0,
},

['weapon_tint_green'] = {
	Level = 8, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 2,
		["gold"] = 1,
		['petrol_raffin'] = 1,
	},
	Pool = 0,
},
['weapon_tint_pink'] = {
	Level = 8, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 2,
		["gold"] = 1,
		['petrol_raffin'] = 1,
	},
	Pool = 0,
},
['weapon_tint_orange'] = {
	Level = 8, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 2,
		["gold"] = 1,
		['petrol_raffin'] = 1,
	},
	Pool = 0,
},

['weapon_tint_army'] = {
	Level = 20, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		["gold"] = 4,
		['petrol_raffin'] = 3,
		["iron"] = 4,
		["gold_piece"] = 4,
		["iron_piece"] = 4
	},
	Pool = 0,
},
['weapon_tint_platinum'] = {
	Level = 20, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		["gold"] = 4,
		['petrol_raffin'] = 3,
		["iron"] = 4,
		["gold_piece"] = 4,
		["iron_piece"] = 4
	},
	Pool = 0,
},
['weapon_tint_gold'] = {
	Level = 20, -- From what level this item will be craftable
	Category = 'skin', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		["gold"] = 4,
		['petrol_raffin'] = 3,
		["iron"] = 4,
		["gold_piece"] = 4,
		["iron_piece"] = 4
	},
	Pool = 0,
},

['WEAPON_SMG_MK2'] = {
	Level = 9, -- From what level this item will be craftable
	Category = 'submachineguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 12, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 5,
	    ['copper'] = 10,
	    ['diamond'] = 7,
	    ['petrol_raffin'] = 10,
		['iron_piece'] = 15,
	    ['gold_piece'] = 10
	},
	Pool = 240000,
},
['WEAPON_SWITCHBLADE'] = {
	Level = 20, -- From what level this item will be craftable
	Category = 'melee', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['essence'] = 4,
	    ['petrol_raffin'] = 8,
		['iron_piece'] = 10,
	    ['gold_piece'] = 10
	},
	Pool = 40000,
},
['WEAPON_BULLPUPRIFLE_MK2'] = {
	Level = 22, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 19, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 7,
	    ['copper'] = 20,
	    ['diamond'] = 8,
	    ['petrol_raffin'] = 15,
		['essence'] = 5,
	    ['iron'] = 7
	},
	Pool = 320000,
},
['WEAPON_COMPACTRIFLE'] = {
	Level = 23, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 14, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['copper'] = 20,
	    ['diamond'] = 8,
	    ['petrol_raffin'] = 15,
		['essence'] = 10,
	    ['iron'] = 10
	},
	Pool = 300000,
},
['WEAPON_MICROSMG'] = {
	Level = 26, -- From what level this item will be craftable
	Category = 'submachineguns', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 25, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 20,
	    ['copper'] = 15,
	    ['diamond'] = 8,
	    ['petrol_raffin'] = 15,
		['essence'] = 5,
		['iron_piece'] = 15,
	    ['iron'] = 20
	},
	Pool = 500000,
},
['WEAPON_CARBINERIFLE_MK2'] = {
	Level = 21, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 20, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 7,
	    ['copper'] = 25,
	    ['diamond'] = 6,
	    ['petrol_raffin'] = 15,
		['iron_piece'] = 10,
	    ['gold_piece'] = 12
	},
	Pool = 350000,
},
['WEAPON_ASSAULTRIFLE_MK2'] = {
	Level = 25, -- From what level this item will be craftable
	Category = 'rifles', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] = 12, -- item name and count, adding items that dont exist in database will crash the script
	    ['gold'] = 10,
	    ['copper'] = 25,
	    ['diamond'] = 10,
	    ['petrol_raffin'] = 15,
		['essence'] = 5,
		['iron_piece'] = 15,
	    ['iron'] = 12
	},
	Pool = 370000,
},
['WEAPON_APPISTOL'] = {
	Level = 29, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	    ['packaged_plank'] =12, -- item name and count, adding items that dont exist in database will crash the script
	    ['essence'] = 7,
	    ['gold'] = 12,
	    ['diamond'] = 15,
		['petrol_raffin'] = 15,
		['gold_piece'] = 16,
	    ['iron'] = 10
	},
	Pool = 600000,
},
['WEAPON_TACTICALRIFLE'] = {
	Level = 28, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packaged_plank'] = 12, -- item name and count, adding items that dont exist in database will crash the script
		['gold'] = 10,
		['copper'] = 25,
		['diamond'] = 5,
		['petrol_raffin'] = 15,
		['essence'] = 5,
		['iron_piece'] = 15,
		['iron'] = 12
	},
	Pool = 300000,
},
['WEAPON_PISTOLXM3'] = {
	Level = 8, -- From what level this item will be craftable
	Category = 'pistols', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['copper'] = 25, -- item name and count, adding items that dont exist in database will crash the script
		['packaged_plank'] = 12,
		['gold'] = 10,
		['petrol_raffin'] = 10,
		['iron_piece'] = 10,
		['iron'] = 5
	},
	Pool = 200000,
},
},

Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access

		{coords = vector3(2359.042, 3119.446, 48.20215), jobs = {}, blip = true, Recipes = nil, radius = 3.0 }

},
 

Text = {

    ['not_enough_ingredients'] = 'You dont have enough ingredients',
    ['you_cant_hold_item'] = 'You cant hold the item',
    ['item_crafted'] = 'Item crafted!',
    ['wrong_job'] = 'You cant open this workbench',
    ['workbench_hologram'] = '[~b~E~w~] Workbench',
    ['wrong_usage'] = 'Wrong usage of command',
    ['inv_limit_exceed'] = 'Inventory limit exceeded! Clean up before you lose more',
    ['crafting_failed'] = 'You failed to craft the item!'

}

}

SpecialGuns = {
	["Sicilian"] = {
		['WEAPON_TACTICALRIFLE'] = {
			Level = 0, -- From what level this item will be craftable
			Category = 'rifles', -- The category item will be put in
			isGun = true, -- Specify if this is a gun so it will be added to the loadout
			Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 3, -- The amount that will be crafted
			SuccessRate = 100, -- 90% That the craft will succeed! If it does not you will lose your ingredients
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				['packaged_plank'] = 12, -- item name and count, adding items that dont exist in database will crash the script
				['gold'] = 10,
				['copper'] = 25,
				['diamond'] = 5,
				['petrol_raffin'] = 15,
				['essence'] = 5,
				['iron_piece'] = 15,
				['iron'] = 12
			},
			Pool = 260000,
		},
		['WEAPON_BULLPUPSHOTGUN'] = {
			Level = 0, -- From what level this item will be craftable
			Category = 'submachineguns', -- The category item will be put in
			isGun = true, -- Specify if this is a gun so it will be added to the loadout
			Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 3, -- The amount that will be crafted
			SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				['packaged_plank'] = 10, -- item name and count, adding items that dont exist in database will crash the script
				['gold'] = 6,
				['copper'] = 30,
				['diamond'] = 5,
				['petrol_raffin'] = 10,
				['essence'] = 12,
				['iron_piece'] = 15,
				['iron'] = 10
			},
			Pool = 120000,
		},
		['WEAPON_MICROSMG'] = {
			Level = 0, -- From what level this item will be craftable
			Category = 'rifles', -- The category item will be put in
			isGun = true, -- Specify if this is a gun so it will be added to the loadout
			Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 3, -- The amount that will be crafted
			SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				['packaged_plank'] = 25, -- item name and count, adding items that dont exist in database will crash the script
				['gold'] = 20,
				['copper'] = 15,
				['diamond'] = 8,
				['petrol_raffin'] = 15,
				['essence'] = 5,
				['iron_piece'] = 15,
				['iron'] = 20
			},
			Pool = 200000,
		},
	},
	["Evil"] = {
		['WEAPON_BULLPUPRIFLE'] = {
			Level = 0, -- From what level this item will be craftable
			Category = 'rifles', -- The category item will be put in
			isGun = true, -- Specify if this is a gun so it will be added to the loadout
			Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 3, -- The amount that will be crafted
			SuccessRate = 100, -- 90% That the craft will succeed! If it does not you will lose your ingredients
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				['packaged_plank'] = 20, -- item name and count, adding items that dont exist in database will crash the script
				['gold'] = 10,
				['copper'] = 20,
				['diamond'] = 5,
				['petrol_raffin'] = 15,
				['gold_piece'] = 15,
				['iron'] = 5
			},
			Pool = 260000,
		},
		['WEAPON_GUSENBERG'] = {
			Level = 0, -- From what level this item will be craftable
			Category = 'rifles', -- The category item will be put in
			isGun = true, -- Specify if this is a gun so it will be added to the loadout
			Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 3, -- The amount that will be crafted
			SuccessRate = 100, -- 90% That the craft will succeed! If it does not you will lose your ingredients
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				['packaged_plank'] = 22, -- item name and count, adding items that dont exist in database will crash the script
				['gold'] = 8,
				['copper'] = 20,
				['diamond'] = 4,
				['petrol_raffin'] = 20,
				['gold_piece'] = 10,
				['iron'] = 8
			},
			Pool = 300000,
		},
		['WEAPON_HEAVYPISTOL'] = {
			Level = 0, -- From what level this item will be craftable
			Category = 'pistols', -- The category item will be put in
			isGun = true, -- Specify if this is a gun so it will be added to the loadout
			Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 3, -- The amount that will be crafted
			SuccessRate = 100, -- 90% That the craft will succeed! If it does not you will lose your ingredients
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				['copper'] = 16, -- item name and count, adding items that dont exist in database will crash the script
				['packaged_plank'] = 8,
				['gold'] = 5,
				['diamond'] = 1,
				['essence'] = 7,
				['iron_piece'] = 12
			},
			Pool = 50000,
		},
	}
}

function SendTextMessage(msg)

        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)

        --EXAMPLE USED IN VIDEO
        --exports['mythic_notify']:SendAlert('inform', msg)

end

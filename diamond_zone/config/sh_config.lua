Config = {}

Config.Weapons = {
	[-1569615261] = 'weapon_unarmed',
	[-1716189206] = 'weapon_knife',
	[1737195953] = 'weapon_nightstick',
	[1317494643] = 'weapon_hammer',
	[-1786099057] = 'weapon_bat',
	[-2067956739] = 'weapon_crowbar',
	[1141786504] = 'weapon_golfclub',
	[-102323637] = 'weapon_bottle',
	[-1834847097] = 'weapon_dagger',
	[-102973651] = 'weapon_hatchet',
	[940833800] = 'weapon_stone_hatchet',
	[-656458692] = 'weapon_knuckle',
	[-581044007] = 'weapon_machete',
	[-1951375401] = 'weapon_flashlight',
	[-538741184] = 'weapon_switchblade',
	[-1810795771] = 'weapon_poolcue',
	[419712736] = 'weapon_wrench',
	[-853065399] = 'weapon_battleaxe',
	[453432689] = 'weapon_pistol',
	[-1075685676] = 'weapon_pistol_mk2',
	[1593441988] = 'weapon_combatpistol',
	[-1716589765] = 'weapon_pistol50',
	[-1076751822] = 'weapon_snspistol',
	[-2009644972] = 'weapon_snspistol_mk2',
	[-771403250] = 'weapon_heavypistol',
	[137902532] = 'weapon_vintagepistol',
	[-598887786] = 'weapon_marksmanpistol',
	[-1045183535] = 'weapon_revolver',
	[-879347409] = 'weapon_revolver_mk2',
	[-1746263880] = 'weapon_doubleaction',
	[584646201] = 'weapon_appistol',
	[911657153] = 'weapon_stungun',
	[1198879012] = 'weapon_flaregun',
	[324215364] = 'weapon_microsmg',
	[-619010992] = 'weapon_machinepistol',
	[736523883] = 'weapon_smg',
	[2024373456] = 'weapon_smg_mk2',
	[-270015777] = 'weapon_assaultsmg',
	[171789620] = 'weapon_combatpdw',
	[-1660422300] = 'weapon_mg',
	[2144741730] = 'weapon_combatmg',
	[-608341376] = 'weapon_combatmg_mk2',
	[1627465347] = 'weapon_gusenberg',
	[-1121678507] = 'weapon_minismg',
	[-1074790547] = 'weapon_assaultrifle',
	[961495388] = 'weapon_assaultrifle_mk2',
	[-2084633992] = 'weapon_carbinerifle',
	[-86904375] = 'weapon_carbinerifle_mk2',
	[-1357824103] = 'weapon_advancedrifle',
	[-1063057011] = 'weapon_specialcarbine',
	[-1768145561] = 'weapon_specialcarbine_mk2',
	[2132975508] = 'weapon_bullpuprifle',
	[-2066285827] = 'weapon_bullpuprifle_mk2',
	[1649403952] = 'weapon_compactrifle',
	[100416529] = 'weapon_sniperrifle',
	[205991906] = 'weapon_heavysniper',
	[177293209] = 'weapon_heavysniper_mk2',
	[-952879014] = 'weapon_marksmanrifle',
	[1785463520] = 'weapon_marksmanrifle_mk2',
	[487013001] = 'weapon_pumpshotgun',
	[1432025498] = 'weapon_pumpshotgun_mk2',
	[2017895192] = 'weapon_sawnoffshotgun',
	[-1654528753] = 'weapon_bullpupshotgun',
	[-494615257] = 'weapon_assaultshotgun',
	[-1466123874] = 'weapon_musket',
	[984333226] = 'weapon_heavyshotgun',
	[-275439685] = 'weapon_dbshotgun',
	[317205821] = 'weapon_autoshotgun',
	[-1568386805] = 'weapon_grenadelauncher',
	[-1312131151] = 'weapon_rpg',
	[1119849093] = 'weapon_minigun',
	[2138347493] = 'weapon_firework',
	[1834241177] = 'weapon_railgun',
	[1672152130] = 'weapon_hominglauncher',
	[1305664598] = 'weapon_grenadelauncher_smoke',
	[125959754] = 'weapon_compactlauncher',
	[-1813897027] = 'weapon_grenade',
	[741814745] = 'weapon_stickybomb',
	[-1420407917] = 'weapon_proxmine',
	[-1600701090] = 'weapon_bzgas',
	[615608432] = 'weapon_molotov',
	[101631238] = 'weapon_fireextinguisher',
	[883325847] = 'weapon_petrolcan',
	[-544306709] = 'weapon_petrolcan',
	[1233104067] = 'weapon_flare',
	[600439132] = 'weapon_ball',
	[126349499] = 'weapon_snowball',
	[-37975472] = 'weapon_smokegrenade',
	[-1169823560] = 'weapon_pipebomb',
	[-72657034] = 'weapon_parachute',
	[-1238556825] = 'weapon_rayminigun',
	[-1355376991] = 'weapon_raypistol',
	[1198256469] = 'weapon_raycarbine',
	[727643628] = 'weapon_ceramicpistol',
	[-1853920116] = 'weapon_navyrevolver',
	[1470379660] = 'weapon_gadgetpistol',
	[94989220] = 'weapon_combatshotgun',
	[-1658906650] = 'weapon_militaryrifle'
}

Config.Locations = {
	JoinExit = {
		Coord = vector4(4421.14, -4490.61, 4.31, 227.55),
        Blip = {
        	Show = true,
        	Sprite = 362,
        	Color = 1,
        	Name = "Zone Fight"
        },
		Marker = {
			Show = true,
			Radius = 9.0,
			Color = {r = 51, g = 204, b = 25, a = 180},
			DrawDistance = 15,
			Type = 1,
			Text = "Dokme ~INPUT_CONTEXT~ jahat baz kardan menu Zone Fight",
			action = function()
				openmenu()
			end
		},
	},
    SafeZone = {
		{
			Coord = vector4(4442.0, -4466.68, 3.90, 192.43),
			Blip = {
				Show = true,
				Sprite = 270,
				Color = 43,
				Name = "Safe Zone 1"
			},
			ReviveZone = {
				PedCoord = vector4(4439.35, -4449.93, 4.33, 208.1),
				Ped = "s_m_m_doctor_01",
				RevCoord = vector3(4439.57, -4451.04, 4.33),
			},
			Zones = {
				{
				    Marker = {
						Coord = vector4(4433.17, -4463.61, 4.33, 103.38),
				    	ShowMarker = true,
				    	Radius = 0.5,
				    	Color = {r = 51, g = 204, b = 25, a = 180},
				    	DrawDistance = 15,
				    	Type = 40,
				    	Text = "Dokme ~INPUT_CONTEXT~ jahat baz kardan teleport menu",
				    	action = function(zone)
				    		openteleportmenu(zone)
				    	end
				    },
				},
			}
		},
		{
			Coord = vector4(5587.1, -5222.52, 14.35, 51.87),
			Blip = {
				Show = true,
				Sprite = 270,
				Color = 43,
				Name = "Safe Zone 2"
			},
			ReviveZone = {
				PedCoord = vector4(5598.35, -5207.05, 14.32, 136.47),
				Ped = "s_m_m_doctor_01",
				RevCoord = vector3(5597.63, -5207.57, 14.34),
			},
			Zones = {
				{
				    Marker = {
						Coord = vector4(5593.65, -5223.44, 14.35, 60.67),
				    	ShowMarker = true,
				    	Radius = 0.5,
				    	Color = {r = 51, g = 204, b = 25, a = 180},
				    	DrawDistance = 15,
				    	Type = 40,
				    	Text = "Dokme ~INPUT_CONTEXT~ jahat baz kardan teleport menu",
				    	action = function(zone)
				    		openteleportmenu(zone)
				    	end
				    },
				},
				{
				    Marker = {
						Coord = vector4(5586.31, -5219.89, 14.35, 40.78),
				    	ShowMarker = true,
				    	Radius = 0.5,
				    	Color = {r = 90, g = 178, b = 255, a = 180},
				    	DrawDistance = 15,
				    	Type = 33,
				    	Text = "Dokme ~INPUT_CONTEXT~ jahat baz kardan menu Zone Fight",
				    	action = function()
				    		openmenu()
				    	end
				    },
				},
			}
		},
		{
			Coord = vector4(4908.72, -5834.08, 28.22, 182.85),
			Blip = {
				Show = true,
				Sprite = 270,
				Color = 43,
				Name = "Safe Zone 3"
			},
			ReviveZone = {
				PedCoord = vector4(4907.39, -5837.21, 28.22, 3.72),
				Ped = "s_m_m_doctor_01",
				RevCoord = vector3(4907.38, -5836.39, 28.22),
			},
			Zones = {
				{
				    Marker = {
						Coord = vector4(4905.46, -5828.46, 28.22, 185.71),
				    	ShowMarker = true,
				    	Radius = 0.5,
				    	Color = {r = 51, g = 204, b = 25, a = 180},
				    	DrawDistance = 15,
				    	Type = 40,
				    	Text = "Dokme ~INPUT_CONTEXT~ jahat baz kardan teleport menu",
				    	action = function(zone)
				    		openteleportmenu(zone)
				    	end
				    },
				},
				{
				    Marker = {
						Coord = vector4(4905.56, -5835.35, 28.22, 175.26),
				    	ShowMarker = true,
				    	Radius = 0.5,
				    	Color = {r = 90, g = 178, b = 255, a = 180},
				    	DrawDistance = 15,
				    	Type = 33,
				    	Text = "Dokme ~INPUT_CONTEXT~ jahat baz kardan menu Zone Fight",
				    	action = function()
				    		openmenu()
				    	end
				    },
				},
			}
		}
    },
    Zones = {
        {
            Name = "A",
            Coord = vector3(5077.06, -4616.28, 2.64),
            Captured = false,
            ThreadHandle = nil,
            ActiveGang = nil,
            CapturedBy = "Not Captured",
            Blip = {
                Sprite = 76,
                Color = 42,
            },
            Marker = {
                Radius = 100.0,
                Size = 100.5,
                Color = {r = 252, g = 3, b = 61},
                Type = 1,
            },
        },
        {
            Name = "B",
            Coord = vector3(4963.82, -5287.16, 6.24),
            Captured = false,
            ThreadHandle = nil,
            ActiveGang = nil,
            CapturedBy = "Not Captured",
            Blip = {
                Sprite = 106,
                Color = 42,
            },
            Marker = {
                Radius = 100.0,
                Size = 100.5,
                Color = {r = 252, g = 3, b = 61},
                Type = 1,
            },
        },
        {
            Name = "C",
            Coord = vector3(5269.04, -5423.6, 65.6),
            Captured = false,
            ThreadHandle = nil,
            ActiveGang = nil,
            CapturedBy = "Not Captured",
            Blip = {
                Sprite = 89,
                Color = 42,
            },
            Marker = {
                Radius = 100.0,
                Size = 100.5,
                Color = {r = 252, g = 3, b = 61},
                Type = 1,
            },
        },
		{
            Name = "D",
            Coord = vector3(5472.09, -5851.09, 20.77),
            Captured = false,
            ThreadHandle = nil,
            ActiveGang = nil,
            CapturedBy = "Not Captured",
            Blip = {
                Sprite = 355,
                Color = 42,
            },
            Marker = {
                Radius = 100.0,
                Size = 100.5,
                Color = {r = 252, g = 3, b = 61},
                Type = 1,
            },
        }
    }
}

Config.AirDropRewards = {
	-- [number] = {
	-- 	{name = "itemname", amount = {min = number, max = number}, type = "item"},
	--  {amount = {min = number, max = number}, type = "cash"},
	-- }

	[1] = {
		{name = "rc", amount = {min = 7, max = 10}, type = "item"},
	}
}
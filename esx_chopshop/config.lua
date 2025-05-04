config = {}

config.framework = "esx" -- "esx"   -  "qb"

config.ShowBlip = true
config.BlipName = "Chop Shop"
config.minPolice = 1
config.startCoolDownPlayerJoinig = false
config.policeAlertPercent = 50
config.clientCooldown = 1800000 -- 30 minutes(1800000)
config.NPCHash = 68070371
config.NPCShop = vector4(-498.75, -1714.1, 18.97, 104.9)
config.NPCName = "Robban"

config.moneyType = "cash" -- "black"

--need to add the items to the database
config.Items = {
	-- İtem name and price
    ["battery"] = 8500,
    ["airbag"] = 8300,
    ["lowradio"] = 6300,
    ["stockrim"] = 5700,
    ["highradio"] = 6580,
    ["highrim"] = 5100,
    ["door"] = 4300,
    ["speaker"] = 6400
}

function policeAlertFunction()
    -- Your Police Alert Event
	TriggerEvent("tgiann-policeAlert:alert", "Chopshop")
end

-- just edit the time, marker-label and progressbar-label
aracParcaNokta = {
	{-- front left door
		["marker-label"] = "Front Left Door",
		["kod-isim"] = "on_sol_kapi",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Door",
		["parca-native-no"] = 0,
		["kordinat"] = {
			["x"] = -558.96,
			["y"] = -1696.59,
			["z"] = 19.13,
			["h"] = 296.08,
		},
		["animasyon"] = {
			["seneryo"] = "true",
			["seneryo-anim"] = "WORLD_HUMAN_WELDING"
		},
		["prop"] =  "prop_car_door_01",
		["entity-attach"] = {
			["bone"] = 57005,
			["xPos"] = 0.4,
			["yPos"] = 0,
			["zPos"] = 0,
			["xRot"] = 0,
			["yRot"] = 270.0,
			["zRot"] = 60.0,
		},
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@narcotics@trash",
			["prop-name"] = "walk"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "on_sol_kapi_kutu",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{ -- front right door
		["marker-label"] = "Front Right Door",
		["kod-isim"] = "on_sag_kapi",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Door",
		["parca-native-no"] = 1,
		["kordinat"] = {
			["x"] = -556.79,
			["y"] = -1694.99,
			["z"] = 19.2,
			["h"] = 120.54,
		},
		["animasyon"] = {
			["seneryo"] = true,
			["seneryo-anim"] = "WORLD_HUMAN_WELDING"
		},
		["prop"] =  "prop_car_door_01",
		["entity-attach"] = {
			["bone"] = 57005,
			["xPos"] = 0.4,
			["yPos"] = 0,
			["zPos"] = 0,
			["xRot"] = 0,
			["yRot"] = 270.0,
			["zRot"] = 60.0,
		},
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@narcotics@trash",
			["prop-name"] = "walk"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "on_sag_kapi_kutu",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{ -- back left door
		["marker-label"] = "Back Left Door",
		["kod-isim"] = "arka_sol_kapi",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Door",
		["parca-native-no"] = 2,
		["kordinat"] = {
			["x"] = -558.48,
			["y"] = -1697.1,
			["z"] = 19.13,
			["h"] = 304.72,
		},
		["animasyon"] = {
			["seneryo"] = true,
			["seneryo-anim"] = "WORLD_HUMAN_WELDING"
		},
		["prop"] =  "prop_car_door_01",
		["entity-attach"] = {
			["bone"] = 57005,
			["xPos"] = 0.4,
			["yPos"] = 0,
			["zPos"] = 0,
			["xRot"] = 0,
			["yRot"] = 270.0,
			["zRot"] = 60.0,
		},
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@narcotics@trash",
			["prop-name"] = "walk"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "arka_sol_kapi_kutu",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{  -- back right door
		["marker-label"] = "Back Right Door",
		["kod-isim"] = "arka_sag_kapi",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Door",
		["parca-native-no"] = 3,
		["kordinat"] = {
			["x"] = -556.26,
			["y"] = -1695.81,
			["z"] = 19.19,
			["h"] = 122.01,
		},
		["animasyon"] = {
			["seneryo"] = true,
			["seneryo-anim"] = "WORLD_HUMAN_WELDING",
		},
		["prop"] =  "prop_car_door_01",
		["entity-attach"] = {
			["bone"] = 57005,
			["xPos"] = 0.4,
			["yPos"] = 0,
			["zPos"] = 0,
			["xRot"] = 0,
			["yRot"] = 270.0,
			["zRot"] = 60.0,
		},
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@narcotics@trash",
			["prop-name"] = "walk"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "arka_sag_kapi_kutu",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{ -- trunk
		["marker-label"] = "Trunk",
		["kod-isim"] = "bagaj",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Trunk",
		["parca-native-no"] = 5,
		["kordinat"] = {
			["x"] = -555.21,
			["y"] = -1697.39,
			["z"] = 19.18,
			["h"] = 75.46,
		},
		["animasyon"] = {
			["seneryo"] = true,
			["seneryo-anim"] = "PROP_HUMAN_BUM_BIN"
		},
		["prop"] =  "prop_cs_cardbox_01",
		["entity-attach"] = {
			["bone"] = 28422,
			["xPos"] = 0.0,
			["yPos"] = -0.03,
			["zPos"] = 0.0,
			["xRot"] = 5.0,
			["yRot"] = 0.0,
			["zRot"] = 0.0,
		},
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@box_carry@",
			["prop-name"] = "idle"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "bagaj_kutula",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{ -- hood
		["marker-label"] = "Hood",
		["kod-isim"] = "on_kaput",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Hood",
		["parca-native-no"] = 4,
		["kordinat"] = {
			["x"] = -559.76,
			["y"] = -1694.32,
			["z"] = 19.15,
			["h"] = 252.67,
		},
		["animasyon"] = {
			["seneryo"] = true,
			["seneryo-anim"] = "PROP_HUMAN_BUM_BIN"
		},
		["prop"] =  "prop_cs_cardbox_01",
		["entity-attach"] = {
			["bone"] = 28422,
			["xPos"] = 0.0,
			["yPos"] = -0.03,
			["zPos"] = 0.0,
			["xRot"] = 5.0,
			["yRot"] = 0.0,
			["zRot"] = 0.0,
		},
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@box_carry@",
			["prop-name"] = "idle"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "on_kaput_kutula",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{ -- radio
		["marker-label"] = "Radio",
		["kod-isim"] = "radyo",
		["time"] = 6500,
		["progressbar-label"] = "You're Dismantling the Radio",
		["parca-native-no"] = nil,
		["kordinat"] = {
			["x"] = -558.72,
			["y"] = -1696.33,
			["z"] = 19.13,
			["h"] = 313.86,
		},
		["animasyon"] = {
			["seneryo"] = true,
			["seneryo-anim"] = "PROP_HUMAN_BUM_BIN"
		},
		["prop"] =  "prop_cs_cardbox_01",
		["entity-attach"] = {
			["bone"] = 28422,
			["xPos"] = 0.0,
			["yPos"] = -0.03,
			["zPos"] = 0.0,
			["xRot"] = 5.0,
			["yRot"] = 0.0,
			["zRot"] = 0.0,
		},	
		["prop-anim"] = {
			["prop-dics"] = "anim@heists@box_carry@",
			["prop-name"] = "idle"
		}
	},
	{
		["marker-label"] = "Car Part Put In Box",
		["kod-isim"] = "radyo_kutula",
		["time"] = 2500,
		["progressbar-label"] = "...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@heists@load_box",
			["anim-name"] = "load_box_3"
		},
		["prop"] =  "sil",
	},
	{ -- collect parts
		["marker-label"] = "Collect Car Parts",
		["kod-isim"] = "parcaları_al",
		["time"] = 12500,
		["progressbar-label"] = "Collecting car parts...",
		["kordinat"] = {
			["x"] = -556.23,
			["y"] = -1704.21,
			["z"] = 19.06,
			["h"] = 114.17,
		},
		["animasyon"] = {
			["seneryo"] = false,
			["anim-disc"] = "anim@mp_fireworks",
			["anim-name"] = "place_firework_3_box"
		},
		["prop"] =  "son",
	}

}
---@diagnostic disable: lowercase-global, undefined-field, missing-parameter, undefined-global
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	ESX.SetPlayerData("isSentenced", false)
	ESX.SetPlayerData("jail", 0)
	ESX.SetPlayerData("comserv", 0)
	ESX.SetPlayerData("IsDead", false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

local Sounds = { -- In case you wanna change out the sounds they are located here.
	["Close"] = {"TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	["Open"] = {"NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	["Select"] = {"SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"}
}
function SoundPlay(which)
	if Config.NUI.Sound then else return end
	local Sound = Sounds[which]
	PlaySoundFrontend(-1, Sound[1], Sound[2])
end

function ToggleCamera(type)
	if Config.NUI.Camera then else return end
	if type == 'Open' then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		camOffset = vector3(-0.025120, 1.512561, 0.559709)
		SetCamActive(cam, true)
		RenderScriptCams(true, true, 500, true, false)
		SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), camOffset))
		SetCamRot(cam, vector3(-15.0, 0.0, GetEntityHeading(PlayerPedId()) + 180))
	elseif type == 'Close' then
		RenderScriptCams(false, true, 500, true, false)
		DestroyCam(cam, false)
	end
end

local function Check(ped) -- We check if the player should be able to open the menu.
	if IsPedInAnyVehicle(ped) and not Config.NUI.AllowInCars then
		return false
	elseif IsPedSwimmingUnderWater(ped) then
		return false
	elseif IsPedRagdoll(ped) and not Config.NUI.AllowWhenRagdolled then
		return false
	elseif IsHudComponentActive(19) then -- If the weapon wheel is open, we close!
		return false
	end
	return true
end

RegisterNUICallback('close', function(_, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = 'close',
	})
	RenderScriptCams(false, true, 750, true, false)
	DestroyCam(cam, false)
	SoundPlay("Close")
	ToggleCamera("Close")
	InMenu = false
    cb('ok')
end)

local Draw = {
	["torso_1"]     = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
	["tshirt_1"]    = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
	["shoes_1"]     = {Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200},
	["bproof_1"]    = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
	["bags_1"]      = {Dict = "anim@heists@ornate_bank@grab_cash", Anim = "intro", Move = 51, Dur = 1600},
	["mask_1"]      = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800},
    ["pants_1"]     = {Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300},
    ["glasses_1"]   = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
    ["bracelets_1"] = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ["watches_1"]   = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ["chain_1"]     = {Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100},
    ["helmet_1"]    = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200},
    ["decals_1"]    = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ["arms"]        = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ["ears_1"]      = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
}

local Naked = {
    [GetHashKey('mp_m_freemode_01')] = {
		shoes_1 = 34,
		pants_1 = 14,
		torso_1 = 15,
		arms = 15,
		tshirt_1 = 15,
        mask_1 = 0,
        helmet_1 = -1,
        bproof_1 = 0,
        watches_1 = -1,
        bracelets_1 = -1,
        decals_1 = 0,
        bags_1 = 0,
        chain_1 = 0,
        glasses_1 = 0,
        ears_1 = -1,
    },
    [GetHashKey('mp_f_freemode_01')] = {
		shoes_1 = 35,
		pants_1 = 14,
		torso_1 = 15,
		arms = 15,
		tshirt_1 = 15,
        mask_1 = 0,
        helmet_1 = -1,
        bproof_1 = 0,
        watches_1 = -1,
        bracelets_1 = -1,
        decals_1 = 0,
        bags_1 = 0,
        chain_1 = 0,
        glasses_1 = 5,
        ears_1 = -1,
    }
}

local ReCheck = {
	['Pants'] = "pants_1",
	['Shoes'] = "shoes_1",
	['Bag']   = "bags_1",
	['Gloves']= "arms",
	['Watch'] = "watches_1",
	['Top']   = "torso_1",
	['Shirt'] = "tshirt_1",
	['Vest'] = "bproof_1",
	['Glasses'] = 'glasses_1',
	['Mask'] = "mask_1",
	["Neck"] = "chain_1",
	['Hat'] = "helmet_1",
	['Bracelets']= "bracelets_1",
	['Earrings'] = "ears_1",
}

local Jobs = {
	["police"] = true,
	["sheriff"] = true,
	["forces"] = true,
	["fbi"] = true,
	["justice"] = true,
	["taxi"] = true,
	["benny"] = true,
	["mechanic"] = true,
	["weazel"] = true,
	["ambulance"] = true,
	["medic"] = true,
}

local JobBlacklist = {
	["torso_1"] = true,
	["tshirt_1"]= true,
	["pants_1"] = true,
	["shoes_1"] = true,
}

local CustomBproof = {
	[79] = {
		[0] = "KingOfKing",
		[1] = "DarkRose",
		[2] = "HYDRA",
		[3] = "Vendetta",
		[4] = "Liquid",
		[5] = "Veneto",
		[6] = "Vigo",
		[7] = "Avengers",
		[8] = "Rebel",
		[9] = "Crows",
		[10] = "Pahlavi",
		[11] = "PERSIAN",
		[12] = "Rex",
		[13] = "Vision",
		[14] = "Sicilian",
		[15] = "GHATELIN",
		[16] = "SNO",
		[17] = "Rebel",
		[18] = "OWL",
	},
}

local Sellable = {
	[GetHashKey('mp_m_freemode_01')] = {
		["tshirt_1"] = {
			[242] = "AK Rooye Sine",
		},
		["bags_1"] = {
			[119] = "Aslahe M4",
			[120] = "Katana Talayi",
		},
		["bproof_1"] = {
			[105] = "Ball Meshki",
		},
		["chain_1"] = {
			[178] = "Katana Rangi",
			[211] = "AK Baghal",
		},
		["mask_1"] = {
			[261] = "Baby Rooye Sine",
		},
	},
	[GetHashKey('mp_f_freemode_01')] = {
		["tshirt_1"] = {
			[311] = "AK Rooye Sine",
		},
		["bags_1"] = {
			[148] = "Katana Talayi",
		},
		["bproof_1"] = {
			[69] = "Barbie",
			[129] = "Ball Meshki",
		},
		["mask_1"] = {
			[192] = "Baby Rooye Sine",
			[208] = "Katana Rangi",
			[246] = "Baby Rooye Sine",
		},
		["pants_1"] = {
			[291] = "Kitty Socks",
		},
	},
}

lastArmor = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(750)
		if GetPedArmour(PlayerPedId()) >= lastArmor then
			lastArmor = 0
		end
	end
end)

Requip = {}
local coolDown = false

RegisterNUICallback('changecloth', function(data, cb)
	local data = data
	data = ReCheck[data]
	local e = Draw[data]
	if data then
		if Jobs[PlayerData.job.name] and JobBlacklist[data] then return ESX.Alert("Shoma Nemitavanid On-Duty In Noe Lebas Ra Dar Biarid", "info") end
		if coolDown then return end
		coolDown = true
		Citizen.SetTimeout(3200, function()
			coolDown = false
		end)
		local clothe1 = data
        local clothe2 = string.gsub(clothe1, "_1", "_2")
        if clothe1 == "arms" then
            clothe2 = "arms_2"
        end
		local gender
		if GetHashKey('mp_m_freemode_01') == GetEntityModel(PlayerPedId()) then
			gender = "m"
		end
		if GetHashKey('mp_f_freemode_01') == GetEntityModel(PlayerPedId()) then
			gender = "f"
		end
		if not gender then return end
		--if Sellable[GetEntityModel(PlayerPedId())][clothe1] and Sellable[GetEntityModel(PlayerPedId())][clothe1][add] then return ESX.Alert("In Lebas Ghabel Estefade Nist", "info") end
		if not Requip[clothe1] then
			TriggerEvent("skinchanger:getSkin", function(skin)
				local add = skin[clothe1]
				local add1 = skin[clothe2]
				if Naked[GetEntityModel(PlayerPedId())][clothe1] and Naked[GetEntityModel(PlayerPedId())][clothe1] == add then return end
				local lokht = Naked[GetEntityModel(PlayerPedId())][clothe1]
				PlayToggleEmote(e, function()
					TriggerEvent("skinchanger:change", clothe1, lokht, function()
						Citizen.Wait(150)
						TriggerEvent("skinchanger:change", clothe2, 0, function()
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								local skin = skin
								skin[clothe1] = lokht
								skin[clothe2] = 0
								TriggerServerEvent('esx_skin:save', skin)
								if clothe1 == "bproof_1" then
									lastArmor = GetPedArmour(PlayerPedId())
									ESX.SetPedArmour(PlayerPedId(), 0)
								end
							end)
						end)
					end)
				end)
				ESX.TriggerServerCallback("esx_clothe:addCurrentClothe", function()
					Requip[clothe1] = {
						first = add,
						last = add1,
						item = gender.."_"..clothe1.."_"..add.."_"..add1
					}
				end, gender.."_"..clothe1.."_"..add.."_"..add1)
			end)
		else
			if ESX.DoesHaveItem2(Requip[clothe1].item, 1) then
				PlayToggleEmote(e, function()
					TriggerEvent("skinchanger:change", clothe1, Requip[clothe1].first, function()
						Citizen.Wait(100)
						TriggerEvent("skinchanger:change", clothe2, Requip[clothe1].last, function()
							TriggerServerEvent("esx_clothe:RemoveClothe", Requip[clothe1].item)
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								local skin = skin
								skin[clothe1] = Requip[clothe1].first
								skin[clothe2] = Requip[clothe1].last
								TriggerServerEvent('esx_skin:save', skin)
								Requip[clothe1] = nil
								if clothe1 == "bproof_1" then
									if lastArmor > 0 then
										ESX.SetPedArmour(PlayerPedId(), lastArmor)
										lastArmor = 0
									end
								end
							end)
						end)
					end)
				end)
			else
				Requip[clothe1] = nil
			end
		end
	end
end)

function PlayToggleEmote(e, cb)
	local Ped = PlayerPedId()
	while not HasAnimDictLoaded(e.Dict) do RequestAnimDict(e.Dict) Wait(100) end
	if IsPedInAnyVehicle(Ped) then e.Move = 51 end
	TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, e.Dur, e.Move, 0, false, false, false)
	local Pause = e.Dur-500 if Pause < 500 then Pause = 500 end
	IncurCooldown(Pause)
	Wait(Pause) -- Lets wait for the emote to play for a bit then do the callback.
	cb()
end

function IncurCooldown(ms)
	Citizen.CreateThread(function()
		Cooldown = true Wait(ms) Cooldown = false
	end)
end

RegisterNetEvent("esx_clothes:PutClothe")
AddEventHandler("esx_clothes:PutClothe", function(gender, clothe, code, color)
    if Cooldown then return end
    local e = Draw[clothe]
    if e then
        local clothe1 = clothe
        local clothe2 = string.gsub(clothe1, "_1", "_2")
        if clothe1 == "arms" then
            clothe2 = "arms_2"
        end
		if Jobs[PlayerData.job.name] and JobBlacklist[clothe1] then return ESX.Alert("Shoma Nemitavanid On-Duty In Noe Lebas Ra Bepooshid", "info") end
        if gender == "m" then
            if GetHashKey('mp_m_freemode_01') ~= GetEntityModel(PlayerPedId()) then
                return ESX.Alert("Shoma Nemitavanid Lebas Mardane Bepooshid", "info")
            end
        end
        if gender == "f" then
            if GetHashKey('mp_f_freemode_01') ~= GetEntityModel(PlayerPedId()) then
                return ESX.Alert("Shoma Nemitavanid Lebas Zanane Bepooshid", "info")
            end
        end
		if clothe == "bproof_1" and gender == "m" then
			if CustomBproof[code] and CustomBproof[code][color] then
				if PlayerData.gang.name ~= CustomBproof[code][color] then return ESX.Alert("Shoma Ejaze Pooshidan In Vest Ra Nadarid", "info") end
			end
		end
		if clothe == "torso_1" and gender == "m" then
			if code == 558 and color == 0 then
				if PlayerData.gang.name ~= "HellsAngels" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
			if code == 558 and color == 1 then
				if PlayerData.gang.name ~= "HellsAngels" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
			if code == 558 and color == 2 then
				if PlayerData.gang.name ~= "HellsAngels" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
			if code == 558 and color == 3 then
				if PlayerData.gang.name ~= "HellsAngels" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
			if code == 535 and color == 1 then
				if PlayerData.gang.name ~= "KingOfKing" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
			if code == 535 and color == 2 then
				if PlayerData.gang.name ~= "Crows" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
			if code == 535 and color == 0 then
				if PlayerData.gang.name ~= "Vision" then return ESX.Alert("Shoma Ejaze Pooshidan In Lebas Ra Nadarid", "info") end
			end
		end
		--if Sellable[GetEntityModel(PlayerPedId())][clothe1] and Sellable[GetEntityModel(PlayerPedId())][clothe1][code] then return ESX.Alert("In Lebas Ghabel Estefade Nist", "info") end
        TriggerEvent("skinchanger:getSkin", function(skin)
            local add = skin[clothe1]
            local add1 = skin[clothe2]
            PlayToggleEmote(e, function()
                TriggerEvent("skinchanger:change", clothe1, code, function()
                    Citizen.Wait(100)
                    TriggerEvent("skinchanger:change", clothe2, color, function()
                        TriggerServerEvent("esx_clothe:RemoveClothe", gender.."_"..clothe1.."_"..code.."_"..color)
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							local skin = skin
							skin[clothe1] = code
							skin[clothe2] = color
							TriggerServerEvent('esx_skin:save', skin)
							if clothe1 == "bproof_1" then
								if lastArmor > 0 then
									ESX.SetPedArmour(PlayerPedId(), lastArmor)
									lastArmor = 0
								end
							end
						end)
                    end)
                end)
            end)
            if Naked[GetEntityModel(PlayerPedId())][clothe1] and Naked[GetEntityModel(PlayerPedId())][clothe1] == add then return end
            ESX.TriggerServerCallback("esx_clothe:addCurrentClothe", function()
            
            end, gender.."_"..clothe1.."_"..add.."_"..add1)
        end)
    end
end)

RegisterNUICallback('reset', function(data, cb)
	ResetClothing()
	Wait(1000)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = 'close',
	})
	RenderScriptCams(false, true, 750, true, false)
	DestroyCam(cam, false)
	SoundPlay("Close")
	ToggleCamera("Close")
	InMenu = false
    cb('ok')
end)

AddEventHandler('esx:onPlayerDeath', function()
	if IsNuiFocused() and InMenu then
		SetNuiFocus(false, false)
		SendNUIMessage({
			action = 'close',
		})
		RenderScriptCams(false, true, 750, true, false)
		DestroyCam(cam, false)
		ToggleCamera("Close")
		InMenu = false
	end
end)

AddEventHandler("onKeyDown", function(key)
	if IsNuiFocused() then return end
	if key == "k" then
		if exports.esx_carwash:doesHaveEmber() then return end
		if IsHelpMessageBeingDisplayed() then return end
		if ESX.GetPlayerData().isSentenced then return end
		if ESX.isDead() then return end
		ShowClothingUI()
	end
end)

function ShowClothingUI()
	local Ped = PlayerPedId()
	if Check(Ped) then
		SoundPlay("Open")
		ToggleCamera("Open")
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'open',
		})
		SetNuiFocus(true, true)
		InMenu = true
	end
end

function rotation(dir)
    local pedRot = GetEntityHeading(PlayerPedId())+dir
    SetEntityHeading(PlayerPedId(), pedRot % 360)
end

local specialCache = {}

RegisterNetEvent("esx_clothes:PutSpecialClothe")
AddEventHandler("esx_clothes:PutSpecialClothe", function(gender, clothe, code)
	local clothe1 = clothe
	local clothe2 = string.gsub(clothe1, "_1", "_2")
	local e = Draw[clothe]
	if Jobs[PlayerData.job.name] and JobBlacklist[clothe1] then return ESX.Alert("Shoma Nemitavanid On-Duty In Noe Lebas Ra Bepooshid", "info") end
    if e then
		if gender == "m" then
			if GetHashKey('mp_m_freemode_01') ~= GetEntityModel(PlayerPedId()) then
				return ESX.Alert("Shoma Nemitavanid Lebas Mardane Bepooshid", "info")
			end
		end
		if gender == "f" then
			if GetHashKey('mp_f_freemode_01') ~= GetEntityModel(PlayerPedId()) then
				return ESX.Alert("Shoma Nemitavanid Lebas Zanane Bepooshid", "info")
			end
		end
		if not specialCache[clothe1] then
			specialCache[clothe1] = {}
		end
		if not specialCache[clothe1][code] then
			TriggerEvent("skinchanger:getSkin", function(skin)
				local add = skin[clothe1]
				local add1 = skin[clothe2]
				PlayToggleEmote(e, function()
					TriggerEvent("skinchanger:change", clothe1, code, function()
						Citizen.Wait(100)
						TriggerEvent("skinchanger:change", clothe2, 0, function()
							specialCache[clothe1][code] = {
								[1] = add,
								[2] = add1
							}
						end)
					end)
				end)
			end)
		else
			TriggerEvent("skinchanger:getSkin", function(skin)
				PlayToggleEmote(e, function()
					TriggerEvent("skinchanger:change", clothe1, specialCache[clothe1][code][1], function()
						Citizen.Wait(100)
						TriggerEvent("skinchanger:change", clothe2, specialCache[clothe1][code][2], function()
							specialCache[clothe1][code] = nil
						end)
					end)
				end)
			end)
		end
	end
end)
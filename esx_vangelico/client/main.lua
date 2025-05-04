---@diagnostic disable: undefined-field, lowercase-global, param-type-mismatch, missing-parameter, undefined-global
local holdingup = false
local store = ""
local blipRobbery = nil
local vetrineRotte = 0 
local Near = false
local RobName = nil
local RobTable = nil 
local animazione = false
local incircle = false
local soundid = GetSoundId()

local vetrine = {
	["JewelryUP"] = {
		{x = 147.085, y = -1048.612, z = 29.346, heading = 70.326, isOpen = false},--
		{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false},--
		{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false},--
		{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false},--
		{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false},--
		{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false},--
		{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false},--
		{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false},--
		{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false},--
		{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false},--
		{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false},--
		{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false},--
		{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false},--
		{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false},--
		{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false},--
		{x = -619.686, y = -227.753, z = 38.057, heading = 305.245, isOpen = false},--
		{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false},--
		{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false},--
		{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false},--
		{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false},--
		{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false},--
	},
	["JewelryDown"] = {
		{x = 830.01, y = -2014.05, z = 29.33, heading = 180.59, isOpen = false},--
		{x = 828.71, y = -2013.94, z = 29.33, heading = 178.66, isOpen = false},--
		{x = 827.3, y = -2013.8, z = 29.33, heading = 178.34, isOpen = false},--
		{x = 826.04, y = -2013.69, z = 29.33, heading = 172.62, isOpen = false},--
		{x = 825.92, y = -2015.62, z = 29.33, heading = 358.22, isOpen = false},--
		{x = 827.28, y = -2015.73, z = 29.33, heading = 351.6, isOpen = false},--
		{x = 828.6, y = -2015.85, z = 29.33, heading = 350.75, isOpen = false},--
		{x = 829.91, y = -2015.98, z = 29.33, heading = 357.96, isOpen = false},--
		{x = 828.5, y = -2021.07, z = 29.33, heading = 176.05, isOpen = false},--
		{x = 829.84, y = -2021.28, z = 29.33, heading = 176.65, isOpen = false},--
		{x = 831.11, y = -2021.39, z = 29.33, heading = 183.31, isOpen = false},--
		{x = 832.46, y = -2021.51, z = 29.33, heading = 176.35, isOpen = false},--
		{x = 832.39, y = -2023.37, z = 29.33, heading = 357.66, isOpen = false},--
		{x = 831.09, y = -2023.25, z = 29.33, heading = 354.1, isOpen = false},--
		{x = 829.67, y = -2023.18, z = 29.33, heading = 354.54, isOpen = false},--
		{x = 828.39, y = -2023.03, z = 29.33, heading = 353.81, isOpen = false},--
		{x = 827.45, y = -2031.58, z = 29.33, heading = 176.03, isOpen = false},--
		{x = 828.81, y = -2031.66, z = 29.33, heading = 175.52, isOpen = false},--
		{x = 830.12, y = -2031.85, z = 29.33, heading = 176.76, isOpen = false},--
		{x = 831.36, y = -2031.98, z = 29.33, heading = 176.8, isOpen = false},--
		{x = 831.36, y = -2033.81, z = 29.33, heading = 358.01, isOpen = false},--
		{x = 830.06, y = -2033.69, z = 29.33, heading = 354.28, isOpen = false},--
		{x = 828.74, y = -2033.57, z = 29.33, heading = 357.45, isOpen = false},--
		{x = 827.47, y = -2033.49, z = 29.33, heading = 355.97, isOpen = false},--
	},
	["JewelryUPSide"] = {
		{x = 2734.47, y =  3473.45, z = 55.77, heading = 251.94, isOpen = false},--
		{x = 2736.24, y =  3472.76, z = 55.77, heading = 71.92, isOpen = false},--
		{x = 2739.77, y =  3481.32, z = 55.77, heading = 74.95, isOpen = false},--
		{x = 2738.02, y =  3481.87, z = 55.77, heading = 253.64, isOpen = false},--
		{x = 2740.93, y =  3486.64, z = 56.44, heading = 343.66, isOpen = false},--
		{x = 2743.67, y =  3487.62, z = 56.44, heading = 59.89, isOpen = false},--
		{x = 2739.71, y =  3489.19, z = 56.44, heading = 245.93, isOpen = false},--
		{x = 2738.03, y =  3490.05, z = 56.44, heading = 29.87, isOpen = false},--
		{x = 2746.07, y =  3485.18, z = 56.44, heading = 310.99, isOpen = false},--
		{x = 2749.21,  y = 3483.31, z = 56.44, heading = 250.75, isOpen = false},--
		{x = 2749.62, y = 3484.54, z = 56.44, heading = 244.81, isOpen = false},--
		{x = 2732.87, y = 3467.42, z = 56.44, heading = 154.26, isOpen = false},--
		{x = 2730.29, y = 3466.47, z = 56.44, heading = 253.93, isOpen = false},--
		{x = 2734.21, y = 3464.99, z = 56.44, heading = 59.35, isOpen = false},--
		{x = 2728.59, y = 3467.31, z = 56.44, heading = 117.64, isOpen = false},--
		{x = 2736.69, y = 3464.68, z = 56.44, heading = 214.97, isOpen = false},--
		{x = 2740.63, y = 3462.55, z = 56.44, heading = 246.89, isOpen = false},--
		{x = 2741.12, y = 3463.74, z = 56.44, heading = 250.61, isOpen = false},--
		{x = 2728.09, y = 3469.57, z = 56.44, heading = 330.67, isOpen = false},--
		{x = 2736.06, y = 3488.64, z = 56.44, heading = 153.62, isOpen = false},--
	},
	["JewelryMiddle"] = {
		{x = 82.9,  y = -1585.91, z = 29.63, heading = 47.38, isOpen = false},--
		--{x = 82.03, y = -1586.92, z = 29.63, heading = 47.37, isOpen = false},--
		{x = 79.35, y = -1586.62, z = 29.63, heading = 317.81, isOpen = false},--
		--{x = 79.06, y = -1583.66, z = 29.62, heading = 227.52, isOpen = false},--
		{x = 81.94, y = -1583.34, z = 29.63, heading = 138.8, isOpen = false},--
		--{x = 76.17, y = -1583.29, z = 29.62, heading = 139.02, isOpen = false},--
		{x = 75.08, y = -1582.43, z = 29.62, heading = 138.77, isOpen = false},--
		--{x = 75.02, y = -1584.73, z = 29.62, heading = 323.18, isOpen = false},--
		{x = 73.96, y = -1583.83, z = 29.62, heading = 318.48, isOpen = false},--
		--{x = 77.37, y = -1579.83, z = 29.62, heading = 316.03, isOpen = false},--
		{x = 78.37, y = -1580.67, z = 29.62, heading = 322.4, isOpen = false},--
		--{x = 79.47, y = -1579.21, z = 29.62, heading = 139.6, isOpen = false},--
		{x = 78.49, y = -1578.31, z = 29.62, heading = 140.35, isOpen = false},--
		--{x = 75.13, y = -1575.6,  z = 29.61, heading = 139.24, isOpen = false},--
		{x = 74.13, y = -1574.74, z = 29.61, heading = 140.56, isOpen = false},--
		--{x = 73.01, y = -1576.19, z = 29.61, heading = 321.85, isOpen = false},--
		{x = 73.93, y = -1577.05, z = 29.61, heading = 318.53, isOpen = false},--
		--{x = 71.96, y = -1579.76, z = 29.61, heading = 138.52, isOpen = false},--
		{x = 70.93, y = -1578.93, z = 29.61, heading = 140.69, isOpen = false},--
		--{x = 69.81, y = -1580.42, z = 29.61, heading = 321.15, isOpen = false},--
		{x = 70.79, y = -1581.34, z = 29.61, heading = 323.64, isOpen = false},--
	},
}

ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function RobThread()
	if holdingup then
		local pos = GetEntityCoords(PlayerPedId())
		local a = tLength(vetrine[store])
		if a > 20 then
			a = 20
		end
		drawTxt(0.3, 1.4, 0.45, _U('smash_case') .. ' :~r~ ' .. vetrineRotte .. '/' .. a , 185, 185, 185, 255)

		for i,v in pairs(vetrine[RobName]) do 
			if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 10.0) and not v.isOpen and Config.EnableMarker then
				DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 0, 255, 0, 200, 1, 1, 0, 0)
			end
			if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 0.75) and not v.isOpen then 
				if IsControlJustPressed(0, 38) then
					exports.essentialmode:DisableControl(true)
					ESX.SetPlayerData('isSentenced', true)
					ESX.SetEntityCoords(PlayerPedId(), v.x, v.y, v.z-0.95)
					SetEntityHeading(PlayerPedId(), v.heading)
					v.isOpen = true 
					PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
					if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
					RequestNamedPtfxAsset("scr_jewelheist")
					end
					while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
					Citizen.Wait(0)
					end
					SetPtfxAssetNextCall("scr_jewelheist")
					StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
					loadAnimDict( "missheist_jewel" ) 
					TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
					TriggerEvent("mt:missiontext", _U('collectinprogress'), 3000)
					--DisplayHelpText(_U('collectinprogress'))
					DrawSubtitleTimed(5000, 1)
					Citizen.Wait(7000)
					ClearPedTasksImmediately(PlayerPedId())
					TriggerServerEvent('esx_vangelico:GetJewel')
					PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					vetrineRotte = vetrineRotte+1
					animazione = false
					exports.essentialmode:DisableControl(false)
					if vetrineRotte == a then 
						for q, s in pairs(vetrine[RobName]) do 
							s.isOpen = false
							vetrineRotte = 0
						end
						TriggerServerEvent('esx_vangelico:RobberyCompleted', store)
						ESX.Alert(_U('lester'), "info")
						holdingup = false
						StopSound(soundid)
					end
					ESX.SetPlayerData('isSentenced', false)
				end
			end	
		end

		local pos2 = Stores[store].position

		if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pos2, true) > 50.5 ) then
			TriggerServerEvent('esx_vangelico:FarFromRob', store)
			holdingup = false
			for i,v in pairs(vetrine[RobName]) do 
				v.isOpen = false
				vetrineRotte = 0
			end
			StopSound(soundid)
		end
		SetTimeout(0, RobThread)
	end
end

RegisterNetEvent('esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('esx_vangelico_robbery:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
	RobThread()
end)

RegisterNetEvent('esx_vangelico:ForceRemoveSound')
AddEventHandler('esx_vangelico:ForceRemoveSound', function()
    StopSound(soundid)
end)

RegisterNetEvent('esx_vangelico_robbery:killblip')
AddEventHandler('esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:setblip')
AddEventHandler('esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
	SetTimeout(10*60*1000, function()
		RemoveBlip(blipRobbery)
	end)
end)

RegisterNetEvent('esx_vangelico_robbery:toofarlocal')
AddEventHandler('esx_vangelico_robbery:toofarlocal', function(robb)
	holdingup = false
	ESX.Alert(_U('robbery_cancelled'), "info")
	robbingName = ""
	incircle = false
end)

RegisterNetEvent('esx_vangelico:StartHack')
AddEventHandler('esx_vangelico:StartHack', function()
	exports.minigame:MiniGame(60, function(success)
		if success then
			ESX.Alert("~g~ Hack Completed", "info")
			TriggerServerEvent('esx_vangelico:HackCompleted', RobName)
		else                                         
			TriggerServerEvent("esx_vangelico:HackFailed", RobName)
		end
	end)
end)

--[[AddEventHandler("datacrack", function(output)
    if output then
        if not holdingup then
			ESX.Alert("~g~ Hack Completed")
			TriggerServerEvent('esx_vangelico:HackCompleted', RobName)
		end
	else
		TriggerServerEvent("esx_vangelico:HackFailed", RobName)
    end
end)]]

RegisterNetEvent('esx_vangelico_robbery:robberycomplete')
AddEventHandler('esx_vangelico_robbery:robberycomplete', function(robb)
	holdingup = false
	ESX.Alert(_U('robbery_complete'), "info")
	store = ""
	incircle = false
end)

Citizen.CreateThread(function()
	for k,v in pairs(Stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 617)
		SetBlipScale(blip, 0.6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('shop_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

function drawTxt(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.64, 0.64)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.155, 0.935)
end

local WhiteBags = {
	[`mp_m_freemode_01`] = {
		[10] = true,
		[11] = true,
		[12] = true,
		[13] = true,
		[45] = true,
		[46] = true,
		[49] = true,
		[50] = true,
		[57] = true,
		[86] = true,
		[87] = true,
		[90] = true,
		[91] = true,
	},
	[`mp_f_freemode_01`] = {
		[40] = true,
		[41] = true,
		[44] = true,
		[45] = true,
		[81] = true,
		[82] = true,
		[85] = true,
		[86] = true,
	},
}

AddEventHandler("onKeyUP", function(key)
	if key == "e" and not holdingup and Near then
		if Config.NeedBag then
			--if WhiteBags[GetEntityModel(PlayerPedId())][GetPedDrawableVariation(PlayerPedId(), 5)] then
				ESX.TriggerServerCallback('esx_vangelico:GetCopAmount', function(CopsConnected)
					if CopsConnected >= Config.RequiredCopsRob then
						TriggerServerEvent('esx_vangelico:CheckCoolDown', RobName)
						PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", RobTable.position.x, RobTable.position.y, RobTable.position.z)
					else
						TriggerEvent('esx:showNotification', _U('min_two_police') .. Config.RequiredCopsRob .. _U('min_two_police2'))
					end
				end)
			--[[else
				TriggerEvent('esx:showNotification', 'Shoma be Kif Ehtiaj Darid, Agar Kif Darid Say konid Zip Kif ro Baz Konid!', "info")
			end]]
		else
			ESX.TriggerServerCallback('esx_vangelico:GetCopAmount', function(CopsConnected)
				if CopsConnected >= Config.RequiredCopsRob then
					TriggerServerEvent('esx_vangelico_robbery:rob', RobName)
					PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", RobTable.position.x, RobTable.position.y, RobTable.position.z)
				else
					TriggerEvent('esx:showNotification', _U('min_two_police') .. Config.RequiredCopsRob .. _U('min_two_police2'))
				end
			end)
		end
	end
end)

CreateThread(function()
	while true do 
		Citizen.Wait(2)
		local Sleep = true
		for k, v in pairs(Stores) do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.position.x, v.position.y, v.position.z) , true) <= Config.DrawDistance then
				Sleep = false
				if not holdingup then
					DrawMarker(27, v.position.x, v.position.y, v.position.z-0.9, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.position.x, v.position.y, v.position.z) , true) <= 1.0 then
						Near = true
						RobName = k
						RobTable = v
					end
				end
			end
		end
		if Sleep then Near = false Wait(730) end
	end
end)

RegisterNetEvent("lester:createBlip")
AddEventHandler("lester:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	if(type == 77)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Lester")
		EndTextCommandSetBlipName(blip)
	end
end)

local Block = false

AddEventHandler("onKeyDown", function(key)
	if key == "e" then
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(707.87, -960.5, 30.413) , true) <= Config.DrawDistance then
			if not Block then
				Block = true
				ESX.TriggerServerCallback('esx_vangelico:GetItemAmount', function(quantity)
					if quantity >= Config.MaxJewelsSell then
						FreezeEntityPosition(playerPed, true)
						TriggerEvent('mt:missiontext', _U('goldsell'), 10000)
						Wait(1000)
						FreezeEntityPosition(playerPed, false)
						TriggerServerEvent('esx_vangelico:SellJewels')
						Block = false
					else
						Block = false
						TriggerEvent('esx:showNotification', _U('notenoughgold'))
					end
				end, 'jewels')
			else
				ESX.Alert("Lotfan Spam Nakonid", "info")
			end
		end
	end
end)

Citizen.CreateThread(function()
	local sellpos = vector3(707.87, -960.5, 30.413)
	TriggerEvent('lester:createBlip', 77, sellpos)
	while true do 
		Citizen.Wait(2)
		local Sleeps = true 
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), sellpos , true) <= Config.DrawDistance then
			Sleeps = false
			DrawMarker(20, sellpos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
		end
		if Sleeps then Citizen.Wait(740) end
	end
end)

local StartGangXP = false
local gangpos

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	--[[while xPlayer.gang == nil do
        Citizen.Wait(10)
    end 
	if xPlayer.gang.name ~= 'nogang' then
		ESX.TriggerServerCallback('gangs:getGangData', function(data)
			if data ~= nil then
				gangpos = json.decode(data.blip)
			end
		end, xPlayer.gang.name)
	end]]
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
	--[[while gang == nil do
        Citizen.Wait(10)
    end 
	if gang.name ~= 'nogang' then
		ESX.TriggerServerCallback('gangs:getGangData', function(data)
			if data ~= nil then
				gangpos = json.decode(data.blip)
			end
		end, gang.name)
	end]]
end)

function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end

	return l
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function drawTxtGang(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - width/5, y - height/2 + 0.005)
end


-----------Code-----------------------

--[[Citizen.CreateThread(function()
	local sellpos = vector3(707.87, -960.5, 30.413)
	TriggerEvent('lester:createBlip', 77, sellpos)

	local Interact
	local Key
	local Point = RegisterPoint(sellpos, Config.DrawDistance, true)
	Point.set('InArea', function ()
		if not blip then
			DrawMarker(20, sellpos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
		end
	end)
	Point.set('InAreaOnce', function ()
		Interact = RegisterPoint(sellpos, 1, true)
		Interact.set('InAreaOnce', function ()
			Hint:Create(_U('press_to_sell'))
			Key = RegisterKey('E', false, function ()
				Hint:Delete()
				Key = UnregisterKey(Key)
				ESX.TriggerServerCallback('esx_vangelico:GetItemAmount', function(quantity)
					if quantity >= Config.MaxJewelsSell then
						FreezeEntityPosition(playerPed, true)
						TriggerEvent('mt:missiontext', _U('goldsell'), 10000)
						Wait(10000)
						FreezeEntityPosition(playerPed, false)
						TriggerServerEvent('lester:vendita')
					else
						TriggerEvent('esx:showNotification', _U('notenoughgold'))
					end
				end, 'jewels')
			end)
		end, function ()
			Key = UnregisterKey(Key)
			Hint:Delete()
		end)
	end, function ()
		if Interact then
			Interact = Interact.remove()
		end
	end)
end)]]
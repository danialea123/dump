---@diagnostic disable: discard-returns, undefined-global, lowercase-global, need-check-nil, undefined-field, param-type-mismatch, missing-parameter
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local menuIsShowed = false
local hintIsShowed = false
local hasAlreadyEnteredMarker = false
local Blips = {}
JobBlips = {}
local isInMarker = false
local isInPublicMarker = false
local frist = true
local hintToDisplay = "no hint to display"
local onDuty = false
local spawner = 0
local myPlate = {}
local vehicleObjInCaseofDrop = nil
local vehicleInCaseofDrop = nil
local dozd = false
local jobcars = {
	["phantom"] = true,
	["benson"] = true,
	["tanker"] = true,
	["trailers"] = true,
}
local vehicleMaxHealth = nil

ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().gang == nil do 
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
	local str = string.reverse(ESX.GetPlayerData().identifier)
	local counter = 0
	local last = ""
	str:gsub(".", function(c)
		if counter < 6 then
			counter = counter + 1
			last = last..c
		end
	end)
	print(last)
	ESX.SetPlayerData("rawid", last)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	for k,v in pairs(Config.Jobs) do
		if PlayerData.job.name == k then
			currentJob = v
			currentZones = v.Zones
		end
	end
	CreatePoint()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local found = false

    PlayerData.job = job
	for k,v in pairs(Config.Jobs) do
		if PlayerData.job.name == k then
			currentJob = v
			currentZones = v.Zones
			found = true
		end
	end
	if not found then
		currentJob = nil
		currentZones = nil
		SetResourceKvpInt("onDuty", 0)
	end
end)

RegisterNetEvent('esx_jobs:ActivateJobForOrgans')
AddEventHandler('esx_jobs:ActivateJobForOrgans', function(job, grade)
	local job = job
	local grade = grade
	Citizen.Wait(math.random(2500, 4000))
	PlayerData.job.name = job
	PlayerData.job.grade = grade
	local found = false
	for k,v in pairs(Config.Jobs) do
		if job == k then
			currentJob = v
			currentZones = v.Zones
			found = true
			break
		end
	end
	if not found then
		currentJob = nil
		currentZones = nil
		SetResourceKvpInt("onDuty", 0)
	end
	exports.sr_main:RemoveByTag("esx_jobs")
	onDuty = false
	local ond = GetResourceKvpInt("onDuty")
	if ond == 1 then
		onDuty = true
	else
		onDuty = false
	end
	myPlate = {} -- loosing vehicle caution in case player changes job.
	spawner = 0
	deleteBlips()
	refreshBlips()
	CreatePoint()
end)

AddEventHandler('skinchanger:PlayerLoaded', function()
	while PlayerData.job == nil do
		Citizen.Wait(10)
	end
	refreshBlips()
end)

local Pointer = {
    ["lumberjack"] = {
        [1] = vector2(1200.63, -1276.39),
        [2] = vector2(1191.96, -1261.77),
        [3] = vector2(-531.86, 5373.34),
        [4] = vector2(1201.26, -1327.73),
    },
    ["slaughterer"] = {
        [1] = vector2(-1071.06, -2003.75),
        [2] = vector2(-1042.94, -2023.25),
        [3] = vector2(-62.34, 6239.67),
        [4] = vector2(-596.12, -889.25),
    },
    ["hunter"] = {
        [1] = vector2(-567.95, 5253.26),
        [2] = vector2(-96.82, 6205.78),
        [3] = vector2(-62.34, 6239.67),
        [4] = vector2(-596.12, -889.25),
    },
    ["miner"] = {
        [1] = vector2(892.19, -2172.8),
        [2] = vector2(884.72, -2176.47),
        [3] = vector2(318.26, 2864.48),
        [4] = vector2(1114.04, -2006.19),
        [5] = vector2(-91.59, -1029.91),
        [6] = vector2(-149.29, -1040.09),
        [7] = vector2(-620.5, -228.4),
        [8] = vector2(892.19, -2172.8),
    },
    ["fueler"] = {
        [1] = vector2(557.92, -2327.83),
        [2] = vector2(554.59, -2314.43),
        [3] = vector2(611.05, 2860.98),
        [4] = vector2(2737.04, 1416.92),
        [5] = vector2(265.42, -3012.44),
        [6] = vector2(492.06, -2162.7),
    },
    ["fisherman"] = {
        [1] = vector2(868.24, -1639.66),
        [2] = vector2(880.49, -1663.94),
        [3] = vector2(-1546.67, -1294.84),
        [4] = vector2(-1012.51,-1354.52),
    }
}

function OpenMenu()
	ESX.UI.Menu.CloseAll()
	--[[for k, v in pairs(JobBlips) do
		SetBlipRoute(v, false)
	end]]
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		elements = {
			{label = _U('job_wear'),     value = 'job_wear'},
			{label = _U('citizen_wear'), value = 'citizen_wear'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			onDuty = false
			SetResourceKvpInt("onDuty", 0)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				if skin then
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)
		elseif data.current.value == 'job_wear' then
			onDuty = true
			SetResourceKvpInt("onDuty", 1)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
			if Pointer[PlayerData.job.name] then
				SetNewWaypoint(Pointer[PlayerData.job.name][2].x, Pointer[PlayerData.job.name][2].y)
			end
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	local ond = GetResourceKvpInt("onDuty")
	if ond == 1 then
		onDuty = true
	else
		onDuty = false
	end
end)

AddEventHandler('esx_jobs:action', function(job, zone, zonename)
	menuIsShowed = true
	if zone.Type == "cloakroom" then
		OpenMenu()
	elseif zone.Type == "work" then
		if PlayerData.job.name == "slaughterer" then 
			if zonename == "AliveChicken" then
				SetNewWaypoint(-77.99, 6229.06)
			end
			if zonename == "SlaughterHouse" then
				SetNewWaypoint(-101.97, 6208.79)
			end
			if zonename == "Packaging" then
				SetNewWaypoint(-596.15, -889.32)
			end
		end
		if PlayerData.job.name == "lumberjack" then 
			if zonename == "Wood" then
				SetNewWaypoint(-552.21, 5326.90)
			end
			if zonename == "CuttedWood" then
				SetNewWaypoint(-501.38, 5280.53)
			end
			if zonename == "Planks" then
				SetNewWaypoint(1201.35, -1327.51)
			end
		end
		if PlayerData.job.name == "fueler" then 
			if zonename == "OilFarm" then
				SetNewWaypoint(2736.94, 1417.99)
			end
			if zonename == "OilRefinement" then
				SetNewWaypoint(265.75, -3013.39)
			end
			if zonename == "OilMix" then
				SetNewWaypoint(491.40, -2163.37)
			end
		end
		Hint:Delete()
		hintIsShowed = false
		
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			ESX.Alert(_U('foot_work'), "info")
		else
			TriggerServerEvent('esx_jobs:startWork', 'items', zonename)
		end
	elseif zone.Type == "vehspawner" then
		local spawnPoint = nil
		local vehicle = nil

		for k,v in pairs(Config.Jobs) do
			if PlayerData.job.name == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehspawnpt" and w.Spawner == zone.Spawner then
						spawnPoint = w
						spawner = w.Spawner
					end
				end

				for m,x in pairs(v.Vehicles) do
					if x.Spawner == zone.Spawner then
						vehicle = x
					end
				end
			end
		end

		if ESX.Game.IsSpawnPointClear(spawnPoint.Pos, 5.0) then
			spawnVehicle(spawnPoint, vehicle, zone.Caution)
		else
			ESX.Alert(_U('spawn_blocked'))
		end

	elseif zone.Type == "vehdelete" then
		local looping = true

		for k,v in pairs(Config.Jobs) do
			if PlayerData.job.name == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehdelete" and w.Spawner == zone.Spawner then
						local playerPed = PlayerPedId()

						if IsPedInAnyVehicle(playerPed, false) then

							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")
							local driverPed = GetPedInVehicleSeat(vehicle, -1)

							if playerPed == driverPed then

								for i=1, #myPlate, 1 do
									if myPlate[i] == plate then

										local vehicleHealth = GetVehicleEngineHealth(vehicleInCaseofDrop)
										local giveBack = ESX.Math.Round(vehicleHealth / vehicleMaxHealth, 2)
										TriggerEvent('esx_carlock:addCarLock', VehToNet(vehicle), false)

										TriggerServerEvent('esx_jobs:caution', "give_back", giveBack, 0, 0)
										DeleteVehicle(GetVehiclePedIsIn(playerPed, false))

										if w.Teleport ~= 0 then
											ESX.Game.Teleport(playerPed, w.Teleport)
										end

										table.remove(myPlate, i)

										if vehicleObjInCaseofDrop.HasCaution then
											vehicleInCaseofDrop = nil
											vehicleObjInCaseofDrop = nil
											vehicleMaxHealth = nil
										end

										break
									end
								end

							else
								ESX.Alert(_U('not_your_vehicle'))
							end

						end

						looping = false
						break
					end

					if looping == false then
						break
					end
				end
			end
			if looping == false then
				break
			end
		end
	elseif zone.Type == "delivery" then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		Hint:Delete()
		hintIsShowed = false
		TriggerServerEvent('esx_jobs:startWork', 'items', zonename)
	end
	--nextStep(zone.GPS)
end)

function nextStep(gps)
	if gps ~= 0 then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
		SetBlipRoute(Blips['delivery'], true)
		ESX.Alert(_U('next_point'))
	end
end

AddEventHandler('esx_jobs:hasExitedMarker', function(zone)
	TriggerServerEvent('esx_jobs:stopWork')
	Hint:Delete()
	menuIsShowed = false
	hintIsShowed = false
	isInMarker = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	exports.sr_main:RemoveByTag("esx_jobs")
	PlayerData.job = job
	onDuty = false
	local ond = GetResourceKvpInt("onDuty")
	if ond == 1 then
		onDuty = true
	else
		onDuty = false
	end
	myPlate = {} -- loosing vehicle caution in case player changes job.
	spawner = 0
	deleteBlips()
	refreshBlips()
	CreatePoint()
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local zones = {}
	local ond = GetResourceKvpInt("onDuty")
	local blipInfo = {}
	if PlayerData.job ~= nil then
		if PlayerData.job.name == 'unemployed' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				if skin then
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)
			return
		end
		for jobKey,jobValues in pairs(Config.Jobs) do

			if jobKey == PlayerData.job.name then
				if PlayerData.job.grade > 0 or ond == 1 then
					onDuty = true
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
						else
							TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
						end
					end)
				else
					onDuty = false
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					if ond == 1 then
						onDuty = true
					else
						onDuty = false
					end
				end
				for zoneKey,zoneValues in pairs(jobValues.Zones) do

					if zoneValues.Blip then
						local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
						SetBlipSprite  (blip, jobValues.BlipInfos.Sprite)
						SetBlipDisplay (blip, 4)
						SetBlipScale   (blip, 0.6)
						SetBlipCategory(blip, 3)
						SetBlipColour  (blip, jobValues.BlipInfos.Color)
						SetBlipAsShortRange(blip, true)
						if zoneKey == "CloakRoom" then
							--SetBlipRoute(blip,  true)
							SetBlipAsMissionCreatorBlip(blip, true)
							--SetBlipRouteColour(blip, 3)
						end
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(zoneValues.Name)
						EndTextCommandSetBlipName(blip)
						table.insert(JobBlips, blip)
					end
				end
			end
		end
	end
end

getVehicleFromPlate = function(plate)
	return nil
end

function spawnVehicle(spawnPoint, vehicle, vehicleCaution)
	Citizen.Wait(math.random(500, 2000))
	if dozd then return end
	dozd = true
	local vehicle = vehicle
	local plate
	if PlayerData.job.name == "lumberjack" then
		plate = "CH"..ESX.GetPlayerData().rawid
	elseif PlayerData.job.name == "fueler" then
		plate = "FL"..ESX.GetPlayerData().rawid
	else
		plate = "GH"..ESX.GetPlayerData().rawid
	end
	if Pointer[PlayerData.job.name] then
		SetNewWaypoint(Pointer[PlayerData.job.name][3].x, Pointer[PlayerData.job.name][3].y)
	end
	plate = string.gsub(plate, " ", "")
	--[[if getVehicleFromPlate(plate) then
		ESX.ShowNotification('Shoma ghablan yek mashin gereftid')
		return
	end]]
	Hint:Delete()
	hintIsShowed = false
	vehicle.plate = plate
	TriggerServerEvent('esx_jobs:caution', 'take', vehicleCaution, spawnPoint, vehicle)
end

RegisterNetEvent('esx_jobs:spawnJobVehicle')
AddEventHandler('esx_jobs:spawnJobVehicle', function(spawnPoint, vehicle)
	if GetInvokingResource() then return end
	if vehicle.Hash and not jobcars[vehicle.Hash] then return end
	if vehicle.Trailer and vehicle.Trailer ~= "none" and not jobcars[vehicle.Trailer] then return end
	local playerPed = PlayerPedId()

	ESX.Game.SpawnVehicle(vehicle.Hash, spawnPoint.Pos, spawnPoint.Heading, function(spawnedVehicle)
		if vehicle.Trailer ~= "none" then
			ESX.Game.SpawnVehicle(vehicle.Trailer, spawnPoint.Sop, spawnPoint.Heading, function(trailer)
				AttachVehicleToTrailer(spawnedVehicle, trailer, 1.1)
			end)
		end
		SetVehicleNumberPlateText(spawnedVehicle, vehicle.plate)

		TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
		Citizen.Wait(300)
		table.insert(myPlate, GetVehicleNumberPlateText(spawnedVehicle))
		--TriggerEvent('esx_carlock:addCarLock', VehToNet(spawnedVehicle), true)
		ESX.CreateVehicleKey(spawnedVehicle)
		dozd = false
		if vehicle.HasCaution then
			vehicleInCaseofDrop = spawnedVehicle
			vehicleObjInCaseofDrop = vehicle
			vehicleMaxHealth = GetVehicleEngineHealth(spawnedVehicle)
		end
	end)
end)

-- Display markers (only if on duty and the player's job ones)
function CreatePoint()
	Citizen.CreateThread(function()
		local zones = {}
		if PlayerData.job ~= nil then
			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					zones = v.Zones
				end
			end

			for k, v in pairs(zones) do
				local Location = zones[k]
				local Point = RegisterPoint(vector3(Location.Pos.x, Location.Pos.y, Location.Pos.z), Config.DrawDistance, true)
				Point.set('InArea', function ()
					Point.set("Tag", "esx_jobs")
					if onDuty or Location.Type == "cloakroom" or PlayerData.job.name == "reporter" then
						if(Location.Marker ~= -1 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Location.Pos.x, Location.Pos.y, Location.Pos.z, true) < Config.DrawDistance) then
							DrawMarker(Location.Marker, Location.Pos.x, Location.Pos.y, Location.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Location.Size.x, Location.Size.y, Location.Size.z, Location.Color.r, Location.Color.g, Location.Color.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end)
			end
		end
	end)
end

local canEnter = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canEnter = true
    else
        canEnter = false
    end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(3)

		if PlayerData.job ~= nil and PlayerData.job.name ~= 'nojob' and canEnter then
			local zones = currentZones
			local job = currentJob

			if zones ~= nil then
				local coords      = GetEntityCoords(PlayerPedId())
				local currentZone = nil
				local zone        = nil
				local lastZone    = nil

				for k,v in pairs(zones) do
					if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
						isInMarker  = true
						currentZone = k
						zone        = v
						break
					else
						isInMarker  = false
					end
				end

				if IsControlJustReleased(0, Keys['E']) and not menuIsShowed and isInMarker then
					if onDuty or zone.Type == "cloakroom" or PlayerData.job.name == "reporter" then
						TriggerEvent('esx_jobs:action', job, zone, currentZone)
					end
				end

				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if (onDuty or zone.Type == "cloakroom" or PlayerData.job.name == "reporter") and zone.Type ~= "vehdelete" then
						ESX.ShowHelpNotification(zone.Hint)
						--Hint:Create(zone.Hint)
						hintIsShowed = true
					elseif zone.Type == "vehdelete" and (onDuty or PlayerData.job.name == "reporter") then
						local playerPed = PlayerPedId()

						if IsPedInAnyVehicle(playerPed, false) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local driverPed = GetPedInVehicleSeat(vehicle, -1)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")

							if playerPed == driverPed then

								for i=1, #myPlate, 1 do
									if myPlate[i] == plate then
										ESX.ShowHelpNotification(zone.Hint)
										break
									end
								end

							else
								ESX.ShowHelpNotification(_U('not_your_vehicle'))
							end
						else
							ESX.ShowHelpNotification(_U('in_vehicle'))
						end
						hintIsShowed = true
					elseif onDuty and zone.Spawner ~= spawner then
						ESX.ShowHelpNotification(_U('wrong_point'))
						hintIsShowed = true
					else
						if not isInPublicMarker then
							--Hint:Delete()
							hintIsShowed = false
						end
					end
				end

				if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('esx_jobs:hasExitedMarker', zone)
				end
			else
				Citizen.Wait(750)
			end
		else
			Citizen.Wait(750)
		end
	end
end)

Citizen.CreateThread(function()
	-- Slaughterer
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")

	-- Tailor
	RequestIpl("id2_14_during_door")
	RequestIpl("id2_14_during1")
end)
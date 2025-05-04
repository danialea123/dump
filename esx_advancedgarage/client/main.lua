---@diagnostic disable: undefined-global, lowercase-global, cast-local-type, missing-parameter, undefined-field, need-check-nil, inject-field, redundant-parameter
Keys = {
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

local ESX = nil

local PlayerData              = {}
local JobBlips                = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local userProperties          = {}
local this_Garage             = {}
local privateBlips            = {}
local AllParks = {}
local PMetr = {
	[GetHashKey('faggio2')] = true,
	[GetHashKey('speedo2')] = true,
	[GetHashKey('mule')] = true,
}
local BlackListedClass = {
	[15] = true,
	[16] = true,
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	if Config.UsePrivateCarGarages == true then
		--[[ESX.TriggerServerCallback('esx_advancedgarage:getOwnedProperties', function(properties)
			userProperties = properties
			PrivateGarageBlips()
		end)]]
	end
	
	PlayerData = ESX.GetPlayerData()
	idnt = PlayerData.identifier
	refreshBlips()
	ParkmetrThread()
end)

function GetAvailableVehicleSpawnPoint(garage)
	if garage.SpawnPoints then
		local spawnPoints = garage.SpawnPoints
		local found, foundSpawnPoint = false, nil

		for i=1, #spawnPoints, 1 do
			if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, 3.5) then
				found, foundSpawnPoint = true, spawnPoints[i]
				break
			end
		end

		if found then
			return true, foundSpawnPoint
		else
			return false
		end
	elseif garage.SpawnPoint then
		local spawnPoint = garage.SpawnPoint
		local found, foundSpawnPoint = false, nil
		local coords = vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z)

		if ESX.Game.IsSpawnPointClear(coords, 2) then
			spawnPoint.heading = spawnPoint.h
			spawnPoint.coords = coords
			found, foundSpawnPoint = true, spawnPoint
		end

		if found then
			return true, foundSpawnPoint
		else
			return false
		end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
	PlayerData.gang = gang
end)

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function setDamages(car, damages)
	local damages = damages
	if type(damages) ~= "table" then
		damages = json.decode(damages)
	end
	for i = 0, GetVehicleNumberOfWheels(car) do
        if damages['burst_tires'] then
            if damages['burst_tires'][i] then
                SetVehicleTyreBurst(car, damages['burst_tires'][i], true, 1000.0)
            end
        end
	end

	for i = 0, 7 do
        if damages['damaged_windows'] then
            if damages['damaged_windows'][i] then
                SmashVehicleWindow(car, damages['damaged_windows'][i])
            end
        end
	end

	for i = 0, GetNumberOfVehicleDoors(car) do 
        if damages['broken_doors'] then
			if damages['broken_doors'][i] then
                SetVehicleDoorBroken(car, damages['broken_doors'][i], true)
            end
        end
	end

    if damages['body_health'] then
		if damages['body_health'] < 100 then
			damages['body_health'] = 200
		end
        ESX.SetVehicleBodyHealth(car, damages['body_health'] + 0.0)
    end
    if damages['engine_health'] then
		if damages['engine_health'] < 100 then
			damages['engine_health'] = 200
		end
        SetVehicleEngineHealth(car, damages['engine_health'] + 0.0)
    end

	if damages["fuel"] then
		if damages["fuel"] < 10 then
			damages["fuel"] = 30
		end
        exports["LegacyFuel"]:SetFuel(car, damages["fuel"]+0.0)
	end
end

-- List Owned Cars Menu
function ListOwnedCarsMenu()
	local elements = {}
	
	if Config.ShowGarageSpacer1 then
		table.insert(elements, {label = _U('spacer1')})
	end
	
	if Config.ShowGarageSpacer2 then
		table.insert(elements, {label = _U('spacer2')})
	end
	
	if Config.ShowGarageSpacer3 then
		table.insert(elements, {label = _U('spacer3')})
	end
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			ESX.Alert('Shoma hich mashini dar in garage nadarid', "error")
		else
			local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(this_Garage)
			if foundSpawn then
				TriggerEvent("esx_garage:requestMenu", ownedCars, spawnPoint, function(data)
					if data then
						Wait(math.random(0, 500))
						TriggerEvent('mythic_progbar:client:progress', {
							name = 'cast',
							duration = math.random(13000, 15000),
							label = 'Spawning Car...',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}
						}, function(status)
							if not status then
								local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(this_Garage)
								if foundSpawn then
									--ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
										local vehicle = data.vehicle
										local damages = data.damages
										ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
											vehicle.plate = data.plate
											ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
											SetVehRadioStation(callback_vehicle, "OFF")
											SetVehicleDoorShut(callback_vehicle, 0, false)
											SetVehicleDoorShut(callback_vehicle, 1, false)
											SetVehicleDoorShut(callback_vehicle, 2, false)
											SetVehicleDoorShut(callback_vehicle, 3, false)
											SetVehicleDoorShut(callback_vehicle, 4, false)
											SetVehicleDoorShut(callback_vehicle, 5, false)
											--SetVehicleDoorsLockedForAllPlayers(callback_vehicle, true)
											setDamages(callback_vehicle, damages)
											ESX.CreateVehicleKey(callback_vehicle)
										end)
										TriggerServerEvent('esx_advancedgarage:setVehicleState', data.plate, false)
									--end, data.current.value.plate)
								else
									ESX.Alert("Pounded", "error")
								end
							end
						end)
					end
				end)
			else
				ESX.Alert("Jaye Khali Baraye Spawn Mashin Vojud Nadarad", "error")
			end
			--[[for _,v in pairs(ownedCars) do
				local hashVehicule = v.vehicle.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
				if vehicleName == "Unknown" then
					vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(vehicleName))
				end
				local plate        = v.plate
				local labelvehicle
				if IsModelValid(hashVehicule) then
					if v.stored then
						labelvehicle = '| '..plate..' | '..vehicleName..' |'
					elseif v.imp then
						labelvehicle = '| '..plate..' | '..vehicleName..' |'..' <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'
					else
						labelvehicle = '| '..plate..' | '..vehicleName..' |'
					end
					table.insert(elements, {label = labelvehicle, value = v})
				end
			end
			
            camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
					
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
				title    = _U('garage_cars'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if not data or not data.current or not data.current.value then return end
				if not data.current.value.imp then
					if data.current.value.stored then
						if not DoesEntityExist(localVeh) then return end
						DeleteVehicle(localVeh)
						localVeh = nil
						ClearFocus()
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						menu.close()
						Wait(math.random(0, 500))
						TriggerEvent('mythic_progbar:client:progress', {
							name = 'cast',
							duration = math.random(13000, 15000),
							label = 'Spawning Car...',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}
						}, function(status)
							if not status then
								local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(this_Garage)
								if foundSpawn then
									--ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
										local vehicle = data.current.value.vehicle
										local damages = data.current.value.damages
										ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
											vehicle.plate = data.current.value.plate
											ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
											SetVehRadioStation(callback_vehicle, "OFF")
											SetVehicleDoorShut(callback_vehicle, 0, false)
											SetVehicleDoorShut(callback_vehicle, 1, false)
											SetVehicleDoorShut(callback_vehicle, 2, false)
											SetVehicleDoorShut(callback_vehicle, 3, false)
											SetVehicleDoorShut(callback_vehicle, 4, false)
											SetVehicleDoorShut(callback_vehicle, 5, false)
											--SetVehicleDoorsLockedForAllPlayers(callback_vehicle, true)
											setDamages(callback_vehicle, damages)
											ESX.CreateVehicleKey(callback_vehicle)
										end)
										TriggerServerEvent('esx_advancedgarage:setVehicleState', data.current.value.plate, false)
									--end, data.current.value.plate)
								else
									ESX.Alert(_U('spawn_points_blocked'), "error")
								end
							end
						end)
					else
						ESX.Alert(_U('car_is_impounded'), "error")
					end
				else
					ESX.Alert("Mashin Shoma Dar Impound Police Ast, Be Edare Police Morajee Konid", "info")
				end
			end, function(data, menu)
				menu.close()
			end, function(data, menu)
				if GlobalPerview then
					ESX.ClearTimeout(GlobalPerview)
					GlobalPerview = nil
				end
				if localVeh then
					DeleteVehicle(localVeh)
					localVeh = nil
				end
				if data.current.value then
					local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(this_Garage)

					if foundSpawn then
						SetCamCoord(camera, spawnPoint.coords.x + 3.0, spawnPoint.coords.y + 3.0, spawnPoint.coords.z+ 3.0)
						SetCamActive(camera, true)
						PointCamAtCoord(camera, spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z)
						RenderScriptCams(true, true, 1000, true, false)

						GlobalPerview = ESX.SetTimeout(500, function()
							--ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
							local vehicle = data.current.value.vehicle
							local damages = data.current.value.damages
								if not localVeh then
									ESX.Game.SpawnLocalVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
										if localVeh then
											DeleteVehicle(callback_vehicle)
										else
											localVeh = callback_vehicle
											vehicle.plate = data.current.value.plate
											ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
											SetVehRadioStation(callback_vehicle, "OFF")
											setDamages(callback_vehicle, damages)
											Citizen.CreateThread(function()
												while DoesEntityExist(callback_vehicle) and localVeh == callback_vehicle and DoesCamExist(camera) do
													Citizen.Wait(0)
													local vehpos = GetOffsetFromEntityInWorldCoords(callback_vehicle, 0.0, 0.0, 2.0)
													ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5),'Benzin : '.. ESX.Math.Round(exports["LegacyFuel"]:GetFuel(callback_vehicle) or 100).. '%',1)
													ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75),'Slamate Badane : '.. ESX.Math.Round(GetVehicleBodyHealth(callback_vehicle) / 10).. '%',1)
													ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1),'Salamate Motor : ' .. ESX.Math.Round(GetVehicleEngineHealth(callback_vehicle) / 10) .. '%',1)
												end
												DeleteVehicle(localVeh)
											end)
										end
									end)
								end
							--end, data.current.value.plate)
						end)
					else
						ESX.Alert(_U('spawn_points_blocked'), "error")
					end
				end
			end, function()
				if GlobalPerview then
					ESX.ClearTimeout(GlobalPerview)
					GlobalPerview = nil
				end
				if localVeh then
					DeleteVehicle(localVeh)
					localVeh = nil
				end
				if camera then
					ClearFocus()
					RenderScriptCams(false, false, 0, true, false)
					DestroyCam(camera, false)
					camera = nil
				end
			end)]]
		end
	end)
end

-- List Owned Boats Menu
function ListOwnedBoatsMenu()
	local elements = {}
	
	if Config.ShowGarageSpacer1 then
		table.insert(elements, {label = _U('spacer1')})
	end
	
	if Config.ShowGarageSpacer2 then
		table.insert(elements, {label = _U('spacer2')})
	end
	
	if Config.ShowGarageSpacer3 then
		table.insert(elements, {label = _U('spacer3')})
	end
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedBoats', function(ownedBoats)
		if #ownedBoats == 0 then
			ESX.Alert(_U('garage_noboats'))
		else
			for _,v in pairs(ownedBoats) do
				if Config.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
					if vehicleName == "Unknown" then
						vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(vehicleName))
					end
					local plate        = v.plate
					local labelvehicle
					
					if Config.ShowVehicleLocation then
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('loc_garage')..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('loc_pound')..' |'
						end
					else
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						end
					end
					
					table.insert(elements, {label = labelvehicle, value = v})
				else
					local hashVehicule = v.vehicle.model
					local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
					if vehicleName == "Unknown" then
						vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(vehicleName))
					end
					local plate        = v.plate
					local labelvehicle
					
					if Config.ShowVehicleLocation then
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('loc_garage')..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('loc_pound')..' |'
						end
					else
						if v.stored then
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' |'
						end
					end
					
					table.insert(elements, {label = labelvehicle, value = v})
				end
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_boat', {
			title    = _U('garage_boats'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value.stored then
				menu.close()
				SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
			else
				ESX.Alert(_U('boat_is_impounded'))
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

-- List Owned Aircrafts Menu
function ListOwnedAircraftsMenu()
	local elements = {}
	
	if Config.ShowGarageSpacer1 then
		table.insert(elements, {label = _U('spacer1')})
	end
	
	if Config.ShowGarageSpacer2 then
		table.insert(elements, {label = _U('spacer2')})
	end
	
	if Config.ShowGarageSpacer3 then
		table.insert(elements, {label = _U('spacer3')})
	end
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedAircrafts', function(ownedAircrafts)
		local ownedAircrafts = ownedAircrafts
		local HeliCodes = exports.gangprop:GetHelis()
		for k, v in pairs(HeliCodes) do
			if v then
				local st = GetHeliData(k)
				local pl = GetHeliData2(k)
				table.insert(ownedAircrafts, {vehicle = {model = v}, stored = st, isGang  = true, plate = pl, Code = k})
			end
		end
		for _,v in pairs(ownedAircrafts) do
			if this_Garage.GaragePoint["y"] == 492.79 and v.type == "aircraft" then
				table.remove(ownedAircrafts, _)
			end
			if this_Garage.GaragePoint["y"] == -1454.01 and v.type == "aircraft" then
				table.remove(ownedAircrafts, _)
			end
			if this_Garage.GaragePoint["y"] == 4915.89 and v.type == "aircraft" then
				table.remove(ownedAircrafts, _)
			end
			if this_Garage.GaragePoint["y"] == 6742.51 and v.type == "aircraft" then
				table.remove(ownedAircrafts, _)
			end
		end
		if #ownedAircrafts == 0 then
			ESX.Alert(_U('garage_noaircrafts'), "error")
		else
			for _,v in pairs(ownedAircrafts) do
				local hashVehicule = v.vehicle.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
				if vehicleName == "Unknown" then
					vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(hashVehicule))
				end
				local plate        = v.plate

				local labelvehicle
				if IsModelValid(hashVehicule) then 
					if v.stored then
						labelvehicle = '| '..plate..' | '..vehicleName..' |'
					elseif v.imp then
						labelvehicle = '| '..plate..' | '..vehicleName..' |'..' <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'
					else
						labelvehicle = '| '..plate..' | '..vehicleName..' |'
					end
					table.insert(elements, {label = labelvehicle, value = v, isGang = v.isGang, Code = v.Code})
				end
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_aircraft', {
			title    = _U('garage_aircrafts'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value.stored then
				menu.close()
				Wait(math.random(0, 500))
				local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(this_Garage)
				if foundSpawn then
					if not data.current.isGang then
						ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle)
							ESX.Game.SpawnVehicle(vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
								vehicle.plate = data.current.value.plate
								ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
								SetVehRadioStation(callback_vehicle, "OFF")
								TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
								ESX.CreateVehicleKey(callback_vehicle)				
							end)
							TriggerServerEvent('esx_advancedgarage:setVehicleState', data.current.value.plate, false)
						end, data.current.value.plate)
					else
						TriggerEvent("gangProp:GetInfo", "heli_access", function(level)
							if PlayerData.gang.grade >= level then
								ESX.TriggerServerCallback("esx_gangProp:DoesHeliExists", function(res, plate, props)
									ESX.Game.SpawnVehicle(data.current.value.vehicle.model, spawnPoint.coords, spawnPoint.heading, function(callback_vehicle)
										SetVehRadioStation(callback_vehicle, "OFF")
										exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
										SetVehicleNumberPlateText(callback_vehicle, plate)
										if props then
											ESX.Game.SetVehicleProperties(callback_vehicle, props)
										else
											local prop = ESX.Game.GetVehicleProperties(callback_vehicle)
											TriggerServerEvent("esx_gangs:setHeliProps", data.current.Code, prop)
										end
										ESX.CreateVehicleKey(callback_vehicle)
										TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
										Citizen.Wait(500)
										TriggerServerEvent("esx_gangProp:TheyUsedHeli", plate)
									end)
								end, data.current.Code)
							else
								ESX.Alert("Shoma Dastresi Estefade Az Heli Nadarid", "info")
							end
						end)
					end
				else
					ESX.Alert(_U('spawn_points_blocked'), "info")
				end
			else
				ESX.Alert(_U('aircraft_is_impounded'), "info")
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function GetHeliData(model)
	local p = promise:new()
	ESX.TriggerServerCallback("esx_gangProp:DoesHeliExists", function(res, plate)
		p:resolve(res)
	end, model)
	return Citizen.Await(p)
end

function GetHeliData2(model)
	local p = promise:new()
	ESX.TriggerServerCallback("esx_gangProp:DoesHeliExists", function(res, plate)
		p:resolve(plate)
	end, model)
	return Citizen.Await(p)
end

AddEventHandler('esx_advancedgarage:GetVehicleDamages', function(cb, vehicle)
	cb(GetVehicleDamages(vehicle))
end)

function GetVehicleDamages(vehicle)
	local damages 	   = {['damaged_windows'] = {}, ['burst_tires'] = {}, ['broken_doors'] = {}, ['body_health'] = GetVehicleBodyHealth(vehicle), ['engine_health'] = GetVehicleEngineHealth(vehicle), ["fuel"] = math.ceil(exports["LegacyFuel"]:GetFuel(vehicle))}

	for i = 0, GetVehicleNumberOfWheels(vehicle) do
		if IsVehicleTyreBurst(vehicle, i, false) then table.insert(damages['burst_tires'], i) end 
	end
	for i = 0, 7 do
		if not IsVehicleWindowIntact(vehicle, i) then table.insert(damages['damaged_windows'], i) end
	end
	for i = 0, GetNumberOfVehicleDoors(vehicle) do 
		if IsVehicleDoorDamaged(vehicle, i) then table.insert(damages['broken_doors'], i) end 
	end

	return damages
end

local spp = false

function StoreOwnedCarsMenu()
	if spp then return ESX.Alert("Lotfan Spam Nakonid", "error") end
	spp = true
	Citizen.SetTimeout(3000, function() spp = false end)
	local playerPed  = PlayerPedId()

	if IsPedInAnyVehicle(playerPed,  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
		local playerPed    = PlayerPedId()
		local vehicle 	   = GetVehiclePedIsUsing(PlayerPedId())
		local props 	   = ESX.Game.GetVehicleProperties(vehicle)
		local plate        = props.plate
		ESX.TriggerServerCallback('esx_advancedgarage:IsOwnerOfVehicle', function (is)
			if is then
				local vehName 	   = ESX.GetVehicleLabelFromHash(props.model) or ESX.GetVehicleLabelFromName(props.model)
				local damages	   = GetVehicleDamages(vehicle)
				TriggerServerEvent('esx_advancedgarage:storeVehicle', props, plate, json.encode(damages), currentZone)
				TriggerServerEvent("esx_gangProp:RestoreHeli", plate)
				ESX.Game.DeleteVehicle(vehicle)
				ESX.Alert(_U('vehicle_in_garage'), "check")
			else
				ESX.Alert('You are not Owner of this vehicle', "error")
			end
		end, plate)

	else
		ESX.Alert(_U('no_vehicle_to_enter'), "error")
	end
end

-- Store Owned Boats Menu
function StoreOwnedBoatsMenu()
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed     = PlayerPedId()
		local coords        = GetEntityCoords(playerPed)
		local vehicle       = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 	    = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth  = GetVehicleEngineHealth(current)
		local plate         = vehicleProps.plate
		
		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.UseDamageMult then
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.BoatPoundPrice*Config.DamageMult)
						reparation(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth)/1000*Config.BoatPoundPrice)
						reparation(apprasial, vehicle, vehicleProps)
					end
				else
					putaway(vehicle, vehicleProps)
				end	
			else
				ESX.Alert(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.Alert(_U('no_vehicle_to_enter'))
	end
end

-- Store Owned Aircrafts Menu
function StoreOwnedAircraftsMenu()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if IsPedInAnyVehicle(PlayerPedId(),  false) and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and (GetVehicleClass(vehicle) == 15 or GetVehicleClass(vehicle) == 16) then
		local vehicle 	   = GetVehiclePedIsUsing(PlayerPedId())
		local props 	   = ESX.Game.GetVehicleProperties(vehicle)
		local plate        = props.plate
		local vehName 	   = GetDisplayNameFromVehicleModel(props.model)
		local tmpName 	   = GetLabelText(vehName)
		local damages	   = GetVehicleDamages(vehicle)
		TriggerServerEvent("esx_gangProp:RestoreHeli", plate)
		TriggerServerEvent('esx_advancedgarage:storeVehicle', props, plate, json.encode({}))    
		ESX.Game.DeleteVehicle(vehicle)
		ESX.Alert('Vasile shoma ba movafaqiat park shod', "info")    
	else
		ESX.Alert('Shoma savare Havapeima/Helicopter nistid!', "info") 
	end
end

-- Pound Owned Cars Menu
function ReturnOwnedCarsMenu()
	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
		ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedCars', function(ownedCars)
			local elements = {}
		
			if Config.ShowPoundSpacer2 then
				table.insert(elements, {label = _U('spacer2'), value = "title"})
			end
			
			if Config.ShowPoundSpacer3 then
				table.insert(elements, {label = _U('spacer3'), value = "title"})
			end
			
			for _,v in pairs(ownedCars) do
				local hashVehicule = v.model
				if hashVehicule and IsModelInCdimage(hashVehicule) then
					local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
					if vehicleName == "Unknown" then
						vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(vehicleName))
					end
					local plate        = v.plate
					local labelvehicle
					if v.plate and IsModelValid(hashVehicule) then
						if v.imp then
							labelvehicle = '| '..plate..' | '..vehicleName..' | '..' <span style="color:red; border-bottom: 1px solid red;">Police Impound</span>'..' |'
						else
							labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
						end
						table.insert(elements, {label = labelvehicle, value = v})
					end
				end
			end
			
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_car', {
				title    = _U('pound_cars'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if data.current.value ~= "title" then
					if not data.current.value.imp then
						if #bills == 0 then
							ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyCars', function(hasEnoughMoney, chopped)
								if hasEnoughMoney then
									TriggerServerEvent('esx_advancedgarage:StartFindingVehicle', data.current.value.plate, this_Garage.retunrGarage, chopped or false)
									-- SpawnPoundedVehicle(data.current.value, data.current.value.plate)
								else
									ESX.Alert(_U('not_enough_money'))
								end
							end, data.current.value.plate)
						else
							ESX.Alert("Shoma Bayad Jarime Haye Khod Ra Be Tor Kamel Pardakht Konid", "info")
						end
					else
						ESX.Alert("Mashin Shoma Dar Impound Police Ast, Be Edare Police Morajee Konid", "info")
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end)
	end)
end

-- Pound Owned Boats Menu
function ReturnOwnedBoatsMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedBoats', function(ownedBoats)
		local elements = {}
		
		if Config.ShowPoundSpacer2 then
			table.insert(elements, {label = _U('spacer2')})
		end
		
		if Config.ShowPoundSpacer3 then
			table.insert(elements, {label = _U('spacer3')})
		end
		
		for _,v in pairs(ownedBoats) do
			if Config.UseVehicleNamesLua then
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			else
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_boat', {
			title    = _U('pound_boats'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyBoats', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payBoat')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.Alert(_U('not_enough_money'))
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

-- Pound Owned Aircrafts Menu
function ReturnOwnedAircraftsMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedAircrafts', function(ownedAircrafts)
		local elements = {}
		if Config.ShowPoundSpacer2 then
			table.insert(elements, {label = _U('spacer2')})
		end
		
		if Config.ShowPoundSpacer3 then
			table.insert(elements, {label = _U('spacer3')})
		end

		if PlayerData.gang.name ~= "nogang" then
			local HeliCodes = exports.gangprop:GetHelis()
			for k, v in pairs(HeliCodes) do
				if v then
					local v1 = GetHeliData(k)
					local plate = GetHeliData2(k)
					if not v1 then
						table.insert(elements, {label = plate.." - Gang Heli - "..v, value = v, isGang = true, plate = plate})
					end
				end
			end
		end
		
		for _,v in pairs(ownedAircrafts) do
			if Config.UseVehicleNamesLua then
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			else
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_aircraft', {
			title    = _U('pound_aircrafts'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.isGang then
				TriggerServerEvent("esx_gangProp:HeliImpound", data.current.plate)
				menu.close()
				return
			end
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyAircrafts', function(hasEnoughMoney, chopped)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:StartFindingVehicle', data.current.value.plate, this_Garage.retunrGarage, chopped or false)
				else
					ESX.Alert(_U('not_enough_money'), "info")
				end
			end, data.current.value.plate)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

-- Pound Owned Policing Menu
function ReturnOwnedPolicingMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedPolicingCars', function(ownedPolicingCars)
		local elements = {}
		
		if Config.ShowPoundSpacer2 then
			table.insert(elements, {label = _U('spacer2')})
		end
		
		if Config.ShowPoundSpacer3 then
			table.insert(elements, {label = _U('spacer3')})
		end
		
		for _,v in pairs(ownedPolicingCars) do
			if Config.UseVehicleNamesLua then
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			else
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_policing', {
			title    = _U('pound_police'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyPolicing', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payPolicing')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.Alert(_U('not_enough_money'))
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

-- Pound Owned Ambulance Menu
function ReturnOwnedAmbulanceMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedAmbulanceCars', function(ownedAmbulanceCars)
		local elements = {}
		
		if Config.ShowPoundSpacer2 then
			table.insert(elements, {label = _U('spacer2')})
		end
		
		if Config.ShowPoundSpacer3 then
			table.insert(elements, {label = _U('spacer3')})
		end
		
		for _,v in pairs(ownedAmbulanceCars) do
			if Config.UseVehicleNamesLua then
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			else
				local hashVehicule = v.model
				local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule)
				local plate        = v.plate
				local labelvehicle
				
				labelvehicle = '| '..plate..' | '..vehicleName..' | '.._U('return')..' |'
				
				table.insert(elements, {label = labelvehicle, value = v})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_ambulance', {
			title    = _U('pound_ambulance'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyAmbulance', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payAmbulance')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.Alert(_U('not_enough_money'))
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

-- Repair Vehicles
function reparation(apprasial, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()
	
	local elements = {
		{label = _U('return_vehicle').." ($"..apprasial..")", value = 'yes'},
		{label = _U('see_mechanic'), value = 'no'}
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
		title    = _U('damaged_vehicle'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		
		if data.current.value == 'yes' then

			ESX.TriggerServerCallback('esx_advancedgarage:checkRepairCost', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payhealth', apprasial)
					putaway(vehicle, vehicleProps)
				else
					ESX.Alert(_U('not_enough_money'))
				end
			end, tonumber(apprasial))

		elseif data.current.value == 'no' then
			ESX.Alert(_U('visit_mechanic'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Put Away Vehicles
function putaway(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true)
	ESX.Alert(_U('vehicle_in_garage'))
end

-- Spawn Pound Cars
function SpawnPoundedVehicle(vehicle, plate)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnPoint.x,
		y = this_Garage.SpawnPoint.y,
		z = this_Garage.SpawnPoint.z + 1
	}, this_Garage.SpawnPoint.h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		ESX.CreateVehicleKey(callback_vehicle)
	end)
	
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

RegisterNetEvent('esx_advancedgarage:FindVehicle')
AddEventHandler('esx_advancedgarage:FindVehicle', function(plate)
	if not ESX then return end
	local vehicles = ESX.Game.GetVehicles()
	local entity
	for _,v in ipairs(vehicles) do
		if GetVehicleNumberPlateText(v) and plate == ESX.Math.Trim(GetVehicleNumberPlateText(v)) then
			entity = v
		end
	end
	if entity then
		carModel = GetEntityModel(entity)
		carName = ESX.GetVehicleLabelFromHash(carModel) or ESX.GetVehicleLabelFromName(carModel)
		NetworkRequestControlOfEntity(entity)
		
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		SetEntityAsMissionEntity(entity, true, true)
		
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		if IsVehicleSeatFree(entity, -1) then
			local damages = GetVehicleDamages(entity)
			
			Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
			
			if (DoesEntityExist(entity)) then 
				DeleteEntity(entity)
			end
			TriggerServerEvent('esx_advancedgarage:ResponseFindVehicle', true, plate, json.encode(damages))
		else
			TriggerServerEvent('esx_advancedgarage:ResponseFindVehicle', false, plate)
		end
	end
end)

RegisterNetEvent('esx_advancedgarage:DeleteAllVehicle')
AddEventHandler('esx_advancedgarage:DeleteAllVehicle', function()
	local vehicles = ESX.Game.GetVehicles()
	for _,entity in ipairs(vehicles) do
		carModel = GetEntityModel(entity)
		carName = ESX.GetVehicleLabelFromHash(carModel) or ESX.GetVehicleLabelFromName(carModel)
		NetworkRequestControlOfEntity(entity)

		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		SetEntityAsMissionEntity(entity, true, true)

		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		if IsVehicleSeatFree(entity, -1) then
			Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))

			if (DoesEntityExist(entity)) then
				DeleteEntity(entity)
			end

			vehicles[_] = nil
		end
	end
end)

RegisterNetEvent('esx_advancedgarage:DeleteVehiclesInArea')
AddEventHandler('esx_advancedgarage:DeleteVehiclesInArea', function(coords, area)
	if not ESX then return end
	local vehicles = ESX.Game.GetVehiclesInArea(coords, area)
	for _, entity in ipairs(vehicles) do
		carModel = GetEntityModel(entity)
		carName = ESX.GetVehicleLabelFromHash(carModel) or ESX.GetVehicleLabelFromName(carModel)
		NetworkRequestControlOfEntity(entity)
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end
		SetEntityAsMissionEntity(entity, true, true)

		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		if IsVehicleSeatFree(entity, -1) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
			if (DoesEntityExist(entity)) then
				DeleteEntity(entity)
			end
			vehicles[_] = nil
		end
	end
end)

-- Entered Marker
AddEventHandler('esx_advancedgarage:hasEnteredMarker', function(zone)
	if zone == 'car_garage_point' then
		CurrentAction     = 'car_garage_point'
		CurrentActionMsg  = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'boat_garage_point' then
		CurrentAction     = 'boat_garage_point'
		CurrentActionMsg  = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'aircraft_garage_point' then
		CurrentAction     = 'aircraft_garage_point'
		CurrentActionMsg  = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'car_store_point' and IsPedInAnyVehicle(PlayerPedId(), false) then
		CurrentAction     = 'car_store_point'
		CurrentActionMsg  = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'boat_store_point' then
		CurrentAction     = 'boat_store_point'
		CurrentActionMsg  = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'aircraft_store_point' then
		CurrentAction     = 'aircraft_store_point'
		CurrentActionMsg  = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'car_pound_point' then
		CurrentAction     = 'car_pound_point'
		CurrentActionMsg  = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'boat_pound_point' then
		CurrentAction     = 'boat_pound_point'
		CurrentActionMsg  = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'aircraft_pound_point' then
		CurrentAction     = 'aircraft_pound_point'
		CurrentActionMsg  = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'policing_pound_point' then
		CurrentAction     = 'policing_pound_point'
		CurrentActionMsg  = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'ambulance_pound_point' then
		CurrentAction     = 'ambulance_pound_point'
		CurrentActionMsg  = _U('press_to_impound')
		CurrentActionData = {}
	end
	if CurrentActionMsg then
		Hint:Create(CurrentActionMsg)
	end
end)

-- Exited Marker
AddEventHandler('esx_advancedgarage:hasExitedMarker', function()
	if GlobalPerview then
		ESX.ClearTimeout(GlobalPerview)
		GlobalPerview = nil
	end
	if localVeh then
		DeleteVehicle(localVeh)
		localVeh = nil
	end
	if camera then
		ClearFocus()
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(camera, false)
		camera = nil
	end
	ESX.UI.Menu.CloseAll()
	Hint:Delete()
	CurrentAction = nil
	CurrentActionMsg  = nil
	currentZone = nil
end)

-- Draw Markers
Citizen.CreateThread(function()
	if Config.UseCarGarages then
		for k,v in pairs(Config.CarGarages) do
			if k ~= 11 then
				for _, c in pairs(v.GaragePoint) do
					local SpawnIntract
					local SpawnPoint = RegisterPoint(vector3(c.x, c.y, c.z), Config.DrawDistance, true)
					SpawnPoint.set('InArea', function()
						DrawMarker(36, c.x, c.y, c.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, Config.PointMarker.r, Config.PointMarker.g, Config.PointMarker.b, 100, false, true, 2, false, false, false, false)	
					end)
		
					SpawnPoint.set('InAreaOnce', function()
						SpawnIntract = RegisterPoint(vector3(c.x, c.y, c.z), Config.PointMarker.x, true)
						SpawnIntract.set('InAreaOnce', function()
							this_Garage = v
							currentZone = k
							TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'car_garage_point')
						end, function()
							TriggerEvent('esx_advancedgarage:hasExitedMarker', 'car_garage_point')
						end)
					end, function ()
						SpawnIntract = SpawnIntract.remove()
					end)
				end

				for _, c in pairs(v.SpawnPoints) do
					if k == 20 then
						local DeleteIntract
						local DeletePoint = RegisterPoint(c.coords, Config.DrawDistance, true)
						DeletePoint.set('InArea', function()
							if IsPedInAnyVehicle(PlayerPedId(), false) then
								DrawMarker(24, c.coords.x, c.coords.y, c.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 2.0, Config.DeleteMarker.z, Config.DeleteMarker.r, Config.DeleteMarker.g, Config.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
							end
						end)
						
						DeletePoint.set('InAreaOnce', function()
							DeleteIntract = RegisterPoint(vector3(c.coords.x, c.coords.y, c.coords.z), Config.DeleteMarker.x, true)
							DeleteIntract.set('InAreaOnce', function()
								TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'car_store_point')
								this_Garage = v
								currentZone = k
							end, function()
								TriggerEvent('esx_advancedgarage:hasExitedMarker', 'car_store_point')
							end)
						end, function()
							DeleteIntract = DeleteIntract.remove()
						end)
					end
				end
			end
		end

		for k,v in pairs(Config.CarPounds) do
			local PointInteract
			local Point = RegisterPoint(vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z), Config.DrawDistance, true)
			Point.set('InArea', function()
				DrawMarker(36, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, Config.PoundMarker.r, Config.PoundMarker.g, Config.PoundMarker.b, 100, false, true, 2, false, false, false, false)
			end)
			Point.set('InAreaOnce', function()
				PointInteract = RegisterPoint(vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z), 1.5, true)
				PointInteract.set('InAreaOnce', function()
					currentZone = k
					this_Garage = v
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'car_pound_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'car_pound_point')
				end)
			end, function ()
				PointInteract = PointInteract.remove()
			end)
		end
	end
	
	if Config.UseBoatGarages then
		for k,v in pairs(Config.BoatGarages) do
			local Interact = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), Config.PointMarker.x, true)
			local Point = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), Config.DrawDistance, true)
			local Deleter = RegisterPoint(vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z), Config.DeleteMarker.x, true)
			local DPoint = RegisterPoint(vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z), Config.DrawDistance, true)
			Point.set('InArea', function()
				DrawMarker(Config.MarkerType, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PointMarker.x, Config.PointMarker.y, Config.PointMarker.z, Config.PointMarker.r, Config.PointMarker.g, Config.PointMarker.b, 100, false, true, 2, false, false, false, false)	
			end)
			DPoint.set('InArea', function()
				DrawMarker(Config.MarkerType, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DeleteMarker.x, Config.DeleteMarker.y, Config.DeleteMarker.z, Config.DeleteMarker.r, Config.DeleteMarker.g, Config.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
			end)
			
			DPoint.set('InAreaOnce', function()
				Deleter = RegisterPoint(vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z), Config.DeleteMarker.x, true)
				Deleter.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'boat_store_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'boat_store_point')
				end)
			end, function()
				Deleter = Deleter.remove()
			end)

			Point.set('InAreaOnce', function()
				Interact = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), Config.PointMarker.x, true)
				Interact.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'boat_garage_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'boat_garage_point')
				end)
			end, function ()
				Interact = Interact.remove()
			end)
		end
		
		for k,v in pairs(Config.BoatPounds) do
			local Point = RegisterPoint(vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z), Config.DrawDistance, true)
			Point.set('InArea', function()
				DrawMarker(Config.MarkerType, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PoundMarker.x, Config.PoundMarker.y, Config.PoundMarker.z, Config.PoundMarker.r, Config.PoundMarker.g, Config.PoundMarker.b, 100, false, true, 2, false, false, false, false)
			end)

			Point.set('InAreaOnce', function()
				local Interact = RegisterPoint(vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z), Config.PointMarker.x, true)
				Interact.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'boat_pound_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'boat_pound_point')
				end)
			end)
		end
	end

	if Config.UseAircraftGarages then
		for k,v in pairs(Config.AircraftGarages) do
			local Deleter
			local Interact
			local Point = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), 100.0, true)
			Point.set('InArea', function()
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					DrawMarker(33, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PointMarker.x, Config.PointMarker.y, Config.PointMarker.z, Config.PointMarker.r, Config.PointMarker.g, Config.PointMarker.b, 100, false, true, 2, false, false, false, false)	
				end
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					DrawMarker(24, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DeleteMarker.x, Config.DeleteMarker.y, Config.DeleteMarker.z, Config.DeleteMarker.r, Config.DeleteMarker.g, Config.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
				end
			end)
	
			Point.set('InAreaOnce', function()
				Interact = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), Config.PointMarker.x, true)
				Interact.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'aircraft_garage_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'aircraft_garage_point')
				end)

				Deleter = RegisterPoint(vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z), Config.DeleteMarker.x, true)
				Deleter.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'car_store_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'car_store_point')
				end)
			end, function ()
				Interact.remove()
				Deleter.remove()
			end)
		end
		
		for k,v in pairs(Config.AircraftPounds) do
			local Interact
			local Point = RegisterPoint(vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z), Config.DrawDistance, true)
			Point.set('InArea', function()
				DrawMarker(Config.MarkerType, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.PoundMarker.x, Config.PoundMarker.y, Config.PoundMarker.z, Config.PoundMarker.r, Config.PoundMarker.g, Config.PoundMarker.b, 100, false, true, 2, false, false, false, false)
			end)
			Point.set('InAreaOnce', function()
				Interact = RegisterPoint(vector3(v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z), Config.PoundMarker.x, true)
				Interact.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'aircraft_pound_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'aircraft_pound_point')
				end)
			end, function ()
				Interact = Interact.remove()
			end)
		end
	end
end)

-- Key Controls
RegisterKey('E', function()
	if CurrentAction ~= nil then
		if CurrentAction == 'car_garage_point' then
			ListOwnedCarsMenu()
		elseif CurrentAction == 'boat_garage_point' then
			ListOwnedBoatsMenu()
		elseif CurrentAction == 'aircraft_garage_point' then
			ListOwnedAircraftsMenu()
		elseif CurrentAction== 'car_store_point' then
			StoreOwnedCarsMenu()
		elseif CurrentAction== 'boat_store_point' then
			StoreOwnedBoatsMenu()
		elseif CurrentAction== 'aircraft_store_point' then
			StoreOwnedAircraftsMenu()
		elseif CurrentAction == 'car_pound_point' then
			ReturnOwnedCarsMenu()
		elseif CurrentAction == 'boat_pound_point' then
			ReturnOwnedBoatsMenu()
		elseif CurrentAction == 'aircraft_pound_point' then
			ReturnOwnedAircraftsMenu()
		elseif CurrentAction == 'policing_pound_point' then
			ReturnOwnedPolicingMenu()
		elseif CurrentAction == 'ambulance_pound_point' then
			ReturnOwnedAmbulanceMenu()
		end

		CurrentAction = nil
		Hint:Delete()
	end
end)

-- Create Blips
function PrivateGarageBlips()
	for _,blip in pairs(privateBlips) do
		RemoveBlip(blip)
	end
	
	privateBlips = {}
	
	for k,v in pairs(Config.PrivateCarGarages) do
		if v.Private and has_value(userProperties, v.Private) then
			local blip = AddBlipForCoord(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z)
			SetBlipSprite(blip, Config.BlipGaragePrivate.Sprite)
			SetBlipDisplay(blip, 0.6)
			SetBlipColour(blip, Config.BlipGaragePrivate.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage_private'))
			EndTextCommandSetBlipName(blip)

			local Interact
			local Point = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), Config.DrawDistance, true)
			local Deleter
			local DeleteP = RegisterPoint(vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z), Config.DrawDistance, true)
			Point.set('InArea', function()
				DrawMarker(36, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, Config.PointMarker.r, Config.PointMarker.g, Config.PointMarker.b, 100, false, true, 2, false, false, false, false)	
			end)
			
			Point.set('InAreaOnce', function()
				Interact = RegisterPoint(vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z), Config.PointMarker.x, true)
				Interact.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'car_garage_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'car_garage_point')
				end)
			end, function ()
				Interact = Interact.remove()
			end)
			
			DeleteP.set('InArea', function()
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					DrawMarker(24, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 2.0, Config.DeleteMarker.z, Config.DeleteMarker.r, Config.DeleteMarker.g, Config.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
				end
			end)
			
			DeleteP.set('InAreaOnce', function()
				Deleter = RegisterPoint(vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z), Config.DeleteMarker.x, true)
				Deleter.set('InAreaOnce', function()
					this_Garage = v
					currentZone = k
					TriggerEvent('esx_advancedgarage:hasEnteredMarker', 'car_store_point')
				end, function()
					TriggerEvent('esx_advancedgarage:hasExitedMarker', 'car_store_point')
				end)
			end, function()
				Deleter = Deleter.remove()
			end)
		end
	end
end

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local blipList = {}
	local JobBlips = {}
	local blipList2= {}
	if Config.UseCarGarages then
		for k,v in ipairs(Config.CarGarages) do
			if k ~= 11 then
				table.insert(blipList, {
					coords = { v.GaragePoint[1].x, v.GaragePoint[1].y },
					text   = 'Parking',
					sprite = Config.BlipGarage.Sprite,
					color  = Config.BlipGarage.Color,
					scale  = Config.BlipGarage.Scale
				})
			end
		end
		
		for k,v in pairs(Config.CarPounds) do
			table.insert(blipList2, {
				coords = { v.PoundPoint.x, v.PoundPoint.y },
				text   = _U('blip_pound'),
				sprite = Config.BlipPound.Sprite,
				color  = Config.BlipPound.Color,
				scale  = Config.BlipPound.Scale
			})
		end
	end
	
	if Config.UseBoatGarages then
		for k,v in pairs(Config.BoatGarages) do
			table.insert(blipList, {
				coords = { v.GaragePoint.x, v.GaragePoint.y },
				text   = _U('blip_garage'),
				sprite = Config.BlipGarage.Sprite,
				color  = Config.BlipGarage.Color,
				scale  = Config.BlipGarage.Scale
			})
		end
		
		for k,v in pairs(Config.BoatPounds) do
			table.insert(blipList, {
				coords = { v.PoundPoint.x, v.PoundPoint.y },
				text   = _U('blip_pound'),
				sprite = Config.BlipPound.Sprite,
				color  = Config.BlipPound.Color,
				scale  = Config.BlipPound.Scale
			})
		end
	end
	
	if Config.UseAircraftGarages then
		for k,v in pairs(Config.AircraftGarages) do
			if k ~= "Garage_CustomPad" and k ~= "Garage_GangPad" and k ~= "Garage_ModPad" then
				table.insert(blipList, {
					coords = { v.GaragePoint.x, v.GaragePoint.y },
					text   = _U('blip_aircraft_garage'),
					sprite = Config.BlipAircraftGarage.Sprite,
					color  = Config.BlipAircraftGarage.Color,
					scale  = Config.BlipAircraftGarage.Scale
				})
			end
		end
		
		for k,v in pairs(Config.AircraftPounds) do
			table.insert(blipList, {
				coords = { v.PoundPoint.x, v.PoundPoint.y },
				text   = "Aircraft Impound",
				sprite = Config.BlipAircraftPound.Sprite,
				color  = Config.BlipAircraftPound.Color,
				scale  = Config.BlipAircraftPound.Scale
			})
		end
	end
	
	for i=1, #blipList, 1 do
		CreateBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, blipList[i].scale)
	end

	for i=1, #blipList2, 1 do
		CreateBlip2(blipList2[i].coords, blipList2[i].text, blipList2[i].sprite, blipList2[i].color, blipList2[i].scale)
	end
	
	for i=1, #JobBlips, 1 do
		CreateBlip(JobBlips[i].coords, JobBlips[i].text, JobBlips[i].sprite, JobBlips[i].color, JobBlips[i].scale)
	end
end

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(table.unpack(coords))
	
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	table.insert(JobBlips, blip)
end

function CreateBlip2(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(table.unpack(coords))
	
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	table.insert(JobBlips, blip)
end

exports("setDamages", setDamages)
exports("StoreOwnedCarsMenu", StoreOwnedCarsMenu)

RegisterNetEvent("esx:LeaveVehicle")
AddEventHandler("esx:LeaveVehicle", function()
	TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 16)
end)

ShowFloatingHelpNotification = function(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

RegisterCommand("getprops", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if vehicle ~= 0 then
		local seat = GetPedInVehicleSeat(vehicle,-1)
		if seat == PlayerPedId() then
			local prop = ESX.Game.GetVehicleProperties(vehicle)
			print(json.encode(prop))
		end
	end
end)

local ParkZones = {
	vector3(-778.29,-2031.61,8.88),
	vector3(-1186.81,-1491.63,4.38),
	vector3(-783.6,-1286.65,5.0),
	vector3(125.36,-1067.27,29.19),
	vector3(-338.42,-897.62,31.61),
	vector3(225.99,-787.99,30.71),
	vector3(412.59,-648.18,28.5),
	vector3(-2032.86,-469.01,11.35),
	vector3(-740.83,-67.43,41.75),
	vector3(-339.53,280.17,85.55),
	vector3(373.03,276.98,103.14),
	vector3(638.5,182.64,96.59),
	vector3(900.43,-55.3,78.76),
	vector3(1028.37,-772.4,58.04),
	vector3(1729.04,3716.16,34.13),
	vector3(1386.07,6554.79,15.48),
	vector3(83.66,6403.19,31.57),
	vector3(-319.19,6098.45,31.46),
}

local ParkID = {
	25,
	15,
	20,
	22,
	27,
	25,
	20,
	24,
	17,
	15,
	25,
	25,
	40,
	17,
	17,
	30,
	30,
	14,
}

Citizen.CreateThread(function()
	for _, c in pairs(ParkZones) do	
		local DeletePoint = RegisterPoint(c, ParkID[_]+0.0, true)
		local Key

		DeletePoint.set('InArea', function()
			inParkingDeleteZone = true
		end)

		DeletePoint.set('InAreaOnce', function()
			Key = UnregisterKey(Key)
			Key = RegisterKey("E", false, function()
				if IsPedInAnyVehicle(PlayerPedId()) then
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'delete_car',
					{
						title 	 = 'Park Kardan Mashin',
						align    = 'center',
						question = "Aya Ghasd Park Kardan Mashin Khod Ra Darid?",
						elements = {
							{label = 'Kheyr', value = 'no'},
							{label = 'Bale', value = 'yes'},
						}
					}, function(data, menu)
						if data.current.value == "yes" then
							StoreOwnedCarsMenu()
							menu.close()
						elseif data.current.value == "no" then
							menu.close()
						end
					end)
				end
			end)
		end, function()
			Key = UnregisterKey(Key)
			inParkingDeleteZone = false
			ESX.UI.Menu.CloseAll()
		end)
	end
end)

local PCounter = {}
local PCars = {}
local Cars = {}
local Counter = {}
local Global = {}
inParkMetrZone = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		if inParkingDeleteZone then
			PenteredCar = IsPedInAnyVehicle(PlayerPedId(),  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() and GetVehiclePedIsIn(PlayerPedId()) or nil
			if PenteredCar and not PCars[PenteredCar] and NetworkGetEntityIsNetworked(PenteredCar) then
				PCars[PenteredCar] = PenteredCar
			end
		else
			Citizen.Wait(750)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for k, v in pairs(PCars) do
			local carCoord = GetEntityCoords(k)
			if DoesEntityExist(k) and IsNearParkinge(k) then
				if PCars[k] and GetVehiclePedIsIn(PlayerPedId()) ~= k then
					if not IsVehicleSeatFree(k, -1) then
						PCars[k] = nil
					end
					if PCars[k] and not PCounter[k] then
						PCounter[k] = true
						StartCountingParkTimer(k)
					end
				end
			else
				PCars[k] = nil
			end
		end
	end
end)

function IsNearParkinge(k)
	local is = false
	for _ , v in pairs(ParkZones) do
		if ESX.GetDistance(GetEntityCoords(k), v) <= ParkID[_] then
			is = true
			break
		end
	end
	return is
end

function StartCountingParkTimer(k)
	local timer = 15
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2)
			if not DoesEntityExist(k) then
				timer = -1
				break
			end
			if GetVehiclePedIsIn(PlayerPedId()) == k then
				timer = -1
				break
			end
			if not IsVehicleSeatFree(k, -1) then
				timer = -1
				break
			end
			if not IsNearParkinge(k) then
				timer = -1
				break
			end
			ESX.Game.Utils.DrawText3D(GetEntityCoords(k), tostring(timer), 2.5)
			if timer < 0 then
				local vehicle = k
				local playerPed    = PlayerPedId()
				local props 	   = ESX.Game.GetVehicleProperties(vehicle)
				local plate        = props.plate
				local vehName 	   = ESX.GetVehicleLabelFromHash(props.model) or ESX.GetVehicleLabelFromName(props.model)
				local damages	   = GetVehicleDamages(vehicle)
				ESX.TriggerServerCallback('esx_advancedgarage:IsOwnerOfVehicle', function (is)
					if is then
						TriggerServerEvent('esx_advancedgarage:storeVehicle', props, plate, json.encode(damages), currentZone)
					end
					ESX.Game.DeleteLocalVehicle(vehicle)
				end, plate)
				break
			end
		end
		PCounter[k] = nil
	end)
	Citizen.CreateThread(function()
		while timer >= 0 do
			Citizen.Wait(1000)
			timer = timer - 1
		end
	end)
end

RegisterCommand("addpark", function()
	local coord = GetEntityCoords(PlayerPedId())
	local heading = GetEntityHeading(PlayerPedId())
	TriggerServerEvent("esx:AddParkMetr", {coord = coord, heading = heading})
end)

RegisterCommand("removepark", function()
	local id = GetNearestPark(GetEntityCoords(PlayerPedId()))
	TriggerServerEvent("esx:DeleteParkMetr", id)
end)

local ParkMeterBlips = {}

RegisterNetEvent("esx:RefreshParkMetr")
AddEventHandler("esx:RefreshParkMetr", function(data)
	exports.sr_main:RemoveByTag('parkmetr')
	for k, v in pairs(ParkMeterBlips) do
		RemoveBlip(v)
	end
	AllParks = data
	ParkMeterBlips = {}
	Citizen.Wait(5000)
	ParkmetrThread()
end)

RegisterNetEvent("esx:RefreshParkMetrKey")
AddEventHandler("esx:RefreshParkMetrKey", function(tabl)
	Global = tabl
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		if inParkingDeleteZone then
			Cars = {}
		else
			Citizen.Wait(250)
		end
		if inParkMetrZone then
			enteredCar = IsPedInAnyVehicle(PlayerPedId(),  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() and GetVehiclePedIsIn(PlayerPedId()) or nil
			if enteredCar and not Cars[enteredCar] and not PMetr[GetEntityModel(enteredCar)] and not BlackListedClass[GetVehicleClass(enteredCar)] and NetworkGetEntityIsNetworked(enteredCar) and ESX.DoesHaveItem2("key_"..ESX.Math.Trim(GetVehicleNumberPlateText(enteredCar)), 1) then
				Cars[enteredCar] = enteredCar
			end
		else
			Citizen.Wait(750)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for k, v in pairs(Cars) do
			local carCoord = GetEntityCoords(k)
			if DoesEntityExist(k) and IsNearAnyPark(carCoord) then
				local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), carCoord)
				if GetVehiclePedIsIn(PlayerPedId()) ~= k and distance >= 10.0 and not Counter[k] then
					if ESX.DoesHaveItem2("key_"..ESX.Math.Trim(GetVehicleNumberPlateText(k)), 1) then
						Counter[k] = true
						StartCountingTimer(k)
					else
						Cars[k] = nil
					end
				end
			else
				Cars[k] = nil
			end
		end
	end
end)

function StartCountingTimer(k)
	local timer = 15
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2)
			if not DoesEntityExist(k) then
				timer = -1
				break
			end
			if GetVehiclePedIsIn(PlayerPedId()) == k then
				timer = -1
				break
			end
			local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(k))
			if distance <= 2.0 then
				timer = -1
				break
			end
			ESX.Game.Utils.DrawText3D(GetEntityCoords(k), tostring(timer), 2.5)
			if timer < 0 and IsNearAnyPark(GetEntityCoords(k)) then
				local key = GetNearestPark(GetEntityCoords(k))
				local vehicle = k
				local plate = ESX.GetPlate(vehicle)
				local damages = GetVehicleDamages(vehicle)
				local prop = ESX.Game.GetVehicleProperties(vehicle)
				prop.id = VehToNet(k)
				ESX.Game.DeleteVehicle(vehicle)
				TriggerServerEvent('ParkMeter:Set',key,plate,prop,json.encode(damages))
				ESX.Alert('Mashin ba movafaghiat park shod','check')
				break
			end
		end
		Counter[k] = nil
	end)
	Citizen.CreateThread(function()
		while timer >= 0 do
			Citizen.Wait(1000)
			timer = timer - 1
		end
	end)
end

function IsNearAnyPark(coord)
	local is = false
	for k , v in pairs(AllParks) do
		if ESX.GetDistance(coord, vector3(v.x,v.y,v.z)) <= 40.0 then
			is = true
			break
		end
	end
	return is
end

function GetNearestPark(coord)
	local is = 100.0
	local key
	for k , v in pairs(AllParks) do
		local dis = ESX.GetDistance(coord, vector3(v.x,v.y,v.z))
		if dis <= is then
			if not Global[k] then
				is = dis
				key = k
			end
		end
	end
	if is <= 40.0 then
		return key
	else
		return nil
	end
end

function ParkmetrThread()
	local Spam = false
	Citizen.CreateThread(function()
		while ESX == nil do Wait(100) end
		for k , v in pairs(AllParks) do
			local ParkMetrInteract
			local Key
			local ParkPoint = RegisterPoint(vector3(v.x,v.y,v.z), 40, true)
			ParkPoint.set("Tag", "parkmetr")
			ParkPoint.set("InArea", function()
				inParkMetrZone = true
				if ESX.GetDistance(GetEntityCoords(PlayerPedId()), vector3(v.x,v.y,v.z)) <= 20.0 then
					if not Global[k] then
						DrawMarker(36, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,0.5, 0.5, 0.5, 3, 119, 252, 255, false, true, 2, false, false, false, false)		
						DrawMarker(6, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 3, 119, 252, 255, false, true, 2, false, false, false, false)	
					elseif Global[k] then
						DrawMarker(36, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,0.5, 0.5, 0.5, 102, 204, 0, 255, false, true, 2, false, false, false, false)		
						DrawMarker(6, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 102, 204, 0, 255, false, true, 2, false, false, false, false)	
					end
				end
				if ESX.GetDistance(GetEntityCoords(PlayerPedId()), vector3(v.x,v.y,v.z)) <= 3.0 then
					ShowFloatingHelpNotification("Dokme  ~INPUT_CONTEXT~Baraye ParkMetr", v.xyz)
				end
			end)
			ParkPoint.set("InAreaOnce", function()
				ParkMetrInteract = RegisterPoint(vector3(v.x,v.y,v.z), 1.5, true)
				ParkMetrInteract.set("Tag", "parkmetr")
				ParkMetrInteract.set("InAreaOnce", function()
					Hint:Delete()
					Hint:Create("Dokme ~INPUT_CONTEXT~ Baraye ParkMetr")
					Key = UnregisterKey(Key)
					Key = RegisterKey("E", false, function()
						if ESX.GetPlayerData().isSentenced then return end
						if ESX.GetDistance(GetEntityCoords(PlayerPedId()), vector3(v.x,v.y,v.z)) > 2.0 then return end 
						key = k
						--if ESX.GetPlayerData().World ~= 0 then return end
						local vehicle = GetVehiclePedIsIn(PlayerPedId())
						if vehicle ~= 0 and NetworkGetEntityIsNetworked(vehicle) and not BlackListedClass[GetVehicleClass(vehicle)] then
							local seat = GetPedInVehicleSeat(vehicle,-1)
							if seat == PlayerPedId() then
								if Spam then return ESX.Alert('Spam nakonid', 'error') end
								Spam = true
								Citizen.SetTimeout(6000,function()
									Spam = false
								end)
								ESX.TriggerServerCallback('esx_advancedgarage:IsOwnerOfVehicle', function(owner)
									ESX.TriggerServerCallback('esx_advancedgarage:DoesHaveKey', function(have)
										if owner or have then
											TriggerEvent('mythic_progbar:client:progress', {
												name = 'cast',
												duration = 3000,
												label = '',
												useWhileDead = false,
												canCancel = true,
												controlDisables = {
													disableMovement = true,
													disableCarMovement = true,
													disableMouse = false,
													disableCombat = true,
												}
											}, function(status)
												if not status then
													ESX.TriggerServerCallback('ParkMeter:CheckUsed',function(used)
														if used then
															ESX.Alert('Shoma yek mashin dar in garage gozashtid!', 'error')
														else
															local p = promise.new()
															local engineHealth = GetVehicleEngineHealth(vehicle)
															--[[ESX.TriggerServerCallback('scoreboard:getjob', function(count)
																if count > 1 then]]
																	p:resolve(true)
																--[[else
																	if engineHealth < 990 then
																		local apprasial = math.floor((1000 - engineHealth)/1000*Config.CarPoundPrice*Config.DamageMult)
																		ESX.UI.Menu.CloseAll()
																		local elements = {
																			{label = 'Park + Ta\'amir ($'..apprasial..')', value = 'yes'},
																			{label = 'Park kardan', value = 'gh'}
																		}
																		
																		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
																			title    = _U('damaged_vehicle'),
																			align    = 'top-left',
																			elements = elements
																		}, function(data, menu)
																			menu.close()
																			
																			if data.current.value == 'yes' then
																	
																				ESX.TriggerServerCallback('esx_advancedgarage:checkRepairCost', function(hasEnoughMoney)
																					if hasEnoughMoney then
																						TriggerServerEvent('esx_advancedgarage:payhealth', apprasial)
																						TriggerEvent('es_admin:repair')
																						Wait(500)
																						p:resolve(true)
																					else
																						ESX.ShowNotification(_U('not_enough_money'))
																					end
																				end, tonumber(apprasial))
																	
																			elseif data.current.value == 'gh' then
																				p:resolve(true)
																			end
																		end, function(data, menu)
																			menu.close()
																		end)
																	else
																		p:resolve(true)
																	end	
																end
															end, 'mechanic')]]
															Citizen.Await(p)
															--local metaData = ESX.Game.getVehicleMetaData(vehicle)
															local plate = ESX.GetPlate(vehicle)
															local damages = GetVehicleDamages(vehicle)
															local prop = ESX.Game.GetVehicleProperties(vehicle)
															ESX.Game.DeleteVehicle(vehicle)
															prop.id = VehToNet(vehicle)
															TriggerServerEvent('ParkMeter:Set',key,plate,prop,json.encode(damages))
															ESX.Alert('Mashin ba movafaghiat park shod','check')
														end
													end,key)
												end
											end)
										else
											ESX.Alert('Shoma nemitavanid in mashin ra park konid!', 'error')
										end
									end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
								end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
							else
								ESX.Alert('Shoma ranande mashin nistid!','error')
							end
						else
							if Spam then return ESX.Alert('Spam nakonid','error') end
							Spam = true
							Citizen.SetTimeout(6000,function()
								Spam = false
							end)
							ESX.TriggerServerCallback('ParkMeter:CheckUsed',function(used,identifier)
								if used then
									TriggerEvent('mythic_progbar:client:progress', {
										name = 'cast',
										duration = math.random(3000, 5000),
										label = '',
										useWhileDead = false,
										canCancel = true,
										controlDisables = {
											disableMovement = true,
											disableCarMovement = true,
											disableMouse = false,
											disableCombat = true,
										}
									}, function(status)
										if not status then
											Citizen.Wait(math.random(100, 1500))
											if ESX.Game.IsSpawnPointClear(v.xyz,2) then
												ESX.TriggerServerCallback('ParkMeter:CheckUsed',function(used,identifier)
													if used then
														TriggerServerEvent('ParkMeter:Set',key,used.plate,nil)
														ESX.Game.SpawnVehicle(used.prop.model, v.xyz, v.w, function(callback_vehicle)
															ESX.Game.SetVehicleProperties(callback_vehicle, used.prop)
															SetVehRadioStation(callback_vehicle, "OFF")
															TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
															--if identifier then
															while GetVehiclePedIsIn(PlayerPedId()) ~= callback_vehicle do Wait(0) end
															--[[if used.doesHaveKey then
																TriggerEvent('esx:createvehiclekey')
															else
																exports["esx_vehiclecontrol"]:SetDecor(callback_vehicle,used.job,true)
															end]]
															--end
															ESX.CreateVehicleKey(callback_vehicle)
															setDamages(callback_vehicle,used.damages)
															--ESX.Game.setVehicleMetaData(callback_vehicle,used.metaData)
															--[[local plate = used.prop.plate
															ESX.TriggerServerCallback('choped',function(choped)
																if choped then
																	ESX.TriggerServerCallback('getengine',function(engine)
																		if engine ~= 0 then
																			ESX.ShowNotification('Motor mashin shoma sadame dide,shoma be yek Engine X'..engine..' niaz darid')
																		else
																			ESX.ShowNotification('Motor mashin shoma sadame dide')
																		end
																		DecorSetBool(callback_vehicle,"choped",true)
																	end,GetEntityModel(callback_vehicle))								
																end
															end,plate)]]	
														end)
													end
												end,key)
											else
												ESX.Alert('In makan jahat spawn mashin por ast!','error')
											end
										end
									end)
								else
									ESX.Alert('Shoma mashini dar in garage nazashtid!','error')
								end
							end,key)
							--ESX.Alert('Error','Shoma savar mashin nistid!',5000,'error')
						end
					end)
				end, function()
					Key = UnregisterKey(Key)
					Hint:Delete()
				end)
			end, function()
				Key = UnregisterKey(Key)
				Hint:Delete()
				inParkMetrZone = false
				if ParkMetrInteract then
					ParkMetrInteract = ParkMetrInteract.remove()
				end
			end)
		end
		--while true do
			local coords = GetEntityCoords(PlayerPedId())
			for k , v in pairs(AllParks) do
				--local distance = ESX.GetDistance(coords,v.xyz)
				--if distance <= 300 then
					--if not ParkMeterBlips[k] then
						local blip = AddBlipForCoord(v.xyz)
						SetBlipSprite(blip, 267)
						SetBlipDisplay(blip, 5)
						SetBlipScale(blip, 0.6)
						SetBlipColour(blip, 74)
						SetBlipAsShortRange(blip, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString('Park meter')
						EndTextCommandSetBlipName(blip)
						ParkMeterBlips[k] = blip
					--end
				--elseif ParkMeterBlips[k] then
				--	RemoveBlip(ParkMeterBlips[k])
				--	ParkMeterBlips[k] = nil
				--end
				Citizen.Wait(10)
			end
		--	Citizen.Wait(5000)
		--end
	end)
end

--[[Disable CargoBob Rope
CreateThread(function()
    local cargobob = `cargobob`
    while true do
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local model = GetEntityModel(vehicle)
        if model == cargobob then
            RemovePickUpRopeForCargobob(vehicle)
        end
        Wait(1)
    end
end)]]

--[[RegisterCommand("ae", function()
	for k , v in pairs(AllParks) do
		local coord = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coord, v, true) < 3.0 then
			print(k)
			break
		end
	end
end)]]

--[[Vehiclesz = {
    {name = "bmw_m2", model = "m2f22", category = "Car"},
    {name = "bmw_m3_2005", model = "m3e46", category = "Car"},
    {name = "bmw_m3_2015 ", model = "m3f80", category = "Car"},
    {name = "bmw_m4_2021", model = "bmwm4", category = "Car"},
    {name = "bmw_m5", model = "gcmm52021", category = "Car"},
    {name = "bmw_m6_2006", model = "m6", category = "Car"},
    {name = "bmw_m8", model = "bmwm8", category = "Car"},
    {name = "bmw_z4", model = "z4", category = "Car"},
    {name = "bmw_x7", model = "bmwg07", category = "Car"},
    {name = "bmw_x6", model = "x6m", category = "Car"},
    {name = "benz_amg_e63", model = "e63amg", category = "Car"},
    {name = "benz_amg_gt63", model = "gt63samg", category = "Car"},
    {name = "benz_amg_a_45", model = "a45amg", category = "Car"},
    {name = "benz_amg_gtr", model = "amggtr", category = "Car"},
    {name = "benz_amg_s65", model = "s65amg", category = "Car"},
    {name = "benz_brabus", model = "mlbrabus", category = "Car"},
    {name = "benz_c32", model = "c32", category = "Car"},
    {name = "benz_clk_gtr", model = "clkgtr", category = "Car"},
    {name = "benz_cls_500", model = "cls500w219", category = "Car"},
    {name = "benz_e_55", model = "benze55", category = "Car"},
    {name = "benz_g_63", model = "4444", category = "Car"},
    {name = "benz_gl_63", model = "gl63", category = "Car"},
    {name = "benz_s_63", model = "mers63c", category = "Car"},
    {name = "benz_s_600", model = "s600w220", category = "Car"},
    {name = "aflaromeo_4c", model = "giulia", category = "Car"},
    {name = "aflaromeo_gui", model = "4c", category = "Car"},
    {name = "astonmartin_shasi", model = "dbx", category = "Car"},
    {name = "astonmartin_vanquish", model = "ast", category = "Car"},
    {name = "audi_q20", model = "q820", category = "Car"},
    {name = "audi_r8_2013", model = "r8ppi", category = "Car"},
    {name = "audi_r8_2020", model = "r820", category = "Car"},
    {name = "audi_rs6", model = "rs6c8", category = "Car"},
    {name = "audi_s8", model = "audis8om", category = "Car"},
    {name = "audi_sq", model = "sq72016", category = "Car"},
    {name = "audi_tt2", model = "yAudiTTmk1", category = "Car"},
    {name = "audi_tts", model = "tts", category = "Bike"},
    {name = "bentley_2018", model = "contss18", category = "Car"},
    {name = "bentley_gt", model = "contgt13", category = "Car"},
    {name = "bugatti_bolide", model = "bolide", category = "Car"},
    {name = "bugatti_chiron", model = "chiron17", category = "Car"},
    {name = "bugatti_superspor", model = "supersport", category = "Car"},
    {name = "bugatti_wycalt", model = "wycalt", category = "Car"},
    {name = "Bdivo", model = "bdivo", category = "Car"},
    {name = "cadillac_6x6", model = "cadi6", category = "Car"},
    {name = "cadillac_ats", model = "cats", category = "Car"},
    {name = "cadillac_c5t", model = "ct5v", category = "Car"},
    {name = "cadillac_esc", model = "escalade", category = "Car"},
    {name = "chevorlet_c7", model = "c7", category = "Car"},
    {name = "chevorlet_c8", model = "c8", category = "Car"},
    {name = "chevorlet_camaro", model = "21camaro", category = "Car"},
    {name = "chevorlet_camaro_zl1", model = "camarozl1", category = "Car"},
    {name = "chevorlet_czr1", model = "czr1", category = "Car"},
    {name = "chevorlet_tahoe", model = "tahoe", category = "Car"},
    {name = "dodge_16challenger", model = "16challenger", category = "Car"},
    {name = "dodge_16charger", model = "16charger", category = "Car"},
    {name = "dodge_dg", model = "dodgeg", category = "Car"},
    {name = "dodge_old", model = "dodgeold", category = "Car"},
    {name = "dodge_vip", model = "vip8", category = "Car"},
    {name = "viper", model = "viper", category = "Car"},
    {name = "ford_boss", model = "boss302", category = "Car"},
    {name = "ford_fgt", model = "fgt", category = "Car"},
    {name = "ford_focus", model = "ffrs", category = "Car"},
    {name = "ford_gt2017", model = "gt2017", category = "Car"},
    {name = "ford_hsuper", model = "fordh", category = "Car"},
    {name = "ford_max", model = "expmax20", category = "Car"},
    {name = "ford_mgt", model = "mgt", category = "Car"},
    {name = "ford_scape", model = "fescape", category = "Car"},
    {name = "ford_shelbold", model = "shelbygt500", category = "Car"},
    {name = "ford_svt", model = "svt00", category = "Car"},
    {name = "heyundai_santafe", model = "santafe", category = "Car"},
    {name = "lamborghini_urus", model = "urus2018", category = "Car"},
    {name = "mclaren_720s", model = "720s", category = "Bike"},
    {name = "mclaren_f1", model = "mcf1", category = "Bike"},
    {name = "nissan_skyline", model = "skyline", category = "Car"},
    {name = "porsche_911", model = "911turbos", category = "Car"},
    {name = "toyota_brz", model = "brzbn", category = "Car"},
    {name = "toyota_camry", model = "camry55", category = "Car"},
    {name = "toyota_frzn", model = "toyotafr", category = "Car"},
    {name = "toyota_runner", model = "4runner", category = "Car"},
    {name = "toyota_supra_2020", model = "gxa90", category = "Car"},
    {name = "Supra", model = "rmodsupra", category = "Car"},
    {name = "aston_martin", model = "wyccvt", category = "Car"},
    {name = "RAM", model = "dodgetrx", category = "Car"},
    {name = "aston_martin_new", model = "aone", category = "Car"},
    {name = "benze_ghadimi", model = "190e", category = "Car"},
    {name = "motor_honda", model = "160montada", category = "Bike"},
    {name = "pride1", model = "psabafn", category = "Car"},
    {name = "pride2", model = "sj131", category = "Car"},
    {name = "pride", model = "pride", category = "Car"},
    {name = "peykan", model = "peykan", category = "Car"},
    {name = "peykan2", model = "hudhorc", category = "Car"},
    {name = "MAZERATI", model = "ghis2", category = "Car"},
    {name = "mlmansory", model = "mlmansory", category = "Car"},
    {name = "goldwing", model = "goldwing", category = "Bike"},
    {name = "Pagani", model = "rmodpagani", category = "Car"},
    {name = "New", model = "ts1", category = "Car"},
    {name = "mitsubishi", model = "lanex400", category = "Car"},
    {name = "lambo_gelardo", model = "2013LP560", category = "Car"},
    {name = "audiq8", model = "q8prior", category = "Car"},
    {name = "quinseg", model = "agerars", category = "Car"},
    {name = "lambo_svj", model = "svjtt", category = "Car"},
    {name = "amg_a45", model = "lwcla45", category = "Car"},
    {name = "pikaco", model = "pika01", category = "Car"},
    {name = "BMW", model = "bmwx6m2020", category = "Car"},
    {name = "STO", model = "STO", category = "Car"},
    {name = "ferrari", model = "sp2mansory", category = "Car"},
    {name = "benz500w124", model = "500w124", category = "Car"},
    {name = "benze632014", model = "e632014", category = "Car"},
    {name = "phantom_rolsroys", model = "ghostonyx", category = "Car"},
    {name = "bmw_rally", model = "m8gte", category = "Car"},
    {name = "nissan_nisimo", model = "370z", category = "Car"},
    {name = "teslamodels", model = "teslamodels", category = "Car"},
    {name = "gtr_2021", model = "gtr50", category = "Car"},
    {name = "toyota_shasi", model = "vxr", category = "Car"},
    {name = "zl12017", model = "zl12017", category = "Car"},
    {name = "ts1", model = "ts1", category = "Car"},
    {name = "jeep", model = "fj40", category = "Car"},
    {name = "bmwi8", model = "rmodbmwi8", category = "Car"},
    {name = "rangerover", model = "rrst", category = "Car"},
    {name = "rangerover2", model = "evoque", category = "Car"},
    {name = "porsche", model = "911turbos", category = "Car"},
    {name = "nissantitan", model = "nissantitan17", category = "Car"},
    {name = "GTRsport", model = "lwgtr", category = "Car"},
    {name = "gtr", model = "gtr", category = "Car"},
    {name = "nh2r", model = "nh2r", category = "Bike"},
    {name = "benze6", model = "g63amg6x6", category = "Car"},
    {name = "maclaren", model = "720s", category = "Car"},
    {name = "laferrari", model = "laferrari", category = "Car"},
    {name = "jeepshasi", model = "trhawk", category = "Car"},
    {name = "h2carb", model = "h2carb", category = "Bike"},
    {name = "FerrariS", model = "fc15", category = "Car"},
    {name = "dm1200", model = "dm1200", category = "Bike"},
    {name = "diavel", model = "diavel", category = "Bike"},
    {name = "maclaren", model = "p1gtr", category = "Car"},
    {name = "astonmartin", model = "db11", category = "Car"},
    {name = "bugatti", model = "bugatti", category = "Car"},
    {name = "s1000rr", model = "s1000rr", category = "Bike"},
    {name = "bmwci", model = "bmci", category = "Car"},
    {name = "bmw4gts", model = "rmodm4gts", category = "Car"},
    {name = "bmwi82", model = "rmodmi8", category = "Car"},
    {name = "i8", model = "i8", category = "Car"},
    {name = "bentSH", model = "bentaygast", category = "Car"},
    {name = "bme46", model = "e46", category = "Car"},
    {name = "audir8", model = "r8ppi", category = "Car"},
    {name = "406", model = "406", category = "Bike"},
    {name = "camaro", model = "rmodzl1", category = "Car"},
    {name = "cls2015", model = "cls2015", category = "Car"},
    {name = "foxshelby", model = "foxshelby", category = "Car"},
    {name = "g65amg", model = "g65amg", category = "Car"},
    {name = "lambolp770", model = "lp770", category = "Car"},
    {name = "BM2021", model = "2021m5", category = "Car"},
    {name = "macan", model = "macan", category = "Car"},
    {name = "maserati2", model = "f620", category = "Car"},
    {name = "p207", model = "p207", category = "Car"},
    {name = "Golf", model = "rmodmk7", category = "Car"},
    {name = "Pvanet", model = "vanetp", category = "Car"},
    {name = "BenzClasic", model = "mbslr", category = "Car"},
    {name = "Benz2022", model = "MVISIONGT", category = "Car"},
    {name = "206", model = "206", category = "Car"},
}

Citizen.CreateThread(function()
	local IPoint
	local Key
	local Point = RegisterPoint(vector3(-1400.58,25.48,53.23), 10, true)
	Point.set("Tag", "vipcartest")
	Point.set("InArea", function()
		ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Test Mashin Haye VIP", vector3(-1400.58,25.48,53.23))
		DrawMarker(0, vector3(-1400.58,25.48,53.23), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 100, 80, 255, 0, 0, 0, 0)
	end)
	Point.set("InAreaOnce", function()
		IPoint = RegisterPoint(vector3(-1400.58,25.48,53.23), 1.5, true)
		IPoint.set("Tag", "vipcartest")
		IPoint.set('InAreaOnce', function ()
			Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Test Mashin Haye VIP')
			Key = RegisterKey('E', false, function()
				Key = UnregisterKey(Key)
				OpenMenuVIP()
			end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
			ESX.UI.Menu.CloseAll()
			if GlobalPerview then
				ESX.ClearTimeout(GlobalPerview)
				GlobalPerview = nil
			end
			if localVeh then
				DeleteVehicle(localVeh)
				localVeh = nil
			end
			if camera then
				ClearFocus()
				RenderScriptCams(false, false, 0, true, false)
				DestroyCam(camera, false)
				camera = nil
			end
		end)
	end, function()
		if IPoint then
			IPoint = IPoint.remove()
		end
	end)
end)

local coordet = vector3(-1401.16,35.77,53.1)

function OpenMenuVIP()
	ESX.UI.Menu.CloseAll()
	for k, v in pairs(GetGamePool("CVehicle")) do
        if not NetworkGetEntityIsNetworked(v) then 
            DeleteEntity(v)
        end
    end
	local element = {}
	for k, v in pairs(Vehiclesz) do
		table.insert(element, {label = v.name, value = v.model})
	end
	camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)			
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
		title    = "VIP Cars",
		align    = 'top-left',
		elements = element
	}, function(data, menu)
		menu.close()
		Citizen.Wait(500)
		ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'buy_car_confirm', {
			title    = 'آیا قصد تست کردن ماشین را دارید؟',
			align    = 'center',
			elements = {
				{label = 'Kheyr',  value = false},
				{label = 'Bale(5,000$)', value = true}
			}
		}, function(data2, menu2)
			if data2.current.value then
				TriggerServerEvent("esx_dCoin:BucketHandler")
				CarSpawnThread(data.current.value)
				menu2.close()
			else
				OpenMenuVIP()
			end
		end, function(data3, menu3)
			menu2.close()
			OpenMenuVIP()
		end)
	end, function(data, menu)
		menu.close()
	end, function(data, menu)
		if GlobalPerview then
			ESX.ClearTimeout(GlobalPerview)
			GlobalPerview = nil
		end
		if localVeh then
			DeleteVehicle(localVeh)
			localVeh = nil
		end
		if data.current.value then
			--local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(this_Garage)

			--if foundSpawn then
				SetCamCoord(camera, coordet.x + 3.0, coordet.y + 3.0, coordet.z+ 3.0)
				SetCamActive(camera, true)
				PointCamAtCoord(camera, coordet.x, coordet.y, coordet.z)
				RenderScriptCams(true, true, 1000, true, false)

				GlobalPerview = ESX.SetTimeout(500, function()
					--ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
					local vehicle = data.current.value
						if not localVeh then
							ESX.Game.SpawnLocalVehicle(vehicle, coordet, 240.63, function(callback_vehicle)
								--SetVehicleDoorsLockedForAllPlayers(callback_vehicle, true)
								if localVeh then
									DeleteVehicle(callback_vehicle)
								else
									localVeh = callback_vehicle
									SetVehRadioStation(callback_vehicle, "OFF")
								end
							end)
						end
					--end, data.current.value.plate)
				end)
		end
	end, function()
		if GlobalPerview then
			ESX.ClearTimeout(GlobalPerview)
			GlobalPerview = nil
		end
		if localVeh then
			DeleteVehicle(localVeh)
			localVeh = nil
		end
		if camera then
			ClearFocus()
			RenderScriptCams(false, false, 0, true, false)
			DestroyCam(camera, false)
			camera = nil
		end
	end)
end

function CarSpawnThread(name)
    TeleportThread(function()
        ESX.Game.SpawnLocalVehicle(name, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(Veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
			ESX.CreateVehicleKey(Veh)
            SetEntityAsMissionEntity(Veh, true, true)
            CounterThread(Veh)
            ESX.Alert("~g~Shoma 60 Saniye Forsat Darid Test Konid", "info")
        end)
    end)
end

function CounterThread(Veh)
    SetTimeout(1*60*1000, function()
        ESX.Game.DeleteVehicle(Veh)
        ESX.Alert("~y~Mohlat Test Be Payan Resid", "info")
        local coords = vector3(-1400.58,25.48,53.23)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        local timeout = 0
        DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(100)
		end
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
            Citizen.Wait(500)
            timeout = timeout + 500
        end
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        DoScreenFadeIn(500)
        TriggerServerEvent("backme")
    end)
end

function TeleportThread(cb)
	local coords = vector3(-1640.82, -2738.11, 13.94)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local timeout = 0
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(100)
	end
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
		Citizen.Wait(500)
		timeout = timeout + 500
	end
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	SetEntityHeading(PlayerPedId(), 151.57)
	DoScreenFadeIn(500)
	Wait(1000)
	cb()
end]]
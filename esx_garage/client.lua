---@diagnostic disable: undefined-field, lowercase-global, param-type-mismatch, undefined-global
--[[Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('garagew')))
end)]]
local newData = {}
local callbackWait
local inGarage = 0
local globalData
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler("esx_garage:requestMenu", function(carTable, cameraCoord, callback)
    local lastData = {}
    inGarage = 0
    for _,v in pairs(carTable) do
        local info = {}
		local hashVehicule = v.vehicle.model
		if hashVehicule and IsModelInCdimage(hashVehicule) then
			local vehicleName = ESX.GetVehicleLabelFromHash(hashVehicule)
			if vehicleName == "Unknown" then
				vehicleName = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(hashVehicule))
			end
			if vehicleName == "Unknown" then
				vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			end
			if v.stored and not v.imp then
				inGarage = inGarage + 1
				info["state"] = 1
			else
				info["state"] = 0
			end
			info["VehModel"] = v.plate..(v.imp and " (PD/SH Impound)" or not v.stored and " (Impound)" or "")
			info["ImageName"] = ESX.Math.Trim(string.lower(GetDisplayNameFromVehicleModel(hashVehicule)))
			info["VehText"] = vehicleName
			info["plate"] = v.plate
			info["damages"] = v.damages
			info["vehicle"] = v.vehicle
            info["chopped"] = v.chopped
			table.insert(lastData, info)
		end
    end
    LastCamera = {
        coords = vector4(cameraCoord.coords.x, cameraCoord.coords.y, cameraCoord.coords.z, cameraCoord.heading or cameraCoord.h),
    }
    Citizen.Wait(5)
    globalData = nil
    callbackWait = false
    SendReactMessage('setOpen', { setVeh = lastData, setName = "Garage", inGarage = inGarage or 0, Price = 0 })
    SetNuiFocus(true, true)
    while not callbackWait do
        Citizen.Wait(10)
    end
    callback(globalData)
    globalData = nil
    callbackWait = false
end)

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
        exports["LegacyFuel"]:SetFuel(car, damages["fuel"]+0.0)
        SetVehicleFuelLevel(car, damages["fuel"]+0.0)
	end
end

RegisterNUICallback('SpawnVehicle', function(data)
    if not DoesEntityExist(localVeh) then return end
    DeleteVehicle(localVeh)
    localVeh = nil
    StopCamera()
    globalData = data.Table
    callbackWait = true
    SendReactMessage('Close')
end)

RegisterNUICallback('VehicleInfo', function(data, cb)
    if GlobalPerview then
        ESX.ClearTimeout(GlobalPerview)
        GlobalPerview = nil
    end
    if localVeh then
        DeleteVehicle(localVeh)
        localVeh = nil
    end
    local vehicle = data.data.vehicle
    local damages = data.data.damages
    local chopped = data.data.chopped
    GlobalPerview = ESX.SetTimeout(500, function()
        --ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle, damages)
            if not localVeh then
                ESX.Game.SpawnLocalVehicle(vehicle.model, LastCamera.coords, LastCamera.coords.w, function(callback_vehicle)
                    if localVeh then
                        DeleteVehicle(callback_vehicle)
                    else
                        localVeh = callback_vehicle
                        vehicle.plate = data.data.plate
                        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
                        SetVehRadioStation(callback_vehicle, "OFF")
                        Citizen.Wait(250)
                        ESX.RepeatCode(function()
                            setDamages(callback_vehicle, damages)
                        end, 2, 1000)
                        Citizen.Wait(1000)
                        cb({
                            Fuel = math.ceil(GetVehicleFuelLevel(localVeh)),
                            Speed = math.ceil(GetVehicleEstimatedMaxSpeed(localVeh)* 3.6),
                            Traction = math.ceil(GetVehicleMaxTraction(localVeh)),
                            Acceleration = math.ceil(GetVehicleAcceleration(localVeh))
                        })
                        local fuel = GetVehicleFuelLevel(localVeh)
                        Citizen.CreateThread(function()
                            while localVeh and DoesEntityExist(localVeh) do
                                Wait(0)
                                local vehpos = GetOffsetFromEntityInWorldCoords(localVeh, 0.0, 0.0, 2.0)
                                ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5),'Benzin : '.. ESX.Math.Round(fuel).. '%',1)
                                ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75),'Engine : '.. tostring(chopped and 'Kheir' or 'Bale'),1)
                                ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1),'Salamate motor : ' .. ESX.Math.Round(GetVehicleEngineHealth(localVeh) / 10) .. '%',1)
                            end
                            StopCamera()
                            DeleteEntity(localVeh)
                        end)
                    end
                    if not camera then
                        CreateCamera()
                    end
                    SetCamActive(camera, true)
                    local camCoords = GetOffsetFromEntityInWorldCoords(callback_vehicle, 2.0, 5.0, 2.0)
                    local pointCoords = GetOffsetFromEntityInWorldCoords(callback_vehicle, 2.0, 0.0, 0.0)
                    PointCamAtCoord(camera, pointCoords.x, pointCoords.y, pointCoords.z)
                    SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z)
                end)
            end
        --end, data.current.value.plate)
    end)
end)

RegisterNUICallback('BackPage', function()
    DeleteVehicle(currentVeh)
end)

RegisterNUICallback('Close', function()
    if GlobalPerview then
        ESX.ClearTimeout(GlobalPerview)
        GlobalPerview = nil
    end
    if localVeh then
        DeleteVehicle(localVeh)
        localVeh = nil
    end
    StopCamera()
    SetNuiFocus(false, false)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    Citizen.Wait(1000)
    globalData = nil
    callbackWait = true
end)

function CreateCamera()
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function StopCamera()
	if camera then
		ClearFocus()
        DestroyAllCams(true)
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(camera, false)
		camera = nil
	end
end

RegisterNUICallback("rotateright", function(data)
    SetEntityHeading(localVeh, GetEntityHeading(localVeh) - 2)
end)

RegisterNUICallback("rotateleft", function()
    SetEntityHeading(localVeh, GetEntityHeading(localVeh) + 2)
end)

function SendReactMessage(action, data) SendNUIMessage({ action = action, data = data }) end
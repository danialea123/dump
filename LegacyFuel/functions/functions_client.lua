---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global, lowercase-global
function ArrayHasValue(array, value, field)
	if field then
		for _, v in pairs(array) do
			if value == v[field] then
				return true
			end
		end
	else 
		for _, v in pairs(array) do
			if value == v then
				return true
			end
		end
	end

	return false
end

function GetClosestVehicle2(coords, radius, includeFilter, excludeFilter, driveableOnly)
	ESX = ESX while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end
	local vehicle = ESX.Game.GetClosestVehicle(coords, includeFilter, excludeFilter, driveableOnly)
	if not DoesEntityExist(vehicle) then
		return 0
	end
	local playerCoords = GetEntityCoords(PlayerPedId())
	local vehicleCoords = GetEntityCoords(vehicle)
	local distance = #(playerCoords - vehicleCoords)
	if distance > radius then
		return 0
	end

	return vehicle
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

function DrawName3D(x,y,z, text) -- some useful function, use it if you want!
    SetDrawOrigin(x, y, z, 0);
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.0, 0.4)
	SetTextColour(240,230,140, 240)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function FindNearestFuelPump()
	local playerCoords = GetEntityCoords(PlayerPedId())
	local pumpObject = 0
	local pumpDistance = -1
	for _, object in pairs(ESX.Game.GetObjects()) do
		local model = GetEntityModel(object)
		if ArrayHasValue(Config.PumpModels, model) then
			local dstcheck = #(playerCoords - GetEntityCoords(object))
			if pumpDistance == -1 or dstcheck < pumpDistance then
				pumpDistance = dstcheck
				pumpObject = object
			end
		end
	end
	return pumpObject, pumpDistance
end

function FuelRound(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function localGasStation()
	local id
	local ped = GetPlayerPed(PlayerId())
	for i=1 ,#Config.GasStations,1 do
		local distance2 = GetDistanceBetweenCoords(GetEntityCoords(ped), Config.GasStations[i].coord)
		if distance2 < 35 then
			id = Config.GasStations[i].id
		end
	end
	return id
end
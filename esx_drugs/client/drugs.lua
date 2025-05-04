---@diagnostic disable: param-type-mismatch, undefined-global, missing-parameter
local isPickingUp = false
local SpawnedPlanet = {}

Citizen.CreateThread(function ()
	while true do
        local pCoord = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.FieldZones) do
			Wait(100)
			if #(v.coords - pCoord) < v.range + 30 then
				if not SpawnedPlanet[k] then
					SpawnedPlanet[k] = {}
					TriggerEvent('esx:showNotification', _U(v.msg))
					SpawnPlants(k)
				end
			else
				if SpawnedPlanet[k] then
					for id,t in pairs(SpawnedPlanet[k]) do
						ESX.Game.DeleteLocalObject(t.obj)
					end
					SpawnedPlanet[k] = nil
					exports.sr_main:RemoveByTag(k)
				end
			end
		end
		Wait(1000)
	end
end)

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

function PickUpCondition()
	return (IsPedOnFoot(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not isPickingUp) and canEnter
end

function SpawnPlants(field)
	RequestModel(Config.FieldZones[field].model)
	while not HasModelLoaded(Config.FieldZones[field].model) do Wait(0) end

	repeat
		local Key
		local coord = GenerateCoords(field)
		local obj = CreateObject(Config.FieldZones[field].model, coord, false, false, true)
		local id = #SpawnedPlanet[field] + 1
		local Point = RegisterPoint(coord, 1, true)
		Point.set('Tag', field)
		Point.set('InAreaOnce', function ()
			Hint:Create(('~INPUT_CONTEXT~ Bardasht ~g~%s~s~'):format(string.gsub(field, 'Field', '')), PickUpCondition)
			Key = RegisterKey('E', false, function ()
				if not PickUpCondition() then
					return
				end
				isPickingUp = true
				Hint:Delete()
				Key = UnregisterKey(Key)
				local drug = string.gsub(field, 'Field', '')
				TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
				TriggerEvent("mythic_progbar:client:progress", {
					name = "harvest_"..drug,
					duration = 4500,
					label = "Bardasht ".. drug,
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				}, function(status)
					if not status then
						ClearPedTasks(PlayerPedId())
						ESX.Game.DeleteLocalObject(SpawnedPlanet[field][id].obj)
						SpawnedPlanet[field][id].point.remove()
						SpawnedPlanet[field][id] = nil
						TriggerServerEvent('esx_jk_drugs:pickedUpPlant', string.lower(drug), field)
						if tLength(SpawnedPlanet[field]) <= 3 then
							SpawnPlants(field)
						end
						isPickingUp = false
					elseif status then
						ClearPedTasksImmediately(PlayerPedId())
						isPickingUp = false
					end
				end)
			end)
		end, function ()
			Hint:Delete()
			Key = UnregisterKey(Key)
		end)

		SpawnedPlanet[field][id] = {obj = obj, point = Point}

		Wait(10)
		PlaceObjectOnGroundProperly_2(obj)
		FreezeEntityPosition(obj, true)
	until (tLength(SpawnedPlanet[field]) >= 10)
	SetModelAsNoLongerNeeded(Config.FieldZones[field].model)
end

function GenerateCoords(field)
	local coord
	repeat
		local x, y

		math.randomseed(GetGameTimer())
		local modX = math.random(-Config.FieldZones[field].range, Config.FieldZones[field].range)
		local modY = math.random(-Config.FieldZones[field].range, Config.FieldZones[field].range)

		x = Config.FieldZones[field].coords.x + modX
		y = Config.FieldZones[field].coords.y + modY

		local coordZ = GetCoordZ(x, y)
		coord = vector3(x, y, coordZ)
	until ValidateCoord(field, coord)

	return coord
end

function ValidateCoord(field, plantCoord)
	local validate = true

	for k, v in pairs(SpawnedPlanet[field]) do
		if #(plantCoord - GetEntityCoords(v.obj)) < 5 then
			validate = false
		end
	end

	return validate
end

function GetCoordZ(x, y)
	local coordZ = 0
	local height = 300.0

	local foundGround = false
	repeat
		Wait(10)
		foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		coordZ = z + 1
		height = height - 5.0
	until foundGround or height < -100

 	return coordZ
end

for k,v in pairs(Config.ProcessZones) do
	local Zone = RegisterPoint(v.coords, 15, true)
	Zone.set('InAreaOnce', function ()
		TriggerEvent('esx:showNotification', _U(v.msg))
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, field in pairs(SpawnedPlanet) do
			for k,v in pairs(field) do
				ESX.Game.DeleteLocalObject(v.obj)
			end
		end
	end
end)
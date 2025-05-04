ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local debugProps, sitting, lastPos, currentSitCoords, currentScenario = {}
local disableControls = false
local currentObj = nil
local sleeping = false
local pedar = {
	[-853526657] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[-1737090544] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[1889748069] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[-1222451822] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[1820665191] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[-1086524442] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[-399437949] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[-1120527678] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
}
local changer = {
	[-1737090544] = true,
	[-853526657] = true,
}

if configSeat.Debug then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)
			for i=1, #debugProps, 1 do
				local coords = GetEntityCoords(debugProps[i])
				local hash = GetEntityModel(debugProps[i])
				local id = coords.x .. coords.y .. coords.z
				local model = 'unknown'

				for i=1, #configSeat.Interactables, 1 do
					local seat = configSeat.Interactables[i]

					if hash == GetHashKey(seat) then
						model = seat
						break
					end
				end

				local text = ('ID: %s~n~Hash: %s~n~Model: %s'):format(id, hash, model)

				ESX.Game.Utils.DrawText3D({
					x = coords.x,
					y = coords.y,
					z = coords.z + 2.0
				}, text, 0.5)
			end

			if #debugProps == 0 then
				Citizen.Wait(500)
			end
		end
	end)
end

local function seatThread()
	ESX.SetPlayerData('isSitting',true)
	Citizen.CreateThread(function()
		while sitting do
			Citizen.Wait(10)
			local canSleep = true
	
			if sitting and not IsPedUsingScenario(PlayerPedId(), currentScenario) then
				wakeup()
				canSleep = false
			end
	
			-- Disable controls
			if disableControls then
				DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
				canSleep = false
			end
	
			if canSleep then
				Citizen.Wait(500)
			end
		end
		Wait(1000)
		ESX.SetPlayerData('isSitting',false)
	end)
end

-- AddEventHandler("onMultiplePress", function(keys)
-- 	if keys["lshift"] and keys["e"] and ESX.GetPlayerData()['IsDead'] ~= 1 then
		
-- 		if sitting then
-- 			wakeup()
-- 		else
-- 			local object, distance = GetNearChair()

-- 			if configSeat.Debug then
-- 				table.insert(debugProps, object)
-- 			end

-- 			if distance and distance < 1.4 then
-- 				local hash = GetEntityModel(object)

-- 				for k,v in pairs(configSeat.Sitable) do
-- 					if GetHashKey(k) == hash then
-- 						sit(object, k, v)
-- 						break
-- 					end
-- 				end
-- 			end
-- 		end

-- 	end
-- end)



AddEventHandler('onKeyDown', function(key)
	if key == "x" then
		if sitting then
			wakeup()
		elseif sleeping then
			ClearPedTasks(PlayerPedId())
			sleeping = false
		end
	end
end)

function GetNearChair()
	local object, distance
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #configSeat.Interactables do
		object = GetClosestObjectOfType(coords, 3.0, GetHashKey(configSeat.Interactables[i]), false, false, false)
		distance = #(coords - GetEntityCoords(object))
		if distance < 1.6 then
			return object, distance
		end
	end
	return nil, nil
end

function wakeup()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(playerPed)

	TaskStartScenarioAtPosition(playerPed, currentScenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
	while IsPedUsingScenario(playerPed, currentScenario) do
		Wait(100)
	end
	ClearPedTasks(playerPed)

	FreezeEntityPosition(playerPed, false)
	--FreezeEntityPosition(currentObj, false)

	TriggerServerEvent('sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
	sitting = false
	disableControls = false
end

function sit(object, modelName, data)
	-- Fix for sit on chairs behind walls
	local ped = PlayerPedId()
	--if not HasEntityClearLosToEntity(ped, object, 17) then
	--	return
	--end
	disableControls = true
	currentObj = object
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(ped)
	local cal = (playerPos.z - pos.z)/2
	if changer[GetEntityModel(object)] then
		cal = -0.1
	end
	local objectCoords = ESX.Math.Round(pos.x,1) .. ESX.Math.Round(pos.y,1) .. ESX.Math.Round(pos.z,1)

	ESX.TriggerServerCallback('sit:getPlace', function(occupied)
		if occupied then
			-- ESX.ShowNotification('There is someone on this chair')
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('sit:takePlace', objectCoords)
			
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + cal, GetEntityHeading(object) + 180.0, 0, true, false)

			Citizen.Wait(2500)
			if GetEntitySpeed(ped) > 0 then
				ClearPedTasks(ped)
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + cal, GetEntityHeading(object) + 180.0, 0, true, true)
			end

			sitting = true
			seatThread()
		end
	end, objectCoords)
end

AddEventHandler('PlayerLoadedToGround', function(xPlayer)
	Wait(10000)
	loadTargets()
end)

function loadTargets()
	local targets = {}
	for k,v in pairs(configSeat.Interactables) do
		table.insert(targets, GetHashKey(v))
	end
	table.insert(targets, -853526657)
	table.insert(targets, 1889748069)
	table.insert(targets, -1737090544)
	table.insert(targets, -1222451822)
	table.insert(targets, 1820665191)
	table.insert(targets, -1086524442)
	table.insert(targets, -399437949)
	table.insert(targets, -1120527678)
	exports['diamond_target']:AddTargetModel(targets, {
        options = {
            {
                icon = "fa-solid fa-chair",
                label = "نشستن",
                action = function(entity)
					local hash = GetEntityModel(entity)
					for k, v in pairs(pedar) do
						if k == hash then
							sit(entity, k, v)
							break
						end
					end
					for k,v in pairs(configSeat.Sitable) do
						if GetHashKey(k) == hash then
							sit(entity, k, v)
							break
						end
					end
                end,
            },
        },
        distance = 2.5
    })
	local targetBeds = {}
	for k,v in pairs(configSeat.beds) do
		table.insert(targetBeds, GetHashKey(v))
	end
	exports['diamond_target']:AddTargetModel(targetBeds, {
        options = {
            {
                icon = "fa-solid fa-bed",
                label = "دراز کشیدن",
                action = function(entity)
					local ped = PlayerPedId()
					local bedCoords, bedHeading = GetEntityCoords(entity), GetEntityHeading(entity)
					ESX.Streaming.RequestAnimDict('missfbi1')
					ESX.SetEntityCoords(ped, bedCoords)
					SetEntityHeading(ped, (bedHeading+180))

					TaskPlayAnim(ped, 'missfbi1', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 0, false, false, false)

					sleeping = true
                end,
            },
        },
        distance = 3.5
    })
end
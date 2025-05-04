local SpamProtect = false
local response = true
local find = false
local oCars = {}
local dict = "anim@mp_player_intmenu@key_fob@"

RegisterKey('G', false, function ()
	CheckNearCars()
end)

function CheckNearCars(event)
	if not SpamProtect then
		local coords = GetEntityCoords(PlayerPedId())
		local hasAlreadyLocked = false
		local carstrie = GetVehiclesInAreaSorted(coords, 30)
		local notowned = 0
		if #carstrie > 0 then
			SpamProtect = true
			SetTimeout(5000, function()
				SpamProtect = false
				find = false
				response = true
			end)
			response = true
			find = false
			for i=1, #carstrie, 1 do
				local time = GetGameTimer()
				while not response or (GetGameTimer() - time > 5000) do
					Wait(0)
				end
				if find then
					break
				end
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
				local net = VehToNet(carstrie[i])
				local lock = GetVehicleDoorsLockedForPlayer(carstrie[i])
                print(lock)
				local vehicleLabel = ESX.GetVehicleLabelFromHash(GetEntityModel(carstrie[i]))
				if event then
					response = false
					ESX.TriggerServerCallback(event, function(owner)
						response = true
						if owner then
							if lock == 1 or lock == 0 then
								LockCar(net, vehicleLabel)
							elseif lock == 2 then
								UnlockCar(net, vehicleLabel)
							end
							find = true
						else
							notowned = notowned + 1
						end
					end, event == 'JobLock' and net or event == 'carlock:isVehicleOwner' and plate)
				else
					for k,v in pairs(oCars) do
						if v == net then
							if not lock then
								LockCar(net, vehicleLabel)
							elseif lock then
								UnlockCar(net, vehicleLabel)
							end
							break
						end
					end
				end
			end
			if notowned == #carstrie then
				ESX.Alert("Hich Kodam az Mashin haye Shoma Nazdik nistand", "error")
			end
		end
	end
end

function LockCar(vehicle, name)
	--TriggerServerEvent('esx_carlock:SyncCarLcoker', VehToNet(vehicle), true)
	CarLocker(vehicle, true)
	PlayVehicleDoorCloseSound(vehicle, 1)
	ESX.Alert('Shoma ~y~'..name..'~s~ ra ~r~ghofl~s~ kardid~s~.', "check")
	TriggerEvent("InteractSound_CL:PlayOnOne", "lock", 0.5)
	local text = '* vasile naghlie ro ghofl mikone *'
	ExecuteCommand("me "..text)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	end
end

function UnlockCar(vehicle, name)
	--TriggerServerEvent('esx_carlock:SyncCarLcoker', VehToNet(vehicle), false)
	CarLocker(vehicle, false)
	PlayVehicleDoorOpenSound(vehicle, 0)
	ESX.Alert('Shoma ~y~'..name..'~s~ ra ~g~baz~s~ kardid~s~.', "check")
	TriggerEvent("InteractSound_CL:PlayOnOne", "unlock", 0.5)
	local text = '* vasile naghlie ro Baz mikone *'
	ExecuteCommand("me "..text)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	end
end

RegisterNetEvent('esx_carlock:addCarLock')
AddEventHandler('esx_carlock:addCarLock', function(net, toggle)
	if toggle then
		table.insert(oCars, net)
	else
		for k,v in pairs(oCars) do
			if v == net then
				table.remove(oCars, k)
				break
			end
		end
	end
end)

function CarLocker(vehicle, toggle)
	if vehicle and vehicle ~= 0 then
		if toggle then
			SetVehicleDoorShut(NetToVeh(vehicle), 0, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 1, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 2, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 3, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 4, false)
			SetVehicleDoorShut(NetToVeh(vehicle), 5, false)
			--SetVehicleDoorsLocked(vehicle, 2)
			--SetVehicleDoorsLockedForAllPlayers(NetToVeh(vehicle), true)
		else
			--SetVehicleDoorsLocked(vehicle, 1)
			--SetVehicleDoorsLockedForAllPlayers(NetToVeh(vehicle), false)
		end
	end
end

GetVehiclesInAreaSorted = function(coords, area)
	local vehicles       = ESX.Game.GetVehicles()
	local vehiclesInArea = {}
	local temp 			 = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = #(vehicleCoords - vector3(coords.x, coords.y, coords.z))

		if distance <= area then
			table.insert(temp, {vehicle = vehicles[i], distance = distance})
		end
	end

	for i=1, #temp do
		local lower = Sort(temp)
		table.insert(vehiclesInArea, temp[lower].vehicle)
		table.remove(temp, lower)
	end

	return vehiclesInArea
end

function Sort(table)
	local lower = -1
	local index = 1
	for i=1, #table do
		if lower == -1 or table[i].distance < lower then
			lower = table[i].distance
			index = i
		end
	end
	return index
end
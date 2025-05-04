---@diagnostic disable: lowercase-global, undefined-field, missing-parameter, param-type-mismatch
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
ESX = nil
local PlayerData = {}
local pointed = nil
local impound = {busy = false, vehicle = 0}
local time = 0
local DesiredVehicle

--  V A R I A B L E S | REGARDING TO ASSETS --
local engineoff = false
local saved = false
-- E N G I N E --
local IsEngineOn = true

local realworld  = true

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(world)
	if world == 0 then
		realworld = true
	else
		realworld = false
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local authorizedVehicles = {
    fbi = {
		1949211328,
		-1530607804,
		1127131465,
		-1647941228,
		-1973172295,
		198223837,
		-1953971833,
		1268785103,
		611662121,
	},
	police = {
		1912215274,
		1534316032,
		-725902531,
		1264341792,
		-1627000575,
		2046537925,
		-186537451,
		456714581,
		-34623805,
		-2007026063,
		831758577,
		-1973172295,
		949403409,
		-305727417,
		2071877360,
		1624609239,
		1127131465,
		-1647941228,
		-1917086021,
		-188151185,
		-1693015116,
		-982610657,
		-1083357304,
		-1205689942,
		2100335611,
		353883353,
		-834607087,
		-1661555510,
		-1683328900,
		1922257928,
		1747439474,
		2099668667,
		699188170,
		1002258198,
		-1145771600,
		-1530607804,
		-1965686528,
		244681512,
		-868574549,
		-371055712,
		-635488668,
		-1619710167,
		-1543585645,
		684713414,
		436299151,
		198223837,
		1230579450,
		-1953971833,
		1268785103,
		611662121,
	},

	sheriff = {
		-1683328900,
		353883353,
		1922257928,
		-1647941228,
		1127131465,
		2071877360,
		-1205689942,
		281000465,
		-2111081553,
		-1647941228,
		1002258198,
		-1965686528,
		-1530607804,
		-1771131952,
		-1145771600,
		684713414,
		-1973172295,
		244681512,
		-8688574549,
		-371055712,
		-635488668,
		-1619710167,
		741586030,
		-1543585645,
		436299151,
		198223837,
		1230579450,
		-1953971833,
		1268785103,
		611662121,
	},

	weazel = {
		1162065741,
		744705981,
		760189077,
		20059254,
		-1124637697,
		-736486717,
		-771538046,
		1268785103,
		611662121,
	},
	taxi = {
		1158859293,
		902761240,
		1941029835,
		2005502477,
		736902334,
		1123216662,
		-511601230,
		-1008861746,
		-2030171296,
		-956048545,
		-497458178,
		760189077,
		1047274985,
		-736486717,
		-713569950,
		-771538046,
		1268785103,
		611662121,
	},
	ambulance = {
		831758577,
		1171614426,
		1230579450,
		-2089623200,
		1463616320,
		-113113216,
		353883353,
		-1468262987,
		1002258198,
		-1965686528,
		-821619709,
		684713414,
		-442313018,
		1268785103,
		611662121,
	},
	mechanic = {
		1353720154,
		-1323100960,
		-1532697517,
		1119641113,
		143643855,
		-1526806709,
		2015368679,
		-1771131952,
		1047274985,
		-736486717,
		-771538046,
		-1045911276,
		1230579450,
		684713414,
		-442313018,
		1268785103,
		611662121,
	}
}

AddEventHandler('onKeyDown',function(key)
	if key == "y" then
		TriggerEvent("esx_vehiclecontol:trigger")
	end
end)

RegisterNetEvent("esx_vehiclecontol:trigger")
AddEventHandler("esx_vehiclecontol:trigger",function()	
			local ped = GetPlayerPed(-1)
			local job = PlayerData.job.name

			if IsPedSittingInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				if DoesHaveAccess(model, authorizedVehicles[job]) then
					TriggerEvent("esx_vehiclecontol:toggleLock", vehicle)
				else
					--ESX.Alert("~h~Shoma dastresi be switch in mashin ra nadarid")
				end
			else
			
				local vehicle = ESX.Game.GetVehicleInDirection(4)
				if vehicle ~= 0 then

					local model = GetEntityModel(vehicle)

					if DoesHaveAccess(model, authorizedVehicles[job]) then
						TriggerEvent("esx_vehiclecontol:toggleLock", vehicle)
					else
						--ESX.Alert("~h~Shoma dastresi be switch in mashin ra nadarid")
					end

				else

					if pointed then

						local model = GetEntityModel(pointed)
						if DoesHaveAccess(model, authorizedVehicles[job]) then
	
							local coords = GetEntityCoords(GetPlayerPed(-1))
							local vcoords = GetEntityCoords(pointed)
							if GetDistanceBetweenCoords(coords, vcoords, false) < 20 then
								TriggerEvent("esx_vehiclecontol:toggleLock", pointed)
							else
								ESX.Alert("~h~Shoma az vasile naghlie khili fasele darid")
							end
	
						else
							--ESX.Alert("~h~Shoma dastresi be switch in mashin ra nadarid")
						end
					end

				end
				

			end
end)

RegisterCommand("gethash", function(source,args)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is model: " .. tostring(model))
			end
        end
    end)
end, false)

RegisterCommand("getmodel", function(source)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 6 then
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is spawn name: " .. tostring(GetDisplayNameFromVehicleModel(model)))
			end
        end
    end)
end, false)

RegisterCommand("livery", function(source,args)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				SetVehicleLivery(vehicle,tonumber(args[1]))
			end
        end
    end)
end, false)

RegisterNetEvent("esx_vehiclecontol:changePointed")
AddEventHandler("esx_vehiclecontol:changePointed",function(veh)
	if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "doc" or PlayerData.job.name  == "mecano" or PlayerData.job.name == "taxi" or PlayerData.job.name == "government" or PlayerData.job.name == "weazel" then
		
		local vehicle = NetworkGetEntityFromNetworkId(veh)
		pointed = vehicle

	end
end)

RegisterNetEvent("esx_vehiclecontol:toggleLock")
AddEventHandler("esx_vehiclecontol:toggleLock",function(vehicle)

		local vehicle = vehicle
		local islocked = GetVehicleDoorLockStatus(vehicle)
		if (islocked == 1 or islocked == 0) then
			SetVehicleDoorsLocked(vehicle, 2)
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
			TriggerServerEvent("esx_vehiclecontrol:lights", NetId)
			ESX.Alert("Shoma ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. "~w~ ra ~r~ghofl ~w~kardid.")
			local dict = "anim@mp_player_intmenu@key_fob@"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(0)
			end
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end
			SetVehicleDoorShut(vehicle, 0, false)
			SetVehicleDoorShut(vehicle, 1, false)
			SetVehicleDoorShut(vehicle, 2, false)
			SetVehicleDoorShut(vehicle, 3, false)
			SetVehicleDoorShut(vehicle, 4, false)
			SetVehicleDoorShut(vehicle, 5, false)
			PlayVehicleDoorCloseSound(vehicle, 1)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "lock", 0.5)

		elseif islocked == 2 then
			SetVehicleDoorsLocked(vehicle, 1)
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
			TriggerServerEvent("esx_vehiclecontrol:lights", NetId)
			ESX.Alert("Shoma ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. "~w~ ra ~g~baaz ~w~kardid.")
			local dict = "anim@mp_player_intmenu@key_fob@"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(0)
			end
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end
			PlayVehicleDoorCloseSound(vehicle, 1)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "unlock", 0.5)
		end
end)

-- Server side sync
RegisterNetEvent("esx_vehiclecontol:ClientSync")
AddEventHandler("esx_vehiclecontol:ClientSync", function(NetId, state)
	local vehicle = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(vehicle) then
		if state then
			SetVehicleDoorsLocked(vehicle, 2) -- lock the door 
		else
			SetVehicleDoorsLocked(vehicle, 1) -- unlcok the door
		end
	end
end)


RegisterNetEvent("esx_vehiclecontol:lockLights")
AddEventHandler("esx_vehiclecontol:lockLights", function(veh)
	local vehicle = NetworkGetEntityFromNetworkId(veh)
	if DoesEntityExist(vehicle) then
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	end
	
end)

--####################### VEHICLE ASSETS Commands #############################

RegisterCommand('trunk', function(source)
	TriggerEvent('trunk')
end, false)

RegisterCommand('hood', function(source)
	TriggerEvent('hood')
end, false)

RegisterCommand('lfdoor', function(source)
	TriggerEvent('lfdoor')
end, false)

RegisterCommand('rfdoor', function(source)
	TriggerEvent('rfdoor')
end, false)

RegisterCommand('lrdoor', function(source)
	TriggerEvent('lrdoor')
end, false)

RegisterCommand('rrdoor', function(source)
	TriggerEvent('rrdoor')
end, false)

RegisterCommand('alldoors', function(source)
	TriggerEvent('alldoors')
end, false)

RegisterCommand('allwindowsdown', function(source)
	TriggerEvent('allwindowsdown')
end, false)

RegisterCommand('allwindowsup', function(source)
	TriggerEvent('allwindowsup')
end, false)
--####################### ENd OF VEHICLE ASSETS COMMANDS #############################

--####################### VEHICLE ASSETS HANDLER #############################
function EngineHandler(force)
	local player = GetPlayerPed(-1)

	if (IsPedSittingInAnyVehicle(player)) then

		DesiredVehicle = GetVehiclePedIsIn(player, false)

		if not force then

		    if GetPedInVehicleSeat(DesiredVehicle, -1) == player then
		    	if IsEngineOn == true then
		    		IsEngineOn = false
					SetVehicleEngineOn(DesiredVehicle, false, false, false)
		    	else
		    		IsEngineOn = true
		    		SetVehicleUndriveable(DesiredVehicle, false)
		    		SetVehicleEngineOn(DesiredVehicle, true, false, false)
		    	end
		    end

		else
			IsEngineOn = false
			SetVehicleEngineOn(DesiredVehicle, false, false, false)
		end
		
	end

end

--[[Citizen.CreateThread(function()
	while true do
		if not IsEngineOn then
			SetVehicleEngineOn(DesiredVehicle, (not GetIsVehicleEngineRunning(DesiredVehicle)), false, true)
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)]]
	
RegisterNetEvent("engineoff")
AddEventHandler("engineoff", function()
	local player = GetPlayerPed(-1)

	if (IsPedSittingInAnyVehicle(player)) then
		local vehicle = GetVehiclePedIsIn(player, false)
		engineoff = true
		ESX.Alert("Engine ~r~off~s~.")
		while (engineoff) do
			SetVehicleEngineOn(vehicle, false, false, false)
			SetVehicleUndriveable(vehicle, true)
			Citizen.Wait(0)
		end
	end
end)

RegisterNetEvent("engineon")
AddEventHandler("engineon", function()
	local player = GetPlayerPed(-1)

	if (IsPedSittingInAnyVehicle(player)) then
		local vehicle = GetVehiclePedIsIn(player, false)
		engineoff = false
		SetVehicleUndriveable(vehicle, false)
		SetVehicleEngineOn(vehicle, true, false, false)
		ESX.Alert("Engine ~g~on~s~.")
	end
end)

-- T R U N K --
RegisterNetEvent("trunk")
AddEventHandler("trunk", function()
	local player = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(player, true)
	end
	
	local isopen = GetVehicleDoorAngleRatio(vehicle, 5)

	if (isopen == 0) then
		SetVehicleDoorOpen(vehicle, 5, 0, 0)
	else
		SetVehicleDoorShut(vehicle, 5, 0)
	end
end)
-- Left Front Door --
RegisterNetEvent("lfdoor")
AddEventHandler("lfdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftDoor = GetEntityBoneIndexByName(vehicle, "door_dside_f")
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
				SetVehicleDoorShut(vehicle, 0, false)
			else
				SetVehicleDoorOpen(vehicle, 0, false)
			end
		else
			ESX.Alert("This vehicle does not have a front driver-side door.")
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- Right Front Door --
RegisterNetEvent("rfdoor")
AddEventHandler("rfdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontRightDoor = GetEntityBoneIndexByName(vehicle, "door_pside_f")
		if frontRightDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then
				SetVehicleDoorShut(vehicle, 1, false)
			else
				SetVehicleDoorOpen(vehicle, 1, false)
			end
		else
			ESX.Alert("This vehicle does not have a front passenger-side door.")
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- Left Rear Door --
RegisterNetEvent("lrdoor")
AddEventHandler("lrdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local rearLeftDoor = GetEntityBoneIndexByName(vehicle, "door_dside_r")
		if rearLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then
				SetVehicleDoorShut(vehicle, 2, false)
			else
				SetVehicleDoorOpen(vehicle, 2, false)
			end
		else
			ESX.Alert("This vehicle does not have a rear driver-side door.")
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- Left Rear Door --
RegisterNetEvent("rrdoor")
AddEventHandler("rrdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local rearRightDoor = GetEntityBoneIndexByName(vehicle, "door_pside_r")
		if rearRightDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then
				SetVehicleDoorShut(vehicle, 3, false)
			else
				SetVehicleDoorOpen(vehicle, 3, false)
			end
		else
			ESX.Alert("This vehicle does not have a rear passenger-side door.")
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- All Doors --
RegisterNetEvent("alldoors")
AddEventHandler("alldoors",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
			SetVehicleDoorShut(vehicle, 0, false)
			SetVehicleDoorShut(vehicle, 1, false)
			SetVehicleDoorShut(vehicle, 2, false)
			SetVehicleDoorShut(vehicle, 3, false)
			SetVehicleDoorShut(vehicle, 4, false)
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorOpen(vehicle, 0, false)
			SetVehicleDoorOpen(vehicle, 1, false)
			SetVehicleDoorOpen(vehicle, 2, false)
			SetVehicleDoorOpen(vehicle, 3, false)
			SetVehicleDoorOpen(vehicle, 4, false)
			SetVehicleDoorOpen(vehicle, 5, false)
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- all windows down --
RegisterNetEvent("allwindowsdown")
AddEventHandler("allwindowsdown", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lf")
		local frontRightWindow = GetEntityBoneIndexByName(vehicle, "window_rf")
		local rearLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lr")
		local rearRightWindow = GetEntityBoneIndexByName(vehicle, "window_rr")
		local frontMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_lm")
		local rearMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_rm")
		if
			frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or
				frontMiddleWindow ~= -1 or
				rearMiddleWindow ~= -1
			then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			RollDownWindow(vehicle, 4)
			RollDownWindow(vehicle, 5)
		else
			ESX.Alert("This vehicle has no windows.")
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- all windows up --
RegisterNetEvent("allwindowsup")
AddEventHandler("allwindowsup", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lf")
		local frontRightWindow = GetEntityBoneIndexByName(vehicle, "window_rf")
		local rearLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lr")
		local rearRightWindow = GetEntityBoneIndexByName(vehicle, "window_rr")
		local frontMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_lm")
		local rearMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_rm")
		if
			frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or
				frontMiddleWindow ~= -1 or
				rearMiddleWindow ~= -1
			then
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			RollUpWindow(vehicle, 4)
			RollUpWindow(vehicle, 5)
		else
			ESX.Alert("This vehicle has no windows.")
		end
	else
		ESX.Alert("You must be the driver of a vehicle to use this.")
	end
end)

-- H O O D --
RegisterNetEvent("hood")
AddEventHandler("hood", function()
	local player = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	local isopen = GetVehicleDoorAngleRatio(vehicle, 4)

		if (isopen == 0) then
			SetVehicleDoorOpen(vehicle, 4, 0, 0)
		else
			SetVehicleDoorShut(vehicle, 4, 0)
		end
end)

RegisterNetEvent("esx_vehiclecontrol:AlarmStete")
AddEventHandler("esx_vehiclecontrol:AlarmStete", function(NetId, state)
	local vehicle = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(vehicle) then
		if state then
			SetVehicleAlarm(vehicle, true)
			SetVehicleAlarmTimeLeft(vehicle, 30000)
		else
			SetVehicleAlarm(vehicle, false)
			SetVehicleAlarmTimeLeft(vehicle, 0)
		end
	end
end)

RegisterNetEvent("esx_vehiclecontrol:HiJack")
AddEventHandler("esx_vehiclecontrol:HiJack", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle == 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
        return
	  end
	  
	HiJackVehicle(vehicle)
end)

--############# END OF VEHICLE ASSETS #################

function DoesHaveAccess(model, table)
	if not table then return false end
	for k,v in pairs(table) do
		if v == model then
			return true
		end
	end
	return false
end
function IsGOV(veh)
	if not veh then return false end
	local model = GetEntityModel(veh)
	for k,v in pairs(authorizedVehicles) do
		for k2 , v2 in pairs(v) do
			if v2 == model then
				return true
			end
		end
	end
	return false
end
function GetVehicles(department)
	return authorizedVehicles[department]
end

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

function Repair(vehicle)
	TriggerServerEvent('esx_vehiclecontol:fixcar', VehToNet(vehicle),GetVehicleEngineHealth(vehicle)<=400,ESX.Game.GetPlayersToSend(400))
end

exports('repair', Repair)

RegisterNetEvent('esx_vehiclecontol:fixcarcl')
AddEventHandler('esx_vehiclecontol:fixcarcl', function(net)
	local vehicle = NetToVeh(net)
	if vehicle ~= 0 then
		ESX.SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleUndriveable(vehicle, false)
		SetVehicleEngineOn(vehicle, true, true)
	end
end)

RegisterNetEvent('esx_vehiclecontol:fixdecor')
AddEventHandler('esx_vehiclecontol:fixdecor', function(net)
	local vehicle = NetToVeh(net)
	if vehicle ~= 0 then
		DecorSetBool(vehicle,"choped",nil)
	end
end)

function Clean(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end

	SetVehicleDirtLevel(vehicle, 0)
end

function HiJack(vehicle)
	SetVehicleDoorsLocked(vehicle, 1)
	local NetId = NetworkGetNetworkIdFromEntity(vehicle)
	TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
end

function ImpoundPolice(vehicle,timee)
	if not impound.busy then
		
		local plate = GetVehicleNumberPlateText(vehicle)
		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "police_impound",
			duration = 15000,
			label = "Dar hale impound kardan mashin",
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

				ClearPedTasksImmediately(GetPlayerPed(-1))
				TriggerServerEvent('esx_advancedgarage:setpdimpound', plate,timee)
				ESX.Game.DeleteVehicle(vehicle) 

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end


function DeleteVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_impound",
			duration = 15000,
			label = "Dar Hale Impound Mashin",
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

				ClearPedTasksImmediately(GetPlayerPed(-1))
				ESX.Game.DeleteVehicle(vehicle) 

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end

function RepairVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		exports.dpemotes:PlayEmote("mechanic")
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_repair",
			duration = 10000,
			label = "Dar hale tamir kardan mashin",
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

				ClearPedTasksImmediately(GetPlayerPed(-1))
				Repair(vehicle)

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end


function RepairVehicle2(vehicle)
	if not impound.busy then
		ESX.UI.Menu.CloseAll()
		ESX.TriggerServerCallback('getengine',function(engine)
			if engine == 0 then
				--[[impound.busy = true
				impound.vehicle = vehicle
				exports.dpemotes:PlayEmote("mechanic")
				TriggerEvent("mythic_progbar:client:progress", {
					name = "mechanic_repair",
					duration = 30000,
					label = "Dar hale tamir kardan engine mashin",
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
						ClearPedTasksImmediately(GetPlayerPed(-1))
						TriggerServerEvent('chop:fix',GetVehicleNumberPlateText(vehicle),VehToNet(vehicle),GetEntityModel(vehicle))
						Repair(vehicle)
		
						impound.busy = false
						impound.vehicle = 0
						
					elseif status then
						ClearPedTasksImmediately(GetPlayerPed(-1))
						impound.busy = false
						impound.vehicle = 0
					end				
				end)]]
				ESX.Alert('In mashin niaz be engine nadare', "info")
			else
				ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
				{
				title 	 = 'Ta\'mir engine',
				align    = 'center',
				question = 'Aya mikhahid engine in mashin ra ta\'amir konid?(Engine X'.. engine ..')',
				elements = {
					{label = 'Bale', value = 'yes'},
					{label = 'Kheir', value = 'no'},
				}
				}, function(data, menu)
					ESX.UI.Menu.CloseAll()
					if data.current.value == 'yes' then						
						local item = 'engine'..engine
						local enginecount = 0
						local PlayerData = ESX.GetPlayerData()
						for i=1, #PlayerData.inventory do
							if PlayerData.inventory[i].name == item then
								enginecount = PlayerData.inventory[i].count
							end
						end
						if enginecount < 1 then
							ESX.Alert('Shoma niaz be yek Engine X'.. engine ..' darid')
						else
							local time = 30000
							time = time + engine * 20000
							impound.busy = true
							impound.vehicle = vehicle
							exports.dpemotes:PlayEmote("mechanic")
							TriggerEvent("mythic_progbar:client:progress", {
								name = "mechanic_repair",
								duration = time,
								label = "Dar hale tamir kardan engine mashin",
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
									ClearPedTasksImmediately(GetPlayerPed(-1))
									TriggerServerEvent('chop:fix',GetVehicleNumberPlateText(vehicle),VehToNet(vehicle),GetEntityModel(vehicle))
									Repair(vehicle)
					
									impound.busy = false
									impound.vehicle = 0
									
								elseif status then
									ClearPedTasksImmediately(GetPlayerPed(-1))
									impound.busy = false
									impound.vehicle = 0
								end				
							end)
						end
					elseif data.current.value == 'no' then
						menu.close()
						ESX.UI.Menu.CloseAll()													
					end
				end)
			end
		end,GetEntityModel(vehicle))	
	end
end

function CleanVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MAID_CLEAN", 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_clean",
			duration = 5000,
			label = "Dar hale tamiz kardan mashin",
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

				ClearPedTasksImmediately(GetPlayerPed(-1))
				Clean(vehicle)

				impound.busy = false
				impound.vehicle = 0
				
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			
		end)

	end
end

function HiJackVehicle(vehicle)
	if not impound.busy then

		if GetVehicleDoorLockStatus(vehicle) == 2 then

			TriggerServerEvent('esx_customItems:remove', 'picklock')
			impound.busy = true
			impound.vehicle = vehicle
			local plate = GetVehicleNumberPlateText(vehicle)
			local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, true)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "vehicle_hijack",
				duration = 30000,
				label = "Dar hale lockpick kardan mashin",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "missheistdockssetup1clipboard@idle_a",
					anim = "idle_a",
				},
			}, function(status)
				
				if not status then

					impound.busy = false
					impound.vehicle = 0

					local number = math.random(1, 3)

					if number % 2 == 0 then
						HiJack(vehicle)
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Mashin ba movafaghiat ^1picklock ^0shod!")
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0PickLock shoma ^1shekast!")
						TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
						Citizen.CreateThread(function()
							Citizen.Wait(5000)
							TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
						end)
					end
					
				elseif status then
					impound.busy = false
					impound.vehicle = 0
					TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
					Citizen.CreateThread(function()
						Citizen.Wait(5000)
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					end)
				end
				
			end)

		else
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Dare mashin mored nazar ghofl nist!")
		end
		
	end
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(10)
	
	  if impound.busy and impound.vehicle ~= 0 then
		 
		local coords = GetEntityCoords(GetPlayerPed(-1))

		if not DoesEntityExist(impound.vehicle) then
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

		local vcoords = GetEntityCoords(impound.vehicle)
		local distance = GetDistanceBetweenCoords(coords, vcoords, false)

		if IsAnyPedInVehicle(impound.vehicle) then
			ESX.Alert("~h~Shakhsi vared mashin shod!")
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

		if distance > 4 then
			ESX.Alert("Mashin mored nazar az shoma ~r~door ~s~shod!")
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end	  

	  end

	end
end)

--[[Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/engine', 'On / Off Kardan Engine', {})
		while true do
			Citizen.Wait(0)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			
			if (IsControlJustReleased(0, 178) or IsDisabledControlJustReleased(0, 178)) and vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
				toggleEngine()
			end
			
		end
end)]]

function toggleEngine()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		if owner or DoesHaveAccess(GetEntityModel(vehicle), authorizedVehicles[PlayerData.job.name]) then
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
		end
	end
end
RegisterNetEvent('toggleengine')
AddEventHandler('toggleengine',toggleEngine)
	
local lastveh = 0
local limit = {
	[1] = 16.88,
	[2] = 8.46,
	[3] = 3.05,
	[4] = 1.52,
}
local threadoff = false
local draw =  true
local hotwire = {}
--[[Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		if vehicle ~= 0 and vehicle ~= lastveh and realworld then
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				lastveh = vehicle
				SetVehicleEngineOn(vehicle,false,true,true)
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
				SetVehicleEngineOn(vehicle,true,false,true)
				Citizen.CreateThread(function()
					while GetVehiclePedIsIn(ped, false) == vehicle do
						Wait(100)
						local count = 0
						if IsVehicleTyreBurst(vehicle, 0, false) then
							count = count + 1
						end
						--Right Front
						if IsVehicleTyreBurst(vehicle, 1, false)  then
							count = count + 1
						end
						--Left Rear
						if IsVehicleTyreBurst(vehicle, 4, false) then
							count = count + 1
						end
						--Right Rear
						if IsVehicleTyreBurst(vehicle, 5, false) then
							count = count + 1
						end
						local choped = DecorGetBool(vehicle,"choped")
						if choped and count < 2 then 
							SetEntityMaxSpeed(vehicle,12.26)
						end
						if limit[count] then
							if (not choped or count >= 2) then
								SetEntityMaxSpeed(vehicle,limit[count])
							end
						end
					end
				end)
			end
		elseif vehicle == 0 then
			lastveh = 0
		end
	end
end)]]

local ownedLicenses = {}

RegisterNetEvent("xex_pilotschool:loadLicenses")
AddEventHandler("xex_pilotschool:loadLicenses", function(Licenses)
	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end
	if ownedLicenses['pmv'] then
		if ownedLicenses['aircraft'] then
			canDrivePlane = true
		end
		if ownedLicenses['helicopter'] then
			canDriveHeli = true
		end
	end
end)

exports("getLicense", function()
	return ownedLicenses
end)

exports("exception", function()
	disable = true
	Citizen.SetTimeout(3000, function()
		disable = false
	end)
end)

function inVehThread()
	Citizen.CreateThread(function()
		while inVeh do
			Citizen.Wait(400)
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local class = GetVehicleClass(vehicle)
			local counter = 0
			if vehicle ~= 0 and vehicle ~= lastveh then
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					SetVehicleEngineOn(vehicle,false,true,true)
					lastveh = vehicle
					local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
					--local maxoffSpeed = exports['sunset_utils']:getMaxSpeedInOffroad(GetEntityModel(vehicle))
					ESX.TriggerServerCallback('esx_advancedgarage:DoesHaveKey', function(owner, bega, chopped)
						local chopped = chopped
						if owner or bega or ESX.GetPlayerData().admin == 1 or not NetworkGetEntityIsNetworked(vehicle) then
							--maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
							--SetEntityMaxSpeed(vehicle, maxSpeed)
							--print(class, canDriveHeli)
							if (class == 15) and not canDriveHeli then
								inVeh = false
								ESX.Alert("Shoma Govahiname Helicopter Nadarid", "info")
								Citizen.CreateThread(function()
									while GetVehiclePedIsIn(ped, false) == vehicle do
										Citizen.Wait(25)
										SetVehicleEngineOn(vehicle,false,true,true)
									end
								end)
								return
							end
							if (class == 16) and not canDrivePlane then
								inVeh = false
								ESX.Alert("Shoma Govahiname Havapeyma Nadarid", "info")
								Citizen.CreateThread(function()
									while GetVehiclePedIsIn(ped, false) == vehicle do
										Citizen.Wait(250)
										SetVehicleEngineOn(vehicle,false,true,true)
									end
								end)
								return
							end
							SetVehicleEngineOn(vehicle,true,false,true)
							if chopped then
								Citizen.CreateThread(function()
									while GetVehiclePedIsIn(ped, false) == vehicle and counter <= 130 do
										if counter == 0 or counter == 45 or counter == 90 or counter == 120 then
											ESX.Alert("In Mashin Engine Nadarad", "info")
										end
										Citizen.Wait(1000)
										counter = counter + 1
									end
								end)
							end
							Citizen.CreateThread(function()
								while GetVehiclePedIsIn(ped, false) == vehicle do
									Citizen.Wait(150)
									local count = 0
									if IsVehicleTyreBurst(vehicle, 0, false) then
										count = count + 1
									end
									--Right Front
									if IsVehicleTyreBurst(vehicle, 1, false)  then
										count = count + 1
									end
									--Left Rear
									if IsVehicleTyreBurst(vehicle, 4, false) then
										count = count + 1
									end
									--Right Rear
									if IsVehicleTyreBurst(vehicle, 5, false) then
										count = count + 1
									end
									--local choped = DecorGetBool(vehicle,"choped")
									--local InStreet = exports['sunset_utils']:getVar('InStreet')
									if chopped then
										SetEntityMaxSpeed(vehicle,8.26)
									elseif limit[count] then
										if (count >= 2) then
											--if limit[count] * 3.6 < maxoffSpeed or InStreet then
												SetEntityMaxSpeed(vehicle,limit[count])
											--end
										end
									end
								end
							end)
						else
							threadoff = true
							draw =  true
							Citizen.CreateThread(function()
								while threadoff and GetVehiclePedIsIn(ped, false) == vehicle do
									Wait(1)
									SetVehicleEngineOn(vehicle,false,true,true)
									local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
									local vehpos = GetOffsetFromEntityInWorldCoords(veh, 0.0, 2.0, 1.0)
									if draw then
										ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z),"[H] Hotwire",2)
										if IsControlJustPressed(0, Keys["H"]) then								
											ESX.TriggerServerCallback('userpich',function(cb)
												if cb then
													draw = false
													Citizen.CreateThread(Hotwire)		
												end
											end)							
										end
									end
								end
							end)
						end
					end,plate, true)
				end
			elseif vehicle == 0 then
				lastveh = 0
			end
		end
		lastveh = 0
	end)
end

AddEventHandler('enterVehicle',function(vehicle,isDriver)
	if disable then return end
	inVeh = true
	inVehThread()
end)

AddEventHandler('exitVehicle',function()
	lastveh = 0
	inVeh = false
end)

function Hotwire()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	if vehicle ~= nil and vehicle ~= 0 then
		if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
			IsHotwiring = true

			local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
			local anim = "machinic_loop_mechandplayer"
			TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,1.0, 4.0, -1, 49, 0, false, false, false)

			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				RequestAnimDict(dict)
				Citizen.Wait(100)
			end

			if taskBar(3000,math.random(10,20)) ~= 100 then             
				StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
				SetVehicleEngineOn(vehicle, false, false, true)
				TriggerServerEvent("esx:removeLockpick")
				ESX.Alert('Pich goushti shekast!', "info")
				draw = true
				IsHotwiring = false
				return
			end

			if taskBar(2500,math.random(10,20)) ~= 100 then
				StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
				SetVehicleEngineOn(vehicle, false, false, true)
				ESX.Alert('Pich goushti shekast!', "info")
				TriggerServerEvent("esx:removeLockpick")
				draw = true
				IsHotwiring = false
				return
			end

			if taskBar(2000,math.random(5,15)) ~= 100 then
				StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
				HasKey = false
				SetVehicleEngineOn(vehicle, false, false, true)
				ESX.Alert('Pich goushti shekast!', "info")
				TriggerServerEvent("esx:removeLockpick")
				draw = true
				return
			end 
			StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
			IsHotwiring = false	
			threadoff = false
			ESX.Alert('Mashin roushan shod!', "check")
			hotwire[vehicle] = true
			Wait(2000)
			SetVehicleEngineOn(vehicle,true,false,true)
			TriggerServerEvent("esx:AddWiredVehicle", ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
			lastveh = 0
			inVeh = false
			Citizen.Wait(2000)
			inVeh = true
			inVehThread()
		end
	end
end


exports("GetVehicles", GetVehicles)
exports("EngineHandler", EngineHandler)
exports("ImpoundPolice", ImpoundPolice)
exports("DeleteVehicle", DeleteVehicle)
exports("RepairVehicle", RepairVehicle)
exports("RepairVehicle2", RepairVehicle2)
exports("CleanVehicle", CleanVehicle)
exports("IsGOV", IsGOV)
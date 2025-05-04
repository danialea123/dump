local inJob = false
local Status = {
	DELIVERY_INACTIVE                 = 0,
	PLAYER_STARTED_JOB 				  = 1,
	PLAYER_STARTED_DELIVERY           = 2,
	PLAYER_REACHED_VEHICLE_POINT      = 3,
	PLAYER_REMOVED_GOODS_FROM_VEHICLE = 4,
	PLAYER_REACHED_DELIVERY_POINT     = 5,
	PLAYER_RETURNING_TO_BASE          = 6
}

local CurrentStatus             = Status.DELIVERY_INACTIVE
local CurrentSubtitle           = nil
local CurrentBlip               = nil
local CurrentType               = nil
local CurrentVehicle            = nil
local CurrentAttachments        = {}
local CurrentVehicleAttachments = {}
local DeliveryLocation          = {}
local DeliveryComplete          = {}
local DeliveryRoutes            = {}
local FinishedJobs              = 0
local SpawnJobVehicleTimeout    = 0
local SoundEffects = {
	["info"]    = {'CHALLENGE_UNLOCKED', 'HUD_AWARDS'},
	["success"] = {'BASE_JUMP_PASSED', 'HUD_AWARDS'},
	["warning"] = {'CHECKPOINT_MISSED', 'HUD_AWARDS'},
	["error"]   = {'Bed', 'WastedSounds'},
}

RegisterNetEvent('MpGameMessage:send')
AddEventHandler('MpGameMessage:send', function(message, subtitle, ms, sound, top)

	if ms == nil then
		ms = 3500
	end
	
	if sound == nil then
		sound = 'info'
	end
	
	if top == true then
		MethodName = "SHOW_PLANE_MESSAGE"
	else
		MethodName = "SHOW_SHARD_WASTED_MP_MESSAGE"
	end
	
	Citizen.CreateThread(function()
		
		local scaleform = RequestScaleformMovie("mp_big_message_freemode")
		
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		
		if sound ~= false then
			PlaySoundFrontend(-1, SoundEffects[sound][1], SoundEffects[sound][2], true)
		end
		
		BeginScaleformMovieMethod(scaleform, MethodName)
		PushScaleformMovieMethodParameterString(message)
		PushScaleformMovieMethodParameterString(subtitle)
		PushScaleformMovieMethodParameterInt(0)
		EndScaleformMovieMethod()

		local time = GetGameTimer() + ms
        
        while(GetGameTimer() < time) do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
		
		SetScaleformMovieAsNoLongerNeeded(scaleform)
	end)
	
end)

RegisterNetEvent('MpGameMessage:warning')
AddEventHandler('MpGameMessage:warning', function(message, subtitle, bottom, ms, sound)

	if ms == nil then
		ms = 3500
	end
	
	if sound == nil then
		sound = 'info'
	end
	
	Citizen.CreateThread(function()
		
		local scaleform = RequestScaleformMovie("POPUP_WARNING")
		
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		
		if sound ~= false then
			PlaySoundFrontend(-1, SoundEffects[sound][1], SoundEffects[sound][2], true)
		end
		
		BeginScaleformMovieMethod(scaleform, "SHOW_POPUP_WARNING")
		PushScaleformMovieMethodParameterFloat(500.0)
		PushScaleformMovieMethodParameterString(message)
		PushScaleformMovieMethodParameterString(subtitle)
		PushScaleformMovieMethodParameterString(bottom)
		PushScaleformMovieMethodParameterBool(true)
		EndScaleformMovieMethod()

		local time = GetGameTimer() + ms
        
        while(GetGameTimer() < time) do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
		
		SetScaleformMovieAsNoLongerNeeded(scaleform)
	end)
	
end)

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local timeout_active = false 

function LeaveMissionTimeout() 
	Citizen.CreateThread(function()

		if timeout_active then 
			return
		end
		timeout_active = true

		local firstWait = GetGameTimer() + 5000 -- Wait 5sec max before printing message to go back in vehicle

		while firstWait > GetGameTimer() do
			Citizen.Wait(500)
			if IsPlayerInsideDeliveryVehicle() then 
				break 
			end
		end
		
		local waitUntil = GetGameTimer() + ConfigDelivery.LeaveVehEndTime
		local leaveTimer = ConfigDelivery.LeaveVehEndTime/1000

		while not IsPlayerInsideDeliveryVehicle() and waitUntil > GetGameTimer() and CurrentStatus ~= Status.PLAYER_REACHED_VEHICLE_POINT do
			CurrentSubtitle = _U("get_back_in_vehicle", math.floor(leaveTimer))
			Citizen.Wait(1000)
			leaveTimer = leaveTimer - 1
		end

		timeout_active = false

		if not IsPlayerInsideDeliveryVehicle() then
			CurrentStatus = Status.DELIVERY_INACTIVE
			LoadDefaultPlayerSkin()
			RemoveBlip(CurrentBlip)
			RemovePlayerProps()
			FinishDelivery(CurrentType, false)
			ESX.ShowNotification(_U("safe_deposit_withheld"))
			CurrentSubtitle = nil
			return
		else 
			ESX.ShowNotification(_U("got_back_in_vehicle") .. FinishedJobs .. "/" .. #DeliveryRoutes)
			CurrentSubtitle = nil
		end	

	end)
end

-- Load the default player skin (for esx_skin)

function LoadDefaultPlayerSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

-- Control the input
local disableX = false
function HandleInput()
	if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
		DisableControlAction(0,21,true)
		DisableControlAction(0,22,true)
		DisableControlAction(0,23,true)
		if not disableX then
			disableX = true
			TriggerEvent("dpclothingAbuse", true)
			--TriggerEvent("dpemote:enable", false)
			exports.essentialmode:DisableControl(true)
		end
	else
		if disableX then
			disableX = false
			TriggerEvent("dpclothingAbuse", false)
			--TriggerEvent("dpemote:enable", true)
			exports.essentialmode:DisableControl(false)
		end
		Citizen.Wait(500)
	end
end

-- Main logic handler

function HandleLogic()

	local playerPed = PlayerPedId()
	local pCoords   = GetEntityCoords(playerPed)
	
	if CurrentStatus ~= Status.DELIVERY_INACTIVE then
		-- if IsPedDeadOrDying(playerPed, true) then
		-- 	FinishDelivery(CurrentType, false)
		-- 	return
		-- elseif GetVehicleEngineHealth(CurrentVehicle) < 20 and CurrentVehicle ~= nil then
		-- 	FinishDelivery(CurrentType, false)
		-- 	return
		-- end

		if CurrentStatus == Status.PLAYER_STARTED_JOB then
			if not IsPlayerInsideDeliveryVehicle() then
				CurrentSubtitle = _U("go_in_vehicle")
			else
				CurrentSubtitle = nil
				CurrentStatus = Status.PLAYER_STARTED_DELIVERY
			end
		end

	
		if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then

			if not IsPlayerInsideDeliveryVehicle() then
				--LeaveMissionTimeout() 
			else
				CurrentSubtitle = nil
			end
			
			if #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z)) < 2.0 then
				CurrentStatus = Status.PLAYER_REACHED_VEHICLE_POINT
				CurrentSubtitle = _U("remove_goods_subtext")
				PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
			end
		end
		
		if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
			if CurrentType == 'van' or CurrentType == 'truck' then
				CurrentSubtitle = _U("deliver_inside_shop")
				if CurrentType == 'van' and not IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "walk", 3) then
					ForceCarryAnimation();
				end
			end
			
			if #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(DeliveryLocation.Item2.x, DeliveryLocation.Item2.y, DeliveryLocation.Item2.z)) < 1.5 then
				
				PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				FinishedJobs = FinishedJobs + 1
				ESX.ShowNotification(_U("finish_job") .. FinishedJobs .. "/" .. #DeliveryRoutes)
				if FinishedJobs >= #DeliveryRoutes then
					TriggerServerEvent("esx_delivery:finishDelivery", CurrentType)
					RemovePlayerProps()
					RemoveBlip(CurrentBlip)
					DeliveryLocation.Item1 = ConfigDelivery.Base.retveh
					DeliveryLocation.Item2 = {x = 0, y = 0, z = 0}
					CurrentBlip            = CreateBlipAt(DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z)
					CurrentSubtitle        = _U("get_back_to_deliveryhub")
					CurrentStatus          = Status.PLAYER_RETURNING_TO_BASE
					return
				else
					RemovePlayerProps()
					GetNextDeliveryPoint(false)
					CurrentStatus = Status.PLAYER_STARTED_DELIVERY
					CurrentSubtitle = _U("drive_next_point")
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				end
			end
		end
		Citizen.Wait(100)
	else
		Citizen.Wait(1000)
	end
end

-- Handling markers and object status

function HandleMarkers()
	local pCoords = GetEntityCoords(PlayerPedId())
	local deleter = ConfigDelivery.Base.deleter
	if DoesEntityExist(GetVehiclePedIsIn(PlayerPedId())) then
		DrawMarker(20, deleter.x, deleter.y, deleter.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 249, 38, 114, 150, true, true)
		if ESX.GetDistance(pCoords,deleter) < 1.5 then
			DisplayHelpText(_U("end_delivery"))
			if IsControlJustReleased(0, 51) then
				EndDelivery()
				return
			end
		end
	end
	if CurrentStatus ~= Status.DELIVERY_INACTIVE then
		if CurrentStatus == Status.PLAYER_STARTED_DELIVERY or CurrentStatus == Status.PLAYER_STARTED_JOB then
			if not IsPlayerInsideDeliveryVehicle() and CurrentVehicle ~= nil then
				local VehiclePos = GetEntityCoords(CurrentVehicle)
				local ArrowHeight = VehiclePos.z
				ArrowHeight = VehiclePos.z + 1.0
				
				if CurrentType == 'van' then
					ArrowHeight = ArrowHeight + 1.0
				elseif CurrentType == 'truck' then
					ArrowHeight = ArrowHeight + 2.0
				end
				
				DrawMarker(20, VehiclePos.x, VehiclePos.y, ArrowHeight, 0, 0, 0, 0, 180.0, 0, 0.8, 0.8, 0.8, 0, 217, 0, 150, true, true)
			else
				local dl = DeliveryLocation.Item1
				if #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(dl.x, dl.y, dl.z)) < 150 then
					DrawMarker(20, dl.x, dl.y, dl.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
				end
			end
		end
		
		if CurrentStatus == Status.PLAYER_REACHED_VEHICLE_POINT then
			if not IsPlayerInsideDeliveryVehicle() then

				if not IsPlayerInsideDeliveryVehicle() then
					--LeaveMissionTimeout() 
				else
					CurrentSubtitle = nil
				end

				TrunkPos = GetEntityCoords(CurrentVehicle)
				TrunkForward = GetEntityForwardVector(CurrentVehicle)
				local ScaleFactor = 1.0
				
				for k, v in pairs(ConfigDelivery.Scales) do
					if k == CurrentType then
						ScaleFactor = v
					end
				end
				
				TrunkPos = TrunkPos - (TrunkForward * ScaleFactor)
				TrunkHeight = TrunkPos.z
				TrunkHeight = TrunkPos.z + 0.7
				
				local ArrowSize = {x = 0.8, y = 0.8, z = 0.8}
				
				if CurrentType == 'scooter' then
					ArrowSize = {x = 0.15, y = 0.15, z = 0.15}
				end
				
				DrawMarker(20, TrunkPos.x, TrunkPos.y, TrunkHeight, 0, 0, 0, 180.0, 0, 0, ArrowSize.x, ArrowSize.y, ArrowSize.z, 102, 217, 239, 150, true, true)
				
				if #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(TrunkPos.x, TrunkPos.y, TrunkHeight)) < 1.0 then
					DisplayHelpText(_U("remove_goods"))
					if IsControlJustReleased(0, 51) then
						PlayTrunkAnimation()
						GetPlayerPropsForDelivery(CurrentType)
						CurrentStatus = Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE
					end
				end
			end
		end
		
		if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
			local dp = DeliveryLocation.Item2
			DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
		end
		
		if CurrentStatus == Status.PLAYER_RETURNING_TO_BASE then
			local dp = ConfigDelivery.Base.deleter
			DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
		end
	else
		local bCoords = ConfigDelivery.Base.coords
		if #(vector3(pCoords.x, pCoords.y, pCoords.z) -  vector3(bCoords.x, bCoords.y, bCoords.z)) < 20.0 then
			local ScooterPos = ConfigDelivery.Base.scooter
			local VanPos     = ConfigDelivery.Base.van
			local TruckPos   = ConfigDelivery.Base.truck
			
			DrawMarker(37, ScooterPos.x, ScooterPos.y, ScooterPos.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 96, 183, 56, 150, true, true)
			DrawMarker(36, VanPos.x, VanPos.y, VanPos.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 250, 170, 60, 150, true, true)
			DrawMarker(39, TruckPos.x, TruckPos.y, TruckPos.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 230, 219, 91, 150, true, true)
			
			local SelectType = false
			
			if #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(ScooterPos.x, ScooterPos.y, ScooterPos.z)) < 1.5 then
				DisplayHelpText(_U("start_delivery"))
				SelectType = 'scooter'
			elseif #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(VanPos.x, VanPos.y, VanPos.z)) < 1.5 then
				DisplayHelpText(_U("start_delivery"))
				SelectType = 'van'
			elseif #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(TruckPos.x, TruckPos.y, TruckPos.z)) < 1.5 then
				DisplayHelpText(_U("start_delivery"))
				SelectType = 'truck'
			else
				SelectType = false
			end

			if SelectType ~= false then
				if IsControlJustReleased(0, 51) then
					if ESX.getVehicleFromPlate('DE' .. ESX.GetPlayerData().rawid) then
						ESX.ShowNotification('Shoma ghablan yek mashin gereftid')
						return
					end
					SpawnJobVehicleTimeout = GetGameTimer() + 30000
					
					StartDelivery(SelectType)
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				end
			end
		end
	end
end

-- The trunk animation when the player remove the goods from the vehicle
function PlayTrunkAnimation()
	Citizen.CreateThread(function()
		if CurrentType == 'truck' then
			if ConfigDelivery.Models.vehDoor.usingTrunkForTruck then
				setVehicleDoorState(CurrentVehicle, 5, true)
			else
				setVehicleDoorState(CurrentVehicle, 2, true)
				setVehicleDoorState(CurrentVehicle, 3, true)
			end
		elseif CurrentType == 'van' then
			if ConfigDelivery.Models.vehDoor.usingTrunkForVan then
				setVehicleDoorState(CurrentVehicle, 5, true)
			else
				setVehicleDoorState(CurrentVehicle, 2, true)
				setVehicleDoorState(CurrentVehicle, 3, true)
			end
		end
		Citizen.Wait(1000)
		if CurrentType == 'truck' then
			if ConfigDelivery.Models.vehDoor.usingTrunkForTruck then
				setVehicleDoorState(CurrentVehicle, 5, false)
			else
				setVehicleDoorState(CurrentVehicle, 2, false)
				setVehicleDoorState(CurrentVehicle, 3, false)
			end
		elseif CurrentType == 'van' then
			if ConfigDelivery.Models.vehDoor.usingTrunkForVan then
				setVehicleDoorState(CurrentVehicle, 5, false)
			else
				setVehicleDoorState(CurrentVehicle, 2, false)
				setVehicleDoorState(CurrentVehicle, 3, false)
			end
		end
	end)
end

function setVehicleDoorState(vehicle, index, open)
	if DoesEntityExist(vehicle) then
		if NetworkHasControlOfEntity(vehicle) then
			if open then
				SetVehicleDoorOpen(vehicle, index)
			else
				SetVehicleDoorShut(vehicle, index)
			end
		else
			local netId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent('sunset_utils:setVehicleDoorState', netId, index, open,ESX.GetPlayersToSend(300))
		end
	end
end

-- Create a blip for the location

function CreateBlipAt(x, y, z)
	
	local tmpBlip = AddBlipForCoord(x, y, z)
	
	SetBlipSprite(tmpBlip, 1)
	SetBlipColour(tmpBlip, 66)
	SetBlipAsShortRange(tmpBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U("dst_blip"))
	EndTextCommandSetBlipName(blip)
	SetBlipAsMissionCreatorBlip(tmpBlip, true)
	SetBlipRoute(tmpBlip, true)
	
	return tmpBlip
end

-- Let the player carry something

function ForceCarryAnimation()
	TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
end

-- Tell the server start delivery job

function StartDelivery(deliveryType)
	local spawnPoint = ESX.GetAvailableVehicleSpawnPoint(ConfigDelivery.SpawnPoints)
	if spawnPoint then
		--TriggerServerEvent('esx_jobs:cautionss2','take')
		TriggerEvent("MpGameMessage:send", _U("delivery_start"), _U("delivery_tips"), 3500, 'success')
		--LoadWorkPlayerSkin(deliveryType)
		local ModelHash = GetHashKey("prop_paper_bag_01")
		ESX.Streaming.RequestModel(ModelHash)
		SpawnDeliveryVehicle(deliveryType)
		CreateRoute(deliveryType)
		GetNextDeliveryPoint(true)
		CurrentType   = deliveryType
		CurrentStatus = Status.PLAYER_STARTED_JOB
	end
end

-- Check is the player in the delivery vehicle

function IsPlayerInsideDeliveryVehicle()
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if playerVehicle == CurrentVehicle then
			return true
		end
	end
	return false
end

-- Is this checkpoint the last checkpoint?

function IsLastDelivery()
	local isLast = false
	local dp1    = DeliveryLocation.Item2
	local dp2    = DeliveryRoutes[#DeliveryRoutes].Item2
	if dp1.x == dp2.x and dp1.y == dp2.y and dp1.z == dp2.z then
		isLast = true
	end
	return isLast
end

-- Remove all object from the player ped

function RemovePlayerProps()
	for i = 0, #CurrentAttachments do
		DetachEntity(CurrentAttachments[i])
		ESX.Game.DeleteObject(CurrentAttachments[i])
	end
	ClearPedTasks(PlayerPedId())
	CurrentAttachments = {}
end

-- Spawn an object and attach it to the player

function GetPlayerPropsForDelivery(deliveryType)
	
	RequestAnimDict("anim@heists@box_carry@")
	while not HasAnimDictLoaded("anim@heists@box_carry@") do
		Citizen.Wait(0)
	end

	if deliveryType == 'scooter' then
		local ModelHash = GetHashKey("prop_paper_bag_01")
		local PlayerPed = PlayerPedId()
		local PlayerPos = GetEntityCoords(PlayerPed)

		ESX.Streaming.RequestModel(ModelHash)
		local Object = nil
		ESX.Game.SpawnLocalObject(ModelHash,GetEntityCoords(PlayerPedId()),function(obj)
			Object = obj
		end)
		while Object == nil do Citizen.Wait(10) end
		AttachEntityToEntity(Object, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.25, 0.0, 0.06, 65.0, -130.0, -65.0, true, true, false, true, 0, true)
		table.insert(CurrentAttachments, Object)

	end
	
	if deliveryType == 'van' then
		TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
		
		local Rand      = math.random(1, #ConfigDelivery.VanGoodsPropNames)
		local ModelHash = ConfigDelivery.VanGoodsPropNames[Rand]
		
		ESX.Streaming.RequestModel(ModelHash)
		
		local PlayerPed = PlayerPedId()
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		local Object = nil
		ESX.Game.SpawnLocalObject(ModelHash,vector3(PlayerPos.x,PlayerPos.y,PlayerPos.z),function(obj)
			Object = obj
		end)
		while Object == nil do Citizen.Wait(10) end
		AttachEntityToEntity(Object, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, 0.0, -0.55, 0.0, 0.0, 90.0, true, false, false, true, 1, true)
		table.insert(CurrentAttachments, Object)
	end
	
	if deliveryType == 'truck' then
		TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
		
		local ModelHash = GetHashKey("prop_sacktruck_02b")
		
		ESX.Streaming.RequestModel(ModelHash)
		
		local PlayerPed = PlayerPedId()
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		local Object = nil
		ESX.Game.SpawnLocalObject(ModelHash,vector3(PlayerPos.x,PlayerPos.y,PlayerPos.z),function(obj)
			Object = obj
		end)
		while Object == nil do Citizen.Wait(10) end
		AttachEntityToEntity(Object, PlayerPed, GetEntityBoneIndexByName(PlayerPed, "SKEL_Pelvis"), -0.075, 0.90, -0.86, -20.0, -0.5, 181.0, true, false, false, true, 1, true)
		table.insert(CurrentAttachments, Object)
	end
	
	local JobData = (FinishedJobs + 1) / #DeliveryRoutes
	
	if JobData >= 0.5 and #CurrentVehicleAttachments > 2 then
		DetachEntity(CurrentVehicleAttachments[1])
		ESX.Game.DeleteObject(CurrentVehicleAttachments[1])
		table.remove(CurrentVehicleAttachments, 1)
	end
	if JobData >= 1.0 and #CurrentVehicleAttachments > 1 then
		DetachEntity(CurrentVehicleAttachments[1])
		ESX.Game.DeleteObject(CurrentVehicleAttachments[1])
		table.remove(CurrentVehicleAttachments, 1)
	end
end

-- Spawn the scooter, truck or van

function SpawnDeliveryVehicle(deliveryType)
	SetBlipRoute(blip,  false)
	local spawnPoint = ESX.GetAvailableVehicleSpawnPoint(ConfigDelivery.SpawnPoints)
	if spawnPoint then
		ESX.Game.SpawnVehicle(ConfigDelivery.Models[deliveryType], spawnPoint.coords, spawnPoint.heading, function(vehicle)
			CurrentVehicle = vehicle
			TaskWarpPedIntoVehicle(PlayerPedId(), CurrentVehicle, -1)
			local plate = 'DE' .. ESX.GetPlayerData().rawid
			SetVehicleNumberPlateText(CurrentVehicle, plate)
			ESX.CreateVehicleKey(vehicle)
			--ESX.giveCarKey(CurrentVehicle)
		end)
	end
	
	SetVehicleOnGroundProperly(CurrentVehicle)
	
end

-- Get the next destination

function GetNextDeliveryPoint(firstTime)
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end
	
	for i = 1, #DeliveryComplete do
		if not DeliveryComplete[i] then
			if not firstTime then
				DeliveryComplete[i] = true
				break
			end
		end
	end
	
	for i = 1, #DeliveryComplete do
		if not DeliveryComplete[i] then
			CurrentBlip = CreateBlipAt(DeliveryRoutes[i].Item1.x, DeliveryRoutes[i].Item1.y, DeliveryRoutes[i].Item1.z)
			DeliveryLocation = DeliveryRoutes[i]
			break
		end
	end
end

-- Create some random destinations

function CreateRoute(deliveryType)
	
	-- local TotalDeliveries = math.random(ConfigDelivery.Deliveries.min, ConfigDelivery.Deliveries.max)
	local TotalDeliveries = 7
	local DeliveryPoints = {}

	if deliveryType == 'scooter' then
		DeliveryPoints = ConfigDelivery.DeliveryLocationsScooter
	elseif deliveryType == 'van' then
		DeliveryPoints = ConfigDelivery.DeliveryLocationsVan
	else
		DeliveryPoints = ConfigDelivery.DeliveryLocationsTruck
	end
	
	while #DeliveryRoutes < TotalDeliveries do
		::fuck::
		local NextPoint = DeliveryPoints[math.random(1, #DeliveryPoints)]
		if ESX.GetDistance(NextPoint.Item1,vector3(168.13, -1470.07, 29.37)) < 100 then
			goto fuck
			Wait(1)
		end
		local HasPlayerAround = false
		
		for i = 1, #DeliveryRoutes do
			local Distance = #(vector3(NextPoint.Item1.x, NextPoint.Item1.y, NextPoint.Item1.z) - vector3(DeliveryRoutes[i].Item1.x, DeliveryRoutes[i].Item1.y, DeliveryRoutes[i].Item1.z))
			if Distance < 50.0 then
				HasPlayerAround = true
			end
		end
		
		if not HasPlayerAround then
			table.insert(DeliveryRoutes, NextPoint)
			table.insert(DeliveryComplete, false)
		end
	end
end

-- Create a blip to tell the player back to the delivery hub

function ReturnToBase(deliveryType)
	CurrentBlip = CreateBlipAt(ConfigDelivery.Base.retveh.x, ConfigDelivery.Base.retveh.y, ConfigDelivery.Base.retveh.z)
end

-- End Delivery, is the player finish or failed?

function EndDelivery()
	local PlayerPed = PlayerPedId()
	if not IsPedSittingInAnyVehicle(PlayerPed) or ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))) ~= ESX.Math.Trim('DE' .. ESX.GetPlayerData().rawid) then
		TriggerEvent("MpGameMessage:send", _U("delivery_end"), _U("delivery_failed"), 3500, 'error')
		FinishDelivery(CurrentType, false)
	else
		TriggerEvent("MpGameMessage:send", _U("delivery_end"), _U("delivery_finish"), 3500, 'success')
		ReturnVehicle(CurrentType)
	end
end

-- Return the vehicle to system

function ReturnVehicle(deliveryType)
	ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
	ESX.ShowNotification(_U("delivery_vehicle_returned"))
	FinishDelivery(deliveryType, true)
end

-- When the delivery mission finish

function FinishDelivery(deliveryType, safeReturn)
	if CurrentVehicle ~= nil or DoesEntityExist(GetVehiclePedIsIn(PlayerPedId())) then
		for i = 0, #CurrentVehicleAttachments do
			DetachEntity(CurrentVehicleAttachments[i])
			ESX.Game.DeleteObject(CurrentVehicleAttachments[i])
		end
		CurrentVehicleAttachments = {}
		if DoesEntityExist(GetVehiclePedIsIn(PlayerPedId())) then
			ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
		end
	end
	
	CurrentStatus    = Status.DELIVERY_INACTIVE
	CurrentVehicle   = nil
	CurrentSubtitle  = nil
	FinishedJobs     = 0
	DeliveryRoutes   = {}
	DeliveryComplete = {}
	DeliveryLocation = {}
	
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end
	
	CurrentBlip = nil
	CurrentType = ''
	if safeReturn then
		--TriggerServerEvent('esx_jobs:cautions','give_back')
	end
	
	--LoadDefaultPlayerSkin()
end

-- Some helpful functions

function DisplayHelpText(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Draw2DTextCenter(x, y, text, scale)
    SetTextFont(0)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
	SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Initialize ESX


-- Make player look like a worker

-- function LoadWorkPlayerSkin(deliveryType)
	
-- 	local playerPed = PlayerPedId()
	
-- 	TriggerEvent('skinchanger:getSkin', function(skin)
-- 		if skin.sex == 0 then
-- 			for k, v in pairs(ConfigDelivery.OutfitScooter) do
-- 				SetPedComponentVariation(playerPed, k, v.drawables, v.texture, 1)
-- 			end
-- 		else
-- 			for k, v in pairs(ConfigDelivery.OutfitScooterF) do
-- 				SetPedComponentVariation(playerPed, k, v.drawables, v.texture, 1)
-- 			end
-- 		end
-- 	end)

-- end

-- Main thread

--[[Citizen.CreateThread(function()
	blip = AddBlipForCoord(ConfigDelivery.Base.coords.x, ConfigDelivery.Base.coords.y, ConfigDelivery.Base.coords.z)
	SetBlipSprite(blip, 587)
	SetBlipColour(blip, 2)
	SetBlipScale(blip, 1.0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)]]

local blip

RegisterNetEvent('esx_jobs:ActivateJobForOrgans')
AddEventHandler('esx_jobs:ActivateJobForOrgans', function(name)
	local name = name
	Citizen.Wait(math.random(1000, 10000))
    if name == 'delivery' and not inJob then
		inJob = true
		mainThread()
		--SetBlipRoute(blip,  true)
        --SetBlipAsMissionCreatorBlip(blip, true)
        --SetBlipRouteColour(blip, 3)
		blip = AddBlipForCoord(ConfigDelivery.Base.coords.x, ConfigDelivery.Base.coords.y, ConfigDelivery.Base.coords.z)
		SetBlipSprite(blip, 587)
		SetBlipColour(blip, 2)
		SetBlipScale(blip, 0.6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('blip_name'))
		EndTextCommandSetBlipName(blip)
	elseif name ~= 'delivery' and inJob then
		inJob = false
		if CurrentVehicle then
			ESX.Game.DeleteVehicle(CurrentVehicle)
			CurrentVehicle = nil
		end
		RemoveBlip(blip)
		--SetBlipRoute(blip,  false)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    if xPlayer.job.name == 'delivery' and not inJob then
        inJob = true
        mainThread()
		--SetBlipRoute(blip,  true)
        SetBlipAsMissionCreatorBlip(blip, true)
       -- SetBlipRouteColour(blip, 3)
    end
end)

function mainThread()
	Citizen.CreateThread(function()
		while inJob do
			Citizen.Wait(0)
			HandleInput()
		end
	end)
	Citizen.CreateThread(function()
		while inJob do
			Citizen.Wait(0)
			HandleLogic()
		end
	end)
	Citizen.CreateThread(function()
		while inJob do
			Citizen.Wait(0)
			HandleMarkers()
		end
	end)
	Citizen.CreateThread(function()
		while inJob do
			if CurrentSubtitle then
				Draw2DTextCenter(0.5, 0.88, CurrentSubtitle, 0.4)
			else
				Citizen.Wait(1000)
			end
			Citizen.Wait(0)
		end
	end)
end

--[[RegisterCommand('jj',function()
	TriggerEvent('esx:inJob','delivery')
end)]]

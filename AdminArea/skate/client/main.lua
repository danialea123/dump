---@diagnostic disable: undefined-global, missing-parameter
local RCCar = {}
local player = nil

Attached = false

AddEventHandler('longboard:clear', function()
	RCCar.Clear()
end)

RegisterNetEvent('longboard:start')
AddEventHandler('longboard:start', function()
	exports.esx_manager:whiteStuffEnt(10000)
    RCCar.Start()
end)

AddEventHandler('esx:onPlayerDeath', function()
	RCCar.AttachPlayer(false)
end)

RCCar.Start = function()
	if DoesEntityExist(RCCar.Entity) then return end
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	RCCar.Spawn()

	while DoesEntityExist(RCCar.Entity) and DoesEntityExist(RCCar.Driver) do
		Wait(4)
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(RCCar.Entity), true)
		RCCar.HandleKeys(distanceCheck)

		if distanceCheck <= Config.LoseConnectionDistance then
			if not NetworkHasControlOfEntity(RCCar.Driver) then
				NetworkRequestControlOfEntity(RCCar.Driver)
			elseif not NetworkHasControlOfEntity(RCCar.Entity) then
				NetworkRequestControlOfEntity(RCCar.Entity)
			end
		else
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end
	end
	DisableControlAction(0, 37, false)
	DisableControlAction(1, 37, false)
	DisableControlAction(2, 37, false)
	EnableControlAction(0, 37, true)
	EnableControlAction(1, 37, true)
	EnableControlAction(2, 37, true)
	SetPedCanSwitchWeapon(PlayerPedId(), true)
end

RCCar.MustRagdoll = function()
	local x = GetEntityRotation(RCCar.Entity).x
	local y = GetEntityRotation(RCCar.Entity).y
	if ((-60.0 < x and x > 60.0)) and IsEntityInAir(RCCar.Entity) and RCCar.Speed < 5.0 then
		return true
	end
	if (HasEntityCollidedWithAnything(GetPlayerPed(-1)) and RCCar.Speed > 5.0) then return true end
	if IsPedDeadOrDying(player, false) then return true end
		return false
end

RCCar.HandleKeys = function(distanceCheck)
	if RCCar and RCCar.Entity and Attached and not IsEntityAttachedToEntity(PlayerPedId(), RCCar.Entity) then
		exports.essentialmode:DisableControl(false)
		TriggerEvent("dpemote:enable", true)
		TriggerEvent("dpclothingAbuse", false)
		RCCar.AttachPlayer(false)
	end
	if RCCar and RCCar.Entity and not Attached and not IsEntityAttachedToEntity(PlayerPedId(), RCCar.Entity) then
		exports.essentialmode:DisableControl(false)
		TriggerEvent("dpemote:enable", true)
		TriggerEvent("dpclothingAbuse", false)
		RCCar.AttachPlayer(false)
	end
	if distanceCheck <= 1.5 then
		if IsControlJustPressed(0, 38) then
			RCCar.Attach('pick')
		end
		if IsControlJustReleased(0, 113) then
			if Attached then
				exports.essentialmode:DisableControl(false)
				TriggerEvent("dpemote:enable", true)
				TriggerEvent("dpclothingAbuse", false)
				RCCar.AttachPlayer(false)
			elseif not IsPedRagdoll(player) then
				exports.essentialmode:DisableControl(true)
				TriggerEvent("dpemote:enable", false)
				TriggerEvent("dpclothingAbuse", true)
				Wait(200)
				RCCar.AttachPlayer(true)
			end
		end
	end

	if Attached then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
		DisablePlayerFiring(PlayerPedId(), true)
		DisableControlAction(0,24,true) -- disable attack
		--[[DisableControlAction(0,47,false) -- disable weapon]]
		DisableControlAction(0,58,true) -- disable weapon
		DisableControlAction(0,263,true) -- disable melee
		DisableControlAction(0,264,true) -- disable melee
		DisableControlAction(0,257,true) -- disable melee
		DisableControlAction(0,140,true) -- disable melee
		DisableControlAction(0,141,true) -- disable melee
		DisableControlAction(0,142,true) -- disable melee
		DisableControlAction(0,143,true) -- disable melee
		DisableControlAction(0, 45, true)
		DisableControlAction(0, 69, true) -- Melee Attack 1
		DisableControlAction(0, 70, true)
		DisableControlAction(0, 92, true)
		DisableControlAction(0, 37, true)
		DisableControlAction(1, 37, true)
		DisableControlAction(2, 37, true)
		SetPedCanSwitchWeapon(PlayerPedId(), false)
	else
		DisableControlAction(0, 37, false)
		DisableControlAction(1, 37, false)
		DisableControlAction(2, 37, false)
		EnableControlAction(0, 37, true)
		EnableControlAction(1, 37, true)
		EnableControlAction(2, 37, true)
		SetPedCanSwitchWeapon(PlayerPedId(), true)
	end

	if distanceCheck < Config.LoseConnectionDistance then
		local overSpeed = (GetEntitySpeed(RCCar.Entity)*3.6) > Config.MaxSpeedKmh

		-- prevents ped from driving away
		TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 1, 1)
		ForceVehicleEngineAudio(RCCar.Entity, 0)

		CreateThread(function()
			player = GetPlayerPed(-1)
			Wait(1)
			SetEntityInvincible(RCCar.Entity, true)
			StopCurrentPlayingAmbientSpeech(RCCar.Driver)	
			if Attached then
				-- Ragdoll system
				RCCar.Speed = GetEntitySpeed(RCCar.Entity) * 3.6

				if RCCar.MustRagdoll() then
					RCCar.AttachPlayer(false)
					SetPedToRagdoll(player, 5000, 4000, 0, true, true, false)
					Attached = false
				end
			end

		end)
		-- Input Control longboard
		if IsControlPressed(0,32) and not IsControlPressed(0, 173) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 9, 1)
		end

		if IsControlPressed(0, 22) and Attached then
			-- Jump system
			if not IsEntityInAir(RCCar.Entity) then	
				local vel = GetEntityVelocity(RCCar.Entity)
				TaskPlayAnim(PlayerPedId(), 'move_crouch_proto', 'idle_intro', 5.0, 8.0, -1, 0, 0, false, false, false)
				local duration = 0
				local boost = 0
				while IsControlPressed(0, 22) do
					Wait(10)
					duration = duration + 10.0
				end
				boost = Config.MaxJumpHeigh * duration / 250.0
				if boost > Config.MaxJumpHeigh then boost = Config.MaxJumpHeigh end
				StopAnimTask(PlayerPedId(), 'move_crouch_proto', 'idle_intro', 1.0)
				if(Attached) then
					SetEntityVelocity(RCCar.Entity, vel.x, vel.y, vel.z + boost)
					TaskPlayAnim(player, 'move_strafe@stealth', 'idle', 8.0, 2.0, -1, 1, 1.0, false, false, false)
				end
			end
		end

		if IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end

		if IsControlPressed(0, 33) and not IsControlPressed(0, 32) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 22, 1)
		end

		if IsControlPressed(0, 34) and IsControlPressed(0, 33) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 13, 1)
		end

		if IsControlPressed(0, 35) and IsControlPressed(0, 33) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 14, 1)
		end

		if IsControlPressed(0, 32) and IsControlPressed(0, 33) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 30, 100)
		end

		if IsControlPressed(0, 34) and IsControlPressed(0, 32) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 7, 1)
		end

		if IsControlPressed(0, 35) and IsControlPressed(0, 32) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 8, 1)
		end

		if IsControlPressed(0, 34) and not IsControlPressed(0, 32) and not IsControlPressed(0, 173) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 4, 1)
		end

		if IsControlPressed(0, 35) and not IsControlPressed(0, 32) and not IsControlPressed(0, 173) and not overSpeed and Attached then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 5, 1)
		end

	end
end


RCCar.Spawn = function()
	-- models to load
	RCCar.LoadModels({ GetHashKey('bmx'), 68070371, GetHashKey('p_defilied_ragdoll_01_s'), 'pickup_object', 'move_strafe@stealth', 'move_crouch_proto'})

	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())

	RCCar.Entity = SpawnVeh()
	RCCar.Skate = SpawnObj()

	-- load models
	while not DoesEntityExist(RCCar.Entity) do
		Wait(5)
	end
	while not DoesEntityExist(RCCar.Skate) do
		Wait(5)
	end

	SetEntityNoCollisionEntity(RCCar.Entity, player, false) -- disable collision between the player and the rc
	SetEntityCollision(RCCar.Entity, false, true)
	SetEntityVisible(RCCar.Entity, false)
	AttachEntityToEntity(RCCar.Skate, RCCar.Entity, GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, -0.40, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

	RCCar.Driver = CreatePed(12	, 68070371, spawnCoords, spawnHeading, false, true)

	-- Driver properties
	SetEnableHandcuffs(RCCar.Driver, true)
	SetEntityInvincible(RCCar.Driver, true)
	SetEntityVisible(RCCar.Driver, false)
	FreezeEntityPosition(RCCar.Driver, true)
	TaskWarpPedIntoVehicle(RCCar.Driver, RCCar.Entity, -1)
	ESX.RepeatCode(function()
		SetEntityVisible(RCCar.Entity, false)
		SetEntityVisible(RCCar.Driver, false)
	end, 5, 1000)
	while not IsPedInVehicle(RCCar.Driver, RCCar.Entity) do
		Wait(0)
	end

	RCCar.Attach('place')
end


RCCar.Attach = function(param)
	if not DoesEntityExist(RCCar.Entity) then
		return
	end

	if param == 'place' then
		-- Place longboard
		AttachEntityToEntity(RCCar.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)

		TaskPlayAnim(PlayerPedId(), 'pickup_object', 'pickup_low', 8.0, -8.0, -1, 0, 0, false, false, false)

		Wait(800)

		DetachEntity(RCCar.Entity, false, true)

		PlaceObjectOnGroundProperly(RCCar.Entity)
	elseif param == 'pick' then
		-- Pick longboard
		Wait(100)

		TaskPlayAnim(PlayerPedId(), 'pickup_object', 'pickup_low', 8.0, -8.0, -1, 0, 0, false, false, false)

		Wait(600)

		AttachEntityToEntity(RCCar.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)

		Wait(900)
		TriggerServerEvent("returnSkate")
		-- Clear 
		RCCar.Clear()

	end

end

RCCar.Clear = function(models)
	DetachEntity(RCCar.Entity)
	DeleteEntity(RCCar.Skate)
	DeleteVehicle(RCCar.Entity)
	DeleteEntity(RCCar.Driver)

	--RCCar.UnloadModels()
	Attach = false
	Attached  = false
	SetPedRagdollOnCollision(player, false)
end


RCCar.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not RCCar.CachedModels then
			RCCar.CachedModels = {}
		end

		RCCar.CachedModels[#RCCar.CachedModels + 1] = {model}

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
				Wait(10)
			end
		end
	end
end

RCCar.UnloadModels = function()
	for modelIndex = 1, #RCCar.CachedModels do
		local model = RCCar.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)
		end
	end
end

RCCar.AttachPlayer = function(toggle)
	if toggle then
		TaskPlayAnim(player, 'move_strafe@stealth', 'idle', 8.0, 8.0, -1, 1, 1.0, false, false, false)
		AttachEntityToEntity(player, RCCar.Entity, 20, 0.0, 0, 0.7, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		SetEntityCollision(player, true, true)
		SetPedRagdollOnCollision(player, true)
		TriggerServerEvent("shareImOnSkate")
	elseif not toggle then
		DetachEntity(player, false, false)
		SetPedRagdollOnCollision(player, false)
		--SetEntityCollision(RCCar.Entity, false, true)
		StopAnimTask(player, 'move_strafe@stealth', 'idle', 1.0)
		StopAnimTask(PlayerPedId(), 'move_crouch_proto', 'idle_intro', 1.0)
		TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 3, 1)	
	end
	Attached = toggle
end

RegisterNetEvent('shareHeIsOnSkate')
AddEventHandler('shareHeIsOnSkate', function(id)
	local player = GetPlayerFromServerId(id)
	local vehicle = GetEntityAttachedTo(GetPlayerPed(player))
	if not vehiclesMuted[vehicle] then
		CreateThread(function() 
			vehiclesMuted[vehicle] = true
			while vehicle do
				Wait(10)
				ForceVehicleEngineAudio(vehicle, 0)
			end
			table.remove(vehiclesMuted, vehicle)
		end)
	end
end)

function SpawnObj()
	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())
	local p = promise.new()
	ESX.Game.SpawnObject("p_defilied_ragdoll_01_s", spawnCoords + vector3(0.3, 0.3, 0.2), function(obj) 
		p:resolve(obj)
	end)
	return Citizen.Await(p)
end

function SpawnVeh()
	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())
	local p = promise.new()
	ESX.Game.SpawnVehicle("bmx", spawnCoords + vector3(0.3, 0.3, 0.2), spawnHeading, function(veh)
		SetVehicleDoorsLockedForAllPlayers(veh, true)
		SetEntityVisible(veh, false)
		--ESX.CreateVehicleKey(veh)
		p:resolve(veh)
	end)
	return Citizen.Await(p)
end
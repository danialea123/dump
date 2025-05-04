---@diagnostic disable: undefined-global, undefined-field, inject-field, missing-parameter, lowercase-global, param-type-mismatch
ESX = nil
PlayerData = nil
GlobalKeys = {}
GlobalBlips = {}
GlobalPeds = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(100)
    end

	PlayerData = ESX.GetPlayerData()

	if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "sheriff" and PlayerData.job.name ~= "fbi" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "forces" then
		ShowHelps()
		ShowMarker()
	end
end)

local PursuitLocations = {
	{
		Botcoord = vector4(2555.02,4652.91,33.08,113.19),
		CarSpawn = vector4(2547.97,4645.11,34.08,315.38),
	},
	{
		Botcoord = vector4(483.2571,-1312.075,28.19556,300.0),
		CarSpawn = vector4(480.0923,-1317.6,28.8418,293.74),
	},
	{
		Botcoord = vector4(221.09,2602.29,44.73,13.52),
		CarSpawn = vector4(216.87,2607.56,46.24,16.99),
	},
}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	for k, v in pairs(GlobalPeds) do
		DeleteEntity(v)
	end
	for k, v in pairs(GlobalBlips) do
		RemoveBlip(v)
	end
	for k, v in pairs(GlobalKeys) do
		UnregisterKey(v)
	end
	exports.sr_main:RemoveByTag("pursuit")
	PlayerData.job = job
	if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "sheriff" and PlayerData.job.name ~= "fbi" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "forces" then
		ShowHelps()
		ShowMarker()
	end
end)

function ShowHelps()
	CreateThread(function()
		RequestModel(GetHashKey("a_m_y_beachvesp_02"))
		while not  HasModelLoaded(GetHashKey("a_m_y_beachvesp_02")) do Wait(0) end 
		for k, v in pairs(PursuitLocations) do
			local blip = AddBlipForCoord(v.Botcoord.x, v.Botcoord.y, v.Botcoord.z)
			SetBlipSprite (blip,458)
			SetBlipDisplay(blip, 2)
			SetBlipScale  (blip,0.6)
			SetBlipColour (blip,1)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Pursuit Robbery")
			EndTextCommandSetBlipName(blip)
			table.insert(GlobalBlips, blip)
			local Ped =  CreatePed(4, GetHashKey("a_m_y_beachvesp_02"), v.Botcoord.x, v.Botcoord.y, v.Botcoord.z, v.Botcoord.w, false, true)
			FreezeEntityPosition(Ped, true)
			SetEntityInvincible(Ped, true)
			SetBlockingOfNonTemporaryEvents(Ped, true)
			SetPedDiesWhenInjured(Ped, false)
			SetPedCanPlayAmbientAnims(Ped, true)
			SetPedCanRagdollFromPlayerImpact(Ped, false)
			SetEntityLodDist(Ped, 100)
			table.insert(GlobalPeds, Ped)
		end 
	end)	
end

ShowFloatingHelpNotification = function(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

local canPlay = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canPlay = true
    else
        canPlay = false
    end
end)

function ShowMarker()
	for k, p in pairs(PursuitLocations) do
		local v = p.Botcoord
		local PursuitInteract
		local Key
		local Point = RegisterPoint(vector3(v.x,v.y,v.z), 10, true)
		Point.set('Tag', 'pursuit')
		Point.set("InArea", function()
			--DrawMarker(36, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,1.0, 1.0, 1.0, 3, 119, 252, 255, false, true, 2, false, false, false, false)		
			DrawMarker(0, v.x,v.y,v.z+2.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 3, 119, 252, 255, false, true, 2, false, false, false, false)	
			if ESX.GetDistance(GetEntityCoords(PlayerPedId()), vector3(v.x,v.y,v.z)) <= 4.0 then
				ShowFloatingHelpNotification("Dokme  ~INPUT_CONTEXT~Baraye Baz Kardan Menu", vector3(v.x, v.y, v.z+0.6))
			end
		end)
		Point.set("InAreaOnce", function()
			PursuitInteract = RegisterPoint(vector3(v.x,v.y,v.z), 1.5, true)
			PursuitInteract.set('Tag', 'pursuit')
			PursuitInteract.set("InAreaOnce", function()
				Hint:Delete()
				Hint:Create("Dokme ~INPUT_CONTEXT~ Baraye Robbery Pursuit")
				Key = UnregisterKey(Key)
				Key = RegisterKey("E", false, function()
					if canPlay then
						Key = UnregisterKey(Key)
						ESX.TriggerServerCallback("esx_cartheft:CD", function(Organ, OnGoing, CoolDown)
							if not OnGoing and CoolDown <= 0 and Organ > 6 then 
								Hint:Delete()
								locationID = k
								OpenUi()
							else
								if OnGoing then
									ESX.Alert("Robbery Tavassot Yek Shakhs Digar Dar Hale Anjam Ast!", "info")
								end
								if CoolDown > 0 then
									ESX.Alert("Robbery CoolDown Ast Baraye: "..CoolDown.." Saniye", "info")
								end
								if Organ < 6 then
									ESX.Alert("Police Kafi Dar Shahr Nist", "info")
								end
							end
						end, k)
					end
				end)
			end)
		end, function()
			Key = UnregisterKey(Key)
			Hint:Delete()
			if PursuitInteract then
				PursuitInteract = PursuitInteract.remove()
			end
		end)
	end
end

function OpenUi()
	TriggerScreenblurFadeIn(1000) 
	MenuOpen = true  
	SetNuiFocus(true, true)
	SendNUIMessage({
		message	= "open"
	})
end 

RegisterNUICallback('buymecano', function(data, cb)
	MenuOpen = false 
	SendNUIMessage({
		message	= "close"
	})
	SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(1000)
	if locationID == 3 then
		ESX.TriggerServerCallback("esx_pursuit:DoesHaveItem", function(have)
			if have then
				TriggerServerEvent('esx_cartheft:Start', locationID)
			else
				ESX.Alert("Shoma Be 10 Cocaine, 5 Crack, 30 Ephedrine, 10 Shishe Baraye Start Robbery Niaz Darid", "error")
			end
		end)
	else
		if ESX.GetPlayerData().money >= 100000 then
			TriggerServerEvent('esx_cartheft:Start', locationID)
		else
			ESX.Alert("Shoma Pool Kafi Nadarid", "info")
		end
	end
end) 

RegisterNUICallback('exit', function(data, cb)
	MenuOpen = false 
	SendNUIMessage({
		message	= "close"
	})
	SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(1000) 
end)

function StartLockpick()
	local random =  math.random(1,3)
	local car = 'z4'
	if random == 1 then 
		car = 'z4'
	elseif random == 2 then 
		car ='foxshelby'

	elseif random == 3 then 
		car ='viper'
	end
	ESX.Alert('Aval Bayad Ghofl Mashin Ra Baaz Konid', "info")
	local EnteredLockpick = false
	local vehicle = SetCar(car)
	local pos = GetEntityCoords(vehicle)
	local LockpickPointInteract
	local Key
	LockpickPoint = RegisterPoint(pos, 30.0, true)
	LockpickPoint.set('Tag', 'pursuit')
	LockpickPoint.set('InArea', function ()
		DrawMarker(20 , vector3(pos.x, pos.y,pos.z + 1.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 255, 255, 100, false, true, 2, false, false, false, false)
	end)
	LockpickPoint.set('InAreaOnce', function ()
		LockpickPointInteract = RegisterPoint(pos, 2.0, true)
		LockpickPointInteract.set('InAreaOnce', function ()
			Key = UnregisterKey(Key)
			Hint:Create('~INPUT_CONTEXT~ Open Lockpick')
			Key = RegisterKey('E', false, function ()
				if not EnteredLockpick then
					EnteredLockpick = true
					Hint:Delete()
					exports.essentialmode:DisableControl(true)
					TriggerEvent("dpemote:enable", false)
					TriggerEvent("dpclothingAbuse", true)
					ESX.SetPlayerData("isSentenced", true)
					local res = createSafe({math.random(1,2),math.random(3,4),math.random(5,6),math.random(7,8)})
					if res then
						Key = UnregisterKey(Key)
						LockpickPoint = LockpickPoint.remove()
						LockpickPointInteract = LockpickPointInteract.remove()
						TriggerEvent("mythic_progbar:client:progress", {name = "D_lockpick",duration = 3000,label = 'Opening...',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})
						Citizen.Wait(3000)
						FreezeEntityPosition(PlayerPedId(), false)
						ESX.SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()), false, false, false, true)
						NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
						ESX.SetPlayerInvincible(PlayerPedId(), false)													
						ClearPedBloodDamage(PlayerPedId())
						ESX.UI.Menu.CloseAll()
						--ESX.SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()))
						ClearPedTasks(PlayerPedId())
						--SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						Citizen.Wait(300)
						TaskWarpPedIntoVehicle(PlayerPedId(),vehicle, -1)
						ESX.Alert('Farar Konid va az Mashin 20 Daghighe Piade Nashavid', "info")
						Citizen.Wait(1500)
						TriggerServerEvent("esx_cartheft:CoordThread", locationID)
						CheackInCar(vehicle)
					else 
						ClearPedTasks(PlayerPedId())
						ESX.Alert('Lockpick Failed Shod, Dobare Talash Konid', "error")
					end
					EnteredLockpick = false
					exports.essentialmode:DisableControl(false)
					TriggerEvent("dpemote:enable", true)
					TriggerEvent("dpclothingAbuse", false)
					ESX.SetPlayerData("isSentenced", false)
				end
			end)
		end, function ()
			Hint:Delete()
			Key = UnregisterKey(Key)
			ESX.UI.Menu.CloseAll()
		end)
	end, function ()
		Key = UnregisterKey(Key)
		Hint:Delete()
		if LockpickPointInteract then
			LockpickPointInteract = LockpickPointInteract.remove()
		end
		if LockpickPoint then
			LockpickPoint = LockpickPoint.remove()
		end
		DeleteEntity(vehicle)
		ESX.Alert('Shoma Az Makan Unlock Kardan Mashin False Gerftid, Robbery Cancel Shod', "error")
		TriggerServerEvent("esx_carTheft:Cancelled", locationID)
	end)	
end

function SetCar(car)
	local p = promise.new()
	local model = GetHashKey(car)
	local coords = PursuitLocations[locationID].CarSpawn
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	ESX.Game.SpawnVehicle(model, vector3(coords.x, coords.y, coords.z), coords.w, function(veh)
		local id = NetworkGetNetworkIdFromEntity(vehicle)
		local vehicle = veh
		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
	
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end
		SetVehRadioStation(vehicle, 'OFF')
		--SetVehicleDoorsLockedForAllPlayers(veh, true)
		ESX.CreateVehicleKey(veh)
		p:resolve(veh)
	end)
	return Citizen.Await(p)
end

function CheackInCar(vehicle)
	inpursuit = true
	CancelWarn = 0 
	local Min = 9
	local Sec = 59 
	TriggerServerEvent('pursuit:SendAlarm', true  , vehicle )
	CreateThread(function()
		while inpursuit do 
			Wait(1000)
			if GetVehiclePedIsIn(PlayerPedId(),false) ~= vehicle then 
				CancelWarn = CancelWarn  + 1 
				ESX.Alert('Savar Mashin Shavid: Ekhtar ~r~'..CancelWarn , "info")
				if CancelWarn > 9  then 
					TriggerServerEvent('pursuit:SendAlarm', nil  , vehicle)
					ESX.Alert('Robbery Cancel Shod', "error")
					ESX.ShowMissionText('')
					DeleteEntity(vehicle)
					TriggerServerEvent("esx_carTheft:Cancelled", locationID)
					inpursuit = false 
					return 
				end
			else
				CancelWarn = 0 
			end 
			if Min > 9  and Sec > 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~"..Min.."~w~ : ~y~"..Sec)
			elseif Min <= 9  and Sec > 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~0"..Min.."~w~ : ~y~"..Sec)
			elseif Min <= 9  and Sec <= 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~0"..Min.."~w~ : ~y~0"..Sec)
			elseif Min > 9  and Sec <= 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~"..Min.."~w~ : ~y~0"..Sec)
			else  
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~"..Min.."~w~ : ~y~"..Sec)
			end
			Sec = Sec - 1 
			if Sec <= 0  and Min ~= 0 then 
				Sec = 59 
				Min = Min - 1 
			elseif Sec <= 0  and Min == 0 then
				inpursuit = false 
				ESX.ShowMissionText("~g~Remaining Time~g~  ~g~"..Min.."~g~ : ~g~"..Sec)
				ESX.Alert('~y~ Robbery Tamam Shod va Padash Ra Daryaft Kardid ', "check")
				TriggerServerEvent('pursuit:success', locationID)
				TriggerServerEvent('pursuit:SendAlarm', false   , vehicle )
				return 
			end
		end 
	end)
end

RegisterNetEvent('esx_carTheft:InitiateCoord')
AddEventHandler('esx_carTheft:InitiateCoord',function(coord)
	if not ESX or not PlayerData or not PlayerData.job then return end
	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" then
		if not DoesBlipExist(vehicleblip) then
			vehicleblip = AddBlipForCoord(coord.x, coord.y, coord.z)
			SetBlipSprite(vehicleblip, 756)
			SetBlipColour(vehicleblip, 1)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Mashin Dozdide Shode Pursuit")
			EndTextCommandSetBlipName(vehicleblip)
		else
			SetBlipCoords(vehicleblip, coord.x, coord.y, coord.z)
		end
	end
end)

RegisterNetEvent('esx_cartheft:Lockpick')
AddEventHandler('esx_cartheft:Lockpick',function()
	StartLockpick()
end)

RegisterNetEvent('esx_carTheft:RemoveBlip')
AddEventHandler('esx_carTheft:RemoveBlip', function()
	RemoveBlip(vehicleblip)
end)
---@diagnostic disable: missing-parameter, missing-parameter
Fishing = false
Blip = nil
SBlip = nil
local lastTimeout = 1

function LoadModels(model)
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	while not HasModelLoaded(model) do
		Citizen.Wait(7)
	end
end

function Progress(Time,LabeL)
	TriggerEvent("mythic_progbar:client:progress",{
		name = "unlocker",
		duration = Time * 1000,
		label =  LabeL,
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

		elseif status then
			Fishing = false
			UnregisterKey(CancelKey)
			Hint:Delete()
			DeleteEntity(Gholab)
			DetachEntity(Gholab)
			ClearPedTasks(PlayerPedId())
			ClearPedSecondaryTask(PlayerPedId())
			FreezeEntityPosition(PlayerPedId(), false)
			exports.essentialmode:DisableControl(false)
			ESX.ClearTimeout(lastTimeout)
		end
	end)
end 

function StartFishing()
	if not Fishing then
		if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedSwimming(PlayerPedId()) and IsEntityInWater(PlayerPedId()) then
			Fishing = true
			Attach()
			exports.essentialmode:DisableControl(true)
			FreezeEntityPosition(PlayerPedId(), true)
			Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Tavaghof Mahigiri")
			CancelKey = RegisterKey("E", function()
				UnregisterKey(CancelKey)
				Hint:Delete()
				DeleteEntity(Gholab)
				DetachEntity(Gholab)
				ClearPedTasks(PlayerPedId())
				ClearPedSecondaryTask(PlayerPedId())
				Fishing = false
				FreezeEntityPosition(PlayerPedId(), false)
				exports.essentialmode:DisableControl(false)
				TriggerEvent("mythic_progbar:client:cancel")
			end)
			local time = math.random(15, 35)
			AddFish(time)
		else 
			ESX.Alert("~r~Shoma Nemitavanid Dar In Makan/Halat Mahigiri Konid", "error")
		end
	else
		ESX.Alert("Shoma Dar Hale Mahigiri Hastid", "info")
	end
end

RegisterNetEvent("esx_fish:CancelFishing")
AddEventHandler("esx_fish:CancelFishing", function()
	Fishing = false
	UnregisterKey(CancelKey)
	Hint:Delete()
	DeleteEntity(Gholab)
	DetachEntity(Gholab)
	ClearPedTasks(PlayerPedId())
	ClearPedSecondaryTask(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	exports.essentialmode:DisableControl(false)
	TriggerEvent("mythic_progbar:client:cancel")
	ESX.ClearTimeout(lastTimeout)
end)

function AddFish(time)
	if Fishing then
		Progress(time, "Fishing...")
		lastTimeout = ESX.SetTimeout((time+2.5)*1000, function()
			if Fishing then
				local T = math.random(15, 35)
				TriggerServerEvent("esx_fish:AddFish")
				AddFish(T)
				Anim("mini@tennis", "forehand_ts_md_far", {
					["flag"] = 48
				})
				while IsEntityPlayingAnim(GetPlayerPed(-1), "mini@tennis", "forehand_ts_md_far", 3) do
					Citizen.Wait(0)
				end
				Anim("amb@world_human_stand_fishing@idle_a", "idle_c", {
					["flag"] = 11
				})
			end
		end)
	end
end

function Attach()
	local fishingRodHash = GetHashKey("prop_fishing_rod_01")
    LoadModels(fishingRodHash)
    Gholab = CreateObject(fishingRodHash, GetEntityCoords(GetPlayerPed(-1)),false)
    AttachEntityToEntity(Gholab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(fishingRodHash)
    Anim("mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })
    while IsEntityPlayingAnim(GetPlayerPed(-1), "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end
    Anim("amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })
end 

function Anim(dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
            if settings == nil then
                TaskPlayAnim(GetPlayerPed(-1), dict, anim, 1.0, -1.0, -1, 1, 0, 0, 0, 0)
            else
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 1
                local playbackRate = 0
                if settings["speed"] then
                    speed = settings["speed"]
                end
                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end
                if settings["duration"] then
                    duration = settings["duration"]
                end
                if settings["flag"] then
                    flag = settings["flag"]
                end
                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end
                TaskPlayAnim(GetPlayerPed(-1), dict, anim, speed, speedMultiplier, -1, 1, playbackRate, 0, 0, 0)
            end
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, true)
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	exports.sr_main:RemoveByTag("fisher")
	RemoveBlip(Blip)
	RemoveBlip(SBlip)
	--[[if xPlayer.job.name == "fisherman" then
		FisherManPoint()
		BCreateBlip(vector3(868.39, -1639.75, 29.33), "Locker Mahigiri")
		if xPlayer.job.grade > 0 then
			OnDutyPoint()
			BCreateBlip(vector3(-1012.64, -1354.62, 5.54), "Forush Maahi")
		end
	end]]
end)

RegisterNetEvent('esx_jobs:ActivateJobForOrgans')
AddEventHandler('esx_jobs:ActivateJobForOrgans', function(job, grade)
	local job = job
	local grade = grade
	Citizen.Wait(math.random(2500, 4000))
	exports.sr_main:RemoveByTag("fisher")
	RemoveBlip(Blip)
	RemoveBlip(SBlip)
	--[[if job == "fisherman" then
		FisherManPoint()
		BCreateBlip(vector3(868.39, -1639.75, 29.33), "Locker Mahigiri")
		if grade > 0 then
			OnDutyPoint()
			BCreateBlip(vector3(-1012.64, -1354.62, 5.54), "Forush Maahi")
		end
	end]]
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	exports.sr_main:RemoveByTag("fisher")
	RemoveBlip(Blip)
	RemoveBlip(SBlip)
	--[[if job.name == "fisherman" then
		FisherManPoint()
		BCreateBlip(vector3(868.39, -1639.75, 29.33), "Locker Mahigiri")
		if job.grade > 0 then
			OnDutyPoint()
			BCreateBlip(vector3(-1012.64, -1354.62, 5.54), "Forush Maahi")
		end
	end]]
end)

function OnDutyPoint()
	Citizen.CreateThread(function()
		SellPos = RegisterPoint(vector3(-1012.64, -1354.62, 5.54), 15, true)
		SellPos.set('Tag', 'fisher')
		SellPos.set('InArea', function ()
			DrawMarker(1, vector3(-1012.64, -1354.62, 4.40), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
			if #(GetEntityCoords(PlayerPedId()) - vector3(-1012.64, -1354.62, 5.54)) < 1.5 then
				ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh Mahi')
				if IsControlJustReleased(0, 38) then
					OpenShop({'fish'})
				end
			end
		end)
		BStartFieldVeh = RegisterPoint(vector3(880.74, -1663.96, 29.37), 15, true)
		BStartFieldVeh.set('Tag', 'fisher')
		BStartFieldVeh.set('InArea', function ()
			DrawMarker(1, vector3(880.74, -1663.96, 29.37), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
			if #(GetEntityCoords(PlayerPedId()) - vector3(880.74, -1663.96, 29.37)) < 1.5 then
				ESX.ShowHelpNotification('~INPUT_CONTEXT~ Spawn Vehicle')
				if IsControlJustReleased(0, 38) then
					Wait(math.random(1,500))
					if ESX.Game.IsSpawnPointClear(vector3(859.35, -1656.21, 29.56), 6.0) then
						if getVehicleFromPlate("FS"..ESX.GetPlayerData().rawid) then
							ESX.ShowNotification('Shoma ghablan yek mashin gereftid')
						else
							ESX.Game.SpawnVehicle('benson', vector3(859.35, -1656.21, 29.56), 50.0, function(vehicle)
								local plate = "FS"..ESX.GetPlayerData().rawid
								plate = string.gsub(plate, " ", "")
								SetVehicleNumberPlateText(vehicle, plate)
								TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
								ESX.CreateVehicleKey(vehicle)
								exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
								--TriggerEvent('esx_carlock:addCarLock', VehToNet(vehicle), true)
								Wait(1000)
								SetVehRadioStation(vehicle, 'RADIO_13_JAZZ')
								SetNewWaypoint(-1038.4545898438, -1397.0551757813)
							end)
						end
					end
				end
			end
		end)
		VStartFieldVeh = RegisterPoint(vector3(873.7,-1669.8,30.49), 15, true)
		VStartFieldVeh.set('Tag', 'fisher')
		VStartFieldVeh.set('InArea', function ()
			DrawMarker(24, vector3(873.7,-1669.8,30.49), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 120, 150, 10, 200, false, true, 2, false, false, false, false)
			if #(GetEntityCoords(PlayerPedId()) - vector3(873.7,-1669.8,30.49)) < 1.5 then
				ESX.ShowHelpNotification('~INPUT_CONTEXT~ Spawn Vehicle')
				DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
			end
		end)
	end)
end

function FisherManPoint()
	Citizen.CreateThread(function()
		BStartPoint = RegisterPoint(vector3(868.39, -1639.75, 29.33), 15, true)
		BStartPoint.set('Tag', 'fisher')
		BStartPoint.set('InArea', function ()
			DrawMarker(1, vector3(868.39, -1639.75, 29.33), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
		end)
		BStartPoint.set('InAreaOnce', function ()
			local Key
			BStartInteract = RegisterPoint(vector3(868.39, -1639.75, 29.33), 1.5, true)
			BStartInteract.set('InAreaOnce', function ()
				Hint:Create('~INPUT_CONTEXT~ Locker Room')
				Key = RegisterKey('E', false, function ()
					Key = UnregisterKey(Key)
					Hint:Delete()
					OpenCloakroomMenu()
				end)
			end, function ()
				Hint:Delete()
				Key = UnregisterKey(Key)
			end)
		end, function ()
			if BStartInteract then
				BStartInteract = BStartInteract.remove()
			end
		end)
	end)
end

function BCreateBlip(coords, name)
	if name == "Forush Maahi" then 
		SBlip = AddBlipForCoord(coords)
		SetBlipSprite  (SBlip, 755)
		SetBlipDisplay (SBlip, 4)
		SetBlipScale   (SBlip, 0.6)
		SetBlipCategory(SBlip, 3)
		SetBlipColour  (SBlip, 43)
		SetBlipAsShortRange(SBlip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(SBlip)
	else
		Blip = AddBlipForCoord(coords)
		SetBlipSprite  (Blip, 755)
		SetBlipDisplay (Blip, 4)
		SetBlipScale   (blip, 0.6)
		SetBlipCategory(Blip, 3)
		SetBlipColour  (Blip, 43)
		SetBlipAsShortRange(Blip, true)
		if name == "Locker Mahigiri" then
			--SetBlipRoute(Blip,  true)
			--SetBlipRouteColour(Blip, 3)
		end
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(Blip)
	end
end

RegisterNetEvent("esx_fish:StartFishing")
AddEventHandler("esx_fish:StartFishing", function()
	Citizen.CreateThread(function()
		Citizen.Wait(750)
		StartFishing()
	end)
end)

AddEventHandler("esx:onPlayerDeath", function()
	if not Fishing then return end
	Fishing = false
	UnregisterKey(CancelKey)
	Hint:Delete()
	DeleteEntity(Gholab)
	DetachEntity(Gholab)
	ClearPedTasks(PlayerPedId())
	ClearPedSecondaryTask(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	TriggerEvent("mythic_progbar:client:cancel")
end)
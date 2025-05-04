---@diagnostic disable: undefined-global, undefined-field, param-type-mismatch, lowercase-global
myFramework = nil
ESX = nil
Citizen.CreateThread(function() 
    if config.framework == "esx" then
        while myFramework == nil do
            TriggerEvent('esx:getSharedObject', function(obj) myFramework = obj end)
            Citizen.Wait(0)
        end
		ESX = myFramework
        cbFunction = myFramework.TriggerServerCallback
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(500)
		end
		PlayerData = ESX.GetPlayerData()
    elseif config.framework == "qb" then
        myFramework = exports['qb-core']:GetCoreObject()
        cbFunction = myFramework.Functions.TriggerCallback
    end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local yeniProp, arac = nil, nil
local aracParcalamaAktif, islemDevamEdiyor, clientcooldown = false, false, config.startCoolDownPlayerJoinig
local kapiSayisi, islem = 0, 0
local parcalamaNokta = vector3(-557.64, -1695.82, 19.16)
local arkaKapi = false

Citizen.CreateThread(function ()
	while true do
		local time = 1000
		if aracParcalamaAktif then
			local playerPed = PlayerPedId()
			local playerKordinat = GetEntityCoords(playerPed)
			local mesafe = #(playerKordinat - vector3(aracParcaNokta[islem]["kordinat"]["x"], aracParcaNokta[islem]["kordinat"]["y"], aracParcaNokta[islem]["kordinat"]["z"]))
			if mesafe < 18 then
				time = 1
				DrawMarker(2, aracParcaNokta[islem]["kordinat"]["x"], aracParcaNokta[islem]["kordinat"]["y"], aracParcaNokta[islem]["kordinat"]["z"]-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 100, false, true, 2, false, false, false, false)
				if mesafe < 2 and not islemDevamEdiyor then
					DrawText3D(aracParcaNokta[islem]["kordinat"]["x"], aracParcaNokta[islem]["kordinat"]["y"], aracParcaNokta[islem]["kordinat"]["z"]-0.2, "~w~~g~[E]~w~ " .. aracParcaNokta[islem]["marker-label"])
					if IsControlJustPressed(1, 38) then
						islemDevamEdiyor = true
						SetEntityHeading(playerPed, aracParcaNokta[islem]["kordinat"]["h"])

						if aracParcaNokta[islem]["prop"] == "sil" and aracParcaNokta[islem]["prop"] ~= "son" then 
							DeleteEntity(yeniProp)	
							if aracParcaNokta[islem]["prop"] == "sil" then
								yeniProp = CreateObject(`prop_cs_cardbox_01`, aracParcaNokta[islem]["kordinat"]["x"], aracParcaNokta[islem]["kordinat"]["y"], aracParcaNokta[islem]["kordinat"]["z"], false, true)
								SetEntityCollision(yeniProp, false, false)
								PlaceObjectOnGroundProperly(yeniProp)
								if DoesEntityExist(yeniProp) then
									AttachEntityToEntity(yeniProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, true, true, false, true, 1, true)
									ClearPedTasks(PlayerPedId())
								end	
							end
						end

						if aracParcaNokta[islem]["animasyon"]["seneryo"] then
							TaskStartScenarioInPlace(playerPed, aracParcaNokta[islem]["animasyon"]["seneryo-anim"], 0, true)
						else
							RequestAnimDictScript(aracParcaNokta[islem]["animasyon"]["anim-disc"], function()
								TaskPlayAnim(playerPed, aracParcaNokta[islem]["animasyon"]["anim-disc"], aracParcaNokta[islem]["animasyon"]["anim-name"], 8.0, 8.0, -1, 33, 0, 0, 0, 0)
							end)
						end

						if aracParcaNokta[islem]["parca-native-no"] then
							SetVehicleDoorOpen(arac, aracParcaNokta[islem]["parca-native-no"], false, false)
						end

						TriggerEvent("mythic_progbar:client:progress", {
							name = aracParcaNokta[islem]["kod-isim"],
							duration = aracParcaNokta[islem]["time"],
							label = aracParcaNokta[islem]["progressbar-label"],
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}
						}, function(status)
							if not status then
								ClearPedTasksImmediately(playerPed)
								if aracParcaNokta[islem]["prop"] ~= "sil" and aracParcaNokta[islem]["prop"] ~= "son" then
									yeniProp = CreateObject(GetHashKey(aracParcaNokta[islem]["prop"]), aracParcaNokta[islem]["kordinat"]["x"], aracParcaNokta[islem]["kordinat"]["y"], aracParcaNokta[islem]["kordinat"]["z"], false, true)
									SetEntityCollision(yeniProp, false, false)
									PlaceObjectOnGroundProperly(yeniProp)
									if DoesEntityExist(yeniProp) then
										AttachEntityToEntity(yeniProp, playerPed, GetPedBoneIndex(playerPed, aracParcaNokta[islem]["entity-attach"]["bone"]), aracParcaNokta[islem]["entity-attach"]["xPos"], aracParcaNokta[islem]["entity-attach"]["yPos"], aracParcaNokta[islem]["entity-attach"]["zPos"], aracParcaNokta[islem]["entity-attach"]["xRot"], aracParcaNokta[islem]["entity-attach"]["yRot"], aracParcaNokta[islem]["entity-attach"]["zRot"], true, true, false, true, 1, true)
										ClearPedTasks(PlayerPedId())
									end

									RequestAnimDictScript(aracParcaNokta[islem]["prop-anim"]["prop-dics"], function()
										TaskPlayAnim(playerPed, aracParcaNokta[islem]["prop-anim"]["prop-dics"], aracParcaNokta[islem]["prop-anim"]["prop-name"], 8.0, 8.0, -1, 50, 0, false, false, false)
									end)	
								elseif aracParcaNokta[islem]["prop"] == "sil" then
									DeleteEntity(yeniProp)	
								end

								if aracParcaNokta[islem]["parca-native-no"] then
									SetVehicleDoorBroken(arac, aracParcaNokta[islem]["parca-native-no"], true)
								end
								
								if islem == #aracParcaNokta then
									aracParcalamaAktif = false
									FinishedChopping()
								elseif islem == 3 then
									if math.random(1,100) < config.policeAlertPercent then
										policeAlertFunction()
									end
								end
								islemDevamEdiyor = false
								islem = islem + 1
								if not arkaKapi and islem == 4 then
									islem = islem + 4
								end
							else
								islemDevamEdiyor = false
								ClearPedTasksImmediately(playerPed)
								if IsEntityAttachedToEntity(yeniProp, playerPed) then
									DeleteEntity(yeniProp)
									ClearPedSecondaryTask(playerPed)
								end
							end
						end)
					end
				end
			
			elseif aracParcalamaAktif then 
				aracParcalamaAktif = false
				if IsEntityAttachedToEntity(yeniProp, playerPed) then
					DeleteEntity(yeniProp)
					ClearPedSecondaryTask(playerPed)
				end
				DeleteEntity(arac)
				scriptNotif("You Left The Zone!")
			end
		end
		Citizen.Wait(time)
	end
end)

Citizen.CreateThread(function()
	if config.ShowBlip then
		local blip = AddBlipForCoord(parcalamaNokta.x, parcalamaNokta.y, parcalamaNokta.z)
		SetBlipSprite(blip, 380)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, 6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(config.BlipName)
		EndTextCommandSetBlipName(blip)
	end

	RequestModel(config.NPCHash)
	while not HasModelLoaded(config.NPCHash) do
		Wait(1)
	end

	stanley = CreatePed(1, config.NPCHash, config.NPCShop.x, config.NPCShop.y, config.NPCShop.z, config.NPCShop.w, false, true)
	SetBlockingOfNonTemporaryEvents(stanley, true)
	SetPedDiesWhenInjured(stanley, false)
	SetPedCanPlayAmbientAnims(stanley, true)
	SetPedCanRagdollFromPlayerImpact(stanley, false)
	SetEntityInvincible(stanley, true)
	FreezeEntityPosition(stanley, true)
end)

local Timer = 0

Citizen.CreateThread(function ()
	while true do
		local time = 1000
		local playerPed = PlayerPedId()
		local playerKordinat = GetEntityCoords(playerPed)
		local mesafe = #(playerKordinat - vector3(parcalamaNokta.x, parcalamaNokta.y, parcalamaNokta.z))

		if not aracParcalamaAktif and mesafe then 
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if mesafe < 25.0 then 
					time = 1
					DrawMarker(20, parcalamaNokta.x, parcalamaNokta.y, parcalamaNokta.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if mesafe < 1.2 then 
						DrawText3D(parcalamaNokta.x, parcalamaNokta.y, parcalamaNokta.z - 0.1, "~w~~g~[E]~w~ Chop The Vehicle")
						if IsControlJustPressed(0, 46) and not clientcooldown and GetGameTimer() - Timer > 3000 then
							if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "sheriff" and PlayerData.job.name ~= "forces" and PlayerData.job.name ~= "mechanic" and PlayerData.job.name ~= "weazel" then
								cbFunction('checkPoliceCount', function(AktifPolis)
									if AktifPolis >= config.minPolice then
										cbFunction('tgiann-aracparcalama:check-cd', function(cd)
											if cd then
												cbFunction('esx_advancedgarage:IsPlateOwned', function(cf)
													if cf then
														Timer = GetGameTimer()
														cbFunction('esx_advancedgarage:IsOwnerOfVehicle', function(cfx)
															if not cfx then
																StartChopThisCar()
															else
																ESX.Alert("Shoma Nemitavanid Mashin Khod Ya Gang Ra Chop Konid", "error")
															end
														end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
													else
														myFramework.ShowNotification("In Mashin Ghabel Chop Shodan Nist")
													end
												end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
											else
												scriptNotif('Someone is Chopping a vehicle.')
											end
										end, VehToNet(GetVehiclePedIsIn(PlayerPedId(), false)))
									else
										scriptNotif('Not enough cops in service')
									end
								end)
							else
								ESX.Alert("Onduty Nemitavanid Mashin Oragh Konid", "info")
							end
						elseif IsControlJustPressed(0, 46) and clientcooldown then
							scriptNotif('Come back later')
						end
					end
				end
			end
		end
		Citizen.Wait(time)
	end
end)

Citizen.CreateThread(function ()
	while true do
		if clientcooldown then
			Citizen.Wait(config.clientCooldown)
			clientcooldown = false
		end 
		Citizen.Wait(1000)
	end
end)

local class = 0
function StartChopThisCar()
	local playerPed = PlayerPedId()
	arac = GetVehiclePedIsIn(playerPed, false)
	class = GetVehicleClass(arac)
	arkaKapi = false
	if class ~= 8 then
		islem = 1

		for i=0, 5 do
			if DoesVehicleHaveDoor(arac, i) then
				kapiSayisi = kapiSayisi + 1
				SetVehicleDoorOpen(arac, i, false, true)
			end
		end

		if kapiSayisi >= 4 then
			arkaKapi = true
		end

		ESX.SetEntityCoords(arac, parcalamaNokta.x, parcalamaNokta.y, parcalamaNokta.z)
		FreezeEntityPosition(arac, true)
		SetEntityHeading(arac, 27.77)
		SetEntityAsMissionEntity(arac, true, true)
		TaskLeaveVehicle(playerPed, arac, 256)
		SetVehicleDoorsLocked(arac, 2)
		--SetVehicleDoorsLockedForAllPlayers(arac, true)
		aracParcalamaAktif = true
		clientcooldown = true
		TriggerServerEvent("tgiann-chopshop:setcd")
	else
		scriptNotif('You cannot do this with a motorcycle!')
	end
end

function FinishedChopping()
	aracParcalamaAktif = false
	DeleteEntity(arac)
	TriggerServerEvent("tgiann-aracparcalama:esya-verme", class)
end

Citizen.CreateThread(function ()
	while true do
		local time = 1000
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local mesafe = #(coords - vector3(config.NPCShop.x, config.NPCShop.y, config.NPCShop.z))
		if mesafe < 3.0 then
			time = 1
			DrawText3D(config.NPCShop.x, config.NPCShop.y, config.NPCShop.z+2.0, "~w~~g~[E]~w~ "..config.NPCName)
			if IsControlJustReleased(0, 38) then
				TriggerServerEvent("tgiann-chopshop:sellitems")
				Citizen.Wait(2500)
			end
		end
		Citizen.Wait(time)
	end
end)

function scriptNotif(text)
    if config.framework == "esx" then
        myFramework.ShowNotification(text)
    elseif config.framework == "qb" then
        myFramework.Functions.Notify(text, 'primary')
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function RequestAnimDictScript(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end
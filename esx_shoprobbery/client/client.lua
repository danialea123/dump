---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-field
ESX = nil

local PlayerData = {}
local started, blockstart, pedwaling, CashRegister, restart, firstlock, secondlock = false, false, false, false, false, false, false
local cassettedone, TimeDefault = 0, 0
local Color = { r = 255, g = 255, b = 255}
local NearThat = false
local CanPressKey = false
local blipcops = {}
local gangpos
lastKos = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
end)

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

RegisterNetEvent('esx_ShopRobbery:EndRobbeyProcess')
AddEventHandler('esx_ShopRobbery:EndRobbeyProcess', function()
	CashRegister = false
end)

local BossSpawn
local ped_hash

Citizen.CreateThread(function()
	Shopper = AddBlipForCoord(723.16, -977.54, 24.13)
	SetBlipSprite(Shopper, 606)
	SetBlipColour(Shopper,  1)
	SetBlipAlpha(Shopper, 250)
	SetBlipScale(Shopper, 0.6)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Shop Robbery')
	EndTextCommandSetBlipName(Shopper)
	ped_hash = GetHashKey(Config.shoprobbery['BossSpawn'].Type)
	BossSpawn = Config.shoprobbery['BossSpawn'].Pos
	RequestModel(ped_hash)
	while not HasModelLoaded(ped_hash) do
		Citizen.Wait(1)
	end
	BossNPC = CreatePed(1, ped_hash, BossSpawn.c.x, BossSpawn.c.y, BossSpawn.c.z-1, BossSpawn.h, false, true)
	SetBlockingOfNonTemporaryEvents(BossNPC, true)
	SetPedDiesWhenInjured(BossNPC, false)
	SetPedCanPlayAmbientAnims(BossNPC, true)
	SetPedCanRagdollFromPlayerImpact(BossNPC, false)
	SetEntityInvincible(BossNPC, true)
	FreezeEntityPosition(BossNPC, true)
end)

function CheckDistance()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), BossSpawn.c, false) < 2.0 then
		return true
	else
		return false
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local Wait = true
		if not blockstart and not started and NearThat then
			Wait = false
			DrawText3Ds(BossSpawn.c.x, BossSpawn.c.y, BossSpawn.c.z + 1.0, 'Baraye Start Robbery, [~g~E~w~] Bezanid')
		else
			if started and NearThat then
				Wait = false
				DrawText3Ds(BossSpawn.c.x, BossSpawn.c.y, BossSpawn.c.z + 1.0, 'Baraye Cancel Kardan Robbery, [~r~E~w~] Bezanid.')
			elseif NearThat then
				Wait = false
				DrawText3Ds(BossSpawn.c.x, BossSpawn.c.y, BossSpawn.c.z + 1.0, 'Boro Ye Ghadam Bezan Baadan Bia...')		
			end		
		end
		if Wait then Citizen.Wait(750) end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		NearThat = CheckDistance()
		if NearThat then
			CanPressKey = true
		else
			Citizen.Wait(100)
			CanPressKey = false
		end
	end
end)

local Pressed = false
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

AddEventHandler("onKeyUP", function(key)
	if key == "e" then
		if canPlay then
			if not blockstart and not started and CanPressKey and not Pressed then
				Pressed = true
				SetTimeout(3000, function()
					Pressed = false
				end)
				ESX.TriggerServerCallback('esx_ShopRobbery:RobAvaliable', function(Avaliable, index)
					if Avaliable then
						started = true
						SetTimeout(Config.TimeToEnd, function()
							if started and not CashRegister then
								--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Shop Robbery Cancel Shod.", timeout = 4000})
								RemoveBlip(ShopBlip)
								DeletePed(ShopNPC)
								started = false
							end
						end)
						ShopName = index
						StartVideo()
					else
						blockstart = true
						SetTimeout(1000*60*3, function()
							blockstart = false
						end)
						--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Police Dar Shahr Hozor Nadarad Lotfan Baadan Emtehan Konid.", timeout = 4000})
					end
				end)
			else
				if started and CanPressKey and not Pressed then
					Pressed = true
					SetTimeout(3000, function()
						Pressed = false
					end)
					started = false
					firstlock = false
					secondlock = false
					RemoveBlip(ShopBlip)
					DeletePed(ShopNPC)
					blockstart = true
					TriggerServerEvent('esx_ShopRobbery:CancelMission', ShopName)
					SetTimeout(1000*60*6, function()
						blockstart = false
					end)
				end
			end
		end
	end
end)

RegisterNetEvent('esx_ShopRobbery:CL_PoliceNotify')
AddEventHandler('esx_ShopRobbery:CL_PoliceNotify', function(coords, street, id)
	local id = id
	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi" or PlayerData.job.name == "artesh" then
		--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Robbery Started At: <b>" ..street.. "</b>.", timeout = 7500})
		blipcops[id] = AddBlipForCoord(coords)
		SetBlipSprite(blipcops[id], 161)
		SetBlipColour(blipcops[id],  1)
		SetBlipAlpha(blipcops[id], 250)
		SetBlipScale(blipcops[id], 1.2)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Shop Robbery')
		EndTextCommandSetBlipName(blipcops[id])
		ESX.Alert("~y~Robbery Dar Yek Foroushgah ~g~Shoru ~y~Shode: ~g~"..street, "lspd")
		SetTimeout(5*60*1000, function()
			if blipcops[id] then
				if DoesBlipExist(blipcops[id]) then
					RemoveBlip(blipcops[id])
				end
			end
		end)
	end
end)

RegisterNetEvent('esx_ShopRobbery:RemoveBlip')
AddEventHandler('esx_ShopRobbery:RemoveBlip', function(id)
	if blipcops[id] == nil then return end
	if DoesBlipExist(blipcops[id]) then
		RemoveBlip(blipcops[id])
	end
end)

local ShopData 
isBusy = false

function ShopRobbery()
	Citizen.CreateThread(function()
		ShopData = Config.Shops[ShopName]
		ShopBlip = AddBlipForCoord(ShopData.ShopPos)	
		SetBlipSprite (ShopBlip, 156)
		SetBlipDisplay(ShopBlip, 4)
		SetBlipScale  (ShopBlip, 3.5)
		SetBlipColour (ShopBlip, 0)
		SetBlipAsShortRange(ShopBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Shop robbery')
		EndTextCommandSetBlipName(ShopBlip)

		local ped_hash = GetHashKey(ShopData.Type)
		RequestModel(ped_hash)
		while not HasModelLoaded(ped_hash) do
			Citizen.Wait(1)
		end	
		ShopNPC = CreatePed(1, ped_hash, ShopData.PedPos.c.x, ShopData.PedPos.c.y, ShopData.PedPos.c.z-1, ShopData.PedPos.h, false, true)	
		SetPedDiesWhenInjured(ShopNPC, false)
		SetPedCanPlayAmbientAnims(ShopNPC, true)
		SetPedCanRagdollFromPlayerImpact(ShopNPC, false)
		SetEntityInvincible(ShopNPC, true)
		FreezeEntityPosition(ShopNPC, true)
		while started do
			local sleep = 500
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local dis = GetDistanceBetweenCoords(coords, ShopData.PedPos.c.x, ShopData.PedPos.c.y, ShopData.PedPos.c.z, true)
			if(dis < 6.5) then	
				sleep = 5
				DrawText3Ds(ShopData.PedPos.c.x, ShopData.PedPos.c.y, ShopData.PedPos.c.z+1.0, 'Hello, how can I help you?')
				if IsPlayerFreeAiming(PlayerId()) then
					local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
					if (IsPedFleeing(targetPed) and targetPed == ShopNPC) or dis <= 4.0 then
						JanMadaretTeleportSho(ShopNPC)	
						ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z) 	
						FreezeEntityPosition(ShopNPC, false)
						CashRegister = true
						CashRegisterThread()
						SetBlockingOfNonTemporaryEvents(ShopNPC, true)
						startAnim(ShopNPC, 'anim@mp_player_intuppersurrender', 'enter')
						local displaying = true
						NetworkRequestControlOfEntity(ShopNPC)
						--[[while not NetworkHasControlOfEntity(ShopNPC) do
							NetworkRequestControlOfEntity(ShopNPC)
							Citizen.Wait(3)
						end]]
						TaskGoToCoordAnyMeans(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z, 1.5)
						ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z)
						TriggerEvent('esx_shop:RobItems', Config.Translator[ShopName])
						local playercoord = GetEntityCoords(PlayerPedId())
						TriggerServerEvent('esx_ShopRobbery:ProcessStart', ShopName, GetStreetNameFromHashKey(GetStreetNameAtCoord(playercoord.x, playercoord.y, playercoord.z)))
						ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z)
						Wait(5000)
						Citizen.CreateThread(function()
							Wait(3000)
							displaying = false
						end)
						while displaying and started do
							Wait(0)
							if restart then break end
							local coordsPed = GetEntityCoords(ShopNPC, false)
							ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z)            
							DrawText3Ds(coordsPed['x'], coordsPed['y'], coordsPed['z'] + 1.2, "I'm Already Opening")
						end
						atlocation = false
						Citizen.CreateThread(function()
							ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z) 
							Wait(10000)
							if atlocation then								
								ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z-1)
								SetEntityHeading(ShopNPC, ShopData.PedWalks.h)
							end
						end)
						ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z) 
						while started do
							local coords2 = GetEntityCoords(ShopNPC)
							if(GetDistanceBetweenCoords(coords2,  ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z, true) < 1.5) then
								atlocation = true
								ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z-1)
								SetEntityHeading(ShopNPC, ShopData.PedWalks.h)
								break
							else
								ESX.SetEntityCoords(ShopNPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z)
							end	
							Citizen.Wait(5)
						end
						

						--startAnim(ShopNPC, 'anim@mp_player_intuppersurrender', 'enter')
						ClearPedTasks(ShopNPC)
						FreezeEntityPosition(ShopNPC, true)
						startAnim(ShopNPC, 'amb@prop_human_bum_bin@idle_a', 'idle_a')

						TimeDefault = ShopData.Time

						Citizen.CreateThread(function()
							ShopData.Time = ShopData.Time + 1
							while started do
								if restart then break end
								ShopData.Time = ShopData.Time - 1
								Citizen.Wait(1000)
								if ShopData.Time <= 0 then
									--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Pool Shoma Amadeye Bardasht Ast", timeout = 4500})
									ClearPedTasks(ShopNPC)
									local coordsPED = GetEntityCoords(ShopNPC)
									startAnim(ShopNPC, 'anim@heists@box_carry@', 'idle')
									pack = CreateObject(GetHashKey('prop_cash_case_02'), coordsPED.x, coordsPED.y, coordsPED.z,  false,  true, true)
									AttachEntityToEntity(pack, ShopNPC, GetPedBoneIndex(ShopNPC, 57005), 0.20, 0.05, -0.25, 260.0, 60.0, 0, true, true, false, true, 1, true)
									break
								end
							end
						end)

						while started do
							local ped = PlayerPedId()
							local coords = GetEntityCoords(ped)
							if ShopData.Time > 0 then
								if(GetDistanceBetweenCoords(coords, ShopData.PedWalks.c, true) < 3.5) then
									DrawText3Ds(ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z+1.0, 'Time: '..tostring(ShopData.Time))
								end
								--DrawText2Ds(0.19, 0.95, 'Time: '..tostring(ShopData.Time), 0.6)
								if restart then break end
							else
								if GetDistanceBetweenCoords(coords, ShopData.PedWalks.c, true) < 1.5 then	
									DrawText3Ds(ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z + 1, "Baraye Bardasht Pool, [~r~E~w~] Bezanid.")
									if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(ped, false) and not isBusy then
										isBusy = true
										FreezeEntityPosition(ShopNPC, false)
										TaskTurnPedToFaceEntity(ShopNPC, PlayerPedId(), 0.2)
										startAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search")
										--[[exports.rprogress:Custom({
											Duration = 6500,
											Label = "Dar Hal Bardasht Pool...",
											Animation = {
												scenario = "", -- https://pastebin.com/6mrYTdQv
												animationDictionary = "", -- https://alexguirre.github.io/animations-list/
											},
											DisableControls = {
												Mouse = false,
												Player = true,
												Vehicle = true
											}
										})]]
										Citizen.Wait(6500)
										ClearPedTasks(ShopNPC)
										TaskPlayAnim(ShopNPC, 'anim@heists@box_carry@', "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
										DeleteEntity(pack)	
										local coord = GetEntityCoords(PlayerPedId())
										ESX.TriggerServerCallback('esx_ShopRobbery:PayOut', function(money)
											--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Shoma "..money.."$ Pool Daryaft Kardid.", timeout = 4500})
											started = false
											CashRegister = false
											TriggerEvent('esx_shop:DisableRobItems')
											isBusy = false
										end, ShopName, GetStreetNameFromHashKey(GetStreetNameAtCoord(coord.x, coord.y, coord.z)), ESX.Game.GetPlayersToSend(40.0))
										break
									end
								end
							end								
							Citizen.Wait(5)
						end
						Citizen.Wait(5000)
						RemoveBlip(ShopBlip)
						DeletePed(ShopNPC)
						started = false
						ShopData.Time = TimeDefault
						break
					end
				end
			end
			Citizen.Wait(sleep)
		end
	end)
end

function JanMadaretTeleportSho(NPC)
	local Time = 5000
	while Time > 0 do
		Citizen.Wait(250)
		Time = Time - 1000
		ESX.SetEntityCoords(NPC, ShopData.PedWalks.c.x, ShopData.PedWalks.c.y, ShopData.PedWalks.c.z)
	end
end

RegisterCommand("shopfix", function()
	if DoesEntityExist(ShopNPC) then
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ShopNPC)) < 10.0 then
			ESX.Alert("~g~Asghar Aghaye ShopRobbery Teleport Shod", "check")
			JanMadaretTeleportSho(ShopNPC)
		else
			ESX.Alert("~r~Fasele Shoma Ba Ped Shop Bish Az 10 Metr Ast", "error")
		end
	else
		ESX.Alert("~y~Asghar Aghaye ShopRobbery Gir Nakarde Ast Ya Shoma Dar Robbery Nistid.", "error")
	end
end)

function CashRegisterThread()
	if CashRegister then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if Config.Shops[ShopName].CashRegister1 then 
			local dist = GetDistanceBetweenCoords(coords, Config.Shops[ShopName].CashRegister1.c.x, Config.Shops[ShopName].CashRegister1.c.y, Config.Shops[ShopName].CashRegister1.c.z, true)
			if(dist < 3) and not Config.Shops[ShopName].CashRegister1.robbed then
				DrawMarker(25, Config.Shops[ShopName].CashRegister1.c.x, Config.Shops[ShopName].CashRegister1.c.y, Config.Shops[ShopName].CashRegister1.c.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 69, 255, 66, 100, false, true, 2, false, false, false, false)
				if dist < 0.4 then
					ShowFloatingHelpNotification("~INPUT_PICKUP~ - To rob a cassette", vector3(Config.Shops[ShopName].CashRegister1.c.x, Config.Shops[ShopName].CashRegister1.c.y, Config.Shops[ShopName].CashRegister1.c.z))
					if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(ped, false) then
						ESX.SetEntityCoords(ped, Config.Shops[ShopName].CashRegister1.c.x, Config.Shops[ShopName].CashRegister1.c.y, Config.Shops[ShopName].CashRegister1.c.z-1)
						SetEntityHeading(ped, Config.Shops[ShopName].CashRegister1.h)
						startAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search")
						--[[exports.rprogress:Custom({
							Duration = 4500,
							Label = "Dar Hal Bardasht Pool...",
							Animation = {
								scenario = "", -- https://pastebin.com/6mrYTdQv
								animationDictionary = "", -- https://alexguirre.github.io/animations-list/
							},
							DisableControls = {
								Mouse = false,
								Player = true,
								Vehicle = true
							}
						})]]
						Citizen.Wait(4500)
						Config.Shops[ShopName].CashRegister1.robbed = true
						ESX.TriggerServerCallback('esx_ShopRobbery:cassettepayout', function(money)
							--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Shoma "..money.."$ Pool Daryaft Kardid.", timeout = 4500})
						end, ShopName)
					end
				end
			end
		end
		if Config.Shops[ShopName].CashRegister2 then
			local dist = GetDistanceBetweenCoords(coords, Config.Shops[ShopName].CashRegister2.c.x, Config.Shops[ShopName].CashRegister2.c.y, Config.Shops[ShopName].CashRegister2.c.z, true)
			if(dist < 1.5) and not Config.Shops[ShopName].CashRegister2.robbed then
				DrawMarker(25, Config.Shops[ShopName].CashRegister2.c.x, Config.Shops[ShopName].CashRegister2.c.y, Config.Shops[ShopName].CashRegister2.c.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 69, 255, 66, 100, false, true, 2, false, false, false, false)
				if dist < 0.4 then
					ShowFloatingHelpNotification("~INPUT_PICKUP~ - To rob a cassette", vector3(Config.Shops[ShopName].CashRegister2.c.x, Config.Shops[ShopName].CashRegister2.c.y, Config.Shops[ShopName].CashRegister2.c.z))
					if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(ped, false) then
						ESX.SetEntityCoords(ped, Config.Shops[ShopName].CashRegister2.c.x, Config.Shops[ShopName].CashRegister2.c.y, Config.Shops[ShopName].CashRegister2.c.z-1)
						SetEntityHeading(ped, Config.Shops[ShopName].CashRegister2.h)
						startAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search")
						--[[exports.rprogress:Custom({
							Duration = 3000,
							Label = "Dar Hal Bardasht Pool...",
							Animation = {
								scenario = "", -- https://pastebin.com/6mrYTdQv
								animationDictionary = "", -- https://alexguirre.github.io/animations-list/
							},
							DisableControls = {
								Mouse = false,
								Player = true,
								Vehicle = true
							}
						})]]
						Citizen.Wait(3000)
						Config.Shops[ShopName].CashRegister2.robbed = true
						ESX.TriggerServerCallback('esx_ShopRobbery:cassettepayout', function(money)
							--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Shoma "..money.."$ Pool Daryaft Kardid.", timeout = 4500})
						end, ShopName)
					end
				end
			end
		end

			
		if Config.Shops[ShopName].CashRegister1 and not firstlock then
			if Config.Shops[ShopName].CashRegister1.robbed then
				cassettedone = cassettedone + 1
				firstlock = true
			end
		elseif not Config.Shops[ShopName].CashRegister1 and not firstlock then
			cassettedone = cassettedone + 1
			firstlock = true
		end
		if Config.Shops[ShopName].CashRegister2 and not secondlock then
			if Config.Shops[ShopName].CashRegister2.robbed then
				cassettedone = cassettedone + 1
				secondlock = true
			end
		elseif not Config.Shops[ShopName].CashRegister2 and not secondlock then
			cassettedone = cassettedone + 1
			secondlock = true
		end


		if cassettedone >= 2 and not started then
			CashRegister = false
			if Config.Shops[ShopName].CashRegister1 then
				Config.Shops[ShopName].CashRegister1.robbed = false
			end
			if Config.Shops[ShopName].CashRegister2 then
				Config.Shops[ShopName].CashRegister2.robbed = false
			end
			cassettedone = 0
			firstlock = false
			secondlock = false
		end

		if(GetDistanceBetweenCoords(coords, Config.Shops[ShopName].ShopPos.x, Config.Shops[ShopName].ShopPos.y, Config.Shops[ShopName].ShopPos.z, true) > 15.0) and started then
			restart = true
			local playercoord = GetEntityCoords(PlayerPedId())
			Config.Shops[ShopName].Time = TimeDefault
			CashRegister = false
			--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Shoma Az Shop Kharej Shodid.", timeout = 4500})
			RemoveBlip(ShopBlip)
			DeletePed(ShopNPC)
			TriggerEvent('esx_shop:DisableRobItems')
			TriggerServerEvent('esx_ShopRobbery:RunOut', ShopName, GetStreetNameFromHashKey(GetStreetNameAtCoord(playercoord.x, playercoord.y, playercoord.z)))
			if Config.Shops[ShopName].CashRegister1 then
				Config.Shops[ShopName].CashRegister1.robbed = false
			end
			if Config.Shops[ShopName].CashRegister2 then
				Config.Shops[ShopName].CashRegister2.robbed = false
			end
			cassettedone = 0
			firstlock = false
			secondlock = false
			started = false
			Citizen.Wait(5000)
			restart = false
		end
		SetTimeout(0, CashRegisterThread)
	end
end

function DrawText2Ds(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0.0, 0.0, 0.0, 0.0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function startAnim(ped, dictionary, anim)
	Citizen.CreateThread(function()
		RequestAnimDict(dictionary)
		while not HasAnimDictLoaded(dictionary) do
			Citizen.Wait(0)
		end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function StartVideo()
	local coords = GetEntityCoords(PlayerPedId())
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local wait = false
	TriggerEvent('skinchanger:getSkin', function(skin)
		lastKos = skin
		wait = true
	end)
	while not wait do
		Citizen.Wait(100)
	end
	local ped = PlayerPedId()
    RequestCutscene("heist_int", 8)
    while not (HasCutsceneLoaded()) do
        Wait(0)
        RequestCutscene("heist_int", 8)
    end
	TriggerEvent('esx_ShopRobbery:SaveCutsceneClothes') 
    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_1', 0, 0, 64)
    StartCutscene(0)
	while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
	end
	SetCutscenePedComponentVariationFromPed(PlayerPedId(), GetPlayerPed(-1), 1885233650)
	SetPedComponentVariation(GetPlayerPed(-1), 11, jacket_old, jacket_tex, jacket_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 8, shirt_old, shirt_tex, shirt_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 3, arms_old, arms_tex, arms_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 4, pants_old,pants_tex,pants_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 6, feet_old,feet_tex,feet_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 1, mask_old,mask_tex,mask_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 9, vest_old,vest_tex,vest_pal)
	SetPedPropIndex(GetPlayerPed(-1), 0, hat_prop, hat_tex, 0)
	SetPedPropIndex(GetPlayerPed(-1), 1, glass_prop, glass_tex, 0)
    while (IsCutscenePlaying()) do
        Wait(0)
    end
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent("skinchanger:loadClothes", skin, lastKos)
	end)
	--exports.pNotify:SendNotification({text = "<b>Shop Robbery</b></br>Get your ass to "..ShopName, timeout = 4000})
	ShopRobbery()
	ESX.Alert("~g~Mokhtasat Shop Robbery Be Rooye Naghshe Mark Shod.", "check")
end

AddEventHandler("onKeyDown", function(key)
	if key == "return" then
		if IsCutscenePlaying() then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(715.07, -961.76, 30.4), false) <= 20.0 then
				StopCutsceneImmediately()
				ESX.Alert("~y~Shoma Demo ShopRobbery Ra Skip Kardid.", "check")
				local coords = GetEntityCoords(PlayerPedId())
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			end
		end
	end
end)

AddEventHandler('esx_ShopRobbery:SaveCutsceneClothes',function()
	local coords = GetEntityCoords(PlayerPedId())
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local ped = GetPlayerPed(-1)
	mask_old,mask_tex,mask_pal = GetPedDrawableVariation(ped,1),GetPedTextureVariation(ped,1),GetPedPaletteVariation(ped,1)
	vest_old,vest_tex,vest_pal = GetPedDrawableVariation(ped,9),GetPedTextureVariation(ped,9),GetPedPaletteVariation(ped,9)
	glass_prop,glass_tex = GetPedPropIndex(ped,1),GetPedPropTextureIndex(ped,1)
	hat_prop,hat_tex = GetPedPropIndex(ped,0),GetPedPropTextureIndex(ped,0)
	jacket_old,jacket_tex,jacket_pal = GetPedDrawableVariation(ped, 11),GetPedTextureVariation(ped,11),GetPedPaletteVariation(ped,11)
	shirt_old,shirt_tex,shirt_pal = GetPedDrawableVariation(ped,8),GetPedTextureVariation(ped,8),GetPedPaletteVariation(ped,8)
	arms_old,arms_tex,arms_pal = GetPedDrawableVariation(ped,3),GetPedTextureVariation(ped,3),GetPedPaletteVariation(ped,3)
	pants_old,pants_tex,pants_pal = GetPedDrawableVariation(ped,4),GetPedTextureVariation(ped,4),GetPedPaletteVariation(ped,4)
	feet_old,feet_tex,feet_pal = GetPedDrawableVariation(ped,6),GetPedTextureVariation(ped,6),GetPedPaletteVariation(ped,6)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	--[[while xPlayer.gang == nil do
        Citizen.Wait(10)
    end 
	if xPlayer.gang.name ~= 'nogang' then
		ESX.TriggerServerCallback('gangs:getGangData', function(data)
			if data ~= nil then
				gangpos = json.decode(data.blip)
			end
		end, xPlayer.gang.name)
	end]]
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
	--[[while gang == nil do
        Citizen.Wait(10)
    end 
	if gang.name ~= 'nogang' then
		ESX.TriggerServerCallback('gangs:getGangData', function(data)
			if data ~= nil then
				gangpos = json.decode(data.blip)
			end
		end, gang.name)
	end]]
end)

--[[RegisterNetEvent("XpAddSystem:ForitemUse")
AddEventHandler("XpAddSystem:ForitemUse",function(xp,item)
	local playerPos = GetEntityCoords(PlayerPedId(), true)
	local NumberXP = tonumber(xp)
	local item = item
    if Vdist(playerPos.x, playerPos.y, playerPos.z, gangpos.x, gangpos.y, gangpos.z) > 50 then
        return ESX.Alert("~r~SHOMA BAYAD NAZDIK GANG KHOD BASHID", "error")
    end
	TriggerServerEvent('SVXP:RemoveItem',item)
	TriggerEvent('GangXPSys:Add', NumberXP, PlayerData.gang.name)
	ESX.Alert('Shoma Ba ~g~Movafaghiyat~s~ Be Gang Residid Va Meghdar ~h~~r~'..NumberXP..' XP ~s~~s~Be Gang Khod Ezafe Kardid', "check")
end)]]

local CALLBACK = nil
local SETTING_CLIPBOARD = false

function SettingClipboard()
	return SETTING_CLIPBOARD
end

function SetClipboard(text, cb)
	local text = text
	if text == "https://discord.gg/ASNjvt6372" then
		text = "https://discord.gg/diamond-rp"
	end
	SETTING_CLIPBOARD = true
	CALLBACK = cb
	SetNuiFocus(true, false)
	SendNUIMessage({
		type = 'SET_CLIPBOARD',
		payload = text,
		meta = 1
	})
end

RegisterNUICallback('message', function (data, cb)
	cb("done")

	if data == nil then return

	elseif data.type == 'SETTING_CLIPBOARD' then
		SETTING_CLIPBOARD = true

	elseif data.type == 'SET_CLIPBOARD' then
		SETTING_CLIPBOARD = false

		if (CALLBACK) then
			CALLBACK(not data.payload)
			CALLBACK = nil
		end
		SetTimeout(17, function ()
			SetNuiFocus(false, false)
		end)
	end
end)

exports('SetClipboard', SetClipboard)


--[[local Arrived = false

RegisterNetEvent('gangs:ChangeXPTracking')
AddEventHandler('gangs:ChangeXPTracking', function(bool)
	Arrived = bool
end)

RegisterNetEvent('gangs:CreateXPThread')
AddEventHandler('gangs:CreateXPThread', function(Data, Amount)
  	SetNewWaypoint(Data.Pos.x, Data.Pos.y)
  	ESX.Alert("~g~~h~Baraye Daryaft XP Bayad Be Khooneye Gang Khod Nazdik Shavid.")
  	local Seceonds = 59
  	local Minutes  = 14
  	Citizen.CreateThread(function()
    	while true do
      		if Arrived then
        		ESX.ShowMissionText("~g~Zaman Baghi Mande : ~g~"..Minutes..":"..Seceonds)
        		ESX.Alert("~g~~h~XP Gang Shoma Variz Shod.")
				TriggerEvent('GangXPSys:Add', Amount, PlayerData.gang.name)
        		SetTimeout(3000, function()
          			Arrived = false
        		end)
        		break
			end
        	if Seceonds < 10 then
				if Minutes < 10 then
					ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":0"..Seceonds)
					if Seceonds == 0 then
						if Minutes == 0 and Seceonds == 0 then
							ESX.Alert("~r~~h~XP Gang Shoma Be Dalil Naresidan Dar Time Hazf Shod.")
							ESX.ShowMissionText("~r~Zaman Baghi Mande : ~r~00:00")
							break
						else
							Minutes = Minutes - 1
							Seceonds = 60
						end
					end
				else
					ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~"..Minutes..":0"..Seceonds)
					if Seceonds == 0 then
						if Minutes == 0 and Seceonds == 0 then
							ESX.Alert("~r~~h~XP Gang Shoma Be Dalil Naresidan Dar Time Hazf Shod.")
							ESX.ShowMissionText("~r~Zaman Baghi Mande : ~r~00:00")
							break
						else
							Minutes = Minutes - 1
							Seceonds = 60
						end
					end
				end
        	else
				if Minutes < 10 then
					ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":"..Seceonds)
					if Seceonds == 0 then
						if Minutes == 0 and Seceonds == 0 then
							ESX.Alert("~r~~h~XP Gang Shoma Be Dalil Naresidan Dar Time Hazf Shod.")
							ESX.ShowMissionText("~r~Zaman Baghi Mande : ~r~00:00")
							break
						else
							Minutes = Minutes - 1
							Seceonds = 60
						end
					end
				else
					ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~"..Minutes..":"..Seceonds)
					if Seceonds == 0 then
						if Minutes == 0 and Seceonds == 0 then
							ESX.Alert("~r~~h~XP Gang Shoma Be Dalil Naresidan Dar Time Hazf Shod.")
							ESX.ShowMissionText("~r~Zaman Baghi Mande : ~r~00:00")
							break
						else
							Minutes = Minutes - 1
							Seceonds = 60
						end
					end
				end
        	end
        	Seceonds = Seceonds - 1
        	Citizen.Wait(1000)
    	end
  	end)
end)]]

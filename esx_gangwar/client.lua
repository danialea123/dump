---@diagnostic disable: undefined-field, param-type-mismatch, missing-parameter, need-check-nil, undefined-global
local ESX = nil
local PlayerData
local GangWarActive
local Kills = 0

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
	PlayerData = data
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

RegisterNetEvent('esx:LeaveGangWar')
AddEventHandler('esx:LeaveGangWar', function(t1, t2)
	if GangWarActive and InGangWarZone then
		if PlayerData.gang.name == t1 or PlayerData.gang.name == t2 then
			TeamOne = nil
			TeamTwo =  nil
			GangWarActive = false
			if InGangWarZone then
				FreezeEntityPosition(PlayerPedId(), false)
				TriggerEvent("esx_inventoryhud:closeHud")
				ESX.SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()), false, false, false, true)
				NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
				ESX.SetPlayerInvincible(PlayerPedId(), false)							
				ESX.SetPedArmour(PlayerPedId(), 0)						
				ClearPedBloodDamage(PlayerPedId())
				ESX.UI.Menu.CloseAll()
				ESX.SetEntityHealth(PlayerPedId(), 200)
				TriggerEvent('esx_status:setirs', 'hunger', 1000000)
				TriggerEvent('esx_status:setirs', 'thirst', 1000000)
				TriggerEvent('esx_status:setirs', 'mental', 1000000)		
				exports.essentialmode:DisableControl(false)
				TriggerEvent("esx_inventoryhud:closeHud")
			end
			Citizen.Wait(2500)
			InGangWarZone = false
			TriggerEvent('capture:inCapture', false)
			TriggerServerEvent("backme")
			TeleportThread(GetGangCoords())
			SendNUIMessage({
				type = 'ui',
				status = false,
			})
		end
	end
end)

RegisterNetEvent("esx:StartGangWar")
AddEventHandler("esx:StartGangWar", function(t1, t2, Coord)
	if PlayerData.gang.name == t1 or PlayerData.gang.name == t2 then
		TeamOne = t1
		TeamTwo =  t2
		Config.WarLocations["AdminSelection"] = Coord
		GangWarActive = true
		PressThread(GetGangCoords())
		CreateKeys()
		UpdateWarPoint()
		StartSecuringArea()
		Update()
		SendNUIMessage({
			type = 'ui',
			punkte = false,
			status = true,
			job1 = TeamTwo,
			job2 = TeamOne,
		})
	end
end)

function GetGangCoords()
	local coord
	TriggerEvent("gangProp:GetInfo", "vehspawn", function(crd)
		coord = crd
	end)
	while coord == nil do 
		Wait(100)
	end
	return vector3(coord.x, coord.y, coord.z+3.0)
end

function UpdateWarPoint()
	Citizen.CreateThread(function()
		while GangWarActive do
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			for k, v in pairs(Config.WarLocations) do
				if GetDistanceBetweenCoords(coords, v, false) < 450 then
					--DrawMarker(Config.WarVariables[k].MarkerType, v.x, v.y, v.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, Config.WarVariables[k].MarkerSize, Config.WarVariables[k].Color.r, Config.WarVariables[k].Color.g, Config.WarVariables[k].Color.b, 255, false, true, 2, false, false, false, false)
					DrawMarker(1, v.x, v.y, v.z - 100, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.WarPointRaduis, Config.WarPointRaduis, 200.0, Config.WarVariables[k].Color.r, Config.WarVariables[k].Color.g, Config.WarVariables[k].Color.b, 255, false, true, 2, false, false, false, false)
				end
			end
			Citizen.Wait(1)
		end
	end)
end

function OpenMenu()
	local element = {}
	element = {
		{label = "Goto GangWar", value = Config.WarLocations["AdminSelection"]}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gangwar_ask_question', {
		title = "GangWar Menu",
		align = 'center',
		elements = element
	}, function(data, menu)
		if Busy then menu.close() return end 
		if data.current.value then
			ESX.UI.Menu.CloseAll()
			Busy = true
			TriggerEvent("mythic_progbar:client:progress", {
				name = "process_revive",
				duration = 10000,
				label = data.current.label,
				useWhileDead = true,
				canCancel = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = true,
					disableCombat = true,
				}}, function(status)
				if not status then
					FreezeEntityPosition(PlayerPedId(), false)
					TriggerEvent("esx_inventoryhud:closeHud")
					ESX.SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()), false, false, false, true)
					NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
					ESX.SetPlayerInvincible(PlayerPedId(), false)							
					ESX.SetPedArmour(PlayerPedId(), 0)						
					ClearPedBloodDamage(PlayerPedId())
					ESX.UI.Menu.CloseAll()
					ESX.SetEntityHealth(PlayerPedId(), 200)
					TriggerEvent('esx_status:setirs', 'hunger', 1000000)
					TriggerEvent('esx_status:setirs', 'thirst', 1000000)
					TriggerEvent('esx_status:setirs', 'mental', 1000000)		
					TeleportThread(data.current.value)
					TriggerServerEvent('esx:joinGangWar')
					Busy = false
					exports.essentialmode:DisableControl(false)
					TriggerEvent("esx_inventoryhud:closeHud")
				end
			end)
		end
	end, function(data,menu)
		menu.close()
	end)
end

function CreateKeys()
	MenuKey = RegisterKey("E", false, function()
		if ((GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetGangCoords(), true) <= 100.0) and not IsHelpMessageBeingDisplayed()) and GangWarActive then
			OpenMenu()
		end
	end)
end

function IsNearAnyCircle()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	for k, v in pairs(Config.WarLocations) do
		Wait(100)
		if GetDistanceBetweenCoords(coords, v, false) <= (Config.WarPointRaduis/2)+5 then
			return true
		end
	end
	return false
end

AddEventHandler("esx:onPlayerDeath", function(data)
	if GangWarActive then
		if IsNearAnyCircle() then
			TriggerServerEvent("esx_war:onPlayerDeath", data)
			hasbeenKilled = true 
			Citizen.Wait(500)
			FreezeEntityPosition(PlayerPedId(), true)
			exports.essentialmode:DisableControl(true)
			Citizen.Wait(1000)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "process_revive",
				duration = 10000,
				label = "Respawning...",
				useWhileDead = true,
				canCancel = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = true,
					disableCombat = true,
				}}, function(status)
				if not status then
					FreezeEntityPosition(PlayerPedId(), false)
					TriggerEvent("esx_inventoryhud:closeHud")
					ESX.SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()), false, false, false, true)
					NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
					ESX.SetPlayerInvincible(PlayerPedId(), false)							
					ESX.SetPedArmour(PlayerPedId(), 0)						
					ClearPedBloodDamage(PlayerPedId())
					ESX.UI.Menu.CloseAll()
					ESX.SetEntityHealth(PlayerPedId(), 200)
					TriggerEvent('esx_status:setirs', 'hunger', 1000000)
					TriggerEvent('esx_status:setirs', 'thirst', 1000000)
					TriggerEvent('esx_status:setirs', 'mental', 1000000)		
					TriggerServerEvent('esx:joinGangWar')
					Busy = false
					exports.essentialmode:DisableControl(false)
					TriggerEvent("esx_inventoryhud:closeHud")
				end
			end)
		end
	end
end)

function makeEntityFaceEntity(GangWar, entity)
	local p2 = GangWar
	local p1 = GetEntityCoords(entity, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading(entity, heading)
end

function Teleport(coord)
	local coordZ = 0
	local height = 300.0

	local foundGround = false
	repeat
		Wait(10)
		ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, height)

		foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)
		coordZ = z + 1
		height = height - 1.0
	until foundGround or height < -100

	if not foundGround then
		coordZ = coord.z
	end

	ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, coordZ)
end

function Update()
	Citizen.CreateThread(function()
		while GangWarActive do
			if TeamOne and TeamTwo then
				SendNUIMessage({
					type = 'ui',
					punkte = true,
					status = true,
					plinks = GlobalState[TeamOne].Kills,
					prechts = GlobalState[TeamTwo].Kills,
					countdown = 50,
				})
			end
			Citizen.Wait(5000)
		end
		SendNUIMessage({
			type = 'ui',
			status = false,
		})
	end)
end

RegisterNetEvent('esx:joinGangWar')
AddEventHandler('esx:joinGangWar', function()
	local point = Config.WarLocations["AdminSelection"]
	if point == nil then return end
	InGangWarZone = true
	TriggerEvent('capture:inCapture', true)
	local BaseCoord = (Config.WarPointRaduis/2) - 5.0
	local XCoord = math.random(-BaseCoord, BaseCoord)
	local YCoord = math.sqrt(BaseCoord^2 - XCoord^2) * (math.random(1,2) > 1 and -1 or 1)
	local FinalCoord = vector2(point.x + XCoord, point.y + YCoord)
	local pedCoord = GetEntityCoords(PlayerPedId())
	Teleport(vector3(FinalCoord.x, FinalCoord.y, pedCoord.z))
	makeEntityFaceEntity(point, PlayerPedId())
end)

function StartSecuringArea()
	Citizen.CreateThread(function()
		while GangWarActive do
			Citizen.Wait(10000)
			if InGangWarZone then
				TriggerServerEvent('esx:joinGangWarW')
			end
		end
	end)
	Citizen.CreateThread(function()
		while GangWarActive do
			Citizen.Wait(1000)
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local pedAmmo	= GetAmmoInPedWeapon(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()))
			if pedAmmo < 100 then AddAmmoToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 50) end
			for k, v in pairs(Config.WarLocations) do
				if GetDistanceBetweenCoords(coords, v, false) <= (Config.WarPointRaduis/2)+3 then
					if IsPedInAnyVehicle(PlayerPedId(), false) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						if GetVehicleClass(vehicle) ~= 15 then
							local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
							--TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, true)

							ESX.Game.DeleteVehicle(vehicle)
						end
					end
					if PlayerData.gang.name == 'nogang' then
						if lastcoord then
							InGangWarZone = false
							ESX.SetEntityCoords(playerPed, lastcoord)
						end
					else
						if not IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsIn(PlayerPedId(), false) ~= 15 then
							if not InGangWarZone then
								if not AskServerCooldown then
									TriggerServerEvent('esx:joinGangWar')
									AskServerCooldown = true
									SetTimeout(1000*10, function()
										AskServerCooldown = false
									end)
								end
							end
						end
					end
				elseif InGangWarZone then
					InGangWarZone = false
					TriggerServerEvent('esx:joinGangWar')
				else
					lastcoord = coords
				end
			end
		end
		TriggerEvent('capture:inCapture', false)
	end)
end

function TeleportThread(crd)
	local coords = crd
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local timeout = 0
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(100)
	end
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	TriggerEvent("esx_inventoryhud:closeHud")
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
		Citizen.Wait(500)
		timeout = timeout + 500
	end
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	TriggerEvent('es_admin:freezePlayer', true)
	SetEntityHeading(PlayerPedId(), 151.57)
	Wait(1500)
	TriggerEvent("esx_inventoryhud:closeHud")
	TriggerEvent('es_admin:freezePlayer', false)
	DoScreenFadeIn(500)
	hasbeenKilled = false
end

function PressThread(pos)
	Citizen.CreateThread(function()
		while GangWarActive do
			if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pos, true) <= 100.0) and not IsHelpMessageBeingDisplayed() then
				text = 'Press [E] To Open Menu'       
				DrawGenericTextThisFrame()	
				SetTextEntry("STRING")
				AddTextComponentString(text)
				DrawText(0.5, 0.8)
			end
			Citizen.Wait(1)
		end
	end)
end

function Draw(text,r,g,b,x,y)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.50, 0.50)
	SetTextColour( r,g,b, 255 )
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function ShowKills()
	Citizen.CreateThread(function()
		while GangWarActive do
			Citizen.Wait(1)
			Draw('Your Kills : '..Kills, 255, 0, 0, 0.01, 0.5)
		end
	end)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end
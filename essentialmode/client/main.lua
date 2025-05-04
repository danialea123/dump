---@diagnostic disable: undefined-field, missing-parameter, undefined-global
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
local LoadoutLoaded = false
local IsPaused      = false
local PlayerSpawned = false
local LastLoadout   = {}
local QUIT       = {}
local Pickups = {}
local isDead        = false
local states = {}
states.frozen = false
states.frozenPos = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('fristJoinCheck')
			SetMaxWantedLevel(0)
			NetworkSetFriendlyFireOption(true)
			DisplayCash(false)
			DisplayAreaName(false)
			break
		end
	end
end)

local loaded = false

Citizen.CreateThread(function()
	NetworkSetFriendlyFireOption(true)
	for i = 0,255 do
		if NetworkIsPlayerActive(i) then
			SetCanAttackFriendly(GetPlayerPed(i), true, true)
			NetworkSetFriendlyFireOption(true)
		end
	end
end)

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end
	ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)

	--[[if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end]]
end)

local enableNative = {}

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	if enableNative[1] then
		N_0xc2d15bef167e27bc()
		SetPlayerCashChange(1, 0)
		Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		SetPlayerCashChange(-1, 0)
	end

	if enableNative[2] then
		SetMultiplayerBankCash()
		Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		SetPlayerCashChange(0, 1)
		SetPlayerCashChange(0, -1)
	end

	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	if firstSpawn and not ESX.PlayerData.dead then
		ESX.SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z - 1)
		TriggerEvent('es_admin:freezePlayer', true)
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			TriggerEvent('es_admin:freezePlayer', false)
		end)
	elseif firstSpawn and ESX.PlayerData.dead then
		ESX.SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z)
		Wait(5000)
		TriggerEvent("newlifeme")
	end
	firstSpawn = false
	PlayerSpawned = true
	isDead = false

	TriggerServerEvent('playerSpawn')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData   = xPlayer
	if GetResourceState("esx_manager") ~= "started" then
        TriggerServerEvent("DiamondAC:BadThingsDetected", "Oh, I Hurt Your Back", false, false)
    end
end)

RegisterNetEvent('es_admin:vehRepair')
AddEventHandler('es_admin:vehRepair', function(veh)
	local vehicle = tonumber(veh)
	if DoesEntityExist(vehicle) then
		ESX.SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0.0)
		exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
	end
end)

RegisterNetEvent('addDonationCar')
AddEventHandler('addDonationCar', function(newOwner, identifier)
	local ped = PlayerPedId()
	local vehicle  = GetVehiclePedIsIn(ped, false)
	local List = exports.esx_addonaccount:getContractCars()
	if not vehicle then return ESX.Alert("Shoma Savar Hich Mashini Nistid", "error") end
	if ESX.GetPlayerData().permission_level < 10 and not List[string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))] then
		return ESX.Alert("Faghat Mashin Haye IC Ra Mitavanid Baraye Gang Add Konid", "error")
	end
	TriggerServerEvent("esx:removeCarKey", ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
	local vehtype = "car"
	if IsPedInAnyBoat(ped) then
		vehtype = "boat"
	elseif IsPedInAnyPlane(ped) then
		vehtype = "aircraft"
	elseif IsPedInAnyHeli(ped) then
		vehtype = "heli"
	end
	local newPlate = exports.esx_vehicleshop:GeneratePlate()
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	local hashVehicule = GetEntityModel(vehicle)
	TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', 'add '..vehtype, GetPlayerName(PlayerId()).." Added Vehicle With Plate "..newPlate.." For: "..identifier.." | Model: "..ESX.GetVehicleLabelFromHash(hashVehicule) or ESX.GetVehicleLabelFromName(hashVehicule), 'user', GetPlayerServerId(PlayerId()), true, false)
	TriggerServerEvent('esx_vehicleshop:AdminTransferVehicle', newOwner, vehtype, vehicleProps)
	ESX.CreateVehicleKey(vehicle)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #HL", 14)
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	ESX.SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z, h)
	if GetInvokingResource() then 
		TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #TP", 14)
		return 
	end
	local coord = vector3(x+0.0, y+0.0, z+0.0)
	ESX.SetEntityCoords(PlayerPedId(), coord)
	if h then SetEntityHeading(PlayerPedId(), h + 180.0) end
	states.frozenPos = coord
end)

RegisterNetEvent('es_admin:teleportUserwithoutcar')
AddEventHandler('es_admin:teleportUserwithoutcar', function(coords)
	if GetInvokingResource() then 
		TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #TP", 14)
		return 
	end
	local ped = GetPlayerPed(-1)
	ESX.Game.Teleport(ped, coords)
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()
	local ped = PlayerPedId()
	local coord = GetEntityCoords(ped)
	states.frozen = state
	FreezeChecker()
	states.frozenPos = vector3(coord.x, coord.y, coord.z - 1)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		ESX.SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		ESX.SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
		FreezePlayer()
	end
end)


local noclip = false
RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	if GetInvokingResource() then return end
	local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end
	EnableNoClip()
	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(m)
	ESX.PlayerData.money = m
end)

RegisterNetEvent('es:addedBank')
AddEventHandler('es:addedBank', function(m)
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	SetPlayerCashChange(0, math.floor(m))
end)

RegisterNetEvent('es:removedBank')
AddEventHandler('es:removedBank', function(m)
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	SetPlayerCashChange(0, -math.floor(m))
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	LoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end
	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	ESX.TriggerServerCallback("esx:getUpdatedLoadout", function(val) 
		ESX.PlayerData.loadout = val
		ESX.SetPlayerData("loadout", val)
		LoadoutLoaded = true
		local playerPed = PlayerPedId()
		local ammoTypes = {}
		RemoveAllPedWeapons(playerPed, true)
		for k, v in ipairs(ESX.PlayerData.loadout) do
			local weaponName = v.name
			local weaponHash = GetHashKey(weaponName)

			GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
			SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

			local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

			for k2,v2 in ipairs(v.components) do
				local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
				GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
			end

			if not ammoTypes[ammoType] then
				AddAmmoToPed(playerPed, weaponHash, v.ammo)
				ammoTypes[ammoType] = true
			end
		end
		LoadoutLoaded = true
	end)
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	local found = false
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
			ESX.PlayerData.inventory[i] = item
			found = true
			break
		end
	end

	if not found then
		table.insert(ESX.PlayerData.inventory, item)
	end

	ESX.UI.ShowInventoryItemNotification(true, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
			ESX.PlayerData.inventory[i] = item
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setDivision')
AddEventHandler('esx:setDivision', function(division)
	ESX.PlayerData.divisions = division
end)

local alllow = {
	["WEAPON_MUSKET"] = true,
	["WEAPON_KNIFE"] = true,
}

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	if GetInvokingResource() and GetInvokingResource() ~= "esx_freeWorld" and not alllow[weaponName] then return end
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local found 	 = false

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
	
	for k,v in pairs(ESX.PlayerData.loadout) do
		if v.name == weaponName then
			found = true
		end
	end
	
	if not found then
		local weaponLabel = ESX.GetWeaponLabel(weaponName)

		table.insert(ESX.PlayerData.loadout, {name = weaponName, ammo = ammo, components = {}, tintIndex = 0, label = weaponLabel })
	end
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('RemoveCar')
AddEventHandler('RemoveCar', function()
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(entity))
	TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', 'Remove Car', GetPlayerName(PlayerId()).." Removed Car With Plate: "..oldPlate, 'user', GetPlayerServerId(PlayerId()), true, false)
	TriggerServerEvent('esx_vehicleshop:DeleteVehicle', oldPlate)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedAmmo(playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end

	for k,v in pairs(ESX.PlayerData.loadout) do
		if v.name == weaponName then
			table.remove(ESX.PlayerData.loadout, k)
		end
	end

	RemoveWeaponFromPed(playerPed, weaponHash)
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	ESX.SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)
	Citizen.CreateThread(function()
		LoadMpDlcMaps()
		EnableMpDlcMaps(true)
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model, coords, id, unlocked)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local playerPed = PlayerPedId()
			local coord    = coords or GetEntityCoords(playerPed)
			ESX.Game.SpawnVehicle(model, coord, GetEntityHeading(playerPed), function(vehicle)
				ESX.CreateVehicleKey(vehicle)
				Citizen.Wait(250)
				if not coords then
					TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
				else
					TriggerServerEvent("esx:GiveKeyToPlayer", id, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
				end
				if unlocked then
					TriggerServerEvent("esx:AdminWiredVehicle", ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
				end
			end)
        end
    end)
end)

RegisterNetEvent("esx:loadoutUpdated")
AddEventHandler("esx:loadoutUpdated", function(val)
	ESX.PlayerData.loadout = val
	ESX.SetPlayerData("loadout", val)
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, coords, type, name, components, tintIndex)
	local x, y, z = coords.x, coords.y, coords.z
	local id = pickupId
	local function setObjectProperties(object)
		SetEntityAsMissionEntity(object, true, false)
		PlaceObjectOnGroundProperly(object)
		FreezeEntityPosition(object, true)
		SetEntityCollision(object, false, true)		
		Pickups[id] = {
			id = id,
			obj = object,
			label = label,
			inRange = false,
			thread = RegisterPoint(coords, 5, true),
			coords = {
				x = x,
				y = y,
				z = z
			}
		}

		Pickups[id].thread.set('InArea', function ()
			ESX.Game.Utils.DrawText3D({
				x = Pickups[id].coords.x,
				y = Pickups[id].coords.y,
				z = Pickups[id].coords.z + 0.25
			}, Pickups[id].label)
		end)
		
		Pickups[id].thread.set('InAreaOnce', function ()
			Pickups[id].interact = RegisterPoint(coords, 1, true)
			Pickups[id].interact.set('InAreaOnce', function ()
				Pickups[id].key = RegisterKey('E', function ()
					if not ESX.GetPlayerData().IsDead then 
						Citizen.Wait(math.random(1,1500))
						if not Pickups[id].inRange and not IsPedSittingInAnyVehicle(PlayerPedId()) then
							Pickups[id].key = UnregisterKey(Pickups[id].key)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
							RequestAnimDict(dictname)
								if not HasAnimDictLoaded(dictname) then
									RequestAnimDict(dictname) 
									while not HasAnimDictLoaded(dictname) do 
										Citizen.Wait(1)
									end
								end
							TaskPlayAnim(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
							Citizen.Wait(850)
							Pickups[id].inRange = true
							Citizen.Wait(1000)
							ClearPedTasks(PlayerPedId())
							Citizen.Wait(math.random(0,1500))
							TriggerServerEvent('esx:onPickup', id)
						end
					end
				end)
			end, function ()
				Pickups[id].key = UnregisterKey(Pickups[id].key)
				Pickups[id].inRange = false
			end)

			Pickups[id].interact.set('InArea', function ()
				if not IsPedSittingInAnyVehicle(PlayerPedId()) then
					ESX.Game.Utils.DrawText3D({
						x = Pickups[id].coords.x,
						y = Pickups[id].coords.y,
						z = Pickups[id].coords.z + 0.5
					}, 'Baraye Bardashtan [~y~E~w~] Ra bezanid')
				end
			end)
		end, function ()
			if Pickups[id].interact then
				Pickups[id].interact = Pickups[id].interact.remove()
			end
		end)
	end
	if type == 'item_weapon' then
		local weaponHash = GetHashKey(name)
		ESX.Streaming.RequestWeaponAsset(weaponHash)
		local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
		SetWeaponObjectTintIndex(pickupObject, tintIndex)

		for k,v in ipairs(components) do
			local component = ESX.GetWeaponComponent(name, v)
			GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
		end

		setObjectProperties(pickupObject)
	else
		ESX.Game.SpawnLocalObject('prop_money_bag_01', coords, setObjectProperties)
	end
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		--TriggerEvent('esx:createPickup', pickupId, pickup.label, pickup.coords, pickup.type, pickup.name, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:pickupUpdate')
AddEventHandler('esx:pickupUpdate', function(id, label)
	if Pickups[id] then
		Pickups[id].label = label
		Pickups[id].inRange = false
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	if Pickups[id] then
		ESX.Game.DeleteLocalObject(Pickups[id].obj)
		if Pickups[id].thread then
			Pickups[id].thread.remove()
		end
		if Pickups[id].interact then
			Pickups[id].interact.remove()
		end
		UnregisterKey(Pickups[id].key)
		Pickups[id] = nil
	end
end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)

	if IsPedInAnyVehicle(playerPed, true) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(vehicle) then
		ESX.Game.DeleteVehicle(vehicle)
	end
end)

RegisterNetEvent('es_admin:repair')
AddEventHandler('es_admin:repair', function()
	if GetInvokingResource() then return end
	local PlayerPed = PlayerPedId()
	local Vehicle   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)

	if IsPedInAnyVehicle(PlayerPed, true) then
		Vehicle = GetVehiclePedIsIn(PlayerPed, false)
	end
	local Driver = GetPedInVehicleSeat(Vehicle, -1)

	if PlayerPed == Driver then
		ESX.SetVehicleFixed(Vehicle)
		SetVehicleDirtLevel(Vehicle, 0.0)
	else
		TriggerServerEvent('es_admin:vehRepair', Vehicle)
	end
end)

AddEventHandler("PaintballGuns", function(bool)
	LoadoutLoaded = bool
end)

function FreezePlayer()
	ClearPedTasksImmediately(PlayerPedId())
	ESX.SetEntityCoords(PlayerPedId(), states.frozenPos)
	if states.frozen then
		SetTimeout(0, FreezePlayer)
	end
end

local LastAmmo = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		local playerPed  = PlayerPedId()
		for i,v in ipairs(Config.Weapons) do
			local weaponName = v.name
			local weaponHash = GetHashKey(weaponName)   
			local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)			
			if HasPedGotWeapon(playerPed, weaponHash, false) then
				if weaponName ~= "WEAPON_PETROLCAN" and (ammoCount == -1 or ammoCount > 251) then 
					SetPedInfiniteAmmo(playerPed, false, weaponHash)
					SetPedAmmo(playerPed, weaponHash, 0)
					ammoCount = 0 
				end
				if LastAmmo[weaponName] == nil then LastAmmo[weaponName] = ammoCount end
				if LastAmmo[weaponName] ~= ammoCount then
					TriggerServerEvent('esx:updateWeaponAmmo', weaponName, ammoCount)
					LastAmmo[weaponName] = ammoCount
				end
			end
		end
	end
end)

-- Menu interactions
-- Citizen.CreateThread(function()
-- 	while true do

-- 		Citizen.Wait(0)

-- 		if IsControlJustReleased(0, Keys['F2']) and GetLastInputMethod(2) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
-- 			ESX.ShowInventory()
-- 		end

-- 	end
-- end)

-- Disable wanted level
Citizen.CreateThread(function()
	local playerId = PlayerId()
	SetPlayerWantedLevel(playerId, 0, false)
	SetPlayerWantedLevelNow(playerId, false)
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		if IsEntityDead(playerPed) and PlayerSpawned then
			PlayerSpawned = false
		end
	end
end)]]

--[[Citizen.CreateThread(function()
	local show   = false
	while true do
	  local entity = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	  if entity > 0 then
		if not show then
		  show = true
		  SendNUIMessage({
			action	= 'show',
			show    = true
		  })
		end
	  else
		if show then
		  show = false
		  SendNUIMessage({
			action	= 'show',
			show    = false
		  })
		end
	  end
	  Citizen.Wait(1000)
	end
end)]]

Citizen.CreateThread(function()
	DisplayCash(false)
	DisplayAreaName(false)
	HideHudComponentThisFrame(3) -- SP Cash display 
	HideHudComponentThisFrame(4)  -- MP Cash display
	HideHudComponentThisFrame(13) -- Cash changes
	HideHudComponentThisFrame( 7 ) -- Area Name
	HideHudComponentThisFrame( 9 ) -- Street Name
end)

function FreezeChecker()
	Citizen.CreateThread(function()
		while states.frozen do
			Citizen.Wait(5)
			ClearPedTasksImmediately(PlayerPedId())
			ESX.SetEntityCoords(PlayerPedId(), states.frozenPos)
		end
	end)
end

local heading = 0

function EnableNoClip()
	Citizen.CreateThread(function()
		while noclip do
			Citizen.Wait(0)
			SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

			if(IsControlPressed(1, 34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
			end

			if(IsControlPressed(1, 32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1, 27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
			end

			if(IsControlPressed(1, 173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
			end
		end
	end)
end

RegisterNetEvent('SendTo')
AddEventHandler('SendTo', function(coords)
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Wait(100)
	end
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
	SetEntityHeading(PlayerPedId(), coords.a)
	TriggerEvent('es_admin:freezePlayer', true)
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Wait(1000)
	end
	TriggerEvent('es_admin:freezePlayer', false)
	Wait(100)
	DoScreenFadeIn(500)
end)

SetBlipAlpha(GetNorthRadarBlip(), 0)

local Island = false
RegisterNetEvent('esx:toggleIsland')
AddEventHandler('esx:toggleIsland', function()
    Island = not Island

    SetIslandHopperEnabled('HeistIsland', Island)

    SetToggleMinimapHeistIsland(Island)
    SetAiGlobalPathNodesType(Island)
    Citizen.InvokeNative(0x53797676AD34A9AA, Island)
    SetScenarioGroupEnabled('Heist_Island_Peds', Island)

    SetAudioFlag('PlayerOnDLCHeist4Island', Island)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', Island, Island)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, Island)
end)

local VIPLevels =
{
	bronze = true,
	silver = true,
	gold = true,
	premium = true
}

exports("IsVIP", function(group)
	return VIPLevels[group] and true or false
end)
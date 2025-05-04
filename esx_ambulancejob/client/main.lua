---@diagnostic disable: lowercase-global, param-type-mismatch, missing-parameter, undefined-field, undefined-global, inject-field, redundant-parameter
Keys = {
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

local inCapture, inEvent = false, false
local formattedCoordsDeath = nil
local paused = false
carryAsking = false

IsDead, InJure, beingRevived, ActiveTimout = false, false , false, nil
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	ESX.SetPlayerData("BlockCarry", false)

	if ESX.GetPlayerData().job.name == "ambulance" and ESX.GetPlayerData().job.grade >= 6 then
		BuyThread()
	end

	if ESX.GetPlayerData().job.name == "medic" and ESX.GetPlayerData().job.grade >= 3 then
		BuyThread2()
	end

	PlayerData = ESX.GetPlayerData()
	
	DecorRegister('Injured', 3)
    DecorSetInt(PlayerPedId(), 'Injured', 0)
	DecorRegister('IsDead', 3)
    DecorSetInt(PlayerPedId(), 'IsDead', 0)
	DecorRegister('KilledBy', 3)
    DecorSetInt(PlayerPedId(), 'KilledBy', 0)
end)

local allllo = {
	["police"] = true,
	["sheriff"] = true,
	["ambulance"] = true,
	["mechanic"] = true,
	["forces"] = true,
	["taxi"] = true,
	["benny"] = true,
	["fbi"] = true,
	["justice"] = true,
	["weazel"] = true,
	["medic"] = true,
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	exports.spawnmanager:setAutoSpawn(false) -- disable respawn
	ESX.PlayerData = xPlayer
	PlayerData = xPlayer
	if ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'medic' then
		if ESX.PlayerData.job.grade > 0  then
			TriggerAmbulanceCitizen()
		end
    end
	if allllo[xPlayer.job.name] then
		AboGhaza()
	end
	if ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'medic' or ESX.PlayerData.job.name == 'offambulance' or ESX.PlayerData.job.name == 'offmedic' then
		teleportEvent = AddEventHandler("onKeyUP", function(key)
			if key == "e" then
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-670.36,361.84,83.08), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-670.84,323.09,140.12))
				elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-670.84,323.09,140.12), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-670.36,361.84,83.08))
				elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-674.63,362.48,83.08), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-674.58,362.72,77.77))
				elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-674.58,362.72,77.77), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-674.63,362.48,83.08))
				end
			end
		end)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local job = job
	ESX.PlayerData.job = job
	PlayerData.job = job
	Citizen.Wait(2000)
	if teleportEvent then
		RemoveEventHandler(teleportEvent)
	end
	if ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'medic' then
		if ESX.PlayerData.job.grade > 0 then
			TriggerAmbulanceCitizen()
		end
    end
	if ESX.GetPlayerData().job.name == "ambulance" and ESX.GetPlayerData().job.grade >= 5 then
		BuyThread()
	end
	if ESX.GetPlayerData().job.name == "medic" and ESX.GetPlayerData().job.grade >= 3 then
		BuyThread2()
	end
	if allllo[job.name] then
		AboGhaza()
	end
	if ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'medic' or ESX.PlayerData.job.name == 'offambulance' or ESX.PlayerData.job.name == 'offmedic' then
		teleportEvent = AddEventHandler("onKeyUP", function(key)
			if key == "e" then
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-670.36,361.84,83.08), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-670.84,323.09,140.12))
				elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-670.84,323.09,140.12), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-670.36,361.84,83.08))
				elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-674.63,362.48,83.08), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-674.58,362.72,77.77))
				elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-674.58,362.72,77.77), true) < 2.0 then
					ESX.SetEntityCoords(PlayerPedId(), vector3(-674.63,362.48,83.08))
				end
			end
		end)
	end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
	PlayerData.gang = gang
	ESX.SetPlayerData("gang", gang)
end)

RegisterNetEvent('esx_ambulancejob:pausedDeath')
AddEventHandler('esx_ambulancejob:pausedDeath', function(toggle)
	paused = toggle
end)

RegisterNetEvent('esx_ambulancejob:ReviveIfDead')
AddEventHandler('esx_ambulancejob:ReviveIfDead', function()
	if IsDead or InJure then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		exports.essentialmode:DisableControl(false)
		IsDead = false
		InJure = false
		ExtraTimeCD = false
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
		ESX.SetPlayerData('IsDead', false)
		SetResourceKvpInt("dead", 0)
		CreateThread(function()
			DoScreenFadeOut(800)

			Wait(800)

			local formattedCoords = {
				x = ESX.Math.Round(coords.x, 1),
				y = ESX.Math.Round(coords.y, 1),
				z = ESX.Math.Round(coords.z, 1)
			}

			ESX.SetPlayerData('lastPosition', formattedCoords)

			TriggerServerEvent('esx:updateLastPosition', formattedCoords)

			local armor = GetPedArmour(PlayerPedId())
			RespawnPed(playerPed, formattedCoords, 0.0, health)

			ESX.SetPedArmour(PlayerPedId(), armor)
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
			Citizen.Wait(2600)
			TriggerEvent("dpclothingAbuse", false)
			TriggerEvent("dpemote:enable", true)
		end)
	end
end)

AddEventHandler('playerSpawned', function()
	IsDead = false
	ExtraTimeCD = false
	if ActiveTimout then ESX.ClearTimeout(ActiveTimout) ActiveTimout = nil end
end)

AddEventHandler('esx:checkDeathFromDisconnect', function()
	if GetResourceKvpInt("dead") == 1 then
		ESX.ShowNotification(_U('combatlog_message'), "error")
		ESX.SetEntityHealth(PlayerPedId(), 0)
	elseif GetResourceKvpInt("dead") == -1 then
		RemoveItemsAfterRPDeath()
	end
	ESX.SetPlayerData('IsDead', false)
	SetResourceKvpInt("dead", 0)
	TriggerServerEvent("esx_ambulancejob:setDeathStatus", false)
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, 0.9)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
	end
end)

function StartDeathAnim(ped, coords, heading)
	local animDict = 'missfbi5ig_0'
	local animName = 'lyinginpain_loop_steve'
	ESX.SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	ESX.SetPlayerInvincible(ped, false)
	SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
	ESX.SetEntityHealth(ped, 150)
	ESX.Streaming.RequestAnimDict(animDict, function()
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 1.0, 0, 0, 0)
	end)
	if not carryAsking then 
		ESX.UI.Menu.CloseAll()
	end
end

RegisterNetEvent('esx_ambulancejob:chnageDeathCoords')
AddEventHandler('esx_ambulancejob:chnageDeathCoords', function(playerId)
	local ped = GetPlayerFromServerId(playerId)
	local coords = GetEntityCoords(GetPlayerPed(ped))
	formattedCoordsDeath = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1) - 1
	}
end)

RegisterNetEvent('esx_ambulancejob:die')
AddEventHandler('esx_ambulancejob:die', function()
	ESX.TriggerServerCallback("esx_ambulancejob:GetDieData", function(can)
		if can then
			exports.essentialmode:DisableControl(true)
			ESX.SetPlayerData('IsDead', true)
			ESX.SetEntityHealth(PlayerPedId(), 0)
			ESX.ShowNotification(' در پنج درصد مواقع ممکن است مدیک نتواند جان شما را نجات دهد به همین علت شما جان خود را از دست دادید تا پایان ریسپان شدن مجدد صبور باشید')
		else
			TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #Am", 14)
		end
	end)
end)

function InjureThreads(playerPed, heading)
	Citizen.CreateThread(function()
		while InJure do
			Wait(0)
			DisableControlAction(0, Keys['F1'],true)
			DisableControlAction(0, Keys['F2'],true)
			DisableControlAction(0, Keys['F3'],true)
			DisableControlAction(0, Keys['F5'],true)
			DisableControlAction(0, Keys['F6'],true)
			DisableControlAction(0, Keys['R'], true)
			DisableControlAction(0, Keys['W'],true)
			DisableControlAction(0, Keys['S'],true)
			DisableControlAction(0, Keys['A'],true)
			DisableControlAction(0, Keys['D'], true)
			DisableControlAction(0, Keys['K'], true)
			DisableControlAction(0, Keys['SPACE'], true)
			DisableControlAction(0, Keys['LEFTSHIFT'], true)
			DisableControlAction(0, Keys['TAB'], true)
			DisableControlAction(0, Keys['X'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys['Z'], true)
			DisableControlAction(0, Keys['U'], true)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Right click
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 27, true) -- Arrow up

		end
	end)
	Citizen.CreateThread(function()
		while InJure do
			local stopped = IsPedStopped(playerPed)
			if (stopped == false) and (not paused) and (not IsEntityInWater(playerPed)) and (not beingRevived) then
				StartDeathAnim(playerPed, formattedCoordsDeath, heading)
			end
			Citizen.Wait(2500)
			TriggerEvent("dpemote:enable", false)
			TriggerEvent("dpclothingAbuse", true)
		end
	end)
	Citizen.CreateThread(function()
		while InJure do
			Citizen.Wait(500)
			if not carryAsking then 
				ESX.UI.Menu.CloseAll()
			end
		end
	end)
end

TimeOutID = nil
TimeOutRevive = nil
spaceKey = nil

RegisterNetEvent("esx_ambulancejob:reviveTimeOut")
AddEventHandler("esx_ambulancejob:reviveTimeOut", function(time)
	TimeOutRevive = nil
	if TimeOutID then
		ESX.ClearTimeout(TimeOutID)
	end
	if spaceKey then
		RemoveEventHandler(spaceKey)
	end
	TimeOutID = ESX.SetTimeout(time, function()
		RemoveEventHandler(spaceKey)
		TimeOutID = nil
		TimeOutRevive = nil
		spaceKey = nil
	end)
	Citizen.Wait(2000)
	reviveTimeOut(time)
end)

function reviveTimeOut(time)
	TimeOutRevive = true
	spaceKey = AddEventHandler('onKeyDown',function(key)
		if key == "space" then 
			local low = math.random(1,2)
			if low == 1 then
				Citizen.Wait(200)
				SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
			end
		end
	end)
	while TimeOutRevive do
		Citizen.Wait(750)
		DisableControlAction(0, 37, true)
		DisableControlAction(1, 37, true)
		DisableControlAction(2, 37, true)
		SetPedCanSwitchWeapon(PlayerPedId(), false)
		if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_MUSKET") and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_KNIFE") then
			Citizen.Wait(75)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
			Citizen.Wait(75)
			--exports['pNotify']:Alert("ERROR", "<span style='color:#c7c7c7'> Level Shoma 0 Ast! Nemitavanid Az Gun Estefade Konid <span style='color:#ff0000'></span>!", 10000, 'error')
			exports['esx_notify']:Notification({
				title = 'INFO',
				message = 'Shoma Ta 5 Daghighe Baad Az Revive Shodan Nemitavanid Aslahe Bekeshid',
				image = 'https://media.discordapp.net/attachments/766026362594656286/912334083193962526/ic_fluent_info_24_filled.png',
				timeout = 6000,
				bgColor = 'rgba(0, 17, 255, 0.4)'
			})
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

function GetCoordZ(x, y, z)
	local coordZ 	= 0
	local height 	= -100.0
	local CurrectZ 	= GetGroundZFor_3dCoord(x, y, z)
	
	if CurrectZ then
		return z
	else
		local foundGround = false
		repeat
			Wait(10)
			foundGround, z = GetGroundZFor_3dCoord(x, y, height)
			coordZ = z + 1
			height = height + 5.0
		until foundGround or height > 1000
	
		return coordZ
	end
end

Crawling = false
CrawlTimer = 0
inAction = false
isCrawlReviving = false

RegisterNetEvent("esx_ambulancejob:actionState")
AddEventHandler("esx_ambulancejob:actionState", function()
	TriggerEvent("mythic_progbar:client:cancel")
	inAction = false
	if ESX.isDead() then return end
	ESX.SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("esx_ambulancejob:reviveOnCrawl")
AddEventHandler("esx_ambulancejob:reviveOnCrawl", function(id)
	if inAction then return end
	inAction = true
	TriggerEvent("mythic_progbar:client:progress", {
		name = "pp",
		duration = 62000,
		label = "Reviving...",
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		},
	}, function(status)
	end)
	exports['diamond_utils']:FlipCrawl()
	ESX.SetPlayerState("Crawling", false)
	ESX.ClearTimeout(CrawlTimer)
	Citizen.CreateThread(function()
		while inAction do
			Citizen.Wait(2)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)
			DisableControlAction(0, 22, true)
		end
		EnableControlAction(0, 32, true)
		EnableControlAction(0, 33, true)
		EnableControlAction(0, 34, true)
		EnableControlAction(0, 35, true)
		EnableControlAction(0, 22, true)
	end)
end)

RegisterNetEvent("esx_ambulancejob:reviveWithCrawl")
AddEventHandler("esx_ambulancejob:reviveWithCrawl", function(id)
	if isCrawlReviving then return end
	ESX.UI.Menu.CloseAll()
	isCrawlReviving = true
	local Ped = GetPlayerPed(GetPlayerFromServerId(id))
	local coords = GetEntityCoords(Ped)
	ESX.SetEntityCoords(PlayerPedId(), coords.x + 0.2, coords.y - 0.2, coords.z- 0.5)
	TaskTurnPedToFaceEntity(PlayerPedId(), Ped)
	Citizen.Wait(1300)
	ExecuteCommand("e jhmassage")
	ExecuteCommand("me dastesho roo ghalb fard zakhmi mizare va feshar mide")
	exports.essentialmode:DisableControl(true)
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "pp",
		duration = 60000,
		label = "Reviving...",
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		},
	}, function(status)
		isCrawlReviving = false
		if status then
			TriggerServerEvent("esx_ambulancejob:reviveFailed")
		else
			TriggerServerEvent("esx_ambulancejob:reviveSuccess")
			exports.essentialmode:DisableControl(false)
			TriggerEvent("dpemote:enable", true)
			TriggerEvent("dpclothingAbuse", false)
			ClearPedTasks(PlayerPedId())
		end
	end)
end)

RegisterNetEvent("esx_ambulancejob:reviveIfPossible")
AddEventHandler("esx_ambulancejob:reviveIfPossible", function()
	if ESX.isDead() then return end
	TriggerEvent("esx_ambulancejob:revive", 200)
	afterCrawlRevive = true
	LimitedWeapons()
	local timer = 15 * 60
    CreateThread(function()
        while timer > 0 and afterCrawlRevive do
            exports['TextUI']:Open('Mahdoodiat Aslahe Sangin<br>'.. timer .. 's', 'lightgreen', 'left')
            timer = timer - 1
            Citizen.Wait(1000)
        end
        exports['TextUI']:Close()
		afterCrawlRevive = false
    end)
end)

local searchAccess = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["justice"] = true,
}

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
		local info = data
		local elements = {}
		table.insert(elements, {label = '--- Money ---', value = nil})
		table.insert(elements, {label =  ESX.Math.GroupDigits(data.money), value = nil})
		table.insert(elements, {label = '--- Pool Kasif ---', value = nil})
		table.insert(elements, {label =  ESX.Math.GroupDigits(data.black_money), value = 'Pool Kasif', itemType = "black_money", amount = data.black_money})
		table.insert(elements, {label = "--- Weapons ---", value = nil})
		for i=1, #data.loadout, 1 do
			table.insert(elements, {
				label    = "Dozdidane "..ESX.GetWeaponLabel(data.loadout[i].name).." "..data.loadout[i].ammo.."x",
				value    = data.loadout[i].name,
				itemType = 'item_weapon',
				amount   = data.loadout[i].ammo
			})
		end
		table.insert(elements, {label = "--- Items ---", value = nil})
		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
				label    = "Dozdidane "..data.inventory[i].label.." "..data.inventory[i].count.."x",
				value    = data.inventory[i].name,
				itemType = 'item_standard',
				amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		{
			title    = "Search Player",
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount
			if data.current.value ~= nil then
				if ESX.GetPlayerState(player, "Crawling") == true then
					if itemType == "item_weapon" and searchAccess[info.job.name] then return ESX.Alert("Shoma Nemitavanid Gun Nirooye Nezami Ra Search Konid", "error") end
					TriggerServerEvent('esx:confiscatePlayerItem', player, itemType, itemName, amount)
					OpenBodySearchMenu(player)
				else
					ESX.Alert("Shoma Nemitvanid In Player Ra Dar In Sharayet Rob Konid", "info")
					ESX.UI.Menu.CloseAll()
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end, player)
end

local Guns = {
    ["WEAPON_PISTOL"]        = true,
    ["WEAPON_PISTOL_MK2"]    = true,
    ["WEAPON_COMBATPISTOL"]  = true,
    ["WEAPON_HEAVYPISTOL"]   = true,
    ["WEAPON_STUNGUN"]       = true,
    ["WEAPON_PISTOL50"]      = true,
    ["WEAPON_SNSPISTOL"]     = true,
    ["WEAPON_SNSPISTOL_MK2"] = true,
    ["WEAPON_VINTAGEPISTOL"] = true,
    ["WEAPON_FLAREGUN"]      = true,
    ["WEAPON_MARKSMANPISTOL"]= true,
    ["WEAPON_REVOLVER"]      = true,
    ["WEAPON_REVOLVER_MK2"]  = true,
    ["WEAPON_APPISTOL"]      = true,
    ["WEAPON_RAYPISTOL"]     = true,
    ["WEAPON_CERAMICPISTOL"] = true,
    ["WEAPON_NAVYREVOLVER"]  = true,
    ["WEAPON_GADGETPISTOL"]  = true,
    ["WEAPON_DOUBLEACTION"]  = true,
    ["WEAPON_UNARMED"]       = true,
    ["WEAPON_BAT"]           = true,
    ["WEAPON_KNIFE"]         = true,
    ["WEAPON_MUSKET"]        = true,
}

function LimitedWeapons()
    Citizen.CreateThread(function()
        while afterCrawlRevive do
            Citizen.Wait(500)
            local CanEquip = false
            for k, v in pairs(Guns) do
                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(k) then
                    CanEquip = true
                end
            end
            if not CanEquip then
                Citizen.Wait(75)
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                Citizen.Wait(75)
				ESX.Alert("Shoma Faghat Az Pistol Mitavanid Estefade Konid", "info")
            end
        end
    end)
end

AddEventHandler("esx_ambulancejob:OpenSearchMenu", function(id)
	local id = id
	if ESX.Game.DoesPlayerExistInArea(id) then
		ESX.UI.Menu.CloseAll()
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(500)
				local Ped = GetPlayerPed(GetPlayerFromServerId(id))
				local coords = GetEntityCoords(Ped)
				local myCoord = GetEntityCoords(PlayerPedId())
				if #(myCoord - coords) >= 2.0 then
					ESX.UI.Menu.CloseAll()
					ESX.Alert("Shoma Az Player Fasele Gereftid", "info")
					break
				end
			end
		end)
		OpenBodySearchMenu(id)
	end
end)

local BlackListLoc = {
	vector4(881.03,-2274.51,32.44, 60),
	vector4(841.01,-1976.87,29.34, 50),
	vector4(-622.02,-230.73,38.06, 50),
	vector4(2739.5,3476.34,55.69, 50),
	vector4(29.27,-1345.77,29.5, 50),
	vector4(-50.1,-1753.25,29.42, 50),
	vector4(-1223.96,-906.26,12.33, 50),
	vector4(-1488.45,-380.36,40.16, 50),
	vector4(-711.64,-912.26,19.22, 50),
	vector4(1137.33,-981.48,46.42, 50),
	vector4(377.68,326.52,103.57, 50),
	vector4(1158.79,-323.16,69.21, 50),
	vector4(2555.6,385.62,108.62, 50),
	vector4(-3041.98,588.45,7.91, 50),
	vector4(-3244.12,1005.3,12.83, 50),
	vector4(-2969.77,390.24,15.04, 50),
	vector4(-1824.7,790.59,138.2, 50),
	vector4(544.45,2668.78,42.16, 50),
	vector4(1166.46,2707.83,38.16, 50),
	vector4(2678.56,3284.52,55.24, 50),
	vector4(1963.48,3744.08,32.34, 50),
	vector4(1392.93,3603.47,34.98, 50),
	vector4(1701.87,4927.39,42.06, 50),
	vector4(1732.95,6414.57,35.04, 50),
	vector4(149.07,-1040.53,29.37, 50),
	vector4(-1213.08,-331.02,37.79, 50),
	vector4(-2962.69,482.58,15.7, 50),
	vector4(-109.2,6466.58,31.63, 60),
	vector4(313.84,-278.46,54.17, 50),
	vector4(-350.99,-49.99,49.04, 50),
	vector4(1166.59,2707.97,38.16, 50),
	vector4(-1068.66,-247.26,39.73, 60),
	vector4(-768.25,249.14,75.63, 60),
	vector4(-1306.54,-826.36,17.15, 60),
	vector4(249.66,220.62,106.29, 70),
	vector4(-1114.96,4922.69,217.98, 80),
	vector4(2439.34,4968.8,57.57, 80),
	vector4(831.71,-2027.42,29.33, 50),
	vector4(-1041.57,-2146.67,13.59, 50),
	vector4(570.43,-3126.36,6.07, 200),
}

function BlackListLocation()
    local coords = GetEntityCoords(PlayerPedId())
    local canUse = false
    for k , v in pairs(BlackListLoc) do
        if ESX.GetDistance(coords,v.xyz) <= v.w then
            canUse = true
            break
        end
    end
	return canUse
end

function OnPlayerDeath(deathCause, Killer)
	local deathCause, Killer = deathCause, Killer
	ExtraTimeCD = false
	if isCrawlReviving or inAction then
		TriggerEvent("mythic_progbar:client:cancel")
		isCrawlReviving = false
	end
	inAction = false
	TriggerServerEvent("carry:stop")
	Citizen.Wait(500)
	if not ESX.GetPlayerData().IsDead and not Crawling and not BlackListLocation() then
		local player = PlayerPedId()
		while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Wait(10)
        end
		Wait(2000)
		StartScreenEffect('DeathFailOut', 0, true)
		SetResourceKvpInt("dead", 1)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		ESX.SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
		NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
		ESX.SetPlayerInvincible(ped, false)
		SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
		ESX.SetEntityHealth(ped, 110)
		ESX.SetPlayerState("Crawling", true)
		TriggerServerEvent("esx_ambulancejob:crawlState", true)
		exports['diamond_utils']:toggleCrawl(true)
		Crawling = true
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		CrawlTimer = ESX.SetTimeout(60000,function()
			ESX.SetEntityHealth(PlayerPedId(), 0)
			TriggerServerEvent("esx_ambulancejob:crawlState", nil)
		end)
		local timer = 60
		Citizen.CreateThread(function()
			while Crawling do
				ESX.ShowMissionText('~r~Injure Timer ~w~('.. timer ..')')
				timer = timer - 1
				Citizen.Wait(1000)
				if isCrawlReviving then
					break
				end
			end
			ESX.ShowMissionText('')
		end)	
	elseif not ESX.GetPlayerData().IsDead and (Crawling or BlackListLocation()) then
		Crawling = false
		ESX.ClearTimeout(CrawlTimer)
		ESX.SetPlayerState("Crawling", false)
		TriggerServerEvent("esx_ambulancejob:crawlState", nil)
		if exports['diamond_utils']:IsPlayerProne() then 
			exports['diamond_utils']:toggleCrawl(true)
		end
		TriggerEvent('sr:onPlayerInjure')
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		InJure = true
		ESX.SetPlayerData('IsDead', true)

		local player = PlayerPedId()

		while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Wait(10)
        end

		local playerPed = PlayerPedId()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)

		formattedCoordsDeath = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(GetCoordZ(coords.x, coords.y, coords.z), 1)
		}

		Wait(2000)
		StartDeathAnim(playerPed, formattedCoordsDeath, heading)
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', deathCause)
		StartDistressSignal()
		StartBleading()
		StartScreenEffect('DeathFailOut', 0, true)
		InjureThreads(playerPed, heading)
		TriggerEvent('esx_status:setirs', 'hunger', 500000)
		TriggerEvent('esx_status:setirs', 'thirst', 500000)
		TriggerEvent('esx_status:setirs', 'mental', 500000)	
		ESX.UI.Menu.CloseAll()
		SetResourceKvpInt("dead", 1)
		TriggerEvent("esx_inventoryhud:closeHud")
		DecorSetInt(PlayerPedId(), 'Injured', exports.sr_main:GetTimeStampp())
		DecorSetInt(PlayerPedId(), 'IsDead', 0)
		if Killer then
			DecorSetInt(PlayerPedId(), 'KilledBy', Killer)
		end
	else
		DecorSetInt(PlayerPedId(), 'IsDead', exports.sr_main:GetTimeStampp())
		DecorSetInt(PlayerPedId(), 'Injured', 0)
		if Killer then
			DecorSetInt(PlayerPedId(), 'KilledBy', Killer)
		end
		SetResourceKvpInt("dead", -1)
		TriggerEvent('sr:onPlayerDeath')
		InJure = false
		IsDead = true
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', -1)
		ESX.SetPlayerData('IsDead', -1)
		StartDeathTimer()
		Citizen.CreateThread(function()
			while IsDead do
				Wait(0)
				DisableAllControlActions(0)
				EnableControlAction(0, Keys['G'], true)
				EnableControlAction(0, Keys['T'], true)
				EnableControlAction(0, Keys['E'], true)
			end
		end)

		ActiveTimout = ESX.SetTimeout(5000 * 60, function()
			if IsDead then
				RemoveItemsAfterRPDeath()
			end
		end)
	end
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAABp5JREFUWIW1l21sFNcVhp/58npn195de23Ha4Mh2EASSvk0CPVHmmCEI0RCTQMBKVVooxYoalBVCVokICWFVFVEFeKoUdNECkZQIlAoFGMhIkrBQGxHwhAcChjbeLcsYHvNfsx+zNz+MBDWNrYhzSvdP+e+c973XM2cc0dihFi9Yo6vSzN/63dqcwPZcnEwS9PDmYoE4IxZIj+ciBb2mteLwlZdfji+dXtNU2AkeaXhCGteLZ/X/IS64/RoR5mh9tFVAaMiAldKQUGiRzFp1wXJPj/YkxblbfFLT/tjq9/f1XD0sQyse2li7pdP5tYeLXXMMGUojAiWKeOodE1gqpmNfN2PFeoF00T2uLGKfZzTwhzqbaEmeYWAQ0K1oKIlfPb7t+7M37aruXvEBlYvnV7xz2ec/2jNs9kKooKNjlksiXhJfLqf1PXOIU9M8fmw/XgRu523eTNyhhu6xLjbSeOFC6EX3t3V9PmwBla9Vv7K7u85d3bpqlwVcvHn7B8iVX+IFQoNKdwfstuFtWoFvwp9zj5XL7nRlPXyudjS9z+u35tmuH/lu6dl7+vSVXmDUcpbX+skP65BxOOPJA4gjDicOM2PciejeTwcsYek1hyl6me5nhNnmwPXBhjYuGC699OpzoaAO0PbYJSy5vgt4idOPrJwf6QuX2FO0oOtqIgj9pDU5dCWrMlyvXf86xsGgHyPeLos83Brns1WFXLxxgVBorHpW4vfQ6KhkbUtCot6srns1TLPjNVr7+1J0PepVc92H/Eagkb7IsTWd4ZMaN+yCXv5zLRY9GQ9xuYtQz4nfreWGdH9dNlkfnGq5/kdO88ekwGan1B3mDJsdMxCqv5w2Iq0khLs48vSllrsG/Y5pfojNugzScnQXKBVA8hrX51ddHq0o6wwIlgS8Y7obZdUZVjOYLC6e3glWkBBVHC2RJ+w/qezCuT/2sV6Q5VYpowjvnf/iBJJqvpYBgBS+w6wVB5DLEOiTZHWy36nNheg0jUBs3PoJnMfyuOdAECqrZ3K7KcACGQp89RAtlysCphqZhPtRzYlcPx+ExklJUiq0le5omCfOGFAYn3qFKS/fZAWS7a3Y2wa+GJOEy4US+B3aaPUYJamj4oI5LA/jWQBt5HIK5+JfXzZsJVpXi/ac8+mxWIXWzAG4Wb4g/jscNMp63I4U5FcKaVvsNyFALokSA47Kx8PVk83OabCHZsiqwAKEpjmfUJIkoh/R+L9oTpjluhRkGSPG4A7EkS+Y3HZk0OXYpIVNy01P5yItnptDsvtIwr0SunqoVP1GG1taTHn1CloXm9aLBEIEDl/IS2W6rg+qIFEYR7+OJTesqJqYa95/VKBNOHLjDBZ8sDS2998a0Bs/F//gvu5Z9NivadOc/U3676pEsizBIN1jCYlhClL+ELJDrkobNUBfBZqQfMN305HAgnIeYi4OnYMh7q/AsAXSdXK+eH41sykxd+TV/AsXvR/MeARAttD9pSqF9nDNfSEoDQsb5O31zQFprcaV244JPY7bqG6Xd9K3C3ALgbfk3NzqNE6CdplZrVFL27eWR+UASb6479ULfhD5AzOlSuGFTE6OohebElbcb8fhxA4xEPUgdTK19hiNKCZgknB+Ep44E44d82cxqPPOKctCGXzTmsBXbV1j1S5XQhyHq6NvnABPylu46A7QmVLpP7w9pNz4IEb0YyOrnmjb8bjB129fDBRkDVj2ojFbYBnCHHb7HL+OC7KQXeEsmAiNrnTqLy3d3+s/bvlVmxpgffM1fyM5cfsPZLuK+YHnvHELl8eUlwV4BXim0r6QV+4gD9Nlnjbfg1vJGktbI5UbN/TcGmAAYDG84Gry/MLLl/zKouO2Xukq/YkCyuWYV5owTIGjhVFCPL6J7kLOTcH89ereF1r4qOsm3gjSevl85El1Z98cfhB3qBN9+dLp1fUTco+0OrVMnNjFuv0chYbBYT2HcBoa+8TALyWQOt/ImPHoFS9SI3WyRajgdt2mbJgIlbREplfveuLf/XXemjXX7v46ZxzPlfd8YlZ01My5MUEVdIY5rueYopw4fQHkbv7/rZkTw6JwjyalBCHur9iD9cI2mU0UzD3P9H6yZ1G5dt7Gwe96w07dl5fXj7vYqH2XsNovdTI6KMrlsAXhRyz7/C7FBO/DubdVq4nBLPaohcnBeMr3/2k4fhQ+Uc8995YPq2wMzNjww2X+vwNt1p00ynrd2yKDJAVN628sBX1hZIdxXdStU9G5W2bd9YHR5L3f/CNmJeY9G8WAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()
	if IsPedInAnyVehicle(PlayerPedId()) then return ESX.Alert("Shoma Nemitavanid Az In Item Dar Mashin Estefade Konid", "info") end
	if itemName == 'medikit' then
		if ESX.GetPlayerData().IsDead and ESX.GetPlayerData().IsDead ~= -1 then
			ESX.TriggerServerCallback("esx_ambulancejob:ValidateUsingItem", function(valid)
				if valid then
					local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
					local playerPed = PlayerPedId()
					IsDead = false
					InJure = false
					ExtraTimeCD = false
					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

						Citizen.Wait(500)
						while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
							Citizen.Wait(0)
							DisableAllControlActions(0)
						end
				
						TriggerEvent('esx_ambulancejob:revive')
						ESX.ShowNotification(_U('used_medikit'))
					end)
				end
			end, itemName)
		end
	elseif itemName == 'bandage' then
		if ESX.GetPlayerData().isSentenced then return end
		if ESX.isDead() then return end
		ESX.TriggerServerCallback("esx_ambulancejob:ValidateUsingItem", function(valid)
			local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
			local playerPed = PlayerPedId()

			ESX.Streaming.RequestAnimDict(lib, function()
				TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

				Citizen.Wait(500)
				while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
					Citizen.Wait(0)
					DisableAllControlActions(0)
				end

				ESX.SetEntityHealth(PlayerPedId(), 200)
				ESX.ShowNotification(_U('used_bandage'))
			end)
		end, itemName)
	end
end)

RegisterNetEvent("esx_ambulancejob:usingBandageToHeal")
AddEventHandler("esx_ambulancejob:usingBandageToHeal", function()
	if ESX.GetPlayerData().isSentenced then return end
	if ESX.isDead() then return end
	exports.essentialmode:DisableControl(true)
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	ESX.SetPlayerData("isSentenced", true)
	TriggerServerEvent("esx_ambulancejob:removeItem", "cbandage")
	local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
	local playerPed = PlayerPedId()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "bandage_heal",
		duration = 4000,
		label = "Using Bandage",
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(status)
		local health = GetEntityHealth(PlayerPedId())
		ESX.SetEntityHealth(PlayerPedId(), health + 4)
		exports.essentialmode:DisableControl(false)
		TriggerEvent("dpemote:enable", true)
		TriggerEvent("dpclothingAbuse", false)
		ESX.SetPlayerData("isSentenced", false)
		ClearPedTasks(PlayerPedId())
	end)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(500)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
	end)
end)

local pressed = false
local star = false

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer
		star = true
		while timer > 0 and InJure do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlJustPressed(0, Keys['G']) or pressed then
				SendDistressSignal()

				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if InJure then
						StartDistressSignal()
					end
				end)
				pressed = false
				star = false
				break
			end
		end
	end)
end

--[[AddEventHandler("onKeyDown", function(key)
	if key == "g" then
		if star then
			pressed = true
		end
	end
end)]]

function SendDistressSignal()
	ESX.ShowNotification(_U('distress_sent'))
    --[[local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local myPos = GetEntityCoords(PlayerPedId())
    local GPS = 'GPS: ' .. myPos.x .. ', ' .. myPos.y]]
    --[[ESX.TriggerServerCallback('gksphone:namenumber', function(Races)
        TriggerServerEvent('gksphone:gkcs:jbmessage', string.gsub(ESX.GetPlayerData().name, "_", " "), Races[1].phone_number, 'Majrooh', '', GPS, 'ambulance')
    end)]]
	ESX.TriggerServerCallback('esx_ambulancejob:GetEnoughMedic', function(enough)
		if not enough then
			local job = "medic"
			local loc2 = vector3(-283.5,-1786.0,3.44)
			local coord = GetEntityCoords(PlayerPedId())
			local distance2 = #(coord - loc2)
			if distance2 < 2900.0 then
				job = "ambulance"
			end
			TriggerServerEvent('medic:request', "Salam, Man Zakhmi Shodam Va Be Komak Niaz Daram", job)
		else
			OfflineRevive()
		end
	end)
end

function OfflineRevive()  
	local vehhash = GetHashKey("ambulance")                                                     
	local loc = GetEntityCoords(PlayerPedId())
	RequestModel(vehhash)
	while not HasModelLoaded(vehhash) do
		Wait(1)
	end
	RequestModel('s_m_m_doctor_01')
	while not HasModelLoaded('s_m_m_doctor_01') do
		Wait(1)
	end
	local spawnRadius = 40                                                    
    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(loc.x + math.random(-spawnRadius, spawnRadius), loc.y + math.random(-spawnRadius, spawnRadius), loc.z, 0, 3, 0)
	if not DoesEntityExist(vehhash) then
        mechVeh = CreateVehicle(vehhash, spawnPos, spawnHeading, false, false)                        
        ClearAreaOfVehicles(GetEntityCoords(mechVeh), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(mechVeh)
		SetVehicleNumberPlateText(mechVeh, "Ambulance")
		SetEntityAsMissionEntity(mechVeh, true, true)
		SetVehicleEngineOn(mechVeh, true, true, false)
        
        mechPed = CreatePedInsideVehicle(mechVeh, 26, GetHashKey('s_m_m_doctor_01'), -1, false, false)              	
        
        mechBlip = AddBlipForEntity(mechPed)                                                        	
        SetBlipFlashes(mechBlip, true)  
        SetBlipColour(mechBlip, 5)

		PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
		Wait(2000)
		TaskVehicleDriveToCoord(mechPed, mechVeh, loc.x, loc.y, loc.z, 20.0, 0, GetEntityModel(mechVeh), 524863, 2.0)
		test = mechVeh
		test1 = mechPed
		Active = true
    end
end

local timec = 0

Citizen.CreateThread(function()
    while true do
      	Citizen.Wait(1000)
        if Active then
            local loc = GetEntityCoords(GetPlayerPed(-1))
			local lc = GetEntityCoords(test)
			local ld = GetEntityCoords(test1)
            local dist = Vdist(loc.x, loc.y, loc.z, lc.x, lc.y, lc.z)
			local dist1 = Vdist(loc.x, loc.y, loc.z, ld.x, ld.y, ld.z)
			timec = timec + 1
            if dist <= 10 or dist1 <= 2 then
				if Active then
					TaskGoToCoordAnyMeans(test1, loc.x, loc.y, loc.z, 1.0, 0, 0, 786603, 0xbf800000)
				end
				if dist1 <= 1 then 
					Active = false
					ClearPedTasksImmediately(test1)
					DoctorNPC()
				end
			elseif timec == 45 then
				TaskLeaveAnyVehicle(test1)
				Citizen.Wait(5000)
				TaskGoToCoordAnyMeans(test1, loc.x, loc.y, loc.z, 1.0, 0, 0, 786603, 0xbf800000)
            end
		else
			timec = 0
			Citizen.Wait(1000)
        end
    end
end)

function DoctorNPC()
	RequestAnimDict("mini@cpr@char_a@cpr_str")
	while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
		Citizen.Wait(1000)
	end
	TaskPlayAnim(test1, "mini@cpr@char_a@cpr_str","cpr_pumpchest",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
	--exports['progressBars']:startUI(Config.ReviveTime, "The doctor is giving you medical aid")
	TriggerEvent("mythic_progbar:client:progress", {
        name = "ai_doc",
        duration = 30000,
        label = "The doctor is reviving you...",
        useWhileDead = true,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(status)
        if not status then
			ClearPedTasks(test1)
			Citizen.Wait(500)
			TriggerEvent('esx_ambulancejob:revive')
			StopScreenEffect('DeathFailOut')	
			RemovePedElegantly(test1)
			DeleteEntity(test)
			DeleteEntity(test1)
			ExecuteCommand("ooc [ID "..GetPlayerServerId(PlayerId()).." Tavasot NPC be dalil Shulughi Time Medic revive shod]")
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

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

local bleedingTimer
local ExtraTimeCD = false
RegisterCommand('extratime', function()
	if bleedingTimer > 0 and not ExtraTimeCD then
		ExtraTimeCD = true
		bleedingTimer = bleedingTimer + 900
	end
end, false)

function StartBleading()
	bleedingTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)

	Citizen.CreateThread(function()
		-- bleedout timer
		while bleedingTimer > 0 and InJure do
			Citizen.Wait(1000)
			bleedingTimer = bleedingTimer - 1
		end
		if bleedingTimer < 1 then
			OnPlayerDeath(-1)
		end
	end)

	Citizen.CreateThread(function()
		local text
		while bleedingTimer > 0 and InJure do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(bleedingTimer))
			if carblip and carblip ~= 0 then
				MainDrawTxt(0.910, 1.25, 1.0, 1.0, 0.5, "Medic Darkhast Shoma Ra Ghabool Karde Va Dar Rah Ast", 255, 255, 255, 255)
			end
			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end

RegisterNetEvent("gcphone:setUiPhone")
AddEventHandler("gcphone:setUiPhone", function(bank)
	ESX.SetPlayerData("bank", bank)
end)

function StartDeathTimer()
	local DeathTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)
	hold = 5
	Citizen.CreateThread(function()
		-- bleedout timer
		while DeathTimer > 0 and IsDead do
			Citizen.Wait(1000)
			DeathTimer = DeathTimer - 1
			if IsControlPressed(0, 38) and hold <= 0 then
				if ESX.GetPlayerData().bank >= 30000 then
					RemoveItemsAfterRPDeath(true)
					hold = 5
				else
					ESX.Alert("Shoma Pool Kafi Dar Bank Nadarid", "info")
					hold = 5
				end
            end
            if IsControlPressed(0, 38) then
                if hold - 1 >= 0 then
                    hold = hold - 1
                else
                    hold = 0
                end
            end
            if IsControlReleased(0, 38) then
                hold = 5
            end
		end
	end)

	Citizen.CreateThread(function()
		local text
		while DeathTimer > 0 and IsDead do
			Citizen.Wait(0)
			MainDrawTxt(0.910, 1.25, 1.0, 1.0, 0.5, "HOLD [~r~E~s~] FOR "..tostring(hold).." SECONDS TO RESPAWN FOR $~r~30,000~s~", 255, 255, 255, 255)
			text = _U('respawn_bleedout_in', secondsToClock(DeathTimer))
			DrawGenericTextThisFrame()
			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end

NewLifeTimeout = nil

RegisterNetEvent("esx_ambulancejob:RegisterNewLifePoint")
AddEventHandler("esx_ambulancejob:RegisterNewLifePoint", function(coord, time)
	exports.sr_main:RemoveByTag("newLifePoint")
	if NewLifeTimeout then
		ESX.ClearTimeout(NewLifeTimeout)
	end
	Citizen.Wait(1000)
	NewLifeTimeout = ESX.SetTimeout(time, function()
		exports.sr_main:RemoveByTag("newLifePoint")
		NewLifeTimeout = nil
	end)
	--[[local Point = RegisterPoint(vector3(coord.x, coord.y, coord.z), 50, true)
	Point.set("Tag", "newLifePoint")
	Point.set("InAreaOnce", function()
		--TriggerServerEvent("esx_ambulancejob:NearNewLifePoint")
	end)]]
end)

function RemoveItemsAfterRPDeath(remove)
	IsDead = false
	ExtraTimeCD = false
	ESX.SetPlayerData('IsDead', false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		Citizen.Wait(800)

		TriggerServerEvent('esx_ambulancejob:removeItemsAfterRPDeath', remove)
		Citizen.Wait(2000)
		local formattedCoords = {
			x = Config.RespawnPoint.coords.x,
			y = Config.RespawnPoint.coords.y,
			z = Config.RespawnPoint.coords.z
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)
		ESX.SetPlayerData('loadout', {})

		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.AfterDeathClothe.skin_male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.AfterDeathClothe.skin_female)
			end
			-- TriggerEvent('skinchanger:getSkin', function(skin)
			-- 	TriggerServerEvent('esx_skin:save', skin)
			-- end)
		end)
		exports.essentialmode:DisableControl(false)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)
		SetResourceKvpInt("dead", 0)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		Citizen.Wait(2600)
		TriggerEvent("dpclothingAbuse", false)
		TriggerEvent("dpemote:enable", true)
	end)
end

exports("RemoveItemsAfterRPDeath", RemoveItemsAfterRPDeath)

function RespawnPed(ped, coords, heading, health, armor)
	ESX.SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	ESX.SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	ESX.SetEntityHealth(ped, health or 200)
	if armor and armor > 0 then ESX.SetPedArmour(ped, armor) end
	ESX.UI.Menu.CloseAll()
end

AddEventHandler('capture:inCapture', function(bool)
	inCapture = bool
end)

exports("inCapture", function()
	return inCapture
end)

AddEventHandler('event:inEvent', function(bool)
	inEvent = bool
end)

AddEventHandler('AdminArea:InCircle', function(bool)
	inEvent = bool
end)

local HasClickedOnMenu = true

AddEventHandler('esx:onPlayerDeath', function(data)
	if inCapture then
		--[[local garage = {
			vector3(437.65, -594.47, 28.5),
			vector3(356.94, 286.13, 103.5),
			vector3(121.95, -1052.85, 29.19),
			vector3(253.7, -781.18, 30.57),
		}

		local army = { x = -2341.68, y = 3265.68, z = 32.83 }
		local formattedCoords

		if ESX.PlayerData.gang.name == 'Army' then
			formattedCoords = army
		else
			formattedCoords = garage[math.random(1, #garage)]
		end
		
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(PlayerPedId(), formattedCoords, 206.36)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		exports.esx_ambulancejob:ReviveAfterCaptureDeath(formattedCoords)
		HasClickedOnMenu = false]]
		return
	elseif inEvent then
		return
	else
		OnPlayerDeath(data.deathCause, data.killer)
	end
end)

function ReviveAfterCaptureDeath(Coords)-- HR_KoobsSystem
	Wait(1000)
	TriggerEvent("es_admin:freezePlayer", true)
	Wait(1000)
	TriggerEvent("es_admin:freezePlayer", false)
end

exports("ReviveAfterCaptureDeath", ReviveAfterCaptureDeath)

function OnCaptureKill()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'capture_ask_question', {
		title = "Capture Menu",
		align = 'center',
		elements = {
			{
				label = "Teleport To Capture(Parachute)", 
				value = 'tp',
			},
			{
				label = "Get Vehicle(BF400)", 
				value = "veh",
			},
			{
				label = "Get Vehicle(Neon)", 
				value = "neno",
			},
			{
				label = "Capture Shop", 
				value = "shop",
			},
			{
				label = "Exit Menu", 
				value = "forceexit",
			}
		}
	}, function(data, menu)
		HasClickedOnMenu = true
		if data.current.value == 'tp' then
			TriggerEvent("capture:GetCaptureCoords", function(Coords)
				if Coords == nil then menu.close() return end
				menu.close()
				CPRevive(function()
					exports.essentialmode:DisableControl(false)
					SetEntityCollision(PlayerPedId(), false, false)
					EnableAllControlActions(0)
					EnableAllControlActions(1)
					EnableAllControlActions(2)
					Wait(500)
					DoScreenFadeOut(1000)
					ESX.SetEntityCoords(PlayerPedId(), Coords.x-230.0, Coords.y-230.0, Coords.z+1500.0)
					Wait(2500)
					ESX.SetEntityCoords(PlayerPedId(), Coords.x-230.0, Coords.y-230.0, Coords.z+1500.0)
					DoScreenFadeIn(2000)
					Wait(6000)
					ForcePedToOpenParachute(PlayerPedId())
					SetEntityCollision(PlayerPedId(), true, true)
				end)
			end)
		elseif data.current.value == 'veh' then
			GiveCar("bf400")
			menu.close()
		elseif data.current.value == "neno" then
			GiveCar("neon")
			menu.close()
		elseif data.current.value == 'shop' then
			ShopMenu()
		elseif data.current.value == 'forceexit' then
			menu.close()
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
		OnCaptureKill()
	end)
end

function ShopMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'capture_ask_shop', {
		title = "Capture Menu",
		align = 'center',
		elements = {
			{
				label = "Kheshab : 3000$", 
				value = 'clip',
			},
			{
				label = "Armor 50 : 60000$", 
				value = "armor",
			}
		}
	}, function(data, menu)
		if data.current.value == 'clip' then
			ESX.TriggerServerCallback("Capture:CanIBuyThatFuckinShit", function(what) 
				if what then
					ESX.ShowNotification("~y~Shoma 1 Kheshab Kharidid")
				else
					ESX.ShowNotification("~r~Shoma Pool Kafi Nadarid")
				end
			end, "clip")
		elseif data.current.value == 'armor' then
			ESX.TriggerServerCallback("Capture:CanIBuyThatFuckinShit", function(what) 
				if what then
					ESX.ShowNotification("~y~Shoma 1 Armour Kharidid")
				else
					ESX.ShowNotification("~r~Shoma Pool Kafi Nadarid")
				end
			end, "armour")
		end
	end, function(data, menu)
		menu.close()
		HasClickedOnMenu = false
		OnCaptureKill()	
	end)
end

function GiveCar(type)
	ESX.Game.SpawnLocalVehicle(type, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(Veh)
		TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
	end)
end

function BugHandler()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)
			if not HasClickedOnMenu then
				ESX.UI.Menu.CloseAll()
				OnCaptureKill()
			end
		end
	end)
end

exports("BugHandler", BugHandler)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        if GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
            if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(attacker)) then
                if GetPlayerServerId(PlayerId()) ~= GetPlayerServerId(GetPlayerByEntityID(victim)) then
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'hit', 0.55)
                end
            end
        end
    end
end)

function GetPlayerByEntityID(id)
	for i=0,255 do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
	end
	return nil
end

RegisterNetEvent("esx_ambulancejob:ReviveNoEffects")
AddEventHandler("esx_ambulancejob:ReviveNoEffects", function(cb)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	IsDead = false
	InJure = false
	ExtraTimeCD = false
	exports.essentialmode:DisableControl(false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	ESX.SetPlayerData('IsDead', false)
	Citizen.CreateThread(function()
		--DoScreenFadeOut(800)

		Citizen.Wait(800)

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)
		SetResourceKvpInt("dead", 0)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		local armor = GetPedArmour(PlayerPedId())
		RespawnPed(playerPed, formattedCoords, 0.0, health)

		ESX.SetPedArmour(PlayerPedId(), armor)

		StopScreenEffect('DeathFailOut')
		--DoScreenFadeIn(800)
		ClearPedTasksImmediately(PlayerPedId())
	end)
	cb()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(health)
	local resourceName = GetInvokingResource()
	if resourceName and not GlobalState.resources[resourceName] then return end
	if carrying then
		TriggerEvent('esx_ambulancejob:chnageDeathCoords', GetEntityCoords(PlayerPedId()))
		Citizen.Wait(1000)
		TriggerEvent('esx_ambulancejob:pausedDeath', false)
		TriggerServerEvent("carry:stop")
	end
	paused = false
	Active = false
	Crawling = false
	inAction = false
	if exports['diamond_utils']:IsPlayerProne() then 
		exports['diamond_utils']:toggleCrawl(false)
	end
	TriggerServerEvent("esx_ambulancejob:crawlState", nil)
	ESX.ClearTimeout(CrawlTimer)
	ESX.SetPlayerState("Crawling", false)
	RemovePedElegantly(test1)
	DeleteEntity(test)
	DeleteEntity(test1)
	DecorSetInt(PlayerPedId(), 'Injured', 0)
	DecorSetInt(PlayerPedId(), 'IsDead', 0)
	DecorSetInt(PlayerPedId(), 'KilledBy', 0)
	carrying = false
	holdingBody = false
	Citizen.Wait(10)
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
	ClearPedTasks(PlayerPedId())
	DetachEntity(GetPlayerPed(-1), true, false)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	IsDead = false
	InJure = false
	ExtraTimeCD = false
	exports.essentialmode:DisableControl(false)
	SetResourceKvpInt("dead", 0)
	TriggerEvent("dpclothingAbuse", false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	ESX.SetPlayerData('IsDead', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		Citizen.Wait(800)

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		local armor = GetPedArmour(PlayerPedId())
		RespawnPed(playerPed, formattedCoords, 0.0, health)

		ESX.SetPedArmour(PlayerPedId(), armor)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		ClearPedTasksImmediately(PlayerPedId())
		Citizen.Wait(2600)
		TriggerEvent("dpclothingAbuse", false)
		TriggerEvent("dpemote:enable", true)
	end)
end)

function CPRevive(cb)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	IsDead = false
	InJure = false
	ExtraTimeCD = false
	exports.essentialmode:DisableControl(false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	ESX.SetPlayerData('IsDead', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		Citizen.Wait(800)

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		local armor = GetPedArmour(PlayerPedId())
		RespawnPed(playerPed, formattedCoords, 0.0, 200)

		ESX.SetPedArmour(PlayerPedId(), armor)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		Citizen.Wait(2000)
		cb()
	end)
end

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end
------->>>>>>>>>>>>>

local holdingBody = false
local carrying = false
local clicked = false

RegisterNetEvent("HR_Carry:AskToCarry")
AddEventHandler("HR_Carry:AskToCarry", function()
	if not ESX.GetPlayerData().BlockCarry and not ESX.GetPlayerData().isSentenced then
		carryAsking = true
		SetTimeout(500, AskAbout)
	else
		TriggerServerEvent("HR_Carry:RestoreCarry")
	end
end)

function AskAbout()
	SetTimeout(1000, RollBack)
	print(carrying, holdingBody)
	if carrying or holdingBody then 
		return
	end
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
	{
		title 	 = 'Darkhast Carry',
		align    = 'center',
		question = "Yek Shakhs Darkhast Carry Shoma Ra Darad! Aya Ghabool Mikonid?",
		elements = {
			{label = 'Bale', value = 'yes'},
			{label = 'Kheyr', value = 'no'},
		}
	}, function(data, menu)
		if data.current.value == "yes" then
			clicked = true
			TriggerServerEvent("HR_Carry:AcceptCarry")
			menu.close()
		elseif data.current.value == "no" then
			clicked = true
			TriggerServerEvent("HR_Carry:DeclineCarry")
			menu.close()
		end
		carryAsking = false
	end)
end

function RollBack()
	SetTimeout(15000, function()
		if not clicked then
			TriggerServerEvent("HR_Carry:RestoreCarry")
			ESX.UI.Menu.CloseAll()
		end
		clicked = false
		carryAsking = false
	end)
end

RegisterNetEvent('carry:syncTarget')
AddEventHandler('carry:syncTarget', function(target)
	if exports['diamond_utils']:IsPlayerProne() then 
		exports['diamond_utils']:toggleCrawl(true)
	end
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	ClearPedTasks(PlayerPedId())
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carrying = true
	exports.essentialmode:DisableControl(true)
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
	ESX.ShowNotification('Dokmeye E Baraye Tavaghof Carry')
	ESX.Alert('Dokmeye E Baraye Tavaghof Carry', "info")
	TriggerEvent('esx_ambulancejob:pausedDeath', true)
	while carrying do
		DisableControlAction(1, 19, true)
		DisableControlAction(0, 34, true)
		DisableControlAction(0, 9, true)
		DisableControlAction(0, 288, true)
		DisableControlAction(0, 289, true)
		DisableControlAction(0, 170, true)
		DisableControlAction(0, 73, true)
		DisableControlAction(0, 79, true)
		DisableControlAction(0, 305, true)
		DisableControlAction(0, 82, true)
		DisableControlAction(0, 182, true)
		DisableControlAction(0, 32, true)
		DisableControlAction(0, 8, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(1, 33, true)
		DisableControlAction(1, 34, true)
		DisableControlAction(1, 35, true)
		DisableControlAction(1, 21, true)  -- space
		DisableControlAction(1, 22, true)  -- space
		DisableControlAction(0, 23, true)  -- F
		DisableControlAction(1, 24, true)  -- F
		DisableControlAction(1, 25, true)  -- F
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions 
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(playerPed, true) -- Disable weapon firing
		if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
			DisableControlAction(0, 71, true)
			DisableControlAction(0, 72, true)
		end
		if not IsEntityPlayingAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
			loadAnim("amb@world_human_bum_slumped@male@laying_on_left_side@base")
			TaskPlayAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
		end
		if IsControlJustPressed(0, 38) then
			carrying = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			TriggerServerEvent("carry:stop")
		end
		Citizen.Wait(3)
	end
end)

RegisterNetEvent('carry:syncMe')
AddEventHandler('carry:syncMe', function()
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	local playerPed = GetPlayerPed(-1)
	ClearPedTasks(PlayerPedId())
	exports.essentialmode:DisableControl(true)
	ESX.ShowNotification('Dokmeye E Baraye Tavaghof Carry')
	ESX.Alert('Dokmeye E Baraye Tavaghof Carry', "info")
	carrying = true
	while carrying do
		DisableControlAction(0, 23, true)  -- F
		DisableControlAction(1, 24, true)  -- F
		DisableControlAction(1, 25, true)  -- F
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions 
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(playerPed, true) -- Disable weapon firing
		if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
			DisableControlAction(0, 71, true)
			DisableControlAction(0, 72, true)
		end
		if not IsEntityPlayingAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
			loadAnim("missfinale_c2mcs_1")
			TaskPlayAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
		end
		if IsControlJustPressed(0, 38) then
			carrying = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			TriggerServerEvent("carry:stop")
		end
		Citizen.Wait(3)
	end
end)

RegisterNetEvent('carry:stop')
AddEventHandler('carry:stop', function()
	carrying = false
	holdingBody = false
	exports.essentialmode:DisableControl(false)
	TriggerEvent("dpemote:enable", true)
	TriggerEvent("dpclothingAbuse", false)
	ClearPedTasks(PlayerPedId())
	DetachEntity(GetPlayerPed(-1), true, false)
	TriggerEvent('esx_ambulancejob:chnageDeathCoords', GetEntityCoords(PlayerPedId()))
	Wait(1000)
	TriggerEvent('esx_ambulancejob:pausedDeath', false)
	if Crawling then
		if not exports['diamond_utils']:IsPlayerProne() then 
			exports['diamond_utils']:toggleCrawl(true)
		end
	end
end)

function carryPed(ped)

	TriggerEvent('notification', 'Press E to release carry.')

	loadAnim('anim@narcotics@trash')
	TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0) 
	TaskTurnPedToFaceEntity(PlayerPedId(), ped, 1.0)

	

	SetBlockingOfNonTemporaryEvents(ped, true)		
	SetPedSeeingRange(ped, 0.0)		
	SetPedHearingRange(ped, 0.0)		
	SetPedFleeAttributes(ped, 0, false)		
	SetPedKeepTask(ped, true)	

	loadAnim( "dead" ) 
	TaskPlayAnim(ped, "dead", "dead_f", 8.0, 8.0, -1, 1, 0, 0, 0, 0)

	DetachEntity(ped)
	ClearPedTasks(ped)
	loadAnim( "amb@world_human_bum_slumped@male@laying_on_left_side@base" ) 
	TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
	attachCarryPed(ped)
	holdingBody = true
	ClearPedTasksImmediately(PlayerPedId())
	while (holdingBody) do

		Citizen.Wait(1)


		if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
			loadAnim( "missfinale_c2mcs_1" ) 
			TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)

		end

		
		if IsControlJustPressed(0, 38) or (`WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId()))  then
			holdingBody = false
			DetachEntity(ped)
			ClearPedTasks(ped)
		end


	end
	ClearPedTasks(PlayerPedId())	  
	DetachEntity(ped)
end

function attachCarryPed(ped)
	AttachEntityToEntity(ped, PlayerPedId(), 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
	loadAnim( "missfinale_c2mcs_1" ) 
	TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
end

function loadAnim( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

local itemscreaft = { 
	['proplus'] = 22000,
	['desomorphine'] = 16000,
	['modafinil'] = 20000,
	['Ibuprofen'] = 12000,
	['wellbutrin'] = 18000,
	['sianor'] = 15000,
	["adr"] = 50000,
}

local oskol = false

function OpenBuyMenu()
	local elem = {}
	ESX.TriggerServerCallback("esx_ambulancejob:getDrugstock", function(amount) 
		ESX.UI.Menu.CloseAll()
		for k, v in pairs(itemscreaft) do
			table.insert(elem, { label = firstToUpper(k)..": "..ESX.Math.GroupDigits(v).."$ ["..amount[k].."x]", value = k})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_mechanic', {
			title    = 'Mechanic Buy',
			align    = 'top-left',
			elements = elem
		}, function(data, menu)
			if amount[data.current.value] > 0 then
				if ESX.GetPlayerData().money > itemscreaft[data.current.value] then
					TriggerServerEvent("esx_ambulancejob:getDrugItem", data.current.value)
					ESX.Alert("Shoma Yek "..firstToUpper(data.current.value).." Kharidid", "check")
					menu.close()
					oskol = false
				else
					ESX.Alert("Shoma Pool Kafi Nadarid", "error")
				end
			else
				ESX.Alert("Tedad In Item Kafi Nist", "error")
			end
		end, function(data, menu)
			menu.close()
			oskol = false
		end)
	end)
end

function BuyThread()
	local Point = RegisterPoint(vector3(-665.67,322.43,83.09), 5, true)
    Point.set("Tag", "ambulancedrug")
    Point.set("InArea", function()
        DrawMarker(42, vector3(-665.67,322.43,83.09), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
        if #(GetEntityCoords(PlayerPedId()) - vector3(-665.67,322.43,83.09)) < 1.2 then
            ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Tajhizat')
            if IsControlJustReleased(0, 38) and not oskol then
				oskol = true
                OpenBuyMenu()
            end
        end
    end)
	Point.set("OutAreaOnce", function()
		ESX.UI.Menu.CloseAll()
		oskol = false
	end)
end

function BuyThread2()
	local Point = RegisterPoint(vector3(1772.9,3658.81,34.85), 5, true)
    Point.set("Tag", "ambulancedrug")
    Point.set("InArea", function()
        DrawMarker(42, vector3(1772.9,3658.81,34.85), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
        if #(GetEntityCoords(PlayerPedId()) - vector3(1772.9,3658.81,34.85)) < 1.2 then
            ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Tajhizat')
            if IsControlJustReleased(0, 38) and not oskol then
				oskol = true
                OpenBuyMenu()
            end
        end
    end)
	Point.set("OutAreaOnce", function()
		ESX.UI.Menu.CloseAll()
		oskol = false
	end)
end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function AboGhaza()
	exports.sr_main:RemoveByTag("aboghaza")
	Citizen.Wait(500)
	local coords = {
		vector3(462.99,-980.16,30.69), -- police
		vector3(-670.85,338.6,83.09), -- Ambulance
		vector3(1363.19,-713.16,74.16), -- mechanic Centeral  
		vector3(891.87,-158.34,78.4), -- Taxi 
		vector3(124.66,-730.3,242.15), --fbi
		vector3(-573.74,-1791.49,26.84), -- Mechanic Benny 
		vector3(604.98,-10.67,91.54), -- Special Forces
		vector3(-1688.9,-753.43,11.24), -- Weazel
		vector3(-568.44,-194.22,37.22), -- justice  
		vector3(1838.42,3687.61,38.93), -- sheriff  
		vector3(1785.75,3649.6,34.85),  -- medic sandy
		vector3(-1071.28,-807.97,25.85), --pd central
	}
	for k, v in pairs(coords) do
		local IPoint
		local Key
		local Point = RegisterPoint(vector3(v.x, v.y, v.z), 5, true)
		Point.set("Tag", "aboghaza")
		Point.set("InArea", function()
			ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan Ab o Ghaza", vector3(v.x, v.y, v.z))
        	DrawMarker(0, vector3(v.x, v.y, v.z), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 150, 200, 255, 0, 0, 0, 0)
		end)
		Point.set("InAreaOnce", function()
			IPoint = RegisterPoint(vector3(v.x, v.y, v.z), 1.5, true)
			IPoint.set("Tag", "aboghaza")
			IPoint.set('InAreaOnce', function ()
				Hint:Delete()
				Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gereftan Ab o Ghaza')
				Key = RegisterKey('E', false, function()
					Key = UnregisterKey(Key)
					TriggerEvent('esx_status:setirs', 'hunger', 1000000)
					TriggerEvent('esx_status:setirs', 'thirst', 1000000)
					--TriggerEvent('esx_status:setirs', 'mental', 1000000)
					ESX.Alert("Ab o Ghaza Shoma Full Shod", "check")
				end)
			end, function()
				Hint:Delete()
				Key = UnregisterKey(Key)
			end)
		end, function()
			if IPoint then
				IPoint = IPoint.remove()
			end
		end)
    end
end

local globalvehicle = {active = false}
local progressing = {active = false, vehicle = 0}

local blacklist = {
	[GetHashKey("club")] = true,
	[GetHashKey("blista")] = true,
	[GetHashKey("brioso")] = true,
	[GetHashKey("asbo")] = true,
	[GetHashKey("kanjo")] = true,
	[GetHashKey("panto")] = true,
	[GetHashKey("rhapsody")] = true,
	[GetHashKey("issi2")] = true,
	[GetHashKey("bestiagts")] = true,
	[GetHashKey("blista2")] = true,
	[GetHashKey("gtrnismo17")] = true,
	[GetHashKey("i8")] = true,
	[GetHashKey("rmodlp750")] = true,
	[GetHashKey("rmodlp770")] = true,
	[GetHashKey("lex570")] = true,
	[GetHashKey("16challenger")] = true,
	[GetHashKey("raptor150")] = true,
	[GetHashKey("futo")] = true,
	[GetHashKey("polvacca")] = true,
	[GetHashKey("vacca")] = true,
	[GetHashKey("polneon")] = true,
	[GetHashKey("bmwg20")] = true,
	[GetHashKey("comet")] = true,
	[GetHashKey("comet2")] = true,
	[GetHashKey("comet3")] = true,
	[GetHashKey("comet4")] = true,
	[GetHashKey("comet5")] = true,
	[GetHashKey("dilettante")] = true,
	[GetHashKey("dilettante2")] = true,
	[GetHashKey("prairie")] = true,
	[GetHashKey("f620")] = true,
	[GetHashKey("oracle")] = true
}

AddEventHandler("esx:LeaveTrunk", function(veh)
	if not inTrunk then
		sendMessage("Shoma dakhel sandogh nistid")
		return
	end

	local ped = PlayerPedId()
	local vehicle = GetEntityAttachedTo(ped)

	if DoesEntityExist(vehicle) then

		local locked = GetVehicleDoorsLockedForPlayer(vehicle)

		if not locked then
			
			--if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
				ExecuteCommand("e Shoro mikone be dasto pa zadan va sai mikone az sandogh biron biyad")
				TriggerEvent("mythic_progbar:client:progress", {
					name = "leaving_trunk",
					duration = 15000,
					label = "Dar hale kharej shodan az sandogh",
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

						--[[if GetVehicleDoorAngleRatio(vehicle, 5) <= 0 then
							sendMessage("Sandogh mashin baste ast nemitavanid kharej shavid!")
							return
						end]]

						local locked = GetVehicleDoorsLockedForPlayer(vehicle)

						if locked then
							sendMessage("Dar mashin mored nazar ghofl ast nemitavanid kharej shavid!")
							return
						end

						if leaveTrunk(true) then
							TriggerServerEvent('esx_carry:leaveTrunk')
						end
					end
				end)
		
			--[[else
				sendMessage("Sandogh mashin baste ast nemitavanid kharej shavid!")
			end]]
		else
			sendMessage("Dar mashin mored nazar ghofl ast nemitavanid kharej shavid!")
		end

	else
		sendMessage("Shoma dakhel hich mashini nistid")
	end
end)

AddEventHandler("esx:GetInTrunk", function(veh)
	if ESX.GetPlayerData().isSentenced or ESX.GetPlayerData().isDead or ESX.GetPlayerData().jailed then return end
	if carrying then
		sendMessage("Shoma nemitavanid hengam carry shodan/kardan vared sandogh shavid")
		return
	end

	if inTrunk then
		sendMessage("Shoma dar hale hazer dar sandogh yek mashin hastid")
		return
	end

		local vehicle = veh

		if DoesEntityExist(vehicle) then

			local model = GetEntityModel(vehicle)

			if blacklist[model] then
				sendMessage("In mashin fazaye khali baraye vared shodan nadarad!")
				return
			end

			if not GetIsDoorValid(vehicle, 5) then
				sendMessage("In mashin fazaye khali baraye vared shodan nadarad!")
				return
			end

			local locked = GetVehicleDoorsLockedForPlayer(vehicle)

			if not locked then
				
				--if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
					local netID = VehToNet(vehicle)
					ESX.TriggerServerCallback('esx_carry:canStoreInVehicle', function(canStore)
						if canStore then
							SetVehicleDoorOpen(vehicle, 5, false, false)
							ExecuteCommand("me Shoro mikone be vared shodan be sandogh")
							activeProgress(vehicle)
							TriggerEvent("mythic_progbar:client:progress", {
								name = "getin_trunk",
								duration = 10000,
								label = "Dar hale vared shodan be sandogh",
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

									resetProgress()

									--[[if GetVehicleDoorAngleRatio(vehicle, 5) <= 0 then
										sendMessage("Sandogh mashin baste ast nemitavanid vared shavid!")
										return
									end]]
			
									locked = GetVehicleDoorsLockedForPlayer(vehicle)

									if not DoesEntityExist(vehicle) then return end

									local dis = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))

									if dis >= 5.0 then return end

									if locked then
										sendMessage("Dar mashin mored nazar ghofl ast nemitavanid vared shavid!")
										return
									end

									ESX.TriggerServerCallback('esx_carry:canStoreInVehicle', function(canStore)
										if canStore then
											SetVehicleDoorOpen(vehicle, 5, false, false)
											if getInTrunk(vehicle) then
												TriggerServerEvent('esx_carry:getInTrunk', netID)
											end
										else
											sendMessage("Dar hale hazer shakhs digari dar sandogh in mashin hast!")
										end
									end, netID)

								else
									resetProgress()
								end
							end)	
							
						else
							sendMessage("Dar hale hazer shakhs digari dar sandogh in mashin hast!")
						end
					end, netID)
				--[[else
					sendMessage("Sandogh mashin baste ast lotfan sandogh ra baz konid!")
				end]]
			else
				sendMessage("Dar mashin mored nazar ghofl ast!")
			end

		else
			sendMessage("Shoma nazdik hich mashini nistid")
		end

end)

function sendMessage(message)
    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0" .. message}})
end

function getInTrunk(vehicle)
	local model = GetEntityModel(vehicle)
	if blacklist[model] then
		return
	end
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	exports.essentialmode:DisableControl(true)
	ESX.SetPlayerData('isSentenced', true)
	local ped = PlayerPedId()
	SetEntityCollision(ped, false, false)
	ESX.SetPlayerData('robbing', 1)
	AttachEntityToEntity(ped, vehicle, -1, 0.0, -2.2, 0.4, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
	RequestAnimDict("timetable@floyd@cryingonbed@base")

	while not HasAnimDictLoaded("timetable@floyd@cryingonbed@base") do
		Citizen.Wait(10)
	end

	
	TaskPlayAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
	
	carryAnimNamePlaying = "base"
	carryAnimDictPlaying = "timetable@floyd@cryingonbed@base"
	carryControlFlagPlaying = 1
	inTrunk = true
	globalvehicle = {active = true, handle = vehicle, netid = VehToNet(vehicle)}
	ESX.SetPlayerData('InTrunk', 1)
	SetVehicleDoorShut(globalvehicle.handle, 5, false)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	CreateThread(SyncVehicle)
	CreateThread(KeysDisable)
	return true
end

function KeysDisable()
	Citizen.CreateThread(function()
		while globalvehicle.active and DoesEntityExist(globalvehicle.handle) do 
			Citizen.Wait(3)
			DisableControlAction(0, 37, true)
		end
	end)
end

function SyncVehicle()
	Citizen.CreateThread(function()
		while globalvehicle.active and DoesEntityExist(globalvehicle.handle) do
			Citizen.Wait(1000)
			if not IsEntityPlayingAnim(PlayerPedId(), "timetable@floyd@cryingonbed@base", 'base', 1) then
				TaskPlayAnim(PlayerPedId() 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
			end
		end
		leaveTrunk(true)
	end)
end

function leaveTrunk(deattach)
	if inTrunk then
		local ped = PlayerPedId()
		inTrunk = false
		ESX.SetPlayerData('InTrunk', 0)
		ESX.SetPlayerData('robbing', 0)
		ClearPedTasks(ped)
		TriggerEvent("dpemote:enable", true)
		TriggerEvent("dpclothingAbuse",false)
		exports.essentialmode:DisableControl(false)
		ESX.SetPlayerData('isSentenced', false)
		if deattach then
			DetachEntity(ped)
		end
		SetVehicleDoorShut(globalvehicle.handle, 5, false)
		globalvehicle = {active = false}
		return true
	else
		return false
	end
end

function activeProgress(vehicle)
	progressing.active = true
	progressing.vehicle = vehicle
end

function resetProgress()
	progressing.active = false
	progressing.vehicle = 0
end

local res = {
	["police"] = vector3(-1094.06,-832.66,19.32),
	["sheriff"] = vector3(1830.79,3682.41,34.33),
	["forces"] = vector3(620.43,8.3,83.64),
	["justice"] = vector3(-552.42,-202.76,38.24),
	["ambulance"] = vector3(-675.33,330.7,83.08),
	["weazel"] = vector3(-1707.27,-750.95,11.24),
	["medic"] = vector3(1741.91,3638.98,34.85),
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		SetPedMaxTimeUnderwater(PlayerPedId(), 50.0)
		if PlayerData and PlayerData.job and res[PlayerData.job.name] then
			local coord = res[PlayerData.job.name]
			local my = GetEntityCoords(PlayerPedId())
			local dis = #(coord - my)
			if dis <= 10.0 then
				TriggerEvent('esx_Quest:point', 'Reception', nil, 1)
			end
		end
	end
end)

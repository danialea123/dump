---@diagnostic disable: undefined-global, undefined-field
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local Status = {}
local PlayerData


function GetStatusData(minimal)
	local status = {}
	local ped = GetPlayerPed(-1)

	for i=1, #Status, 1 do

		if minimal then

			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				percent = (Status[i].val / Config.StatusMax) * 100,
			})

		else

			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				color   = Status[i].color,
				visible = Status[i].visible(Status[i]),
				max     = Status[i].max,
				percent = (Status[i].val / Config.StatusMax) * 100,
			})

		end

	end

	local pedhealth = GetEntityHealth(ped)

	if pedhealth < 100 then
	  pedhealth = 0
	else
	  pedhealth = pedhealth - 100
	end

	table.insert(status, {
		name	= 'health',
		val		= pedhealth,
		percent	= pedhealth
	})

	local armor = GetPedArmour(ped)
	
	table.insert(status, {
		name	= 'armor',
		val		= armor ,
		percent	= armor
	})
	return status
end

AddEventHandler('esx_status:registerStatus', function(name, default, color, visible, tickCallback)
	local s = CreateStatus(name, default, color, visible, tickCallback)
	table.insert(Status, s)
end)

local health = 200
local armor	 = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	for i=1, #Status, 1 do
		for j=1, #PlayerData.status, 1 do
			if Status[i].name == PlayerData.status[j].name then
				Status[i].set(PlayerData.status[j].val)
			elseif PlayerData.status[j].name == 'health' then
				health = tonumber(PlayerData.status[j].val) + 100
			elseif PlayerData.status[j].name == 'armor' then
				armor = tonumber(PlayerData.status[j].val)
			end
		end
	end

	Citizen.CreateThread(function()
	  	while true do
			Citizen.Wait(750)
			for i=1, #Status, 1 do
				Status[i].onTick()
			end
	
			TriggerEvent('esx_customui:updateStatus', GetStatusData(true))
			if ESX.GetPlayerData().Level >= 14 then
				Citizen.Wait(Config.TickTime*1.2)
			else
				Citizen.Wait(Config.TickTime)
			end
	  	end
	end)
end)

local jh = {
	["police"] = true,
	["sheriff"] = true,
	["fbi"] = true,
	["forces"] = true,
}

RegisterNetEvent('esx_status:setLastStatsirs')
AddEventHandler('esx_status:setLastStatsirs', function()
	local ped = GetPlayerPed(-1)
	ESX.SetEntityHealth(ped, health)
	if armor > 0 then
		ESX.SetPedArmour(ped, armor)
		if jh[PlayerData.job.name] then
			if PlayerData.job.name == "police" then 
				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						local clothesSkin = {
							['bproof_1'] = 82,  ['bproof_2'] = 0,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					elseif skin.sex == 1 then
						local clothesSkin = {
							['bproof_1'] = 67,  ['bproof_2'] = 0,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					end
				end)
			end

			if PlayerData.job.name == "sheriff" then 

				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						local clothesSkin = {
							['bproof_1'] = 82,  ['bproof_2'] = 1,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					elseif skin.sex == 1 then
						local clothesSkin = {
							['bproof_1'] = 67,  ['bproof_2'] = 1,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					end
				end)
			end

			if PlayerData.job.name == "fbi" then 

				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						local clothesSkin = {
							['bproof_1'] = 82,  ['bproof_2'] = 2,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					elseif skin.sex == 1 then
						local clothesSkin = {
							['bproof_1'] = 118,  ['bproof_2'] = 0,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					end
				end)
			end

			if PlayerData.job.name == "forces" then 
				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						local clothesSkin = {
							['bproof_1'] = 65,  ['bproof_2'] = 4,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					elseif skin.sex == 1 then
						local clothesSkin = {
							['bproof_1'] = 67,  ['bproof_2'] = 3,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					end
				end)
			end
		else
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['bproof_1'] = 23,  ['bproof_2'] = 9,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				elseif skin.sex == 1 then
					local clothesSkin = {
						['bproof_1'] = 20,  ['bproof_2'] = 9,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
			end)
		end
	else
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['bproof_1'] = 0,  ['bproof_2'] = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end
end)

RegisterNetEvent('esx_status:setirs')
AddEventHandler('esx_status:setirs', function(name, val)	
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData(true))
end)

RegisterNetEvent('esx_status:add')
AddEventHandler('esx_status:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData(true))
end)

RegisterNetEvent('esx_status:remove')
AddEventHandler('esx_status:remove', function(name, val)	
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData(true))
end)

AddEventHandler('esx_status:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

-- Loaded event
Citizen.CreateThread(function()
	TriggerEvent('esx_status:loaded')
end)

-- Update server
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.UpdateInterval)
		TriggerServerEvent('esx_status:update', GetStatusData(true))
	end
end)
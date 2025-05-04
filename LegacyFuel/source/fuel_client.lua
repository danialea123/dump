---@diagnostic disable: undefined-global, lowercase-global, missing-parameter, param-type-mismatch
Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

		Citizen.Wait(500)
	end
end)

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false
local menuOpen
local LastSyncValue = 0
local npcPed = nil
local npcBlip = nil
local currentStationId = nil

Locations ={
	[1] ={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[2]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[3]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[4]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[5]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[6]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[7]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[8]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[9]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[10]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[11]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[12]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[13]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[14]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[15]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[16]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[17]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[18]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[19]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[20]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[21]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[22]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[23]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[24]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[25]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[26]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
	[27]={
		["blip"]={
			['x']=1,['y']=1,['z']=1,
		}
	},
}

for i = 1, #Locations do
	Locations[i]['blip']['x'] = Config.GasStations[i].coord.x
	Locations[i]['blip']['y'] = Config.GasStations[i].coord.y
	Locations[i]['blip']['z'] = Config.GasStations[i].coord.z
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		if IsPedInAnyVehicle(PlayerPedId()) then
			if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 14 then
				TriggerEvent('esx_Quest:point', 'DriveBoat', nil, 1)
			end
		end
	end
end)

RegisterNetEvent('LegacyFuel:setFuelClient')
AddEventHandler('LegacyFuel:setFuelClient', function(netId, fuel, source)
	if not ESX then return end
	if not ESX.Game.DoesPlayerExistInArea(source) then return end
	if not tonumber(fuel) or not tonumber(netId) or fuel > 100.0 or fuel < 0.0 then
		return
	end
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if DoesEntityExist(vehicle) then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
	end
end)

function GetFuel(vehicle)
	return Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
end

function SetFuel(vehicle, fuel)
	if not DoesEntityExist(vehicle) or not tonumber(fuel) or fuel > 100.0 or fuel < 0.0 then
		return
	end
	local netId = NetworkGetNetworkIdFromEntity(vehicle)
    SetVehicleFuelLevel(vehicle, fuel + 0.0)
    Entity(vehicle).state.fuel = fuel + 0.0
	TriggerServerEvent('LegacyFuel:setFuel', netId, fuel)
end

function SyncFuelToAll(vehicle, percent)
    local fuel = GetFuel(vehicle)
    if LastSyncValue - fuel > percent then
        SetFuel(vehicle, fuel)
        LastSyncValue = fuel
    end
    if fuel > LastSyncValue then
        LastSyncValue = fuel
    end
end

Citizen.CreateThread(function()
	while true do
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                SyncFuelToAll(vehicle, Config.SyncPercent)
            end
        end
		Citizen.Wait(10000)
	end
end)

function SyncFuel(vehicle, fuel)
	if DoesEntityExist(vehicle) and IsEntityAMissionEntity(vehicle) then
		ESX.TriggerServerCallback('LegacyFuel:syncFuel', function() end, NetworkGetNetworkIdFromEntity(vehicle),fuel or GetFuel(vehicle),ESX.Game.GetPlayersToSend(300))
	end
end

local VIPRewards =
{
	bronze = false,
	silver = true,
	gold = true,
	premium = true
}

AddEventHandler("PlayerLoadedToGround", function()
	local playerData = ESX.GetPlayerData()

	if VIPRewards[playerData.group] then 
		Config.FuelUsage = {
			[1.0] = 1.7,
			[0.9] = 1.6,
			[0.8] = 1.5,
			[0.7] = 1.4,
			[0.6] = 1.3,
			[0.5] = 1.2,
			[0.4] = 1.1,
			[0.3] = 1.0,
			[0.2] = 0.9,
			[0.1] = 0.8,
			[0.0] = 0.7,
		}
		AlertRewards()
	end
end)

function AlertRewards()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5*60*1000)
			if IsPedInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
				if VIPRewards[ESX.GetPlayerData().group] then 
					ESX.Alert("Masraf Benzin Mashin Shoma 50% Kamtar Shode Ast (VIP)", "info")
				end
			end
		end
	end)
end

-- Remove fuel based on RPM, find nearest pump object
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed)
			if not ArrayHasValue(Config.Blacklist, GetEntityModel(vehicle)) and GetPedInVehicleSeat(vehicle, -1) == playerPed and IsVehicleEngineOn(vehicle) then
				local fuelToRemove = (Config.FuelUsage[FuelRound(GetVehicleCurrentRpm(vehicle), 1)] or 0.0) * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10.0
                -- Update locally in real time
                local fuel = GetFuel(vehicle) - fuelToRemove
                Entity(vehicle).state.fuel = fuel + 0.0
                SetVehicleFuelLevel(vehicle, fuel + 0.0)
			end
		end
		local pumpObject, pumpDistance = FindNearestFuelPump()
		if pumpObject ~= 0 and pumpDistance < 3.2 then
			NearestPump = pumpObject
		else
			NearestPump = nil
		end
		NearestVehicle = GetClosestVehicle2(GetEntityCoords(playerPed), 5.0)
	end
end)

local num

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local id = localGasStation()
		if not id then
			num = 100
			if not Config.GasStations[num] then
				Config.GasStations[num] = {
					gasVal = 10000,
					gasPrice = 120,
				}
			end
		else
			num = id
		end
	end
end)

function FuelUpTick(pumpObject, vehicle)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local pumpObject = pumpObject
		CurrentFuel = GetFuel(vehicle)
		CurrentCost = 0.0
		totalLiters = 0
		while IsFueling do
			Citizen.Wait(500)
			
			local oldFuel = CurrentFuel
			
			local fuelToAdd = 2
			local tickCost  = Config.GasStations[num].gasPrice * 2
			
			if not pumpObject then
				-- Jerrican
				if GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) - fuelToAdd * 100 >= 0 then
					CurrentFuel = oldFuel + fuelToAdd
					SetPedAmmo(playerPed, `WEAPON_PETROLCAN`, math.floor(GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) - fuelToAdd * 100))
				else
					IsFueling = false
				end
			else
				if Config.GasStations[num].gasVal - 2 < 0 then
					IsFueling = false
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 Mojudi Benzin Be Payan Resid")
					return
				end
	
				if CurrentCost + tickCost > ESX.GetPlayerData().money then
					IsFueling = false
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 Pool Shoma Baraye Benzin Zadan Kafi Nist")
					return
				end
				CurrentFuel = oldFuel + fuelToAdd
				totalLiters = totalLiters + 2
				Config.GasStations[num].gasVal = Config.GasStations[num].gasVal - 2
			end
			
			-- Tank is full, stop fueling
			if CurrentFuel > 100.0 then
				CurrentFuel = 100.0
				IsFueling = false
			end
			
			-- -- No more money, stop fueling
			CurrentCost = CurrentCost + tickCost
			-- if pumpObject and CurrentCash < CurrentCost + tickCost then
			-- 	IsFueling = false
			-- end
		end
		-- Stopped fueling, pay or update jerrycan ammos
		if pumpObject then
			TriggerServerEvent('fuel:pay',CurrentCost, num)
			TriggerServerEvent("update:gasval", num, totalLiters)
			SetFuel(vehicle, CurrentFuel)
			SyncFuel(vehicle, CurrentFuel)
		else 
			SetFuel(vehicle, CurrentFuel)
			SyncFuel(vehicle, CurrentFuel)
		end
	end)
end

function RefuelVehicleFromPump(pumpObject, vehicle)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local animDict = 'timetable@gardener@filling_can'
		local anim = 'gar_ig_5_filling_can'
		ESX.Streaming.RequestAnimDict(animDict)
		
		-- Make ped to face vehicle
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
		Citizen.Wait(1000)
		
		-- Start refuel thread
		FuelUpTick(pumpObject, vehicle)

		Citizen.Wait(1000)

		Citizen.CreateThread(function()
			while IsFueling do
				Citizen.Wait(100)
				TriggerEvent("enable:gas", FuelRound(CurrentFuel, 1))
			end
			TriggerEvent("disable:gas")
		end)

		while IsFueling do
			-- Disable controls when fueling
			for _, controlIndex in pairs(Config.DisableKeys) do
				DisableControlAction(0, controlIndex)
			end
			
			-- Disaply fueling progress
			local vehicleCoords = GetEntityCoords(vehicle)
			if pumpObject then
				local pumpCoords  = GetEntityCoords(pumpObject)
				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Dokme ~g~E ~w~Baraye Etmam Benzin Zadan\nHazine: ~g~' .. FuelRound(CurrentCost, 1) .. '$')
				DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, FuelRound(CurrentFuel, 1) .. "%")
			else
				DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, 'Dokme ~g~E ~w~Baraye Etmam Benzin Zadan\nJerrican: ~g~'.. FuelRound(GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) / Config.DefaultPetrolCanAmmo * 100, 1) .. '~s~ | Vehicle: ~g~' .. FuelRound(CurrentFuel, 1) .. '~s~')
			end
			
			-- Play fueling animation
			if not IsEntityPlayingAnim(playerPed, animDict, anim, 3) then
				TaskPlayAnim(playerPed, animDict, anim, 2.0, 8.0, -1, 50, 0, 0, 0, 0)
			end
			
			-- Allow cancelling fuel
			if IsControlJustPressed(0, 38) or (NearestPump and GetEntityHealth(pumpObject) <= 0) then
				IsFueling = false
			end
			
			Citizen.Wait(0)
		end
		
		ClearPedTasks(playerPed)
		RemoveAnimDict(animDict)
	end)
end

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if not IsFueling and (NearestPump and GetEntityHealth(NearestPump) > 0) then
			-- We are near a pump
			local pumpCoords = GetEntityCoords(NearestPump)
			if IsPedInAnyVehicle(playerPed) then
				-- Player is vehicle driver
				if GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed), -1) == playerPed then
					DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Baraye Benzin Zadan Az ~r~Mashin~w~ Kharej Shavid')
				end
			else
				-- Player is NOT in vehicle
				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.6, 'Mojudi: ~r~'..Config.GasStations[num].gasVal.." L ~w~| "..Config.GasStations[num].gasPrice.."$ Per Liter")
				local vehicle = NearestVehicle
				if DoesEntityExist(vehicle) then
					-- A vehicle is near, ask for refuel
					local vehicleCoords = GetEntityCoords(vehicle)
					if GetFuel(vehicle) < 95 then
						DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.2, 'Dokme ~g~E ~w~ Baraye ~g~Banzin~w~ Zadan')
						if IsControlJustPressed(0, 38) then
							if Config.GasStations[num].gasVal > 0 then
								IsFueling = true
								RefuelVehicleFromPump(NearestPump, vehicle)
							else
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 In Pomp Benzin Mojudi Benzin Nadarad")
							end
						end
					else
						DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Bak ~g~Benzin~w~ Por Ast')
					end
				else
					-- No vehicle is near, ask for jerrycan buy/refill
					if not HasPedGotWeapon(playerPed, `WEAPON_PETROLCAN`) then
						DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Dokme ~g~E ~w~Baraye Kharid Boshke Benzin Be Gheimat : ~g~$' .. Config.GasStations[num].gasPrice*100)

						if IsControlJustPressed(0, 38) then
							if Config.GasStations[num].gasVal >= 100 then
								TriggerServerEvent('fuel:pay',Config.GasStations[num].gasPrice*100, num)
								TriggerServerEvent("update:gasval", num, 100)
								GiveWeaponToPed(playerPed, 883325847, 4500, false, true)
							else
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 In Pomp Benzin Mojudi Benzin Baraye 100 Liter Nadarad")
							end
						end
					else
						local liters = 100 - FuelRound(GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`)/45)
						local refillCost = FuelRound(liters*Config.GasStations[num].gasPrice)
						if refillCost > 0 then
							if ESX.GetPlayerData().money >= refillCost then
								DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Dokme ~g~E ~w~Barate Por Kardan Boshke '..liters..' Liter Ba Gheymat :  ~g~'.. refillCost .. '$')

								if IsControlJustPressed(0, 38) then
									if liters <= Config.GasStations[num].gasVal then
										TriggerServerEvent('fuel:pay',refillCost, num)
										TriggerServerEvent("update:gasval", num, liters)
										Config.GasStations[num].gasVal = math.floor(Config.GasStations[num].gasVal - liters)
										SetPedAmmo(playerPed, 883325847, 4500)
									else
										TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 In Pomp Benzin Mojudi Benzin Baraye Por Kardan Boshke Nadard")
									end
								end
							else
								DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Pool Kafi Baraye Poor Kardan Boshke Nadarid')
							end
						else
							DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, 'Boshke Benzin Poor Ast')
						end
					end
				end
			end
		elseif not IsFueling and not NearestPump and not IsPedInAnyVehicle(playerPed) and GetSelectedPedWeapon(playerPed) == `WEAPON_PETROLCAN` then
			-- We are not near a pump but we have a Jerican
			local vehicle = NearestVehicle
			if DoesEntityExist(vehicle) then
				-- A vehicle is near
				local vehicleCoords = GetEntityCoords(vehicle)
				local canFuel = GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) > 0 and true or false
				if GetFuel(vehicle) < 95 and canFuel then
					DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.2,  'Dokme ~g~E ~w~ Baraye ~g~Banzin~w~ Zadan')
					if IsControlJustPressed(0, 38) then
						IsFueling = true
						RefuelVehicleFromPump(NearestPump, vehicle)
					end
				elseif not canFuel then
					DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.2, 'Boshke benzin khali ast')
				else
					DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.2, 'Bak ~g~Benzin~w~ Poor Ast')
				end
			end
		else
			Citizen.Wait(250)
		end
		Citizen.Wait(0)
	end
end)

RegisterCommand('infogas',function(source,args)
	local localGas = tonumber(num)
	if localGas ~= nil then
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^6-------------------")
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3ID ^0: ^1"..localGas)
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3Name ^0: ^1"..Config.GasStations[localGas].name)
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3Owner ^0: ^1"..Config.GasStations[localGas].owner)
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3Identifier ^0: ^1"..Config.GasStations[localGas].identifier)
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3Gas ^0: ^1"..Config.GasStations[localGas].gasVal .. " Litr")

	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3For Sale ^0: ^1"..Config.GasStations[localGas].forSale)
		if Config.GasStations[localGas].forSale == 'true' then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3Price ^0: ^1"..Config.GasStations[localGas].price)
		end
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^6-------------------")
	elseif localGas == nil then
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 You should be in the Gas Station")
	end
end)

RegisterNetEvent('fuel:updateclient')
AddEventHandler('fuel:updateclient', function(data)
	updateFile(data)
end)

function updateFile(data)
	for i=1, #data do
		Config.GasStations[i].name = data[i].name
		Config.GasStations[i].owner = data[i].owner
		Config.GasStations[i].identifier = data[i].identifier
		Config.GasStations[i].price = data[i].price
		Config.GasStations[i].forSale = data[i].forSale
		Config.GasStations[i].gasVal = tonumber(data[i].gasvalue)
		Config.GasStations[i].gasPrice = data[i].gasPrice
		Config.GasStations[i].wallet = data[i].wallet
	end
	-- Citizen.Wait(6000)
	-- CreateBlips()
end

function openStationMenu()
	ESX.TriggerServerCallback('fuel:getidinfo', function(info)
		local input = info.id
		local name = info.name
		local owner = info.owner
		local iden = info.identifier
		local gasVal = info.gasvalue
		local gasPrice = info.gasPrice
		local forSale = info.forSale
		local price = info.price
		local wallet = info.wallet

		local elements = {
			{label = ('ID : <span style="color:yellow;">' .. input .. '</span>'), value = 'id_value'},
			{label = ('Name : <span style="color:yellow;">' .. name .. '</span>'), value = 'change_name'},
			{label = ('owner : <span style="color:yellow;">' .. owner .. '</span>'), value = 'Owner'},
			{label = ('Identifier : <span style="color:yellow;">' .. iden .. '</span>'), value = 'identifier'},
			{label = ('Gas Litr value : <span style="color:yellow;">' .. gasVal .. '</span>'), value = 'gasvalue'},
			{label = ('Gas Price : <span style="color:yellow;">' .. gasPrice .. '</span>'), value = 'gasPrice'},
			{label = ('Wallet : <span style="color:yellow;">' .. wallet .. '</span>'), value = 'wallet'},
		}
	
		table.insert(elements, {label = ('<span style="color:black;">Close Menu </span>'), value = 'close_menu'})

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pomp',
		{
			title    = 'pomp',
			align    = 'top-right',
			elements = elements,
		},function(data, menu)
		  	if data.current.value == 'change_name' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'changename', {
					title    = "Enter new Gas station name",
				}, function(data2, menu2)
					if not data2.value then
						ESX.ShowNotification("You put nothing here")
						return
					end
		
					if data2.value:match("[^%w%s]") or data2.value:match("%d") then
						ESX.ShowNotification("~h~You cant use ~r~Special ~o~character ~w~or ~r~number ~w~!")
						return
					end

					if string.len(ESX.Math.Trim(data2.value)) >= 3 and string.len(ESX.Math.Trim(data2.value)) <= 11 then
						menu2.close()
						TriggerServerEvent('update:GasName',input,data2.value)
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^2You have changed your station name")
						Citizen.Wait(500)
						menu.close()
						openStationMenu()
					else
						ESX.ShowNotification("The characters should be between 3 & 11")
					end
				end, function (data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'wallet' then
				if wallet >= 100 then
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3You have claimed : ^1"..wallet .. ' $')
					TriggerServerEvent('fuel:claimwallet', input,wallet)
					Citizen.Wait(500)
					menu.close()
					openStationMenu()
				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^3You should have 100$ at least in your wallet")
				end
			elseif data.current.value == 'gasvalue' then
				currentStationId = input
				SpawnGasSupplier()
				menu.close()
				ESX.ShowNotification('Gas supplier Baraye shoma mark shod!')
			elseif data.current.value == 'gasPrice' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gasp', {
					title    = "Enter the litrs that you want to buy",
				}, function(data2, menu2)
		
					local numdata = tonumber(data2.value)

					if not numdata then
						ESX.ShowNotification("You put nothing here")
						return
					end
					
					if numdata > Config.maxgasprice or numdata <= Config.mingasprice then
						ESX.ShowNotification("Your litr should be between " .. Config.mingasprice  .. " and " .. Config.maxgasprice)
						return
					end
			
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^2You have set your station gas price to ^3 "..numdata)
					TriggerServerEvent('update:setgasPrice',input,numdata)
					menu2.close()
					Citizen.Wait(500)
					menu.close()
					openStationMenu()
				end, function (data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'close_menu' then
				menu.close()
			end
		end,function(data, menu)
			menu.close()
		end)
	end,num)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local Pause = true
		for i = 1, #Config.GasStations do
			local p2x,p2y,p2z = table.unpack(Config.GasStations[i].bossAction)
			if GetDistanceBetweenCoords(coords, Config.GasStations[i].bossAction, true) < 1 then
				Pause = false
				DrawName3D(p2x,p2y,p2z+0.5,'~y~Press ~r~E ~w~to open menu')
			end
		end
		if Pause then Citizen.Wait(700) end
	end
end)

RegisterNUICallback('trunoff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({
		display = false
	})
end)

RegisterNUICallback('setWaypoint', function(data)
	local idmark = tonumber(data.id)
	local newcoord = Config.GasStations[idmark].coord
	SetNewWaypoint(newcoord.x, newcoord.y)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local Pause = true
		for i = 1, #Config.GasStations do
			if GetDistanceBetweenCoords(coords, Config.GasStations[i].bossAction, false) <= 5 then
				Pause = false
				if IsControlJustPressed(0, 38) then
					ESX.TriggerServerCallback('fuel:getPlayerData', function(infop)
						if infop.iden == Config.GasStations[i].identifier then
							openStationMenu()
						elseif infop.iden ~= Config.GasStations[i].identifier then
							openBuyMenu()
						else
							TriggerEvent("chatMessage", "[ERROR]", {255, 0, 0}, "^1 Something went wrong")
						end
					end)
				end
			end
		end
		if Pause then Citizen.Wait(700) end
    end
end)

function openBuyMenu()
	ESX.TriggerServerCallback('fuel:getidinfo', function(info)
		local input = info.id
		local name = info.name
		local iden = info.identifier
		local forSale = info.forSale
		local price = info.price
		local elements = {
			{label = ('ID : <span style="color:yellow;">' .. input .. '</span>'), value = 'id_value'},
			{label = ('Name : <span style="color:yellow;">' .. name .. '</span>'), value = 'change_name'},
			{label = ('Buy : <span style="color:green;">' .. price .. '</span>'), value = 'pricelabel'},
			{label = ('<span style="color:white;">Close Menu </span>'), value = 'close_menu'}
		}

		if forSale == 'true' then
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pomp-sell',
			{
				title    = 'pomp-sell',
				align    = 'top-right',
				elements = elements,
			},function(data, menu)
				if data.current.value == 'pricelabel' then
					ESX.TriggerServerCallback('fuel:getPlayerData',function(infop)
						local stationp = info.price
						if infop.bank >= stationp then
							TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, '^2You have buyed this station ^0| ^2ID : '..info.id)
							TriggerServerEvent('fuel:setOwnerStation',info.id,'false')
							TriggerServerEvent('fuel:takemoney',stationp)
							menu.close()
							Citizen.Wait(500)
							menu.close()
							openStationMenu()
						else 
							TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1 You Don't have enough money in your bank account")
							TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, '^1 Price : ^8'..ESX.Math.GroupDigits(stationp))
							return
						end
					end)

				elseif data.current.value == 'close_menu' then
					menu.close()
				end
			end,function(data, menu)
				menu.close()
			end)
		elseif forSale == 'false' then
			TriggerEvent("chatMessage", "[ERROR]", {255, 0, 0}, "^1 This Gas Station Is Not For Sale")
		end
	end,num)
end

function SpawnGasSupplier()
    if npcPed then
        DeleteEntity(npcPed)
        RemoveBlip(npcBlip)
    end
	npcPed = nil
	Citizen.Wait(1000)
    local pedModel = `a_m_m_business_01`
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end

    local spawnCoords = vector3(2842.93, 1456.96, 24.74)
	SetNewWaypoint(2842.93, 1456.96)
    npcPed = CreatePed(4, pedModel, spawnCoords.x, spawnCoords.y, spawnCoords.z - 1.0, 72.77, false, true)
    SetEntityAsMissionEntity(npcPed, true, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    SetPedDiesWhenInjured(npcPed, false)
    SetPedCanPlayAmbientAnims(npcPed, true)
    SetPedCanRagdollFromPlayerImpact(npcPed, false)
    SetEntityInvincible(npcPed, true)
    FreezeEntityPosition(npcPed, true)

    npcBlip = AddBlipForCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)
    SetBlipSprite(npcBlip, 280)
    SetBlipDisplay(npcBlip, 4)
    SetBlipScale(npcBlip, 0.8)
    SetBlipColour(npcBlip, 5)
    SetBlipAsShortRange(npcBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Gas Supplier")
    EndTextCommandSetBlipName(npcBlip)

    Citizen.CreateThread(function()
        while npcPed do
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local npcCoords = GetEntityCoords(npcPed)
            local distance = #(coords - npcCoords)

            if distance < 3.0 then
                DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z + 1.0, "Press [E] to sell petrol")
                if IsControlJustReleased(0, 38) then
                    SellPetrolToSupplier()
                end
            end
            Wait(0)
        end
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

function SellPetrolToSupplier()
    ESX.TriggerServerCallback('fuel:getPlayerData', function(data)
        ESX.TriggerServerCallback('esx:getPlayerData', function(xPlayer)
            local inventory = xPlayer.inventory
            local petrolCount = 0
            
            for _, item in pairs(inventory) do
                if item.name == 'petrol' then
                    petrolCount = item.count
                    break
                end
            end

            if petrolCount > 0 then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_petrol', {
                    title = "How much petrol do you want to sell? (example: 10)"
                }, function(data2, menu2)
                    local amount = tonumber(data2.value)
                    if amount and amount > 0 and amount <= petrolCount then
                        menu2.close()
                        TriggerServerEvent('fuel:sellPetrolToSupplier', currentStationId, amount)
                    else
                        ESX.ShowNotification('Invalid amount!')
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            else
                ESX.ShowNotification('You don\'t have any petrol to sell!')
            end
        end)
    end)
end

function CreateNPC()
    local model = GetHashKey('a_m_m_business_01')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    
    npcPed = CreatePed(4, model, Config.coordstationui.x, Config.coordstationui.y, Config.coordstationui.z - 1.0, 0.0, false, true)
    SetEntityHeading(npcPed, 206.23)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    
    TaskStartScenarioInPlace(npcPed, "WORLD_HUMAN_CLIPBOARD", 0, true)

    exports['diamond_target']:AddTargetEntity(npcPed, {
        options = {
            {
                type = "client",
                action = function()
                    ESX.TriggerServerCallback('fuel:getData', function(data)
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            display = true,
                            detail = data
                        })
                    end)
                end,
                icon = "fas fa-gas-pump",
                label = "Open Gas Station Menu",
                canInteract = function(entity)
                    return not IsPedDeadOrDying(entity, true)
                end
            }
        },
        distance = 2.5
    })
end

Citizen.CreateThread(CreateNPC)

local AllBlips = {}
local Set = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if IsPedInAnyVehicle(PlayerPedId()) then
			if not Set then
				Set = true
				CreateBlips()
			else
				Citizen.Wait(1000)
			end
		else
			if Set then
				Set = false
				for k, v in pairs(AllBlips) do
					RemoveBlip(v)
				end
			else
				Citizen.Wait(1000)
			end
		end
	end
end)

function CreateBlips()
    Citizen.CreateThread(function()
        for i=1, #Locations do
            local blip = Locations[i]["blip"]

            if blip then
                if DoesBlipExist(blip["id"]) then
                    RemoveBlip(blip["id"])
                end

                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
				table.insert(AllBlips, blip["id"])
                SetBlipSprite(blip["id"], 361)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 0.4)
                SetBlipColour(blip["id"], 1)
                SetBlipAsShortRange(blip["id"], true)
    
                BeginTextCommandSetBlipName("gasblip")
                AddTextEntry("gasblip", Config.GasStations[i].name)
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end)
end
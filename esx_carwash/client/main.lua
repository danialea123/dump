---@diagnostic disable: missing-parameter, lowercase-global, undefined-global
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

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local AllBlips = {}
local Set = false

function CreateWashBlips()
	AllBlips = {}
	for i=1, #Config.Locations, 1 do
		carWashLocation = Config.Locations[i]

		local blip = AddBlipForCoord(carWashLocation)
		SetBlipSprite(blip, 100)
		SetBlipAsShortRange(blip, true)
		table.insert(AllBlips, blip)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('blip_carwash'))
		EndTextCommandSetBlipName(blip)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if IsPedInAnyVehicle(PlayerPedId()) then
			if not Set then
				Set = true
				CreateWashBlips()
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

DrawDistance = 15.0
Citizen.CreateThread(function()
	for i=1, #Config.Locations, 1 do
		local carWashLocation = Config.Locations[i]
		local Interact
		local Point = RegisterPoint(carWashLocation, DrawDistance, true)
		Point.set('InArea', function ()
			if CanWashVehicle() then
				DrawMarker(1, carWashLocation, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, false, false, 2, false, false, false, false)
			end
		end)
		Point.set('InAreaOnce', function ()
			Interact = RegisterPoint(carWashLocation, 5, true)
			Interact.set('InArea', function ()
				if CanWashVehicle() then
					ESX.ShowHelpNotification(_U('prompt_wash_paid', ESX.Math.GroupDigits(Config.Price)))
					if IsControlJustReleased(0, Keys['E']) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		
						if GetVehicleDirtLevel(vehicle) > 2 then
							WashVehicle()
						else
							ESX.Alert(_U('wash_failed_clean'))
						end
					end
				end
			end)
		end, function ()
			if Interact then
				Interact.remove()
			end
		end)
	end
end)

function CanWashVehicle()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			return true
		end
	end

	return false
end

function WashVehicle()
	ESX.TriggerServerCallback('esx_carwash:canAfford', function(canAfford)
		if canAfford then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			SetVehicleDirtLevel(vehicle, 0.0)

			if Config.EnablePrice then
				ESX.Alert(_U('wash_successful_paid', ESX.Math.GroupDigits(Config.Price)))
			else
				ESX.Alert(_U('wash_successful'))
			end
			Citizen.Wait(5000)
		else
			ESX.Alert(_U('wash_failed'))
			Citizen.Wait(5000)
		end
	end)
end



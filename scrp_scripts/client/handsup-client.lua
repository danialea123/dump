---@diagnostic disable: missing-parameter
ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

handsup = false
active = true
Citizen.CreateThread(function()
	local dict = "missfra1mcs_2_crew_react"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(0)
		if IsPedReloading(PlayerPedId()) then
			active = false
			Citizen.SetTimeout(3000, function()
				active = true
			end)
		end	
	end
end)

AddEventHandler('handappstate',function(state)
	active = state
	if not active then
		Citizen.SetTimeout(2000, function()
			active = true
		end)
	end
end)

AddEventHandler("onKeyDown", function(key)
	local dict = "missfra1mcs_2_crew_react"
	if key == "x" and ESX.GetPlayerData()['IsDead'] ~= 1 and active and not IsPedInAnyVehicle(PlayerPedId()) then
		--SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
		if not handsup then
			TaskPlayAnim(PlayerPedId(), dict, "handsup_standing_base", 8.0, 8.0, -1, 50, 0, false, false, false)
			handsup = true
			Citizen.CreateThread(function()
				while handsup do 
					Wait(0)
					if IsEntityPlayingAnim(PlayerPedId(), dict,"handsup_standing_base", 3) then
						DisableControlAction(0, 37, true)
						DisableControlAction(0, 25, true)
						DisablePlayerFiring(PlayerPedId(), true)
					else
						handsup = false
						ClearPedTasks(PlayerPedId())
					end
					if not active then
						handsup = false
						ClearPedTasks(PlayerPedId())
						Citizen.Wait(2000)
						active = true
					end
				end
			end)
		else
			handsup = false
			ClearPedTasks(PlayerPedId())
		end	
    end
end)
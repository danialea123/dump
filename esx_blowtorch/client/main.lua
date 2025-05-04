ESX               = nil
local blowtorching = false
local clearweld = false
local dooropen = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  local parachuteModel = GetHashKey('pil_p_para_pilot_sp_s')
  local tintIndex = 10
  SetPlayerHasReserveParachute(player)

  SetPlayerParachutePackTintIndex(player, tintIndex)
  SetPlayerReserveParachuteTintIndex(player, tintIndex)

  SetPlayerParachuteModelOverride(player, parachuteModel)
  SetPlayerReserveParachuteModelOverride(player, parachuteModel)
end)

RegisterNetEvent('esx_blowtorch:startblowtorch')
AddEventHandler('esx_blowtorch:startblowtorch', function(timer)
	blowtorchAnimation(timer)
	ESX.SetPlayerData('isSentenced', true)
	TriggerEvent("Emote:SetBan", true)
    TriggerEvent("dpclothingAbuse", true)
    exports.essentialmode:DisableControl(true)
end)

RegisterNetEvent('esx_blowtorch:stopblowtorching')
AddEventHandler('esx_blowtorch:stopblowtorching', function()
	blowtorching = false
	ESX.SetPlayerData('isSentenced', false)
	ClearPedTasksImmediately(PlayerPedId())
	TriggerEvent("Emote:SetBan", false)
	TriggerEvent("dpclothingAbuse", false)
	exports.essentialmode:DisableControl(false)
end)

function blowtorchAnimation(timer)
	local blowtorchingtime = timer or 600000
	blowtorching = true
	Citizen.CreateThread(function()
		while blowtorching do
			if not IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_WELDING") then
				TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)	
			end
			Wait(100)
		end
	end)
	SetTimeout(blowtorchingtime, function()
		if blowtorching then
			ClearPedTasksImmediately(PlayerPedId())
			blowtorching = false
			ESX.SetPlayerData('isSentenced', false)
			TriggerEvent("Emote:SetBan", false)
			TriggerEvent("dpclothingAbuse", false)
			exports.essentialmode:DisableControl(false)
		end
	end)
end


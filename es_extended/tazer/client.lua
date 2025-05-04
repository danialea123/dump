---@diagnostic disable: missing-parameter
local isTaz = false
local Stopper = true

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if IsPedBeingStunned(GetPlayerPed(-1)) and not isTaz then
			isTaz = true
			Stopper = false
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			if not Stop then
				Stop = true
				DisableRunning()
				Citizen.SetTimeout(30000, function()
					Stop = false
				end)
			end
		elseif not IsPedBeingStunned(GetPlayerPed(-1)) and isTaz then
			isTaz = false
			Stopper = true
			Wait(5000)
			SetTimecycleModifier("hud_def_desat_Trevor")
			Wait(10000)
      		SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
		if IsPedBeingStunned(GetPlayerPed(-1)) then
			SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
		end
	end
end)

function DisableRunning()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2)
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 22, true)
			if not Stop then
				break
			end
		end
	end)
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		if Stopper then
-- 			SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
-- 			SetPedCanRagdoll(PlayerPedId(), false)
-- 		end
-- 	end
-- end)
ESX          = nil
local IsDead = false
local IsAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:setirs', 'hunger', 500000)
	TriggerEvent('esx_status:setirs', 'thirst', 500000)
	TriggerEvent('esx_status:setirs', 'mental', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	if GetInvokingResource() then
		TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #HL2", 14)
		return
	end
	-- restore hunger & thirst
	TriggerEvent('esx_status:setirs', 'hunger', 1000000)
	TriggerEvent('esx_status:setirs', 'thirst', 1000000)
	TriggerEvent('esx_status:setirs', 'mental', 1000000)

	-- restore hp
	local playerPed = PlayerPedId()
	ESX.SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return true
	end, function(status)
		status.remove(250)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return true
	end, function(status)
		status.remove(200)
	end)

	TriggerEvent('esx_status:registerStatus', 'mental', 1000000, '#0C98F1', function(status)
		return true
	end, function(status)
		status.remove(250)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(12000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth
			local mentalcheck = true

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val <= 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
					if (status.val == 15) or (status.val == 10) or (status.val == 5) then
						local random = math.random(1,4)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'stomach_'..random, 0.3)
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val <= 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
					if (status.val == 15) or (status.val == 10) or (status.val == 5) then
						local gender
						local random
						if GetHashKey('mp_m_freemode_01') == GetEntityModel(PlayerPedId()) then
							random = math.random(1,4)
							gender = 'man_cough_'
						elseif GetHashKey('mp_f_freemode_01') == GetEntityModel(PlayerPedId()) then
							random = math.random(1,5)
							gender = 'female_coughing_'
						end
						TriggerEvent('InteractSound_CL:PlayOnOne', gender..random, 1.0)
						ExecuteCommand('e cough')
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'mental', function(status)
				if status.val <= 0 then
					if prevHealth > 150 then
						health = health - 5
						mentalcheck = false
					elseif not IsPedDeadOrDying(playerPed) then
						ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
							if IsDead ~= false and IsDead ~= 'done' then
								health = health - 1
							elseif prevHealth > 105 then
								health = health - 5
							else
								while not HasAnimDictLoaded('mp_suicide') do
									RequestAnimDict('mp_suicide')
									Citizen.Wait(10)
								end
								TaskPlayAnim(playerPed, 'mp_suicide', 'pill', 2.0, 2.0, -1, 51, 0, false, false, false)
								RemoveAnimDict('mp_suicide')
								Citizen.Wait(4000)
								health = 0
							end
							mentalcheck = false
						end, GetPlayerServerId(PlayerId()))
					else
						mentalcheck = false
					end
				else
					mentalcheck = false
				end
			end)
			while mentalcheck do
				Citizen.Wait(50)
			end
			if health ~= prevHealth then
				if health <= 100 and not ESX.GetPlayerData().IsDead then
					TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Shoma Be Dalil Tamam Shodan Ab Ya Ghaza Ya Mental Injure Shodid")
					TriggerServerEvent('DiscordBot:PlayerDied', GetPlayerName(PlayerId()) .. ' (' ..GetPlayerServerId(PlayerId()).. ') ' .. "Tamam Shodan Ab Ya Ghaza Ya Mental" .. '.')
				end
				ESX.SetEntityHealth(playerPed, health)
			end
		end
	end)
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
	if ESX.isDead() then return end
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpclothingAbuse", true)
		TriggerEvent("dpemote:enable", false)
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			ESX.Game.SpawnObject(prop_name, {
				x = x,
				y = y,
				z = z + 0.2
			}, function(obj)
				local prop = obj
				local boneIndex = GetPedBoneIndex(playerPed, 18905)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	
				ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
					TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
					local random = math.random(1,4)
					TriggerEvent('InteractSound_CL:PlayOnOne', 'eating_'..random, 1.0)
					Citizen.Wait(3000)
					IsAnimated = false
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
					exports.essentialmode:DisableControl(false)
					TriggerEvent("dpclothingAbuse", false)
					TriggerEvent("dpemote:enable", true)
				end)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		if ESX.isDead() then return end
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpclothingAbuse", true)
		TriggerEvent("dpemote:enable", false)
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			ESX.Game.SpawnObject(prop_name, {
					x = x,
					y = y,
					z = z + 0.2
				}, function(obj)
				local prop = obj
				local boneIndex = GetPedBoneIndex(playerPed, 18905)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
				local random = math.random(1,2)
				TriggerEvent('InteractSound_CL:PlayOnOne', 'drinking_'..random, 1.0)
				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
				exports.essentialmode:DisableControl(false)
				TriggerEvent("dpclothingAbuse", false)
				TriggerEvent("dpemote:enable", true)
			end)	
		end)	
		end)

	end
end)

AddEventHandler('onKeyDown',function(key)
	if key == "space" then 
		local low = false
		TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			if status.val == 0 then
				low = true
			end
		end)

		TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			if status.val == 0 then
				low = true
			end
		end)
		if low then
			Wait(200)
			SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
		end
	end
end)
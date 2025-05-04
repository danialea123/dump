---@diagnostic disable: undefined-field, param-type-mismatch, missing-parameter
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
PlayerData = {}
local jailTime = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		
		Citizen.Wait(10)
	end
	
	PlayerData = ESX.GetPlayerData()
	
	ESX.SetPlayerData('jailed', false)
	ESX.SetPlayerData('jail', 0)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
end)

AddEventHandler('PlayerLoadedToGround', function()
	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime, JailLoc, type)
		if inJail then
			jailTime = newJailTime
			if type ~= "Admin" and type ~= "Prison" then
				JailLogin2(Config.CellPos[string.lower(type)][JailLoc])--pashmat berize dawsh :D
			else
				JailLogin()
			end
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("esx-qalle-jail:openJailMenu")
AddEventHandler("esx-qalle-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("esx-qalle-jail:openMiniJailMenu")
AddEventHandler("esx-qalle-jail:openMiniJailMenu", function(job)
	OpenMiniJailMenu(job)
end)

RegisterNetEvent("esx-qalle-jail:jailPlayer")
AddEventHandler("esx-qalle-jail:jailPlayer", function(newJailTime)
	TriggerEvent("esx_policejob:removeHandcuffFull")
	jailTime = newJailTime
	Cutscene(InJail)
	TriggerEvent("dpclothingAbuse", true)
end)

RegisterNetEvent("esx-qalle-jail:miniJailPlayer")
AddEventHandler("esx-qalle-jail:miniJailPlayer", function(jailPlayerCoords, newJailTime)
	TriggerEvent("esx_policejob:removeHandcuffFull")
	jailTime = newJailTime
	MiniJailStart(jailPlayerCoords)
	TriggerEvent("dpclothingAbuse", true)
end)

RegisterNetEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function()
	if GetInvokingResource() then return end
	jailTime = 0
	TriggerEvent("dpclothingAbuse", false)
	SetTimeout(5000, function()
		UnJail(jailTime)
	end)
end)

function removeweapons()
	
	local ped =  PlayerPedId()

	ESX.SetPedArmour(ped, 0)
	ClearPedBloodDamage(ped)
	ResetPedVisibleDamage(ped)
	ClearPedLastWeaponDamage(ped)
	RemoveAllPedWeapons(ped, true)

end

function JailLogin(jail)
	local ped = PlayerPedId()
	TriggerServerEvent("esx-qalle-jail:jobSet", source)

	ESX.Alert("Akharin bar ke DC kardid too zendan boodid, bara hamin be zendan bazgashtid!", "info")
	InJail(jail, true)
end

function JailLogin2(location)
	local ped = PlayerPedId()
	TriggerServerEvent("esx-qalle-jail:jobSet", source)

	ESX.Alert("Akharin bar ke DC kardid too zendan boodid, bara hamin be zendan bazgashtid!", "info")
	InJail2(location, true)
end

local jobcenter = {
	["Job Center"] = {
		["x"] = -260.45,
		["y"] = -974.40,
		["z"] = 31.2200,
		["h"] = 92.469093322754,
		["goal"] = {
			"JobCenter"
		}
	},
}

function UnJail(jailTime)
	ESX.SetPlayerData('jailed', false)
	ESX.SetPlayerData('jail', 0)
	local PlayerPed = PlayerPedId()
	local PlayerCoords = GetEntityCoords(PlayerPed)
	if jailTime == -10 then
		ESX.Game.Teleport(PlayerPedId(), jobcenter["Job Center"])
	elseif #(PlayerCoords - vector3(1848.17, 3674.45, 34.33)) <= 40.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(1828.4,3671.78,34.34))
	elseif #(PlayerCoords - vector3(559.63, 27.71, 69.36)) <= 40.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(620.39,18.04,87.9))
	elseif #(PlayerCoords - vector3(480.64,-1009.34,26.27)) <= 40.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(489.27,-1002.14,27.99))
	elseif #(PlayerCoords - vector3(1858.75,3711.75,34.58)) <= 25.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(1839.09,3693.7,34.27))
	elseif #(PlayerCoords - vector3(0, 0, 0)) <= 2 then
		ESX.Game.Teleport(PlayerPedId(), vector3(-437.34, 6019.26, 31.49))
	elseif #(PlayerCoords - vector3(607.73, -7.74, 82.78)) <= 20.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(651.9297, -21.36264, 82.05347))
	elseif #(PlayerCoords - vector3(-558.36,-235.81,34.27)) <= 10.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(-545.43,-210.66,37.65))
	elseif #(PlayerCoords - vector3(365.56, -1606.41, 30.05)) <= 10.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(372.33,-1618.45,29.29))
	elseif #(PlayerCoords - vector3(831.62, -1299.62, 28.24)) <= 10.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(830.24,-1311.23,28.13))
	elseif #(PlayerCoords - vector3(-1077.39, -811.71, 15.64)) <= 20.0 then
		ESX.Game.Teleport(PlayerPedId(), vector3(-1057.99,-840.82,5.04))
	else
		ESX.Game.Teleport(PlayerPedId(), vector3(1845.60, 2585.80, 45.67))
	end
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
	ESX.Alert("~g~~h~Shoma Azad Shodid!", "check")
end

function PervenantScape()
	if jailTime > 0 or jailTime == -10 then
		local JailPosition = vector3(1773.35,2492.74,45.74)
		local pCoord = GetEntityCoords(PlayerPedId())
		if #(vector2(pCoord.x, pCoord.y) - vector2(JailPosition.x, JailPosition.y)) > 200.0 then
			ESX.Game.Teleport(PlayerPedId(), JailPosition)
			ESX.Alert("~r~~h~Shoma nemitavanid az zendan farar konid.", "error")
		end
		SetTimeout(1000, PervenantScape)
	end
end

function InJail()
	ESX.SetPlayerData('jailed', true)
	ESX.SetPlayerData('jail', jailTime)

	TriggerServerEvent("esx-qalle-jail:jobSet", source)
	if jailTime == -10 then
		changeQuestionClothes()
	else
		changeClothes2()
	end
	local ped =  PlayerPedId()

	ESX.SetPedArmour(PlayerPedId(), 0)
	ClearPedBloodDamage(PlayerPedId())
	ResetPedVisibleDamage(PlayerPedId())
	ClearPedLastWeaponDamage(PlayerPedId())
	-- RemoveAllPedWeapons(PlayerPedId(), true)

	local JailPosition 	= nil
	local canRun 		= false

	JailPosition = Config.JailPositions["Cell"]
	ESX.SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)

	PervenantScape()

    Citizen.CreateThread(function()
		while jailTime > 0 or jailTime == -10 do
			DisableControlAction(0, 0, true)
			SetFollowPedCamViewMode(1)

			DisableControlAction(0, Keys['F1'],true)
			DisableControlAction(0, Keys['F3'],true)
			DisableControlAction(0, Keys['F5'],true)
			DisableControlAction(0, Keys['TAB'], true)
			DisableControlAction(0, Keys['LEFTSHIFT'], true)
			DisableControlAction(0, Keys['PAGEUP'], true)
			DisableControlAction(0, Keys['R'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys[','], true)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Right click
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 27, true) -- Arrow up

			Citizen.Wait(0)
		end
	end)
	ESX.UI.Menu.CloseAll()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20000)
        if jailTime > 0 then
            TriggerEvent('esx_status:setirs', 'hunger', 1000000)
            TriggerEvent('esx_status:setirs', 'thirst', 1000000)
            TriggerEvent('esx_status:setirs', 'mental', 1000000)
        else
            Citizen.Wait(2000)
        end
    end
end)

function InJail2(jail, first)
	ESX.SetPlayerData('jailed', true)
	ESX.SetPlayerData('jail', jailTime)
	changeClothes()
	local ped =  PlayerPedId()

	ESX.SetPedArmour(PlayerPedId(), 0)
	ClearPedBloodDamage(PlayerPedId())
	ResetPedVisibleDamage(PlayerPedId())
	ClearPedLastWeaponDamage(PlayerPedId())

	local JailPosition = nil
	local canRun = false

	JailPosition = Config.JailPositions["Cell"]
	ESX.SetEntityCoords(PlayerPedId(), jail["x"], jail["y"], jail["z"] - 1)
	Citizen.CreateThread(function()
		while jailTime > 0 or jailTime == -10 do
			Citizen.Wait(250)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), jail.x, jail.y, jail.z, false) > 4.0 then
				ESX.Game.Teleport(PlayerPedId(), jail)
				ESX.Alert("~r~~h~Shoma nemitavanid az zendan farar konid.", "error")
			end
		end
	end)

    Citizen.CreateThread(function()
		while jailTime > 0 or jailTime == -10 do
			DisableControlAction(0, 0, true)
			SetFollowPedCamViewMode(1)

			DisableControlAction(0, Keys['F1'],true)
			DisableControlAction(0, Keys['F3'],true)
			DisableControlAction(0, Keys['F5'],true)
			DisableControlAction(0, Keys['TAB'], true)
			DisableControlAction(0, Keys['LEFTSHIFT'], true)
			DisableControlAction(0, Keys['PAGEUP'], true)
			DisableControlAction(0, Keys['R'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys[','], true)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Right click
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 27, true) -- Arrow up

			Citizen.Wait(0)
		end		
	end)
	ESX.UI.Menu.CloseAll()
end

function OpenMiniJailMenu(job)
	local PrisonCoord = false
	local PrisonText = ""
	local PlayerPed = PlayerPedId()
	local PlayerCoords = GetEntityCoords(PlayerPed)
	if job == "police" then
		for k, v in pairs(Config.CellPos["police"]) do
			if #(PlayerCoords - vector3(v["x"], v["y"], v["z"])) <= 45.0 then
				PrisonCoord = true
			end
		end
		PrisonText = "Edare Police"
	elseif job == "sheriff" then
		if #(PlayerCoords - vector3(1842.49, 3671.12, 34.33)) <= 15.0 then
			PrisonCoord = true
		end
		PrisonText = "Edare Sheriff"
	elseif job == "forces" then
		for k, v in pairs(Config.CellPos["forces"]) do
			if #(PlayerCoords - vector3(v["x"], v["y"], v["z"])) <= 15.0 then
				PrisonCoord = true
			end
		end
		PrisonText = "Edare Special Force"
	elseif job == "justice" then
		if #(PlayerCoords - vector3(-555.7, -234.33, 34.27)) <= 15.0 then
			PrisonCoord = true
		end
		PrisonText = "Justice"
	end
	if PrisonCoord then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mini_jail_menu', {
			title    = "Menu Zendan",
			align    = 'center',
			elements = {
				{ label = "Zendani Kardan", value = "jail_closest_player" },
				{ label = "Azad Kardan", value = "unjail_player" }
			}
		}, function(data, menu)
			local action = data.current.value
			if action == "jail_closest_player" then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_choose_time_menu', {
    	        	title = "Zaman e zendan(be daghighe)"
    	      	}, function(data2, menu2)
    	        	local jailTime = tonumber(data2.value)
    	        	if jailTime == nil then
    	          		ESX.Alert("Lotfan Time ro Be daqiqe Vared konid!", "error")
					else
						if jailTime <= 60 then
							if jailTime > 30 and PlayerData.job.name ~= "justice" then
								ESX.Alert("Shoma Faghat Ta 30 Daghighe Mitavanid Jail Bezanid", "error")
								return
							end
							menu2.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.Alert("Hich kas nazdik nist!", "error")
							else
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_choose_reason_menu', {
									title = "Dalil zendan"
								}, function(data3, menu3)
									local reason = data3.value
									if reason == nil then
										ESX.Alert("Bayad dalil bezarid", "error")
									else
										menu3.close()
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
										if closestPlayer == -1 or closestDistance > 3.0 then
											ESX.Alert("Kasi nazdik nist!", "error")
										else
											local TargetPed = GetPlayerPed(closestPlayer)
											local TargetCoords = GetEntityCoords(TargetPed)
											TriggerServerEvent("HR_Jailsystem:miniJailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason, TargetCoords)
											menu3.close()
										end
									end
								end, function(data3, menu3)
									menu3.close()
								end)
							end
						else
							ESX.Alert("Zaman zendan nemitavand bishtar az 60 daghighe bashad", "error")
						end
					end
    	      	end, function(data2, menu2)
					menu2.close()
				end)
			elseif action == "unjail_player" then
				local elements = {}
				ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)
					if #playerArray == 0 then
						ESX.Alert("~y~Hich Fardi Dar Zendan ~g~"..ESX.GetPlayerData().job.name.." ~y~Zendani Nashode Ast", "error")
						return
					end
					for i = 1, #playerArray, 1 do
						table.insert(elements, {label = "Zendani: " .. playerArray[i].name .. " | Zaman Zendan: " .. playerArray[i].jailTime .. " Daghighe", value = playerArray[i].identifier })
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_unjail_menu', {
						title = "Azad kardan az zendan",
						align = "center",
						elements = elements
					}, function(data2, menu2)
						local action = data2.current.value

						TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)

						menu2.close()
					end, function(data2, menu2)
						menu2.close()
					end)
				end, true)
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.Alert("Shoma Bayad Dar ~r~Nazdiki~s~ ~y~Bazdashtgah "..PrisonText.."~s~ Bashid!", "error")
	end
end

function OpenJailMenu()
	local PlayerPed = PlayerPedId()
	local PlayerCoords = GetEntityCoords(PlayerPed)
	local PrisonCoord = vector3(1735.08, 2603.81, 45.56)
	if #(PlayerCoords - PrisonCoord) <= 150 then
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'jail_prison_menu',
			{
				title    = "Menu ye zendan",
				align    = 'center',
				elements = {
					{ label = "Jail Closest Person", value = "jail_closest_player" },
					{ label = "Unjail Person", value = "unjail_player" }
				}
			}, 
		function(data, menu)

			local action = data.current.value

			if action == "jail_closest_player" then

				menu.close()

				ESX.UI.Menu.Open(
    	      		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
    	      		{
    	        		title = "Zaman e zendan(be daghighe)"
    	      		},
    	      	function(data2, menu2)

    	        	local jailTime = tonumber(data2.value)

    	        	if jailTime == nil then
    	          		ESX.Alert("Lotfan Time ro Be daqiqe Vared konid!", "error")
					else
						if jailTime <= 60 then
    	          		menu2.close()

    	          		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    	          		if closestPlayer == -1 or closestDistance > 3.0 then
    	            		ESX.Alert("Hich kas nazdik nist!", "error")
						else
							ESX.UI.Menu.Open(
								'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
								{
								  title = "Dalil zendan"
								},
							function(data3, menu3)
							
							  	local reason = data3.value
							
							  	if reason == nil then
									ESX.Alert("Bayad dalil bezarid", "error")
							  	else
									menu3.close()
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
									  	ESX.Alert("Kasi nazdik nist!", "error")
									else
										TriggerServerEvent("esx-qalle-jail:jailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
									end
							  	end
							  
							end, function(data3, menu3)
								menu3.close()
							end)
						  end
						else
							ESX.Alert("Zaman zendan nemitavand bishtar az 60 daghighe bashad", "error")
						end

					end

    	      	end, function(data2, menu2)
					menu2.close()
				end)
			elseif action == "unjail_player" then

				local elements = {}

				ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)

					if #playerArray == 0 then
						ESX.Alert("Zendan e shoma khalist", "error")
						return
					end

					for i = 1, #playerArray, 1 do
						table.insert(elements, {label = "Zendani: " .. playerArray[i].name .. " | Zaman e zendan: " .. playerArray[i].jailTime .. " daghighe", value = playerArray[i].identifier })
					end

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'jail_unjail_menu',
						{
							title = "Azad kardan az zendan",
							align = "center",
							elements = elements
						},
					function(data2, menu2)

						 local action = data2.current.value

						 TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)

						 menu2.close()

					end, function(data2, menu2)
						menu2.close()
					end)
				end)

			end

		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.Alert("Shoma Bayad Dar ~r~Nazdiki~s~ ~y~Zendan Markazi~s~ Bashid!", "error")
	end
end

--[[AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ForceSocialClubUpdate()
    end
end)

AddEventHandler("onClientResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ForceSocialClubUpdate()
    end
end)]]
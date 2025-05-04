---@diagnostic disable: undefined-field, undefined-global, missing-parameter, lowercase-global, need-check-nil, need-check-nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy, Ended = false, true
local spawnedVehicles, isInShopMenu = {}, false
local Melee = {
	-1569615261,
	1737195953,
	1317494643,
	-1786099057,
	1141786504,
	-2067956739,
	-868994466
}
local Knife = {
	-1716189206,
	1223143800,
	-1955384325,
	-1833087301,
	910830060
}
local Bullet = {453432689,1593441988,584646201,-1716589765,324215364,736523883,-270015777,-1074790547,-2084633992,-1357824103,-1660422300,2144741730,487013001,2017895192,-494615257,-1654528753,100416529,205991906,1119849093}
local Animal = {
	-100946242,
	148160082
}
local FallDamage = {
	-842959696
}
local Explosion = {
	-1568386805,
	1305664598,
	-1312131151,
	375527679,
	324506233,
	1752584910,
	-1813897027,
	741814745,
	-37975472,
	539292904,
	341774354,
	-1090665087
}
local Gas = {
	-1600701090
}
local Burn = {
	615608432,
	883325847,
	-544306709
}
local Drown = {
	-10959621,
	1936677264
}
local Car = {
	133987706,
	-1553120962
}
function checkArray(array, val)
	for name, value in ipairs(array) do
		if value == val then
			return true
		end
	end
	return false
end

function OpenAmbulanceActionsMenu()
	TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
		menu.close()
	end, {wash = false,withdraw = true})
end

function Notification(x, y, z)
	local timestamp = GetGameTimer()
	while (timestamp + 4500) > GetGameTimer() do
		Citizen.Wait(0)
		DrawText3D(x, y, z, '~r~X', 0.4)
		checking = false
	end
end
function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end
function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

local OnSleep = false
function ChooseFromNearbyPlayers(distance, cb)
	if OnSleep then
		ESX.ShowNotification('Dar har ~r~10 Saniye~s~ faghat 1 bar mitavanid in amaliat ra anjam bedid.')
		return
	end

	OnSleep = true
	SetTimeout(10000, function()
		OnSleep = false
	end)

	local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), distance + 0.0)
	local foundPlayers = false
	local elements = {}

	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			foundPlayers = true
			table.insert(elements, {source_id = GetPlayerServerId(players[i]), value = players[i]})
		end
	end

	if not foundPlayers then
	  	ESX.ShowNotification('Hich fardi dar nazdiki shoma ~r~yaft~s~ nashod!')
		OnSleep = false
		return
	end

	ESX.TriggerServerCallback('Diamond:getClosestPlayersName', function(PlayersElem)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'send_bill_to_nearby_player', {
			title    = 'Lotfan fard mored nazar ro entekhab konid:',
			align    = 'top-left',
			elements = PlayersElem
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'send_bill_confirm', {
				title    = 'Aya motmaenid ke mikhahid ' .. data.current.label .. ' ro entekhab konid?',
				align    = 'top-left',
				elements = {
					{label = 'Kheyr',  value = 'no'},
					{label = 'Bale', value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value == 'yes' then
					local target = data.current.value
					menu.close()
					local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(target)), true)
					if dist <= (distance + 0.0) then
						cb(target)
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data2, menu2)
			menu2.close()
		end)
	end, elements, 'label')
end

cuffTimer = 0

function OpenSecurityMenu()
	local elements = {
		{label = "Dastband Zadan",		value = 'handcuff'},
		{label = "Baaz Kardan Dastband",			value = 'uncuff'},
		{label = "Drag",			value = 'drag'},
	}

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'citizen_interaction',
	{
		title    = "Interaction",
		align    = 'top-left',
		elements = elements
	}, function(data2, menu2)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			local action = data2.current.value
			if action == 'handcuff' then
				if GetGameTimer() - cuffTimer < 3000 then return ESX.Alert("Spam Cuff Nakonid", "error") end
				playerPed = PlayerPedId()
				SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
				local target, distance = ESX.Game.GetClosestPlayer()
				playerheading = GetEntityHeading(PlayerPedId())
				playerlocation = GetEntityForwardVector(PlayerPedId())
				playerCoords = GetEntityCoords(PlayerPedId())
				local target_id = GetPlayerServerId(target)
				if distance <= 2.0 then
					if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
						ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
							if not Cuff then 
								if not IsInjure or not IsDead then 
									TriggerServerEvent('esx:requestarrest', target_id, playerheading, playerCoords, playerlocation, false)
									cuffTimer = GetGameTimer()
								else
									ESX.Alert("~y~Shoma Nemitavanid Player Zakhmi Ra Cuff Konid", "info")
								end
							else
								ESX.Alert("~y~Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid", "info")
							end
						end, GetPlayerServerId(target))
					else
						ESX.Alert('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!', "info")
					end
				else
					ESX.Alert('Shakhsi nazdik shoma nist')
				end
			elseif action == 'uncuff' then
				playerPed = PlayerPedId()
				SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
				local target, distance = ESX.Game.GetClosestPlayer()
				playerheading = GetEntityHeading(PlayerPedId())
				playerlocation = GetEntityForwardVector(PlayerPedId())
				playerCoords = GetEntityCoords(PlayerPedId())
				local target_id = GetPlayerServerId(target)
				if distance <= 2.0 then
					-- if exports.sr_main:GetDecor('_IS_PED_HANDCUFFED', GetPlayerPed(target)) then
						TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
					-- else
						-- ESX.Alert('Shoma Nemitavanid Dast Kasi Ke Cuff Nist Ra Baz Konid')
					-- end	
				else
					ESX.Alert('Shakhsi nazdik shoma nist', "info")
				end
			elseif action == 'drag' then
				TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
			end
		else
			ESX.Alert("Kasi Nazdik Shoma Nist", "info")
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end

function OpenMobileAmbulanceActionsMenu()
	ESX.UI.Menu.CloseAll()
	local element = {
		{
			label = _U('ems_menu'),
			value = 'citizen_interaction'
		},
		{
			label = "Req Menu",
			value = "req_menu"
		},
		{
			label = "Dispatch Queue",
			value = "queue"
		},
		{
			label = "Queue List",
			value = "saaf"
		},
		{
			label = "Unit System",
			value = "unit"
		},
		{
			label = 'MedBag',
			value = 'emote'
		},
	}
	if ESX.GetPlayerData().job.ext == "security" then
		table.insert(element, {label = "Security Menu", value = "security"})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title = _U('ambulance'),
		align = 'top-left',
		elements = element
	}, function(data, menu)
		if data.current.value == 'req_menu' then 
			menu.close()
			openMedicRequest()
		end
		if data.current.value == 'queue' then 
			menu.close()
			ExecuteCommand("mdduty")
		end
		if data.current.value == 'saaf' then 
			menu.close()
			ShowDispatchList()
		end
		if data.current.value == "security" then
			ESX.UI.Menu.CloseAll()
			OpenSecurityMenu()
		end
		if data.current.value == "unit" then
			ExecuteCommand("unitsystem")
			ESX.UI.Menu.CloseAll()
		end
		if data.current.value == "emote" then
			ExecuteCommand("e medbag")
		end
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title = _U('ems_menu_title'),
				align = 'top-left',
				elements = {
					{
						label = 'Check death cause',
						value = 'deathcause'
					},
					{
						label = 'Body Damage Checker',
						value = 'info'
					},
					{
						label = 'identify where the damage occured',
						value = 'damage'
					},
					{
						label = _U('ems_menu_revive'),
						value = 'revive'
					},
					{
						label = _U('ems_menu_small'),
						value = 'small'
					},
					{
						label = _U('ems_menu_big'),
						value = 'big'
					},
					{
						label = 'Send Bill',
						value = 'billing'
					},
					{
						label = 'Carry Injured Player',
						value = 'carry'
					},
				}
			}, function(data, menu)
				if IsBusy then
					return
				end
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 1.5 then
					ESX.ShowNotification(_U('no_players'))
				else
					if data.current.value == 'deathcause' then
						loadAnimDict('amb@medic@standing@kneel@base')
						loadAnimDict('anim@gangops@facility@servers@bodysearch@')
						local d
						local playerPed = PlayerPedId()
						ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
							if IsDead ~= false and IsDead ~= 'done' then
								d = IsDead
							else
								d = GetPedCauseOfDeath(GetPlayerPed(closestPlayer))
							end
						end, GetPlayerServerId(closestPlayer))
						TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
						TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)
						Citizen.Wait(5000)
						ClearPedTasksImmediately(playerPed)
						if checkArray(Melee, d) then
							ESX.ShowNotification(_U('hardmeele'))
						elseif checkArray(Bullet, d) then
							ESX.ShowNotification(_U('bullet'))
						elseif checkArray(Knife, d) then
							ESX.ShowNotification(_U('knifes'))
						elseif checkArray(Animal, d) then
							ESX.ShowNotification(_U('bitten'))
						elseif checkArray(FallDamage, d) then
							ESX.ShowNotification(_U('brokenlegs'))
						elseif checkArray(Explosion, d) then
							ESX.ShowNotification(_U('explosive'))
						elseif checkArray(Gas, d) then
							ESX.ShowNotification(_U('gas'))
						elseif checkArray(Burn, d) then
							ESX.ShowNotification(_U('fire'))
						elseif checkArray(Drown, d) then
							ESX.ShowNotification(_U('drown'))
						elseif checkArray(Car, d) then
							ESX.ShowNotification(_U('caraccident'))
						else
							ESX.ShowNotification(_U('unknown'))
						end
					elseif data.current.value == 'damage' then
						local bone
						local success = GetPedLastDamageBone(GetPlayerPed(closestPlayer), bone)
						local success, bone = GetPedLastDamageBone(GetPlayerPed(closestPlayer))
						if success then
							local x, y, z = table.unpack(GetPedBoneCoords(GetPlayerPed(closestPlayer), bone))
							Notification(x, y, z)
						else
							ESX.ShowNotification('Makane Khordane Zarbe Moshakhas nist')
						end
					elseif data.current.value == 'billing' then
						menu.close()
						ChooseFromNearbyPlayers(2, function(target)
							local text = '* Ghabz minevise *'
							TriggerServerEvent('3dme:shareDisplay', text, false)

							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
								title = _U('invoice_amount')
							}, function(data2, menu2)
								local amount = tonumber(data2.value)
								if amount == nil or amount < 0 or amount > 100000 then
									ESX.ShowNotification(_U('amount_invalid'))
								end

								menu2.close()

								TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Ambulance Fine***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_ambulance', "Ghabz Medic", amount)
							end, function(data2, menu2)
								menu2.close()
							end)
						end)
					elseif data.current.value == 'carry' then
						ExecuteCommand("bhnjs "..GetPlayerServerId(closestPlayer))
						menu.close()
					elseif data.current.value == 'revive' then
						ESX.UI.Menu.CloseAll()
						if IsBusy then
							return
						end
						IsBusy = true
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
									if IsDead ~= false and IsDead ~= 'done' then
										math.randomseed(GetGameTimer())
										local chance = math.random(1, 100)
										if chance < 3 then
											TriggerServerEvent('DiscordBot:ToDiscord', 'revive'..ESX.GetPlayerData().job.name, 'CHAT LOG', '***Revive Player***```css\n[REVIVER]: (' .. GetPlayerServerId(PlayerId()) .. ') '.." Steam: "..ESX.GetPlayerData().identifier.." " .. GetPlayerName(PlayerId()) .. '\n[REVIVED]: (' .. GetPlayerServerId(closestPlayer) .. ') ' .. GetPlayerName(closestPlayer) .. '\n[STATUS]: Die\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
											TriggerServerEvent('esx_ambulancejob:die', GetPlayerServerId(closestPlayer))
											ESX.ShowNotification('Farde morede Nazar Jone khodesh ro az dast dad')
											Wait(100)
										else
											ESX.UI.Menu.CloseAll()
											local camanimDict = "mini@cpr@char_a@cpr_def"
											local camanimDict1 = "mini@cpr@char_a@cpr_str"
											local playerPed = PlayerPedId()
											TriggerServerEvent('esx_ambulancejob:syncDeadBody', PedToNet(PlayerPedId()), GetPlayerServerId(closestPlayer))
											Ended = false
											exports.essentialmode:DisableControl(true)
											Citizen.CreateThread(function()
												while not Ended do
													Wait(0)
													DisableControlAction(0, Keys['F1'], true)
													DisableControlAction(0, Keys['F2'], true)
													DisableControlAction(0, Keys['F3'], true)
													DisableControlAction(0, Keys['F5'], true)
													DisableControlAction(0, Keys['R'], true)
													DisableControlAction(0, Keys['T'], true)
													DisableControlAction(0, Keys['W'], true)
													DisableControlAction(0, Keys['S'], true)
													DisableControlAction(0, Keys['A'], true)
													DisableControlAction(0, Keys['D'], true)
													DisableControlAction(0, Keys['X'], true)
													DisableControlAction(0, Keys['TAB'], true)
													DisableControlAction(0, Keys['SPACE'], true)
													DisableControlAction(0, Keys['K'], true)
													DisableControlAction(0, 24, true)
													DisableControlAction(0, 257, true)
													DisableControlAction(0, 25, true)
													DisableControlAction(0, 47, true)
													DisableControlAction(0, 264, true)
													DisableControlAction(0, 257, true)
													DisableControlAction(0, 140, true)
													DisableControlAction(0, 141, true)
													DisableControlAction(0, 142, true)
													DisableControlAction(0, 143, true)
													DisableControlAction(0, 263, true)
													DisableControlAction(0, 27, true)
												end
											end)
											ESX.Streaming.RequestAnimDict(camanimDict1)
											ESX.Streaming.RequestAnimDict(camanimDict, function()
												Citizen.Wait(500)
												TaskPlayAnim(playerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
												Citizen.Wait(15800)
												TaskPlayAnim(playerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
												Citizen.Wait(5000)
												TaskPlayAnim(playerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
												Citizen.Wait(28600)
												ClearPedTasksImmediately(PlayerPedId())
												Ended = true
											end)
											ESX.ShowNotification(_U('revive_inprogress'))
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer), 150)
											TriggerServerEvent('DiscordBot:ToDiscord', 'revive'..ESX.GetPlayerData().job.name, 'CHAT LOG', '***Revive Player***```css\n[REVIVER]: (' .. GetPlayerServerId(PlayerId()) .. ') ' .." Steam: "..ESX.GetPlayerData().identifier.." " ..  GetPlayerName(PlayerId()) .. '\n[REVIVED]: (' .. GetPlayerServerId(closestPlayer) .. ') ' .. GetPlayerName(closestPlayer) .. '\n[STATUS]: Complete\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
											exports.essentialmode:DisableControl(false)
											if Config.ReviveReward > 0 then
												ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward))
											else
												ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
											end
										end
									else
										ESX.ShowNotification(_U('player_not_unconscious'))
									end
								end, GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
							IsBusy = false
						end, 'medikit')
					elseif data.current.value == 'small' then
						if IsPedInAnyVehicle(PlayerPedId()) then return ESX.Alert("Shoma Nemitavanid Dar Mashin In Kar Ra Bokonid", "info") end
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)
								if health > 0 then
									local playerPed = PlayerPedId()
									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)
									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')
					elseif data.current.value == 'big' then
						if IsPedInAnyVehicle(PlayerPedId()) then return ESX.Alert("Shoma Nemitavanid Dar Mashin In Kar Ra Bokonid", "info") end
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)
								if health > 0 then
									local playerPed = PlayerPedId()
									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)
									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'medikit')
					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif data.current.value == 'carry' then
						local coords = GetEntityCoords(GetPlayerPed(closestPlayer))
						local distance = ESX.GetDistance(coords,GetEntityCoords(PlayerPedId()))
						if distance < 50 then
							Citizen.SetTimeout(1000,function()
								ExecuteCommand('carry')
							end)
						else
							ESX.ShowNotification('Fard mored nazar az shoma door ast!')
						end
					else
						exports.esx_ambulancejob:GetClosetStat()
						return
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()
	DoScreenFadeOut(800)
	Citizen.Wait(800)
	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)
		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

function TriggerAmbulanceCitizen()
	Citizen.CreateThread(function()
		while PlayerData and PlayerData.job and (PlayerData.job.name == "ambulance" or PlayerData.job.name == "medic") do
			Citizen.Wait(0)
			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum
			for hospitalNum, hospital in pairs(Config.Hospitals) do
				for k,v in ipairs(hospital.AmbulanceActions) do
					local distance = GetDistanceBetweenCoords(playerCoords, v, true)
					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < Config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
					end
				end
				for k,v in ipairs(hospital.CloakRoom) do
					local distance = GetDistanceBetweenCoords(playerCoords, v, true)
					if distance < Config.DrawDistance then
						DrawMarker(42, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < Config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'CloakRoom', k
					end
				end
				for k,v in ipairs(hospital.Pharmacies) do
					local distance = GetDistanceBetweenCoords(playerCoords, v, true)
					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < Config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacies', k
					end
				end
				for k,v in ipairs(hospital.Vehicles) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)
					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < v.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
					end
				end
				for k,v in ipairs(hospital.VehiclesDeleter) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.Deleter, true)
					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < v.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'VehiclesDeleter', k
					end
				end
				for k,v in ipairs(hospital.Armory) do
					local distance = GetDistanceBetweenCoords(playerCoords, v, true)
					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < Config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Armory', k
					end
				end
				for k,v in ipairs(hospital.Helicopters) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)
					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false
					end
					if distance < v.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
					end
				end
			end
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end
				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum
				TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
			end
			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
			end
		end
		if letSleep then
			Citizen.Wait(500)
		end
	end)
end

RegisterNetEvent('esx_ambulancejob:finishCPR')
AddEventHandler('esx_ambulancejob:finishCPR', function(ped)
	local NersPed = NetToPed(ped)
	local PlayerPed = PlayerPedId()
	local coords = GetEntityCoords(PlayerPed)
	local head = GetEntityHeading(PlayerPed)
	local camanimDict = "mini@cpr@char_b@cpr_def"
	local camanimDict1 = "mini@cpr@char_b@cpr_str"
	local loadedanim = false
	beingRevived = true
	ESX.Streaming.RequestAnimDict(camanimDict1)
	ESX.Streaming.RequestAnimDict(camanimDict, function()
		loadedanim = true
	end)
	while not loadedanim do
		Citizen.Wait(5)
	end
	ClearPedTasksImmediately(PlayerPed)
	AttachEntityToEntity(PlayerPed, NersPed, 28422, -0.1, 1.15, 0.0, 0.0, 0.0, 75.0, false, false, false, true, 2, true)
	TaskPlayAnim(PlayerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(800)
	DetachEntity(PlayerPed, true, false)
	Citizen.Wait(15000)
	TaskPlayAnim(PlayerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
	Citizen.Wait(5000)
	TaskPlayAnim(PlayerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(28600)
	ClearPedTasksImmediately(PlayerPed)
	exports.essentialmode:DisableControl(false)
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if part == 'AmbulanceActions' then
		CurrentAction = part
		CurrentActionMsg = _U('actions_prompt')
		CurrentActionData = {}
	elseif part == 'Pharmacies' then
		CurrentAction = part
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	elseif part == 'CloakRoom' then
		CurrentAction = part
		CurrentActionMsg = '~INPUT_CONTEXT~ Open Clothes Menu'
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction = part
		CurrentActionMsg = '~INPUT_CONTEXT~ Open Locker'
		CurrentActionData = {}
	elseif part == 'Vehicles' then
		CurrentAction = part
		CurrentActionMsg = _U('garage_prompt')
		CurrentActionData = {
			hospital = hospital,
			partNum = partNum
		}
	elseif part == 'VehiclesDeleter' then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if DoesEntityExist(vehicle) then
				CurrentAction = 'VehiclesDeleter'
				CurrentActionMsg = 'press ~INPUT_CONTEXT~ to delete vehicle'
				CurrentActionData = {
					vehicle = vehicle
				}
			end
		else
			return
		end
	elseif part == 'Helicopters' then
		CurrentAction = part
		CurrentActionMsg = _U('helicopter_prompt')
		CurrentActionData = {
			hospital = hospital,
			partNum = partNum
		}
	elseif part == 'FastTravelsPrompt' then
		local travelItem = Config.Hospitals[hospital][part][partNum]
		CurrentAction = part
		CurrentActionMsg = travelItem.Prompt
		CurrentActionData = {
			to = travelItem.To.coords,
			heading = travelItem.To.heading
		}
	end
end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end
	CurrentAction = nil
end)

AddEventHandler("onKeyUP", function(key)
	if key == "e" then
		if CurrentAction then
			if CurrentAction == 'AmbulanceActions' then
				OpenAmbulanceActionsMenu()
			elseif CurrentAction == 'Armory' then
				OpenArmoryMenu()
			elseif CurrentAction == 'CloakRoom' then
				OpenCloakroomMenu()
			elseif CurrentAction == 'Pharmacies' then
				OpenPharmacyMenu()
			elseif CurrentAction == 'Vehicles' then
				OpenVehicleSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
			elseif CurrentAction == 'VehiclesDeleter' then
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			elseif CurrentAction == 'Helicopters' then
				OpenHelicopterSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
			elseif CurrentAction == 'FastTravelsPrompt' then
				FastTravel(CurrentActionData.to, CurrentActionData.heading)
			end
			CurrentAction = nil
		end
	end
end)

AddEventHandler("onKeyUP", function(key)
	if key == "f6" then
		if PlayerData and PlayerData.job and (PlayerData.job.name == "ambulance" or PlayerData.job.name == "medic") and not IsDead and Ended then
			OpenMobileAmbulanceActionsMenu()
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i = maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

function OpenCloakroomMenu()
	local elem = {
		{
			label = _U('ems_clothes_civil'),
			value = 'citizen_wear'
		},
		{
			label = _U('ems_clothes_ems'),
			value = 'ambulance_wear'
		},
		{
			label = "Custom Clothe",
			value = 'custom'
		}
	}
	
	if PlayerData.job.grade_name == 'boss' then
		table.insert(elem, {label = 'Lebas Dispatch', value = 'dispatch'})
		table.insert(elem, {label = 'Lebas Heli', value = 'heli'})
		table.insert(elem, {label = 'Lebas Surgeon', value = 'surgeon'})
		table.insert(elem, {label = 'Lebas Surgeon', value = 'security'})
		table.insert(elem, {label = 'Lebas Psychology', value = 'psy'})
	end

	if ESX.GetPlayerData().job.ext == 'dispatch' then
		table.insert(elem, {label = 'Lebas Dispatch', value = 'dispatch'})
	elseif ESX.GetPlayerData().job.ext == 'heli' then
		table.insert(elem, {label = 'Lebas Heli', value = 'heli'})
	elseif ESX.GetPlayerData().job.ext == 'surgeon' then
		table.insert(elem, {label = 'Lebas Surgeon', value = 'surgeon'})
	elseif ESX.GetPlayerData().job.ext == 'security' then
		table.insert(elem, {label = 'Lebas Surgeon', value = 'security'})
	elseif ESX.GetPlayerData().job.ext == 'psy' then
		table.insert(elem, {label = 'Lebas Psychology', value = 'psy'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		align = 'top-left',
		elements = elem
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			TriggerServerEvent('duty', ESX.PlayerData.job.name, false)
			return
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'dispatch' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleDispatchClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, ESX.PlayerData.job.name, ESX.PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'heli' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleHeliClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, ESX.PlayerData.job.name, ESX.PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'custom' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleCustomClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'surgeon' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleSurgeonClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, ESX.PlayerData.job.name, ESX.PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'psy' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandlePSYClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, ESX.PlayerData.job.name, ESX.PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'security' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleSecurityClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, ESX.PlayerData.job.name, ESX.PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		end
		TriggerServerEvent('duty', ESX.PlayerData.job.name, true)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end
function SpawnVehicle(vehicle, plate, coords, heading)
	local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
	if not DoesEntityExist(shokol) then
		ESX.Game.SpawnVehicle(vehicle.model, {
			x = coords.x,
			y = coords.y,
			z = coords.z + 1
		}, heading, function(callback_vehicle)
			SetVehicleNumberPlateText(callback_vehicle, plate)
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			ESX.CreateVehicleKey(callback_vehicle)
			Citizen.Wait(1000)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			TriggerServerEvent('savedVehicles', 'ambulance', VehToNet(callback_vehicle))
			Citizen.Wait(2000)
			local targetBlip = AddBlipForEntity(callback_vehicle)
			SetBlipSprite(targetBlip, 225)
			exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
			TriggerServerEvent('DiscordBot:ToDiscord', 'spawn'..ESX.GetPlayerData().job.name, 'JOBS LOG', GetPlayerName(PlayerId()).." | "..PlayerData.name.." Ba Ranke "..PlayerData.job.grade.." Mashin Ba Pelake "..plate.." Ra Biroon Avord.", 'user', GetPlayerServerId(PlayerId()), true, false)
		end)
	else
		ESX.ShowNotification('Mahale Spawn mashin ro Khali konid')
	end
end
function OpenVehicleSpawnerMenu(station, partNum)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback("esx_society:GetVehiclesByPermission", function(Cars, AccessAll) 
		if not AccessAll then
			if Cars ~= nil then
				local elements = {}
				for i=1, #Cars, 1 do
					table.insert(elements, {
						label = ESX.GetVehicleLabelFromName(Cars[i]), 
						model = Cars[i]
					})
				end
				if #elements == 0 then
					ESX.ShowNotification("~y~Shoma Be Hich Mashini Dastresi Nadarid")
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
					title = _U('vehicle_menu'),
					align = 'top-left',
					elements = elements
				}, function(data, menu)
					menu.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin'
					}, function(data3, menu3)
						if not ESX.IsPlateValid(data3.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
						if data3.value == nil then
							ESX.ShowNotification('Lotfan yek pelak vared konid')
						else
							menu3.close()
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, 'Vehicles', partNum)
							if foundSpawn then
								ESX.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
									ESX.TriggerServerCallback('esx:callbackVehicle', function(status)
										if status then
											ESX.Alert("In Pelak Motalegh Be Kasi Ast")
										else
											SpawnVehicle(json.decode(veh), data3.value, spawnPoint.coords, spawnPoint.heading)
										end
									end, data3.value)
								end, data.current.model)
							else
								ESX.ShowNotification(_U('garage_notavailable'))
							end
						end
					end, function(data3, menu3)
						menu3.close()
						CurrentAction = 'menu_vehicle_spawner'
						CurrentActionMsg = _U('garage_prompt')
						CurrentActionData = {
							station = station,
							partNum = partNum
						}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction = 'menu_vehicle_spawner'
					CurrentActionMsg = _U('garage_prompt')
					CurrentActionData = {
						station = station,
						partNum = partNum
					}
				end)
			end
		else
			if Cars ~= nil then
				local elements = {}
				for k, v in pairs(Cars) do
					table.insert(elements, {
						label = ESX.GetVehicleLabelFromName(v.model), 
						model = v.model
					})
				end
				if #elements == 0 then
					ESX.ShowNotification("~y~Shoma Be Hich Mashini Dastresi Nadarid")
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
					title = _U('vehicle_menu'),
					align = 'top-left',
					elements = elements
				}, function(data, menu)
					menu.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin'
					}, function(data3, menu3)
						if not ESX.IsPlateValid(data3.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
						if data3.value == nil then
							ESX.ShowNotification('Lotfan yek pelak vared konid')
						else
							menu3.close()
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, 'Vehicles', partNum)
							if foundSpawn then
								ESX.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
									ESX.TriggerServerCallback('esx:callbackVehicle', function(status)
										if status then
											ESX.Alert("In Pelak Motealegh Be Kasi Ast")
										else
											SpawnVehicle(json.decode(veh), data3.value, spawnPoint.coords, spawnPoint.heading)
										end
									end, data3.value)
								end, data.current.model)
							else
								ESX.ShowNotification(_U('garage_notavailable'))
							end
						end
					end, function(data3, menu3)
						menu3.close()
						CurrentAction = 'menu_vehicle_spawner'
						CurrentActionMsg = _U('garage_prompt')
						CurrentActionData = {
							station = station,
							partNum = partNum
						}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction = 'menu_vehicle_spawner'
					CurrentActionMsg = _U('garage_prompt')
					CurrentActionData = {
						station = station,
						partNum = partNum
					}
				end)
			end
		end
	end)
end

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}
	if #vehicles > 0 then
		for k, v in ipairs(vehicles) do
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		ESX.ShowNotification(_U('garage_store_nearby'))
		return
	end
	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true
			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1
				if attempts > 30 then
					break
				end
				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k, v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end
			IsBusy = false
			ESX.ShowNotification(_U('garage_has_stored'))
		else
			ESX.ShowNotification(_U('garage_has_notstored'))
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(hospital, part, partNum)
	local spawnPoints = Config.Hospitals[hospital][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil
	for i = 1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end
	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('garage_blocked'))
		return false
	end
end

function OpenHelicopterSpawnerMenu(hospital, partNum)
	local elements = {}
	--[[if ESX.PlayerData.job.grade >= 3 then
		table.insert(elements, {
			model = 'buzzard2',
			label = 'Nagasaki Buzzard'
		})
	else
		ESX.ShowNotification(_U('helicopter_notauthorized'))
		return
	end]]
	if PlayerData.job.ext == "heli" then
		table.insert(elements, {
			model = 'polmedik',
			label = 'EMS heli'
		})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title = _U('garage_title'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local model = data.current.model
		local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Helicopters', partNum)
		if not DoesEntityExist(vehicle) then
			local playerPed = PlayerPedId()
			if foundSpawn then
				ESX.Game.SpawnVehicle(model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
					ESX.CreateVehicleKey(vehicle)
					Citizen.Wait(1000)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					SetVehicleModKit(vehicle, 1)
					SetVehicleLivery(vehicle, 1)
					SetVehicleMods(vehicle, true, 27, 27, 27)
					Citizen.Wait(2000)
					exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
					TriggerServerEvent('savedVehicles', 'ambulance', VehToNet(vehicle))
					TriggerServerEvent('DiscordBot:ToDiscord', 'spawn'..ESX.GetPlayerData().job.name, 'JOBS LOG', GetPlayerName(PlayerId()).." | "..ESX.GetPlayerData().name.." Ba Ranke "..ESX.GetPlayerData().job.grade.." Helicopter Ba Pelake "..GetVehicleNumberPlateText(vehicle).." Ra Biroon Avord.", 'user', GetPlayerServerId(PlayerId()), true, false)
				end)
			else
				ESX.ShowNotification(_U('garage_notavailable'))
			end
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'menu_vehicle_spawner'
		CurrentActionMsg = _U('vehicle_spawner')
		CurrentActionData = {
			station = station,
			partNum = partNum
		}
	end)
end
function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title = _U('vehicleshop_title'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align = 'top-left',
			elements = {
				{
					label = _U('confirm_no'),
					value = 'no'
				},
				{
					label = _U('confirm_yes'),
					value = 'yes'
				}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local props = ESX.Game.GetVehicleProperties(vehicle)
				props.plate = newPlate
				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function(bought)
					if bought then
						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))
						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						ESX.ShowNotification(_U('vehicleshop_money'))
						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()
		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)
	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInShopMenu then
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
		else
			Citizen.Wait(500)
		end
	end
end)
function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end
function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true)
			DisableControlAction(0, Keys['BACKSPACE'], true)
			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end
function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_ambulancejob:getStockItems', function(items)
		ESX.TriggerServerCallback('esx_society:GetItemsByPermission', function(access, all)
			local elements = {}
			if all then
				for i=1, #items, 1 do
					if items[i].name ~= nil and items[i].label ~= nil and items[i].count > 0 then
						table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. (items[i].label or "Unknown"), value = items[i].name})
					end
				end
			else
				for i=1, #items, 1 do
					for k, v in pairs(access) do
						if items[i].name == v and items[i].count > 0 then
							table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. (items[i].label or "Unknown"), value = items[i].name})
						end
					end
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title = 'Locker',
				align = 'top-left',
				elements = elements
			}, function(data, menu)
				local itemName = data.current.value
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = 'Tedad ra vared konid'
				}, function(data2, menu2)
					local count = tonumber(data2.value)
					if count == nil then
						ESX.ShowNotification('Tedad ro Eshtebah vared kardid')
					else
						menu2.close()
						menu.close()
						if string.find(itemName, "casino") ~= nil then return end
						TriggerServerEvent('esx_ambulancejob:getStockItem', itemName, count)
						Citizen.Wait(300)
						OpenGetStocksMenu()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
			end)
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
		local elements = {}
		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Locker',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Tedad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil then
					ESX.ShowNotification('Tedad ra Eshtebah vared kardid')
				else
					menu2.close()
					menu.close()
					if string.find(itemName, "casino") ~= nil then return end
					TriggerServerEvent('esx_ambulancejob:putStockItems', itemName, count)
					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{
			label = 'Bardashtane Item',
			value = 'get_stock'
		},
		{
			label = 'Gozashtan Item',
			value = 'put_stock'
		},
		-- {
		-- 	label = 'Personal Stash',
		-- 	value = 'stash'
		-- },
	}
	if ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {
			label = _U('buy_items'),
			value = 'buy_items'
		})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title = 'Locker',
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == "stash" then
            ESX.UI.Menu.CloseAll()
            TriggerEvent("esx_inventoryhud:OpenStash", PlayerData.job.name)
            return 
        end
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'buy_items' then
			OpenBuyStockMenu()
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'Armory'
		CurrentActionMsg = '~INPUT_CONTEXT~ Open Locker'
		CurrentActionData = {}
	end)
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function OpenBuyStockMenu()
	ESX.TriggerServerCallback('esx_ambulancejob:getStockItems', function(inventory)
		local elements = {}
		for i = 1, #Config.AuthorizedItems, 1 do
			local item = Config.AuthorizedItems[i]
			local count = 0
			for i2 = 1, #inventory, 1 do
				if inventory[i2].name == item.name then
					count = inventory[i2].count
					break
				end
			end
			table.insert(elements, {
				label = 'x' .. count .. ' ' .. item.label .. ' $' .. item.price,
				value = item.name,
				price = item.price
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_stock', {
			title = _U('buy_stock_menu'),
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_ambulancejob:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_addonaccount:addStockItems', data.current.value)
					OpenBuyStockMenu()
				else
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end, data.current.price)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title = _U('pharmacy_menu_title'),
		align = 'top-left',
		elements = {
			{
				label = _U('pharmacy_take', _U('medikit')),
				value = 'medikit'
			},
			{
				label = _U('pharmacy_take', _U('bandage')),
				value = 'bandage'
			}
		}
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped)
	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
	if distance ~= -1 and distance <= 5.0 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
		for i = maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end
		if freeSeat then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	if GetInvokingResource() then return end
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)
	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		ESX.SetEntityHealth(playerPed, newHealth)
		medicResetADR()
		afterCrawlRevive = false
	elseif healType == 'big' then
		ESX.SetEntityHealth(playerPed, maxHealth)
		medicResetADR()
		afterCrawlRevive = false
	end
	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

function SetVehicleMods(vehicle, color, colorA, colorB, colorC)
	local props = {}
	if not color then
		props = {
			modEngine = 3,
			modBrakes = 2,
			windowTint = -1,
			modArmor = 4,
			modTransmission = 2,
			modSuspension = -1,
			modTurbo = true
		}
	else
		props = {
			modEngine = 3,
			modBrakes = 2,
			windowTint = -1,
			modArmor = 4,
			modTransmission = 2,
			modSuspension = -1,
			color1 = colorA,
			color2 = colorB,
			pearlescentColor = colorC,
			modTurbo = true
		}
	end
	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function MainDrawTxt(x, y, width, height, scale, text, r, g, b, a, _)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end

local carblip                 = 0
local drawInD                 = false

local function openRequst(id)
	local id = id
    ESX.TriggerServerCallback('medic:getlist', function(data)
        ems = data
        elements = {}
        emoji = "❌"
        if ems[id].accept then
            emoji = "✔️"
        end
        table.insert(elements,{label = "Id : ".. ems[id].source,value = "no"})
        table.insert(elements,{label = "Accept status : ".. emoji,value = "no"})
        if ems[id].accept then
            table.insert(elements,{label = "Accepted by : ".. ems[id].acceptername,value = "no"})
        else
            table.insert(elements,{label = "Accept",value = "accept"})
        end
        if ems[id].acceptersource == GetPlayerServerId(PlayerId()) then
            table.insert(elements,{label = "Decline",value = "decline"})
            table.insert(elements,{label = "Finish",value = "finish"})
        end
        table.insert(elements,{label = "Pin location",value = "pin"})
        local source = ems[id].source
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list2', 
		{
            title    = 'Request list',
            align    = 'top-left',
            elements = elements
        }, function(data2, menu2)
            if data2.current.value == "accept" then
				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
				ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
                TriggerServerEvent('medic:accept',id, mugshotStr)
                openRequst(id)
				Citizen.Wait(1000)
				ESX.TriggerServerCallback('getplayercoords', function(coords)
                    if coords ~= nil then
                        SetNewWaypoint(coords.x,coords.y)
                        SetNewWaypoint(coords.x,coords.y)
						ESX.Alert("Location Request Mark Shod", "info")
                    end
                end,source)
            elseif data2.current.value == "decline" then
                TriggerServerEvent('medic:decline',id)
				ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
                openRequst(id)
            elseif data2.current.value == "finish" then
                TriggerServerEvent('medic:finish',id)
                menu2.close()
            elseif data2.current.value == "pin" then
                ESX.TriggerServerCallback('getplayercoords', function(coords)
                    if coords ~= nil then
                        SetNewWaypoint(coords.x,coords.y)
                        SetNewWaypoint(coords.x,coords.y)
						ESX.Alert("Location Request Mark Shod", "info")
                    end
                end,source)
            elseif data2.current.value == "call" then
                --TriggerEvent('gcphone:autoCall',ems[id].number)
                --exports['sunset_phone']:Call({number = ems[id].number,name = ems[id].number})
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end)
end

function openMedicRequest()
	ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('medic:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            local elements = {}
            for k , v in pairs(ems) do
                if v.show and v.job == "all" or v.job == PlayerData.job.name then
                    emoji = "❌"
                    if v.accept then
                        emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
                    end
                    table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .." | Distance : ".. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)),value = k})
                end
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', 
			{
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data2, menu)
                menu.close()
                local id = tonumber(data2.current.value)
                openRequst(id)
            end, function(data2, menu)
                menu.close()
            end)
        end
    end)
end

RegisterNetEvent('medic:openAdmin',function()
    ESX.TriggerServerCallback('medic:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            elements = {}
            for k , v in pairs(ems) do
                emoji = "❌"
                if v.accept then
                    emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
                end
                table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .." | Distance : ".. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)) ,value = k})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', 
			{
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data2, menu)
                menu.close()
                local id = tonumber(data2.current.value)
                openRequst(id)
            end, function(data2, menu)
                menu.close()
            end)
        end
    end)
end)

RegisterNetEvent('medic:addemsblip',function(id,coords,mug,name)
	print(mug)
    local id = id
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
    Wait(2000)
	carblip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(carblip, 198)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,1)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Ambulance nurse')
	EndTextCommandSetBlipName(carblip)
    while carblip ~= 0 do
        Wait(1000)
        ESX.TriggerServerCallback('getplayercoords', function(coords)
            if coords ~= nil then
                SetBlipCoords(carblip, coords.x, coords.y, coords.z)
            else
                RemoveBlip(carblip)
                carblip = 0
            end
        end,id)
		ESX.ShowAdvancedNotification(name, '~g~Dar rah ast~s~', 'Lotfan sabur bashid', mug, 7)
    end
end)

RegisterNetEvent('medic:deleteblip',function()
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
end)

function ShowDispatchList()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('getambulanceDispatchList', function(list)
		local elements = {}
		for k, v in pairs(list) do
			table.insert(elements, {label = v.name.."("..v.id..")", value = nil, join = v.join})
		end
		table.sort(elements, function(a, b)
			return a.join < b.join
		end)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'disptach_list', 
		{
			title    = 'Dispatch List',
			align    = 'top-left',
			elements = elements
		}, function(data2, menu)

		end, function(data2, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('medic:acceptq',function(id)
	local id = id
	local clicked = false
	ESX.UI.Menu.CloseAll()
    local elements = {
        {label = 'Bale', value = true},
        {label = 'Kheyr', value = false},
    }
	ExecuteCommand('f Darkhast ' .. id .. ' baraye man ersal shod')
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'a' .. id,
    {
		title 	 = 'Darkhast jadid!',
		align    = 'center',
		question = 'Aya mayel be ghabul kardan darkhast hastid?',
		elements = elements
    }, function(data, menu)
		clicked = true
        menu.close()
		if data.current.value then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
			TriggerServerEvent('medic:accept',id,mugshotStr)
			ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
		else
			ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
			TriggerServerEvent("medic:reject", id)
		end
    end)

    Citizen.SetTimeout(10000,function()
        if not clicked then
            ESX.UI.Menu.Close('question',GetCurrentResourceName(), 'a' .. id)
            ExecuteCommand('f Darkhast ' .. id .. ' be dalil AFK reject shod!')
			TriggerServerEvent("medic:reject", id)
        end
    end)
end)

RegisterNetEvent('medic:acceptKarde',function()
    if not drawInD then
        drawInD = true
        reqid = 0
        Citizen.CreateThread(function()
            while drawInD do
                Citizen.Wait(0)
                ESX.ShowMissionText('~y~Request in progress('.. reqid ..')')
            end
        end)
        Citizen.CreateThread(function()
            while drawInD do
                local bedeBezanim = false
                ESX.TriggerServerCallback('medic:getlist', function(data)
                    ems = data
                    for k , v in pairs(ems) do
                        if v.acceptersource and v.acceptersource == GetPlayerServerId(PlayerId()) then
                            bedeBezanim = true
                            reqid = v.source
                        end
                    end
                    if not bedeBezanim then
                        drawInD = false
                    end
                end)
                Citizen.Wait(10000)
            end
        end)
    end
end)

function CountTable(object)
    local count = 0
    for k,v in pairs(object) do
        count = count + 1
    end
    return count
end
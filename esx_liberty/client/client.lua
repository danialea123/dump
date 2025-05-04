---@diagnostic disable: lowercase-global, undefined-field, undefined-global, param-type-mismatch, missing-parameter
holdingup = false
hackholdingup = false
bombholdingup = false
bank = ""
hacked = false
planted = false
savedbank = {}
secondsRemaining = 0
platingbomb = false
platingbombtime = 20
blipRobbery = nil


ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function CountTime(con)
	if _G[con] and (secondsRemaining > 0)then
		secondsRemaining = secondsRemaining - 1
		if secondsRemaining == 0 then
			CancelKey = UnregisterKey(CancelKey)
		end
		SetTimeout(1000, function ()
			CountTime(con)
		end)
	end
end

function DisplayTimer(con)
	if _G[con] and (secondsRemaining > 0)then
		if con == 'holdingup' then
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('robbery_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)
		elseif con == 'hackholdingup' then
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('hack_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)
		elseif con == 'bombholdingup' then
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('bomb_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)
		end

		SetTimeout(0, function ()
			DisplayTimer(con)
		end)
	end
end

RegisterNetEvent('esx_libertybank:currentlyrobbing')
AddEventHandler('esx_libertybank:currentlyrobbing', function(robb)
	holdingup = true
	bank = robb
	secondsRemaining = 600
	CountTime('holdingup')
	DisplayTimer('holdingup')
	Hint:Create(_U('press_to_cancel'))
	CancelKey = RegisterKey('E', false, function ()
		CancelKey = UnregisterKey(CancelKey)
		Hint:Delete()
		TriggerServerEvent('esx_libertybank:toofar', bank)
		TriggerEvent('esx_blowtorch:stopblowtorching')
	end)
	TriggerEvent('esx_blowtorch:startblowtorch')
end)

RegisterNetEvent('esx_libertybank:currentlyhacking')
AddEventHandler('esx_libertybank:currentlyhacking', function(robb, thisbank)
	hackholdingup = true
	ExecuteCommand("e type4")
	SetEntityHeading(PlayerPedId(), 234.23)
	--TriggerEvent("mhacking:show")
	--TriggerEvent("mhacking:start",7,150, opendoors)
	local success = exports['dz-chimpminigame']:StartMinigame(10 --[[solutions]], 90 --[[time in second]])
	opendoors(success)
	savedbank = thisbank
	bank = robb
	secondsRemaining = 600
	CountTime('hackholdingup')
	DisplayTimer('hackholdingup')
end)

RegisterNetEvent('esx_libertybank:plantingbomb')
AddEventHandler('esx_libertybank:plantingbomb', function(robb, thisbank)
	bombholdingup = true
	savedbank = thisbank
	bank = robb
	secondsRemaining = 10
	plantBombAnimation(secondsRemaining)
	CountTime('bombholdingup')
	DisplayTimer('bombholdingup')
	planted = true
end)

function opendoors(success)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerEvent('esx_libertybank:hackcomplete')
	else
		hackholdingup = false
		ESX.ShowNotification(_U('hack_failed'))
		TriggerEvent('mhacking:hide')
		secondsRemaining = 0
		incircle = false
		TriggerServerEvent("esx_libertybank:toofar")
	end
	ClearPedTasks(PlayerPedId())
end

RegisterNetEvent('esx_libertybank:killblip')
AddEventHandler('esx_libertybank:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_libertybank:setblip')
AddEventHandler('esx_libertybank:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
	SetTimeout(12*1000*60, function()
		RemoveBlip(blipRobbery)
	end)
end)

RegisterNetEvent('esx_libertybank:toofarlocal')
AddEventHandler('esx_libertybank:toofarlocal', function(robb)
	holdingup = false
	bombholdingup = false
	hacked = false
	planted = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_libertybank:toofarlocalhack')
AddEventHandler('esx_libertybank:toofarlocalhack', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_libertybank:robberycomplete')
AddEventHandler('esx_libertybank:robberycomplete', function(reward)
	holdingup = false
	Hint:Delete()
	CancelKey = UnregisterKey(CancelKey)
	ESX.ShowNotification(_U('robbery_complete', reward))
	TriggerServerEvent('esx_libertybank:closedoor', bank)
	TriggerEvent('esx_blowtorch:stopblowtorching')
	bank = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_libertybank:hackcomplete')
AddEventHandler('esx_libertybank:hackcomplete', function()
	hackholdingup = false
	ESX.ShowNotification(_U('hack_complete'))

	--[[for i=1, Banks[bank].doors do
		TriggerServerEvent('sr_doorlock:updateStateWithScript', bank, i, false)
	end]]

	bank = ""
	hacked = true
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_libertybank:plantbombcomplete')
AddEventHandler('esx_libertybank:plantbombcomplete', function(bank)
	bombholdingup = false


	ESX.ShowNotification(_U('bombplanted_run'))
	TriggerServerEvent('esx_libertybank:plantbombtoall', bank.bombposition.x,  bank.bombposition.y, bank.bombposition.z, bank.bombdoortype)
	incircle = false
end)

RegisterNetEvent('esx_libertybank:plantedbomb')
AddEventHandler('esx_libertybank:plantedbomb', function(x,y,z)
	local coords = {x,y,z}
	local obs, distance = ESX.Game.GetClosestObject('v_ilev_bk_vaultdoor', coords)
    AddExplosion( x,  y, z , 0, 0.5, 1, 0, 1065353216, 0)
    AddExplosion( x,  y, z , 0, 0.5, 1, 0, 1065353216, 0)
	--TriggerServerEvent('sr_doorlock:updateStateWithScript', 'PrincipalBank', 2, false)
	local rotation = GetEntityHeading(obs) + 47.2869
	SetEntityHeading(obs,rotation)
	globalbombcoords = coords
	globalbombrotation = rotation
	globalbombDoortype = 'v_ilev_bk_vaultdoor'
	local timer = 900
	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(2000)
			local obs, distance = ESX.Game.GetClosestObject(globalbombDoortype, globalbombcoords)
			SetEntityHeading(obs, globalbombrotation)
			Citizen.Wait(0)
			timer = timer - 2
		end
	end)
end)

Citizen.CreateThread(function()
	--[[for k,v in pairs(Banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 255)--156
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 75)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('bank_robbery'))
		EndTextCommandSetBlipName(blip)
	end]]
	local salam = AddBlipForCoord(-1034.55,-2137.0,13.59)
	SetBlipSprite(salam, 605)--156
	SetBlipScale(salam, 0.6)
	--SetBlipColour(salam, 25)
	SetBlipAsShortRange(salam, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Liberty Bank")
	EndTextCommandSetBlipName(salam)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Banks)do
		local Interact
		local Key
		local Point = RegisterPoint(v.position, 15, true)
		local HInteract
		local HPoint = RegisterPoint(v.hackposition, 15, true)

		Point.set('InArea', function()
			if not holdingup and hacked then
				DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
			end
		end)
	
		Point.set('InAreaOnce', function ()
			Interact = RegisterPoint(v.position, 2, true)
			Interact.set('InAreaOnce', function ()
				if hacked then
					Hint:Create(_U('press_to_rob') .. v.nameofbank)
				end
				Key = RegisterKey('E', false, function ()
					if hacked then
						ESX.DoesHaveItem('blowtorch', 1, function()
							Key = UnregisterKey(Key)
							Hint:Delete()
							TriggerServerEvent('esx_libertybank:rob', k, v.position)
						end, "Blowtorch")
					end
				end)
			end, function ()
				Key = UnregisterKey(Key)
				Hint:Delete()
			end)
		end, function ()
			if holdingup then
				TriggerServerEvent('esx_libertybank:toofar', bank)
			end
			Interact = Interact.remove()
		end)

		HPoint.set('InArea', function()
			if not hackholdingup and not hacked then
				DrawMarker(1, v.hackposition.x, v.hackposition.y, v.hackposition.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
			end
		end)

		HPoint.set('InAreaOnce', function ()
			HInteract = RegisterPoint(v.hackposition, 2, true)
			HInteract.set('InAreaOnce', function ()
				if not hacked then 
					Hint:Create(_U('press_to_hack') .. v.nameofbank)
				end
				Key = RegisterKey('E', false, function ()
					if not hacked then
						ESX.DoesHaveItem('net_cracker', 1, function()
							Key = UnregisterKey(Key)
							Hint:Delete()
							TriggerServerEvent('esx_libertybank:hack', k)
						end, "Hacker Laptob")
					end

				end)
			end, function ()
				Key = UnregisterKey(Key)
				Hint:Delete()
			end)
		end, function ()
			HInteract = HInteract.remove()
		end)

		if v.bombposition then
			local BInteract
			local BPoint = RegisterPoint(v.bombposition, 15, true)
			BPoint.set('InArea', function()
				if not bombholdingup and hacked and not planted then
					DrawMarker(1, v.bombposition.x, v.bombposition.y, v.bombposition.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
				end
			end)
			
			BPoint.set('InAreaOnce', function ()
				BInteract = RegisterPoint(v.bombposition, 1, true)
				BInteract.set('InAreaOnce', function ()
					if hacked and not planted then
						Hint:Create(_U('press_to_bomb') .. v.nameofbank)
					end
					Key = RegisterKey('E', false, function ()
						if hacked then
							Key = UnregisterKey(Key)
							Hint:Delete()
							TriggerServerEvent('esx_libertybank:plantbomb', k)
						end
					end)
				end, function ()
					Key = UnregisterKey(Key)
					Hint:Delete()
				end)
			end, function ()
				BInteract = BInteract.remove()
			end)
		end
	end
end)

function plantBombAnimation(timer)
	local playerPed = PlayerPedId()
	TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)

	SetTimeout(timer * 1000, function()
		ClearPedTasksImmediately(playerPed)
	end)
end
